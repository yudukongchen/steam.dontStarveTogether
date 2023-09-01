local assets =
{
	Asset("ANIM", "anim/tz_floating_music_atk.zip"),
	
	Asset("ANIM", "anim/tz_floating_music_minion.zip"),
	Asset("ANIM", "anim/tz_floating_music_atk_newfx.zip"),
	Asset("ANIM", "anim/tz_floating_music_stagelight.zip"),
	Asset("ANIM", "anim/tz_floating_music_shield.zip"),
	Asset("ANIM", "anim/tz_floating_music_reticulearc.zip"),
	Asset("ANIM", "anim/swap_tz_floating_music_weapon.zip"),
	Asset("IMAGE","images/inventoryimages/tz_floating_music_weapon.tex"),
	Asset("ATLAS","images/inventoryimages/tz_floating_music_weapon.xml"),
	
	-- Asset("IMAGE","images/inventoryimages/tz_floating_music_weapon_extra.tex"),
	-- Asset("ATLAS","images/inventoryimages/tz_floating_music_weapon_extra.xml"),
	
	
	
	Asset("ANIM", "anim/swap_tz_floating_music_weapon_extra.zip"),
	Asset("ANIM", "anim/tz_floating_music_minion_extra.zip"),
	
	Asset("SOUNDPACKAGE", "sound/tz_floating_music.fev"),
    Asset("SOUND", "sound/tz_floating_music.fsb"),
}

local prefabs =
{
    "weaponsparks",
    "sunderarmordebuff",
    "superjump_fx",
    "reticulearc",
    "reticulearcping",
}

local brain = require("brains/tz_floating_music_minion_brain")

local ItemEffectList = {
	redgem = {
		repair_percent = 0.12,
	},
	bluegem = {
		repair_percent = 0.12,
	},
	greengem = {
		repair_percent = 0.52,
	},
	orangegem = {
		repair_percent = 0.67,
	},
	purplegem = {
		repair_percent = 0.28,
	},
	yellowgem = {
		repair_percent = 0.61,
	},
	opalpreciousgem = {
		repair_percent = 1.00,
		first_fullfn = function(inst,num)
			-- inst.components.weapon.attackwear = 0
			inst.components.finiteuses:SetPercent(1)
			inst:AddTag("hide_percentage")
		end,
	},
	marble = {
		repair_percent = 0.05,
	},

}

local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    --Cast range is 8, leave room for error
    --4 is the aoe range
    for r = 7, 0, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function ListenForEventOnce(inst, event, fn, source)
    -- Currently, inst2 is the source, but I don't want to make that assumption.
    local function gn(inst2, data)
        inst:RemoveEventCallback(event, gn, source) --as you can see, it removes the event listener even before firing the function
        return fn(inst2, data)
    end
     
    return inst:ListenForEvent(event, gn, source)
end

---------------------------------------------------------------------------
local function CreateMinionLight(inst,minion)
	if minion.components.bloomer ~= nil then
        minion.components.bloomer:PushBloom(inst, "shaders/anim.ksh", -1)
    else
        minion.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end
	
	if not minion.wormlight then 
		local fx = minion:SpawnChild("tz_floating_music_wormlight_fx")
		minion.wormlight = fx
		return fx
	end 
end 

local function GetItemNum(inst,prefab)
	return inst.TradeItemList[prefab] or 0 
end 


local function SetName(inst)
	local name = STRINGS.NAMES[string.upper(inst.prefab)]
	if  inst.components.named then 
		--inst.components.named:SetName(name.."\n阶级:"..inst.ly_level.."/"..max_level)
		--[[inst.TradeItemList = {
			redgem = 0,
			bluegem = 0,
			greengem = 0,
			orangegem = 0,
			purplegem = 0,
			yellowgem = 0,
			opalpreciousgem = 0,
			marble = 0,
		}--]]
		local level = inst.StarLevel
		name = name.." "
		for i = 1,level do 
			name = name.."★"
		end 
		for k,num in pairs(inst.TradeItemList) do 
			local pst = (k == inst.FirstFullItem and "(满额特效)") or ""
			local k_name = STRINGS.NAMES[string.upper(k)]
			name = name.."\n"..k_name.." : "..num..pst
		end 
		inst.components.named:SetName(name)
	end
