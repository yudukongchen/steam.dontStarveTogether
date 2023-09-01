RegisterInventoryItemAtlas("images/inventoryimages/krm_spirit_crystal.xml", "krm_spirit_crystal.tex")

STRINGS.NAMES.KRM_SPIRIT_CRYSTAL = "二亚的灵结晶 "
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KRM_SPIRIT_CRYSTAL = "阿拉阿拉，真是意料之外的力量啊"

local assets =
{
    Asset("ANIM", "anim/krm_spirit_crystal.zip"),
    Asset("ATLAS", "images/inventoryimages/krm_spirit_crystal.xml"),
    Asset("IMAGE", "images/inventoryimages/krm_spirit_crystal.tex"),
}
--------红宝石：1
local function healowner(inst, owner)
    if (owner.components.health and owner.components.health:IsHurt() and not owner.components.oldager)
        and (owner.components.hunger and owner.components.hunger.current > 5) then
        owner.components.health:DoDelta(TUNING.REDAMULET_CONVERSION, false, "redamulet")
        owner.components.hunger:DoDelta(-TUNING.REDAMULET_CONVERSION)
    end
end
local function onequip_red(inst, owner)
    inst.task = inst:DoPeriodicTask(TUNING.REDAMULET_CONVERSION_TIME, healowner, nil, owner)
end
local function onunequip_red(inst, owner)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
end
------------
---蓝宝石：5
local function onequip_blue(inst, owner)
    inst.freezefn = function(attacked, data)
        if data and data.attacker and data.attacker.components.freezable then
            data.attacker.components.freezable:AddColdness(0.67)
            data.attacker.components.freezable:SpawnShatterFX()
        end
    end
    inst:ListenForEvent("attacked", inst.freezefn, owner)
end

local function onunequip_blue(inst, owner)
    if inst and inst.freezefn then
        inst:RemoveEventCallback("attacked", inst.freezefn, owner)
    end
end
--------------------紫宝石：4
local function onequip_purple(inst, owner)
    if owner.components.sanity ~= nil then
        owner.components.sanity:SetInducedInsanity(inst, true)
    end
end

local function onunequip_purple(inst, owner)
    if owner.components.sanity ~= nil then
        owner.components.sanity:SetInducedInsanity(inst, false)
    end
end
------绿宝石：4

local function onequip_green(inst, owner)
    if owner.components.builder ~= nil then
        owner.components.builder.ingredientmod = TUNING.GREENAMULET_INGREDIENTMOD
    end
end

local function onunequip_green(inst, owner)
    if owner.components.builder ~= nil then
        owner.components.builder.ingredientmod = 1
    end
end
-------橙宝石：2
local function pickup(inst, owner)
    local item = FindPickupableItem(owner, TUNING.ORANGEAMULET_RANGE, false)
    if item == nil then
        return
    end

    local didpickup = false
    if item.components.trap ~= nil then
        item.components.trap:Harvest(owner)
        didpickup = true
    end

    if owner.components.minigame_participator ~= nil then
        local minigame = owner.components.minigame_participator:GetMinigame()
        if minigame ~= nil then
            minigame:PushEvent("pickupcheat", { cheater = owner, item = item })
        end
    end

    --Amulet will only ever pick up items one at a time. Even from stacks.
    SpawnPrefab("sand_puff").Transform:SetPosition(item.Transform:GetWorldPosition())



    if not didpickup then
        local item_pos = item:GetPosition()
        if item.components.stackable ~= nil then
            item = item.components.stackable:Get()
        end

        owner.components.inventory:GiveItem(item, nil, item_pos)
    end
end
local function onequip_orange(inst, owner)
    inst.task2 = inst:DoPeriodicTask(TUNING.ORANGEAMULET_ICD, pickup, nil, owner)
end

local function onunequip_orange(inst, owner)
    if inst.task2 ~= nil then
        inst.task2:Cancel()
        inst.task2 = nil
    end
end
---------黄宝石：3

local function onequip_yellow(inst, owner)
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("yellowamuletlight")
    end
    inst._light.entity:SetParent(owner.entity)

    if owner.components.bloomer ~= nil then
        owner.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
    else
        owner.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end
end

local function turnoff_yellow(inst)
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end
end

local function onunequip_yellow(inst, owner)
    if owner.components.bloomer ~= nil then
        owner.components.bloomer:PopBloom(inst)
    else
        owner.AnimState:ClearBloomEffectHandle()
    end

    turnoff_yellow(inst)
