local assets = 
{
	Asset("ANIM", "anim/player_basic.zip"),
	Asset("ANIM", "anim/player_idles_shiver.zip"),
	Asset("ANIM", "anim/player_actions.zip"),
	Asset("ANIM", "anim/player_actions_axe.zip"),
	Asset("ANIM", "anim/player_actions_pickaxe.zip"),
	Asset("ANIM", "anim/player_actions_shovel.zip"),
	Asset("ANIM", "anim/player_actions_blowdart.zip"),
	Asset("ANIM", "anim/player_actions_eat.zip"),
	Asset("ANIM", "anim/player_actions_item.zip"),
	Asset("ANIM", "anim/player_actions_uniqueitem.zip"),
	Asset("ANIM", "anim/player_actions_bugnet.zip"),
	Asset("ANIM", "anim/player_actions_fishing.zip"),
	Asset("ANIM", "anim/player_actions_boomerang.zip"),
	Asset("ANIM", "anim/player_bush_hat.zip"),
	Asset("ANIM", "anim/player_attacks.zip"),
	Asset("ANIM", "anim/player_idles.zip"),
	Asset("ANIM", "anim/player_rebirth.zip"),
	Asset("ANIM", "anim/player_jump.zip"),
	Asset("ANIM", "anim/player_amulet_resurrect.zip"),
	Asset("ANIM", "anim/player_teleport.zip"),
	Asset("ANIM", "anim/wilson_fx.zip"),
	Asset("ANIM", "anim/player_one_man_band.zip"),
	Asset("ANIM", "anim/shadow_hands.zip"),
    Asset("ANIM", "anim/player_woodie.zip"),
	Asset("ANIM", "anim/player_wolfgang.zip"),
	Asset("SOUND", "sound/sfx.fsb"),
	Asset("ANIM", "anim/wilton.zip"),
	Asset("ANIM", "anim/swap_axe.zip"),
	Asset("ANIM", "anim/swap_pickaxe.zip"),
	--Asset("ANIM", "anim/swap_machete.zip"),
	Asset("ANIM", "anim/swap_shovel.zip"),
--	Asset("ANIM", "anim/spear.zip"),
--	Asset("ANIM", "anim/swap_spear.zip"),		
--	Asset("ANIM", "anim/armor_wood.zip"),
--	Asset("ANIM", "anim/hat_football.zip"),	
--	Asset("ANIM", "anim/swap_torch.zip"),
	Asset("SOUND", "sound/common.fsb"),		
	Asset("IMAGE", "images/inventoryimages/skeletonAI.tex"),
	Asset("ATLAS", "images/inventoryimages/skeletonAI.xml"),	
}

local prefabs = 
{
	"goldnugget",
}

local items =
{
	AXE = "swap_axe",
	PICK = "swap_pickaxe",
	--MACHETTE = "swap_machete",
	MACHETTE = "swap_axe",
    SWORD = "swap_spear",
	SHOVEL = "swap_shovel",
	TORCH = "swap_torch",
}

local function KeepTarget(isnt, target)
    return target and target:IsValid()
end

--[[
local function onload(inst, data)
    if data.timeleft then
        inst.lifetime = data.timeleft
        if inst.lifetime > 0 then
            resume(inst, inst.lifetime)
        else
            die(inst)
        end
    end
end
]]

local function OnKeepTarget(inst, target)
    return inst.components.combat:CanTarget(target) 
end

