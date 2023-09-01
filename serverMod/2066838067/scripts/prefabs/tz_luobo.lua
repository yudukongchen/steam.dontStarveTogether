local assets = {
  Asset("ANIM", "anim/tz_luobo.zip"),
   Asset("ANIM", "anim/luobo_fx.zip"),
    Asset("ANIM", "anim/luobo_fx_two.zip"),
   Asset("ANIM", "anim/lavaarena_battlestandard.zip"),
}


local prefabs =
{
    "tz_luobo_fx",
}
local function DoAreaAttack(inst)
	if inst.components.combat then
		inst.components.combat:DoAreaAttack(inst, 18, nil, nil, nil, { "INLIMBO" })
	end
	inst:Remove()
end
local noTags = { "FX", "NOCLICK", "DECOR", "INLIMBO" }
local function SproutLaunch(inst, x, y, z, basespeed)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local dx, dz = x1 - x, z1 - z
    local dsq = dx * dx + dz * dz
    local angle
    if dsq > 0 then
        local dist = math.sqrt(dsq)
        angle = math.atan2(dz / dist, dx / dist) + (math.random() * 20 - 10) * DEGREES
    else
        angle = 2 * PI * math.random()
    end
    local speed = basespeed + math.random()+0.4
    inst.Physics:Teleport(x1, .1, z1)
    inst.Physics:SetVel(math.cos(angle) * speed, speed * 4 + math.random() * 2, math.sin(angle) * speed)
end
local function OnBaozha(inst)
    inst.SoundEmitter:KillSound("hiss")
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
	local x, y, z = inst.Transform:GetWorldPosition()
    RemovePhysicsColliders(inst)
	inst.AnimState:PlayAnimation("wu")
	SpawnPrefab("explode_small").Transform:SetPosition(x, y, z)
	local fx1   = SpawnPrefab("tz_luobo_fx_two")
	fx1.Transform:SetPosition(x, y, z)
    for i, v in ipairs(AllPlayers) do
        local distSq = v:GetDistanceSqToInst(inst)
        local k = math.max(0, math.min(1, distSq / 1600))
        local intensity = k * (k - 2) + 1
        if intensity > 0 then
            --v:ScreenFlash(intensity)
            v:ShakeCamera(CAMERASHAKE.FULL, .7, .02, intensity / 2)
        end
    end
    inst:AddTag("NOCLICK")
    inst.persists = false
    local attack_delay = .3
    inst:DoTaskInTime(attack_delay, DoAreaAttack)
	local tomove = TheSim:FindEntities(x, y, z, 12, { "_inventoryitem" }, { "locomotor", "INLIMBO" })
	local ents = TheSim:FindEntities(x, y, z, 12, nil, noTags)
            for i, v2 in ipairs(ents) do
                if v2 ~= inst and v2:IsValid() then	
					if 	v2.prefab == "flower"or v2.prefab == "flower_rose"   then
						SpawnPrefab("petals").Transform:SetPosition(v2.Transform:GetWorldPosition())
						v2:Remove()
					end
					if	v2.components.workable ~= nil and
                        v2.components.workable:CanBeWorked() and
                        v2.components.workable.action ~= ACTIONS.NET then
                        v2.components.workable:Destroy(inst)
					end
                end
			end
            for i, v in ipairs(tomove) do
                if v:IsValid() then
                    if v.components.inventoryitem and not v.components.inventoryitem.nobounce and v.Physics ~= nil and v.Physics:IsActive() then
                        SproutLaunch(v,  x, y, z, 1.5)
                    end
                end
            end
end

local function shenme(inst)
	inst:DoTaskInTime(2, function()	
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
	end)
	inst:DoTaskInTime(6.8, function()	inst.AnimState:SetMultColour(0,0,0,1) end)
	inst:DoTaskInTime(7, OnBaozha)
end

local function fn() 
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    MakeObstaclePhysics(inst, .5)  
	inst.AnimState:SetBank("tz_luobo")
	inst.AnimState:SetBuild("tz_luobo")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst:AddComponent("talker")
    inst.components.talker.fontsize = 40
	inst.components.talker.colour = Vector3(.9, .4, .4)
    inst.components.talker.offset = Vector3(0, -500, 0)
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(500)
	inst:DoTaskInTime(3, shenme)
    return inst
end

local function splashhitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("lavaarena_battlestandard")
	inst.AnimState:SetBuild("luobo_fx")
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetScale(1.8, 1.8 ,1.8)
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

    inst:AddComponent("luobo_groundpounder")
    --inst.components.luobo_groundpounder.groundpoundringfx = "tz_luobo_fx_botwo"
    inst.components.luobo_groundpounder.destroyer = true
    inst.components.luobo_groundpounder.damageRings = 2
    inst.components.luobo_groundpounder.destructionRings = 2
    inst.components.luobo_groundpounder.numRings = 3
	inst.components.luobo_groundpounder.initialRadius = 2
	inst.components.luobo_groundpounder.radiusStepDistance = 2.5
	inst.components.luobo_groundpounder.scale = 0.7
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	return inst
end
local function splashfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("lavaarena_battlestandard")
	inst.AnimState:SetBuild("luobo_fx_two")
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetScale(12, 12 ,12)
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	return inst
end
local function bofn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("bearger_ring_fx")
	inst.AnimState:SetBuild("bearger_ring_fx")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetScale(1.6, 1 ,1.6)
    inst.AnimState:SetFinalOffset(-1)
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	return inst
end
local function botwofn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("bearger_ring_fx")
	inst.AnimState:SetBuild("bearger_ring_fx")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetScale(0.8, 1 ,0.8)
    inst.AnimState:SetFinalOffset(-1)
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	return inst
end
return Prefab("tz_luobo", fn, assets, prefabs),
       Prefab("tz_luobo_fx", splashhitfn, assets),
       Prefab("tz_luobo_fx_two", splashfn, assets),
	   Prefab("tz_luobo_fx_bo", bofn, assets),
		Prefab("tz_luobo_fx_botwo", botwofn, assets)