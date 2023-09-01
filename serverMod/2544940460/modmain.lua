GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
local Prefabs = GLOBAL.Prefabs
modimport("modinfo_TUNING")


PrefabFiles = {
	"ice_flowerhat",
}
STRINGS.NAMES.ICE_FLOWERHAT="冰之花环"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICE_FLOWERHAT= "我超勇的！！！~"
STRINGS.RECIPE_DESC.ICE_FLOWERHAT= "春华凝霜"

local ifh_recipe_petals_num = 15
local ifh_recipe_bluegem_num = 2
local ifh_recipe_redgem_num = 1
AddRecipe("ice_flowerhat", {
	Ingredient("petals", ifh_recipe_petals_num), Ingredient("bluegem", ifh_recipe_bluegem_num), Ingredient("redgem", ifh_recipe_redgem_num)
}, 
RECIPETABS.DRESS, TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/ice_flowerhat.xml", "ice_flowerhat.tex" )


----幸运采收
--多汁浆果
local function pick_for_berrybush_juicy_once_before(self, picker)
	local pt = self.inst:GetPosition()
	pt.y = pt.y + (self.dropheight or 0)
	if self.use_lootdropper_for_product then
		self.inst.components.lootdropper:DropLoot(pt)
	else
		local num = self.numtoharvest or 1
		for i = 1, num do
			self.inst.components.lootdropper:SpawnLootPrefab(self.product, pt)
		end
	end
end
local function double_pick_for_berrybush_juicy(self)
	local oooooldPick = self.Pick
	function self:Pick(picker)
		if not ( picker and picker.components.inventory ~= nil
		and (self.product or self.use_lootdropper_for_product ~= nil)
		and self.droppicked and self.inst.components.lootdropper ) then
			return oooooldPick(self, picker)
		end

		local on_head = ( picker and picker.components.inventory and picker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ) or nil
		if on_head and on_head.prefab == "ice_flowerhat" and on_head.components.ifhexperience then
			local inst = self.inst
			on_head.components.ifhexperience:Pick_exp_up( picker, { object = inst } )

			local pick_probability = on_head.components.ifhexperience.pick_probability
			math.randomseed(os.time())
			if math.random() <= pick_probability then
				for count = 2, on_head.multiple_pick_enable and on_head.multiple_pick or 2 do
					pick_for_berrybush_juicy_once_before(self, picker)
				end
			end
		end
		return oooooldPick(self, picker)
	end
end
--收获组件
local function double_harvest_for_harvestable(self)
	local oooooldHarvest = self.Harvest
	function self:Harvest(picker)
		local on_head = ( picker and picker.components.inventory and picker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ) or nil
		if on_head and on_head.prefab == "ice_flowerhat" and on_head.components.ifhexperience then
			local inst = self.inst
			on_head.components.ifhexperience:Pick_exp_up( picker, { object = inst } )

			local pick_probability = on_head.components.ifhexperience.pick_probability
			math.randomseed(os.time())
			if math.random() <= pick_probability then
				if self.produce then
					self.produce = self.produce * ( on_head.multiple_pick_enable and on_head.multiple_pick or 2 )
				end
			end
		end
		return oooooldHarvest(self, picker)
	end
end
--剃刮组件
local function shave_for_shaveable_once_before(self, shaver)
	if self.prize_prefab and self.prize_count then
        local position = self.inst:GetPosition()
        for k = 1, self.prize_count do
            local prize = SpawnPrefab(self.prize_prefab)
            if prize.components.inventoryitem then
                prize.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
            end
            if shaver and shaver.components.inventory then
                shaver.components.inventory:GiveItem(prize, nil, position)
            else
                LaunchAt(prize, self.inst, nil, 1, 1)
            end
        end
    end
end
local function double_shave_for_shaveable(self)
	local oooooldShave = self.Shave
	function self:Shave(shaver, shaving_implement)
		local on_head = ( shaver and shaver.components.inventory and shaver.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ) or nil
		if on_head and on_head.prefab == "ice_flowerhat" and on_head.components.ifhexperience then
			local inst = self.inst
			on_head.components.ifhexperience:Pick_exp_up( shaver, { object = inst } )

			local pick_probability = on_head.components.ifhexperience.pick_probability
			math.randomseed(os.time())
			if math.random() <= pick_probability then
				for count = 2, on_head.multiple_pick_enable and on_head.multiple_pick or 2 do
					shave_for_shaveable_once_before(self, shaver)
				end
			end
		end
		return oooooldShave(self, shaver, shaving_implement)
	end
end
--胡子组件
local function shave_for_beard_once_before(self)
	if self.prize and self.bits ~= 0 then
        for k = 1 , self.bits do
            local bit = SpawnPrefab(self.prize)
            local x, y, z = self.inst.Transform:GetWorldPosition()
            bit.Transform:SetPosition(x, y + 2, z)
            local speed = 1 + math.random()
            local angle = math.random() * 2 * PI
            bit.Physics:SetVel(speed * math.cos(angle), 2 + math.random() * 3, speed * math.sin(angle))
        end
    end
end
local function double_shave_for_beard(self)
	local oooooldShave = self.Shave
	function self:Shave(who, withwhat)
		if self.canshavetest then
	        local pass, reason = self.canshavetest(self.inst, who)
	        if not pass then
				return oooooldShave(self, who, withwhat)
			end
		end

		local shaver = nil
		if withwhat.components.inventoryitem then
			shaver = withwhat.components.inventoryitem.owner
		end
		local on_head = ( shaver and shaver.components.inventory and shaver.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ) or nil
		if on_head and on_head.prefab == "ice_flowerhat" and on_head.components.ifhexperience then
			local inst = self.inst
			on_head.components.ifhexperience:Pick_exp_up( shaver, { object = inst } )

			local pick_probability = on_head.components.ifhexperience.pick_probability
			math.randomseed(os.time())
			if math.random() <= pick_probability then
				for count = 2, on_head.multiple_pick_enable and on_head.multiple_pick or 2 do
					shave_for_beard_once_before(self)
				end
			end
		end
		return oooooldShave(self, who, withwhat)
	end
end
--刷洗组件
local function brush_for_brushable_once_before(self, doer)
	local numprizes = 0
    if self.brushable and self.prize or self.max > 0 then
        numprizes = self:CalculateNumPrizes()

        for i=1,numprizes do
            local prize = SpawnPrefab(self.prize)
            if doer.components.inventory then
                doer.components.inventory:GiveItem(prize, nil, self.inst:GetPosition())
            else
                prize.Transform:SetPosition(doer.Transform:GetWorldPosition())
            end
        end
    end
end
local function double_brush_for_brushable(self)
	local oooooldBrush = self.Brush
	function self:Brush(doer, brush)
		local on_head = ( doer and doer.components.inventory and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ) or nil
		if on_head and on_head.prefab == "ice_flowerhat" and on_head.components.ifhexperience then
			local inst = self.inst
			on_head.components.ifhexperience:Pick_exp_up( doer, { object = inst } )

			local pick_probability = on_head.components.ifhexperience.pick_probability
			math.randomseed(os.time())
			if math.random() <= pick_probability then
				for count = 2, on_head.multiple_pick_enable and on_head.multiple_pick or 2 do
					brush_for_brushable_once_before(self, doer)
				end
			end
		end
		return oooooldBrush(self, doer, brush)
	end
end
--风干组件
local function harvest_for_dryer_once_before(self, harvester)
	if self:IsDone() then
		local loot = SpawnPrefab(self.product)
	    if loot then
	        if loot.components.perishable then
	            loot.components.perishable:SetPercent(self:GetTimeToSpoil() / TUNING.PERISH_PRESERVED)
	            loot.components.perishable:StartPerishing()
	        end
	        if loot.components.inventoryitem and not self.protectedfromrain then
	            loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
	        end
	        if harvester.components.inventory then
	        	harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
	    	end
	    end
	end
end
local function double_harvest_for_dryer(self)
	local oooooldHarvest = self.Harvest
	function self:Harvest(harvester)
		local on_head = ( harvester and harvester.components.inventory and harvester.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ) or nil
		if on_head and on_head.prefab == "ice_flowerhat" and on_head.components.ifhexperience then
			local inst = self.inst
			on_head.components.ifhexperience:Pick_exp_up( harvester, { object = inst } )

			local pick_probability = on_head.components.ifhexperience.pick_probability
			math.randomseed(os.time())
			if math.random() <= pick_probability then
				for count = 2, on_head.multiple_pick_enable and on_head.multiple_pick or 2 do
					harvest_for_dryer_once_before(self, harvester)
				end
			end
		end
		return oooooldHarvest(self, harvester)
	end
end
--烹饪组件
local cooking = require("cooking")
local function harvest_for_stewer_once_before(self, harvester)
	if self.done and self.product then
	    local loot = SpawnPrefab(self.product)
	    if loot then
			local recipe = cooking.GetRecipe(self.inst.prefab, self.product)
			local stacksize = recipe and recipe.stacksize or 1
			if stacksize > 1 then
				loot.components.stackable:SetStackSize(stacksize)
			end

	        if self.spoiltime and loot.components.perishable then
	            local spoilpercent = self:GetTimeToSpoil() / self.spoiltime
	            loot.components.perishable:SetPercent(self.product_spoilage * spoilpercent)
	            loot.components.perishable:StartPerishing()
	        end
	        if harvester and harvester.components.inventory then
	            harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
	        else
	            LaunchAt(loot, self.inst, nil, 1, 1)
	        end
	    end
	end
end
local function double_harvest_for_stewer(self)
	local oooooldHarvest = self.Harvest
	function self:Harvest(harvester)
		local on_head = ( harvester and harvester.components.inventory and harvester.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ) or nil
		if on_head and on_head.prefab == "ice_flowerhat" and on_head.components.ifhexperience then
			local inst = self.inst
			on_head.components.ifhexperience:Pick_exp_up( harvester, { object = inst } )

			local pick_probability = on_head.components.ifhexperience.pick_probability
			math.randomseed(os.time())
			if math.random() <= pick_probability then
				for count = 2, on_head.multiple_pick_enable and on_head.multiple_pick or 2 do
					harvest_for_stewer_once_before(self, harvester)
				end
			end
		end
		return oooooldHarvest(self, harvester)
	end
end
--工作组件
local workstageanims =
{
	"empty",
	"low",
	"med",
	"full",
}
local loottables =
{
	"saltstack_low",
	"saltstack_med",
	"saltstack_full",
}
local function whether_pick_exp_up(self, worker, numworks)
	local ooooold_workleft = self.workleft
    numworks = numworks or 1
	if self.workleft <= 1 then -- if there is less that one full work remaining, then just finish it. This is to handle the case where objects are set to only one work and not planned to handled something like 0.5 numworks
		self.workleft = 0
	else
	    self.workleft = self.workleft - numworks
	end

	local inst = self.inst
	local on_head = worker and worker.components.inventory and worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)

	if self.action == ACTIONS.MINE and self.onwork and inst.workstage then--盐堆
		local workleft = self.workleft
		inst.workstage = (workleft > 6 and 4)
			or (workleft > 3 and 3)
			or (workleft > 0 and 2)
			or 1

		if inst.workstage ~= inst.workstageprevious then
			local anim = workstageanims[inst.workstage]

			if inst.workstage < inst.workstageprevious then
				on_head.components.ifhexperience:Pick_exp_up( worker, { object = inst } )
			end
		end
	elseif self.workleft <= 0 then
		on_head.components.ifhexperience:Pick_exp_up( worker, { object = inst } )
    end

    self.workleft = ooooold_workleft
