local assets =
{
    Asset("ANIM", "anim/tz_statue_fox.zip"),
	Asset("ANIM", "anim/tz_statue_spirit.zip"),
	Asset("ANIM", "anim/tz_statue_stoneheart.zip"),
	
	Asset("IMAGE","images/inventoryimages/tz_statue_fox.tex"),
	Asset("ATLAS","images/inventoryimages/tz_statue_fox.xml"),
	
	Asset("IMAGE","images/inventoryimages/tz_statue_spirit.tex"),
	Asset("ATLAS","images/inventoryimages/tz_statue_spirit.xml"),
	
	Asset("IMAGE","images/inventoryimages/tz_statue_stoneheart.tex"),
	Asset("ATLAS","images/inventoryimages/tz_statue_stoneheart.xml"),
	
	
    Asset("MINIMAP_IMAGE", "statue"),
}

local prefabs =
{
    "marble",
    "rock_break_fx",
    "chesspiece_formal_sketch",
}

local function HeartStoneFn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_statue_stoneheart")
    inst.AnimState:SetBuild("tz_statue_stoneheart")
    inst.AnimState:PlayAnimation("idle")
	
	inst.Transform:SetScale(1.5,1.5,1.5)
	
	MakeInventoryFloatable(inst, "small", 0.2,0.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "tz_statue_stoneheart"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_statue_stoneheart.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("tradable")
	
    return inst
end 

local function CreateStatue(prefabname,bank,build,anim,extrafn)
	local function OnWork(inst, worker, workleft)
		if workleft <= 0 then
			local pos = inst:GetPosition()
			SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
			TheWorld:PushEvent("ms_unlockchesspiece", "formal")
			--inst.components.lootdropper:DropLoot(pos)
			for i=1,9 do 
				inst.components.lootdropper:SpawnLootPrefab("tz_statue_stoneheart",pos)
			end
			inst:Remove()
		elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
			--inst.AnimState:PlayAnimation("hit_low")
			--inst.AnimState:PushAnimation("idle_low")
		elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
			--inst.AnimState:PlayAnimation("hit_med")
			--inst.AnimState:PushAnimation("idle_med")
		else
			--inst.AnimState:PlayAnimation("hit_full")
			--inst.AnimState:PushAnimation("idle_full")
		end
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()

		inst:AddTag("statue")

		MakeObstaclePhysics(inst, .66)

		--inst.MiniMapEntity:SetIcon("statue.png")
		
		
		inst.Transform:SetScale(2,2,2)

		inst.AnimState:SetBank(bank)
		inst.AnimState:SetBuild(build)
		inst.AnimState:PlayAnimation(anim)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("lootdropper")

		inst:AddComponent("inspectable")
		inst:AddComponent("workable")
		--TODO: Custom variables for mining speed/cost
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
		inst.components.workable:SetOnWorkCallback(OnWork)

		MakeHauntableWork(inst)
		
		if extrafn then 
			extrafn(inst)
		end

		return inst
	end

	return Prefab(prefabname, fn, assets, prefabs)
end 

STRINGS.NAMES.TZ_STATUE_FOX = "灵狐雕像"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_STATUE_FOX = "是一只名叫“太真”的小狐狸"
STRINGS.RECIPE_DESC.TZ_STATUE_FOX = "仿照灵狐族人雕砌的石雕"

STRINGS.NAMES.TZ_STATUE_SPIRIT = "精灵雕像"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_STATUE_SPIRIT = "你忘了吗？她叫“维纳斯”"
STRINGS.RECIPE_DESC.TZ_STATUE_SPIRIT = "根据妖精族人外形雕制的石像"

STRINGS.NAMES.TZ_STATUE_STONEHEART = "石心"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_STATUE_STONEHEART = "你的心也是石头做的吗？"
STRINGS.RECIPE_DESC.TZ_STATUE_STONEHEART = "用鹤嘴锄雕刻的心形石头"

return CreateStatue("tz_statue_fox","tz_statue_fox","tz_statue_fox","idle"),
		MakePlacer("tz_statue_fox_placer", "tz_statue_fox", "tz_statue_fox", "idle",nil,nil,nil,2),
		CreateStatue("tz_statue_spirit","tz_statue_spirit","tz_statue_spirit","idle"),
		MakePlacer("tz_statue_spirit_placer", "tz_statue_spirit", "tz_statue_spirit", "idle",nil,nil,nil,2),
		Prefab("tz_statue_stoneheart", HeartStoneFn, assets, prefabs)