local assets =
{
    Asset("ANIM", "anim/toolbox.zip"),
	Asset("ATLAS", "images/inventoryimages/toolbox.xml"),
    Asset("IMAGE", "images/inventoryimages/toolbox.tex"),
	Asset("ATLAS", "images/inventoryimages/toolboxopen.xml"),
    Asset("IMAGE", "images/inventoryimages/toolboxopen.tex"),
}
local function onopen(inst)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/toolboxopen.xml"
	        inst.components.inventoryitem:ChangeImageName("toolboxopen")
			 inst.AnimState:PlayAnimation("open")
end

local function onclose(inst)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/toolbox.xml"
	        inst.components.inventoryitem:ChangeImageName("toolbox")
			 inst.AnimState:PlayAnimation("idle")
end

local function itemtest(inst, item, slot)
    if item.components.tool then
	   return true
    end
    return false
end

local params = {}
local containers = require("containers")
params.toolbox = {
  widget =
  {
      slotpos = {},
      animbank = "ui_chester_shadow_3x4",
      animbuild = "ui_chester_shadow_3x4",
      pos = Vector3(0, 200, 0),
      side_align_tip = 160,
  },
  type = "chest",
}

for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(params.toolbox.widget.slotpos, Vector3(75*x-75*2+75, 75*y-75*2+75,0))
    end
end

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.toolbox.widget.slotpos ~= nil and #params.toolbox.widget.slotpos or 0)

local containers_widgetsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data)
    local t = prefab or container.inst.prefab
    if t == "toolbox" then
        local t = params[t]
        if t ~= nil then
            for k, v in pairs(t) do
                container[k] = v
            end
            container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        end
    else
        return containers_widgetsetup(container, prefab)
    end
end


local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

	inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("toolbox")
    inst.AnimState:SetBuild("toolbox")
    inst.AnimState:PlayAnimation("idle")
	
	if not TheWorld.ismastersim then
    	return inst
    end
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/toolbox.xml"
	inst.components.inventoryitem.cangoincontainer = true

    inst:AddComponent("container")
    inst.components.container.itemtestfn = itemtest
	inst.components.container:WidgetSetup("toolbox")
	inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    return inst
end

return Prefab("toolbox", fn, assets, prefabs)