end
local function DropLoots(inst, lower, upper)
	lower = lower or 1
	upper = upper or #loottables

	for i=lower,upper do
		inst.components.lootdropper:SetChanceLootTable(loottables[i])
		inst.components.lootdropper:DropLoot()
	end
end
local function saltstack_onmined(inst, worker, workleft)
	inst.workstage = (workleft > 6 and 4)
		or (workleft > 3 and 3)
		or (workleft > 0 and 2)
		or 1

	if inst.workstage ~= inst.workstageprevious then
		local anim = workstageanims[inst.workstage]

		if inst.workstage < inst.workstageprevious then
			-- Being mined
			DropLoots(inst, inst.workstage, inst.workstageprevious - 1)
		end
	end
end
local function CheckSpawnedLoot(loot)
    if loot.components.inventoryitem then
        loot.components.inventoryitem:TryToSink()
    else
        local lootx, looty, lootz = loot.Transform:GetWorldPosition()
        if ShouldEntitySink(loot, true) or TheWorld.Map:IsPointNearHole(Vector3(lootx, 0, lootz)) then
            SinkEntity(loot)
        end
    end
end
local function SpawnLootPrefab(inst, lootprefab)
    if lootprefab == nil then
        return
    end

    local loot = SpawnPrefab(lootprefab)
    if loot == nil then
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()

    if loot.Physics ~= nil then
        local angle = math.random() * 2 * PI
        loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))

        if inst.Physics ~= nil then
            local len = loot:GetPhysicsRadius(0) + inst:GetPhysicsRadius(0)
            x = x + math.cos(angle) * len
            z = z + math.sin(angle) * len
        end

        loot:DoTaskInTime(1, CheckSpawnedLoot)
    end

    loot.Transform:SetPosition(x, y, z)

	loot:PushEvent("on_loot_dropped", {dropper = inst})

    return loot
