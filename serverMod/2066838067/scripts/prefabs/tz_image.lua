
local assets = {

}

local prefabs = {
	"taizhen"
}
local function die(inst)
	inst.components.health:Kill()
end
local function Ondeath(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/death")
	inst.AnimState:PlayAnimation("death")
end
local function resume(inst, time)
    if inst.death then
        inst.death:Cancel()
        inst.death = nil
    end
    inst.death = inst:DoTaskInTime(time, die)
end
local function onsave(inst, data)
    data.timeleft = (inst.lifetime - inst:GetTimeAlive())
end

local function onload(inst, data)
    if data.timeleft then
        inst.lifetime = data.timeleft
        if inst.lifetime > 0 then
            resume(inst, inst.lifetime)
        else
            die(inst)
        end
    end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    MakeCharacterPhysics(inst, 100, .2)
    inst.Physics:SetFriction(.3)
    inst.Physics:SetDamping(0)
    inst.Physics:SetRestitution(1)
	inst.DynamicShadow:SetSize(2, 1.5)
	MakeSnowCoveredPristine(inst)
	inst.Transform:SetFourFaced()

	inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("taizhen")
	inst.AnimState:PlayAnimation("idle_loop", true)
	--inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:Hide("ARM_carry")
	inst.AnimState:Show("ARM_normal")
    inst:AddTag("scarytoprey")
	inst:AddTag("_health")
	inst:AddTag("_combat")
	inst:AddTag("character")
	inst:AddTag("tz_image")
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(0)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(1000)
	inst:AddComponent("burnable")
	inst:AddComponent("freezable")	
	inst:AddComponent("inspectable")

	inst:AddComponent("inventory")
	inst.components.inventory.dropondeath = false
	inst:SetStateGraph("SGtz_image")

    MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
	return inst
end

return Prefab("common/tz_image", fn, assets, prefabs)
