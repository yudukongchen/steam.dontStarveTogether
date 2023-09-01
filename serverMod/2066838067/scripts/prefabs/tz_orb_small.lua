
local function applydamagetoent(inst,ent)
	local v = ent
	if  v and v:IsValid() and not (v.components.health ~= nil and v.components.health:IsDead())  then            
		if inst.owner  ~= nil then
			v:PushEvent("attacked", { attacker = inst.owner, damage = 0, weapon = inst })
		end
        if v.components.freezable ~= nil then
            if not v.components.freezable:IsFrozen() then
                v.components.freezable:AddColdness(1)
				v.components.freezable:SpawnShatterFX()
            end
        end
	end
end

local function OnCollidesmall(inst,other)
    applydamagetoent(inst,other)

    local explosion = SpawnPrefab("tz_orb_small_fx")
    explosion.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
	explosion.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_impact")
    
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    MakeCharacterPhysics(inst, 1, 0.5)
	
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.GROUND)
	inst.Physics:CollidesWith(COLLISION.GIANTS)

    anim:SetBank("tz_iceball")
    anim:SetBuild("tz_iceball")
    anim:PlayAnimation("attack_loop", true)    

    inst.Transform:SetScale(1.2,1.2,1.2) --飞行的大小

	inst:AddTag("projectile")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.Physics:SetCollisionCallback(OnCollidesmall)
		
    inst.persists = false

    inst:AddComponent("locomotor")

    inst:DoTaskInTime(0.85,OnCollidesmall)
	
    return inst
end

local function explosionfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    inst.AnimState:SetBuild("tz_iceball")
    inst.AnimState:SetBank("tz_iceball")
    inst.AnimState:PlayAnimation("attack_end")
    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
	inst.Transform:SetScale(1.4,1.4,1.4) --爆炸的大小
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    inst:ListenForEvent("animover", function(inst) inst:Remove() end)
    return inst
end

return Prefab("tz_orb_small", fn),
	Prefab("tz_orb_small_fx", explosionfn)
