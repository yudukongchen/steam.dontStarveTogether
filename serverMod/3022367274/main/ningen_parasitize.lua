local enable_list = {
    'pigman',
    'pigguard',
    'merm',
    'mermguard',
    'bunnyman',
    'beefalo',
    'deer',
    'lightninggoat',
    'koalefant_summer',
    'koalefant_winter',
    'walrus',
    'little_walrus',
    'powder_monkey',
    'prime_mate'
}

local function _modify(inst)
    if TheWorld.ismastersim then
        if not inst:HasTag('aria') then
            inst:AddComponent('can_be_parasitized_by_ningen')
        end
    end
end

for _, v in pairs(enable_list) do
    AddPrefabPostInit(v, _modify)
end

AddPlayerPostInit(_modify)

local ningen_parasitize =
    State {
    name = 'ningen_parasitize',
    tags = {'nomorph', 'busy', 'nopredict', 'nodangle', 'drowning', 'notalking', 'hiding'},
    onenter = function(inst)
        inst:RemoveTag('player')
        RemovePhysicsColliders(inst)
        inst.Physics:Stop()
        inst.AnimState:PlayAnimation('hide_idle', false)
    end,
    onexit = function(inst)
        inst:AddTag('player')
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:CollidesWith(COLLISION.OBSTACLES)
        inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
        inst.Physics:CollidesWith(COLLISION.CHARACTERS)
        inst.Physics:CollidesWith(COLLISION.GIANTS)
    end
}
AddStategraphState('wilson', ningen_parasitize)
AddStategraphState('wilson_client', ningen_parasitize)

local function LEAVE(inst)
    if inst:HasTag('ningen') and inst:HasTag('on_parasitizing') then
        inst.components.ningen_parasitize:Leave()
    end
end

AddModRPCHandler('ningen', 'LEAVE', LEAVE)

TheInput:AddKeyDownHandler(
    GLOBAL.KEY_S,
    function()
        local IsHUDscreen = GLOBAL.TheFrontEnd:GetActiveScreen() and GLOBAL.TheFrontEnd:GetActiveScreen().name == 'HUD'
        if IsHUDscreen then
            SendModRPCToServer(MOD_RPC['ningen']['LEAVE'])
        end
    end
)
