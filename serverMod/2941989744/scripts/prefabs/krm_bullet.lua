local function AddBuff2(inst, time)
    if inst.krm_bullet_buff_task2 then
        inst.krm_bullet_buff_task2:Cancel()
        inst.krm_bullet_buff_task2 = nil
    end

    if inst.components.locomotor then
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "krm_bullet_buff2", 0.5)
    end

    if inst.components.combat then
        if inst.min_attack_period == nil then
            inst.min_attack_period = inst.components.combat.min_attack_period
        end
        inst.components.combat.min_attack_period = inst.min_attack_period * 1.5
    end

    inst.krm_bullet_buff_task2 = inst:DoTaskInTime(time, function() -- 时间结束后取消Buff
        -- print("移除buff2")
        inst.components.combat.min_attack_period = inst.min_attack_period or 1
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "krm_bullet_buff2")

        if inst.krm_bullet_buff_task2 then
            inst.krm_bullet_buff_task2:Cancel()
            inst.krm_bullet_buff_task2 = nil
        end
    end)
end

local GetGrowthStages = {0.7, 1, 1.25}

local GetLeif = {
    evergreen = "leif",
    evergreen_sparse = "leif_sparse"
}
local function spawn_leif(target)
    local leif = SpawnPrefab(GetLeif[target.prefab] or "leif")
    leif.AnimState:SetMultColour(target.AnimState:GetMultColour())
    leif:SetLeifScale(target.leifscale)

    local x, y, z = target.Transform:GetWorldPosition()
    target:Remove()

    leif.Transform:SetPosition(x, y, z)
    leif.sg:GoToState("spawn")
end

local function canspawn(item)
    return not item.noleif and item.components.growable ~= nil and item.components.growable.stage <= 3
end
local function AddBuff3fx(inst)
if inst then
    if inst.components.pickable then
        inst.components.pickable:FinishGrowing()
		SpawnPrefab("farm_plant_happy").entity:SetParent(inst.entity)
    end

    if inst.components.growable then
        if inst:HasTag("farm_plant") and not inst:HasTag("weed") then
            if inst.krm_bullet3_buff == nil then
                inst.krm_bullet3_buff = true
            end
            inst.components.growable:DoGrowth()

        elseif inst.prefab == "deciduoustree" and inst.monster == false and math.random() >= 0.9 then
            inst:StartMonster(true)

        elseif canspawn(inst) and inst:HasTag("evergreens") and math.random() >= 0.9 then
            inst.leifscale = GetGrowthStages[inst.components.growable.stage] or 1
            spawn_leif(inst)

        else
            inst.components.growable:DoGrowth()
        end
		SpawnPrefab("farm_plant_happy").entity:SetParent(inst.entity)
    end


end
end
local function AddBuff3(inst)
    -- if inst.components.combat then
        -- return
    -- end
    -- print("添加效果3")
		local x, y, z = inst.Transform:GetWorldPosition()
			for k, v in pairs(TheSim:FindEntities(x, y, z, 5)) do 
				AddBuff3fx(v)
			end

end

-- local function AddBuff4(inst)
-- if inst:HasTag("kurumi") then
-- inst.components.health:DoDelta(50, true, "krm_heal")
-- else
-- local del = inst.components.health.maxhealth * 0.50
-- inst.components.health:DoDelta(del)        
-- end
-- SpawnPrefab("pocketwatch_heal_fx").entity:SetParent(inst.entity)  
-- end    

local function AddBuff4(inst)
    if inst:HasTag("kurumi") then
        inst.components.health:DoDelta(120, true, "krm_heal")
    else
        local del = inst.components.health.maxhealth * 0.50
        inst.components.health:DoDelta(del)
    end
    SpawnPrefab("pocketwatch_heal_fx").entity:SetParent(inst.entity)
end

local function RemoveBuff5(inst)
    if inst.krm_bullrt5_fx then
        inst.krm_bullrt5_fx:Remove()
        inst.krm_bullrt5_fx = nil
    end

    if inst.krm_bullet_buff_task5 then
        inst.krm_bullet_buff_task5:Cancel()
        inst.krm_bullet_buff_task5 = nil
    end
end

local function AddBuff5(inst, time)
    RemoveBuff5(inst)

    if inst.krm_bullrt5_fx == nil then
        inst.krm_bullrt5_fx = SpawnPrefab("shadow_chester_swirl_fx")
        inst.krm_bullrt5_fx.entity:SetParent(inst.entity)
    end

    inst.krm_bullet_buff_task5 = inst:DoTaskInTime(time, function() -- 时间结束后取消Buff
        -- print("移除buff5")
        RemoveBuff5(inst)
    end)
end

