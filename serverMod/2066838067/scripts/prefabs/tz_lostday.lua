local prefabs = {"shadow_despawn", "statue_transition_2", "nightmarefuel", "tz_shadowunbrella"}
local fxassets = {Asset("ANIM", "anim/tz_shadowunbrella.zip")}
local brain = require "brains/lostdaybrain"
local MAX_LIGHT_ON_FRAME = 15
local MAX_LIGHT_OFF_FRAME = 30
local function DoEffects(pet)
    local x, y, z = pet.Transform:GetWorldPosition()
    SpawnPrefab("shadow_despawn").Transform:SetPosition(x, y, z)
    SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
end
local function OnDeath(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
    if inst.components.inventory ~= nil then
        inst.components.inventory:DropEverything()
    end
end
local function KillPet(pet)
    DoEffects(pet)
    if pet.components.lootdropper == nil then
        pet:AddComponent("lootdropper")
    end
	for k = 1, 5 do
    	pet.components.lootdropper:SpawnLootPrefab("nightmarefuel", pet:GetPosition())
	end
    OnDeath(pet)
    pet:Remove()
end

local function OnAttacked(inst, data)
    if data.attacker ~= nil then
        if data.attacker.components.petleashlostday ~= nil and data.attacker.components.petleashlostday:IsPet(inst) then
            if inst.components.lootdropper == nil then
                inst:AddComponent("lootdropper")
            end
            OnDeath(inst)
			for k = 1, string.find(inst.prefab,"gai") and 7 or 3 do
            	inst.components.lootdropper:SpawnLootPrefab("nightmarefuel", inst:GetPosition())
			end
            data.attacker.components.petleashlostday:DespawnPet(inst)

        elseif data.attacker.components.combat ~= nil then
            inst.components.combat:SuggestTarget(data.attacker)
        end
    end
end

local banequips = {
	lostearth = EQUIPSLOTS.HANDS,
	lostearth_gai = EQUIPSLOTS.HANDS,
	lostumbrella = EQUIPSLOTS.HANDS,
	lostumbrella_gai = EQUIPSLOTS.HANDS,
	lostchester = EQUIPSLOTS.BODY,
	lostchester_gai = EQUIPSLOTS.BODY,
	lostfight = EQUIPSLOTS.HANDS,
	lostfight_gai = EQUIPSLOTS.HANDS,
}
local function ShouldAcceptItem(inst, item)
    if item.prefab == "reviver" then
        return true
	elseif item.components.equippable ~= nil and item.components.equippable.equipslot ~= banequips[inst.prefab] and 
		not item.components.equippable:IsRestricted(inst) and not item:HasTag("tz_fanhao") then
		return true
    end
end
local function OnGetItemFromPlayer(inst, giver, item)
    if item.prefab == "reviver" then
        KillPet(inst)
	elseif item.components.equippable ~= nil then
        local current = inst.components.inventory:GetEquippedItem(item.components.equippable.equipslot)
        if current ~= nil then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(item)
    end
end

local function CalcSanityAura(inst, observer)
    return observer:IsNear(inst, 4) and 5 / 60 or 0
end

local function lostearthfn(inst)
    inst.AnimState:OverrideSymbol("swap_object", "swap_redlantern", "swap_redlantern_stick")
    inst._body = SpawnPrefab("redlanternbody")
    inst._body.AnimState:SetMultColour(0, 0, 0, 0.5)
    inst._body.entity:SetParent(inst.entity)
    inst._body.entity:AddFollower()
    inst._body.Follower:FollowSymbol(inst.GUID, "swap_object", 84, -120, 0)
    inst.entity:AddLight()
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(253 / 255, 179 / 255, 179 / 255)
    inst.Light:SetFalloff(.33)
    inst.Light:SetRadius(4)
    inst.Light:Enable(true)
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura
end
local function jisha(inst, deadthing, killer)
    if deadthing ~= nil and not (deadthing:HasTag("wall") or deadthing:HasTag("smashable")) then
        if deadthing:IsValid() then
            if not inst:IsNear(deadthing, 20) then
                return
            end
            if math.random() < 0.33 then
                local nightmarefue = SpawnPrefab("nightmarefuel")
                inst.components.container:GiveItem(nightmarefue)
                local x, y, z = inst.Transform:GetWorldPosition()
                SpawnPrefab("sanity_raise").Transform:SetPosition(x, y, z)
            end

        end
    end
end

local function lostearthgaifn(inst)
    inst.AnimState:OverrideSymbol("swap_object", "swap_lostlantern", "swap_redlantern_stick")
    inst._body = SpawnPrefab("lostlanternbody")
    inst._body.entity:SetParent(inst.entity)
    inst._body.entity:AddFollower()
    inst._body.Follower:FollowSymbol(inst.GUID, "swap_object", 84, -120, 0)
    inst.entity:AddLight()
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(253 / 255, 179 / 255, 179 / 255)
    inst.Light:SetFalloff(.33)
    inst.Light:SetRadius(4)
    inst.Light:Enable(true)
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("lostchester_gai")
        end
        return inst
    end
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("lostchester_gai")
    inst:ListenForEvent("death", OnDeath)
    -- inst:ListenForEvent("onremove", OnDeath)
    inst._onentitydeath = function(world, data)
        jisha(inst, data.inst)
    end
    inst:ListenForEvent("entity_death", inst._onentitydeath, TheWorld)
end
local function chunyifu(inst)
    if inst.components.inventory ~= nil and
        not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.BODY) then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(inst.Remove)
        weapon:AddComponent("equippable")
        weapon.components.equippable.insulated = true
        inst.components.inventory:Equip(weapon)
    end