end 



local function ApplyItemEffect(inst)
	for prefab,current_num in pairs(inst.TradeItemList) do 
		if ItemEffectList[prefab].apply_fn then 
			ItemEffectList[prefab].apply_fn(inst,current_num)
		end 
	end
	SetName(inst)
end 

local function TryApplyFirstFullItem(inst,prefab)
	if inst.TradeItemList[prefab] >= 100 and inst.FirstFullItem == nil and not inst.HasAppliedFirstFullItem then 
		local owner = inst.components.inventoryitem.owner
		inst.FirstFullItem = prefab
		inst.HasAppliedFirstFullItem = true 
		if ItemEffectList[prefab].first_fullfn then 
			ItemEffectList[prefab].first_fullfn(inst,inst.TradeItemList[prefab])
		end
		if inst.Minion and inst.Minion:IsValid() then 
			CreateMinionLight(inst,inst.Minion)
		end
		if owner and inst.components.equippable.isequipped then 
			owner.AnimState:OverrideSymbol("swap_object", "swap_tz_floating_music_weapon_extra", "swap_tz_floating_music_weapon_extra")
		end
	end
end 


local function ShouldAcceptItem(inst,item)
	return ItemEffectList[item.prefab]
end 

local function OnGetItemFromPlayer(inst,giver,item)
	local effect_list = ItemEffectList[item.prefab]
	if effect_list then
		if inst.components.finiteuses then 
			local old_percent = inst.components.finiteuses:GetPercent()
			local new_percent = math.min(old_percent + effect_list.repair_percent,1)
			inst.components.finiteuses:SetPercent(new_percent)
		end
		inst.TradeItemList[item.prefab] = inst.TradeItemList[item.prefab] + 1
		inst:TryApplyFirstFullItem(item.prefab)
		inst:ApplyItemEffect()
	end
end 

local function OnRefuseItem(inst, giver,item)
	giver.components.talker:Say("只能给予宝石或者大理石。")
end



local function ShouldAcceptItemMinion(inst,item,giver)
	local weapon = inst.weapon
	if weapon and weapon:IsValid() then 
		return weapon.components.trader:WantsToAccept(item,giver)
	end
end 

local function OnGetItemFromPlayerMinion(inst,giver,item)
	local weapon = inst.weapon
	if weapon and weapon:IsValid() then 
		return weapon.components.trader:AcceptGift(giver,item)
	end
end 

local function OnRefuseItemMinion(inst, giver,item)
	--giver.components.talker:Say("只能给予宝石或者大理石。")
	local weapon = inst.weapon
	if weapon and weapon:IsValid() then 
		weapon.components.trader.onrefuse(weapon,giver,item)
	end
end
---------------------------------------------------------------------------


local function onequip(inst, owner) 
	--[[if inst.FirstFullItem then 
		owner.AnimState:OverrideSymbol("swap_object", "swap_tz_floating_music_weapon", "swap_tz_floating_music_weapon_light")
	else 
		owner.AnimState:OverrideSymbol("swap_object", "swap_tz_floating_music_weapon", "swap_tz_floating_music_weapon")
	end --]]
	owner.AnimState:OverrideSymbol("swap_object", "swap_tz_floating_music_weapon_extra", "swap_tz_floating_music_weapon_extra")
	if inst.Minion and inst.Minion:IsValid() then 
		inst.Minion:Remove()
	end
	inst.Minion = nil 
	
	inst.Minion = SpawnAt("tz_floating_music_minion",owner:GetPosition())
	inst.Minion.weapon = inst 
	if inst.FirstFullItem then 
		CreateMinionLight(inst,inst.Minion)
	end 
	if inst.Minion.components.follower then 
		inst.Minion.components.follower:SetLeader(owner)
	end
	inst.Minion.StarLevel = inst.StarLevel
	inst.Minion:PlayLevelAnim()
    inst.Minion:ListenForEvent("onremove",function()
		inst.Minion:Remove()
	end,inst)
end

local function onunequip(inst, owner) 
	if inst.Minion and inst.Minion:IsValid() then 
		--popbloom(inst, inst.Minion)
		inst.Minion:Remove()
	end
	inst.Minion = nil 

end

