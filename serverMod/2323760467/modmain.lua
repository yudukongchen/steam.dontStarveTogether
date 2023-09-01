Assets = 
{
	Asset("IMAGE", "images/inventoryimages/skeletonAI.tex"),
	Asset("ATLAS", "images/inventoryimages/skeletonAI.xml"),
}

PrefabFiles = 
{
	"skeletonservant",
	"skeletonwarrior",
	"skeletonmage",
}

--require = GLOBAL.require
local TUNING = GLOBAL.TUNING
local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local ACTIONS = GLOBAL.ACTIONS
local Vector3 = GLOBAL.Vector3
local distsq = GLOBAL.distsq
local DEGREES = GLOBAL.DEGREES
local seg_time = 30
local day_segs = 10
local dusk_segs = 4
local night_segs = 2
local day_time = seg_time * day_segs
local dusk_time = seg_time * dusk_segs
local night_time = seg_time * night_segs
local total_day_time = seg_time*16
local TheSim = GLOBAL.TheSim

AddMinimapAtlas("images/inventoryimages/skeletonAI.xml")

TUNING.SKELETON_PASSERBY_SINKHOLE = GetModConfigData("skeleton_passerby_sinkhole") or false
TUNING.SKELETON_REVIVE = GetModConfigData("skeleton_revive") or false
TUNING.SKELETON_TUGH_SERVANT =  GetModConfigData("skeleton_tough_servant") or 0.8
TUNING.SKELETON_BACKPACKING = GetModConfigData("skeleton_backpacking") or false
TUNING.SKELETON_FREEZER = GetModConfigData("skeleton_freezer") or false
TUNING.SKELETON_LEAVEGUNPOWDER =  GetModConfigData("skeleton_leaveGunpowder") or false
TUNING.SKELETON_PICKUPHAMBAT = GetModConfigData("skeleton_pickupHamBat") or false

TUNING.SKELETON_LEAVEJUICYBERRIES =  false
TUNING.SKELETON_TUGH_WARRIOR =  GetModConfigData("skeleton_tough_warrior") or 0.8
TUNING.SKELETON_LANTERN = GetModConfigData("skeleton_lantern") or false
TUNING.SKELETON_TUGH_MAGE =  GetModConfigData("skeleton_tough_mage") or 0.8

