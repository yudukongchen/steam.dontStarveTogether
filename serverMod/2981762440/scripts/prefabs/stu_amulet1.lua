local assets =
{
    Asset("ANIM", "anim/stu_amulet1.zip"),
    Asset("ATLAS", "images/inventoryimages/stu_amulet1_1.xml"),
    Asset("ATLAS", "images/inventoryimages/stu_amulet1_2.xml"),
    Asset("ATLAS", "images/inventoryimages/stu_amulet1_3.xml"),        
}

local function PutIn(inst, owner)
    if inst.skd_task then 
        inst.skd_task:Cancel()
        inst.skd_task = nil
    end    

    inst.skd_task = inst:DoTaskInTime(0, function(inst)
    if owner and owner:IsValid() then
        owner:SetMaxSanity() 
    end    
    for k, v in ipairs(AllPlayers) do
    if v.prefab == "skd" then
        local Skill_Buff = v.components.timer ~= nil and (v.components.timer:GetTimeLeft("Skd_Skill1") or 0) or nil        
        if Skill_Buff ~= nil and Skill_Buff > 0 and v:IsValid() then
            v:SetSkillMaxHealth()

        elseif v:IsValid() then
            v:SetMaxHealth()             
        end

    elseif v.prefab == "stu" then 
        local Skill3_Buff = v.components.timer ~= nil and (v.components.timer:GetTimeLeft("Stu_Skill3") or 0) or nil  
        if Skill3_Buff ~= nil and Skill3_Buff > 0 and v:IsValid() then
            v:SetSkillMaxHealth()
        elseif v:IsValid() then
            v:SetMaxHealth()    
        end            
    end
    end
    end)      
end

local function MakeAmulet(name, armor, sanity, atk_mult, health)
local function onequip(inst, owner)
    --local percent = owner._stu_sanity or owner.components.sanity:GetPercent() or 1
    owner.components.combat.externaldamagemultipliers:SetModifier(inst.prefab, atk_mult)

    --owner.components.sanity:SetMax(owner.components.sanity.max + sanity)
    --owner.components.sanity:SetPercent(percent)

    PutIn(inst, owner)
--[[
    if name ~= "1" then
        local percent = owner._stu_health or owner.components.health:GetPercent() or 1
        local del = 150 * health - 35
        owner.components.health:SetMaxHealth(owner.components.health.maxhealth + del)
        owner.components.health:SetPercent(percent)
    end
]]    
   --owner.AnimState:OverrideSymbol("swap_body", "stu_amulet2", "stu_amulet2")
end 

local function onunequip(inst, owner)
    owner.components.combat.externaldamagemultipliers:RemoveModifier(inst.prefab) 

    --local percent = owner.components.sanity:GetPercent() or 1
    --owner.components.sanity:SetMax(owner.components.sanity.max - sanity)
    --owner.components.sanity:SetPercent(percent) 

    PutIn(inst, owner)
--[[
    if name ~= "1" then
    local percent = owner.components.health:GetPercent() or 1
    local del = 150 * health - 35
    owner.components.health:SetMaxHealth(owner.components.health.maxhealth - del)
    owner.components.health:SetPercent(percent)
    end
]]
    owner.AnimState:ClearOverrideSymbol("swap_body")   
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("amulet")
    inst:AddTag("stu_amulet1")
    inst:AddTag("stu_amulet1_"..name)

    inst:AddTag("hide_percentage")

    inst.AnimState:SetBank("stu_amulet1")
    inst.AnimState:SetBuild("stu_amulet1")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "stu_amulet1_"..name
    inst.components.inventoryitem.atlasname = "images/inventoryimages/stu_amulet1_"..name..".xml"

    inst:AddComponent("inspectable") 

    inst:AddComponent("equippable")
    inst.components.equippable.restrictedtag = "stu"    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY

    inst:ListenForEvent("onremove", PutIn)    

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(100, armor)   
    inst.components.armor.indestructible = true

    MakeHauntableLaunch(inst)

    return inst
end

    return Prefab("stu_amulet1_"..name, fn, assets)
end   

return MakeAmulet("1", 0.15, 100, 1.1, 0.23),
       MakeAmulet("2", 0.35, 200, 1.2, 0.28),
       MakeAmulet("3", 0.7, 300, 1.35, 0.3)
