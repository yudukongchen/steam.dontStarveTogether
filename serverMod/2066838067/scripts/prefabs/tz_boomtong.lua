local assets = {
	Asset("ANIM", "anim/tz_boomtong.zip"),
	Asset("ANIM", "anim/explode.zip"),
	Asset("IMAGE","images/inventoryimages/tz_boomtong_item.tex"),
	Asset("ATLAS","images/inventoryimages/tz_boomtong_item.xml"),
}

local function OnIgniteFn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
    DefaultBurnFn(inst)
end

local function OnExtinguishFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    DefaultExtinguishFn(inst)
end

local function IsSleep(inst)
	return inst.components.sleeper and inst.components.sleeper:IsAsleep()
end 

local function OnExplodeFn(inst)
	local targetpos = inst:GetPosition()
	
    inst.SoundEmitter:KillSound("hiss")
    SpawnPrefab("explode_boomtong").Transform:SetPosition(inst.Transform:GetWorldPosition())
	local ring = SpawnPrefab("firering_fx")
	ring.Transform:SetScale(1.2,1.2,1.2)
	ring.Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	local splashnum = 8
	local pos = inst:GetPosition()
	for rota = 0,PI * 2,PI * 2/splashnum  do 
		local offset = Vector3(math.random()*10*math.cos(rota),0,math.random()*10*math.sin(rota))
		SpawnAt("firesplash_fx",pos+offset)
	end 
	--[[TheWorld:StartThread(function()
		for i = 1,5 do 
			local fx = SpawnPrefab("explode_boomtong")
			local rota = PI * math.random() * 2
			local rad = GetRandomMinMax(4,6)
			local offset = Vector3(math.random()*rad*math.cos(rota),0,math.random()*rad*math.sin(rota))
			fx.Transform:SetPosition((targetpos+offset):Get())
		end
		Sleep(0.1)
	end)--]]


    inst.components.lootdropper:DropLoot(targetpos)
	
	
	
	--爆炸组件本身就会造成一次伤害，所以不用写额外的
	--但是对睡眠敌人造成的增加伤害要写在这
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x,y,z,inst.components.explosive.explosiverange,{"_combat"})
	for k,v in pairs(ents) do 
		if v.components.combat ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) and IsSleep(v) then
            local dmg = 1200
            if v.components.explosiveresist ~= nil then
                dmg = dmg * (1 - v.components.explosiveresist:GetResistance())
                v.components.explosiveresist:OnExplosiveDamage(dmg, inst)
            end
            v.components.combat:GetAttacked(inst, dmg, nil)
        end
	end
end

local function OnDeath(inst)
	inst.components.burnable:Ignite(true)
end 

local function fn()
	local inst = CreateEntity()
		
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter() 
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, .5)
    inst.Physics:SetDontRemoveOnSleep(true)

		
	inst.AnimState:SetBank("tz_boomtong")
	inst.AnimState:SetBuild("tz_boomtong")
	inst.AnimState:PlayAnimation("loop",true)
	
	inst:AddTag("explosive")
		
	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")

    MakeSmallBurnable(inst,GetRandomMinMax(0.4,0.8))
    MakeSmallPropagator(inst)
	
	inst.components.burnable:SetOnBurntFn(nil)
    inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguishFn)

    inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive.explosivedamage = 600
	inst.components.explosive.explosiverange = 12
	
	inst:AddComponent("lootdropper")
    inst.components.lootdropper.max_speed = 8
    inst.components.lootdropper.min_speed = 4
    inst.components.lootdropper.y_speed = 3
    inst.components.lootdropper.y_speed_variance = 2
    inst.components.lootdropper.spawn_loot_inside_prefab = true
	
	--[[inst:AddComponent("groundpounder")
	inst.components.groundpounder.numRings = 8
    inst.components.groundpounder.burner = true
    inst.components.groundpounder.groundpoundfx = "firesplash_fx"
    inst.components.groundpounder.groundpounddamagemult = 0
    inst.components.groundpounder.groundpoundringfx = "firering_fx"--]]
	
	inst:AddComponent("combat")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(1)
	inst.components.health.fire_damage_scale = 0
	--inst.components.health.nofadeout = true
	
	inst:ListenForEvent("death",OnDeath)

	return inst
