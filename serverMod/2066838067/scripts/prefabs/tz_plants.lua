
local function make_plantable(data)
    local name = data.name
    local assets =
    {
        Asset("ANIM", "anim/tz_seeds.zip"),
		Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
    }
    if data.build ~= nil then
        table.insert(assets, Asset("ANIM", "anim/"..data.build..".zip"))
    end
    local function ondeploy(inst, pt, deployer)
        local tree = SpawnPrefab(data.plant)
        if tree ~= nil then
            tree.Transform:SetPosition(pt:Get())
			if inst.components.stackable then
            	inst.components.stackable:Get():Remove()
			else
				inst:Remove()
			end
            --if tree.components.pickable ~= nil then
            --    tree.components.pickable:OnTransplant()
            --end
			tree.AnimState:PlayAnimation("small_in")
			tree.AnimState:PushAnimation("small_loop")
            if deployer ~= nil and deployer.SoundEmitter ~= nil then
                deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
            end
        end
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("deployedplant")

        inst.AnimState:SetBank("tz_seeds")
        inst.AnimState:SetBuild("tz_seeds")
        inst.AnimState:PlayAnimation(name)

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])
        else
            MakeInventoryFloatable(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")
        
        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        MakeHauntable(inst)

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        if data.mediumspacing then
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
        end
        return inst
    end
    return Prefab(name, fn, assets)
end

local function dig_up(inst, worker)
    if  inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SpawnLootPrefab("twigs")
    end
    inst:Remove()
end

local time = 480
local function addshui(self,doer)
	self:StopTimer("currenttime")
	self:StartTimer("currenttime",self.currenttime)
end
local function addgooditem(self,doer)
	self:StopTimer("goodtime")
	self:StartTimer("goodtime",self.goodtime)
	self:DoEffectDelta("good",1,"goodtime")
end
local function addbaditem(self,doer)
	self:StopTimer("badtime")
	self:StartTimer("badtime",self.badtime)
	self:DoEffectDelta("bad",1,"badtime")
end
local function bdzxfn(inst)
    inst:AddComponent("tz_plant_grower")
    inst.components.tz_plant_grower:SetMax(100)
    inst.components.tz_plant_grower:AddFertilizer("waterwater",1,time,1,addshui)
	inst.components.tz_plant_grower:AddFertilizer("poop",5,time,2,addbaditem)
	inst.components.tz_plant_grower:AddFertilizer("spoiled_food",3,time,1)
	inst.components.tz_plant_grower:AddFertilizer("guano",10,time,1,addgooditem)
	inst.components.tz_plant_grower:AddFertilizer("fertilizer",5,time,1)
end
local function hhzxfn(inst)
    inst:AddComponent("tz_plant_grower")
    inst.components.tz_plant_grower:SetMax(75)
    inst.components.tz_plant_grower:AddFertilizer("waterwater",1,time,1,addshui)
	inst.components.tz_plant_grower:AddFertilizer("poop",5,time,2,addbaditem)
	inst.components.tz_plant_grower:AddFertilizer("spoiled_food",3,time,1)
	inst.components.tz_plant_grower:AddFertilizer("guano",10,time,1,addgooditem)
	inst.components.tz_plant_grower:AddFertilizer("fertilizer",5,time,1)
end

local function dogrow(inst)
    local tree = SpawnPrefab(inst.tree)
    if tree ~= nil then
        tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
        if inst.components.tz_plant_grower.bad >= 3 then
            tree.isbad = true
        elseif inst.components.tz_plant_grower.good >= 10 then
            tree.isgood = true
        end
        inst:Remove()
        tree.isplanted = true
        tree.AnimState:PlayAnimation("big_in")
        tree.AnimState:PushAnimation("big_close")
    end
end

local function make_plan1(data)
    local name = data.name
    local assets =
    {
        Asset("ANIM", "anim/"..data.build..".zip"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.AnimState:SetBank(data.build)
        inst.AnimState:SetBuild(data.build)
        inst.AnimState:PlayAnimation("small_loop",true)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
        inst.tree = data.build
        inst:AddComponent("inspectable")
        
        inst:AddComponent("lootdropper")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(dig_up)
        inst.components.workable:SetWorkLeft(1)

        if data.fn then
            data.fn(inst)
        end
        inst.DoGrow = dogrow
		MakeHauntable(inst)
        return inst
    end
    return Prefab(name, fn, assets)
end

local function setstate(inst)
    if not inst.isplanted then
        if inst.isspiritshown then
            if inst.isbad then
                inst.AnimState:PlayAnimation("big_bad",true)
            elseif inst.isgood then
                inst.AnimState:PlayAnimation("big_good",true)
         else
                inst.AnimState:PlayAnimation("big_normal",true)
            end
        else
            inst.AnimState:PlayAnimation("big_close",true)
        end
    else
        inst.isplanted = false
    end
    if not inst.isgood then
        inst.AnimState:ClearBloomEffectHandle()
    end
end

local function OnLoad(inst, data)
    if data ~= nil then
        if data.isbad  then
            inst.isbad  = data.isbad 
        end
        if data.isgood  then
            inst.isgood  = data.isgood
        end
        if data.isspiritshown  then
            inst.isspiritshown  = data.isspiritshown
        end
        --setstate(inst)
    end
end

local function OnSave(inst, data)
    data.isspiritshown = inst.isspiritshown
    data.isgood = inst.isgood
    data.isbad = inst.isbad
end

local function onuse(inst,doer)
    inst.isspiritshown = not inst.isspiritshown
    setstate(inst)
    return true
end

local function make_plan2(name,sanity,tem)
    local assets =
    {
        Asset("ANIM", "anim/"..name..".zip"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("big_close",true)

        inst.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.isspiritshown = false
        inst.isgood = false
        inst.isbad = false

        inst:AddComponent("inspectable")
        
        inst:AddComponent("lootdropper")

        if sanity then
            inst:AddComponent("sanityaura")
            inst.components.sanityaura.aura = sanity
        end

        if tem then
            inst:AddComponent("heater")
            if tem < 0 then
                inst.components.heater:SetThermics(false, true)
            end
            inst.components.heater.heat = tem
        end

        inst:AddComponent("tz_plant_use")
        inst.components.tz_plant_use:SetUse(onuse)

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(dig_up)
        inst.components.workable:SetWorkLeft(1)

        MakeHauntable(inst)

        inst.SetState = setstate
        inst.OnSave = OnSave
        inst.OnLoad = OnLoad
        inst:DoTaskInTime(0,setstate)
    
        return inst
    end
    return Prefab(name, fn, assets)
end

return make_plantable({name = "tz_seed_bdzx", plant ="tz_plant_bdzx"}),
	make_plantable({name = "tz_seed_hhzx", plant ="tz_plant_hhzx"}),

	make_plan1({name = "tz_plant_bdzx", build = "tz_follwers_akxy",fn = bdzxfn }),
	make_plan1({name = "tz_plant_hhzx", build = "tz_follwers_abl",fn = hhzxfn }),

    make_plan2("tz_follwers_akxy",1.5),
    make_plan2("tz_follwers_abl",1, -10),

    MakePlacer("tz_seed_bdzx_placer", "tz_seeds", "tz_seeds", "tz_seed_bdzx"),
    MakePlacer("tz_seed_hhzx_placer", "tz_seeds", "tz_seeds", "tz_seed_hhzx")