end

----------------
local function onequip(inst, owner) ----装备
    -----------------------安装护符效果
    if inst and owner and inst.baoshinengli then
        if inst.baoshinengli == 1 then
            onequip_red(inst, owner)
        elseif inst.baoshinengli == 2 then
            onequip_orange(inst, owner)
        elseif inst.baoshinengli == 3 then
            onequip_yellow(inst, owner)
        elseif inst.baoshinengli == 4 then
            onequip_green(inst, owner)
        elseif inst.baoshinengli == 5 then
            onequip_blue(inst, owner)
        elseif inst.baoshinengli == 6 then
            onequip_purple(inst, owner)
        end
    end
    -------------------------------------
    -- if owner.components.builder ~= nil and inst.components.rechargeable:IsCharged() and not owner.components.builder.freebuildmode then
        -- owner.components.builder:GiveAllRecipes()
    -- end
    -- inst:ListenForEvent("builditem", inst.onitembuild, owner)
    -- inst:ListenForEvent("buildstructure", inst.onitembuild, owner)
end

local function onunequip(inst, owner) ----卸载
    -- if owner.components.builder ~= nil and owner.components.builder.freebuildmode then
        -- owner.components.builder:GiveAllRecipes()
    -- end
    -- inst:RemoveEventCallback("builditem", inst.onitembuild, owner)
    -- inst:RemoveEventCallback("buildstructure", inst.onitembuild, owner)
    ---------------------------------------------------------------------------卸载护符，不需要判定直接卸载
    if inst and owner then
        onunequip_red(inst, owner)
        onunequip_blue(inst, owner)
        onunequip_purple(inst, owner)
        onunequip_green(inst, owner)
        onunequip_orange(inst, owner)
        onunequip_yellow(inst, owner)
    end
end

local function onunequip2(inst, owner, from_ground) ----卸载2，
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
	if inst and inst.freezefn then
    inst:RemoveEventCallback("attacked", inst.freezefn, owner)
	end
    if owner.components.sanity ~= nil then
        owner.components.sanity:SetInducedInsanity(inst, false)
    end
    if owner.components.builder ~= nil then
        owner.components.builder.ingredientmod = 1
    end
    if inst.task2 ~= nil then
        inst.task2:Cancel()
        inst.task2 = nil
    end

    if owner.components.bloomer ~= nil then
        owner.components.bloomer:PopBloom(inst)
    else
        owner.AnimState:ClearBloomEffectHandle()
    end

    turnoff_yellow(inst)
end


local function OnCharged(inst)
    if inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        if owner and owner.components.builder ~= nil and inst.components.rechargeable:IsCharged() and not owner.components.builder.freebuildmode then
            owner.components.builder:GiveAllRecipes()
        end
    end
end
local function ShouldAcceptItem(inst, item, giver) ----接受物品
    if item and inst and inst.baoshinengli then
        if inst.baoshinengli ~= 1 and item.prefab == "redgem" or inst.baoshinengli ~= 2 and item.prefab == "orangegem" or inst.baoshinengli ~= 3 and item.prefab == "yellowgem" or inst.baoshinengli ~= 4 and item.prefab == "greengem" or inst.baoshinengli ~= 5 and item.prefab == "bluegem" or inst.baoshinengli ~= 6 and item.prefab == "purplegem" then
            return true
        end
    end
