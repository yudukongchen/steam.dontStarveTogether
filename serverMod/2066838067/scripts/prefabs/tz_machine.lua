require "prefabutil"
require "tz_treasurehunt"

local prefabs =
{
	"collapse_big",
}
local goodspawns = 
{

	butterfly = 20,
	rabbit = 10,
	perd = 10,
	mole = 15,
	crow = 5,
	robin = 5,
	robin_winter = 5,
	tz_tfsword = 3,
	canary = 5,
	mandrake = 1,
	mandrake_planted = 1,
	smallbird =10,
}

local okspawns =
{
	bunnyman = 15, 
	pigman = 20,
	monkey = 15,
	beefalo = 15,
	babybeefalo = 10,
	koalefant = 15,
	lightninggoat = 15,
	bee = 10,
	bearger = 5,
	krampus = 5,
	leif = 5,
	leif_sparse = 5,
	checheche = 5,

	book_birds = 4,
	book_sleep = 4,
	book_brimstone = 4,
	book_horticulture = 4,
	item_TeJiChuShi = 1,--特级厨师】学习机
}

--"book_horticulture"
--"book_silviculture

local badspawns =
{

	spider = 20,
	spider_warrior = 10,
	mosquito = 10,
	hound = 5,
	firehound = 5,
	icehound = 5,
	merm = 5,
	spiderqueen = 5,
	worm = 5,
	spider_dropper = 5,
	spider_hider = 5,
	spider_spitter = 5,
	killerbee = 5,
	warg =4,
	slurtle = 3,
	tz_spiritualism = 2,--新增拨浪鼓
	deerclops = 5
}

local prizevalues = 
{
	bad = 1,
	ok = 1,
	good = 1,
}
local actions =
{
	--ok
	bunnyman = { treasure = "bunnyman", },
	pigman = { treasure = "pigman", },
	monkey = { treasure = "monkey", },
	beefalo = { treasure = "beefalo", },
	koalefant = { treasure = "koalefant", },
	lightninggoat = { treasure = "lightninggoat", },
	bee = { treasure = "bee", },
	bearger = { treasure = "bearger", },
	krampus = { treasure = "krampus", },
	babybeefalo = { treasure = "babybeefalo", },
	leif = { treasure = "leif", },
	leif_sparse = { treasure = "leif_sparse", },
	checheche = { treasure = "checheche", },


	book_birds = { treasure = "book_birds", },
	book_sleep = { treasure = "book_sleep", },
	book_brimstone= { treasure = "book_brimstone", },
	book_horticulture = { treasure = "book_horticulture", },

	--bad
	spider = { treasure = "spider", },
	spider_warrior = { treasure = "spider_warrior", },
	mosquito = { treasure = "mosquito", },
	hounds = { treasure = "hounds", },
	firehounds = { treasure = "firehounds", },
	icehounds = { treasure = "icehounds", },
	merm = { treasure = "merm", },
	spiderqueen = { treasure = "spiderqueen", },
	worm = { treasure = "worm", },
	spider_dropper = { treasure = "spider_dropper", },
	spider_hider = { treasure = "spider_hider", },
	spider_spitter = { treasure = "spider_spitter", },
	killerbee	= { treasure = "killerbee", },
	warg = { treasure = "warg", },
	slurtle  = { treasure = "slurtle", },
	tz_spiritualism  = { treasure = "tz_spiritualism", },
	deerclops  = { treasure = "deerclops", },
	-- good

	butterfly = { treasure = "butterfly", },
	rabbit = { treasure = "rabbit", },
	perd = { treasure = "perd", },
	mole = { treasure = "mole", },
	crow = { treasure = "crow", },
	robin = { treasure = "robin", },
	robin_winter = { treasure = "robin_winter", },
	canary = { treasure = "canary", },
	mandrake = { treasure = "mandrake", },
	mandrake_planted = { treasure = "mandrake_planted", },
	smallbird = { treasure = "smallbird", },

}

local sounds = 
{
	ok = "tz_machine/tz_machine/mediumresult",
	good = "tz_machine/tz_machine/goodresult",
	bad = "tz_machine/tz_machine/badresult",
}

local function SpawnCritter(inst, critter, lootdropper, pt, delay)
	if not critter or not lootdropper then return end
	delay = delay or GetRandomWithVariance(1,0.8)
	inst:DoTaskInTime(delay, function() 
		SpawnPrefab("collapse_small").Transform:SetPosition(pt:Get())
		local spawn = lootdropper:SpawnLootPrefab(critter, pt)
		if not spawn then
			return 
		end
		if spawn.components.combat then
		end
		if spawn:HasTag("bird") and spawn.sg then
			spawn.sg:GoToState("stunned")
		end
		if spawn:HasTag("mole") and spawn.sg then
			spawn.sg:GoToState("stunned")
		end
	end)
