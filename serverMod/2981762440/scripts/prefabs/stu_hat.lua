local assets =
{
    Asset("ANIM", "anim/stu_hat.zip"),
    Asset("ANIM", "anim/stu_hat_ground.zip"),

    Asset("ANIM", "anim/stu_hat_skin.zip"),
    Asset("ANIM", "anim/stu_hat_skin_ground.zip"),

    Asset("ATLAS", "images/inventoryimages/stu_hat.xml"),
    Asset("ATLAS", "images/inventoryimages/stu_hat_skin.xml"),
}

local function MakeHat(name)
local function onequip(inst, owner)
    owner.equipcoattask = owner:DoTaskInTime(0, function() 
        owner.AnimState:OverrideSymbol("swap_hat", name, "swap_hat")
        owner.AnimState:OverrideSymbol("hair_hat", name, "hair_hat")
        owner.AnimState:OverrideSymbol("hair", name, "hair")   
        if owner.equipcoattask then
            owner.equipcoattask:Cancel()
            owner.equipcoattask = nil
        end    
    end) 

    if owner.components.stu_swim then
        owner.components.stu_swim.can_swim = true
    end    

    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end 
end 

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:ClearOverrideSymbol("hair_hat")
    owner.AnimState:ClearOverrideSymbol("hair")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner.components.stu_swim then
        owner.components.stu_swim.can_swim = false
    end    

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end       
end

local function LoadBuff(inst) 
    if inst.get_eyeball == true and inst.components.waterproofer == nil then
        inst:AddTag("waterproofer")
        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(1) 
    end 

    if inst.level > 0 then
        inst.components.armor.absorb_percent = (inst.level == 0 and 0.4) or (inst.level == 1 and 0.5) or (inst.level == 2 and 0.6) or (inst.level == 3 and 0.7)
    end   
end

local function OnSave(inst, data)
    data.get_eyeball = inst.get_eyeball
    data.level = inst.level
end

local function OnLoad(inst, data)
    if data ~= nil then
        if data.get_eyeball ~= nil then
            inst.get_eyeball = data.get_eyeball
        end

        if data.level ~= nil then
            inst.level = data.level
        end

        LoadBuff(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("hat")
    inst:AddTag("hide_percentage")

    inst:AddTag("stu_hat")
    --inst:AddTag("waterproofer")

    inst.AnimState:SetBank(name.."_ground")
    inst.AnimState:SetBuild(name.."_ground")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = name
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

    inst:AddComponent("inspectable") 

    inst:AddComponent("equippable")
    inst.components.equippable.restrictedtag = "stu"    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.walkspeedmult = TUNING.STU_HAT_MULT

    --inst:AddComponent("waterproofer")
    --inst.components.waterproofer:SetEffectiveness(1)   

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(100, 0.4)   
    inst.components.armor.indestructible = true

    inst.get_eyeball = false

    inst.level = 0 

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(function(item, fixer, giver)
        local result = false
        if fixer.prefab == "deerclops_eyeball" and inst.get_eyeball == false and inst.components.waterproofer == nil then
            result = true
            inst.get_eyeball = true

            LoadBuff(inst)

        elseif (fixer.prefab == "armorwood" and inst.level == 0)
        or (fixer.prefab == "armor_sanity" and inst.level < 2) 
        or (fixer.prefab == "armorruins" and inst.level < 3) then    
            result = true
            inst.level = (fixer.prefab == "armorwood" and 1) or (fixer.prefab == "armor_sanity" and 2) or (fixer.prefab == "armorruins" and 3) or 0
            LoadBuff(inst)
        end

        if result then
            inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
        end    
        return result
    end) 

    inst.LoadBuff = LoadBuff 

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab(name, fn, assets)
end

local skins = {}
local skin1 = MakeHat("stu_hat")
local skin2 = MakeHat("stu_hat_skin")

table.insert(skins, skin1)
table.insert(skins, skin2)

return unpack(skins)
