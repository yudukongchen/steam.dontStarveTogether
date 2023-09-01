
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	
	Asset( "ANIM", "anim/change.zip" ),
	Asset( "ANIM", "anim/change_winter.zip" ),
	Asset( "ANIM", "anim/change_moon.zip" ),
}
local prefabs = {}

-- 初始物品
local start_inv = {
}

local RabbitFxList = {
	cane_victorian_fx = Vector3(0,0.6,0),
	lantern_winter_fx_held = Vector3(0,0.8,0),
}

local function keepTwoDecimalPlaces(decimal)-----------------------四舍五入保留两位小数的代码
    decimal = math.floor((decimal * 100)+0.5)*0.01       
    return  decimal 
end

local function setcd(inst,cdname,time,skillname,cansay)
	if inst.sg:HasStateTag("nointerrupt") or inst.sg:HasStateTag("knockout") or inst.sg:HasStateTag("sleeping") 
	or inst.sg.currentstate == "death"
	 then 
		return false
	end 
	if GetTime() - inst[cdname] < time then 
		if inst.components.talker and cansay then 
			local last = time - (GetTime() - inst[cdname])
			last = keepTwoDecimalPlaces(last)
			inst.components.talker:Say(skillname.."技能还需要"..last.."秒才能使用")
		end
		--print(skillname.."释放失败!")
		return false
	end 
	inst[cdname] = GetTime()
	if inst["_"..cdname] ~= nil then 
		inst["_"..cdname]:set(inst[cdname])
	end
	return true
end 

local function CheckFx(inst)
	local season = TheWorld.state.season
	local moon = TheWorld.state.moonphase
	local newfx = (season == "winter" and "lantern_winter_fx_held") or "cane_victorian_fx"
	if not inst.RabbitFX then 
		inst.RabbitFX = inst:SpawnChild(newfx)
		inst.RabbitFX.Transform:SetPosition(RabbitFxList[newfx]:Get())
	elseif newfx ~= inst.RabbitFX.prefab then 
		if inst.RabbitFX:IsValid() then 
			inst.RabbitFX:Remove()
		end
		inst.RabbitFX = nil 
		inst.RabbitFX = inst:SpawnChild(newfx)
		inst.RabbitFX.Transform:SetPosition(RabbitFxList[newfx]:Get())
	end 
	
	
end 

local function OnSeasonAndMoonChange(inst)
	if inst.components.health:IsDead() or inst:HasTag("playerghost") then 
		return 
	end 
	local season = TheWorld.state.season
	local moonphase = TheWorld.state.moonphase
	
	if  moonphase == "full" then --------月圆/秋天换装
		inst.AnimState:SetBuild("change_moon")
	elseif season == "winter" then -------冬天换装
		inst.AnimState:SetBuild("change_winter")
	else
		inst.AnimState:SetBuild("change")
	end
	CheckFx(inst)
end 

local function CheckHound(inst)
	if (inst.components.health and inst.components.health:IsDead()) or inst:HasTag("playerghost") then 
		return 
	end 
	local hound = FindEntity(
        inst,
        20,
        function(guy)
            return guy:HasTag("hound") or guy:HasTag("houndwarning") or (guy.prefab and string.find(guy.prefab,"houndwarning_lvl"))
        end
    )
	if (hound and hound:IsValid()) then 
		inst.components.locomotor:SetExternalSpeedMultiplier(inst, "hound_scared_speed", 1.4)
		inst.components.sanity:DoDelta(-TUNING.DAPPERNESS_HUGE)
	else
		inst.components.locomotor:SetExternalSpeedMultiplier(inst, "hound_scared_speed", 1)
	end
end 

-- 当人物复活的时候
local function onbecamehuman(inst)
	-- 设置人物的移速（1表示1倍于wilson）
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "change_speed_mod", 1.1)
	inst:DoTaskInTime(4,OnSeasonAndMoonChange)
	--（也可以用以前的那种
	--inst.components.locomotor.walkspeed = 4
	--inst.components.locomotor.runspeed = 6）
end
--当人物死亡的时候
local function onbecameghost(inst)
	-- 变成鬼魂的时候移除速度修正
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "change_speed_mod")
end

-- 重载游戏或者生成一个玩家的时候
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end

