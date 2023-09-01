local assets =
{
   Asset("ANIM", "anim/krm_fuyoupao.zip"),
   Asset("ANIM", "anim/lavaarena_blowdart_attacks.zip"),
}

local function IsValidTarget(inst,death)
	return  inst:IsValid() and  inst.components.health ~= nil and (death or 
	not inst.components.health:IsDead()) and inst.components.combat ~= nil
end

local function canhit(inst,target)
    if IsValidTarget(target) and IsValidTarget(inst.owner,true) and inst:IsValid() then
        local pos = inst:GetPosition()
        local pt = target:GetPosition()
        local range = target:GetPhysicsRadius(0) + 0.5
        if distsq(pos.x, pos.z,pt.x,pt.z) < range * range then
            target.components.combat:GetAttacked(inst.owner,20,nil,"krm_fuyoupao")
            inst:Remove()
        end
    end
end

local projectile_offset = 1
local function LaunchProjectile(inst,attacker, target)
    local proj = SpawnPrefab("krm_fuyoupao_projectile")
    if proj ~= nil then
        if proj.components.projectile ~= nil then
            if projectile_offset ~= nil then
                local x, y, z = inst.Transform:GetWorldPosition()
                local dir = (target:GetPosition() - Vector3(x, y, z)):Normalize()
                dir = dir * projectile_offset
                proj.Transform:SetPosition(x + dir.x, y, z + dir.z)
            else
                proj.Transform:SetPosition(attacker.Transform:GetWorldPosition())
            end
            proj.owner = attacker
            proj.components.projectile:Throw(attacker, target)
            proj:DoPeriodicTask(0,canhit,0,target)
        end
    end
end

local function SetTarget(inst,target,owner)
    if target then
        local x,y,z = target.Transform:GetWorldPosition()
        inst:FacePoint(x, y, z)
        inst:DoTaskInTime(0.25,function()
            if IsValidTarget(target) and owner:IsValid() then
                LaunchProjectile(inst,owner, target)
            end
        end)
    end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("krm_fuyoupao")
    inst.AnimState:SetBuild("krm_fuyoupao")
    inst.AnimState:PlayAnimation("atk_pre")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

	inst.AnimState:SetFinalOffset(1)

	inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:PushAnimation("atk", false)
    inst.AnimState:PushAnimation("atk_pst", false)
    inst:ListenForEvent("animqueueover", inst.Remove)

    inst:DoTaskInTime(3,inst.Remove)
    inst.SetTarget = SetTarget
    inst.persists = false

	return inst
end

local FADE_FRAMES = 5
local function CreateTail(thintail, tail_suffix)
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("lavaarena_blowdart_attacks")
    inst.AnimState:SetBuild("lavaarena_blowdart_attacks")
    inst.AnimState:PlayAnimation("tail_1")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    if not thintail then
        inst.AnimState:SetAddColour(1, 1, 0, 0)
    end

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end
local function OnUpdateProjectileTail(inst, tail_suffix)
    local c = (not inst.entity:IsVisible() and 0) or 1
    if c > 0 then
        local tail = CreateTail(inst.thintailcount > 0, tail_suffix)
        tail.Transform:SetPosition(inst.Transform:GetWorldPosition())
        tail.Transform:SetRotation(inst.Transform:GetRotation())
        if c < 1 then
            tail.AnimState:SetTime(c * tail.AnimState:GetCurrentAnimationLength())
        end
        if inst.thintailcount > 0 then
            inst.thintailcount = inst.thintailcount - 1
        end
    end
end

local function OnAttack(inst, attacker, target)
    inst:Remove()
end

local function commonprojectilefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("lavaarena_blowdart_attacks")
    inst.AnimState:SetBuild("lavaarena_blowdart_attacks")
    inst.AnimState:PlayAnimation("attack_2", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetAddColour(1, 1, 0, 0)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("projectile")
    if not TheNet:IsDedicated() then
        inst.thintailcount = 0
        inst:DoPeriodicTask(0, OnUpdateProjectileTail, nil, "")
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(25)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(0)
    inst.components.projectile:SetOnMissFn(inst.Remove)
    inst.components.projectile:SetLaunchOffset(Vector3(1, 0, 0))
    inst.components.projectile.range = 12
	inst.components.projectile.has_damage_set = true
    inst.components.projectile.Hit = function(...)
        
    end

    inst:DoTaskInTime(2,inst.Remove)
    return inst
end

return Prefab("krm_fuyoupao", fn, assets),
Prefab("krm_fuyoupao_projectile", commonprojectilefn, assets)