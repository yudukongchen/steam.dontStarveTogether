local assets =
{
    Asset("ANIM", "anim/zan_light.zip"),
	Asset("ANIM", "anim/asa_ring.zip"),
	Asset("ANIM", "anim/asa_max_fx.zip"),
	Asset("ANIM", "anim/asa_tornado_fxs.zip"),
	Asset("ANIM", "anim/asa_lightning.zip"),
	Asset("ANIM", "anim/asa_drone.zip"),
}

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:SetPristine()
    
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("zan_light")
	inst.AnimState:SetBank("zan_light")
    inst.AnimState:SetBuild("zan_light")
	if math.random() > 0.5 then
		inst.AnimState:PlayAnimation("idle_1")
	else
		inst.AnimState:PlayAnimation("idle_2")
	end
	inst.AnimState:SetLightOverride(0.8)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	local s = 2.5
	inst.AnimState:SetScale(s,0.6*s,s)
	
	inst.AnimState:SetSortOrder(1)
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddNetwork()
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("asa_ring")
	
	inst.AnimState:SetBank("asa_ring")
    inst.AnimState:SetBuild("asa_ring")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	
	inst.AnimState:SetLightOverride(0.3)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	local s = 5.2
	inst.AnimState:SetScale(s,s,s)
	
	inst.AnimState:SetSortOrder(0)
	-- if not TheWorld.ismastersim then
		-- return inst
	-- end
	
	-- inst.entity:SetPristine()
	--inst.persists = false
	--inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:SetPristine()
    inst.entity:AddLight()
	
	inst.Light:SetIntensity(.8)
    inst.Light:SetColour(1, 0.2, 0.2)
    inst.Light:SetFalloff(.8)
    inst.Light:SetRadius(2)
    inst.Light:Enable(true)
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst.AnimState:SetBank("asa_max_fx")
    inst.AnimState:SetBuild("asa_max_fx")
	inst.AnimState:PlayAnimation("idle")
	
	inst.AnimState:SetLightOverride(0.8)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	local s = 8
	inst.AnimState:SetScale(s,s,s)
	
	inst.AnimState:SetSortOrder(3)
	
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end

local function fn4()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:SetPristine()
    
	inst:AddTag("FX")
	inst.Transform:SetEightFaced()
	inst.AnimState:SetBank("asa_tornado_fxs")
    inst.AnimState:SetBuild("asa_tornado_fxs")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(1)
	
	local s = 3
	inst.AnimState:SetScale(s,s,s)
	
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end

local function fn5()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:SetPristine()
    
	inst:AddTag("FX")
	inst.AnimState:SetBank("asa_tornado_fxs")
    inst.AnimState:SetBuild("asa_tornado_fxs")
	inst.AnimState:PlayAnimation("tornado", true)
	inst.AnimState:SetSortOrder(3)
	local s = 5
	inst.AnimState:SetScale(s,s,s)
	
    return inst
end

local function fn6()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	-- inst:AddTag("asa_ring")
	
	inst.AnimState:SetBank("asa_ring")
    inst.AnimState:SetBuild("asa_ring")
	inst.AnimState:PlayAnimation("idle_alert")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	
	inst.AnimState:SetLightOverride(0.4)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	local s = 0.8
	inst.AnimState:SetScale(s,s,s)
	
	inst.AnimState:SetSortOrder(0)
	-- if not TheWorld.ismastersim then
		-- return inst
	-- end
	
	-- inst.entity:SetPristine()
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end

local function fn7()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst.AnimState:SetBank("asa_ring")
    inst.AnimState:SetBuild("asa_ring")
	inst.AnimState:PlayAnimation("idle_target")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	
	inst.AnimState:SetLightOverride(0.3)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	local s = 4
	inst.AnimState:SetScale(s,s,s)
	
	inst.AnimState:SetSortOrder(1)
	-- if not TheWorld.ismastersim then
		-- return inst
	-- end
	
	-- inst.entity:SetPristine()
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end

local function fn8()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:SetPristine()
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst.AnimState:SetBank("asa_shop")
    inst.AnimState:SetBuild("asa_shop")
	inst.AnimState:PlayAnimation("arm_idle")
	local s = 0.8
	inst.AnimState:SetScale(s,s,s)
	
	inst.Transform:SetEightFaced()
	
    return inst
end

local function fn9()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:SetPristine()
	
    MakeGhostPhysics(inst,50,0)
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("asa_shop_top")
	inst.AnimState:SetBank("asa_shop")
    inst.AnimState:SetBuild("asa_shop")
	inst.AnimState:PlayAnimation("top")
	local s = 1.6
	inst.AnimState:SetScale(s,s,s)
	
	-- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	inst.Transform:SetEightFaced()
	
	--关键！防止下线还保存，重复出现，这玩意儿就是个壳子，踢起来可轻
	inst.persists = false
    return inst
end

local function fn10()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:SetPristine()
    
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst.AnimState:SetBank("asa_lightning")
    inst.AnimState:SetBuild("asa_lightning")
	inst.AnimState:PlayAnimation("red_idle",true)
	inst.AnimState:SetTime(math.random()/1.5)
	inst.AnimState:SetLightOverride(0.3)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	local s = 0.25
	inst.AnimState:SetScale(s,s,s)
	
    return inst