--local function NormalRetarget(inst)
--    local notags = {"FX", "NOCLICK","INLIMBO", "companion", "character", "player", "structure"}
--    return FindEntity(inst, 8, 
--        function(guy) 
--            if inst.components.combat:CanTarget(guy) then
--                return (guy:HasTag("monster") or guy:HasTag("hostile") or guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
--            end
--    end, nil, notags)
--end

local function EquipItem(inst, item)
	if item then
	    inst.AnimState:OverrideSymbol("swap_object", item, item)
	    inst.AnimState:Show("ARM_carry") 
	    inst.AnimState:Hide("ARM_normal")
	end
end

local function OnAttacked(inst, data)
    local attacker = data.attacker
    inst.components.combat:SetTarget(attacker)
    inst.components.combat:ShareTarget(attacker, 30, function(dude) return dude:HasTag("summonedbyplayer") end, 15)
end

local function OnSave()
	if inst.fight then
		return 
		{
			mobspawndelay = inst.fight,
		}
	end
end

local function OnLoad(data)
	self.mobspawndelay = data.mobspawndelay or MOB_DELAY + math.random(0,MOB_DELAY_RANDOM)
end

local function OnGetItemFromPlayer(inst, giver, item)
	if (item.prefab == "spear" or item.prefab == "footballhat" or item.prefab == "armorwood") then
		inst.sg:GoToState("happy")
	    inst.components.talker:Say("MASTER IS GOOD!")
		if not inst.weapons then
			inst.weapons = 1
		else 
			inst.weapons = inst.weapons + 1 
		end
    end
end

local function ShouldAcceptItem(inst, item)
	if (item.prefab == "spear" or item.prefab == "footballhat" or item.prefab == "armorwood") then   
		return true
    end
end

local function OnRefuseItem(inst, item)
--    local playerprefab = GetPlayer()
--    if playerprefab then
--		inst.sg:GoToState("talk")
--		inst.components.talker:Say("WHAT IS THAT?!")
--    end
	inst.sg:GoToState("talk")
	inst.components.talker:Say("WHAT IS THAT?!")
end

local function OnDeath(inst)
	inst.components.talker:Say("I FAILED !")
--	inst.components.lootdropper:SpawnLootPrefab("skeleton")
end

local function HellowMaster(inst)
	if not (inst.talked or inst.components.combat.target or inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("busy") or inst.components.freezable:IsFrozen() or inst.components.health:IsDead() or inst.sg:HasStateTag("working") or inst.components.inventoryitem:IsHeld() or inst.components.followersitcommand:IsCurrentlyStaying() == false) then
		inst.sg:GoToState("talk")
		local talk = math.random(1,7)
	    if talk == 1 then inst.components.talker:Say("MASTER!")
		elseif talk == 2 then inst.components.talker:Say("I COLLECT FOR MASTER!")
		elseif talk == 3 then inst.components.talker:Say("HELLOW MASTER!")
		elseif talk == 4 then inst.components.talker:Say("GLAD TO SEE YOU MASTER!")
		elseif talk == 5 then inst.components.talker:Say("MASTER!")
		elseif talk == 6 then inst.components.talker:Say("CAN I HELP YOU MASTER!")
		elseif talk == 7 then inst.components.talker:Say("I WANT TO BE USEFUL!")
		end
		inst.talked = true
		inst:DoTaskInTime(90, function(inst)
			inst.talked = false
		end)		
    end
end

local function DropItems(inst)
	inst:DoTaskInTime(1*FRAMES, function() 
		if inst.components.inventory then
			inst.components.inventory:DropEverything(true)
			inst.inventoryfull = nil
		end
	end)
end


local function OnDropped(inst)
--	inst.components.inventoryitem.canbepickedup = false
--	if TUNING.SKELETON_FOLLOWING then inst.components.followersitcommand:SetStaying(false) end
	inst.components.followersitcommand:SetCurrentPos()
end


local function OnInventoryfull(inst, data)
--	print("---- Sleleton Servant OnInventoryfull()")
	inst.inventoryfull =  true
end


local function OnHornPlayed(inst, data)
	if inst.components.machine then
		inst.components.machine:TurnOff()
	end
end


local function keepFoodsFresh(inst)
	if not TUNING.SKELETON_FREEZER then return end
	inst.freshInterval = (inst.freshInterval or 0) + 1
	if inst.freshInterval > 10 then
		inst.freshInterval = 0
		local foods = inst.components.inventory:FindItems(function(i) return i.components.perishable end)
		for _,v in pairs(foods) do
			v.components.perishable:SetPercent(1)
		end
	end
end


local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
--	local sound = inst.entity:AddSoundEmitter()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()
	inst.Transform:SetFourFaced(inst)

    MakeCharacterPhysics(inst, 75, .5)
	
	anim:SetBank("wilson")
	anim:SetBuild("wilton")
	anim:PlayAnimation("idle")
    anim:Hide("ARM_carry")
    anim:Hide("hat")
    anim:Hide("hat_hair")
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "skeletonAI.tex" )
	
	inst:AddTag("character")	
	inst:AddTag("notraptrigger")
	inst:AddTag("scarytoprey")
	inst:AddTag("companion")
	inst:AddTag("summonedbyplayer")
