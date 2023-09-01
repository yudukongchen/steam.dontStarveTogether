require "prefabutil"

local dist1 = 0.8
local dist2 = 0.85
local dist3 = 0.95
local dist4 = 1.1
local dist5 = 1.2

local prefabs = 
{
    "sparks",
}

local function PushAnimation(inst, anim, loop)
    inst.AnimState:PushAnimation(anim, loop)
end


local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
   fx:SetMaterial("metal")
    if inst.repairtask then
		inst.repairtask:Cancel()
		inst.repairtask = nil
	end
	
	if inst.arm1 then
		inst.arm1:Remove()
	end
	if inst.arm2 then
		inst.arm2:Remove()
	end
	if inst.arm3 then
		inst.arm3:Remove()
	end
	if inst.floattask then
		inst.floattask:Cancel()
		inst.floattask = nil
	end
	
	if inst.floattask2 then
		inst.floattask2:Cancel()
		inst.floattask2 = nil
	end
	if inst.top then
		inst.top:Remove()
		inst.top = nil
	end
    inst:Remove()
end

local function onsave(inst, data)
	-- if inst.arm1 then
		-- data.arm1 = inst.arm1
	-- end
	-- if inst.arm2 then
		-- data.arm2 = inst.arm2
	-- end
	-- if inst.arm3 then
		-- data.arm3 = inst.arm3
	-- end
	-- if inst.top then
		-- data.top = inst.top
	-- end
end

local function onload(inst, data)
	-- if data then
		-- inst.arm1 = data.arm1
		-- inst.arm2 = data.arm2
		-- inst.arm3 = data.arm3
		
		-- local x,y,z = inst.Transform:GetWorldPosition()
		-- local dist = 1.2
		-- inst.arm1.Transform:SetPosition(x,y,z+2*dist)
		-- inst.arm2.Transform:SetPosition(x-1.5*dist,y,z-1*dist)
		-- inst.arm3.Transform:SetPosition(x+1.5*dist,y,z-1*dist)
		-- inst.arm1:FacePoint(x,y,z)
		-- inst.arm2:FacePoint(x,y,z)
		-- inst.arm3:FacePoint(x,y,z)
	-- end
	inst.arm1 = SpawnPrefab("asa_shop_arm")
	inst.arm2 = SpawnPrefab("asa_shop_arm")
	inst.arm3 = SpawnPrefab("asa_shop_arm")
	
	inst.arm1.Transform:SetPosition(0,0,-2*dist1)
	inst.arm2.Transform:SetPosition(1.5*dist1,0,1*dist1)
	inst.arm3.Transform:SetPosition(-1.5*dist1,0,1*dist1)
	inst.arm1:FacePoint(0,0,0)
	inst.arm2:FacePoint(0,0,0)
	inst.arm3:FacePoint(0,0,0)
	
	inst.arm1.entity:SetParent(inst.entity)
	inst.arm2.entity:SetParent(inst.entity)
	inst.arm3.entity:SetParent(inst.entity)
	inst:DoTaskInTime(0.8,function()
		local x,y,z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z,1)
		for k,v in pairs (ents) do
			if v:HasTag("asa_shop_top") and inst.top ~= v then
				v:Remove()
			end
		end
	end)
end


local function onhit(inst, worker)
end

