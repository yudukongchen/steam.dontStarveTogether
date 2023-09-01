

local function makeback(name)
    local assets =
    {
        Asset("ANIM", "anim/"..name..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex")
    }
    
    local prefabs =
    {
        "ash",
    }
    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("backpack", name, "backpack")
        owner.AnimState:OverrideSymbol("swap_body", name, "swap_body")
        if inst.components.container ~= nil then
            inst.components.container:Open(owner)
        end
    end
    
    local function onunequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_body")
        owner.AnimState:ClearOverrideSymbol("backpack")
        if inst.components.container ~= nil then
            inst.components.container:Close(owner)
        end
    end
    
    local function onequiptomodel(inst, owner, from_ground)
        if inst.components.container ~= nil then
            inst.components.container:Close(owner)
        end
    end
    
    local function onburnt(inst)
        if inst.components.container ~= nil then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
        SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())
    
        inst:Remove()
    end
    
    local function onignite(inst)
        if inst.components.container ~= nil then
            inst.components.container.canbeopened = false
        end
    end
    
    local function onextinguish(inst)
        if inst.components.container ~= nil then
            inst.components.container.canbeopened = true
        end
    end

    local function eat(inst,food)
        local add = food:HasTag("oceanfish") and 0.02 or 0.01
        inst.perishrate =  math.clamp(inst.perishrate + add, 0, 2)
        inst.components.preserver:SetPerishRateMultiplier(1-inst.perishrate)
        print(inst.perishrate,add)
        if food.components.stackable ~= nil then
            food.components.stackable:Get():Remove()
        else
            food:Remove()
        end
    end
    
    local function fn()
        local inst = CreateEntity()
    
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
    
        MakeInventoryPhysics(inst)
    
        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("anim")
    
        inst:AddTag("backpack")
        inst:AddTag("krm_meowbag")
    
        inst.foleysound = "dontstarve/movement/foley/backpack"
    
        local swap_data = {bank = name, anim = "anim"}
        MakeInventoryFloatable(inst, "small", 0.2, nil, nil, nil, swap_data)
    
        inst.entity:SetPristine()
    
        if not TheWorld.ismastersim then
            return inst
        end
        inst.perishrate = 0 
    
        inst:AddComponent("inspectable")
    
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.cangoincontainer = false
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"
    
        inst:AddComponent("equippable")
        inst.components.equippable.restrictedtag = "kurumi"
        inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable:SetOnEquipToModel(onequiptomodel)
    
        inst:AddComponent("container")
        inst.components.container:WidgetSetup(name)
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true
    
        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        inst.components.burnable:SetOnBurntFn(onburnt)
        inst.components.burnable:SetOnIgniteFn(onignite)
        inst.components.burnable:SetOnExtinguishFn(onextinguish)

        inst.Eat = eat

        inst:AddComponent("preserver")
        inst.components.preserver:SetPerishRateMultiplier(1)
        MakeHauntableLaunchAndDropFirstItem(inst)
    
        inst.OnSave = function(inst, data)
            data.perishrate = inst.perishrate
        end

        inst.OnLoad = function(inst, data)
            if data  and data.perishrate then
                inst.perishrate = data.perishrate
                inst.components.preserver:SetPerishRateMultiplier(1-inst.perishrate)
            end
        end
    
        return inst
    end 
    return Prefab(name, fn, assets, prefabs)
end
return makeback("krm_meowbag")