--	inst:AddTag("irreplaceable")
	inst:AddTag("nosteal")
	inst:AddTag("kingdom")
	inst:AddTag("skeleton_freezer")

	inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0,-400,0)
	inst.components.talker:StopIgnoringAll()

    if not TheWorld.ismastersim then   
      return inst  
    end   
    
    inst.entity:SetPristine() 

	inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 0.75 )
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * 1.35
	
	inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
	
	inst:AddComponent("playerprox")
    inst.components.playerprox.near = 4
    inst.components.playerprox.onnear = HellowMaster

    MakeMediumFreezableCharacter(inst, "face")
	inst.components.freezable.wearofftime = 1.5
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)
	inst.components.health:StartRegen(5,1)
	inst.components.health.canheal = false
	inst.components.health.canmurder = false
--	if (IsDLCEnabled(CAPY_DLC) or IsDLCEnabled(REIGN_OF_GIANTS)) then
--	if IsDLCEnabled(CAPY_DLC) or IsDLCEnabled(REIGN_OF_GIANTS) or IsDLCEnabled(PORKLAND_DLC) then
--		inst.components.health:SetAbsorptionAmount(0.20)
--	else
--		inst.components.health:SetAbsorbAmount(0.20)
--	end
--	inst.components.health:SetAbsorptionAmount(0.20)
	inst.components.health:SetAbsorptionAmount(TUNING.SKELETON_TUGH_SERVANT)
	
    inst:AddComponent("inspectable")
	inst:AddComponent("knownlocations")

--    inst:AddComponent("lootdropper")
--    inst.components.lootdropper:SetLoot({"skeleton"})
--	inst:AddComponent("norecipelootdrop")
    inst:AddComponent("lootdropper")
    function inst.components.lootdropper:GenerateLoot() return {"skeleton"} end

    inst.items = items
    inst.equipfn = EquipItem
    EquipItem(inst)

    inst:AddComponent("follower")
--	inst.components.follower.maxfollowtime = 9999999
--  inst.components.follower:AddLoyaltyTime(999999)
	
--	inst:AddComponent("eater")

	local brain = require "brains/skeletonservantbrain"
	inst:SetBrain(brain)
	
    inst:AddComponent("followersitcommand")
	
	inst:SetStateGraph("SGskeletonservant")
	
--	inst:AddComponent("inventory")
	
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = true
	inst.components.inventoryitem.imagename = "skeletonAI"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/skeletonAI.xml"	
	inst.components.inventoryitem:SetOnPickupFn(DropItems)
	inst.components.inventoryitem:SetOnDroppedFn(DropItems)
    inst.components.inventoryitem.canaccepttarget = false -- He can't fight

	inst:AddComponent("inventory")
	local old_GiveItem = inst.components.inventory.GiveItem
	function inst.components.inventory:GiveItem(item, slot, screen_src_pos, skipsound, dontDropOnFail)
		if item:HasTag("backpack") then
			self:Equip(item)
			return
		end
		old_GiveItem(self, item, slot, screen_src_pos, skipsound, dontDropOnFail)
	end

    inst:AddComponent("combat")

--	inst:AddComponent("talker")
--  inst.components.talker.fontsize = 35
--	inst.components.talker.font = TALKINGFONT
--	inst.components.talker.offset = Vector3(0,-400,0)
--	inst.components.talker:StopIgnoringAll()

    inst.Transform:SetScale(1.10, 1.10, 1.10)
	
	MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
