require "behaviours/chaseandattack"
require "behaviours/standstill"

local TzPugalisk_tailBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function WantToAttackBack(inst)
    return inst.TailShouldAttackCnt and inst.TailShouldAttackCnt > 0
end

local function IsCrazy(inst)
    return inst.host 
        and inst.host.CrazyFantabBaldeStartTime 
        and GetTime() - inst.host.CrazyFantabBaldeStartTime <= 30
end

function TzPugalisk_tailBrain:OnStart()
    local root =
        PriorityNode(
        {              
            -- ChaseAndAttack(self.inst),            
            -- inst.
            IfNode(function() 
                return WantToAttackBack(self.inst) and not IsCrazy(self.inst)
            end, 
            "CanLaunchBlade",
            DoAction(self.inst, function() 
                if not self.inst.sg:HasStateTag("busy") 
                    and not self.inst.sg:HasStateTag("attack") then 

                    local attacker = self.inst.components.combat.lastattacker
                    if self.inst.components.combat:CanTarget(attacker) 
                        and not self.inst.components.combat:IsAlly(attacker) then
                       
                        if self.inst:IsNear(attacker,16) then
                            self.inst.sg:GoToState("attack_tail",attacker:GetPosition())
                        else 
                            local roa = GetRandomMinMax(0,2 * PI)
                            local offset = Vector3(math.cos(roa),0,math.sin(roa))
                            self.inst.sg:GoToState("attack_tail",self.inst:GetPosition() + offset)
                        end

                        self.inst.TailShouldAttackCnt = self.inst.TailShouldAttackCnt - 1 
                    end
                end
            end)
            ),

            IfNode(function() 
                return 
                    not self.inst.sg:HasStateTag("busy") 
                    and not self.inst.sg:HasStateTag("attack")
                    and IsCrazy(self.inst)
            end, 
            "CanLaunchCrazyBlade",
            DoAction(self.inst, function() 
                if not self.inst.sg:HasStateTag("busy") 
                    and not self.inst.sg:HasStateTag("attack") then 

                    local possible_players = {} 
                    for k,v in pairs(AllPlayers) do
                        if v and v:IsValid() 
                            and self.inst.components.combat:CanTarget(v) 
                            and not self.inst.components.combat:IsAlly(v)
                            and self.inst:IsNear(v,28) then
                            
                            table.insert(possible_players,v)
                        end
                    end

                    local player = #possible_players > 0 and possible_players[math.random(1,#possible_players)] or nil 
                    if player then
                        self.inst.sg:GoToState("attack_tail",player:GetPosition())
                    else 
                        local roa = GetRandomMinMax(0,2 * PI)
                        local offset = Vector3(math.cos(roa),0,math.sin(roa))
                        self.inst.sg:GoToState("attack_tail",self.inst:GetPosition() + offset)
                    end

                end
            end)
            ),
            StandStill(self.inst,function()
                return not WantToAttackBack(self.inst) and not IsCrazy(self.inst)
            end,function()
                return not WantToAttackBack(self.inst) and not IsCrazy(self.inst)
            end)

        },1)
    
    self.bt = BT(self.inst, root)        
end

return TzPugalisk_tailBrain
