local TzUtil = require("tz_util")
local TzFh = require("util/tz_fh")

local assets =
{
    Asset("ANIM", "anim/tz_yexingzhe_purple.zip"), 
    Asset("ANIM", "anim/yexingzhe_hudunfx_purple.zip"),
    Asset("ANIM", "anim/tz_yueshicos.zip"),
    Asset("ANIM", "anim/meteor_purple.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tz_yexingzhe_purple.tex"),
	Asset("ATLAS", "images/inventoryimages/tz_yexingzhe_purple.xml"),
}

local ringassets =
{
    Asset("ANIM", "anim/tz_yueshiring.zip"),
}

local upassets=
{
    Asset("ANIM", "anim/attune_fx.zip"),
}

local aa = {
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","M","N","M","N","M","N","M","N","M","N","M","N","M","N","M","N","M","L","K","J","I","H","G","F","E","D","C","B","A"
}

--10+43*0.1 = 13.44

local prefabs =
{
	"yexingzhe_victorian_fx",
	"tz_yexingzhe_light",
}

local MAX_LIGHT_ON_FRAME = 15
local MAX_LIGHT_OFF_FRAME = 30

local function fly_equipped(inst,data)
	if inst.hudunfx == nil then
		inst.hudunfx = SpawnPrefab("tz_yexiang_hudunfx_purple")
		inst.hudunfx.entity:SetParent((data.owner or inst).entity)
	end
end

local function fly_unequipped(inst)
	if inst.hudunfx ~= nil then
		inst.hudunfx:Kill()
		inst.hudunfx = nil
	end
end

local function IsWeaponEquipped(inst, weapon)
    return weapon ~= nil
        and weapon.components.equippable ~= nil
        and weapon.components.equippable:IsEquipped()
        and weapon.components.inventoryitem ~= nil
        and weapon.components.inventoryitem:IsHeldBy(inst)
end

local function OnKilled(owner, data)
	local victim = data.victim
	if victim and  math.random() < 0.33 then
		if victim.components.lootdropper then
			victim.components.lootdropper:SpawnLootPrefab("nightmarefuel")
		end
	end 
end

local function onnewsleeptick(inst,owner)
	if IsWeaponEquipped(owner, inst) then
		owner.AnimState:OverrideSymbol("swap_object", "tz_yueshicos", "tz_"..aa[inst.num])
		inst.num = inst.num + 1 
		if inst.num > #aa then
			if inst.newnumatask ~= nil then
				inst.newnumatask:Cancel()
				inst.newnumatask = nil
			end
			owner.AnimState:OverrideSymbol("swap_object", "tz_yexingzhe_purple", "wuqi")
		end
	end
end

local function onsleeptick(inst,owner)
	inst.num = 1
	if inst.newnumatask ~= nil then
		inst.newnumatask:Cancel()
	end
	inst.newnumatask = inst:DoPeriodicTask(0.08, onnewsleeptick,FRAMES,owner)
end


local function lightkai(inst)
    if inst.components.equippable:IsEquipped() and  inst.components.inventoryitem.owner ~= nil then
        if inst._light == nil then
            inst._light = SpawnPrefab("tz_yexingzhe_light")
			inst._light:Turnoon()
        end
        inst._light.entity:SetParent((inst._body or inst.components.inventoryitem.owner or inst).entity)
	end
end
local function lightguan(inst)
    if inst.components.equippable:IsEquipped() and  inst.components.inventoryitem.owner ~= nil then
		if inst._light ~= nil then
			inst._light:Turnoff()
			inst._light = nil
        end
	end
end

local function onequip(inst, owner)
    if owner.prefab == "taizhen" then
		owner.AnimState:OverrideSymbol("swap_object", "tz_yexingzhe_purple", "wuqi")
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
		owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
		if inst.components.fueled ~= nil then
			inst.components.fueled:StartConsuming()
		end
		if  TheWorld.state.phase == "night"then
			if inst._light == nil then
				inst._light = SpawnPrefab("tz_yexingzhe_light")
				inst._light:Turnoon()
			end
			inst._light.entity:SetParent((inst._body or inst.components.inventoryitem.owner or inst).entity)
		end
		if inst._wheel ~= nil then
			inst._wheel:Remove()
		end
		inst._wheel = SpawnPrefab("tzyexing_wheel_purple")
		inst._wheel.entity:AddFollower()
		inst._wheel.Follower:FollowSymbol(owner.GUID, "swap_object", 22, -260, 0)  ---环的坐标

		if inst._smoke == nil then    
			inst._smoke = SpawnPrefab("yexingzhe_victorian_fx")
			inst._smoke.entity:AddFollower()
			inst._smoke.Follower:FollowSymbol(owner.GUID, "swap_object", 22, -260, 0) --星星的坐标
		end 
		inst:ListenForEvent("killed", OnKilled, owner)
		
		if inst.numatask ~= nil then
			inst.numatask:Cancel()
		end
		inst.numatask = inst:DoPeriodicTask(13.5, onsleeptick,FRAMES,owner)
		if owner.components.tz_xx and owner.components.tz_xx.dengji > 7 then
			if owner.components.combat then
				owner.components.combat.externaldamagemultipliers:SetModifier("tzxx_level7", 1.25)
			end
			--inst.components.samaequip.equipsama = 12--3				
		end
		if owner.components.combat and inst.components.tz_fh_level.level ~= 0 then
            owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1+inst.components.tz_fh_level.level*0.01)
        end
	else
		if TUNING.TZ_FANHAO_SPECIFIC then 
			TzUtil.OnInvalidOwner(inst,owner,0,STRINGS.NOYEXINGZHE,true)
		end 
    end	