end

local function fn11()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:SetPristine()

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst.AnimState:SetBank("asa_shield_fx")
	inst.AnimState:SetBuild("asa_drone")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetLightOverride(0.3)

	inst.Transform:SetEightFaced()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)

	inst.SetInit = function(inst, owner, attacker)
		local x,y,z = owner.Transform:GetWorldPosition()
		inst.Transform:SetPosition(x, 1.5, z)
		inst:FacePoint(attacker:GetPosition())
	end

	return inst
end

local function fn12()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:SetPristine()

	inst.entity:AddLight()
	inst.Light:SetIntensity(.6)
	inst.Light:SetColour(0, 0.6, 1)
	inst.Light:SetFalloff(.3)
	inst.Light:SetRadius(0.3)
	inst.Light:Enable(true)

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst.AnimState:SetBank("asa_drone")
	inst.AnimState:SetBuild("asa_drone")
	inst.AnimState:PlayAnimation("idle_pre")
	inst.AnimState:PushAnimation("idle_loop", true)
	inst.AnimState:SetLightOverride(0.2)
	inst.AnimState:SetSortOrder(3)


	inst.persists = false

	return inst
end
--5草原，4光地，3岩石，12棋盘，11地毯，42月岛沙滩，43月岛地板，30桦树林，8沼泽，31荒漠,200多是海洋
local function GetMirage(inst)
	if TheWorld:HasTag("cave") then
		local building = FindEntity(inst, 20, nil, {"giftmachine"})
		local mush = FindEntity(inst, 10, nil, {"mushtree"})
		local plant = FindEntity(inst, 10, nil, {"plant"})
		local chess = FindEntity(inst, 15, nil, {"chess"})
		local statue = FindEntity(inst, 15, nil, {"statue"})
		if building ~= nil then
			return  { "tent", "tent", "idle" }
		elseif mush ~= nil then
			if mush.prefab == "mushtree_tall" then
				return  { "mushroom_tree", "mushroom_tree_tall", "idle_loop" }
			elseif mush.prefab == "mushtree_medium" then
				return  { "mushroom_tree_med", "mushroom_tree_med", "idle_loop" }
			elseif mush.prefab == "mushtree_small" then
				return  { "mushroom_tree_small", "mushroom_tree_small", "idle_loop" }
			elseif mush.prefab == "mushtree_moon" then
				return  { "mushroom_tree", "mutatedmushroom_tree_build", "idle_loop" }
			end
		elseif statue ~= nil then
			return  { "statue_ruins_small", "statue_ruins_small", "idle_full" }
		elseif chess ~= nil then
			return  { "atrium_overgrowth", "atrium_overgrowth", "idle" }
		elseif plant ~= nil then
			local ran = math.random()
			if ran < 0.3 then
				return  { "bulb_plant_single", "bulb_plant_single", "idle" }
			elseif ran < 0.6 then
				return  { "bulb_plant_double", "bulb_plant_double", "idle" }
			else
				return  { "bulb_plant_triple", "bulb_plant_triple", "idle" }
			end
		else
			local ran = math.random()
			if ran < 0.3 then
				return  { "rock_stalagmite_tall", "rock_stalagmite_tall", "full_"..tostring(math.random(2)) }
			elseif ran < 0.6 then
				return  { "rock_stalagmite_tall", "rock_stalagmite_tall", "med_"..tostring(math.random(2)) }
			else
				return  { "rock_stalagmite_tall", "rock_stalagmite_tall", "low_"..tostring(math.random(2)) }
			end
		end
	else
		local mist = FindEntity(inst, 10, nil, {"erd_misttree"})
		local building = FindEntity(inst, 20, nil, {"giftmachine"})
		local leaftree = FindEntity(inst, 8, nil, {"deciduoustree"})
		local frozen = FindEntity(inst, 10, nil, {"frozen"})
		local king = FindEntity(inst, 15, nil, {"king"})
		local rock2 = FindEntity(inst, 10, nil, {"erd_rock2"})
		if king ~= nil and king.prefab == "pigking" then
			return  { "pig_house", "pig_house", "idle" }
		elseif building ~= nil then
			return  { "tent", "tent", "idle" }
		elseif rock2 ~= nil then
			return  { "erd_rock2", "erd_rocks", "idle4" }
		elseif mist ~= nil then
			return  { "erd_spring", "erd_spring", "full" }
		elseif frozen ~= nil and frozen.prefab == "rock_ice" then
			return  { "ice_boulder", "ice_boulder", "full" }
		elseif leaftree ~= nil then
			return  { "tree_leaf", "tree_leaf_trunk_build", "sway1_loop_tall" }
		else
			local x,y,z = inst.Transform:GetWorldPosition()
			if TheWorld.Map:GetTileAtPoint(x, 0, z) == 3 then
				if math.random() < 0.4 then
					return  { "rock", "rock", "full" }
				else
					return { "rock2", "rock2", "full" }
				end
			elseif TheWorld.Map:GetTileAtPoint(x, 0, z) == 4
					or TheWorld.Map:GetTileAtPoint(x, 0, z) == 42 or TheWorld.Map:GetTileAtPoint(x, 0, z) == 5 then
				return { "rock", "rock", "full" }
			elseif TheWorld.Map:GetTileAtPoint(x, 0, z) == 31 then
				return { "rock_flintless", "rock_flintless", "full" }
			elseif TheWorld.Map:GetTileAtPoint(x, 0, z) == 43 then
				if math.random() < 0.4 then
					return { "rock5", "rock7", "full" }
				else
					return { "moonglass_rock", "moonglass_rock", "full" }
				end
			elseif TheWorld.Map:GetTileAtPoint(x, 0, z) == 30 then
				return { "pig_house", "pig_house", "idle" }
			elseif TheWorld.Map:GetTileAtPoint(x, 0, z) == 8 then
				return { "merm_house", "merm_house", "idle" }
			elseif TheWorld.Map:GetTileAtPoint(x, 0, z) == 12 or TheWorld.Map:GetTileAtPoint(x, 0, z) == 11 then
				return { "statue_small", "statue_small_type1_build", "full" }
			elseif TheWorld.Map:GetTileAtPoint(x, 0, z) == 201 or TheWorld.Map:GetTileAtPoint(x, 0, z) == 202
					or TheWorld.Map:GetTileAtPoint(x, 0, z) == 203 or TheWorld.Map:GetTileAtPoint(x, 0, z) == 204
					or TheWorld.Map:GetTileAtPoint(x, 0, z) == 205 or TheWorld.Map:GetTileAtPoint(x, 0, z) == 206
					or TheWorld.Map:GetTileAtPoint(x, 0, z) == 207 or TheWorld.Map:GetTileAtPoint(x, 0, z) == 208
			then
				return { "malbatross", "malbatross_build", "idle_loop" }
			else
				return { "evergreen_short", "evergreen_new", "sway1_loop_tall" }
			end
		end
	end