end
local function yisugai(inst)
    inst.components.locomotor.runspeed = 7
    inst.components.locomotor.walkspeed = 7
end

local function lostumbrellafn(inst)
    inst:AddTag("lightningrod")
    if not TheWorld.ismastersim then
        return inst
    end
    chunyifu(inst)
end

local function lostumbrellagaifn(inst)
    inst:AddTag("lightningrod")
    if not TheWorld.ismastersim then
        return inst
    end
    chunyifu(inst)
end

local function lostchesterfn(inst)
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("lostchester")
    inst:ListenForEvent("death", OnDeath)
end

local function lostchestergaifn(inst)
    inst:AddComponent("container")
    inst:AddComponent("preserver")
    inst.components.container:WidgetSetup("lostchestergai")
    inst.components.preserver:SetPerishRateMultiplier(0)
    inst:ListenForEvent("death", OnDeath)
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end
local function retargetfn(inst)
    local leader = inst.components.follower:GetLeader()
    return leader ~= nil and FindEntity(leader, TUNING.SHADOWWAXWELL_TARGET_DIST, function(guy)
        return guy ~= inst and (guy.components.combat:TargetIs(leader) or guy.components.combat:TargetIs(inst)) and
                   inst.components.combat:CanTarget(guy)
    end, {"_combat"}, {"playerghost", "INLIMBO"}) or nil
end

local function keeptargetfn(inst, target)
    return inst.components.follower:IsNearLeader(18) and inst.components.combat:CanTarget(target)
end
local function EquipWeapon(inst)
    if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(20)
        weapon.components.weapon:SetRange(8, 10)
        weapon.components.weapon:SetProjectile("tz_projectile")
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(inst.Remove)
        weapon:AddComponent("equippable")
        inst.components.inventory:Equip(weapon)
    end
end
local function EquipWeapongai(inst)
    if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(25)
        weapon.components.weapon:SetRange(8, 10)
        weapon.components.weapon:SetProjectile("tz_xin_cjb")
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(inst.Remove)
        weapon:AddComponent("equippable")
        inst.components.inventory:Equip(weapon)
    end