local function AddBuff6(inst, target)
    if inst and target and inst:IsValid() and target:IsValid() then
        local g, o, b = inst.Transform:GetWorldPosition()
        local a, c, n = target.Transform:GetWorldPosition()
        if g and o and b and a and c and n then
            inst.Transform:SetPosition(a, c, n)
            target.Transform:SetPosition(g, o, b)
        end
    end
    -- if inst:HasTag("kurumi") and inst == target and inst.pet_buff6 and inst.pet_buff6:IsValid() then
    -- local x, y, z = inst.pet_buff6:GetPosition():Get()
    -- inst.Transform:SetPosition(x, y, z)
    -- inst.pet_buff6:Remove()

    -- elseif inst and target:HasTag("krm_pet") then
    -- inst.pet_buff6 = target
    -- end  

end

local function AddBuff7(inst)
    --------------------------------------------
    if TheWorld and inst.shijianzanting == nil and TheWorld.shijianzantingle == nil and
        TheWorld.components.krm_time_manager then
        TheWorld.shijianzantingle = true ---不可以触发第二次世界暂停
        if TheNet then
            TheNet:Announce(" 砸瓦鲁多 ")
        end
        if AllPlayers then
            for i, v in ipairs(AllPlayers) do
                if v.SoundEmitter then
                    v.SoundEmitter:PlaySound("shijianzanting/NGXY/shijianzanting")
						if TheWorld and TheWorld.components.krm_time_manager then
							TheWorld.components.krm_time_manager:AddTimeMagicCenter(v) -- 开启时停
						end
                end
            end
        end
        inst.shijianzanting = inst:DoTaskInTime(10, function()
			TheWorld.shijianzantingle = nil
            if TheNet then
                TheNet:Announce(" 時は動き出すジョギー ")
            end
            if AllPlayers then
                for i, v in ipairs(AllPlayers) do
						if TheWorld and TheWorld.components.krm_time_manager then
                        TheWorld.components.krm_time_manager:RemoveTimeMagicCenter(v) -- 结束时停
						end
                end
            end
            if inst.shijianzanting ~= nil then
                inst.shijianzanting:Cancel()
                inst.shijianzanting = nil
            end

        end)
    end
    ------------------------------------------
end

local function AddBuff8(inst)
    -- print("添加buff8")
    if inst:HasTag("kurumi") then
        if inst.components.krm_pets then
            local x, y, z = inst:GetPosition():Get()
            inst.components.krm_pets:SpawnPetAt(x, 0, z, "krm_pet1", true)
        end
    end

    if inst:HasTag("krm_pet") then
        inst:AddTag("krm_bullent_buff9")
        inst.sg:GoToState("death")
    end

end

local function AddBuff9(inst)

    if inst:HasTag("player") then

        if inst and inst.huanyingchuansuo == nil then

            SendModRPCToClient(CLIENT_MOD_RPC["kuangsan"]["chuansuoditu"], inst.userid, true, TheWorld.state.phase)
            inst.huanyingchuansuo = true
            inst:DoTaskInTime(1, function()
                if TheNet then
                    TheNet:Announce(inst:GetBasicDisplayName() .. "即将穿梭到鼠标位置")
                end
                inst:DoTaskInTime(1, function()
                    if TheNet then
                        TheNet:Announce(inst:GetBasicDisplayName() .. "1")
                    end
                    inst:DoTaskInTime(1, function()
                        if TheNet then
                            TheNet:Announce(inst:GetBasicDisplayName() .. "2")
                        end
                        inst:DoTaskInTime(1, function()
                            if TheNet then
                                TheNet:Announce(inst:GetBasicDisplayName() .. "3")
                            end
                        end)
                    end)
                end)
            end)

            inst:DoTaskInTime(5, function()
                inst.huanyingchuansuo = nil
                SendModRPCToClient(CLIENT_MOD_RPC["kuangsan"]["chuansuoditu"], inst.userid)

            end)
        end

    end

end

local function AddBuff10(inst)
    if inst.components.builder then
        inst:AddTag("krm_bullent_buff10")
        inst.components.builder:GiveAllRecipes()
        inst.components.builder:GiveAllRecipes()
    end
end

local function AddBuff11(inst)
    if TheWorld.state.isspring then
        -- print("推进到夏天")
        TheWorld:PushEvent("ms_setseason", "summer")

    elseif TheWorld.state.issummer then
        -- print("推进到秋天")
        TheWorld:PushEvent("ms_setseason", "autumn")

    elseif TheWorld.state.isautumn then
        -- print("推进到冬天")
        TheWorld:PushEvent("ms_setseason", "winter")

    elseif TheWorld.state.iswinter then
        -- print("推进到春天")
        TheWorld:PushEvent("ms_setseason", "spring")
    end
end