-- for i=1,100 do 
-- 	c_findnext("tz_floating_music_weapon").components.trader:AcceptGift(ThePlayer,c_spawn("opalpreciousgem")) 
-- end

local function OnAttack(inst,attacker,target)
	local is_aoe_attack = attacker.sg and attacker.sg:HasStateTag("tz_floating_music_atk_aoe")
	local first_full_item = inst.FirstFullItem 
	
	if first_full_item == "redgem" and not is_aoe_attack then 
		inst.components.equippable.walkspeedmult = 2.0
		if inst.SpeedDownTask then 
			inst.SpeedDownTask:Cancel()
			inst.SpeedDownTask = nil 
		end 
		inst.SpeedDownTask = inst:DoTaskInTime(2,function()
			inst.components.equippable.walkspeedmult = nil 
		end)
	end
	if first_full_item == "bluegem" and math.random() <= 0.25 then 
		if target.components.freezable then
			target.components.freezable:AddColdness(1,5)
		end
	end
	if first_full_item == "greengem" and not is_aoe_attack then 
		if attacker.components.health and not attacker.components.health:IsDead() and not attacker:HasTag("playerghost") then
			attacker.components.health:DoDelta(1,nil,inst.prefab)
		end
	end
	if first_full_item == "yellowgem" and not is_aoe_attack then 
		for k,v in pairs(AllPlayers) do 
			if v:IsNear(inst,12) then 
				v.components.combat.externaldamagemultipliers:SetModifier(inst,2,inst.prefab)
				if v.MusicAtkDownTask then 
					v.MusicAtkDownTask:Cancel()
					v.MusicAtkDownTask = nil 
				end 
				v.MusicAtkDownTask = v:DoTaskInTime(1,function()
					v.components.combat.externaldamagemultipliers:RemoveModifier(inst,inst.prefab)
				end)
				
				--v.components.debuffable:AddDebuff(inst.prefab, "buff_attack")
			end
		end
	end

	if first_full_item == "opalpreciousgem" and inst.components.finiteuses.current <= inst.components.finiteuses.total then 
		inst.components.finiteuses:Use(-1)
	end
	

end 

local function EnableVisibleMinion(inst,enable)
	local minion = inst.Minion
	if minion and minion:IsValid() then 
		if enable then
			local x,y,z = inst.Transform:GetWorldPosition()
			inst:RemoveChild(minion)
			minion:ReturnToScene()
			minion.Transform:SetPosition(x,y,z)
		else
			inst:AddChild(minion)
			minion:RemoveFromScene()
			minion.Transform:SetPosition(0,0,0)
		end
	end 
end 

local function TrySpawnGroundLight(inst)
	if inst.GroundFire and inst.GroundFire:IsValid() then 
		inst.GroundFire:Remove()
	end
	inst.GroundFire = nil 
	
	if inst.components.bloomer ~= nil then
        inst.components.bloomer:PopBloom(inst)
    else
        inst.AnimState:ClearBloomEffectHandle()
    end
	
	if inst.FirstFullItem and not inst.components.inventoryitem.owner then 
		inst.GroundFire = inst:SpawnChild("tz_floating_music_wormlight_fx")
		if inst.components.bloomer ~= nil then
			inst.components.bloomer:PushBloom(inst, "shaders/anim.ksh", -1)
		else
			inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		end
	end
end 

local function ApplyLevel(inst)
	inst.components.weapon:SetDamage(42 + 5 * (inst.StarLevel or 1 ))
	local owner = inst.components.inventoryitem.owner
	if inst.Minion and inst.Minion:IsValid() then 
		--变换随从动画
		
		--loop_1
		inst.Minion.StarLevel = inst.StarLevel
		inst.Minion:PlayLevelAnim()
	end
	if owner and inst.components.equippable.isequipped then 
		--改变手持动画
		--owner.AnimState:OverrideSymbol("swap_object", "swap_tz_floating_music_weapon", "swap_tz_floating_music_weapon_light")
	end
end 