end

local function onunequip(inst, owner)
	if inst._wheel ~= nil then
        inst._wheel:Remove()
        inst._wheel = nil
    end
	
	inst:RemoveEventCallback("killed", OnKilled, owner)

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	if inst._smoke ~= nil then
        inst._smoke:Remove()
        inst._smoke = nil
    end
	if inst._light ~= nil then
		inst._light:Turnoff()
		inst._light = nil
    end
	
	if inst.numatask ~= nil then
		inst.numatask:Cancel()
		inst.numatask = nil
	end
	if inst.newnumatask ~= nil then
		inst.newnumatask:Cancel()
		inst.newnumatask = nil
	end	
	if owner.components.tz_xx then
		if owner.components.combat then
			owner.components.combat.externaldamagemultipliers:RemoveModifier("tzxx_level7")
		end
		--inst.components.samaequip.equipsama = 6			
	end
    if owner and owner.components.combat then
		owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
    end
end

local function updatedamage(inst, phase)
    if phase == "night" then
        inst.components.weapon:SetDamage(72)
		lightkai(inst)
    else
        inst.components.weapon:SetDamage(46)
		lightguan(inst)
    end
end
local function levelfn(inst)
    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
        local owner = inst.components.inventoryitem.owner
        if owner.components.combat and inst.components.tz_fh_level.level ~= 0 then
            owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1+inst.components.tz_fh_level.level*0.01)
        end
    end
end

local function onfinished(inst)
	local spiritualism = SpawnPrefab("tz_spiritualism")
	if spiritualism then
		local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
		local pt = Vector3(inst.Transform:GetWorldPosition())
		local holder = owner and ( owner.components.inventory or owner.components.container) 
		local slot = holder and holder:GetItemSlot(inst)		
		inst:Remove()
        if holder then
			holder:Equip(spiritualism, slot)
        else
			spiritualism.Transform:SetPosition(pt:Get())
		end
	end
end

local function ontakefuel(inst)
	inst.components.fueled:DoDelta(384)
    local owner = inst.components.inventoryitem.owner
	if owner then
		local pos = Vector3(owner.Transform:GetWorldPosition()) 
		inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
		SpawnPrefab("tz_takefuel").Transform:SetPosition(pos.x-0.1,pos.y-2.6,pos.z)
	end
end

local function onattack(inst, attacker, target)
	if target  and target:IsValid() and  inst.components.tz_yexinglvl.current == 100 then
        if not target.yezhao then 
			target.yezhao =1
		else 
			if target.yezhao == 14 then
				target.yezhao =0 
				local delay = 0.0
				local pos = Vector3(target.Transform:GetWorldPosition())
				for i = 1, 4, 1 do
				inst:DoTaskInTime(delay, function(inst)
					local shadowmeteor = SpawnPrefab("yezhao_meteor_2")
					shadowmeteor.Transform:SetPosition(pos.x, pos.y, pos.z)
				end)
				delay = delay + 0.55
				end
			else 
				target.yezhao = target.yezhao +1
			end			
		end
	end
end