end
local function onhammered(inst, worker)
	local recipe = AllRecipes[inst.prefab] or nil
    if recipe then 	
	    for i, v in ipairs(recipe.ingredients) do
	        local amt = math.floor(v.amount * 0.5)
	        for n = 1, amt do
	            SpawnLootPrefab(inst, v.type)
	        end
	    end
	elseif inst.components.lootdropper then--不可制造
		inst.components.lootdropper:DropLoot()
	end
end
local function loot_onworked_once_before(self, worker, numworks)
    local ooooold_workleft = self.workleft
    numworks = numworks or 1
	if self.workleft <= 1 then -- if there is less that one full work remaining, then just finish it. This is to handle the case where objects are set to only one work and not planned to handled something like 0.5 numworks
		self.workleft = 0
	else
	    self.workleft = self.workleft - numworks
	end

	local inst = self.inst
	if self.action == ACTIONS.MINE and self.onwork and inst.workstage then--盐堆
		saltstack_onmined(inst, worker, self.workleft)
	elseif self.workleft <= 0 then
    	if self.action == ACTIONS.HAMMER then
    		if self.onfinish then
    			onhammered(inst, worker)
			end
        end

        if self.action == ACTIONS.MINE then
        	if self.onwork or self.onfinish then--贝壳堆
        		if inst.components.lootdropper then
		        	inst.components.lootdropper:DropLoot(inst:GetPosition())
		    	end
	    	end
		end

		if self.action == ACTIONS.CHOP then
        	if self.onfinish then
        		if inst.components.lootdropper then
					inst.components.lootdropper:DropLoot(inst:GetPosition())
				end
	    	end
		end
    end

    self.workleft = ooooold_workleft
