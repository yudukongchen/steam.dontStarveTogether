local assets =
{
	Asset("ANIM", "anim/swap_nanashi_mumei_dagger.zip"),
}

local function OnMiss(inst, owner, target)
    inst:DoTaskInTime(2,function ()
        if not target or not target:IsValid() then
            SpawnSaveRecord(inst._dagger)
            inst:Remove()
        end
    end)
end
local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("swap_nanashi_mumei_dagger")
    inst.AnimState:SetBuild("swap_nanashi_mumei_dagger")
    inst.AnimState:PlayAnimation("idle_toss", true)
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("projectile")
    
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(30)
	inst.components.projectile:SetLaunchOffset({x=0, y=2})
	inst.components.projectile:SetHitDist(2)
    -- inst.components.projectile:SetOnMissFn(OnMiss)

	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)


	inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
	inst:DoTaskInTime(5,function ()
        if inst._dagger then
            local dagger = SpawnSaveRecord(inst._dagger)
            dagger.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst:Remove()
        end
    end)
	return inst
end

return Prefab("nanashi_mumei_dagger_projectile", fn, assets)