--	if not TUNING.SKELETION_PROPAGATER then inst:RemoveComponent("propagator") end
	inst:RemoveComponent("propagator")

    inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("death", OnDeath)
	inst:ListenForEvent("ondropped", OnDropped)
	inst:ListenForEvent("inventoryfull", OnInventoryfull)
    inst:ListenForEvent("hornplayed", OnHornPlayed)
	
	inst:DoPeriodicTask(0.5,function() 
--		if not inst.components.inventoryitem.owner then
--			if inst.components.follower and inst.components.follower.leader == nil and inst.components.followersitcommand:IsCurrentlyStaying() == false then	
--				local player = GetClosestInstWithTag("player",inst,6)
--				if player then player.components.leader:AddFollower(inst) end
--			elseif inst.components.follower and inst.components.follower.leader and inst.components.followersitcommand:IsCurrentlyStaying() == true then
--				inst.components.follower.leader.components.leader:RemoveFollower(inst)
--			end
--		end
		local itemtradable = inst.components.inventory:FindItem(function(item)
--			return item:HasTag("skeletontrade")
			return not item.prefab == "nightmarefuel" and item:HasTag("skeletontrade")
        end)
        if itemtradable then
			itemtradable:Remove()
		end
		if inst.weapons and inst.weapons >= 3 then			
			inst:DoTaskInTime(1*FRAMES, function() 
				if inst.components.inventory then
					inst.components.inventory:DropEverything(true)
				end
			end)	
			inst:DoTaskInTime(2*FRAMES, function()
				local skeletonwarrior = SpawnPrefab("skeletonwarrior")
				skeletonwarrior.Transform:SetPosition(inst:GetPosition():Get())
				skeletonwarrior.sg:GoToState("talk")
				skeletonwarrior.components.talker:Say("I can now fight for you sir!")
				inst:Remove() 
			end)
		end

		-- against monkey pikking up
		if FindEntity(inst, 15, nil, nil, nil, {"monkey", "eyeplant"}) then
			inst.components.inventoryitem.canbepickedup = false
		else
			inst.components.inventoryitem.canbepickedup = true
		end

		keepFoodsFresh(inst)
	end)
	
	inst.OnSave = function(inst, data)
		if inst.weapons then 
			data.weapons = inst.weapons
		end
    	data.singleton_id = inst.singleton_id -- duplication bug fix, when a game starts.
    end     
    
    inst.OnPreLoad = function(inst, data)
        -- duplication bug fix, when a game starts.
        if data and data.singleton_id then
            inst.singleton_id = data.singleton_id
        end
    end

    inst.OnLoad = function(inst, data)    
		if data and data.weapons then
			inst.weapons = data.weapons
		end
    end

--	inst.components.inventoryitem.canbepickedup = false
    inst:DoTaskInTime(1, function(inst)
	    if inst.components.inventoryitem:IsHeld() then inst.components.inventoryitem.canbepickedup = true end
	end)

    -- duplication bug fix, when a game starts.
    inst.singleton_id = math.random()
    local old_SetLeader = inst.components.follower.SetLeader
    function inst.components.follower:SetLeader(player)
        if player ~= nil then
            local inst = self.inst
            local ents = player.components.leader.followers or {}
            for e,_ in pairs(ents) do
                if e ~= inst and e.singleton_id == inst.singleton_id then
                    inst:DoTaskInTime(0, function(inst) inst:Remove() end)
                    return
                end
            end
        end
        old_SetLeader(self, player)
    end

	return inst
end

STRINGS.NAMES.SKELETONSERVANT = "Skeleton Servant"
STRINGS.RECIPE_DESC.SKELETONSERVANT = "Summon a loyal skeleton servant."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SKELETONSERVANT = "He works without stopping for me."

return Prefab("common/skeletonservant", fn, assets, prefabs)