end
local function lostfightfn(inst)
    --inst:AddComponent("inventory")
    inst.components.inventory.dropondeath = false
    inst.components.combat:SetDefaultDamage(1)
    inst.components.combat:SetAttackPeriod(0.4)
    inst.components.combat:SetRetargetFunction(2, retargetfn)
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)

    EquipWeapon(inst)
end
local function lostfightgaiattack(inst, data)
    local target = data.target
    if target and target:IsValid() and math.random() < 0.02 and not inst.cd == true then
        local pos = Vector3(target.Transform:GetWorldPosition())
        local shadowmeteor = SpawnPrefab("yezhao_meteor")
        shadowmeteor.Transform:SetPosition(pos.x, pos.y, pos.z)
        inst.cd = true
        inst:DoTaskInTime(1, function()
            inst.cd = false
        end)
    end
end

local function lostfightgaifn(inst)
    --inst:AddComponent("inventory")
    inst.components.inventory.dropondeath = false
    inst.components.combat:SetDefaultDamage(1)
    inst.components.combat:SetAttackPeriod(0.4)
    inst.components.combat:SetRetargetFunction(2, retargetfn)
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst:ListenForEvent("onattackother", lostfightgaiattack)
    EquipWeapongai(inst)
    inst.components.locomotor.runspeed = 7
    inst.components.locomotor.walkspeed = 7
end

