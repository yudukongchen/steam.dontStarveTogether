local assets =
{
    Asset("ANIM", "anim/tz_sword.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_tfsword.xml"),	
    Asset("ANIM", "anim/swap_tz_tfsword.zip"),
}

local prefabs =
{
    "tz_shandian",
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_tz_tfsword", "swap_tz_tfsword")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end
local function onspell(inst, doer ,pos)

	local x,y,z =  pos:Get()
	--print(x,y,z)
	local r = 7
	if doer.components.playercontroller ~= nil then
		doer.components.playercontroller:Enable(false)
	end
	if doer.components.health ~= nil then
		doer.components.health:SetInvincible(true)
	end
    if doer.DynamicShadow ~= nil then 
        doer.DynamicShadow:Enable(false)
    end
	doer:Hide()
	if doer._fenshenzhan  == nil then 
		doer._fenshenzhan =  doer:DoPeriodicTask(0.2, function()   
	        local ents = TheSim:FindEntities(x, y, z, 7, {"_health", "_combat"}, {"INLIMBO", "wall" , "playerghost" ,"player", "companion"})
			for i, v in ipairs(ents) do
				if  v and v:IsValid() and not v:IsInLimbo() then
					if v.components.combat ~= nil then
						v.components.combat:GetAttacked(doer, 55* (doer.prefab == "taizhen" and 1.2 or 1), inst)
					end
				end
			end	
		end)
	end
	doer:DoTaskInTime(12/45+1.4, function()
	if doer._fenshenzhan  ~= nil then 
        doer._fenshenzhan:Cancel()
        doer._fenshenzhan = nil
	end	
	end)
	doer:DoTaskInTime(12/45+2, function() 
	if doer.components.playercontroller ~= nil then
		doer.components.playercontroller:Enable(true)
	end
	if doer.components.health ~= nil then
		doer.components.health:SetInvincible(false)
	end
    if doer.DynamicShadow ~= nil then 
        doer.DynamicShadow:Enable(true)
    end
	doer:Show()
	end)
    doer:StartThread(function()
        for k = 1, 8 do  
		local g = k* 45 + math.random(-15,15)
			local fx = SpawnPrefab("tz_cccanying")
			if fx then
			fx.AnimState:SetBuild(doer.prefab)
			fx.Transform:SetPosition(x+ r*math.cos(2*math.pi/360*g),0,z+r*math.sin(2*math.pi/360*g))
			SpawnPrefab("statue_transition_2").Transform:SetPosition(fx.Transform:GetWorldPosition())
			fx:ForceFacePoint(x, 0, z)
			fx:DoTaskInTime(0.1, function()
			fx:Yichu(12/45+(8- k)*0.2+0.5)
			fx.Physics:SetMotorVel(40, 0 ,0)
			fx.SoundEmitter:PlaySound ("dontstarve/wilson/attack_nightsword")
					fx:DoTaskInTime(14/40, function()
					fx.Physics:Stop() 
					fx.Physics:SetMotorVel(0, 0, 0) 
					end)	
			end)
			end
            Sleep(.2)
        end
    end)
		inst.components.rechargeable:StartRecharge()
		if 	inst.components.tz_firelvl  then
			inst.components.tz_firelvl:DoDelta(-15)
		end
		if doer._tflight ~= nil then
			doer._tflight:Remove()
			doer._tflight = nil
			if doer.components.combat ~= nil then
				doer.components.combat.externaldamagemultipliers:RemoveModifier(inst)
			end
		end

end

local function onattack(inst, attacker, target)
	if target  and target:IsValid() then
		if 	inst.components.fueled  then
			inst.components.fueled:DoDelta(-4)
		end	
		if 	inst.components.tz_firelvl  then
			inst.components.tz_firelvl:DoDelta(1)
		end
		if attacker.components.sanity ~= nil then
			inst.components.weapon:SetDamage(attacker.components.sanity.max-attacker.components.sanity.current)
		end
	end
end
local function  imagechage(inst)
	if inst.components.tz_firelvl and inst.components.tz_firelvl.current == 15 and inst.components.rechargeable and
		inst.components.rechargeable.isready then
			if inst.components.equippable:IsEquipped() and  inst.components.inventoryitem.owner ~= nil then
			local owner = inst.components.inventoryitem.owner
				if owner._tflight == nil then
					owner._tflight = SpawnPrefab("tz_shandian")
					if owner._tflight then
						owner._tflight.entity:SetParent(owner.entity)
						owner._tflight.Follower:FollowSymbol(owner.GUID, "swap_body", 0, 0, 0.5)
						if  owner.components.combat then
							owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1.25)
						end
					end
				end
	end
	end
end

local function onfinished(inst)
	inst:Remove()
end

local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    --Cast range is 8, leave room for error
    --4 is the aoe range
    for r = 7, 0, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function DoSk(inst,key)
	if inst.components.fueled then
		inst.components.fueled:DoDelta(-160*0.08)
	end	
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_sword")
    inst.AnimState:SetBuild("tz_sword")
    inst.AnimState:PlayAnimation("idle",true)
	inst.AnimState:SetMultColour(1,1,1,0.5)

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("ljs")

	
        --[[inst:AddTag("rechargeable")

        inst:AddComponent("aoetargeting")
        inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoesummon"
        inst.components.aoetargeting.reticule.pingprefab = "reticuleaoesummonping"
        inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
        inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
        inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
        inst.components.aoetargeting.reticule.ease = true
        inst.components.aoetargeting.reticule.mouseenabled = true]]
		
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst.DoSk = DoSk
	
    --inst:AddComponent("tz_hyspell")
	--inst.components.tz_hyspell.spell = onspell
	
	--inst:AddComponent("tz_aoespell")
    --inst.components.aoespell = inst.components.tz_aoespell
	--inst.components.aoespell.canuseonpoint = true
	--inst.components.aoespell:SetSpellFn(onspell)
	--inst:RegisterComponentActions("aoespell")
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(65)
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetRange(0.7)
	inst:AddComponent("tz_firelvl")
	inst.components.tz_firelvl:Setmax(15)
	
	inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(160)
    inst.components.fueled:SetDepletedFn(onfinished)
    inst.components.fueled.accepting = true

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_tfsword.xml"
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst:ListenForEvent("tz_firelvl", imagechage)
	
	--inst:AddComponent("tz_rechargeable")
    --inst.components.rechargeable = inst.components.tz_rechargeable
	--inst.components.rechargeable:SetRechargeTime(30)
	--inst:RegisterComponentActions("rechargeable")
	
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("tz_tfsword", fn, assets,prefabs)