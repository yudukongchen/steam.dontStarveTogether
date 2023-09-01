local function MooseGooseRandomizeName(inst)
    inst._altname:set(math.random() < .5)
end

local PIECES =
{
    {name="pawn",			moonevent=false,    gymweight=3},
    {name="rook",			moonevent=true,     gymweight=3},
    {name="knight",			moonevent=true,     gymweight=3},
    {name="bishop",			moonevent=true,     gymweight=3},
    {name="muse",			moonevent=false,    gymweight=3},
    {name="formal",			moonevent=false,    gymweight=3},
    {name="hornucopia",		moonevent=false,    gymweight=3},
    {name="pipe",			moonevent=false,    gymweight=3},

    {name="deerclops",		moonevent=false,    gymweight=4},
    {name="bearger",		moonevent=false,    gymweight=4},
    {name="moosegoose",		moonevent=false,    gymweight=4,
        common_postinit = function(inst)
            inst._altname = net_bool(inst.GUID, "chesspiece_moosegoose._altname")
            inst.displaynamefn = function(inst)
                return inst._altname:value() and STRINGS.NAMES[string.upper(inst.prefab).."_ALT"] or nil
            end
        end,
        master_postinit = function(inst)
            inst:DoPeriodicTask(5, MooseGooseRandomizeName)
            MooseGooseRandomizeName(inst)
        end,
    },
    {name="dragonfly",		moonevent=false,    gymweight=4},
    {name="clayhound",		moonevent=false,    gymweight=3},
    {name="claywarg",		moonevent=false,    gymweight=3},
    {name="butterfly",		moonevent=false,    gymweight=3},
    {name="anchor",			moonevent=false,    gymweight=3},
    {name="moon",			moonevent=false,    gymweight=4},
    {name="carrat",			moonevent=false,    gymweight=3},
    {name="beefalo",		moonevent=false,    gymweight=3},
    {name="crabking",		moonevent=false,    gymweight=4},
    {name="malbatross",		moonevent=false,    gymweight=4},
    {name="toadstool",		moonevent=false,    gymweight=4},
    {name="stalker",		moonevent=false,    gymweight=4},
    {name="klaus",			moonevent=false,    gymweight=4},
    {name="beequeen",		moonevent=false,    gymweight=4},
    {name="antlion",		moonevent=false,    gymweight=4},
    {name="minotaur",		moonevent=false,    gymweight=4},
    {name="guardianphase3", moonevent=false,    gymweight=4},
    {name="eyeofterror",	moonevent=false,    gymweight=4},
    {name="twinsofterror",	moonevent=false,    gymweight=4},
    {name="kitcoon",		moonevent=false,    gymweight=3},
    {name="catcoon",		moonevent=false,    gymweight=3},
    {name="manrabbit",      moonevent=false,    gymweight=3},
}

local MOON_EVENT_RADIUS = 12
local MOON_EVENT_MINPIECES = 3

local MOONGLASS_NAME = "moonglass"
local MATERIALS =
{
    {name="marble",         prefab="marble",        inv_suffix=""},
    {name="stone",          prefab="cutstone",      inv_suffix="_stone"},
    {name=MOONGLASS_NAME,   prefab="moonglass",  inv_suffix="_moonglass"},
}
--------------------------------------------------------------------------

local function builderonbuilt(inst, builder)
    local piece = SpawnPrefab("chesspiece_"..PIECES[inst.pieceid].name.."_marble")
    piece.Transform:SetPosition(builder.Transform:GetWorldPosition())

    inst:Remove()
end

local function makebuilder(pieceid)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()

        inst:AddTag("CLASSIFIED")

        --[[Non-networked entity]]
        inst.persists = false

        --Auto-remove if not spawned by builder
        inst:DoTaskInTime(0, inst.Remove)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.pieceid = pieceid
        inst.OnBuiltFn = builderonbuilt  --STRINGS.NAMES.CHESSPIECE_HORNUCOPIA_BUILDER

        return inst
    end

    return Prefab("stu_chesspiece_"..PIECES[pieceid].name.."_builder", fn, nil, { "chesspiece_"..PIECES[pieceid].name })
end

--------------------------------------------------------------------------

local chesspieces = {}
for p = 1,#PIECES do
    STRINGS.NAMES[string.upper("stu_chesspiece_"..PIECES[p].name.."_builder")] = STRINGS.NAMES[string.upper("chesspiece_"..PIECES[p].name.."_builder")] 
    STRINGS.RECIPE_DESC[string.upper("stu_chesspiece_"..PIECES[p].name.."_builder")] = STRINGS.RECIPE_DESC[string.upper("chesspiece_"..PIECES[p].name.."_builder")] 
    table.insert(chesspieces, makebuilder(p))
end

return unpack(chesspieces)