local function MakeLostDay(prefab, qianghua, tool, hat, armor, master_postinit, keji_postinit, data)
    local assets = {Asset("ANIM", "anim/lostearth.zip"), Asset("SOUND", "sound/maxwell.fsb"),
                    Asset("ANIM", "anim/swap_redlantern.zip"), Asset("ANIM", "anim/swap_umbrella.zip"),
                    Asset("ANIM", "anim/swap_tzumbrella.zip"),
                    Asset("ATLAS", "images/inventoryimages/" .. prefab .. "_builder.xml"),
					--Asset("ATLAS", "images/inventoryimages/" .. prefab .. "_gai_builder.xml"),
                    Asset("ANIM", "anim/lostlantern.zip"), Asset("ANIM", "anim/swap_lostlantern.zip"),
                    Asset("ANIM", "anim/swap_backpack_gai.zip"), Asset("ANIM", "anim/player_amulet_resurrect.zip"),
                    Asset("ANIM", "anim/tz_shadowbox.zip")}

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        inst.entity:AddDynamicShadow()
        MakeCharacterPhysics(inst, 30, .5)
        inst.DynamicShadow:SetSize(2, 1.5)
        inst.Transform:SetFourFaced(inst)

        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("lostearth")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetMultColour(0, 0, 0, 0.5)
        RemovePhysicsColliders(inst)
        inst.Physics:SetCollisionGroup(COLLISION.SANITY)
        inst.Physics:CollidesWith(COLLISION.SANITY)
        if tool ~= nil then
            inst.AnimState:OverrideSymbol("swap_object", tool, tool)
            inst.AnimState:Hide("ARM_normal")
        else
            inst.AnimState:Hide("ARM_carry")
        end

        if hat ~= nil then
            inst.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
            inst.AnimState:Hide("HAIR_NOHAT")
            inst.AnimState:Hide("HAIR")
        else
            inst.AnimState:Hide("HAT")
            inst.AnimState:Hide("HAIR_HAT")
        end
        if armor ~= nil then
            inst.AnimState:OverrideSymbol("backpack", armor, "backpack")
            inst.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
        else
            inst.AnimState:ClearOverrideSymbol("swap_body")
            inst.AnimState:ClearOverrideSymbol("backpack")
        end
        if master_postinit ~= nil then
            master_postinit(inst)
        end
        inst._qianghua = qianghua
        inst:AddTag("scarytoprey")
        inst:AddTag("NOBLOCK")
        inst:AddTag("notraptrigger")
        inst:AddTag("noauradamage")
        inst:AddTag("tzsuicong")
        inst:AddTag("tzlostday")
        inst:AddTag(prefab)
        inst:AddTag("companion")
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("locomotor")
        inst.components.locomotor.runspeed = 7
        inst.components.locomotor.walkspeed = 7

        inst:AddComponent("inspectable")

        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.deleteitemonaccept = false
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader:Enable()

		inst:AddComponent("inventory")

        inst:AddComponent("follower")
        inst.components.follower:KeepLeaderOnAttacked()
        inst.components.follower.keepdeadleader = true
        if prefab == "lostchester" or prefab == "lostchester_gai" then
            inst:AddComponent("health")
            inst.components.health:SetMaxHealth(75)
            inst.components.health:StartRegen(4, 1)
            inst.components.health.absorb = 0.6
            inst.components.health.nofadeout = true
            inst.components.health.redirect = nodebrisdmg
            inst.components.health:SetAbsorptionAmount(1)
        else
            inst:AddComponent("health")
            inst.components.health:SetMaxHealth(75)
            inst.components.health:StartRegen(4, 1)
            inst.components.health.absorb = 0.6
            inst.components.health.nofadeout = true
            inst.components.health.redirect = nodebrisdmg
        end
        inst.sign = {}
        inst:ListenForEvent("onremove", function(inst, data)
            if inst:HasTag("lostumbrella_gai") then
                local x, y, z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, y, z, 24, {"player"})
                for k, v in pairs(ents) do
                    v.components.temperature.inherentsummerinsulation = 0
                    v.components.health.externalabsorbmodifiers = SourceModifierList(v, 0, SourceModifierList.additive)
                    v.number = v.number - 2
                    inst.sign = 0
                    if v.fx then
                        v.fx.AnimState:PlayAnimation("pst")
                        v.fx = nil
                        v.fx1 = nil
                    end
                end
            end
            if inst:HasTag("lostumbrella") then
                local x, y, z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, y, z, 10, {"player"})
                for k, v in pairs(ents) do
                    v.components.temperature.inherentsummerinsulation = 0
                    v.components.health.externalabsorbmodifiers = SourceModifierList(v, 0, SourceModifierList.additive)
                    v.number = v.number - 1
                    inst.sign = 0
                    if v.fx then
                        v.fx.AnimState:PlayAnimation("pst")
                        v.fx = nil
                        v.fx1 = nil
                    end
                end
            end
        end)
        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "torso"
        inst.components.combat:SetRange(8)
        inst:AddComponent("lootdropper")
        inst.components.lootdropper:AddChanceLoot('nightmarefuel', 1)
        inst:SetBrain(brain)
        inst:SetStateGraph("SGlostday")
        inst:ListenForEvent("attacked", OnAttacked)
        if keji_postinit ~= nil then
            keji_postinit(inst)
        end
        return inst
    end

    return Prefab(prefab, fn, assets, prefabs)
end

--------------------------------------------------------------------------
----
local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function onbuilt(inst, builder)
    local num = 1
    if builder.components.tz_xx and builder.components.tz_xx.dengji > 8 and math.random() < 0.5 then
        num = 2
    end
    for k = 1, num do
        local theta = math.random() * 2 * PI
        local pt = builder:GetPosition()
        local radius = math.random(3, 6)
        local offset = FindWalkableOffset(pt, theta, radius, 12, true, true, NoHoles)
        if offset ~= nil then
            pt.x = pt.x + offset.x
            pt.z = pt.z + offset.z
        end
        builder.components.petleashlostday:SpawnPetAt(pt.x, 0, pt.z, inst.pettype)
    end
    inst:Remove()
end

local function MakeBuilder(prefab)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()

        inst:AddTag("CLASSIFIED")

        inst.persists = false

        if not TheWorld.ismastersim then
            return inst
        end

        inst.pettype = prefab
        inst.OnBuiltFn = onbuilt

        return inst
    end

    return Prefab(prefab .. "_builder", fn, nil, {prefab})
