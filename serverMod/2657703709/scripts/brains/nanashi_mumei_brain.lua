require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/chaseandattack"
require "behaviours/standstill"

local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 5
local MAX_WANDER_DIST = 20
local SEE_TARGET_DIST = 6

local MAX_CHASE_DIST = 10
local MAX_CHASE_TIME = 40


local MumeiBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)
local function findweapon(inst)
    local items = inst.components.inventory:FindItems(function(inst) return inst.components.weapon end)
    local strongest
    for _, value in ipairs(items) do
        if not strongest then
            strongest = value
        elseif strongest.components.weapon.damage < value.components.weapon.damage then
            strongest = value
        end
    end
    if strongest then
        inst.components.inventory:Equip(strongest)
    end
end

local function LookForWeapon(inst) --Look for things to take food from (EatFoodAction handles picking up/ eating)
    -- Food On Ground > Pots = Farms = Drying Racks > Beebox > Mushroom Farm > Look In Fridge > Chests > Backpacks (on ground) > Plants
    findweapon(inst)
    if inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        return
    end
    if inst.sg:HasStateTag("busy")
        or (inst.components.container ~= nil and
            inst.components.container:IsFull()) then
        return
    end

    local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "burnt" }

    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 30, nil, NO_TAGS)
    local targets = {}

    --Gather all targets in one pass
    for i, item in ipairs(ents) do
            if item:IsValid() and item:IsOnValidGround() then
                if targets.pickable == nil and item.components.weapon
                then
                targets.pickable = item
                break
            end
        end
    end

    --Pick action by priority on all gathered targets
    if targets.pickable ~= nil then
        return BufferedAction(inst, targets.pickable, ACTIONS.PICKUP)
    end
end


local function KillAttack(inst)
    if TheWorld.ismastersim then
        local target = inst.components.combat.target
        if target.components.health:GetPercent() <= 0 then
            target = nil
        end
        if target then
            inst:PushEvent("nanashi_mumei_killer_attack")
        end
        return target ~= nil 
        and BufferedAction(inst, target, ACTIONS.ATTACK) or nil
    -- else
    --     local target = inst.replica.combat:GetTarget()
    --     if target.replica.health:GetPercent() <= 0 then
    --         target = nil
    --     end
    --     return target ~= nil 
    --     and BufferedAction(inst, target, ACTIONS.ATTACK) or nil
    else
        return
    end
end
local function Heal(inst)
    local items = inst.components.inventory.itemslots
    local target
    for _, value in pairs(items) do
        if value and value.components.edible and value.components.edible.healthvalue > 0 and inst.components.eater:CanEat(value) then
            target = value
            break
        end
    end
    return target ~= nil  and BufferedAction(inst, target, ACTIONS.EAT) or nil
end
function MumeiBrain:OnStart()
    self.inst:ListenForEvent("oneat",function (inst,data)
        if KnownModIndex:IsModEnabled("workshop-2039181790") 
        or KnownModIndex:IsModEnabled("workshop-2751937554")
        and data and data.food.components.edible.healthvalue >= 0 then -- Uncompromising mod healing cooldown
            inst.components.timer:StartTimer("heal_cd", 10)
        end
    end)
    local root = PriorityNode(
    {
        WhileNode(function() return 
            (self.inst.components.health and self.inst.components.health:GetPercent() < 0.5 and TheWorld.ismastersim
            and self.inst.components.inventory and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS))
            and self.inst:GetBufferedAction() and self.inst:GetBufferedAction().action ~= ACTIONS.EAT 
            and TUNING.NANASHI_MUMEI_KILLER_AUTOHEAL
            and not self.inst.components.timer:TimerExists("heal_cd")
        end, "Heal",DoAction(self.inst, Heal, "Heal",true,0.05)),
        WhileNode(function() return 
            (self.inst.components.inventory and not self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and TheWorld.ismastersim)
            and self.inst:GetBufferedAction() and self.inst:GetBufferedAction().action ~= ACTIONS.PICKUP
            -- or self.inst.replica.inventory and not self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) 
        end, "ItemDoko",DoAction(self.inst, LookForWeapon, "FindItem",true,0.05)),
        WhileNode(function() return self.inst._nanashi_mumei_killer:value() and
              (self.inst.components.combat and self.inst.components.combat.target and not self.inst.components.combat:InCooldown())
              or(ThePlayer and self.inst == ThePlayer and ThePlayer.components.locomotor 
              and self.inst.replica.combat and self.inst.replica.combat:GetTarget() and not self.inst.replica.combat:InCooldown())
              and self.inst:GetBufferedAction() and self.inst:GetBufferedAction().action ~= ACTIONS.ATTACK 
              and self.inst:GetBufferedAction().action  ~= ACTIONS.EAT
            end, "KillKill",DoAction(self.inst, KillAttack, "KillAll", true,0.05)),
    },0.25)

    self.bt = BT(self.inst, root)

end

return MumeiBrain