end

local function fn13()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeSnowCoveredPristine(inst)
	inst.entity:SetPristine()

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst.AnimState:SetBank("asa_mirage")
	inst.AnimState:SetBuild("asa_manufacture")
	inst.AnimState:PlayAnimation("idle_off")
	inst.AnimState:SetLightOverride(0.1)

	 if not TheWorld.ismastersim then
		 return inst
	 end

	inst.Appear = function(inst, master)
		--print("出现了")
		local bk = GetMirage(master)
		if bk then
			inst.AnimState:SetBank(bk[1])
			inst.AnimState:SetBuild(bk[2])
			inst.AnimState:PlayAnimation(bk[3], true)
			if bk[1] == "malbatross" then
				inst.Transform:SetScale(1.3, 1.3, 1.3)
				inst.Transform:SetSixFaced()
			elseif bk[1] == "tree_leaf" then
				if TheWorld.state.isautumn then
					if math.random() < 0.5 then
						inst.AnimState:OverrideSymbol("swap_leaves", "tree_leaf_red_build", "swap_leaves")
					else
						inst.AnimState:OverrideSymbol("swap_leaves", "tree_leaf_orange_build", "swap_leaves")
					end
				elseif not TheWorld.state.iswinter then
					inst.AnimState:OverrideSymbol("swap_leaves", "tree_leaf_green_build", "swap_leaves")
				end
			end
		end
		for i = 1, 10, 1 do
			inst:DoTaskInTime(i/30,function()
				inst.AnimState:SetAddColour(0, 0.5-i/20, 1-i/10, 1)
			end)
		end
		if master then
			inst.Transform:SetPosition(master.Transform:GetWorldPosition())
			inst.Transform:SetRotation(master.Transform:GetRotation())
			master.asa_mirage = inst
		end
	end

	inst.Disappear = function(inst)
		--print("我走了")
		for i = 1, 5, 1 do
			inst:DoTaskInTime(i/20,function()
				inst.AnimState:SetAddColour(0, i/10, i/5, 1)
			end)
		end

		for i = 1, 10, 1 do
			inst:DoTaskInTime(0.2 + i/30,function()
				inst.AnimState:SetMultColour(1,1,1,1-i/10)
			end)
		end
		inst:DoTaskInTime(1.2,function()
			inst:Remove()
		end)
	end

	inst.persists = false

	return inst
end

return Prefab("zan_light", fn1, assets),
	Prefab("asa_ring", fn2),
	Prefab("asa_max_fx", fn3),
	Prefab("asa_tornado_light", fn4),
	Prefab("asa_tornado", fn5),
	Prefab("asa_alertring", fn6),
	Prefab("asa_targetring", fn7),
	Prefab("asa_shop_arm", fn8),
	Prefab("asa_shop_top", fn9),
	Prefab("asa_lightning_red", fn10),
	Prefab("asa_shield_fx", fn11),
	Prefab("asa_drone_fx", fn12),
	Prefab("asa_mirage_fx", fn13)