end
local function SpawnReward(inst, reward, lootdropper, pt, delay)
	delay = delay or GetRandomWithVariance(1,0.8)

	local loots = GetTreasureLootList(reward)  --？？
	for k, v in pairs(loots) do
		for i = 1, v, 1 do

			inst:DoTaskInTime(delay, function(inst) 
				local down = TheCamera:GetDownVec()
				local spawnangle = math.atan2(down.z, down.x)
				local angle = math.atan2(down.z, down.x) + (math.random()*90-45)*DEGREES
				local sp = math.random()*3+2
				
				local item = SpawnPrefab(k)

				if item.components.inventoryitem and not item.components.health then
					local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(2*math.cos(spawnangle), 3, 2*math.sin(spawnangle))
					inst.SoundEmitter:PlaySound("tz_machine/tz_machine/reward")
					item.Transform:SetPosition(pt:Get())
					item.Physics:SetVel(sp*math.cos(angle), math.random()*2+9, sp*math.sin(angle))
				else
					local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(2*math.cos(spawnangle), 0, 2*math.sin(spawnangle))
					pt = pt + Vector3(sp*math.cos(angle), 0, sp*math.sin(angle))
					item.Transform:SetPosition(pt:Get())
						if item:HasTag("bird") and item.sg then
						item.sg:GoToState("stunned")
						end
						if item:HasTag("mole") and item.sg then
						item.sg:GoToState("stunned")
						end
						--print("item是"..k)
					SpawnPrefab("collapse_small").Transform:SetPosition(pt:Get())
				end
				
			end)
			delay = delay + 0.25
		end
	end
end

local function PickPrize(inst)
	inst.busy = true
	local prizevalue = weighted_random_choice(prizevalues)
	if prizevalue == "ok" then
		inst.prize = weighted_random_choice(okspawns)
	elseif prizevalue == "good" then
		inst.prize = weighted_random_choice(goodspawns)
	elseif prizevalue == "bad" then
		inst.prize = weighted_random_choice(badspawns)
	else
		-- impossible!
		-- print("impossible slot machine prizevalue!", prizevalue)
	end
	inst.prizevalue = prizevalue
end

local function DoneSpinning(inst)

	local pos = inst:GetPosition()
	local item = inst.prize 
	local doaction = actions[item] 

	local cnt = (doaction and doaction.cnt) or 1
	local func = (doaction and doaction.callback) or nil
	local radius = (doaction and doaction.radius) or 4
	local treasure = (doaction and doaction.treasure) or nil

	if doaction and doaction.var then
		cnt = GetRandomWithVariance(cnt,doaction.var) 
		if cnt < 0 then cnt = 0 end
	end

	if cnt == 0 and func then
		func(inst,item,doaction)
	end

	for i=1,cnt do
		local offset, check_angle, deflected = FindWalkableOffset(pos, math.random()*2*PI, radius , 8, true, false) -- try to avoid walls
		if offset then
			if treasure then
				SpawnReward(inst, treasure)
			elseif func then
				func(inst,item,doaction)
			elseif item == "trinket" then
				SpawnCritter(inst, "trinket_"..tostring(math.random(NUM_TRINKETS)), inst.components.lootdropper, pos+offset)
			elseif item == "nothing" then
				-- do nothing
				-- print("Slot machine says you lose.")
			else
				-- print("Slot machine item "..tostring(item))
				SpawnCritter(inst, item, inst.components.lootdropper, pos+offset)
			end
		end
	end
	inst.coins = inst.coins + 1
	inst.busy = false
	inst.prize = nil
	inst.prizevalue = nil	
end

local function StartSpinning(inst)

	inst.sg:GoToState("spinning")
end

local function ShouldAcceptItem(inst, item)
	
	if not inst.busy and item.prefab == "tz_coin" then
		return true
	else
		return false
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	PickPrize(inst)
	StartSpinning(inst)
end

local function OnRefuseItem(inst, item)
	 --print("Slot machine refuses "..tostring(item.prefab))
end

local function OnLoad(inst,data)
	if not data then
		return
	end
	
	inst.coins = data.coins or 0
	inst.prize = data.prize
	inst.prizevalue = data.prizevalue

	if inst.prize ~= nil then
		StartSpinning(inst)
	end
end

local function OnSave(inst,data)
	data.coins = inst.coins
	data.prize = inst.prize
	data.prizevalue = inst.prizevalue
end
local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
end
local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", false)
end
local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end


local function CreateSlotMachine(name)
	
	local assets = 
	{
		Asset("ANIM", "anim/tz_machine.zip"),
		Asset("ATLAS", "images/inventoryimages/tz_machine.xml"),
		Asset("IMAGE", "images/inventoryimages/tz_machine.tex"),		
	}


	local function InitFn(Sim)
		local inst = CreateEntity()

		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetPriority( 5 )
		minimap:SetIcon( "tz_machine.tex" )
				
		MakeObstaclePhysics(inst, 1, 1.2)
		
		inst:AddTag("structure")
		anim:SetBank("tz_machine")
		anim:SetBuild("tz_machine")
		anim:PlayAnimation("idle")
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		inst.coins = 0
		inst.DoneSpinning = DoneSpinning
		inst.busy = false
		inst.sounds = sounds		
		inst:AddComponent("inspectable")

		inst:AddComponent("lootdropper")
		
		inst:AddComponent("trader")
		inst.components.trader:SetAcceptTest(ShouldAcceptItem)
		inst.components.trader.onaccept = OnGetItemFromPlayer
		inst.components.trader.onrefuse = OnRefuseItem
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(3)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)
		local old = inst.components.workable.WorkedBy
		inst.components.workable.WorkedBy = function(self,worker,...)
			print(worker and worker.prefab or "没有")
			if not worker or not worker:HasTag("player") then
				return
			end
			return old(self,worker,...)
		end
        inst:ListenForEvent("onbuilt", onbuilt)
		inst:SetStateGraph("SGtz_machine")
		inst.OnSave = OnSave
		inst.OnLoad = OnLoad
		return inst
	end

	return Prefab( "tz_machine", InitFn, assets, prefabs),
	MakePlacer("tz_machine_placer", "tz_machine", "tz_machine", "idle")

end

return CreateSlotMachine()

