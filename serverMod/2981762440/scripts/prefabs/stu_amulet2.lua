local assets =
{
    Asset("ANIM", "anim/stu_amulet2.zip"),
    Asset("ATLAS", "images/inventoryimages/stu_amulet2_1.xml"),
    Asset("ATLAS", "images/inventoryimages/stu_amulet2_2.xml"),
    Asset("ATLAS", "images/inventoryimages/stu_amulet2_3.xml")
}

local function PutIn(inst)
    --print("装备")
    if inst.stu_task then 
        inst.stu_task:Cancel()
        inst.stu_task = nil
    end    

    inst.stu_task = inst:DoTaskInTime(0, function(inst)
    local Skill3_Buff = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("Stu_Skill3") or 0) or nil                    
    if Skill3_Buff ~= nil and Skill3_Buff > 0 and inst:IsValid() then
        --print("技能加血")
        inst:SetSkillMaxHealth()
        
    elseif inst:IsValid() then
        --print("加血")
        inst:SetMaxHealth()    
    end 
    end)        
end

local function MakeAmulet(name, armor, health, atk_mult)
local function onequip(inst, owner)
    --local percent = owner._stu_health or owner.components.health:GetPercent() or 1
    owner.components.combat.externaldamagemultipliers:SetModifier(inst.prefab, atk_mult)
    PutIn(owner)

    --owner.components.health:SetMaxHealth(owner.components.health.maxhealth + health)
    --owner.components.health:SetPercent(percent)
   --owner.AnimState:OverrideSymbol("swap_body", "stu_amulet2", "stu_amulet2")
end 

local function onunequip(inst, owner)
    owner.components.combat.externaldamagemultipliers:RemoveModifier(inst.prefab) 

    --local percent = owner.components.health:GetPercent() or 1
    --owner.components.health:SetMaxHealth(owner.components.health.maxhealth - health)
    --owner.components.health:SetPercent(percent)

    PutIn(owner)

    owner.AnimState:ClearOverrideSymbol("swap_body")   
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("amulet")
    inst:AddTag("stu_amulet2")
    inst:AddTag("stu_amulet2_"..name)

    if armor > 0 then
    inst:AddTag("hide_percentage")
    end

    inst.AnimState:SetBank("stu_amulet2")
    inst.AnimState:SetBuild("stu_amulet2")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "stu_amulet2_"..name
    inst.components.inventoryitem.atlasname = "images/inventoryimages/stu_amulet2_"..name..".xml"

    inst:AddComponent("inspectable") 

    inst:AddComponent("equippable")
    inst.components.equippable.restrictedtag = "stu"    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY

    if armor > 0 then
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(100, armor)   
    inst.components.armor.indestructible = true
    end

    MakeHauntableLaunch(inst)

    return inst
end

    return Prefab("stu_amulet2_"..name, fn, assets)  
end   

return MakeAmulet("1", 0, 50, 1.2),
       MakeAmulet("2", 0.2, 65, 1.3),
       MakeAmulet("3", 0.5, 90, 1.5)
