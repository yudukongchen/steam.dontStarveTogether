local assets =
{
    Asset("ANIM", "anim/swap_change_backpack.zip"),
    Asset("ANIM", "anim/ui_backpack_2x4.zip"),
	
	Asset( "IMAGE", "images/inventoryimages/change_backpack.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_backpack.xml" ),
}

local containers = require("containers")
local widgetsetup_old = containers.widgetsetup

local change_backpack = --------全局变量
{
    widget =
    {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(-5, -70, 0),
    },
    issidewidget = true,
    type = "pack",
}

for y = 0, 3 do
    table.insert(change_backpack.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(change_backpack.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

function containers.widgetsetup(container, prefab, data, ...)
	if container.inst.prefab == "change_backpack" or prefab == "change_backpack" then
		for k, v in pairs(change_backpack) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        return
	end
    return widgetsetup_old(container, prefab, data, ...)
end


local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("backpack", "swap_change_backpack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_change_backpack", "swap_body")

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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_change_backpack")
    inst.AnimState:SetBuild("swap_change_backpack")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("backpack")

    inst.MiniMapEntity:SetIcon("backpack.png")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem.imagename = "change_backpack"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/change_backpack.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("container")
    --inst.components.container:WidgetSetup("backpack")
	inst.components.container:WidgetSetup("change_backpack",change_backpack)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("change_backpack", fn, assets)