local function OnTzPercentUsedChange(inst,data)
	local delta = data.new_percent - data.old_percent
	--print(inst,"OnTzPercentUsedChange",data.new_percent,data.old_percent,delta)
	if delta <= 0 and inst.StarLevel < 9 then 
		inst.ComsumedFiniteuses = inst.ComsumedFiniteuses + math.abs(delta)
	end
	
	while inst.ComsumedFiniteuses >= 1 and inst.StarLevel < 9 do 
		inst.StarLevel = inst.StarLevel + 1 
		inst.ComsumedFiniteuses = inst.ComsumedFiniteuses - 1
	end
	
	ApplyLevel(inst)
	SetName(inst)
end 

local function OnSpell(inst)
	-- 45 or 25 
	inst.components.rechargeable:Discharge(inst.FirstFullItem == "opalpreciousgem" and 25 or 45)
	if inst.components.finiteuses and inst.FirstFullItem ~= "opalpreciousgem" then 
		local old_percent = inst.components.finiteuses:GetPercent()
		inst.components.finiteuses:SetPercent(old_percent - 0.05)
	end

	return true
end 

local function OnSave(inst,data)
	data.ComsumedFiniteuses = inst.ComsumedFiniteuses
	data.StarLevel = inst.StarLevel
	data.TradeItemList = {}
	data.FirstFullItem = inst.FirstFullItem
	for k,v in pairs(inst.TradeItemList) do 
		data.TradeItemList[k] = v 
	end
end 

local function OnLoad(inst,data)
	if data and data.ComsumedFiniteuses then 
		inst.ComsumedFiniteuses = data.ComsumedFiniteuses
	end 
	
	if data and data.StarLevel then 
		inst.StarLevel = data.StarLevel
	end 
	
	--ApplyLevel(inst)
	inst:DoTaskInTime(0,ApplyLevel)
	 
	if data and data.TradeItemList then 
		for k,v in pairs(data.TradeItemList) do 
			inst.TradeItemList[k] = v 
		end
	end
	if data and data.FirstFullItem then 
		inst:TryApplyFirstFullItem(data.FirstFullItem)
	end 
	
	inst:ApplyItemEffect()
	--print(inst,"ItemList:")
	--for k,v in pairs(inst.TradeItemList) do 
	--	print(k,v)
	--end
end 

--[[local function IsAllyAndNotIsLostday(inst,target)
	return inst.components.combat:IsAlly(target) and not target:HasTag("tzlostday")
end --]]

--逻辑：单体攻击能打到自己的黯影随从
--单体攻击能打到友军
--单体攻击能打普通敌人

--群体攻击不能打到自己的黯影随从
--群体攻击不能打到友军
local function CanAttack(inst,target,isaoe)
	local isally = inst.components.combat:IsAlly(target)
	local is_shadow_pet = target:HasTag("tzlostday") or target:HasTag("tzxiaoyingguai")
	local is_my_shadow_pet = isally and is_shadow_pet
	if not isaoe then 
		return true
	else
		return not is_shadow_pet and not isally
	end
end 


