local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fh_you.zip"),
    Asset("ANIM", "anim/tz_fhyou_sg.zip"),
    Asset("ANIM", "anim/tz_fh_you_arrow.zip"),
    Asset("ANIM", "anim/swap_tz_fh_you.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_you.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_you.xml")
}
local function OnAttack(inst, attacker, target)
    local fx = SpawnPrefab("tz_fh_you_curve_fx")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
    fx:DoTaskInTime(1.5,fx.Remove)
end

local function OnMiss(inst, owner, target)
    inst:Remove()
end
--local function UpdateDamage(inst,phase)
    --if phase == "night" then
        --inst.components.weapon:SetDamage(62.5+25)
    --else
        --inst.components.weapon:SetDamage(50+25)
    --end
--end

local CAN_TAGS = {"_combat","_health"}
local CANT_TAGS = {"playerghost","player","INLIMBO"}

local function projectile_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeProjectilePhysics(inst)

    inst.AnimState:SetBank("tz_fh_you_arrow")
    inst.AnimState:SetBuild("tz_fh_you_arrow")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetBloomEffectHandle("shaders/anim_haunted.ksh")
    inst.AnimState:SetLightOverride(1)

    inst:AddTag("NOCLICK")
    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	-- inst.Physics:SetCollisionCallback(function(a,b,c,d)
		-- print(a,b,c,d)
	
	-- end)
    inst.persists = false

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(51)
	inst.components.weapon:SetOnAttack(OnAttack)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(28)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(1)
    inst.components.projectile:SetOnMissFn(OnMiss)
    inst.components.projectile:SetLaunchOffset(Vector3(0, 0.9, 0))
    inst.components.projectile.range = 30
	inst.components.projectile.has_damage_set = true
	
	local sss = {}
	function inst.components.projectile:OnUpdate(dt)
		if not self.owner:IsValid() then
			return
		end
		local attacker = self.owner.components.inventoryitem.owner
		if attacker ~= nil and attacker:IsValid() then
			local x,y,z = self.inst.Transform:GetWorldPosition()
			for i, v in ipairs(TheSim:FindEntities(x, 0, z, 1.65, CAN_TAGS,CANT_TAGS)) do
				if sss[v] == nil then
					sss[v] = true
					local fx = SpawnPrefab("tz_fh_you_curve_fx")
					fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
					fx:DoTaskInTime(1.5,fx.Remove)
					v.components.combat:GetAttacked(attacker, attacker.components.combat:CalcDamage(v, self.inst), self.inst)
					for iv, vv in ipairs(TheSim:FindEntities(x, y, z, 3.3, CAN_TAGS,CANT_TAGS)) do
						if sss[vv] == nil then
						   sss[vv] = true
							vv.components.combat:GetAttacked(attacker, attacker.components.combat:CalcDamage(vv, self.inst, 0.67), self.inst)
						end
					end
				end
			end
		end
	end
	inst.components.projectile:SetOnThrownFn(function(inst, owner, target, attacker)
		if attacker ~= nil then
			local x,y,z = attacker.Transform:GetWorldPosition()
			inst.Transform:SetPosition(x,y+0.9,z)
		end
		-- inst.components.projectile:OnUpdate(0.033)
	end)
	inst:DoTaskInTime(2,inst.Remove)

    --大力士不要炸了ok？
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.pushlandedevents = false
    inst.components.inventoryitem.canbepickedup = false

    --inst:WatchWorldState("phase", UpdateDamage)
    --UpdateDamage(inst, TheWorld.state.phase)

    return inst
end

local function UpdateSpeed(inst,phase)
    if phase == "night" then
        inst.components.equippable.walkspeedmult = 1.35
    else
        inst.components.equippable.walkspeedmult = 1.25
    end
end