end
------红宝石：1 橙宝石：2 黄宝石：3 绿宝石：4 蓝宝石：5 紫宝石：6
local function OnGetItem(inst, giver, item) --参数:本物品实体，给予物品的人的实体，接收的物品实体
    if item and item.prefab == "redgem" then
        inst.baoshinengli = 1
    elseif item and item.prefab == "orangegem" then
        inst.baoshinengli = 2
    elseif item and item.prefab == "yellowgem" then
        inst.baoshinengli = 3
    elseif item and item.prefab == "greengem" then
        inst.baoshinengli = 4
    elseif item and item.prefab == "bluegem" then
        inst.baoshinengli = 5
    elseif item and item.prefab == "purplegem" then
        inst.baoshinengli = 6
    end

    if inst and inst.baoshinengli and inst.baoshinengli == 1 then
        if inst.components.named and STRINGS.NAMES.KRM_SPIRIT_CRYSTAL and STRINGS.NAMES.AMULET then
            inst.components.named:SetName(STRINGS.NAMES.KRM_SPIRIT_CRYSTAL .. "\n" .. STRINGS.NAMES.AMULET)
        end
        if inst.components.hauntable == nil then inst:AddComponent("hauntable") end
        if inst.components.hauntable then
            inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
                haunter:PushEvent("respawnfromghost", { source = inst })
                return true
            end)
        end
    else
        inst:RemoveComponent("hauntable")
    end

    if inst and inst.baoshinengli and inst.baoshinengli == 3 then
        if inst.components.named and STRINGS.NAMES.KRM_SPIRIT_CRYSTAL and STRINGS.NAMES.YELLOWAMULET then
            inst.components.named:SetName(STRINGS.NAMES.KRM_SPIRIT_CRYSTAL .. "\n" .. STRINGS.NAMES.YELLOWAMULET)
        end
		if inst.components.equippable then
		inst.components.equippable.walkspeedmult = 1.50
		end
    else
		if inst.components.equippable then
        inst.components.equippable.walkspeedmult = 1.25
		end
    end
	
    if inst and inst.baoshinengli and inst.baoshinengli == 2 then
        if inst.components.named and STRINGS.NAMES.KRM_SPIRIT_CRYSTAL and STRINGS.NAMES.ORANGEAMULET then
            inst.components.named:SetName(STRINGS.NAMES.KRM_SPIRIT_CRYSTAL .. "\n" .. STRINGS.NAMES.ORANGEAMULET)
        end
    elseif inst and inst.baoshinengli and inst.baoshinengli == 4 then
        if inst.components.named and STRINGS.NAMES.KRM_SPIRIT_CRYSTAL and STRINGS.NAMES.GREENAMULET then
            inst.components.named:SetName(STRINGS.NAMES.KRM_SPIRIT_CRYSTAL .. "\n" .. STRINGS.NAMES.GREENAMULET)
        end
    elseif inst and inst.baoshinengli and inst.baoshinengli == 5 then
        if inst.components.named and STRINGS.NAMES.KRM_SPIRIT_CRYSTAL and STRINGS.NAMES.BLUEAMULET then
            inst.components.named:SetName(STRINGS.NAMES.KRM_SPIRIT_CRYSTAL .. "\n" .. STRINGS.NAMES.BLUEAMULET)
        end
    elseif inst and inst.baoshinengli and inst.baoshinengli == 6 then
        if inst.components.named and STRINGS.NAMES.KRM_SPIRIT_CRYSTAL and STRINGS.NAMES.PURPLEAMULET then
            inst.components.named:SetName(STRINGS.NAMES.KRM_SPIRIT_CRYSTAL .. "\n" .. STRINGS.NAMES.PURPLEAMULET)
        end
    end
end


local function OnSave(inst, data)
    data.baoshinengli = inst.baoshinengli
end

local function onload(inst, data)
    if data ~= nil then
        if data.baoshinengli ~= nil then inst.baoshinengli = data.baoshinengli; end
    end
    OnGetItem(inst)
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("krm_spirit_crystal")
    inst.AnimState:SetBuild("krm_spirit_crystal")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("nonpackable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst:AddComponent("rechargeable")
    -- inst.components.rechargeable:SetOnChargedFn(OnCharged)

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/krm_spirit_crystal.xml"

    inst:AddComponent("named")

    inst:AddComponent("equippable")
    -- inst.components.equippable.restrictedtag = "kurumi"
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onunequip2)
	
	inst.components.equippable.walkspeedmult = 1.25
	 
	 
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
    inst.baoshinengli = 0
    inst:AddComponent("trader")                            --使物品可以接受给予
    inst.components.trader:SetAcceptTest(ShouldAcceptItem) --设置可以接受哪些东西，详细看上面的ShouldAcceptItem函数
    inst.components.trader.onaccept = OnGetItem            --设置接受物品后执行的程序,详细看上面的OnGetItem函数
    inst.components.trader.acceptnontradable = true        --设置是否接受没有tradable组件的东西，true为接受


    -- inst.onitembuild = function(owner, data)
        -- if owner and owner.components.builder ~= nil and owner.components.builder.freebuildmode then
            -- owner.components.builder:GiveAllRecipes()
            -- inst.components.rechargeable:Discharge(80 * 480)
        -- end
    -- end


    inst.OnSave = OnSave
    inst.OnLoad = onload


    return inst
end

return Prefab("krm_spirit_crystal", fn, assets)