end
local function double_loot_onworked(self)
	local oooooldWorkedBy = self.WorkedBy
	function self:WorkedBy(worker, numworks)
		local on_head = ( worker and worker.components.inventory and worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ) or nil
		if on_head and on_head.prefab == "ice_flowerhat" and on_head.components.ifhexperience then
			whether_pick_exp_up(self, worker, numworks)

			local pick_probability = on_head.components.ifhexperience.pick_probability
			math.randomseed(os.time())
			if math.random() <= pick_probability then
				local multiple_pick_count = on_head.multiple_pick_enable and on_head.multiple_pick or 2

				--多倍暴击不包括回收
   				if AllRecipes[self.inst.prefab] then
   					multiple_pick_count = 2
   				end

				for count = 2, multiple_pick_count do
					loot_onworked_once_before(self, worker, numworks)
				end
			end
		end
		return oooooldWorkedBy(self, worker, numworks)
	end
end
local double_pick_enable = TUNING.IFH_DOUBLE_PICK_ENABLE
if double_pick_enable == true and not TheNet:GetIsClient() then
	AddComponentPostInit("pickable", function(self)
		double_pick_for_berrybush_juicy(self)
	end)
	AddComponentPostInit("harvestable", function(self)
		double_harvest_for_harvestable(self)
	end)
	AddComponentPostInit("shaveable", function(self)
		double_shave_for_shaveable(self)
	end)
	AddComponentPostInit("beard", function(self)
		double_shave_for_beard(self)
	end)
	AddComponentPostInit("brushable", function(self)
		double_brush_for_brushable(self)
	end)
	AddComponentPostInit("dryer", function(self)
		double_harvest_for_dryer(self)
	end)
	AddComponentPostInit("stewer", function(self)
		double_harvest_for_stewer(self)
	end)
	AddComponentPostInit("workable", function(self)
		double_loot_onworked(self)
	end)
end
--鸟笼
--Only use for hit and idle anims
local function PushStateAnim(inst, anim, loop)
    inst.AnimState:PushAnimation(anim..inst.CAGE_STATE, loop)
end
local function GetBird(inst)
    return (inst.components.occupiable and inst.components.occupiable:GetOccupant()) or nil
end
local function DigestFood_once_before(inst, food)
    if food.components.edible.foodtype == FOODTYPE.MEAT then
        --If the food is meat:
            --Spawn an egg.
        if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
            inst.components.lootdropper:SpawnLootPrefab("rottenegg")
        else
            inst.components.lootdropper:SpawnLootPrefab("bird_egg")
        end
    else
        if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
            inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
        else
            local seed_name = string.lower(food.prefab .. "_seeds")
            if Prefabs[seed_name] then
    			inst.components.lootdropper:SpawnLootPrefab(seed_name)
            else
                --Otherwise...
                    --Spawn a poop 1/3 times.
                if math.random() < 0.33 then
                    local loot = inst.components.lootdropper:SpawnLootPrefab("guano")
                    loot.Transform:SetScale(.33, .33, .33)
                end
            end
        end
    end
end
local function DigestFood(inst, food)
    if food.components.edible.foodtype == FOODTYPE.MEAT then
        --If the food is meat:
            --Spawn an egg.
        if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
            inst.components.lootdropper:SpawnLootPrefab("rottenegg")
        else
            inst.components.lootdropper:SpawnLootPrefab("bird_egg")
        end
    else
        if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
            inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
        else
            local seed_name = string.lower(food.prefab .. "_seeds")
            if Prefabs[seed_name] then
    			inst.components.lootdropper:SpawnLootPrefab(seed_name)
            else
                --Otherwise...
                    --Spawn a poop 1/3 times.
                if math.random() < 0.33 then
                    local loot = inst.components.lootdropper:SpawnLootPrefab("guano")
                    loot.Transform:SetScale(.33, .33, .33)
                end
            end
        end
    end

    --Refill bird stomach.
    local bird = GetBird(inst)
    if bird and bird:IsValid() and bird.components.perishable then
        bird.components.perishable:SetPercent(1)
    end
