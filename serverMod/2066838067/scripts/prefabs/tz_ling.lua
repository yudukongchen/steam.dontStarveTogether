local brain = require("brains/tz_lingbrain")

local function onfar(inst,player)

end

local function onnear(inst,player)
    if player and player.components.tz_xx and player.components.tz_xx.dengji > 9  then
        if inst.components.follower:GetLeader() == nil  and not player.components.tz_xx_ling:IsFull() then
			inst:SpawnChild("tz_ling_use")
			player.components.tz_xx_ling:AddPet(inst)
		end
    end
end

local function MakeLing(name, siza, damage,sanity)
    local assets =
    {
	    Asset("ANIM", "anim/tz_ling.zip"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
		inst.entity:AddLight()

        inst.AnimState:SetBank("tz_ling")
        inst.AnimState:SetBuild("tz_ling")
        inst.AnimState:PlayAnimation("proximity_loop")

		MakeInventoryPhysics(inst)
		inst.Light:SetIntensity(.9)
		inst.Light:SetRadius(2)
		inst.Light:SetFalloff(.9)
		inst.Light:Enable(true)
		inst.Light:SetColour(180 / 255, 195 / 255, 225 / 255)
		inst.Physics:SetDontRemoveOnSleep(true)

        inst:AddTag("companion")
        inst:AddTag("notraptrigger")
        inst:AddTag("noauradamage")
        inst:AddTag("small_livestock")
        inst:AddTag("NOBLOCK")
		inst:AddTag("flying")

		local face = math.random(4)
		if face ~= 1 then
			inst.AnimState:OverrideSymbol("seed", "tz_ling","seed_"..face)
		end
		inst.AnimState:SetScale(siza, siza, siza)
		
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		inst.adddamage = damage
		inst.sizi = siza
	
        inst:AddComponent("inspectable")

        inst:AddComponent("follower")
        inst.components.follower:KeepLeaderOnAttacked()
        inst.components.follower.keepdeadleader = true
        inst.components.follower.keepleaderduringminigame = true

        inst:AddComponent("locomotor")
		inst.components.locomotor.walkspeed = 6
		inst.components.locomotor.runspeed = 6
		inst.components.locomotor.pathcaps = { allowocean = true }
		
		inst:AddComponent("playerprox")
		inst.components.playerprox:SetDist(1.5, 3)
		inst.components.playerprox:SetOnPlayerNear(onnear)
		inst.components.playerprox:SetOnPlayerFar(onfar)
	
        inst:AddComponent("timer")

        inst:SetBrain(brain)
        inst:SetStateGraph("SGtz_ling")

	    inst:AddComponent("sanityaura")
		inst.components.sanityaura.aura = sanity/60
		
		inst:ListenForEvent("timerdone", function()
			inst:PushEvent("godie")
		end)
        return inst
    end
    return Prefab(name, fn, assets)
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst.entity:AddAnimState()

	inst:AddTag("NOBLOCK")
	inst:AddTag("fx")
	
    inst.AnimState:SetBank("tz_ling") 
	inst.AnimState:SetBuild("tz_ling")
    inst.AnimState:PlayAnimation("use")
	inst.Transform:SetScale(2, 2, 2)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false 
	inst:ListenForEvent("animover", inst.Remove)
    return inst
end

return Prefab("tz_ling_use", fxfn),
	MakeLing("tz_ling_small", 0.6,50,10 ),
	MakeLing("tz_ling_nolmal", 1,80,20 ),
	MakeLing("tz_ling_big", 1.35,150,40 )
