local assets =
{
    Asset("ANIM", "anim/nanashi_mumei_friend.zip"),

    Asset( "IMAGE", "images/inventoryimages/nanashi_mumei_friend.tex" ),
    Asset( "ATLAS", "images/inventoryimages/nanashi_mumei_friend.xml" ),
}

local brain = require "brains/nanashi_mumei_friend_brain"

local function OnOpen(inst)
    inst.sg:GoToState("land")
    inst.SoundEmitter:PlaySound("mumei_sounds/mumei/mumei_paperbag_open")
end

local function OnClose(inst)
    inst.sg:GoToState("action_done")
    inst.SoundEmitter:PlaySound("mumei_sounds/mumei/mumei_paperbag_close")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1, .3)

    inst.DynamicShadow:SetSize(1, .33)
    inst.Transform:SetSixFaced()

    inst.AnimState:SetBank("nanashi_mumei_friend")
    inst.AnimState:SetBuild("nanashi_mumei_friend")
    inst.AnimState:PlayAnimation("idle_loop",true)

    inst.entity:AddPhysics()
    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith((TheWorld.has_ocean and COLLISION.GROUND) or COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.FLYERS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetCapsule(.5, 1)

    inst:AddTag("flying")
    inst:AddTag("ignorewalkableplatformdrowning")

    MakeInventoryFloatable(inst)

    inst:AddTag("companion")
    inst:AddTag("notraptrigger")
    inst:AddTag("noauradamage")
    inst:AddTag("small_livestock")
    inst:AddTag("NOBLOCK")
    inst:AddTag("nanashi_mumei_friend")

    inst.entity:SetPristine()

    inst:AddComponent("spawnfader")


    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("chester")
		end
        return inst
    end


    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.softstop = true
    inst.components.locomotor.walkspeed = TUNING.CRITTER_WALK_SPEED * 1.1
    inst.components.locomotor.pathcaps = { allowocean = true }


    inst:AddComponent("knownlocations")

    -- MakeHauntablePanic(inst)

    inst:AddComponent("inspectable")


    inst:AddComponent("thief")

    inst:AddComponent("follower")
    inst.components.follower:KeepLeaderOnAttacked()
    inst.components.follower.keepdeadleader = true
    inst.components.follower.keepleaderduringminigame = true

    inst:SetBrain(brain)

    inst._friend_fx = inst:SpawnChild("nanashi_mumei_friend_fx")
    inst._friend_fx.Follower:FollowSymbol(inst.GUID,"glomling_body", 0, 0, 0)

    inst:SetStateGraph("SGnanashi_mumei_friend")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("chester")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true
    local oldtakeitem = inst.components.container.CanTakeItemInSlot
    
    local allowed_item = {"berries","berries_cooked","berries_juicy","berries_juicy_cooked","wormlight","wormlight_lesser"}
    inst.components.container.CanTakeItemInSlot = function (self,item, slot)
        for _, value in pairs(allowed_item) do
            if item.prefab == value then
                return oldtakeitem(self,item, slot)
            end
        end
        return false
    end

    inst.persists = false

    inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(TUNING.PERISH_SALTBOX_MULT)

    return inst
end

local function builder_onbuilt(inst, builder)
    local theta = math.random() * 2 * PI
    local pt = builder:GetPosition()
    local radius = 1
    local offset = FindWalkableOffset(pt, theta, radius, 6, true)
    if offset ~= nil then
        pt.x = pt.x + offset.x
        pt.z = pt.z + offset.z
    end
    builder.components.petleash:SpawnPetAt(pt.x, 0, pt.z, inst.pettype)
    inst:Remove()
end

local function MakeBuilder(prefab)
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

        inst.pettype = prefab
        inst.OnBuiltFn = builder_onbuilt

        return inst
    end

    return Prefab(prefab.."_builder", fn, nil, { prefab })
end

local function fn_fx()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddFollower()
    -- inst.entity:AddLight()

    inst.AnimState:SetBank("fireflies")
    inst.AnimState:SetBuild("fireflies")
    inst.AnimState:PlayAnimation("swarm_pre")
    inst.AnimState:PushAnimation("swarm_loop", true)
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(3)
    inst.AnimState:SetSortOrder(3)
    -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.BillBoard)
    inst.AnimState:SetLayer(LAYER_WORLD)
    local scale = 1
    inst.AnimState:SetScale(scale,scale,scale)
    local transparency = 0.5
    inst.AnimState:SetMultColour(transparency,transparency,1,transparency)
    inst.Transform:SetPosition(0,5,0)

    
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persist = false

    return inst
end

return Prefab("nanashi_mumei_friend", fn, assets),
    Prefab("nanashi_mumei_friend_fx", fn_fx),
    MakeBuilder("nanashi_mumei_friend")