end

local function onbuiltchong(inst, builder)
    local num = 1
    if builder.components.tz_xx and builder.components.tz_xx.dengji > 8 and math.random() < 0.5 then
        num = 2
    end
    for k = 1, num do
        local theta = math.random() * 2 * PI
        local pt = builder:GetPosition()
        local radius = math.random(3, 6)
        local offset = FindWalkableOffset(pt, theta, radius, 12, true, true, NoHoles)
        if offset ~= nil then
            pt.x = pt.x + offset.x
            pt.z = pt.z + offset.z
        end
        builder.components.petleashlostday:SpawnPetAt(pt.x, 0, pt.z, inst.pettype)
    end

    inst:Remove()
end

local function MakeBuilderChong(prefab)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()

        inst:AddTag("CLASSIFIED")

        inst.persists = false

        if not TheWorld.ismastersim then
            return inst
        end

        inst.pettype = prefab
        inst.OnBuiltFn = onbuiltchong

        return inst
    end

    return Prefab(prefab .. "_builder", fn, nil, {prefab})
end
--------------------------------------------------------------------------
local function lanternbodyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lostlantern")
    inst.AnimState:SetBuild("lostlantern")
    inst.AnimState:PlayAnimation("idle_body_loop", true)
    inst.AnimState:SetMultColour(0, 0, 0, 0.5)
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst.persists = false

    return inst
end
local function miaobodyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("redlantern")
    inst.AnimState:SetBuild("redlantern")
    inst.AnimState:PlayAnimation("idle_body_loop", true)
    inst.AnimState:SetMultColour(0, 0, 0, 0.5)
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    inst.persists = false

    return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()
    inst:AddTag("FX")
    inst.entity:SetCanSleep(false)

    inst.AnimState:SetBank("tz_shadow")
    inst.AnimState:SetBuild("tz_shadowunbrella")
    inst.AnimState:PlayAnimation("loop")
    inst.AnimState:SetScale(2, 2)
    inst.AnimState:SetFinalOffset(0)
    -- inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )LAYER_BACKGROUND
    inst.AnimState:SetLayer(998)
    inst.AnimState:SetSortOrder(999)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    -- inst:ListenForEvent("animqueueover", function(inst,data)
    -- inst:DoTaskInTime(0.5,inst.Remove)
    -- end)
    return inst
end

return MakeLostDay("lostearth", false, "swap_redlantern", nil, nil, lostearthfn, nil), -- 暗影释放者
MakeLostDay("lostearth_gai", true, "swap_lostlantern", nil, nil, lostearthgaifn, yisugai), MakeBuilder("lostearth"),MakeBuilder("lostearth_gai"),

    MakeLostDay("lostumbrella", false, "swap_umbrella", nil, nil, lostumbrellafn, nil),
    MakeLostDay("lostumbrella_gai", true, "swap_tzumbrella", nil, nil, lostumbrellagaifn, yisugai),MakeBuilder("lostumbrella"),MakeBuilder("lostumbrella_gai"),
	
	MakeLostDay("lostchester", false, nil, nil, "swap_backpack", nil, lostchesterfn),
    MakeLostDay("lostchester_gai", true, nil, nil, "tz_shadowbox", nil, lostchestergaifn), MakeBuilder("lostchester"),MakeBuilder("lostchester_gai"),

    MakeLostDay("lostfight", false, "swap_tz_enchanter", nil, nil, nil, lostfightfn), --  暗影投射者
    MakeLostDay("lostfight_gai", true, "swap_tz_yexingzhe", nil, nil, nil, lostfightgaifn), MakeBuilder("lostfight"),MakeBuilder("lostfight_gai"),

    Prefab("tz_shadowunbrella", fxfn, fxassets), Prefab("lostlanternbody", lanternbodyfn)
