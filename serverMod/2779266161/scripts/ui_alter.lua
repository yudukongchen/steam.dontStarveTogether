require("prefabs/veggies")

local containers = require("containers")
local params = {}

local containers_widgetsetup = containers.widgetsetup or function() return true end
function containers.widgetsetup(container, prefab, data, ...)
	local pfb = prefab or container.inst.prefab
	if pfb == "auto_seeding_machine" or pfb == "auto_harvest_machine" or pfb == "jinkela_machine" then
		local pfbw = params[pfb]
		if pfbw ~= nil then
			for k, v in pairs(pfbw) do
				container[k] = v
			end
			container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
		end
	else
		-- 针对游戏内容器，用原始的函数来处理
		return containers_widgetsetup(container, prefab, data, ...)
	end
end

params.auto_seeding_machine =
{
    widget = {
        slotpos = {Vector3(0,40,0)},
        animbank = "ui_seeding_1x1",
        animbuild = "ui_seeding_1x1",
        pos = Vector3(0,0,0),
        buttoninfo = {
            text = STRINGS.SEED_BUTTOM,
            position = Vector3(0, -20, 0),
        },
    },
    numslots=1,
    acceptsstacks=true,
    usespecificslotsforitems=false,
    issidewidget=false,
    type="seeding",
    itemtestfn = function(inst, item, slot)
        if item:HasTag("deployedplant") and item:HasTag("cookable") and item.prefab~="acorn" then
            return true
        else return false
        end
    end
}
function auto_seeding_machineFn(player,inst)
    inst.components.container:Close(inst.owner)
    inst.checkforfarm(inst, player)
end
function auto_seeding_machine_validFn(player,inst)
    if not inst.components.container:IsEmpty() then
        inst.isvalid:set(true)
        return true
    else    
        inst.isvalid:set(false)
        return false
    end
end
function params.auto_seeding_machine.widget.buttoninfo.fn(inst)
    if TheWorld.ismastersim then
        auto_seeding_machineFn(ThePlayer, inst)
    else
        SendModRPCToServer(MOD_RPC["auto_seeding_machine"]["auto_seeding_machineFn"], inst)
    end
end
function params.auto_seeding_machine.widget.buttoninfo.validfn(inst)
    if TheWorld.ismastersim then
        return auto_seeding_machine_validFn(nil,inst)
    else
        SendModRPCToServer(MOD_RPC["auto_seeding_machine"]["auto_seeding_machine_validFn"], inst)
        return inst.isvalid:value()
    end
end
AddModRPCHandler("auto_seeding_machine", "auto_seeding_machineFn", auto_seeding_machineFn)
AddModRPCHandler("auto_seeding_machine", "auto_seeding_machine_validFn", auto_seeding_machine_validFn)

params.auto_harvest_machine = 
{
    widget = {
        slotpos = {},
        animbank = "bg_5x5",
        animbuild = "bg_5x5",
        pos = Vector3(0,200,0),
    },
    numslots=25,
    acceptsstacks=true,
    usespecificslotsforitems=false,
    issidewidget=false,
    type="harvest",
    itemtestfn = function(inst, item, slot)
        if VEGGIES[item.prefab] or TUNING.EA_LEGION_ITEM[item.prefab]
        or (item:HasTag("deployedplant") and item:HasTag("cookable") and item.prefab~="acorn") then
            return true
        end
        return false
    end
}
for y = 3, -1, -1 do
    for x = -1, 3 do
			table.insert(params.auto_harvest_machine.widget.slotpos, Vector3(80*x-80*2+80, 80*y-80*2+80, 0))
	end
end

params.jinkela_machine =
{
    widget = {
        slotpos = {Vector3(0,40,0)},
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0,0,0),
        buttoninfo = {
            text = STRINGS.JINKELA_BUTTOM,
            position = Vector3(0, -20, 0),
        },
    },
    numslots=1,
    acceptsstacks=true,
    usespecificslotsforitems=false,
    issidewidget=false,
    type="seeding",
}
function jinkela_machineFn(player,inst)
    inst.components.container:Close(inst.owner)
    inst.onproduce(inst, player)
end
function jinkela_machine_validFn(player,inst)
    if not inst.components.container:IsEmpty() then
        inst.isvalid:set(true)
    else    
        inst.isvalid:set(false)
    end
    return inst.isvalid:value()
end
function params.jinkela_machine.widget.buttoninfo.fn(inst)      --inst:机器实例
    SendModRPCToServer(MOD_RPC["jinkela_machine"]["jinkela_machineFn"], inst)
end
function params.jinkela_machine.widget.buttoninfo.validfn(inst)
    SendModRPCToServer(MOD_RPC["jinkela_machine"]["jinkela_machine_validFn"], inst)
    return inst.isvalid:value()
end
AddModRPCHandler("jinkela_machine", "jinkela_machineFn", jinkela_machineFn)
AddModRPCHandler("jinkela_machine", "jinkela_machine_validFn", jinkela_machine_validFn)

local function ContainerCanOpenInit(self)
    self.canopen = true
    local old = self.Open
    self.Open = function (self,doer)
        if self.canopen then
            old(self,doer)
        end
    end
end
AddComponentPostInit("container", ContainerCanOpenInit)