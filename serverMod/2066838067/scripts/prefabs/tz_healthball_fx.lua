local assets =
{
    Asset("ANIM", "anim/fireball_2_fx.zip"),
    Asset("ANIM", "anim/deer_fire_charge.zip"),
	Asset("ANIM", "anim/tz_healthball_fx.zip"),

}
local function CreateTail(bank, build, lightoverride,colour)
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    inst.Physics:ClearCollisionMask()

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("disappear")
    inst.AnimState:SetMultColour(colour,colour,colour,1)
    if lightoverride > 0 then
        inst.AnimState:SetLightOverride(lightoverride)
    end
    inst.AnimState:SetFinalOffset(-1)

    inst:ListenForEvent("animover", inst.Remove)
	inst.Transform:SetScale(0.4,0.4,0.4) --飞行尾巴的大小
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    return inst
end

local function OnUpdateProjectileTail(inst, bank, build, speed, lightoverride, hitfx,colour, tails)
    local x, y, z = inst.Transform:GetWorldPosition()
    for tail, _ in pairs(tails) do
        tail:ForceFacePoint(x, y, z)
    end
    if inst.entity:IsVisible() then
        local tail = CreateTail(bank, build, lightoverride,colour)
        local rot = inst.Transform:GetRotation()
        tail.Transform:SetRotation(rot)
        rot = rot * DEGREES
        local offsangle = math.random() * 2 * PI
        local offsradius = math.random() * .2 + .2
        local hoffset = math.cos(offsangle) * offsradius
        local voffset = math.sin(offsangle) * offsradius
        tail.Transform:SetPosition(x + math.sin(rot) * hoffset, y + voffset, z + math.cos(rot) * hoffset)
        tail.Physics:SetMotorVel(speed * (.2 + math.random() * .3), 0, 0)
        tails[tail] = true
        inst:ListenForEvent("onremove", function(tail) tails[tail] = nil end, tail)
        tail:ListenForEvent("onremove", function(inst)
            tail.Transform:SetRotation(tail.Transform:GetRotation() + math.random() * 30 - 15)
        end, inst)
    end
end

local function MakeProjectile(name, bank, build, speed, lightoverride,  hitfx ,colour)
    local assets =
    {
        Asset("ANIM", "anim/"..build..".zip"),
    }

    local prefabs = hitfx ~= nil and { hitfx } or nil

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
		inst.entity:AddSoundEmitter()

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle_loop", true)
		inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetFinalOffset(-1)

		inst.Transform:SetScale(0.5,0.5,0.5) --飞行特效的大小
		inst.glow = inst.entity:AddLight()  --光照部分   
		inst.glow:SetIntensity(.9) --强度
		inst.glow:SetRadius(1) --范围
		inst.glow:SetFalloff(1) --削减
		inst.glow:SetColour(10/255, 239/255, 245/255) --颜色
		inst.glow:Enable(true)	
	
        inst:AddTag("projectile")

        if not TheNet:IsDedicated() then
            inst:DoPeriodicTask(0, OnUpdateProjectileTail, nil, bank, build, speed, lightoverride, hitfx,colour ,{})
        end
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		inst.persists = false
		inst:AddComponent("projectile")
		inst.components.projectile:SetSpeed(speed)
		inst.components.projectile:SetOnMissFn(inst.Remove)
		inst.components.projectile:SetOnHitFn(function(inst, owner, target)
			if target:IsValid() then
				local fx = SpawnPrefab(hitfx)
				fx.Transform:SetPosition(target.Transform:GetWorldPosition())
				if inst.health ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
					target.components.health:DoDelta(inst.health, false,nil,true)
					if target.components.tzsama then
						target.components.tzsama:DoDelta(inst.health)
					end
				end
			end
			inst:Remove()
		end)
        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local function OnRemove(inst)
	local x, y, z = inst.Transform:GetWorldPosition()	
	if inst.owner ~= nil then
		local projectile = SpawnPrefab("tz_healthball_fx")
		projectile.Transform:SetPosition(x, y, z )
		if projectile ~= nil and projectile.components.projectile then
			projectile.Transform:SetPosition(x, y, z )
			projectile.components.projectile:Throw(projectile, inst.owner)
			projectile.health = inst.health or 0 
		end
	end
	inst:Remove()
end

local function prefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tz_healthball_fx")
    inst.AnimState:SetBuild("tz_healthball_fx")
    inst.AnimState:PlayAnimation("idle_pre")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(-1)

	inst.Transform:SetScale(0.5,0.5,0.5) --初始 一出来那个特效的大小
    inst.glow = inst.entity:AddLight()  --光照部分   
    inst.glow:SetIntensity(.9) --强度
    inst.glow:SetRadius(1) --范围
    inst.glow:SetFalloff(1) --削减
    inst.glow:SetColour(10/255, 239/255, 245/255) --颜色
    inst.glow:Enable(true)	
	
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:ListenForEvent("animover", OnRemove)
    inst.persists = false
	
    return inst
end

local function PlayHitSound(proxy)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()

    inst.Transform:SetFromProxy(proxy.GUID)
    inst.SoundEmitter:PlaySound("tz_bianshen_sound/a/c")

    inst:Remove()
end

local function fireballhit_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tz_healthball_fx")
    inst.AnimState:SetBuild("tz_healthball_fx")
    inst.AnimState:PlayAnimation("idle_pst")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(-1)
	
	
	inst.Transform:SetScale(0.5,0.5,0.5) --击中特效的大小
    inst.glow = inst.entity:AddLight()  --光照部分   
    inst.glow:SetIntensity(.9) --强度
    inst.glow:SetRadius(1) --范围
    inst.glow:SetFalloff(1) --削减
    inst.glow:SetColour(10/255, 239/255, 245/255) --颜色
    inst.glow:Enable(true)	
	
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, PlayHitSound)
    end
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)
    return inst
end

return MakeProjectile("tz_healthball_fx", "fireball_fx", "tz_healthball_fx", 15, 1, "tz_healthball_fx_hit_fx",1),
		Prefab("tz_healthball_fx_hit_fx", fireballhit_fn, assets),
		Prefab("tz_healthball_fx_pre", prefn)
