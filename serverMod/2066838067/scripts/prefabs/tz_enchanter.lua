local TzUtil = require("tz_util")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/customanim.zip"),
    Asset("ANIM", "anim/tz_enchanter.zip"),
    Asset("ANIM", "anim/swap_tz_enchanter.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_enchanter.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_enchanter.xml"),
    Asset("ANIM", "anim/tz_enchanter_yellow.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_enchanter_yellow.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_enchanter_yellow.xml")
}
local prefabs = {
    "tz_thurible_smoke",
    "statue_transition",
    "statue_transition_2",
    "tz_charge",
    "tz_takefuel",
    "tz_projectile",
    "tz_bfoff",
    "tz_canying",
    "tz_bfon",
    "tz_shadow_buff"
}

local function onremovesmoke(smoke)
    smoke._mi._smoke = nil
end

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function doeffects(inst, pos)
    SpawnPrefab("statue_transition").Transform:SetPosition(pos:Get())
    SpawnPrefab("statue_transition_2").Transform:SetPosition(pos:Get())
end
--change 2019-05-15
local function onspawn(owner, enchanter)
    if not owner and owner.components.tzpetshadow then
        return
    end
    if owner.components.tzpetshadow:IsFull() then
        return
    end
    local theta = math.random() * 2 * PI
    local pt = owner:GetPosition()
    local radius = math.random(3, 6)
    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 3, 6, false, true, NoHoles)
    if offset ~= nil then
        pt.x = pt.x + offset.x
        pt.z = pt.z + offset.z
    end
    local minis = {"tz_nightmare1", "tz_nightmare2"}
    local mini = minis[math.random(#minis)]
    local k = owner.components.tzpetshadow:SpawnPetAt(pt.x, 0, pt.z, mini)
    --如果需要 在这儿更换贴图等等
    if k then
        k.Transform:SetScale(0.3 * enchanter * enchanter, 0.3 * enchanter * enchanter, 0.3 * enchanter * enchanter)
    end
end

local function toremove(owner)
    if owner and owner.components.leader then
        for k, v in pairs(owner.components.leader.followers) do
            if k:HasTag("tzxiaoyingguai") and k.components.health and not k.components.health:IsDead() then
                k.components.health:Kill()
            end
        end
    end
end
local function checkenchanter(owner)
    local enchanter
    if owner.components.inventory:EquipHasTag("tz_enchanter") then
        if owner.components.inventory:EquipHasTag("tz_yellow") then
            enchanter = 1
        else
            enchanter = 1
        end
    else
        enchanter = 0
    end
    --连续60秒无装备就删除小弟
    if enchanter == 0 then
        --装备变化了 更换贴图
        -- elseif enchanter ~= owner.enchanter then
        -- owner.enchanter = enchanter
        -- if owner.components.leader then
        -- for k,v in pairs(owner.components.leader.followers) do
        -- if k:HasTag("tzxiaoyingguai") and k.components.health and not k.components.health:IsDead() then
        -- --改变贴图 这儿只改变了大小
        -- k.Transform:SetScale(0.3*enchanter*enchanter, 0.3*enchanter*enchanter, 0.3*enchanter*enchanter)
        -- end
        -- end
        -- end
        --么得变化  计时刷影怪吧
        if owner.enchanter ~= 0 then
            owner.enchanter = 0
            owner.enchantertime = 0
        end
        owner.enchantertime = owner.enchantertime + 1
        if owner.enchantertime >= 360 then
            toremove(owner)
            owner.enchantertime = 0
            owner._enchanter:Cancel()
            owner._enchanter = nil
        end
    else
        owner.enchantertime = owner.enchantertime + 1
        if owner.enchantertime >= 60 then
            onspawn(owner, enchanter)
            owner.enchantertime = 0
        end
    end
end
--change
local function onequip(inst, owner)
    if owner.prefab == "taizhen" then
        --change 2019-05-15
        owner.AnimState:OverrideSymbol("swap_object", inst.symbolbuild, inst.symbolimage)
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
        --change end
        if inst._smoke == nil then
            inst._smoke = SpawnPrefab("tz_thurible_smoke")
            inst._smoke.entity:AddFollower()
            inst._smoke._mi = inst
            inst:ListenForEvent("onremove", onremovesmoke, inst._smoke)
            inst._smoke.Follower:FollowSymbol(inst.components.inventoryitem.owner.GUID, "swap_object", -1, -190, 0)
        end
        --change 2019-05-15
        -- if inst._shadowtz == nil then
        -- inst._shadowtz = inst:DoPeriodicTask(60, onspawn,60 )
        -- end

        if owner._enchanter == nil then
            owner.enchanter = 0
            owner.enchantertime = 0
            owner._enchanter = owner:DoPeriodicTask(1, checkenchanter)
        end

        --change end
        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
        if owner.components.tz_xx and owner.components.tz_xx.dengji > 7 then
            if owner.components.combat then
                owner.components.combat.externaldamagemultipliers:SetModifier("tzxx_level7", 1.25)
            end
            --inst.components.samaequip.equipsama = 12
        end
    else
        if TUNING.TZ_FANHAO_SPECIFIC then
            TzUtil.OnInvalidOwner(inst, owner, 0, STRINGS.NOYEXINGZHE, true)
        end
    end
end

local function onunequip(inst, owner)
    -- if not owner.sg:HasStateTag("dead") then
    -- owner.sg:GoToState("idle")
    -- end
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if inst._smoke ~= nil then
        inst._smoke:Remove()
    end
    if inst._shadowtz ~= nil then
        inst._shadowtz:Cancel()
        inst._shadowtz = nil
    end
    -- toremove(inst)    既然操作只与人物有关  那么只需要关注人物就行

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
    if owner.components.tz_xx then
        if owner.components.combat then
            owner.components.combat.externaldamagemultipliers:RemoveModifier("tzxx_level7")
        end
        --inst.components.samaequip.equipsama = 0
    end
end

local function OnRemove(inst)
    if inst._smoke ~= nil then
        inst._smoke:Remove()
    end
end
local function onfinished(inst)
    local spiritualism = SpawnPrefab("tz_spiritualism")
    if spiritualism then
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
        local pt = Vector3(inst.Transform:GetWorldPosition())
        local holder = owner and (owner.components.inventory or owner.components.container)
        local slot = holder and holder:GetItemSlot(inst)
        inst:Remove()
        --toremove(inst)
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
        SpawnPrefab("tz_takefuel").Transform:SetPosition(pos.x - 0.1, pos.y - 2.6, pos.z)
    end
end

local function OnSpell(inst, doer)
    -- for k, v in pairs(doer.components.tzpetshadow.pets) do
    --     v.buff = SpawnPrefab('tz_shadow_buff')
    --     v.buff.entity:SetParent(v.entity)
    --     v.buff.entity:AddFollower()
    --     if v.prefab=="tz_nightmare2" then
    --         -- 大嘴 buff效果的跟随偏移
    --         v.buff.Follower:FollowSymbol(v.GUID, 'shadowcreature2_body', 0, -500, 0)
    --         -- buff后的伤害
    --         v.components.combat:SetDefaultDamage(45)
    --         -- buff后的移速
    --         v.components.locomotor.walkspeed =  23
    --     else
    --         -- 爬行怪
    --         v.buff.Follower:FollowSymbol(v.GUID, 'shadowcreature1_body', 0, -500, 0)
    --         v.components.combat:SetDefaultDamage(35)
    --         v.components.locomotor.walkspeed =  28
    --     end
    -- end
end

local function levelfn(inst)
    local level = inst.components.tz_fh_level.level
    inst.components.weapon:SetRange(8 + level*0.2)
    inst.components.samaequip.equipsama = level
    inst.components.equippable.dapperness = (-2+level)/ 60 --每分钟掉2
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("tz_spiritualism.tex")

    inst.AnimState:SetBank("tz_enchanter")
    inst.AnimState:SetBuild("tz_enchanter")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    --change 2019-05-15
    inst:AddTag("tz_enchanter")
    inst:AddTag("tz_fanhao")
    inst:AddTag("rangedweapon")
    -- 需要加上这个tag，饥荒才会给对应的冷却效果显示
    -- inst:AddTag("rechargeable")
    --change
	
    -- inst:AddComponent("aoetargeting")
    -- inst.components.aoetargeting:SetAlwaysValid(true)
    -- inst.components.aoetargeting.reticule.reticuleprefab = ""
    -- inst.components.aoetargeting.reticule.pingprefab = ""
	-------------------------------------------------------------------------------------
    -- inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    -- inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
    -- inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
	-------------------------------------------------------------------------------------
    -- inst.components.aoetargeting.reticule.validcolour = {1, .75, 0, 1}
    -- inst.components.aoetargeting.reticule.invalidcolour = {.5, 0, 0, 1}
    -- inst.components.aoetargeting.reticule.ease = true
    -- inst.components.aoetargeting.reticule.mouseenabled = true
    local old_GetDisplayName = inst.GetDisplayName
    inst.GetDisplayName = function(self,...)
        local level = inst.tz_fh_level ~= nil and inst.tz_fh_level:value() or 0
        if level == 0 then
            return old_GetDisplayName(self,...)
        else
            return old_GetDisplayName(self,...)
            .." +"..level.."\n攻击距离 +"..(level*0.2).."\n撒嘛值回复 +"..level.."/分钟"
        end
    end
    inst.tz_fh_level = net_ushortint(inst.GUID, "tzfanhaolevel_enchanter")
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.onspawn = onspawn
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(17)
    inst.components.weapon:SetRange(8)
    inst.components.weapon:SetProjectile("tz_projectile")
    inst.components.weapon.heightoffset = 1
	-----------------------------------------------------------------------------------
	inst.components.weapon:SetOnAttack(function(zj, wj, mb)
		tz_xin["tz_xin_lhwq"](inst, mb)
	end)
	-----------------------------------------------------------------------------------
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_enchanter.xml"

    inst:AddComponent("samaequip")
    inst.components.samaequip.equipsama = 0

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = -10 / 300
    --change 2019-05-15
    inst.symbolbuild = "swap_tz_enchanter"
    inst.symbolimage = "swap_tz_enchanter"
    --change
    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(3840)
    inst.components.fueled:SetDepletedFn(onfinished)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true ---0.5					--1/60

    -- inst:AddComponent("tz_rechargeable")
    -- inst.components.rechargeable = inst.components.tz_rechargeable
    -- inst.components.rechargeable:SetRechargeTime(3)
    -- inst:RegisterComponentActions("rechargeable")

    -- inst:AddComponent("tz_aoespell")
    -- inst.components.aoespell = inst.components.tz_aoespell
    -- inst.components.aoespell.canuseonpoint = true
    -- inst.components.aoespell:SetSpellFn(OnSpell)
    -- inst:RegisterComponentActions("aoespell")

    inst:AddComponent("tz_fh_level")
    inst.components.tz_fh_level.levelupfn = levelfn

    inst.OnRemoveEntity = OnRemove
    MakeHauntableLaunch(inst)

	TzFh.tzsama(inst)

    return inst
end

--change 2019-05-15
--return Prefab("tz_enchanter", fn, assets, prefabs)
local function yellowfn()
    local inst = fn()
    inst.AnimState:SetBank("tz_enchanter_yellow")
    inst.AnimState:SetBuild("tz_enchanter_yellow")
    inst:AddTag("tz_yellow")
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_enchanter_yellow.xml"
    inst.components.inventoryitem.imagename = "tz_enchanter_yellow"
    inst.symbolbuild = "tz_enchanter_yellow"
    inst.symbolimage = "shochi"
    return inst
end
return Prefab("tz_enchanter", fn, assets, prefabs), Prefab("tz_enchanter_yellow", yellowfn, assets, prefabs)
--change end