end
local function OnGetItem(inst, giver, item)
    --If you're sleeping, wake up.
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

    if item.components.edible and
        (   item.components.edible.foodtype == FOODTYPE.MEAT
            or item.prefab == "seeds"
            or string.match(item.prefab, "_seeds")
            or Prefabs[string.lower(item.prefab .. "_seeds")] ~= nil
        ) then
        --If the item is edible...
        --Play some animations (peck, peck, peck, hop, idle)
        inst.AnimState:PlayAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("hop")
        PushStateAnim(inst, "idle", true)
        --Digest Food in 60 frames.
        local on_head = ( giver and giver.components.inventory and giver.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ) or nil
		if on_head and on_head.prefab == "ice_flowerhat" and on_head.components.ifhexperience then
			on_head.components.ifhexperience:Pick_exp_up( giver, { object = inst } )

			local pick_probability = on_head.components.ifhexperience.pick_probability
			math.randomseed(os.time())
			if math.random() <= pick_probability then
				for count = 2, on_head.multiple_pick_enable and on_head.multiple_pick or 2 do
					inst:DoTaskInTime(60 * FRAMES, DigestFood_once_before, item)
				end
			end
		end
        inst:DoTaskInTime(60 * FRAMES, DigestFood, item)
    end
end
local double_pick_enable = TUNING.IFH_DOUBLE_PICK_ENABLE
if double_pick_enable == true then
	AddPrefabPostInit("birdcage",function(inst)
		if not TheWorld.ismastersim then
        	return inst
    	end

		inst.components.trader.onaccept = OnGetItem
	end)
end


------治愈
----猪人
--不会发疯
local function DoTransform(inst, self, isfullmoon)
    self._task = nil
    if isfullmoon then
    	local on_head = inst and inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
		if on_head and on_head.prefab == "ice_flowerhat" then
			--do nothing
		else
			self:SetWere(math.max(self.weretime, TUNING.TOTAL_DAY_TIME * (1 - TheWorld.state.time) + math.max(0, GetRandomWithVariance(1, 2))))
		end
    else
        self:SetNormal()
    end
end
local function OnRevert(inst, self)
    if self:IsInWereState() and not inst.sg:HasStateTag("transform") then
        self:SetNormal()
    end
end
local function OnIsFullmoon(self, isfullmoon)
    if self._task then
        self._task:Cancel()
        self._task = nil
    end
    if isfullmoon == self:IsInWereState() then
        if isfullmoon and self._reverttask then
            local remaining = GetTaskRemaining(self._reverttask)
            local time = TUNING.TOTAL_DAY_TIME * (1 - TheWorld.state.time) + math.max(0, GetRandomWithVariance(1, 2))
            if time > remaining then
                self._reverttask:Cancel()
                self._reverttask = self.inst:DoTaskInTime(time, OnRevert, self)
            end
        end
    elseif not self.inst:IsInLimbo() then
        self._task = self.inst:DoTaskInTime(math.max(0, GetRandomWithVariance(1, 2)), DoTransform, self, isfullmoon)
    end
end
local cure_enable = TUNING.IFH_CURE_ENABLE
if cure_enable == true and not TheNet:GetIsClient() then
	AddComponentPostInit("werebeast", function(self)
		self:WatchWorldState("isfullmoon", OnIsFullmoon)
	end)
end
--无限接受肉食
local function ShouldAcceptItem_pigman(inst, item)
    if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        return true
    elseif inst.components.eater:CanEat(item) then
        local foodtype = item.components.edible.foodtype
        if foodtype == FOODTYPE.MEAT or foodtype == FOODTYPE.HORRIBLE then
        	local on_head = inst and inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
			if on_head and on_head.prefab == "ice_flowerhat" then
        		return true
        	end

            return inst.components.follower.leader == nil or inst.components.follower:GetLoyaltyPercent() <= TUNING.PIG_FULL_LOYALTY_PERCENT
        elseif foodtype == FOODTYPE.VEGGIE or foodtype == FOODTYPE.RAW then
            local last_eat_time = inst.components.eater:TimeSinceLastEating()
            return (last_eat_time == nil or
                    last_eat_time >= TUNING.PIG_MIN_POOP_PERIOD)
                and (inst.components.inventory == nil or
                    not inst.components.inventory:Has(item.prefab, 1))
        end
        return true
    end
end
--不会主动攻击怪物
local RETARGET_MUST_TAGS = { "_combat" }
local function NormalRetargetFn_pigman(inst)
    if inst:HasTag("NPC_contestant") then
        return nil
    end

	local exclude_tags = { "playerghost", "INLIMBO" , "NPC_contestant" }
	if inst.components.follower.leader then
		table.insert(exclude_tags, "abigail")
	end
	if inst.components.minigame_spectator then
		table.insert(exclude_tags, "player") -- prevent spectators from auto-targeting webber
	end

	local on_head = inst and inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
	if on_head and on_head.prefab == "ice_flowerhat" then
		table.insert(exclude_tags, "monster")
		table.insert(exclude_tags, "merm")
	end

    local oneof_tags = {"monster"}
    if not inst:HasTag("merm") then
        table.insert(oneof_tags, "merm")
    end

    return not inst:IsInLimbo()
        and FindEntity(
                inst,
                TUNING.PIG_TARGET_DIST,
                function(guy)
                    return guy:IsInLight() and inst.components.combat:CanTarget(guy)
                end,
                RETARGET_MUST_TAGS, -- see entityreplica.lua
                exclude_tags,
                oneof_tags
            )
        or nil
