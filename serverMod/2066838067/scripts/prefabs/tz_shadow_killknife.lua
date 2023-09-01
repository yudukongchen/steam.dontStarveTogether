local assets =
{
    Asset( "ANIM", "anim/taizhen.zip" ),
}

local function StartShadows(self)
	local fx = SpawnPrefab(self.Fx or "statue_transition_2") --statue_transition_2  blossom_hit_fx
	fx.Transform:SetPosition(self.Transform:GetWorldPosition())
	if not fx.AnimState then 
		fx.entity:AddAnimState()
	end 
	fx.AnimState:SetMultColour(unpack(self.FxColour))
	self.AnimState:PlayAnimation("lunge_pre")
	self.AnimState:PushAnimation("lunge_lag",false)
	--self.AnimState:PushAnimation("lunge_pst")
	
	--[[self:ListenForEvent("animover",function()
		if self.AnimState:IsCurrentAnimation("lunge_lag") then
			self.AnimState:SetBank("lavaarena_shadow_lunge")
			self.AnimState:SetBuild("waxwell_shadow_mod")
			self.AnimState:AddOverrideBuild("lavaarena_shadow_lunge")
			self.AnimState:PlayAnimation("lunge_pst")
		end
	end)--]]
	
	
	
	self:DoTaskInTime(7*FRAMES, function(inst) 
		inst.Physics:SetMotorVel(self.Speed or 30, 0, 0)
		inst.AttackTask = inst:DoPeriodicTask(0,function(inst)
			local x,y,z = inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x,y,z,2,{"_combat"})
			
			for k,v in pairs(ents) do 
				if inst.player and inst.player:IsValid() and inst.player.components.combat:CanTarget(v) and not inst.player.components.combat:IsAlly(v) and not inst.HitedTargets[v] then 
					SpawnAt("tz_killknife_fx",v:GetPosition()+Vector3(0,1,0)).Transform:SetScale(2,2,2)
					if inst.caster then
						local wq = inst.caster.components.combat:GetWeapon()
						v.components.combat:GetAttacked(inst.caster,inst.caster.components.combat:CalcDamage(v, wq, 0.5),wq)
					else
						v.components.combat:GetAttacked(inst,inst.damage)
					end
					inst.HitedTargets[v] = true
					inst.SoundEmitter:PlaySound("dontstarve/common/lava_arena/fireball")
				end
			end
		end)
	end)
	self:DoTaskInTime(13*FRAMES, function(inst) 
		--inst.Physics:SetMotorVelOverride(5, 0, 0) 
		inst.AnimState:SetBank("lavaarena_shadow_lunge")
		inst.AnimState:SetBuild("waxwell_shadow_mod")
		inst.AnimState:AddOverrideBuild("lavaarena_shadow_lunge")
		inst.AnimState:PlayAnimation("lunge_pst")
	end )
	self:DoTaskInTime(17*FRAMES, function(inst) 
		inst.Physics:ClearMotorVelOverride() 
		inst.AttackTask:Cancel()
		
	end)
	self:DoTaskInTime(30*FRAMES, function(inst) inst:Remove() end)
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    --inst.entity:AddDynamicShadow()
	inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    --inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("wilson") 
	inst.AnimState:SetBuild("taizhen")
    inst.AnimState:PlayAnimation("idle")
	
    inst.AnimState:Show("ARM_carry")
    inst.AnimState:Hide("ARM_normal")
	
	inst.AnimState:AddOverrideBuild("player_lunge")
    inst.AnimState:AddOverrideBuild("player_attack_leap")
    inst.AnimState:AddOverrideBuild("player_superjump")
    inst.AnimState:AddOverrideBuild("player_multithrust")
    inst.AnimState:AddOverrideBuild("player_parryblock")
	
	
	inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:SetCapsule(.5, 1)

    inst:AddTag("scarytoprey")
    inst:AddTag("NOBLOCK")
	inst:AddTag("tz_shadow")
	inst:AddTag("NO_TIME_STOP")


    inst.entity:SetPristine()
	

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.HitedTargets = {}
	inst.FxColour = {0,0,0,0.7}

	inst:AddComponent("colouradder")
   
    inst:AddComponent("bloomer")

    inst:AddComponent("inventory")
	
	inst.SetFx = function(self,fx,colour)
		self.Fx = fx
		self.FxColour = colour
	end
	
	inst.SetHitSound = function(self,sound)
		self.HitSound = sound
	end 
	
	inst.SetSpeed = function(self,speed)
		self.Speed = speed 
	end 
	
	inst.SetPlayer = function(self, player)
		self.player = player
	end
	
	inst.SetDamage = function(self,damage)
		self.damage = damage or 0
	end 
	
	inst.Init = function(self,owner,build,noweapon,colour,setmultcolour)
		self:SetPlayer(owner)
		self.AnimState:SetBank("wilson") 
		self.AnimState:SetBuild(build or owner.prefab)
		inst.AnimState:OverrideSymbol("swap_object", "swap_nightmaresword_shadow", "swap_nightmaresword_shadow")
		colour = colour or self.FxColour or {0,0,0,0.7}
		if setmultcolour then 
			self.AnimState:SetMultColour(unpack(colour))
		else
			self.components.colouradder:PushColour("charge",unpack(colour) )
		end 
		
		if owner and not noweapon then
			local weapon = owner.components.combat:GetWeapon()
			if weapon then 
				local shadoweapon = SpawnPrefab(weapon.prefab)
				local x,y,z = self:GetPosition():Get()
				shadoweapon.Transform:SetPosition(x,y,z)
				self.components.inventory:Equip(shadoweapon)
                shadoweapon:ListenForEvent("unequip",function() shadoweapon:Remove() end,self)
                shadoweapon:ListenForEvent("onremove",function() shadoweapon:Remove() end,self)
                shadoweapon.persists = false
			end
		end 
	end 
	
	inst.StartShadows = StartShadows
	
	
	

	
	inst.persists = false 

    return inst
end

return Prefab("tz_shadow_killknife", fn, assets)