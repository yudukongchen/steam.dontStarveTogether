local assets =
{
    Asset("ANIM", "anim/foodbox.zip"),
	Asset("ATLAS", "images/inventoryimages/foodbox.xml"),
    Asset("IMAGE", "images/inventoryimages/foodbox.tex"),
	Asset("ATLAS", "images/inventoryimages/foodboxopen.xml"),
    Asset("IMAGE", "images/inventoryimages/foodboxopen.tex"),
}

local function onopen(inst)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/foodboxopen.xml"
	        inst.components.inventoryitem:ChangeImageName("foodboxopen")
			 inst.AnimState:PlayAnimation("open")
end

local function onclose(inst)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/foodbox.xml"
	        inst.components.inventoryitem:ChangeImageName("foodbox")
			 inst.AnimState:PlayAnimation("idle")
end

local function itemtest(inst, item, slot)
    if item.components.edible or item.prefab == "heatrock" or item.prefab == "hambat" then
	   return true
    end
    return false
end

local params = {}
local containers = require("containers")
params.foodbox = {
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
        table.insert(params.foodbox.widget.slotpos, Vector3(75*x-75*2+75, 75*y-75*2+75,0))
    end
end

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.foodbox.widget.slotpos ~= nil and #params.foodbox.widget.slotpos or 0)

local containers_widgetsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data)
    local t = prefab or container.inst.prefab
    if t == "foodbox" then
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

    inst.AnimState:SetBank("foodbox")
    inst.AnimState:SetBuild("foodbox")
    inst.AnimState:PlayAnimation("idle")
	inst:AddTag("fridge")  
	
	if not TheWorld.ismastersim then
    	return inst
    end
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/foodbox.xml"
	inst.components.inventoryitem.cangoincontainer = true

    inst:AddComponent("container")
    inst.components.container.itemtestfn = itemtest
	inst.components.container:WidgetSetup("foodbox")
	inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    return inst
end

return Prefab("foodbox", fn, assets, prefabs)