local function AddBuff12(inst)
    if TheWorld.state.isspring then
        -- print("回溯到冬天")
        TheWorld:PushEvent("ms_setseason", "winter")

    elseif TheWorld.state.issummer then
        -- print("回溯到春天")
        TheWorld:PushEvent("ms_setseason", "spring")

    elseif TheWorld.state.isautumn then
        -- print("回溯到夏天")
        TheWorld:PushEvent("ms_setseason", "summer")

    elseif TheWorld.state.iswinter then
        -- print("回溯到秋天")
        TheWorld:PushEvent("ms_setseason", "autumn")
    end
end

local function onhit(inst, attacker, target)
    if inst.bullet ~= nil and target and target:IsValid() then
        local fx = SpawnPrefab("wanda_attack_pocketwatch_normal_fx")
        fx.entity:SetParent(target.entity)
        -- print(inst.bullet)

        if inst.bullet == "krm_bullet1" and target.components.krm_bullet_buff then
            target.components.krm_bullet_buff:RemoveBuff1_Task()
            target.components.krm_bullet_buff:GetBuff1(480)

        elseif inst.bullet == "krm_bullet2" and not target:HasTag("player") then
            AddBuff2(target, 480)

        elseif inst.bullet == "krm_bullet3" then
            AddBuff3(target)

        elseif inst.bullet == "krm_bullet4" and target.components.health and not target.components.health:IsDead() then
            AddBuff4(target)

        elseif inst.bullet == "krm_bullet5" and target.components.combat then
            AddBuff5(target, 10)

        elseif inst.bullet == "krm_bullet6" then
            AddBuff6(attacker, target)

        elseif inst.bullet == "krm_bullet7" then

            AddBuff7(attacker)

        elseif inst.bullet == "krm_bullet8" then
            AddBuff8(target)

        elseif inst.bullet == "krm_bullet9" then
            AddBuff9(target)
        elseif inst.bullet == "krm_bullet10" then
            if jiesuoikejishizhidan then
                AddBuff10(target)
            else
                AddBuff10(attacker)
            end
        elseif inst.bullet == "krm_bullet11" then
            AddBuff11(target)

        elseif inst.bullet == "krm_bullet12" then
            AddBuff12(target)
        end

        if target ~= attacker and inst.bullet ~= "krm_bullet7" then
            target:PushEvent("attacked", {
                attacker = attacker,
                damage = 0,
                damageresolved = 0,
                weapon = nil
            })
        end
    end

    inst:Remove()
end

local function StopTrackingDelayOwner(self)
    if self.delayowner ~= nil then
        self.inst:RemoveEventCallback("onremove", self._ondelaycancel, self.delayowner)
        self.inst:RemoveEventCallback("newstate", self._ondelaycancel, self.delayowner)
        self.delayowner = nil
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("krm_bulletfx")
    inst.AnimState:SetBuild("krm_bulletfx")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(0.5)
    inst.AnimState:SetFinalOffset(-1)

    MakeProjectilePhysics(inst)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(10)
    inst.Physics:SetRestitution(0)

    inst:AddTag("NOCLICK")
    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.bullet = nil

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(1.2)
    inst.components.projectile:SetLaunchOffset(Vector3(2, 1, 0))
    inst.components.projectile:SetOnHitFn(onhit)
    inst.components.projectile:SetOnMissFn(inst.Remove)

    local OldThrow = inst.components.projectile.Throw
    inst.components.projectile.Throw = function(self, owner, target, attacker)
        if owner and owner.bullet then
            inst.bullet = owner.bullet
        end
        return OldThrow(self, owner, target, attacker)
    end

    inst.components.projectile.Hit = function(self, target)
        local attacker = self.owner
        local weapon = self.inst
        StopTrackingDelayOwner(self)
        self:Stop()
        self.inst.Physics:Stop()

        if attacker.components.combat == nil and attacker.components.weapon ~= nil and attacker.components.inventoryitem ~=
            nil then
            weapon = (self.has_damage_set and weapon.components.weapon ~= nil) and weapon or attacker
            attacker = attacker.components.inventoryitem.owner
        end

        if self.onprehit ~= nil then
            self.onprehit(self.inst, attacker, target)
        end
        if attacker ~= nil and attacker.components.combat ~= nil and target.prefab ~= "kurumi" then
            if attacker.components.combat.ignorehitrange then
                attacker.components.combat:DoAttack(target, weapon, self.inst, self.stimuli)
            else
                attacker.components.combat.ignorehitrange = true
                attacker.components.combat:DoAttack(target, weapon, self.inst, self.stimuli)
                attacker.components.combat.ignorehitrange = false
            end
        end
        if self.onhit ~= nil then
            self.onhit(self.inst, attacker, target)
        end
    end

    return inst
end

return Prefab("krm_bullet", fn)