end 

local function item_fn()
	
	local function ondeploywall(inst, pt, deployer)
        local ent = SpawnPrefab("tz_boomtong") 
        if ent ~= nil then 
            local x = math.floor(pt.x) + .5
            local z = math.floor(pt.z) + .5
            ent.Physics:SetCollides(false)
            ent.Physics:Teleport(x, 0, z)
            ent.Physics:SetCollides(true)
			
			if deployer.components.talker then
				deployer.components.talker:Say("福到！")
			end 
			
			if inst.components.stackable then 
				inst.components.stackable:Get():Remove()
            end 
			
            ent.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")
        end
    end
	
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("tz_boomtong_item")
	--inst:AddTag("wallbuilder")

    inst.AnimState:SetBank("tz_boomtong")
    inst.AnimState:SetBuild("tz_boomtong")
    inst.AnimState:PlayAnimation("lost")

	inst.nameoverride = "tz_boomtong"
	
	MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "tz_boomtong_item"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_boomtong_item.xml"


    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploywall
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)

    MakeHauntableLaunch(inst)

    return inst
end 

local function MakeExplosion(data)
    local function PlayExplodeAnim(proxy)
        local inst = CreateEntity()

        inst:AddTag("FX")
        --[[Non-networked entity]]
        inst.entity:SetCanSleep(false)
        inst.persists = false

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()

        inst.Transform:SetFromProxy(proxy.GUID)

        if data ~= nil and data.scale ~= nil then
            inst.Transform:SetScale(data.scale, data.scale, data.scale)
        end

        inst.AnimState:SetBank("explode")
        inst.AnimState:SetBuild("explode")
        inst.AnimState:PlayAnimation(data ~= nil and data.anim or "small")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetLightOverride(1)

        if data ~= nil and type(data.sound) == "function" then
            data.sound(inst)
        else
            inst.SoundEmitter:PlaySound(data ~= nil and data.sound or "dontstarve/common/blackpowder_explo")
        end

        inst:ListenForEvent("animover", inst.Remove)
    end

    local function explodefn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        --Dedicated server does not need to spawn the local fx
        if not TheNet:IsDedicated() then
            --Delay one frame so that we are positioned properly before starting the effect
            --or in case we are about to be removed
            inst:DoTaskInTime(0, PlayExplodeAnim)
        end

        inst.Transform:SetFourFaced()

        inst:AddTag("FX")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst:DoTaskInTime(1, inst.Remove)

        return inst
    end

    return explodefn
end

local extras =
{
    boomtong =
    {
        anim = "small_firecrackers",
        sound = function(inst)
            inst.SoundEmitter:PlaySoundWithParams("dontstarve/common/together/fire_cracker", { start = math.random() })
        end,
        scale = 2,
    },
}    

STRINGS.NAMES.TZ_BOOMTONG = "招财进宝桶"
STRINGS.RECIPE_DESC.TZ_BOOMTONG = "为你的家带来好运"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_BOOMTONG = "把它放置在最好的朋友家中！"

STRINGS.NAMES.TZ_BOOMTONG_ITEM = "招财进宝桶"
STRINGS.RECIPE_DESC.TZ_BOOMTONG_ITEM = "为你的家带来好运"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_BOOMTONG_ITEM = "把它放置在最好的朋友家中！"


return Prefab("tz_boomtong", fn, assets),
Prefab("tz_boomtong_item", item_fn, assets),
Prefab("explode_boomtong", MakeExplosion(extras.boomtong), assets),
MakePlacer("tz_boomtong_item_placer", "tz_boomtong", "tz_boomtong", "loop")