local function weaponfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
	
	inst.Transform:SetScale(1.5,1.5,1.5)
	
	
	inst:AddTag("rechargeable")
	inst:AddTag("tz_floating_music_weapon")
	
	inst.AnimState:SetBank("tz_floating_music_minion_extra")
	inst.AnimState:SetBuild("tz_floating_music_minion_extra")
	inst.AnimState:PlayAnimation("idle")
	
	
	inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetAlwaysValid(true)
	inst.components.aoetargeting.reticule.reticuleprefab = "tz_reticule_empty"
	inst.components.aoetargeting.reticule.pingprefab = "tz_reticule_emptyping"
    inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true

    

	inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.Minion = nil 
	inst.EnableVisibleMinion = EnableVisibleMinion
	inst.ApplyItemEffect = ApplyItemEffect
	inst.GetItemNum = GetItemNum 
	inst.TryApplyFirstFullItem = TryApplyFirstFullItem
	inst.FirstFullItem = nil 
	inst.HasAppliedFirstFullItem = false 
	inst.ComsumedFiniteuses = 0
	inst.StarLevel = 0 
	inst.TradeItemList = {
		redgem = 0,
		bluegem = 0,
		greengem = 0,
		orangegem = 0,
		purplegem = 0,
		yellowgem = 0,
		opalpreciousgem = 0,
		marble = 0,
	}
	
	inst:AddComponent("named")
	
	inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetRange(12,12)
	inst.components.weapon:SetDamage(42 + inst.StarLevel * 5)
	inst.components.weapon:SetOnAttack(OnAttack)	
	
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(800)
    inst.components.finiteuses:SetUses(800)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	local old_SetUses = inst.components.finiteuses.SetUses
	inst.components.finiteuses.SetUses = function(self,...)
		local old = self:GetPercent()
		local ret = old_SetUses(self,...)
		local new = self:GetPercent()
		
		self.inst:PushEvent("tz_percentusedchange", {old_percent = old,new_percent = new})
		
		return ret 
	end 

	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "tz_floating_music_weapon"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_floating_music_weapon.xml"
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddComponent("tz_aoespell")
    inst.components.aoespell = inst.components.tz_aoespell
	inst.components.aoespell.canuseonpoint = true
	inst.components.aoespell:SetSpellFn(OnSpell)
	inst:RegisterComponentActions("aoespell")
	
	inst:AddComponent("rechargeable")
	inst.components.rechargeable:SetOnDischargedFn(function()
		if inst.components.aoetargeting then
			inst.components.aoetargeting:SetEnabled(false)
		end
	end)
	inst.components.rechargeable:SetOnChargedFn(function()
		if inst.components.aoetargeting then
			inst.components.aoetargeting:SetEnabled(true)
		end
	end)
	
	inst:AddComponent("bloomer")
	
	
	inst:DoTaskInTime(0,SetName)
	inst:DoTaskInTime(0,TrySpawnGroundLight)
	
	inst:ListenForEvent("ondropped",TrySpawnGroundLight)
	inst:ListenForEvent("onputininventory",TrySpawnGroundLight)
	inst:ListenForEvent("onpickup",TrySpawnGroundLight)
	inst:ListenForEvent("tz_percentusedchange",OnTzPercentUsedChange)
	
	
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	return inst
end

local function minionfn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	
	inst.DynamicShadow:SetSize(1.5, 1)

	MakeGhostPhysics(inst, .5, .5)
	RemovePhysicsColliders(inst)

	--inst.Transform:SetEightFaced()
	--inst.Transform:SetScale(2,2,2)
	
	inst:AddTag("tz_floating_music_minion")
	
	inst.AnimState:SetBank("tz_floating_music_minion_extra")
	inst.AnimState:SetBuild("tz_floating_music_minion_extra")
	inst.AnimState:PlayAnimation("loop_1",true)
	--inst.Transform:SetScale(0.75,0.75,0.75)
	
	
	inst.entity:SetPristine()
	

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false 
	inst.StarLevel = 0
	inst.PlayLevelAnim = function(self,push)
		local level = self.StarLevel
		local anim = "loop_1"
		if level >= 3 and level < 5 then 
			anim = "loop_2"
		elseif level >= 5 then
			anim = "loop_3"
		else
			anim = "loop_1"
		end
		if push then 
			self.AnimState:PushAnimation(anim,true)
		else
			self.AnimState:PlayAnimation(anim,true)
		end
		
	end 

	inst:AddComponent("inspectable")
	inst:AddComponent("locomotor")
	inst:AddComponent("follower")
	inst:AddComponent("bloomer")
	
	inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItemMinion)
    inst.components.trader.onaccept = OnGetItemFromPlayerMinion
    inst.components.trader.onrefuse = OnRefuseItemMinion
	
	
	inst:SetBrain(brain)
	inst:SetStateGraph("SGtz_floating_music_minion")
	
	inst:PlayLevelAnim()
	
	return inst
end
--------------------------------------------------------------

