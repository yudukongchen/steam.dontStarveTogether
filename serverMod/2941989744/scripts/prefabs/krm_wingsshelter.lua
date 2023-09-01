local assets = {
    Asset("ANIM", "anim/krm_wingsshelter.zip"),
    Asset("ATLAS", "images/inventoryimages/krm_wingsshelter.xml")}

local prefabs = {}

RegisterInventoryItemAtlas("images/inventoryimages/krm_wingsshelter.xml", "krm_wingsshelter.tex")

STRINGS.NAMES.KRM_WINGSSHELTER = "庇护之翼"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KRM_WINGSSHELTER = "愿你的生命远离苦难"

local RESISTANCES =
{
    "_combat",
    "explosive",
    "quakedebris",
    "caveindebris",
    "trapdamage",
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "krm_wingsshelter", "swap_body")
    if owner:HasTag("player") then
        inst:ListenForEvent("attacked",inst.attack_fn,owner)
        if owner.components.health then
            inst._oldhealth = owner.components.health.SetVal
            owner.components.health.SetVal = function(self,val,...)
                local old_health = self.currenthealth
                local min_health = self.minhealth or 0
                if val <= min_health then
                    inst:Remove()
                    self:DoDelta(self.maxhealth, false, "oldager_component")
                    return
                end
                return  inst._oldhealth(self,val,...)
            end

        end
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    if owner:HasTag("player") then
        inst:RemoveEventCallback("attacked",inst.attack_fn,owner)
        if inst._oldhealth and  owner.components.health then
            owner.components.health.SetVal = inst._oldhealth
        end
        inst._oldhealth = nil
    end
    if inst.wingsshelter_task then
        inst.wingsshelter_task:Cancel()
        inst.wingsshelter_task = nil
    end
    if inst.wingsshelter_fx then
        inst.wingsshelter_fx:kill_fx()
        inst.wingsshelter_fx = nil
    end
end

local function ShouldResistFn(inst)
    if not inst.components.equippable:IsEquipped() then
        return false
    end
    local owner = inst.components.inventoryitem.owner
    return owner ~= nil
        and not (owner.components.inventory ~= nil and
                owner.components.inventory:EquipHasTag("forcefield"))
        and inst.forcefield_damage
end

local function OnResistDamage(inst)--, damage)
    if inst.wingsshelter_fx then
        inst.wingsshelter_fx.AnimState:PlayAnimation("hit")
        inst.wingsshelter_fx.AnimState:PushAnimation("idle_loop")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("krm_wingsshelter")
    inst.AnimState:SetBuild("krm_wingsshelter")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.forcefield_damage = false
    inst.damage_record = 0
    inst.attack_fn = function(owner,data)
        if owner and data and data.original_damage and owner.components.health and not owner.components.health:IsDead() then
            inst.damage_record = inst.damage_record + data.original_damage
            if inst.damage_record >= 500 then
                inst.components.equippable.walkspeedmult = 2
                inst.forcefield_damage = true
                inst:DoTaskInTime(2,function()
                    inst.components.equippable.walkspeedmult = nil
                end)
                inst.damage_record = 0
                if inst.wingsshelter_task then
                    inst.wingsshelter_task:Cancel()
                end
                if not inst.wingsshelter_fx then
                    inst.wingsshelter_fx = SpawnPrefab("forcefieldfx")
                    inst.wingsshelter_fx.entity:SetParent(owner.entity)
                    inst.wingsshelter_fx.Transform:SetPosition(0, 0.2, 0)
                end
                inst.wingsshelter_task = inst:DoTaskInTime(5,function()
                    inst.wingsshelter_task = nil
                    if inst.wingsshelter_fx then
                        inst.wingsshelter_fx:kill_fx()
                        inst.wingsshelter_fx = nil
                    end
                    inst.forcefield_damage = false
                end)
            end
        end
    end

    inst:AddComponent("inventoryitem")

    inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.AMULET or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("resistance")
    inst.components.resistance:SetShouldResistFn(ShouldResistFn)
    inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
    for i, v in ipairs(RESISTANCES) do
        inst.components.resistance:AddResistance(v)
    end
    
    MakeHauntableLaunch(inst)

    return inst
end

--------------------------------------------------------------------------------

return Prefab("krm_wingsshelter", fn, assets, prefabs)
