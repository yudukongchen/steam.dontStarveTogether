local assets = { Asset("ANIM", "anim/fhl_zzj.zip"), Asset("ANIM", "anim/swap_fhl_zzj.zip"),

    Asset("ATLAS", "images/inventoryimages/fhl_zzj.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_zzj.tex") }

local prefabs = {}

local function onzzjremove(inst)
    SpawnPrefab("moonrocknugget").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function SpawnIceFx(inst, target)
    if not inst then
        return
    end

    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")

    local numFX = math.random(15, 20)
    local pos = inst:GetPosition()
    local targetPos = target and target:GetPosition()
    local vec = targetPos - pos
    vec = vec:Normalize()
    local dist = pos:Dist(targetPos)
    local angle = inst:GetAngleToPoint(targetPos:Get())

    for i = 1, numFX do
        inst:DoTaskInTime(math.random() * 0.25, function(inst)
            local prefab = "icespike_fx_" .. math.random(1, 4)
            local fx = SpawnPrefab(prefab)
            if fx then
                local x = GetRandomWithVariance(0, 2)
                local z = GetRandomWithVariance(0, 2)
                local offset = (vec * math.random(dist * 0.25, dist)) + Vector3(x, 0, z)
                fx.Transform:SetPosition((offset + pos):Get())

                local x, y, z = fx.Transform:GetWorldPosition()

                -- 每根冰柱的伤害半径
                local r = 1.5

                -- 每根冰柱的伤害
                local dmg = math.random() * 50 * TUNING.ZZJ_PRE

                local ents = TheSim:FindEntities(x, y, z, r)
                for k, v in pairs(ents) do

                    ----发招忽略队友
                    if v and v.components.health and not v.components.health:IsDead() and v.components.combat and v ~=
                        inst and not (v.components.follower and v.components.follower.leader == inst) and
                        (TheNet:GetPVPEnabled() or not v:HasTag("player")) then
                        v.components.combat:GetAttacked(inst, dmg)

                        if v.components.freezable then
                            v.components.freezable:AddColdness(2)
                            v.components.freezable:SpawnShatterFX()
                        end

                    end
                end

            end
        end)
    end
end

local function fn()

    local function onequip(inst, owner, target)
        if owner.prefab == "fhl" then
            owner.AnimState:OverrideSymbol("swap_object", "swap_fhl_zzj", "swap_myitem")
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
        else
            owner:DoTaskInTime(0, function()
                local inv = owner.components.inventory
                if inv then
                    inv:GiveItem(inst)
                end
                local talker = owner.components.talker
                if talker then
                    talker:Say("我的力量无法驱使这把剑!")
                end
            end)
        end
    end

    -- 攻击燃烧
    local function onattack(weapon, attacker, target)
        -- 普攻燃烧
        if attacker and TUNING.ZZJ_FIREOPEN then
            if TheWorld.state.isnight and math.random() < TUNING.ZZJ_TIMES then
                if target ~= nil and target.components.burnable ~= nil and math.random() <
                    TUNING.TORCH_ATTACK_IGNITE_PERCENT * target.components.burnable.flammability then
                    target.components.burnable:Ignite(nil, attacker)
                end
            end
        end

        if attacker and math.random() < TUNING.ZZJ_TIMES then
            SpawnIceFx(attacker, target)
            attacker.components.hunger:DoDelta(-2)
        end
    end

    local function OnUnequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    inst.entity:AddNetwork()

    anim:SetBank("fhl_zzj")
    anim:SetBuild("fhl_zzj")
    anim:PlayAnimation("idle")

    inst:AddTag("sharp")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tool")

    if TUNING.ZZJ_CANKANSHU then
        inst.components.tool:SetAction(ACTIONS.CHOP, 3) -- 可砍树
    end
    if TUNING.ZZJ_CANWAKUANG then
        inst.components.tool:SetAction(ACTIONS.MINE, 3) -- 可挖矿
    end
    if TUNING.ZZJ_CAN_USE_AS_SHOVEL then
        inst.components.tool:SetAction(ACTIONS.DIG) -- 可挖..
    end
    -- inst.components.tool:SetAction(ACTIONS.NET)  --可捕虫
    if TUNING.ZZJ_CAN_USE_AS_HAMMER then
        inst.components.tool:SetAction(ACTIONS.HAMMER) -- 可重击
    end
    -- inst:AddInherentAction(ACTIONS.TERRAFORM)    --可铲草

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.ZZJ_DAMAGE)
    inst.components.weapon:SetRange(TUNING.ZZJ_RANGE)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_zzj.xml"
    -- inst.components.inventoryitem.keepondeath = true
    inst.components.inventoryitem.imagename = "fhl_zzj"

    if TUNING.ZZJ_FINITE_USES > 0 then
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.ZZJ_FINITE_USES)
        inst.components.finiteuses:SetUses(TUNING.ZZJ_FINITE_USES)
        inst.components.finiteuses:SetOnFinished(onzzjremove)
        inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
        inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)
        inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
        inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 1)
    end

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    -- inst.components.inventoryitem.keepondeath = true
    inst.components.equippable.walkspeedmult = 1.1

    return inst
end

return Prefab("common/inventory/fhl_zzj", fn, assets)