local Rskeleton = Recipe("skeletonservant", {Ingredient("nightmarefuel",2),Ingredient("boneshard",8),Ingredient("beardhair",6)}, RECIPETABS.MAGIC, TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/skeletonAI.xml", "skeletonAI.tex")
Rskeleton.sortkey = 2

local function setStarterInventory(inst, custom_inv)
	local st_inv = inst.starting_inventory or {}

	-- check
	local item_found = false
    for _,prefab in pairs(st_inv) do
        if prefab == "skeletonservant" then
        	print("---- Friendly Skeleton setStarterInventory(), Starting items are already setupped!")
        	item_found = true
        	break
        end
    end

    if not item_found then
		for k,v in pairs(custom_inv)  do
			table.insert(st_inv, v)
		end
		inst.starting_inventory = st_inv
	end
end

local function makePostInit(custom_inv)
	return function (inst)
		setStarterInventory(inst, custom_inv)
	end
end

local skeleton_inv1 = {"skeletonservant"}
local skeleton_inv2 = {"skeletonservant","skeletonwarrior"}
local skeleton_inv3 = {"skeletonservant","skeletonwarrior","skeletonmage"}
local skeleton_inv4 = {"skeletonservant","skeletonwarrior","skeletonwarrior"}
local skeleton_inv5 = {"skeletonservant","skeletonwarrior","skeletonwarrior","skeletonmage"}
if     GetModConfigData("skeleton_start") == 1 then AddPlayerPostInit(makePostInit(skeleton_inv1))
elseif GetModConfigData("skeleton_start") == 2 then AddPlayerPostInit(makePostInit(skeleton_inv2))
elseif GetModConfigData("skeleton_start") == 3 then AddPlayerPostInit(makePostInit(skeleton_inv3))
elseif GetModConfigData("skeleton_start") == 4 then AddPlayerPostInit(makePostInit(skeleton_inv4))
elseif GetModConfigData("skeleton_start") == 5 then AddPlayerPostInit(makePostInit(skeleton_inv5))
end

STRINGS.ACTIONS.SITCOMMAND = "Order to Stay"
STRINGS.ACTIONS.SITCOMMAND_CANCEL = "Order to Follow"
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_SITCOMMAND = "Stay there."
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_SITCOMMAND_CANCEL = "Come here."
STRINGS.CHARACTERS.WX78.ANNOUNCE_SITCOMMAND = "STAY"
STRINGS.CHARACTERS.WX78.ANNOUNCE_SITCOMMAND_CANCEL = "FOLLOW"

--credits to Questionable Intent for the code here.
ACTIONS.SITCOMMAND = GLOBAL.Action({}, 2, true, true)
ACTIONS.SITCOMMAND.fn = function(act)
	local targ = act.target
	if targ and targ.components.followersitcommand then
		act.doer.components.locomotor:Stop()
		act.doer.components.talker:Say(GLOBAL.GetString(act.doer.prefab, "ANNOUNCE_SITCOMMAND"))
		if not targ.components.unteleportable then 
			targ:AddComponent("unteleportable") 
		end
		targ.components.followersitcommand:SetStaying(true)
		targ.components.followersitcommand:RememberSitPos("currentstaylocation", GLOBAL.Point(targ.Transform:GetWorldPosition())) 
		return true
	end
end

ACTIONS.SITCOMMAND.str = STRINGS.ACTIONS.SITCOMMAND
ACTIONS.SITCOMMAND.id = "SITCOMMAND"

ACTIONS.SITCOMMAND_CANCEL = GLOBAL.Action({}, 2, true, true)
ACTIONS.SITCOMMAND_CANCEL.fn = function(act)
	local targ = act.target
	if targ and targ.components.followersitcommand then
		act.doer.components.locomotor:Stop()
		act.doer.components.talker:Say(GLOBAL.GetString(act.doer.prefab, "ANNOUNCE_SITCOMMAND_CANCEL"))
		targ:RemoveComponent("unteleportable")
		targ.components.followersitcommand:SetStaying(false)
		return true
	end
end

ACTIONS.SITCOMMAND_CANCEL.str = STRINGS.ACTIONS.SITCOMMAND_CANCEL
ACTIONS.SITCOMMAND_CANCEL.id = "SITCOMMAND_CANCEL"
--

--examine trap first + auto reset
--AddSimPostInit(function(inst)
--	GLOBAL.TheInput:AddControlHandler(GLOBAL.CONTROL_ACTION, function(down)
--    local pt = GLOBAL.GetPlayer():GetPosition()
--    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 50)
--	    for k,ent in pairs(ents) do
--			if ent and ent.components.inventoryitem then
--				if ent:HasTag("summonedbyplayer") then
--					ent.components.inventoryitem.canbepickedup = false
--				end
--			end
--		end
--	end)
--	GLOBAL.TheInput:AddControlHandler(GLOBAL.CONTROL_PRIMARY, function(down)
--	local ents=GLOBAL.TheInput:GetAllEntitiesUnderMouse()
--	    for k,ent in pairs(ents) do
--			if ent and ent.components.inventoryitem then
--				if ent:HasTag("summonedbyplayer") then
--					ent.components.inventoryitem.canbepickedup = true
--				end
--			end
--		end
--	end)
--end)

local function skeletonCombatPostInit(inst)
    if not GLOBAL.TheWorld.ismastersim then return end  	
    local combat = inst.components.combat

    -- override combat:GetAttacked
    local old_GetAttacked = combat.GetAttacked
	function combat:GetAttacked(attacker, damage, weapon, stimuli)
		if attacker and attacker:HasTag("player") then return true end
		if attacker and attacker.components.combat and attacker.components.combat.playerdamagepercent then
			damage = damage and damage * attacker.components.combat.playerdamagepercent or nil
		end
		return old_GetAttacked(self, attacker, damage, weapon, stimuli)
	end

	-- override combat:SetTarget
    local old_SetTarget = combat.SetTarget
    function combat:SetTarget(target)
    	if target and (target:HasTag("player") or target:HasTag("summonedbyplayer") or target:HasTag("abigail") or target:HasTag("shadowminion") or target:HasTag("wall")) then return end
        return old_SetTarget(self, target) -- call original function
    end

