require "behaviours/chaseandattack"
require "behaviours/standstill"
local pu = require ("prefabs/tz_pugalisk_util")

local TzPugalisk_headBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function customLocomotionTest(inst)    
    if not inst.movecommited then
        pu.DetermineAction(inst)        
    end

    if inst.movecommited then
        return false
    end

    return true
end



local function DoSoundAttackSkill(inst)
    inst.LastSoundAttackTime = GetTime()

    local target = inst:PickSoundAttackTarget()

    if target then
        inst.sg:GoToState("sound_attack",{
            target = target,
            can_multi_cast = true,
        })
    end
end

local function DoRoarSkill(inst)
    inst.LastRoarTime = GetTime()

    local target = inst.components.combat.target 

    if target then
        inst.sg:GoToState("roar",{
            roar_cnt = TUNING.TZ_PUGALISK_CONFIG.ROAR_COUNT,
        })
    end
end

local function DoMeteorSkill(inst)
    inst.LastMeteorTime = GetTime()

    -- local low_percent = TUNING.TZ_PUGALISK_CONFIG.METEOR_LOW_HEALTH_PERCENT
    local is_big_meteor = inst:GetBrokenBodyCount() >= 2

    inst.sg:GoToState("meteor_summon",{
        summon_period = is_big_meteor and TUNING.TZ_PUGALISK_CONFIG.METEOR_BIG_PERIOD or TUNING.TZ_PUGALISK_CONFIG.METEOR_SMALL_PERIOD,
        damage_resolved_max = is_big_meteor and TUNING.TZ_PUGALISK_CONFIG.METEOR_BIG_ABORT_DAMAGE or TUNING.TZ_PUGALISK_CONFIG.METEOR_SMALL_ABORT_DAMAGE,
        is_big_meteor = is_big_meteor,
    })
end



function TzPugalisk_headBrain:OnStart()
    local root =
        PriorityNode(
        {  
            WhileNode(function() return customLocomotionTest(self.inst) and not self.inst.sg:HasStateTag("underground") end, "Be a head", 
                PriorityNode{
                    IfNode(function() return self.inst:CanCastSoundAttack() end, "CanSpawnSoundAttack",
                        DoAction(self.inst, function() DoSoundAttackSkill(self.inst) end)),
                    IfNode(function() return self.inst:CanCastRoar() end, "CanCastRoar",
                        DoAction(self.inst, function() DoRoarSkill(self.inst) end)),
                    IfNode(function() return self.inst:CanCastMeteor() end, "CanCastMeteor",
                        DoAction(self.inst, function() DoMeteorSkill(self.inst) end)),


                    ChaseAndAttack(self.inst),

                    StandStill(self.inst),
                }),
        },1)
    
    self.bt = BT(self.inst, root)        
end

function TzPugalisk_headBrain:OnInitializationComplete()
    self.inst.LastSoundAttackTime = GetTime()

    -- Start can use
    self.inst.LastRoarTime =  GetTime()

    self.inst.LastMeteorTime = GetTime()

    self.inst.LastLaserTime = GetTime()
end

return TzPugalisk_headBrain