end
--增加最大生命
local function whether_largen_maxhealth(inst)
	inst:DoPeriodicTask(1, function(inst)
		local on_head = inst and inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
		if on_head and on_head.prefab == "ice_flowerhat" then
			local largen_maxhealth_enable = on_head.largen_maxhealth_enable
			local largen_maxhealth_value = on_head.largen_maxhealth_value
			if largen_maxhealth_enable == true then
				inst.normal_maxhealth = TUNING.PIG_HEALTH
				local largen_maxhealth = inst.normal_maxhealth + largen_maxhealth_value
		        inst.components.health.maxhealth = largen_maxhealth
			end
		end
	end, 0)
end
--增加最大忠诚时间
local function whether_largen_maxfollowtime(inst)
	inst:DoPeriodicTask(1, function(inst)
		local on_head = inst and inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
		if on_head and on_head.prefab == "ice_flowerhat" then
			local employ_duration = 72
			inst.components.follower.maxfollowtime = employ_duration * 480
		else
			inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME
		end
	end, 0)
end
--记录忠诚时间
local function save_targettime(inst)
	local targettime = 0
	inst.save_targettime_task = inst:DoPeriodicTask(1 , function(inst)
		targettime = inst.components.follower.targettime or 0
		inst.save_targettime = targettime
	end, 0)
end
--保存忠诚时间
local builds = { "pig_build", "pigspotted_build" }
local function OnSave_pigman(inst, data)
    data.build = inst.build
	data._pigtokeninitialized = inst._pigtokeninitialized

	inst.save_targettime_task:Cancel()
	local targettime = inst.save_targettime
	local current_time = GetTime()
	data.loyalty_time = targettime - current_time
end
local function OnLoad_pigman(inst, data)
    if data then
        inst.build = data.build or builds[1]
        if not inst.components.werebeast:IsInWereState() then
            inst.AnimState:SetBuild(inst.build)
        end
		inst._pigtokeninitialized = data._pigtokeninitialized

		inst:DoTaskInTime(3, function(inst)
			local loyalty_time = data.loyalty_time or 0
			inst.components.follower:AddLoyaltyTime(loyalty_time)
		end)
    end
end
local function test(inst)
end
----兔人
--无限接受胡萝卜
local function is_meat(item)
    return item.components.edible and item.components.edible.foodtype == FOODTYPE.MEAT and not item:HasTag("smallcreature")
end
local function ShouldAcceptItem_bunnyman(inst, item)
    local should_accept = false
    if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
    	return true
    end
    if inst.components.eater:CanEat(item) then
    	local on_head = inst and inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		if on_head and on_head.prefab == "ice_flowerhat" then
    		return true
    	end
    	
    	return (item.prefab ~= "carrot" and item.prefab ~= "carrot_cooked") or
                inst.components.follower.leader == nil or inst.components.follower:GetLoyaltyPercent() <= .9
    end
end
--不会主动攻击怪物
local RETARGET_MUST_TAGS = { "_combat", "_health" }
local RETARGET_ONEOF_TAGS = { "monster", "player" }
local function NormalRetargetFn_bunnyman(inst)
	local exclude_tags = {}
	local on_head = inst and inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
	if on_head and on_head.prefab == "ice_flowerhat" then
		table.insert(exclude_tags, "monster")
		table.insert(exclude_tags, "merm")
	end

    return not inst:IsInLimbo()
        and FindEntity(
                inst,
                TUNING.PIG_TARGET_DIST,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                        and (guy:HasTag("monster")
                            or (guy.components.inventory ~= nil and
                                guy:IsNear(inst, TUNING.BUNNYMAN_SEE_MEAT_DIST) and
                                guy.components.inventory:FindItem(is_meat) ~= nil))
                end,
                RETARGET_MUST_TAGS, -- see entityreplica.lua
                exclude_tags,
                RETARGET_ONEOF_TAGS
            )
        or nil
end
--不会因为玩家精神失常变成降san光环
local function IsCrazyGuy(guy)
    local sanity = guy ~= nil and guy.replica.sanity or nil
    return sanity ~= nil and sanity:IsInsanityMode()
    	and sanity:GetPercentNetworked() <= (guy:HasTag("dappereffects") and TUNING.DAPPER_BEARDLING_SANITY or TUNING.BEARDLING_SANITY)
end
local function ClearBeardlord(inst)
    inst.clearbeardlordtask = nil
    inst.beardlord = nil
end
local function SetBeardLord(inst)
    inst.beardlord = true
    if inst.clearbeardlordtask ~= nil then
        inst.clearbeardlordtask:Cancel()
    end
    inst.clearbeardlordtask = inst:DoTaskInTime(5, ClearBeardlord)