local function createmachine()
	local function onturnon(inst)
		if not inst.AnimState:IsCurrentAnimation("base_build") then
			inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_run", "sound")
			inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/shop_on",nil,0.3)
			inst.AnimState:PlayAnimation("base_turnon")
			inst.AnimState:PushAnimation("base_idle_on")
			inst.Light:Enable(true)
			inst.components.lighttweener:StartTween(nil, 2, nil, nil, nil, 0.2)
			
			if inst.arm1 then
				inst.arm1.AnimState:PlayAnimation("arm_pre")
				inst.arm1.AnimState:PushAnimation("arm_loop")
			end
			if inst.arm2 then
				inst.arm2.AnimState:PlayAnimation("arm_pre")
				inst.arm2.AnimState:PushAnimation("arm_loop")
				inst:DoTaskInTime(0.22,function()
					if inst.arm2 then
						inst.arm2.AnimState:SetTime(0.5 + 0.5 * math.random())
					end
				end)
			end
			if inst.arm3 then
				inst.arm3.AnimState:PlayAnimation("arm_pre")
				inst.arm3.AnimState:PushAnimation("arm_loop")
			end

			if inst.top then
				inst.top:Remove()
				inst.top = nil
			end

			if not inst.top then
				inst:DoTaskInTime(0.1,function()
					local x,y,z = inst.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x,y,z,1)
					for k,v in pairs (ents) do
						if v:HasTag("asa_shop_top") and inst.top ~= v then
							v:Remove()
						end
					end
				end)
				inst:DoTaskInTime(0.15,function()
					local x,y,z = inst.Transform:GetWorldPosition()
					inst.top = SpawnPrefab("asa_shop_top")
					inst.top.Transform:SetPosition(x,y,z)
					
					inst.top:FacePoint(x,y,z+1)
					inst.top.Physics:SetMotorVelOverride(0,18,0)
					inst:DoTaskInTime(0.2,function()
						if inst.top then
							inst.top.Physics:Stop()
						end
					end)
				end)
				
				inst.floattask = inst:DoPeriodicTask(2,function()
					local x,y,z = inst.Transform:GetWorldPosition()
					inst.top.Transform:SetPosition(x,y+2.5,z)
					inst.top.Physics:SetMotorVelOverride(0,1.6,0)
				end,1)
				inst.floattask2 = inst:DoPeriodicTask(2,function()
					inst.top.Physics:Stop()
				end)
			end
			
			inst.arm1.Transform:SetPosition(0,0,-2*dist1)
			inst.arm2.Transform:SetPosition(1.5*dist1,0,1*dist1)
			inst.arm3.Transform:SetPosition(-1.5*dist1,0,1*dist1)
			inst:DoTaskInTime(0.05,function()
				inst.arm1.Transform:SetPosition(0,0,-2*dist2)
				inst.arm2.Transform:SetPosition(1.5*dist2,0,1*dist2)
				inst.arm3.Transform:SetPosition(-1.5*dist2,0,1*dist2)
			end)
			inst:DoTaskInTime(0.1,function()
				inst.arm1.Transform:SetPosition(0,0,-2*dist3)
				inst.arm2.Transform:SetPosition(1.5*dist3,0,1*dist3)
				inst.arm3.Transform:SetPosition(-1.5*dist3,0,1*dist3)
			end)
			inst:DoTaskInTime(0.15,function()
				inst.arm1.Transform:SetPosition(0,0,-2*dist4)
				inst.arm2.Transform:SetPosition(1.5*dist4,0,1*dist4)
				inst.arm3.Transform:SetPosition(-1.5*dist4,0,1*dist4)
			end)
			inst:DoTaskInTime(0.2,function()
				inst.arm1.Transform:SetPosition(0,0,-2*dist5)
				inst.arm2.Transform:SetPosition(1.5*dist5,0,1*dist5)
				inst.arm3.Transform:SetPosition(-1.5*dist5,0,1*dist5)
			end)
			
			local x,y,z = inst.Transform:GetWorldPosition()
			inst.repairtask = inst:DoPeriodicTask(3,function()
				local ents = TheSim:FindEntities(x, 0, z, 3.5)
				for k,v in pairs(ents)do
					-- if v:HasTag("player") then
					if v:HasTag("asakiri") and v.components.health and not v.components.health:IsDead() then
						if v.components.hunger and not v.components.hunger:IsStarving() and v.components.health:GetPercent() < 1 then
							v:DoTaskInTime(math.random(),function()
								v.components.health:DoDelta(8)
								SpawnPrefab("sparks").Transform:SetPosition(v.Transform:GetWorldPosition())
							end)
						end
					end
					if v:HasTag("asa_item") and v.components.fueled:GetPercent() < 1 then
						v:DoTaskInTime(math.random()/2,function()
							--统一回复
							SpawnPrefab("sparks").Transform:SetPosition(v.Transform:GetWorldPosition())
							if v:HasTag("asa_shield_drone") then
								v.components.fueled:DoDelta(v.components.fueled.maxfuel / 20)
							else
								v.components.fueled:DoDelta(v.components.fueled.maxfuel / 5)
							end
							--斧头特殊处理
							if v:HasTag("asa_axe") then
								if v.components.fueled:IsEmpty() then
									v.components.weapon:SetDamage(59.5)
									v.components.tool:SetAction(ACTIONS.CHOP, 4)
									v.components.tool:SetAction(ACTIONS.MINE, 2)
								end
								if v.components.equippable:IsEquipped() then
									v.components.fueled:StartConsuming()
									v.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "swap_asa_axe", "swap_asa_axe")
								end
							end
						end)
					end

				end
			end)
		end
	end
	
	local function onturnoff(inst)
	    inst.AnimState:PlayAnimation("base_turnoff")
	    inst.AnimState:PushAnimation("base_idle_off")
	    inst.components.lighttweener:StartTween(nil, 0, nil, nil, nil, 0.2, function(inst)inst.Light:Enable(false)end)
		
		inst.SoundEmitter:KillSound("sound")
		inst:DoTaskInTime(0.3,function()
			inst.SoundEmitter:PlaySound("wintersfeast2019/winters_feast/oven/start")
		end)
		if inst.repairtask then
			inst.repairtask:Cancel()
			inst.repairtask = nil
		end
		if inst.arm1 then
			inst.arm1.AnimState:PlayAnimation("arm_pst")
			inst.arm1.AnimState:PushAnimation("arm_idle")
		end
		if inst.arm2 then
			inst.arm2.AnimState:PlayAnimation("arm_pst")
			inst.arm2.AnimState:PushAnimation("arm_idle")
		end
		if inst.arm3 then
			inst.arm3.AnimState:PlayAnimation("arm_pst")
			inst.arm3.AnimState:PushAnimation("arm_idle")
		end
		inst:DoTaskInTime(0.2,function()
			inst.arm1.Transform:SetPosition(0,0,-2*dist1)
			inst.arm2.Transform:SetPosition(1.5*dist1,0,1*dist1)
			inst.arm3.Transform:SetPosition(-1.5*dist1,0,1*dist1)
		end)
		inst:DoTaskInTime(0.15,function()
			inst.arm1.Transform:SetPosition(0,0,-2*dist2)
			inst.arm2.Transform:SetPosition(1.5*dist2,0,1*dist2)
			inst.arm3.Transform:SetPosition(-1.5*dist2,0,1*dist2)
		end)
		inst:DoTaskInTime(0.1,function()
			inst.arm1.Transform:SetPosition(0,0,-2*dist3)
			inst.arm2.Transform:SetPosition(1.5*dist3,0,1*dist3)
			inst.arm3.Transform:SetPosition(-1.5*dist3,0,1*dist3)
		end)
		inst:DoTaskInTime(0.05,function()
			inst.arm1.Transform:SetPosition(0,0,-2*dist4)
			inst.arm2.Transform:SetPosition(1.5*dist4,0,1*dist4)
			inst.arm3.Transform:SetPosition(-1.5*dist4,0,1*dist4)
		end)
		
		if inst.floattask then
			inst.floattask:Cancel()
			inst.floattask = nil
		end
		
		if inst.floattask2 then
			inst.floattask2:Cancel()
			inst.floattask2 = nil
		end
		if inst.top then
			inst.top.Physics:SetMotorVelOverride(0,-16,0)
		end
		inst:DoTaskInTime(0.2,function()
			if inst.top then
				inst.top:Remove()
				inst.top = nil
			end
		end)
	end

	local assets = 
	{
		Asset("ANIM", "anim/asa_shop.zip"),
	}

	local function fn(Sim)
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
		local minimap = inst.entity:AddMiniMapEntity()
		local light = inst.entity:AddLight()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
		minimap:SetIcon("asa_shop.tex")
		
		light:Enable(false)
    	light:SetRadius(5)
    	light:SetFalloff(.4)
    	light:SetIntensity(.8)
    	light:SetColour(0.1,0.1,1)

		minimap:SetPriority( 5 )
		minimap:SetIcon( "asa_shop.tex" )
	    
		--MakeObstaclePhysics(inst, 0.2)

		local s = 1.3
		trans:SetScale(s,s,s)
	    
		anim:SetBank('asa_shop')
		anim:SetBuild('asa_shop')
		anim:PlayAnimation("base_idle_off")
		anim:SetOrientation(ANIM_ORIENTATION.OnGround)
		anim:SetSortOrder(-2)
		
		anim:SetBloomEffectHandle("shaders/anim.ksh")
		
        inst:AddTag("structure")

        MakeSnowCoveredPristine(inst)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
        	return inst
    	end
		
		inst:AddComponent("inspectable")

    	inst:AddComponent("prototyper")
        inst.components.prototyper.onturnon = onturnon
        inst.components.prototyper.onturnoff = onturnoff
        inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ASA_TECH_ONE

    	inst:AddComponent('lighttweener')
    	inst.components.lighttweener:StartTween(light, 1, .9, 0.9, { 0.1,0.5,0.9}, 0, function(inst)inst.Light:Enable(false)end)

		if inst.arm1 == nil then
			inst.arm1 = SpawnPrefab("asa_shop_arm")
			inst.arm1.Transform:SetPosition(0,0,-2*dist1)
			inst.arm1.entity:SetParent(inst.entity)
			inst.arm1:FacePoint(0,0,0)
		end

		if inst.arm2 == nil then
			inst.arm2 = SpawnPrefab("asa_shop_arm")
			inst.arm2.Transform:SetPosition(1.5*dist1,0,1*dist1)
			inst.arm2.entity:SetParent(inst.entity)
			inst.arm2:FacePoint(0,0,0)
		end

		if inst.arm3 == nil then
			inst.arm3 = SpawnPrefab("asa_shop_arm")
			inst.arm3.Transform:SetPosition(-1.5*dist1,0,1*dist1)
			inst.arm3.entity:SetParent(inst.entity)
			inst.arm3:FacePoint(0,0,0)
		end


		inst:ListenForEvent( "onbuilt", function()
			anim:PlayAnimation("base_build")
			inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl2_place")
			inst.SoundEmitter:PlaySound("dontstarve/common/lightning_rod_craft")
			PushAnimation(inst, "base_idle_off")

			if inst.arm1 == nil then
				inst.arm1 = SpawnPrefab("asa_shop_arm")
				inst.arm1.Transform:SetPosition(0,0,-2*dist1)
				inst.arm1.entity:SetParent(inst.entity)
				inst.arm1:FacePoint(0,0,0)
			end

			if inst.arm2 == nil then
				inst.arm2 = SpawnPrefab("asa_shop_arm")
				inst.arm2.Transform:SetPosition(1.5*dist1,0,1*dist1)
				inst.arm2.entity:SetParent(inst.entity)
				inst.arm2:FacePoint(0,0,0)
			end

			if inst.arm3 == nil then
				inst.arm3 = SpawnPrefab("asa_shop_arm")
				inst.arm3.Transform:SetPosition(-1.5*dist1,0,1*dist1)
				inst.arm3.entity:SetParent(inst.entity)
				inst.arm3:FacePoint(0,0,0)
			end

			inst:DoTaskInTime(0.05,function()
				inst.arm1.Transform:SetPosition(0,0,-2*dist2)
				inst.arm2.Transform:SetPosition(1.5*dist2,0,1*dist2)
				inst.arm3.Transform:SetPosition(-1.5*dist2,0,1*dist2)
			end)
			inst:DoTaskInTime(0.1,function()
				inst.arm1.Transform:SetPosition(0,0,-2*dist3)
				inst.arm2.Transform:SetPosition(1.5*dist3,0,1*dist3)
				inst.arm3.Transform:SetPosition(-1.5*dist3,0,1*dist3)
			end)
			inst:DoTaskInTime(0.15,function()
				inst.arm1.Transform:SetPosition(0,0,-2*dist4)
				inst.arm2.Transform:SetPosition(1.5*dist4,0,1*dist4)
				inst.arm3.Transform:SetPosition(-1.5*dist4,0,1*dist4)
			end)
			inst:DoTaskInTime(0.2,function()
				inst.arm1.Transform:SetPosition(0,0,-2*dist5)
				inst.arm2.Transform:SetPosition(1.5*dist5,0,1*dist5)
				inst.arm3.Transform:SetPosition(-1.5*dist5,0,1*dist5)
			end)
			--inst.arm1:FacePoint(0,0,0)
			--inst.arm2:FacePoint(0,0,0)
			--inst.arm3:FacePoint(0,0,0)
			--
			--inst.arm1.entity:SetParent(inst.entity)
			--inst.arm2.entity:SetParent(inst.entity)
			--inst.arm3.entity:SetParent(inst.entity)
			
			if inst.arm1 then
				inst.arm1.AnimState:PlayAnimation("arm_pre")
				inst.arm1.AnimState:PushAnimation("arm_loop")
			end
			if inst.arm2 then
				inst.arm2.AnimState:PlayAnimation("arm_pre")
				inst.arm2.AnimState:PushAnimation("arm_loop")
			end
			if inst.arm3 then
				inst.arm3.AnimState:PlayAnimation("arm_pre")
				inst.arm3.AnimState:PushAnimation("arm_loop")
			end
			
			inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_run", "sound")
			inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/shop_on",nil,0.3)
			inst.AnimState:PushAnimation("base_turnon")
			inst.AnimState:PushAnimation("base_idle_on")
			
			local pos = inst:GetPosition()
			local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,3,{"player"})
			for k,v in pairs(ents) do
				local pos1 = v:GetPosition()
				v:ForceFacePoint(pos.x, 0, pos.z)
				v.Physics:SetMotorVelOverride(-30, 0, 0)	--退下！
			end
		end)

		inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

		inst:AddComponent("lootdropper")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(10)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)

		inst.OnSave = onsave
		inst.OnLoad = onload


		-- MakeSnowCovered(inst, .01)
		
		
		
		return inst
	end
	return Prefab( "asa_shop", fn, assets)
end

return createmachine(), MakePlacer("asa_shop_placer", "asa_shop","asa_shop", "base_idle_on")
