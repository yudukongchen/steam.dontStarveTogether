local make_wet = Action({priority = 1, mount_valid = true})
make_wet.id = 'make_wet'
make_wet.str = '弄湿'
make_wet.fn = function(action)
    if action.doer.components.moisture then
        action.doer.components.moisture:SetPercent(
            math.min(action.doer.components.moisture:GetMoisturePercent() + .2, 1)
        )
    end
    return true
end
AddAction(make_wet)
AddStategraphActionHandler('wilson', ActionHandler(make_wet, 'dolongaction'))
AddStategraphActionHandler('wilson_client', ActionHandler(make_wet, 'dolongaction'))
AddComponentAction(
    'SCENE',
    'watersource',
    function(inst, doer, actions, right)
        if doer:HasTag('ningen') then
            table.insert(actions, make_wet)
        end
    end
)
------------------------------------------------
local offset = {
    pigman = {x = 0, y = .5, z = 0, mult = 1},
    pigguard = {x = 0, y = .5, z = 0, mult = 1},
    merm = {x = 0, y = .5, z = 0, mult = 1},
    mermguard = {x = 0, y = .5, z = 0, mult = 1.1},
    bunnyman = {x = 0, y = .5, z = 0, mult = 0.8},
    beefalo = {x = 0, y = .5, z = 0, mult = 1},
    deer = {x = 0, y = .5, z = 0, mult = 1},
    lightninggoat = {x = 0, y = .5, z = 0, mult = 1},
    koalefant_summer = {x = 0, y = .8, z = 0, mult = 1},
    koalefant_winter = {x = 0, y = .8, z = 0, mult = 1},
    walrus = {x = 0, y = .7, z = 0, mult = 0.7},
    little_walrus = {x = 0, y = .3, z = 0, mult = 1},
    powder_monkey = {x = 0, y = .5, z = 0, mult = 1},
    prime_mate = {x = 0, y = .5, z = 0, mult = 0.8}
}

local function LaunchItem(inst, item)
    if item.Physics ~= nil and item.Physics:IsActive() then
        local x, y, z = item.Transform:GetWorldPosition()
        item.Physics:Teleport(x, .1, z)

        local angle = math.random() * 2 * math.pi
        local speed = .75 + math.random() * .75
        item.Physics:SetVel(math.cos(angle) * speed, 5, math.sin(angle) * speed)
    end
end

local ningen_parasitize = Action({priority = 1, mount_valid = true})
ningen_parasitize.id = 'ningen_parasitize'
ningen_parasitize.str = '寄生'
ningen_parasitize.fn = function(action)
    local inst = action.doer
    local tar = action.target
    if (inst.components.rider and inst.components.rider:IsRiding()) or inst == tar then
        return false
    end
    if
        tar.components.combat and tar.components.health and not tar.components.health:IsDead() and
            not tar:HasTag('playerghost')
     then
        for _, v in pairs(inst.components.inventory.equipslots) do
            if v ~= nil then
                inst.components.inventory:DropItem(v)
                LaunchItem(inst, v)
            end
        end
        RemovePhysicsColliders(inst)
        if not tar.components.can_be_parasitized_by_ningen:SetTarget(inst) then
            return false
        end

        inst.components.ningen_parasitize:SetTarget(tar)
        inst.sg:GoToState('ningen_parasitize')
        inst.on_parasitifer_move =
            inst:DoPeriodicTask(
            0,
            function()
                local parasitifer = inst.components.ningen_parasitize.parasitifer
                if parasitifer and not parasitifer.components.health:IsDead() then
                    inst.Transform:SetPosition(parasitifer.Transform:GetWorldPosition())
                end
            end
        )
        local fx = SpawnPrefab('ningen_parasitize_fx')
        if tar:HasTag('player') then
            -- fx.Follower:FollowSymbol(tar.GUID, 'headbase', 0, 80, 0)
            inst.components.ningen_parasitize.fx = fx
            tar:AddChild(fx)
            fx.Transform:SetPosition(0, 0.5, 0)
        else
            fx.Transform:SetScale(offset[tar.prefab].mult, offset[tar.prefab].mult, offset[tar.prefab].mult)
            inst.components.ningen_parasitize.fx = fx
            tar:AddChild(fx)
            fx.Transform:SetPosition(offset[tar.prefab].x, offset[tar.prefab].y, offset[tar.prefab].z)
        end
    end
    return true
end
AddAction(ningen_parasitize)
AddStategraphActionHandler('wilson', ActionHandler(ningen_parasitize, 'give'))
AddStategraphActionHandler('wilson_client', ActionHandler(ningen_parasitize, 'give'))

----------------------------------------------------------------------------------

local ningen_deport = Action({priority = 10})
ningen_deport.id = 'ningen_deport'
ningen_deport.str = '驱逐'
ningen_deport.fn = function(action)
    local inst = action.doer
    -- local tar = action.target
    -- if inst ~= tar then
    --     return false
    -- end

    local parasite = inst.components.can_be_parasitized_by_ningen.parasite
    if parasite:HasTag('ningen') and parasite:HasTag('on_parasitizing') then
        parasite.components.ningen_parasitize:Leave()
    end
    return true
end
AddAction(ningen_deport)
AddStategraphActionHandler('wilson', ActionHandler(ningen_deport, 'give'))
AddStategraphActionHandler('wilson_client', ActionHandler(ningen_deport, 'give'))

AddComponentAction(
    'SCENE',
    'can_be_parasitized_by_ningen',
    function(inst, doer, actions, right)
        if right and inst == doer and inst:HasTag('be_parasitized_by_ningen') then
            table.insert(actions, ningen_deport)
        elseif doer:HasTag('ningen') then
            table.insert(actions, ningen_parasitize)
        end
    end
)