local function ListenForEventOnce(inst, event, fn, source)
    -- Currently, inst2 is the source, but I don't want to make that assumption.
    local function gn(inst2, data)
        inst:RemoveEventCallback(event, gn, source) --as you can see, it removes the event listener even before firing the function
        return fn(inst2, data)
    end
     
    return inst:ListenForEvent(event, gn, source)
end

local function WatchWorldStateOnce(inst,var,fn)
	local function wn(inst2,...)
        inst:StopWatchingWorldState(var, wn) --as you can see, it removes the event listener even before firing the function
        return fn(inst2,...)
    end
	
	return inst:WatchWorldState(var,wn)
end 

local function DefaultFaceClient(inst,x,y,z,entity)
	if entity and not (x and y and z)  then 
		x,y,z = entity:GetPosition():Get()
	end
	inst:ForceFacePoint(x,y,z)
end 

local function StopLightFx(inst)
	if inst.ChangeLightFx and inst.ChangeLightFx:IsValid() then 
		inst.ChangeLightFx:Remove()
	end
	if inst.ChangeLightCircle and inst.ChangeLightCircle:IsValid() then 
		inst.ChangeLightCircle:FadeOut()
	end
	inst.ChangeLightFx = nil 
	inst.ChangeLightCircle = nil 
	inst.change_lightfx_ison = false 
	print(inst,"Stop Light Fx !!!")
end 

local function StartLightFx(inst)
	if not inst.change_lightfx_ison then ------没开灯的话打开灯
		local checkcd = setcd(inst,"change_lightfx_cd",5*60,"嫦娥发光",true)
		if not checkcd then 
			return 
		end
		StopLightFx(inst)
		local fx = inst:SpawnChild("changelightfx")
		local circle = inst:SpawnChild("change_light_circle")
		circle:FadeIn()
		circle.Transform:SetScale(0.8,0.8,0.8)
		inst.ChangeLightFx = fx 
		inst.ChangeLightCircle = circle
		inst.change_lightfx_ison = true 
		WatchWorldStateOnce(inst, "startday", StopLightFx)
		print(inst,"Start Light Fx !!!")
	else ----------否则关闭灯
		StopLightFx(inst)
	end 
end 

-------------在这里添加RPC比较合适
if TheNet:GetIsServer() then 
	AddModRPCHandler("change","change_lightfx",StartLightFx)
else
	AddModRPCHandler("change","change_lightfx",function() end)
end

local function ReBuildRPC()----------------可以清空过量的RPC并重新添加正确RPC
	MOD_RPC["change"] = nil   
	if TheNet:GetIsClient() then  
		AddModRPCHandler("change","change_lightfx",function() end)  
	end  
end


--这个函数将在服务器和客户端都会执行
--一般用于添加小地图标签等动画文件或者需要主客机都执行的组件（少数）
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "change.tex" )
	
	inst:AddTag("change")
	inst:RemoveTag("scarytoprey")
	
	inst:AddComponent("change_keyhandler")
	inst.components.change_keyhandler:AddActionListener(KEY_J,{Namespace = "change",Action = "change_lightfx"},nil,DefaultFaceClient)
	
	inst.ReBuildRPC = ReBuildRPC
	--TheInput:AddKeyDownHandler(KEY_F11, ReBuildRPC)
end

-- 这里的的函数只在主机执行  一般组件之类的都写在这里
local master_postinit = function(inst)
	-- 人物音效
	inst.soundsname = "willow"
	inst.change_lightfx_cd = 0 
	inst.change_lightfx_ison = false 
	
	-- 三维	
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(200)
	
	-- 伤害系数
    inst.components.combat.damagemultiplier = 1
	
	-- 饥饿速度
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
	OnSeasonAndMoonChange(inst) 
	inst:WatchWorldState("season", OnSeasonAndMoonChange)
	inst:WatchWorldState("moonphase", OnSeasonAndMoonChange)
	inst:DoPeriodicTask(1,CheckHound)
	
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetIntensity(0.8)
    inst.Light:SetColour(255 / 255, 250 / 255, 250 / 255)
    inst.Light:SetFalloff(.5)
    inst.Light:SetRadius(2)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end




return MakePlayerCharacter("change", prefabs, assets, common_postinit, master_postinit, start_inv),
Prefab("changelightfx", fxfn)
