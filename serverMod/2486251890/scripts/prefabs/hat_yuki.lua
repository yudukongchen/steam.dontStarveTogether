local assets =
{
    Asset("ANIM", "anim/hat_yuki.zip"),
    Asset("ATLAS", "images/inventoryimages/hat_yuki.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_yuki.tex")
}

local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_hat", "hat_yuki", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        --owner.AnimState:Hide("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
     end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end        
end 

local function onunequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_hat")
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
     end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end          
end    

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("hat")

    inst.AnimState:SetBank("hat_yuki")
    inst.AnimState:SetBuild("hat_yuki")
    inst.AnimState:PlayAnimation("anim")

  --  inst:AddTag("yuki_armor")  --这个标签能让护甲耐久比例不显示出来
    MakeInventoryFloatable(inst, "med", nil, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
   
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "hat_yuki"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_yuki.xml"


    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.WALRUSHAT_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    --inst:AddComponent("insulator")
    --inst.components.insulator:SetInsulation(120)  --120秒保暖

    --inst:AddComponent("waterproofer")
    --inst.components.waterproofer:SetEffectiveness(0.8)   --0.8的防水系数

    inst:AddComponent("inspectable") 

    inst:AddComponent("tradable")

    inst:AddComponent("equippable")
    --inst.components.equippable.restrictedtag = "yuki"    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.walkspeedmult = 1.1
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("hat_yuki", fn, assets)