end
local function CalcSanityAura(inst, observer)
	local on_head = inst and inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
	if on_head and on_head.prefab == "ice_flowerhat" then
		return inst.components.follower ~= nil
        and inst.components.follower:GetLeader() == observer
        and TUNING.SANITYAURA_SMALL
        or 0
	end

    if IsCrazyGuy(observer) then
        SetBeardLord(inst)
        return -TUNING.SANITYAURA_MED
    end
    return inst.components.follower ~= nil
        and inst.components.follower:GetLeader() == observer
        and TUNING.SANITYAURA_SMALL
        or 0
end
--保存忠诚时间
local function OnSave_bunnyman(inst, data)
	inst.save_targettime_task:Cancel()
	local targettime = inst.save_targettime
	local current_time = GetTime()
	data.loyalty_time = targettime - current_time
end
local function OnLoad_bunnyman(inst, data)
    if data then
		inst:DoTaskInTime(3, function(inst)
			local loyalty_time = data.loyalty_time or 0
			inst.components.follower:AddLoyaltyTime(loyalty_time)
		end)
    end
end
local cure_enable = TUNING.IFH_CURE_ENABLE
if cure_enable == true then
	AddPrefabPostInit("pigman",function(inst)
		if not TheWorld.ismastersim then
        	return inst
    	end

		inst.components.trader:SetAcceptTest(ShouldAcceptItem_pigman)
		inst.components.combat:SetRetargetFunction(3, NormalRetargetFn_pigman)

		whether_largen_maxhealth(inst)
		whether_largen_maxfollowtime(inst)

		save_targettime(inst)
		inst.OnSave = OnSave_pigman
        inst.OnLoad = OnLoad_pigman

        test(inst)
	end)

	AddPrefabPostInit("bunnyman",function(inst)
		if not TheWorld.ismastersim then
        	return inst
    	end

		inst.components.trader:SetAcceptTest(ShouldAcceptItem_bunnyman)
		inst.components.sanityaura.aurafn = CalcSanityAura
		inst.components.combat:SetRetargetFunction(3, NormalRetargetFn_bunnyman)

		whether_largen_maxfollowtime(inst)

		save_targettime(inst)
		inst.OnSave = OnSave_bunnyman
        inst.OnLoad = OnLoad_bunnyman

        test(inst)
	end)
end


----添加标签
--眼球草
local function checkmaster(tar, inst)
    if inst.minionlord then
        return tar == inst.minionlord
    end

    if tar.minionlord and inst.minionlord then
        return tar.minionlord == inst.minionlord
    else
        return false
    end
end
local RETARGET_MUST_TAGS = { "_combat", "_health" }
local RETARGET_CANT_TAGS = { "INLIMBO", "plantkin", "ifh_eyeplant" }
local RETARGET_ONEOF_TAGS = { "character", "monster", "animal", "prey", "eyeplant", "lureplant" }
local function retargetfn(inst)
    return FindEntity(
        inst,
        TUNING.EYEPLANT_ATTACK_DIST,
        function(guy)
            return not (guy.components.health:IsDead() or checkmaster(guy, inst))
        end,
        RETARGET_MUST_TAGS, -- see entityreplica.lua
        RETARGET_CANT_TAGS,
        RETARGET_ONEOF_TAGS
    )
end
local add_eyeplant = TUNING.IFH_ADD_EYEPLANT
if add_eyeplant == true then
	AddPrefabPostInit("eyeplant",function(inst)
		if not TheWorld.ismastersim then
        	return inst
    	end

		inst.components.combat:SetRetargetFunction(0.2, retargetfn)
	end)
end
--春天蜜蜂
local RETARGET_MUST_TAGS = { "_combat", "_health" }
local RETARGET_CANT_TAGS = { "insect", "INLIMBO", "plantkin", "ifh_springbee" }
local RETARGET_ONEOF_TAGS = { "character", "animal", "monster" }
local function SpringBeeRetarget(inst)
    return TheWorld.state.isspring and
        FindEntity(inst, 4,
            function(guy)
                return inst.components.combat:CanTarget(guy)
            end,
			RETARGET_MUST_TAGS,
			RETARGET_CANT_TAGS,
			RETARGET_ONEOF_TAGS)
        or nil
end
local add_springbee = TUNING.IFH_ADD_SPRINGBEE
if add_springbee == true then
	AddPrefabPostInit("bee",function(inst)
		if not TheWorld.ismastersim then
        	return inst
    	end
		
		inst.components.combat:SetRetargetFunction(2, SpringBeeRetarget)
	end)
end
--海草
local function update_barnacle_layers(inst, pct)
    if pct >= 0.33 then
        inst.base.AnimState:Show("bud1")
    else
        inst.base.AnimState:Hide("bud1")
    end

    if pct >= 0.66 then
        inst.base.AnimState:Show("bud2")
    else
        inst.base.AnimState:Hide("bud2")
    end

    if pct >= 1.00 then
        inst.base.AnimState:Show("bud3")
    else
        inst.base.AnimState:Hide("bud3")
    end