local function TakeFuelItem(self,item, doer)
    if self:CanAcceptFuelItem(item) then
        local wetmult = item:GetIsWet() and TUNING.WET_FUEL_PENALTY or 1
        local masterymult = doer ~= nil and doer.components.fuelmaster ~= nil and doer.components.fuelmaster:GetBonusMult(item, self.inst) or 1
        self:DoDelta(50 * self.bonusmult * wetmult * masterymult, doer)
        if doer and doer:HasTag("player") then
            local pos = doer:GetPosition()
            SpawnAt("tz_takefuel",pos + Vector3(-0.1,-2.6,0))
        end
        self.inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        item:Remove()
        self.inst:PushEvent("takefuel", { fuelvalue = 50 })
        return true
    end
end

-------------------------------------------------------------------------------------------------
local function trap_fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("shadow_trap")
	inst.AnimState:SetBuild("shadow_trap")
	inst.AnimState:PlayAnimation("idle", true)

	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end
	inst.task = inst:DoPeriodicTask(.5, function(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		local b = TheSim:FindEntities(x, y, z, 2, CAN_TAGS,CANT_TAGS)
		if #b == 0 then
			return
		end
		inst.AnimState:PlayAnimation("explode")
		for i, v in ipairs(b) do
			if inst.attacker ~= nil and inst.attacker:IsValid() then
				local wq = inst.attacker.components.combat:GetWeapon()
				-- v.components.combat:GetAttacked(inst.attacker, inst.attacker.components.combat:CalcDamage(v, wq, 0.67),wq)
				v.components.combat:GetAttacked(inst.attacker, 50,wq)
			else
				v.components.combat:GetAttacked(inst, 51)
			end
			if v.components.locomotor ~= nil then
				v.components.locomotor:SetExternalSpeedMultiplier(inst, "tz_fh_you_trap", 0)
			end
		end
		if inst.task ~= nil then
			inst.task:Cancel()
		end
		for i, v in ipairs(TheSim:FindEntities(x, y, z, 14, {"player"})) do
			local you = v.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if you ~= nil and you:HasTag("tz_fh_you") then
				if v.tz_fh_you_traptask ~= nil then
					v.tz_fh_you_traptask:Cancel()
					v.tz_fh_you_traptask = nil
				end
				v.tz_fh_you_traptask = v:DoTaskInTime(2,function(p)
					p.components.locomotor:RemoveExternalSpeedMultiplier(p, "tz_fh_you_trap")
				end)
				v.components.locomotor:SetExternalSpeedMultiplier(v, "tz_fh_you_trap", 1.25)
			end
		end
		inst:DoTaskInTime(2,inst.Remove)
	end)


	inst:DoTaskInTime(240,inst.Remove)

	return inst

end

return  Prefab("tz_fh_you_arrow",projectile_fn),
	Prefab("tz_fh_you_trap",trap_fn),
    TzEntity.CreateNormalWeapon({
    assets = assets,
    prefabname = "tz_fh_you",
    tags = {"tz_fh_you","tz_fanhao"},
    bank = "tz_fh_you",
    build = "tz_fh_you",
    anim = "idle",

    weapon_data = {
        -- However,the damage delt by this weapon is pierce damage
        -- So do this in another way....
        damage = 0,
        ranges = 14,
    },
    
    clientfn = function(inst)
        TzFh.AddFhLevel(inst,true)
        TzFh.AddOwnerName(inst)
    end,
    serverfn = function(inst)
		inst.cdtime = GetTime()
        -- This is Tz-Fh Common
        --TzFh.AddOwnerName(inst)
        TzFh.MakeWhiteList(inst)
        TzFh.AddFueledComponent(inst,{
            max = 500,
        })
        inst.components.fueled.TakeFuelItem = TakeFuelItem
        TzFh.SetReturnSpiritualism(inst)
            
        --TzFh.AddLibrarySkill(inst,{name = "shadowstep",walkspeedmult = 1.25})
        inst:WatchWorldState("phase", UpdateSpeed)
        UpdateSpeed(inst, TheWorld.state.phase)


        inst.components.weapon:SetOnProjectileLaunch(function(inst,attacker,target)
            inst.components.fueled:DoDelta(-1)
        end)

        inst.components.weapon:SetProjectile("tz_fh_you_arrow")
        -- inst.components.weapon:SetProjectileOffset(1)

    end,
})