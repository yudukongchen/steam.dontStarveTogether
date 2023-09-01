local assets =
{
	Asset("ANIM", "anim/stu_chainsaw.zip"),
    Asset("ANIM", "anim/stu_chainsaw_skin.zip"),

    Asset("ANIM", "anim/swap_stu_chainsaw.zip"),
    Asset("ANIM", "anim/swap_stu_chainsaw_skin.zip"),
    
    Asset("ATLAS", "images/inventoryimages/stu_chainsaw.xml"),
    Asset("ATLAS", "images/inventoryimages/stu_chainsaw_skin.xml")
}

local function MakeChain(skinname)
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_"..skinname, "swap_"..skinname)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank(skinname)
    inst.AnimState:SetBuild(skinname)
    inst.AnimState:PlayAnimation("idle", true)  --c_findnext("skd_sword")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("weapon")

    inst:AddTag("jab")
    inst:AddTag("stu_chainsaw")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.skill = 0

    inst:AddComponent("inspectable")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.STU_WP_DAMAGE)
    inst.components.weapon:SetRange(2)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = skinname
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..skinname..".xml"
    inst.components.inventoryitem.keepondeath = true

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.restrictedtag = "stu"
    inst.components.equippable.walkspeedmult = TUNING.STU_WP_MULT 
--[[
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(function(item, fixer, giver)
        local result = false
        if (fixer.prefab == "redgem" or fixer.prefab == "bluegem") then
            if inst.skill ~= 1 then
               result = true
               inst.skill = 1

            elseif giver and giver.components.talker then
               giver.components.talker:Say("已解锁该技能") 
            end    

        elseif (fixer.prefab == "purplegem" or fixer.prefab == "orangegem") then
            if inst.skill ~= 2 then
               result = true
               inst.skill = 2

            elseif giver and giver.components.talker then
               giver.components.talker:Say("已解锁该技能") 
            end   

        elseif (fixer.prefab == "yellowgem" or fixer.prefab == "greengem") then 
            if inst.skill ~= 3 then
               result = true
               inst.skill = 3

            elseif giver and giver.components.talker then
               giver.components.talker:Say("已解锁该技能") 
            end   
        end

        if result then
            inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
        end    
        return result
    end)    

    inst.OnSave = function(inst, data)
        data.skill = inst.skill
    end
    inst.OnLoad = function(inst, data)
        if data then
            inst.skill = data.skill
        end
    end

    inst:DoPeriodicTask(0.33, function(inst) 
        if inst.skill == 1 and not inst:HasTag("skill_1") then
            inst:AddTag("skill_1")
            inst:RemoveTag("skill_2")
            inst:RemoveTag("skill_3")

        elseif inst.skill == 2 and not inst:HasTag("skill_2") then
            inst:AddTag("skill_2")
            inst:RemoveTag("skill_1")
            inst:RemoveTag("skill_3")

        elseif inst.skill == 3 and not inst:HasTag("skill_3") then
            inst:AddTag("skill_3")
            inst:RemoveTag("skill_1")
            inst:RemoveTag("skill_2")

        elseif inst.skill == 0 then
            inst:RemoveTag("skill_1")
            inst:RemoveTag("skill_2")
            inst:RemoveTag("skill_3")                        
        end 
    end)
]]
    MakeHauntableLaunch(inst)

    return inst
end

    return Prefab(skinname, fn, assets)
end

local skins = {}
local skin1 = MakeChain("stu_chainsaw")
local skin2 = MakeChain("stu_chainsaw_skin")

table.insert(skins, skin1)
table.insert(skins, skin2)

return unpack(skins)