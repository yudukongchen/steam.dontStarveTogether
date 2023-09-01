local assets =
{
    Asset("ANIM", "anim/fireball_2_fx.zip"),
    Asset("ANIM", "anim/deer_fire_charge.zip"),
	Asset("ANIM", "anim/baiball_2_fx.zip"),
    Asset("ANIM", "anim/deer_bai_charge.zip"),
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

local function OnHit(inst, owner, target)
    if target:IsValid() then
        local fx = SpawnPrefab("tz_fireball_hit_fx")
        fx.Transform:SetPosition(target.Transform:GetWorldPosition())
    end
    inst:Remove()
end

local function OnThrown(inst, owner, target)
    if inst:IsValid() then
		inst:DoTaskInTime(0.2, function()
        local fx = SpawnPrefab("tz_fireball_hit_fx")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		end)
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

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle_loop", true)
        if lightoverride > 0 then
            inst.AnimState:SetLightOverride(lightoverride)
        end
		
		if 	name ==	"tz_projectile_purple" then
			inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
			inst.Transform:SetScale(0.8,0.8,0.8)
		end
		
        inst.AnimState:SetFinalOffset(-1)
		
		inst.AnimState:SetMultColour(colour,colour,colour,1)

        inst:AddTag("projectile")

        if not TheNet:IsDedicated() then  --??
            inst:DoPeriodicTask(0, OnUpdateProjectileTail, nil, bank, build, speed, lightoverride, hitfx,colour ,{})
        end
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
        
		inst.persists = false
		
		--inst:AddComponent("combat")
		--inst.components.combat:SetDefaultDamage(10)
		
		inst:AddComponent("projectile")
		inst.components.projectile:SetSpeed(speed)
		inst.components.projectile:SetOnMissFn(inst.Remove)
		inst.components.projectile:SetOnHitFn(function(inst, owner, target)
		    if target:IsValid() then
                if hitfx ~= nil then
			        local fx = SpawnPrefab(hitfx)
			        fx.Transform:SetPosition(target.Transform:GetWorldPosition())
		        end 
            end
			if name == "tz_xin_cjb" then
				tz_xin["tz_xin_cjb"](inst)
			else
				inst:Remove()
			end
		end)
        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

--------------------------------------------------------------------------

local function fireballhit_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("fireball_fx")
    inst.AnimState:SetBuild("deer_fire_charge")
    inst.AnimState:PlayAnimation("blast")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(-1)
    inst.AnimState:SetMultColour(0,0,0,1)
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)
    return inst
end
local function fireballbaihit_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("fireball_fx")
    inst.AnimState:SetBuild("deer_bai_charge")
    inst.AnimState:PlayAnimation("blast")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)
    return inst
end
		--MakeProjectile(name, bank, build, speed, lightoverride,  hitfx ,colour)
return MakeProjectile("tz_projectile", "fireball_fx", "fireball_2_fx", 15, 1, "tz_fireball_hit_fx",0),
	   MakeProjectile("tz_xin_cjb", "fireball_fx", "fireball_2_fx", 15, 1, "tz_fireball_hit_fx",0),
	   MakeProjectile("tz_projectile_bai", "baiball_2_fx", "baiball_2_fx", 26, 0, "tz_baiball_hit_fx",1),
	   MakeProjectile("tz_projectile_purple", "tz_lightball_fx", "tz_lightball_fx", 26, 1, "explosivehit",1),

       MakeProjectile("tz_projectile_fhzlz", "tz_projectile_fhzlz", "tz_projectile_fhzlz", 20, 1, nil,1),

       Prefab("tz_fireball_hit_fx", fireballhit_fn, assets),
	   Prefab("tz_baiball_hit_fx", fireballbaihit_fn, assets)
