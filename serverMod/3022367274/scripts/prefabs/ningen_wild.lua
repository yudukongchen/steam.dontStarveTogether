local assets =
{
    Asset( "ANIM", "anim/ningen.zip" ),
}

local brain = require "brains/ningen_wildbrain"

SetSharedLootTable("wild_ningendrop",
{
	{"tentaclespots", 0.2},
	{"fishmeat", 1},
	-- {"fishmeat", 1},
})

local function NormalRetargetFn(inst)
    return FindEntity(inst, TUNING.PIG_TARGET_DIST, function(guy)
        return inst.components.hunger:GetPercent() < 0.5
            and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) 
            and guy:HasTag("player") and not guy:HasTag("chess") and not guy:HasTag("ningen_wild")
    end, nil, { "character" }, nil)
end

local function keeptargetfn(inst, target)
   return target ~= nil
        and target.components.combat ~= nil
        and target.components.health ~= nil
        and not target.components.health:IsDead()
end

local function updatestate(inst)
    if inst.components.health:GetPercent() < 0.3 then
        inst.components.locomotor.walkspeed = 2 * TUNING.WILSON_WALK_SPEED 
	    inst.components.locomotor.runspeed = 2 * TUNING.WILSON_RUN_SPEED 
    else
        inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED 
	    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED 
    end
    if inst.components.follower ~= nil and inst.components.follower.leader == nil then
        if inst.components.hunger:GetPercent() < 0.1 then
            inst.components.hunger:SetPercent(0.1)
        end
    end
end

local function OnEat(inst, food)
    if food.components.edible ~= nil then
        -- if food.prefab == "jellybean" then
        --     inst.sg:GoToState("sleep")
        -- end
    end
end

local function OnHitOther(inst, target)
    if inst.components.follower ~= nil and inst.components.follower.leader == nil then
        if inst.components.hunger then
            inst.components.hunger:DoDelta(2)
        end
    end
end

local function OnAttacked(inst, data)
    local attacker = data.attacker
    local owner = inst.components.follower.leader
    if inst.no_targeting or attacker == nil then
        return
    end
    if owner ~= nil and attacker == owner then
        return
    end
    if attacker then
        inst.components.combat:SetTarget(attacker)
    end
end

local function fn()
    
    local inst = CreateEntity()
    inst.entity:AddNetwork()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLightWatcher()
	inst.entity:AddDynamicShadow()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("ningen")
    inst.AnimState:PlayAnimation("idle")
    -- inst.AnimState:Hide("ARM_carry")
    -- inst.AnimState:Show("ARM_normal")
    inst.AnimState:Show("ARM_carry")

    inst.DynamicShadow:SetSize(1.3, .6)

    MakeCharacterPhysics(inst, 50, .5)

    inst.entity:SetPristine()

    -- inst:AddTag("trader")
    inst:AddTag("scarytoprey")
    inst:AddTag("notraptrigger")
    inst:AddTag("ningen_wild")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("follower")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED 
	inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED 
    inst.components.locomotor:EnableGroundSpeedMultiplier(true)
    inst.components.locomotor:SetSlowMultiplier(0.6)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.NINGEN_HEALTH)
    inst.components.health:StartRegen(1.5, 5)
    inst.components.health:SetAbsorptionAmount(0.85)

    inst:AddComponent("hunger")
    inst.components.hunger:SetMax(TUNING.NINGEN_HUNGER)
    inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE)
    
    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.GOODIES }, { FOODTYPE.GOODIES })
    inst.components.eater:SetOnEatFn(OnEat)

    local selfeater = inst.components.eater
    local old = selfeater.Eat
	function inst.components.eater:Eat(food)
		if selfeater:CanEat(food) then
		    if food.components.edible.sanityvalue then
                food.components.edible.sanityvalue = 0
            end
			if food.components.edible.healthvalue then
				food.components.edible.healthvalue = 0
			end
            if food.components.edible.hungervalue then
				food.components.edible.hungervalue = 0
			end
		end
		return old(selfeater, food)
	end

    inst:AddComponent("inventory")
	inst.components.inventory.nosteal = true
    inst.components.inventory.dropondeath = true
    inst.components.inventory:Equip(SpawnPrefab("tentaclespike"))

    inst.weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    inst.weapon.components.weapon.attackwearmultipliers:SetModifier(inst, 0)

    inst:AddComponent("combat")
    inst.components.combat:SetRange(3, 3)
    inst.components.combat:SetDefaultDamage(51)
    inst.components.combat:SetAttackPeriod(1.5)
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetRetargetFunction(1.5, NormalRetargetFn)
    inst.components.combat:SetTarget(nil)
    inst.components.combat.onhitotherfn = OnHitOther

    inst:AddComponent("talker")
	inst.components.talker.fontsize = 30
	inst.components.talker.colour = Vector3(1, 0.5, 0.75, 1)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("wild_ningendrop")
    
	inst:DoPeriodicTask(1, updatestate)

    inst:ListenForEvent("attacked", OnAttacked)

    inst:SetBrain(brain)
    inst:SetStateGraph("SGningen_wild")

    return inst

end

return Prefab("ningen_wild", fn, assets)