local function lightfx_commonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.Light:SetRadius(2)
    inst.Light:SetIntensity(.8)
    inst.Light:SetFalloff(.5)
    inst.Light:SetColour(169/255, 231/255, 245/255)
    inst.Light:Enable(true)
    inst.Light:EnableClientModulation(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then

        return inst
    end

    inst.persists = false

    return inst
end


--------------------------------------------------------------

local function CreateFx(prefabname,bank,build,anim,loop,forever,extrafn)
	local function fxfn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter() 
		inst.entity:AddNetwork()

		
		inst.AnimState:SetBank(bank)
		inst.AnimState:SetBuild(build)
		
		if anim then 
			inst.AnimState:PlayAnimation(anim,loop)
		end 
		
		inst.entity:SetPristine()
		if not TheWorld.ismastersim then
			return inst
		end
		
		if forever then 
			
		else
			inst.persists = false 
			inst:ListenForEvent("animover",inst.Remove)
		end 
		
		if extrafn then 
			extrafn(inst)
		end 
		
		return inst
	end 
	
	return Prefab(prefabname, fxfn, assets,prefabs)
end 

STRINGS.NAMES.TZ_FLOATING_MUSIC_WEAPON = "亚龙美少女琵琶"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_FLOATING_MUSIC_WEAPON = "灵韵之音中寄宿着一位少女"
STRINGS.RECIPE_DESC.TZ_FLOATING_MUSIC_WEAPON = "龙族灵器弹奏古风电音"
STRINGS.ACTIONS.CASTAOE.TZ_FLOATING_MUSIC_WEAPON = "音符地狱"

STRINGS.NAMES.TZ_FLOATING_MUSIC_MINION = "亚龙美少女琵琶"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_FLOATING_MUSIC_MINION = "来一首，就现在！"

return 
	Prefab("tz_floating_music_weapon", weaponfn, assets,prefabs),
	Prefab("tz_floating_music_minion", minionfn, assets,prefabs),
	Prefab("tz_floating_music_wormlight_fx", lightfx_commonfn),
	
	
	CreateFx("tz_floating_music_reticulearc","tz_floating_music_reticulearc","tz_floating_music_reticulearc","idle",true,true,function(inst)
		inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
		inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
		inst.AnimState:SetSortOrder(3)
		
		local function UpdatePing(inst, s0, s1, t0, duration, multcolour, addcolour)
			if next(multcolour) == nil then
				multcolour[1], multcolour[2], multcolour[3], multcolour[4] = inst.AnimState:GetMultColour()
			end
			if next(addcolour) == nil then
				addcolour[1], addcolour[2], addcolour[3], addcolour[4] = inst.AnimState:GetAddColour()
			end
			local t = GetTime() - t0
			local k = 1 - math.max(0, t - 0.1) / duration
			k = 1 - k * k
			local s = Lerp(s0, s1, k)
			local c = Lerp(1, 0, k)
			inst.Transform:SetScale(s, s, s)
			inst.AnimState:SetMultColour(c * multcolour[1], c * multcolour[2], c * multcolour[3], c * multcolour[4])

			k = math.min(0.3, t) / 0.3
			c = math.max(0, 1 - k * k)
			inst.AnimState:SetAddColour(c * addcolour[1], c * addcolour[2], c * addcolour[3], c * addcolour[4])
		end
		
		local function FadeOut(inst,duration,startscale,adds)
			if inst.fadetask then 
				inst.fadetask:Cancel()
				inst.fadetask = nil 
			end
			duration = duration or 0.5 
			startscale = startscale or 1
			adds = adds or 0.15 
			
			inst.fadetask = inst:DoPeriodicTask(0, UpdatePing, nil, startscale, startscale + adds, GetTime(),duration, {}, {})
			inst:DoTaskInTime(duration,inst.Remove) 
		end 
		
		inst.KillFX = function(self)
			FadeOut(inst)
		end
	end),
	CreateFx("tz_floating_music_fx_hand","tz_floating_music_minion","tz_floating_music_minion",nil,false,false,function(inst)
		inst.AnimState:SetFinalOffset(1)
		inst.AnimState:PlayAnimation(math.random() <= 0.5 and "shouchitexiao_0" or "shouchitexiao_1")
	end),
	CreateFx("tz_floating_music_fx_move","tz_floating_music_minion","tz_floating_music_minion","move_0",true,true,function(inst)
		inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
		inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
		inst.AnimState:SetSortOrder(3)
		inst.KillFX = function(self)
			self:ListenForEvent("animover",inst.Remove)
		end 
	end),
	CreateFx("tz_floating_music_fx_atk","tz_floating_music_minion","tz_floating_music_minion",nil,false,false,function(inst) 
		local pst = {"0","01","1","11"}
		inst.AnimState:SetFinalOffset(1)
		inst.AnimState:PlayAnimation("attacktexiao_"..pst[math.random(1,#pst)])
	end),
--[[	CreateFx("tz_floating_music_fx_pulse","tz_floating_music_minion","tz_floating_music_minion","shenshang",true,true,function(inst)
		inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
		inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
		inst.AnimState:SetSortOrder(3)
		
		inst.Transform:SetScale(2,2,2)
		inst.KillFX = function(self)
			self:ListenForEvent("animover",inst.Remove)
		end 
	end),--]]
	CreateFx("tz_floating_music_fallatk","tz_floating_music_atk_newfx","tz_floating_music_atk_newfx",nil,nil,nil,function(inst)
		inst.AnimState:PlayAnimation(math.random() <= 0.5 and "one" or "two")
		inst.AnimState:SetFinalOffset(1)
		inst.AnimState:SetMultColour(1,1,1,0.5)
		inst.Transform:SetScale(2,2,2)
		inst.SetOwner = function(self,owner)
			self.owner = owner 
		end 
		
		inst.DoSleepAttack = function(self,target)
			local weapon = self.owner.components.combat:GetWeapon()
			
			if weapon and weapon:IsValid() then 
				-- local old_wear = weapon.components.weapon.attackwear
				-- weapon.components.weapon.attackwear = 0
				self.owner.components.combat.ignorehitrange = true 
				self.owner.components.combat:DoAttack(target)
				self.owner.components.combat.ignorehitrange = false 
				-- weapon.components.weapon.attackwear = old_wear
			end 
			target:DoTaskInTime(1.5,function()
				local time = 15
				if not (target.components.freezable ~= nil and target.components.freezable:IsFrozen()) and
					not (target.components.pinnable ~= nil and target.components.pinnable:IsStuck()) and
					not (target.components.fossilizable ~= nil and target.components.fossilizable:IsFossilized()) then
					local mount = target.components.rider ~= nil and target.components.rider:GetMount() or nil
					if mount ~= nil then
						mount:PushEvent("ridersleep", { sleepiness = 7, sleeptime = time + math.random() })
					end
					if target:HasTag("player") then
						target:PushEvent("yawn", { grogginess = 4, knockoutduration = time + math.random() })
					elseif target.components.sleeper ~= nil then
						target.components.sleeper:AddSleepiness(7, time + math.random())
					elseif target.components.grogginess ~= nil then
						target.components.grogginess:AddGrogginess(4, time + math.random())
					else
						target:PushEvent("knockedout")
					end
					
					target.components.combat.externaldamagetakenmultipliers:SetModifier(self.owner,3,"tz_floating_music_weapon")
					ListenForEventOnce(target, "attacked", function()
						target.components.combat.externaldamagetakenmultipliers:RemoveModifier(self.owner,"tz_floating_music_weapon")
					end)
				end
			end)
		end
		
		inst.DoAttack = function(self,rad,damage_override,sleep)
			if self.owner and self.owner:IsValid() and self.owner.components.combat then 
				rad = rad or 0.33
				local x,y,z = self.Transform:GetWorldPosition()
				local targets = TheSim:FindEntities(x,y,z,rad,{"_combat"},{"wall"})
				for k,v in pairs(targets) do 
					if self.owner.components.combat:CanTarget(v) and CanAttack(self.owner,v,rad > 0.33) then 
						--damage_override
						if sleep then 
							inst:DoSleepAttack(v)
						else
							--[[local weapon = self.owner.components.combat:GetWeapon()
							local damage = damage_override or weapon.components.weapon.damage
							v.components.combat:GetAttacked(self.owner,damage)--]]
							
							local weapon = self.owner.components.combat:GetWeapon()
							--去他娘的兼容性
							if weapon and weapon:IsValid() then  
								local pre_damage = weapon.components.weapon.damage
								if damage_override then 
									weapon.components.weapon:SetDamage(damage_override)
								end 
								-- local old_wear = weapon.components.weapon.attackwear
								-- weapon.components.weapon.attackwear = 0
								self.owner.components.combat.ignorehitrange = true 
								self.owner.components.combat:DoAttack(v)
								self.owner.components.combat.ignorehitrange = false 
								-- weapon.components.weapon.attackwear = old_wear
								
								weapon.components.weapon:SetDamage(pre_damage)
								--SpawnAt("tz_floating_music_fx_atk",v:GetPosition())
								--SpawnAt("tz_floating_music_pulseatk_white",v:GetPosition())
								ApplyLevel(weapon)
							end 
							
							
						end 
					end
				end
			end
		end 
		
		
	end),
	CreateFx("tz_floating_music_pulseatk_black","tz_floating_music_minion","tz_floating_music_minion","shenshang",false,false,function(inst)
		--[[inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
		inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
		inst.AnimState:SetSortOrder(3)--]]
		inst.Transform:SetScale(4,4,4)
		--inst.AnimState:SetFinalOffset(-1)
		--[[inst.KillFX = function(self)
			self:ListenForEvent("animover",inst.Remove)
		end --]]
	end),
	CreateFx("tz_floating_music_pulseatk_black_ground","tz_floating_music_minion","tz_floating_music_minion","shenshang",false,false,function(inst)
		inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
		inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
		inst.AnimState:SetSortOrder(3)
		inst.Transform:SetScale(3,3,3)
		inst.AnimState:SetFinalOffset(-1)
		--inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp")
		inst.SoundEmitter:PlaySound("tz_floating_music/bgm/yinfu_"..math.random(1,4)) 
		--[[inst.KillFX = function(self)
			self:ListenForEvent("animover",inst.Remove)
		end --]]
	end),
	CreateFx("tz_floating_music_pulseatk_white","tz_floating_music_atk_newfx","tz_floating_music_atk_newfx","tanzou",false,false,function(inst)
		--[[inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
		inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
		inst.AnimState:SetSortOrder(3)--]]
		--inst.Transform:SetScale(2,2,2)
		inst.AnimState:SetFinalOffset(1)
		--inst.Transform:SetScale(2,2,2)
		--[[inst.KillFX = function(self)
			self:ListenForEvent("animover",inst.Remove)
		end --]]
	end),
	
	CreateFx("tz_floating_music_stagelight","tz_floating_music_stagelight","tz_floating_music_stagelight",nil,true,true,function(inst)
		inst.AnimState:PlayAnimation("chuxian")
		inst.AnimState:PushAnimation("baochi",true)
		inst.AnimState:SetLightOverride(1)
		inst.KillFX = function(self)
			self.AnimState:PlayAnimation("jieshu")
			self:ListenForEvent("animover",inst.Remove)
		end 
	end),
	
	CreateFx("tz_floating_music_shield_0","tz_floating_music_shield","tz_floating_music_shield",nil,true,true,function(inst)
		--inst:AddTag("NOCLICK")
		inst:AddTag("NOTARGET")
		
		
		
		
		inst.AnimState:PlayAnimation("open_000")
		inst.AnimState:PushAnimation("loop_000",true)
		inst.AnimState:SetFinalOffset(1)
		
		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(200)
		
		inst:AddComponent("combat")
		
		
		inst.KillFX = function(self)
			self.AnimState:PlayAnimation("end")
			self:ListenForEvent("animover",inst.Remove)
		end 
		
		inst:ListenForEvent("death",inst.KillFX)
	end),
	
	CreateFx("tz_floating_music_shield_1","tz_floating_music_shield","tz_floating_music_shield",nil,true,true,function(inst)
		inst.AnimState:PlayAnimation("open_001")
		inst.AnimState:PushAnimation("loop",true)
		
		inst.KillFX = function(self)
			self.AnimState:PlayAnimation("end_000")
			self:ListenForEvent("animover",inst.Remove)
		end 
	end)
	
	--[[CreateFx("tz_floating_music_shield_all","tz_floating_music_shield","tz_floating_music_shield",nil,true,true,function(inst)
		inst:AddTag("NOCLICK")
		inst:AddTag("NOTARGET")
	
		inst.fx0 = inst:SpawnChild("tz_floating_music_shield_0")
		inst.fx1 = inst:SpawnChild("tz_floating_music_shield_1")
		
		inst.persists = false 
		
		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(200)
		
		inst:AddComponent("combat")
		
		inst.KillFX = function(self)
			if self.fx0 and self.fx0:IsValid() then 
				self.fx0:KillFX()
			end 
			if self.fx1 and self.fx1:IsValid() then 
				self.fx1:KillFX()
			end 
			self:DoTaskInTime(0.36,self.Remove)
		end 
		
		
		inst:ListenForEvent("death",inst.KillFX)
	end)--]]
	
	
	