local function onload(inst)
	if inst.components.timer:TimerExists("tzblinkcd") then
		inst:RemoveTag("tzblinkcd")
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_yexingzhe_purple")
    inst.AnimState:SetBuild("tz_yexingzhe_purple")
    inst.AnimState:PlayAnimation("idle")
	inst.MiniMapEntity:SetIcon("tz_yexingzhe_purple.tex")
    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("yexing")
	inst:AddTag("tz_fanhao")
    inst:AddTag("rangedweapon")

    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
	
    local old_GetDisplayName = inst.GetDisplayName
    inst.GetDisplayName = function(self,...)
        if inst.tz_fh_level ~= nil and inst.tz_fh_level:value() ~= 0 then
            local level = inst.tz_fh_level:value()
            return (old_GetDisplayName(self, ...) or "") 
                .." +" .. level
                .."\n伤害 +"..level.."%"
                ..string.format("\n最终减伤+ %.2f",level*100/(level+100)).."%"
        else
            return old_GetDisplayName(self, ...)
        end
    end
    inst.tz_fh_level = net_ushortint(inst.GUID, "tzfanhaolevel_yexingzhe_purple")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "tz_yexingzhe_purple"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_yexingzhe_purple.xml"
	
	inst:AddComponent("samaequip")
	inst.components.samaequip.equipsama = 6	
	
    inst:AddComponent("tz_yexinglvl")
	inst.components.tz_yexinglvl.current = 100
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetRange(12)
    inst.components.weapon:SetProjectile("tz_projectile_purple")
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon.heightoffset =1.2
    inst.components.weapon:SetDamage(46)

    inst:AddComponent("inspectable")
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.walkspeedmult = 1.25
	inst.components.equippable.dapperness = -3/60
	
	inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(3840)
    inst.components.fueled:SetDepletedFn(onfinished)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true
	
    MakeHauntableLaunch(inst)
	
    inst:WatchWorldState("phase", updatedamage)
    updatedamage(inst, TheWorld.state.phase)
	
    inst:ListenForEvent("equipped", fly_equipped)
    inst:ListenForEvent("unequipped", fly_unequipped)

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", function() inst:AddTag("tzblinkcd") end) 
	

    inst:AddComponent("tz_fh_level")
    inst.components.tz_fh_level.levelupfn = levelfn

	onload(inst)
	inst:ListenForEvent("onremove", function()
		fly_unequipped(inst)
	end	)
    return inst
end

local function light()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst:AddTag("FX")
    inst.AnimState:SetBank("tz_yueshiring")
    inst.AnimState:SetBuild("tz_yueshiring")
	inst.AnimState:PlayAnimation("ring_loop",true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    return inst
end

local function kill(inst)
	inst.AnimState:PlayAnimation("ok_pst")
	inst:ListenForEvent("animover", inst.Remove)
end

local function hufn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    inst:AddTag("FX")

    inst.AnimState:SetBank("yexingzhe_hudunfx_purple")
    inst.AnimState:SetBuild("yexingzhe_hudunfx_purple")
    inst.AnimState:PlayAnimation("ok_pre")
    inst.AnimState:PushAnimation("ok_loop")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
		return inst
    end
	
    inst.persists = false
	inst.Kill = kill
	
    return inst
end

local function daji(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 1, {"_health", "_combat"}, {"INLIMBO", "wall","playerghost" ,"player", "companion"})
        for i, v in ipairs(ents) do
            if  v and v:IsValid() and not v:IsInLimbo() then
				if v.components.combat ~= nil then
					v.components.combat:GetAttacked(inst, 50, inst)
				end
            end
        end
	SpawnPrefab("yezhao_meteorring_2").Transform:SetPosition(inst.Transform:GetWorldPosition())
end
local function meteor()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst:AddTag("FX")

    inst.AnimState:SetBank("meteor")
	inst.AnimState:SetBuild("meteor")
	inst.AnimState:AddOverrideBuild("meteor_purple")
    inst.AnimState:PlayAnimation("crash")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetScale(0.7, 0.7, 0.7)
    inst.AnimState:SetFinalOffset(1)

    inst.SoundEmitter:PlaySound("dontstarve/common/meteor_impact")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		return inst
    end
    inst.Transform:SetRotation(math.random(360))
	
    inst.persists = false
	
	inst:DoTaskInTime(0.33, daji)
	
    inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end
local function bo(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 6, {"_health", "_combat"}, {"INLIMBO", "wall","playerghost" ,"player", "companion"})
        for i, v in ipairs(ents) do
            if  v and v:IsValid() and not v:IsInLimbo() then
				if v.components.combat ~= nil then
					v.components.combat:GetAttacked(inst, 35, inst)
				end
            end
        end
	inst:Remove()
end

local function PlayRingAnim(proxy)
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.Transform:SetFromProxy(proxy.GUID)
    
    inst.AnimState:SetBank("bearger_ring_fx")
    inst.AnimState:SetBuild("bearger_ring_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(1)
	inst.Transform:SetScale(0.7, 0.7, 0.7)
	inst.AnimState:SetMultColour(1,1,1,1)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:ListenForEvent("animover", bo)
end

local function ringfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, PlayRingAnim)
    end
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    inst:DoTaskInTime(3, inst.Remove)
    return inst
end

--c_spawn"yezhao_meteor_2"
--c_spawn"yezhao_meteor"
--c_spawn"yezhao_meteorring_2"

return Prefab("tz_yexingzhe_purple", fn, assets),
		Prefab("tzyexing_wheel_purple", light,ringassets),
		Prefab("yezhao_meteor_2", meteor),
		Prefab("yezhao_meteorring_2",ringfn),
		Prefab("tz_yexiang_hudunfx_purple", hufn)