end
local SHARE_TARGET_DISTANCE = TUNING.WATERPLANT.ATTACK_DISTANCE
local SHARE_TARGET_MUSTTAGS = { "_combat", "waterplant" }
local function set_target(inst, target)
    inst.components.combat:SuggestTarget(target)
    inst.components.combat:ShareTarget(target,
        SHARE_TARGET_DISTANCE,
        function(other_entity)
            return not other_entity.components.sleeper:IsAsleep()
        end,
        4,
        SHARE_TARGET_MUSTTAGS
    )
end
local function on_harvested(inst, picker, picked_amount)
    update_barnacle_layers(inst, 0)

    -- Keep shaveable and harvestable in lockstep
    if inst.components.shaveable then
        inst.components.shaveable.prize_count = 0
    end

    if not picker:HasTag("plantkin") and not picker:HasTag("ifh_waterplant") then
        inst.components.sleeper:WakeUp()

        set_target(inst, picker)
    end
end
local function on_shaved(inst, shaver, shave_item)
    update_barnacle_layers(inst, 0)

    -- Keep shaveable and harvestable in lockstep
    if inst.components.harvestable then
        inst.components.harvestable.produce = 0
        inst.components.harvestable:StartGrowing()
    end

    -- If we're awake, target the shaver. However, if we're asleep, we won't wake up to fight.
    if shaver and not inst.components.sleeper:IsAsleep() 
    and not shaver:HasTag("plantkin") and not shaver:HasTag("ifh_waterplant") then
        set_target(inst, shaver)
    end
end
local add_waterplant = TUNING.IFH_ADD_WATERPLANT
if add_waterplant == true then
	AddPrefabPostInit("waterplant",function(inst)
		if not TheWorld.ismastersim then
        	return inst
    	end

		inst.components.harvestable:SetOnHarvestFn(on_harvested)
		inst.components.shaveable.on_shaved = on_shaved
	end)
end
--蜂箱
local function setlevel(inst, level)
    if not inst:HasTag("burnt") then
        if inst.anims == nil then
            inst.anims = { idle = level.idle, hit = level.hit }
        else
            inst.anims.idle = level.idle
            inst.anims.hit = level.hit
        end
        inst.AnimState:PlayAnimation(inst.anims.idle)
    end
end
local levels =
{
    { amount=6, idle="honey3", hit="hit_honey3" },
    { amount=3, idle="honey2", hit="hit_honey2" },
    { amount=1, idle="honey1", hit="hit_honey1" },
    { amount=0, idle="bees_loop", hit="hit_idle" },
}
local function updatelevel(inst)
    if not inst:HasTag("burnt") then
        for k, v in pairs(levels) do
            if inst.components.harvestable.produce >= v.amount then
                setlevel(inst, v)
                break
            end
        end
    end
end
local function onharvest(inst, picker, produce)
    --print(inst, "onharvest")
    if not inst:HasTag("burnt") then
        if inst.components.harvestable then
            inst.components.harvestable:SetGrowTime(nil)
            inst.components.harvestable.pausetime = nil
            inst.components.harvestable:StopGrowing()
        end
		if produce == levels[1].amount then
			AwardPlayerAchievement("honey_harvester", picker)
		end
        updatelevel(inst)
        if inst.components.childspawner and not TheWorld.state.iswinter then
			if picker and picker:HasTag("ifh_beebox")  then
        		--do nothing
        	else
            	inst.components.childspawner:ReleaseAllChildren(picker)
        	end
        end
    end
end
local add_beebox = TUNING.IFH_ADD_BEEBOX
if add_beebox == true then
	AddPrefabPostInit("beebox",function(inst)
		if not TheWorld.ismastersim then
        	return inst
    	end

		inst.components.harvestable.onharvestfn = onharvest
	end)
end

--多倍暴击
if TUNING.IFH_MULTIPLE_PICK_ENABLE == true then
	AddPrefabPostInit("glommerwings",function(inst)
		if not TheWorld.ismastersim then
			return inst
		end

		if not inst.components.tradable then
			inst:AddComponent("tradable")
		end
	end)
end


--开启感知
local ifh_sense_enable = TUNING.IFH_SENSE_ENABLE
if ifh_sense_enable == true then
	modimport("scripts/skill/ifh_sense.lua")
	local this_modname = TUNING.THIS_MODNAME
	local sense_key = TUNING.IFH_SENSE_KEY
	TheInput:AddKeyDownHandler(sense_key, function()--克雷会适配大小写
		SendModRPCToServer(MOD_RPC[this_modname]["ifh_sense"])
	end)
end

--开启冰环
local ifh_icering_enable = TUNING.IFH_ICERING_ENABLE
if ifh_icering_enable == true then
	modimport("scripts/skill/ifh_icering.lua")
	local this_modname = TUNING.THIS_MODNAME
	local icering_key = TUNING.IFH_ICERING_KEY
	TheInput:AddKeyDownHandler(icering_key, function()
		SendModRPCToServer(MOD_RPC[this_modname]["ifh_icering"])
	end)
end