end
AddPrefabPostInit("skeletonservant", skeletonCombatPostInit)
AddPrefabPostInit("skeletonwarrior", skeletonCombatPostInit)
AddPrefabPostInit("skeletonmage",    skeletonCombatPostInit)

--[[ Should not modify all prefab's follower, Just modify only Skeleton's follower
function TeleportCheck(self,inst)
	function self:StartLeashing()
		self.inst.portnearleader = function()    
			if not self.leader or (self.leader and self.leader:IsAsleep()) then
				return
			end
			local init_pos = self.inst:GetPosition()
			local leader_pos = self.leader:GetPosition()
			local angle = self.leader:GetAngleToPoint(init_pos)
			local offset = GLOBAL.FindWalkableOffset(leader_pos, angle*DEGREES, 30, 10) or Vector3(0,0,0)
			if distsq(leader_pos, init_pos) > 1600 and not self.inst.components.unteleportable then
				local pos = leader_pos + offset
				if self.inst.components.combat then
					self.inst.components.combat:SetTarget(nil)
				end
				self.inst:DoTaskInTime(.1, function() 
					self.inst.Transform:SetPosition(pos:Get())
				end)
			end
		end	
		self.inst:ListenForEvent("entitysleep", self.inst.portnearleader)    
	end
end
AddComponentPostInit("follower", TeleportCheck)
]]

ACTIONS.HACK = GLOBAL.Action({}, 2, true, true)

local function OnAttackedSkeletonHelp(inst, data)
	if not inst:IsValid() or not inst.components.combat then return end

    inst.components.combat:ShareTarget(data.attacker, 65, function(dude)
        return dude:HasTag("summonedbyplayer")
               and not dude.components.health:IsDead()
			   and not dude:HasTag("player")
    end, 10)
end

local function playerPostInit_2(inst)
	if not GLOBAL.TheWorld.ismastersim then return end   

	inst:ListenForEvent("attacked",OnAttackedSkeletonHelp)

	if TUNING.SKELETON_PASSERBY_SINKHOLE then
		if not inst.components.tourguide then
		    inst:AddComponent("tourguide")
		end
	    inst.components.tourguide:AddPrefabToList("skeletonservant")
	    inst.components.tourguide:AddPrefabToList("skeletonwarrior")
	    inst.components.tourguide:AddPrefabToList("skeletonmage")
	end
end
AddPlayerPostInit(playerPostInit_2)

local function SkeletonTrade(inst)
	inst:AddTag("skeletontrade")

	if not GLOBAL.TheWorld.ismastersim then return end   

	if not inst.components.tradable then inst:AddComponent("tradable") end
end
AddPrefabPostInit("footballhat", SkeletonTrade)
AddPrefabPostInit("armorwood", SkeletonTrade)
AddPrefabPostInit("nightmarefuel", SkeletonTrade)
AddPrefabPostInit("blueamulet", SkeletonTrade)
AddPrefabPostInit("amulet", SkeletonTrade)
AddPrefabPostInit("purpleamulet", SkeletonTrade)

local function ServantIgnore(inst)
	inst:AddTag("servantignore")
end
AddPrefabPostInit("flower_cave", ServantIgnore)
AddPrefabPostInit("flower_cave_double", ServantIgnore)
AddPrefabPostInit("flower_cave_triple", ServantIgnore)
AddPrefabPostInit("reeds_water", ServantIgnore)
AddPrefabPostInit("lotus", ServantIgnore)
AddPrefabPostInit("pinecone_sapling", ServantIgnore)
AddPrefabPostInit("twiggy_nut_sapling", ServantIgnore)
AddPrefabPostInit("tallbirdegg", ServantIgnore)
AddPrefabPostInit("reviver", ServantIgnore)
if TUNING.SKELETON_LEAVEGUNPOWDER    then AddPrefabPostInit("Gunpowder", ServantIgnore) end
if TUNING.SKELETON_LEAVEJUICYBERRIES then AddPrefabPostInit("berries_juicy", ServantIgnore) end


