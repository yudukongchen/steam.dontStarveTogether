GLOBAL.setmetatable(env,{__index = function(t, k)return GLOBAL.rawget(GLOBAL, k) end})
local containers = require "containers"
local params = containers.params

-------------------------------------------------------------------------------
params.tz_fhym =
{
    widget =
    {
        slotpos = {},
        -- slotbg = {},
        animbank = "ui_alterguardianhat_1x6",
        animbuild = "ui_alterguardianhat_1x6",
        pos = Vector3(0, 150, 0),
		buttoninfo =
        {
            text = "开关",
            position = Vector3(0, 150, 0),
        }
    },
    type = "hand_inv",
}

for i = 0, 4 do
    table.insert(params.tz_fhym.widget.slotpos, Vector3(0, 95 - (i*72), 0))
end
function params.tz_fhym.widget.buttoninfo.fn(inst,doer)
	if TheWorld.ismastersim then
        inst:onoff(doer)
	else
		SendModRPCToServer(MOD_RPC["tz_fhym"]["tz_fhym"],inst)
    end
end
AddModRPCHandler("tz_fhym","tz_fhym",function(player,inst)
	 if inst and type(inst.onoff)=="function" then
		inst:onoff(player)
	end
end)

params.tz_fh_ys =
{
    widget =
    {
        slotpos = {
            Vector3(0, 2, 0),
        },
        animbank = "ui_antlionhat_1x1",
        animbuild = "ui_antlionhat_1x1",
        pos = Vector3(53, 40, 0),
    },
    type = "hand_inv",
    excludefromcrafting = true,
}
-------------------------------------------------------------------------------

params.tz_swordcemetery = {
    widget = {
        slotpos = {},
        animbank = "ui_chester_shadow_3x4",
        animbuild = "ui_tz_swordcemetery_1x4",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160
    },
    type = "chest",
    acceptsstacks = false,
	openlimit = 1,
}
for x = -0.5, 2.5, 1 do
    table.insert(params.tz_swordcemetery.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, -80 * 2 + 80 + 80, 0))
end
--malibag
params.tz_malibag = {
    widget = {
        slotpos = {},
        animbank = "ui_icepack_2x3",
        animbuild = "ui_malibag_2x3",
        pos = Vector3(-5, -70, 0)
    },
    issidewidget = true,
    type = "pack",
	openlimit = 1,
}
function params.tz_malibag.itemtestfn(container, item, slot)
    if not (item:HasTag("tz_malibag") or item:HasTag("chester_eyebone") 
		or item:HasTag("hutch_fishbowl") or item.prefab == "atrium_key") then
        return true
    end
end
for y = 0, 2 do
    table.insert(params.tz_malibag.widget.slotpos, Vector3(-162, -75 * y + 75, 0))
    table.insert(params.tz_malibag.widget.slotpos, Vector3(-162 + 75, -75 * y + 75, 0))
end

--这其实是lostearthgai，原作者命名有误
params.lostchester_gai = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_tz_pi_1x1",
        pos = Vector3(40, 180, 0),
        side_align_tip = 160
    },
    type = "chest",
	openlimit = 1,
}
function params.lostchester_gai.itemtestfn(container, item, slot)
    return item.prefab == "nightmarefuel"
end
table.insert(params.lostchester_gai.widget.slotpos, Vector3(80 * 1 - 80 * 2 + 80, 80 * 1 - 80 * 2 + 80, 0))

--lostchester
params.lostchester = {
    widget = {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(0, 220, 0),
		side_align_tip = 160,
    },
    --issidewidget = true,
    type = "chest",
	openlimit = 1,
}
for y = 0, 3 do
    table.insert(params.lostchester.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(params.lostchester.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

params.lostchestergai = {
    widget = {
        slotpos = {},
        animbank = "ui_chester_shadow_3x4",
        animbuild = "ui_chester_shadow_3x4",
        pos = Vector3(0, 220, 0),
		side_align_tip = 160,
    },
    --issidewidget = true,
    type = "chest",
	openlimit = 1,
}
function params.lostchestergai.itemtestfn(container, item, slot)
    if not item:HasTag("lostchestergai") then
        return true
    end
end
for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(params.lostchestergai.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
    end
end

params.tz_elong_box = {
    widget = {
        slotpos = {},
        animbank = "ui_chester_shadow_3x4",
        animbuild = "ui_chester_shadow_3x4",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160
    },
    type = "tz_elong_box",
	openlimit = 1,
}
for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(params.tz_elong_box.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
    end
end

params.ta_wzk_armor = params.piggyback

params.tz_fh_nx =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_fh_nx_7x7",
        pos = Vector3(-5-115, -70, 0),
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1,
}

for y = -2, 4 do
    for k = -5 ,1 do
        table.insert(params.tz_fh_nx.widget.slotpos, Vector3(-127+ k*75 + 2*75, -75 * y + 80, 0))
    end
end

for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

AddPrefabPostInit("lostchester_gai",function(inst)
	if not GLOBAL.TheWorld.ismastersim then
        inst:DoTaskInTime(0, function()
            if inst.replica then
                if inst.replica.container then
                    inst.replica.container:WidgetSetup("lostchestergai")
                end
            end
        end)
        return inst
    end
    if GLOBAL.TheWorld.ismastersim then
        if not inst.components.container then
            inst:AddComponent("container")
            inst.components.container:WidgetSetup("lostchestergai")
        end
    end
end)
