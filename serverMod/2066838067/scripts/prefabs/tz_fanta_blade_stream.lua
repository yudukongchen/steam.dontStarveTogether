local function fn()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)


    if not TheWorld.ismastersim then
        return inst
    end

    inst.speed = 25
    inst.num = 12
    inst.persists = false
    inst.damage = 25
    inst.Hitted = {}

	inst.SpawnFX = function(inst)
		for i=0,0.33,0.33/inst.num do 
			local fx = inst:SpawnChild("tz_fanta_blade_stream_vfx") 
			fx.Transform:SetPosition(-i,0,0) 
			fx.NUM:set(15) 
			fx.HIEGHT:set(2.6 + (fx.HIEGHT:value() - 2.6) * i * 2)
		end
		local fx = inst:SpawnChild("tz_fanta_blade_stream_vfx")
		fx.Transform:SetPosition(0.1,0,0) 
		fx.HIEGHT:set(2.6)
		fx.TAIL_LENGTH:set(1.25)
	end

	inst.Shoot = function(inst,owner,targetpos,canattack)
		if targetpos then 
			inst:ForceFacePoint(targetpos:Get())
		else
			inst.Transform:SetRotation(owner:GetRotation())
		end
		inst.Physics:SetMotorVel(inst.speed,0,0)
		inst.SoundEmitter:PlaySound("dontstarve/common/lava_arena/fireball")
		inst:DoPeriodicTask(0,function()
			--SpawnAt("blossom_hit_fx",inst:GetPosition())
			local x,y,z = inst.Transform:GetWorldPosition()
			for k,v in pairs(TheSim:FindEntities(x,y,z,0.75,{"_combat"})) do 
				if not inst.Hitted[v] and (canattack and canattack(v,owner)) then 
					v.components.combat:GetAttacked(owner,inst.damage + GetRandomMinMax(0,5))
					local fx = SpawnAt("blossom_hit_fx",v:GetPosition())
					fx.AnimState:SetAddColour(36/256, 40/256, 170/256, 0)
					inst.Hitted[v] = true
				end
			end
		end)

		inst:DoTaskInTime(0.12,inst.SpawnFX)
		inst:DoTaskInTime(GetRandomMinMax(0.75,1),inst.Remove)
	end

    return inst

end
-- local fx = SpawnAt("tz_fanta_blade_stream",ThePlayer) fx:Shoot(ThePlayer,c_findnext("dummytarget"):GetPosition())
-- 
-- 2.6 + (fx.HIEGHT:value() - 2.6) * i * 2
return Prefab("tz_fanta_blade_stream",fn)