local function SkeletonDoesntTarget(inst)
	inst:AddTag("structure")
end
AddPrefabPostInit("slurtlehole", SkeletonDoesntTarget)


if TUNING.SKELETON_REVIVE then
  local function onAcceptTest(inst, item, giver)
	return item and item.prefab == "reviver" or (inst.trader_old_test and inst.trader_old_test(inst, item, giver) or false)
  end

  local function onAccept(inst, giver, item)
  	if item == nil then return end
	if item.prefab == "reviver" then
		local skeleton = GLOBAL.SpawnPrefab("skeletonservant")
		skeleton.Transform:SetPosition(inst:GetPosition():Get())
		skeleton.sg:GoToState("happy")
		skeleton.components.talker:Say("Thenk you, I will live for you.")
		inst:Remove() 
	elseif inst.trader_old_onaccept then
		inst.trader_old_onaccept(inst, giver, item) -- call original function
	end
  end

  local function deadbodyPostInit(inst)
    if not GLOBAL.TheWorld.ismastersim then return end  	
    if not inst.components.trader then
	    inst:AddComponent("trader")
	end

	inst.trader_old_test = inst.components.trader.test
    inst.components.trader:SetAcceptTest(onAcceptTest)

    inst.trader_old_onaccept = inst.components.trader.onaccept
	inst.components.trader.onaccept = onAccept
  end

  AddPrefabPostInit("skeleton", deadbodyPostInit)
  AddPrefabPostInit("skeleton_player", deadbodyPostInit)
end


if TUNING.SKELETON_PICKUPHAMBAT then
	local function hambatPostInit(inst)
        inst:AddTag("icebox_valid")
	end
	AddPrefabPostInit("hambat", hambatPostInit)
	AddPrefabPostInit("lm", hambatPostInit) -- Tohru's Dragon Tail Sword
end


-- BUG: Abigail would atttack staying Skeleton.
local function abigailPostInit(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    local combat = inst.components.combat  	
    local old_SetTarget = combat.SetTarget
    function combat:SetTarget(target)
    	if target and target:HasTag("summonedbyplayer") then return end
        return old_SetTarget(self, target) -- call original function
    end
end
AddPrefabPostInit("abigail", abigailPostInit)
AddPrefabPostInit("shadowduelist", abigailPostInit)


-- Playing Horn, you can gether Skeletons
local function hornPostInit(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    if inst.components.finiteuses then
    	inst:RemoveComponent("finiteuses")
    end

    -- override instrument.onplayed
    local instrument = inst.components.instrument
    if not instrument then return end
    local old_onplayed = instrument.onplayed
	instrument:SetOnPlayedFn(function(inst, musician)
		if old_onplayed then
			old_onplayed(inst, musician) -- call original function
		end
		musician:PushEvent("hornplayed")		
	end)
end
AddPrefabPostInit("horn", hornPostInit)


-- debug for afficial update (Sep/12/2021)
local function skeletonInventoryPostInit(inst)
    if not GLOBAL.TheWorld.ismastersim then return end  	

	function inst.components.inventory:DropEverything(ondeath, keepequip)
	    if self.activeitem ~= nil then
	        self:DropItem(self.activeitem)
	        self:SetActiveItem(nil)
	    end

    	for k = 1, self.maxslots do
        	local v = self.itemslots[k]
        	if v ~= nil then
            	self:DropItem(v, true, true)
        	end
    	end

    	if not keepequip then
        	for k, v in pairs(self.equipslots) do
            	if not (ondeath and v.components.inventoryitem.keepondeath) then
                	self:DropItem(v, true, true)
            	end
        	end
    	end
	end
end
AddPrefabPostInit("skeletonservant", skeletonInventoryPostInit)
AddPrefabPostInit("skeletonwarrior", skeletonInventoryPostInit)
AddPrefabPostInit("skeletonmage",    skeletonInventoryPostInit)
