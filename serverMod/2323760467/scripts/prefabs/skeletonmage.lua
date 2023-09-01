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
--	Asset("ANIM", "anim/swap_axe.zip"),
--	Asset("ANIM", "anim/swap_pickaxe.zip"),
	--Asset("ANIM", "anim/swap_machete.zip"),
	Asset("ANIM", "anim/amulets.zip"),
	Asset("ANIM", "anim/torso_amulets.zip"),
	Asset("ANIM", "anim/staffs.zip"),
    Asset("ANIM", "anim/swap_staffs.zip"),
	Asset("SOUND", "sound/common.fsb"),		
	Asset("IMAGE", "images/inventoryimages/skeletonAI.tex"),
	Asset("ATLAS", "images/inventoryimages/skeletonAI.xml"),	
}

local prefabs = 
{
	"goldnugget",
}

--local items =
--{
--	AXE = "swap_axe",
--	PICK = "swap_pickaxe",
--	--MACHETTE = "swap_machete",
--	MACHETTE = "swap_axe",
--    SWORD = "swap_spear",
--	SHOVEL = "swap_shovel",
--	TORCH = "swap_torch",
--}

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

local function OnNewTarget(inst, data)
--    inst.components.combat:ShareTarget(data.target, 30, function(dude) return dude:HasTag("summonedbyplayer") end, 15)
	inst.components.combat:ShareTarget(data.target, 30, function(dude) return dude:HasTag("summonedbyplayer") or (dude.components.follower and dude.components.follower.leader and dude.components.follower.leader:HasTag("player")) end, 15)
end

local function OnKeepTarget(inst, target)
    return inst.components.combat:CanTarget(target) 
end

local function NormalRetarget(inst)
--    local notags = {"FX", "NOCLICK","INLIMBO", "companion", "character", "player", "structure"}
    local notags = {"FX", "NOCLICK","INLIMBO", "companion", "player", "structure"}
    return FindEntity(inst, 11, 
        function(guy) 
            if inst.components.combat:CanTarget(guy) then
--                return (guy:HasTag("monster") or guy:HasTag("hostile") or guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
                return guy:HasTag("monster") or guy:HasTag("hostile") or (guy.components.combat.target and guy.components.combat.target:HasTag("player"))
            end
    end, nil, notags)
end

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
	if inst.icemagic and attacker.components.freezable then 
        attacker.components.freezable:AddColdness(2)
        attacker.components.freezable:SpawnShatterFX()
	elseif inst.firemagic and attacker.components.burnable and not attacker.components.burnable:IsBurning() then 
		attacker.components.freezable:Unfreeze()                      
		attacker.components.burnable:Ignite(true)
    end
end

local function IceEffect(inst, attacker, target)
    if target.components.freezable then
        target.components.freezable:AddColdness(2)
        target.components.freezable:SpawnShatterFX()
    end
end

local function FireEffect(inst, attacker, target)
	local burnchance = math.random(1,3)
	if burnchance == 1 then
		if target.components.burnable and not target.components.burnable:IsBurning() then         
			target.components.freezable:Unfreeze()                      
			target.components.burnable:Ignite(true)
		end
	end		
end

local function WeaponDropped(inst)
    inst:Remove()
end

local function EquipWeapon(inst)
    if inst.components.inventory and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(inst.components.combat.defaultdamage)
        weapon.components.weapon:SetRange(inst.components.combat.attackrange, inst.components.combat.attackrange+4)
		if inst.icemagic then
			weapon.components.weapon:SetOnAttack(IceEffect)
			weapon.components.weapon:SetProjectile("ice_projectile")
			weapon.components.weapon:SetDamage(40)
		elseif inst.firemagic then
			weapon.components.weapon:SetOnAttack(FireEffect)
			weapon.components.weapon:SetProjectile("fire_projectile")
			weapon.components.weapon:SetDamage(50)			
		else
			weapon.components.weapon:SetProjectile("bishop_charge")
			weapon.components.weapon:SetDamage(60)
		end
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(WeaponDropped)
        weapon:AddComponent("equippable")
        inst.components.inventory:Equip(weapon)
    end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.prefab == "blueamulet" and not inst.icemagic then 
        inst.icemagic = true
		inst.firemagic = false
	elseif item.prefab == "amulet" and not inst.firemagic then 
        inst.icemagic = false
		inst.firemagic = true
	elseif item.prefab == "purpleamulet" and (inst.icemagic or inst.firemagic) then 
        inst.icemagic = false
		inst.firemagic = false
    end
	--if (item.prefab == "blueamulet" or item.prefab == "amulet" or item.prefab == "purpleamulet") then   
        inst.components.health:DoDelta(300) 
		local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		inst.components.inventory:DropItem(weapon)
		inst:DoTaskInTime(1, EquipWeapon)		
		inst.sg:GoToState("happy")
		local talk = math.random(1,4)
	    if talk == 1 then inst.components.talker:Say("Interesting!")
		elseif talk == 2 then inst.components.talker:Say("Such power!")
		elseif talk == 3 then inst.components.talker:Say("Thank you!")
		elseif talk == 4 then inst.components.talker:Say("A strange magic!")
		end
    --end
end

local function ShouldAcceptItem(inst, item)
	if (item.prefab == "blueamulet" or item.prefab == "amulet" or item.prefab == "purpleamulet") then   
		return true
    end
end

local function OnRefuseItem(inst, item)
--    local playerprefab = GetPlayer()
--    if playerprefab then
--		inst.sg:GoToState("talk")
--		inst.components.talker:Say("I've nothing to do with that.")
--    end
	inst.sg:GoToState("talk")
	inst.components.talker:Say("I've nothing to do with that.")
end

local function OnDeath(inst)
	inst.components.talker:Say("Noo! I can't be defeated....")
	inst.components.lootdropper:SpawnLootPrefab("skeleton")
end

local function HellowMaster(inst)
	if not (inst.talked or inst.components.combat.target or inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("busy") or inst.components.freezable:IsFrozen() or inst.components.health:IsDead() or inst.sg:HasStateTag("working") or inst.components.inventoryitem:IsHeld() or inst.components.followersitcommand:IsCurrentlyStaying() == false) then
		inst.sg:GoToState("talk")
		local talk = math.random(1,7)
	    if talk == 1 then inst.components.talker:Say("My magic has no limit.")
		elseif talk == 2 then inst.components.talker:Say("There are no limit to my power")
		elseif talk == 3 then inst.components.talker:Say("The light the dark... what is the difference?")
		elseif talk == 4 then inst.components.talker:Say("Do you have any kind of magic book.")
		elseif talk == 5 then inst.components.talker:Say("I wish to learn different magics")
		elseif talk == 6 then inst.components.talker:Say("AVADA KEDAVRA!")
		elseif talk == 7 then inst.components.talker:Say("Thank you for making me so powerful.")
		end
		inst.talked = true
		inst:DoTaskInTime(90, function(inst)
			inst.talked = false
		end)		
    end
end


local function OnDropped(inst)
    inst.components.inventoryitem.canaccepttarget = true
--	inst.components.inventoryitem.canbepickedup = false
--	if TUNING.SKELETON_FOLLOWING then inst.components.followersitcommand:SetStaying(false) end
	inst.components.followersitcommand:SetCurrentPos()
end



local function OnHornPlayed(inst, data)
	if inst.components.machine then
		inst.components.machine:TurnOff()
	end
end


local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()
	inst.Transform:SetFourFaced(inst)

    MakeCharacterPhysics(inst, 75, .5)
	
	anim:SetBank("wilson")
	anim:SetBuild("wilton")
	anim:PlayAnimation("idle")
	
--	inst.AnimState:OverrideSymbol("swap_object", "swap_staffs", "purplestaff")
    inst.AnimState:Show("ARM_carry") 
    inst.AnimState:Hide("ARM_normal")
	inst.AnimState:OverrideSymbol("swap_body", "torso_amulets", "purpleamulet")
	inst.AnimState:OverrideSymbol("swap_hat", "hat_feather", "swap_hat")
    inst.AnimState:Show("HAT")
    inst.AnimState:Show("HAT_HAIR")
    inst.AnimState:Hide("HAIR_NOHAT")
    inst.AnimState:Hide("HAIR")
	
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
	inst.components.health:StartRegen(3,1)
	inst.components.health.canheal = false
	inst.components.health.canmurder = false
--	if (IsDLCEnabled(CAPY_DLC) or IsDLCEnabled(REIGN_OF_GIANTS)) then
--	if IsDLCEnabled(CAPY_DLC) or IsDLCEnabled(REIGN_OF_GIANTS) or IsDLCEnabled(PORKLAND_DLC) then
--		inst.components.health:SetAbsorptionAmount(0.20)
--	else
--		inst.components.health:SetAbsorbAmount(0.20)
--	end
--	inst.components.health:SetAbsorptionAmount(0.20)
	inst.components.health:SetAbsorptionAmount(TUNING.SKELETON_TUGH_MAGE)

    inst:AddComponent("inspectable")
	inst:AddComponent("knownlocations")

--    inst:AddComponent("lootdropper")
--    inst.components.lootdropper:SetLoot({"skeleton"})
--	inst:AddComponent("norecipelootdrop")
    inst:AddComponent("lootdropper")
    function inst.components.lootdropper:GenerateLoot() return {"skeleton"} end

    inst:AddComponent("follower")
--	inst.components.follower.maxfollowtime = 9999999
--  inst.components.follower:AddLoyaltyTime(999999)	
	
--	inst:AddComponent("eater")

	local brain = require "brains/skeletonmagebrain"
	inst:SetBrain(brain)
	
    inst:AddComponent("followersitcommand")
	
	inst:SetStateGraph("SGskeletonmage")
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = true
	inst.components.inventoryitem.imagename = "skeletonAI"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/skeletonAI.xml"	
	inst.components.inventoryitem:SetOnPickupFn(function(inst, picker) inst.components.inventoryitem.canaccepttarget = false end)

    inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetDefaultDamage(60)
    inst.components.combat:SetAttackPeriod(2.5)	
    inst.components.combat:SetKeepTargetFunction(OnKeepTarget)
	inst.components.combat:SetRetargetFunction(1, NormalRetarget)
	local old_CanTarget = inst.components.combat.CanTarget
	function inst.components.combat:CanTarget(guy)
		if guy.components.follower and guy.components.follower.leader and guy.components.follower.leader:HasTag("player") then
			return false
		else
			return old_CanTarget(self, guy) -- call original function
		end
	end
	inst:DoPeriodicTask(1,function()	
		if inst.icemagic then
			inst.components.combat:SetDefaultDamage(40)
		elseif inst.icemagic then
			inst.components.combat:SetDefaultDamage(40)
		else
			inst.components.combat:SetDefaultDamage(60)
		end
	end)

--	inst:AddComponent("talker")
--  inst.components.talker.fontsize = 35
--	inst.components.talker.font = TALKINGFONT
--	inst.components.talker.offset = Vector3(0,-400,0)
--	inst.components.talker:StopIgnoringAll()

    inst.Transform:SetScale(1.10, 1.10, 1.10)
	
	MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")
	inst.components.freezable.wearofftime = 0.8
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
--	if not TUNING.SKELETION_PROPAGATER then inst:RemoveComponent("propagator") end
	inst:RemoveComponent("propagator")
	
    inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("newcombattarget", OnNewTarget)
	inst:ListenForEvent("death", OnDeath)
	inst:ListenForEvent("ondropped", OnDropped)
    inst:ListenForEvent("hornplayed", OnHornPlayed)
	
	inst:AddComponent("inventory")
	
	inst:DoTaskInTime(1, EquipWeapon)
	
	inst:DoPeriodicTask(0.5, function()
--		if not inst.components.inventoryitem.owner then
--			if inst.components.follower and inst.components.follower.leader == nil and inst.components.followersitcommand:IsCurrentlyStaying() == false then	
--				local player = GetClosestInstWithTag("player",inst,6)
--				if player then player.components.leader:AddFollower(inst) end
--			elseif inst.components.follower and inst.components.follower.leader and inst.components.followersitcommand:IsCurrentlyStaying() == true then
--				inst.components.follower.leader.components.leader:RemoveFollower(inst)
--			end
--		end
		
		if inst.icemagic then
			inst.AnimState:OverrideSymbol("swap_object", "swap_staffs", "swap_bluestaff")
			inst.AnimState:OverrideSymbol("swap_body", "torso_amulets", "blueamulet")
		elseif inst.firemagic then
			inst.AnimState:OverrideSymbol("swap_object", "swap_staffs", "swap_redstaff")
			inst.AnimState:OverrideSymbol("swap_body", "torso_amulets", "redamulet")
		else
			inst.AnimState:OverrideSymbol("swap_object", "swap_staffs", "swap_purplestaff")
			inst.AnimState:OverrideSymbol("swap_body", "torso_amulets", "purpleamulet")
		end	

		-- against monkey pikking up
		if FindEntity(inst, 15, nil, nil, nil, {"monkey", "eyeplant"}) then
			inst.components.inventoryitem.canbepickedup = false
		else
			inst.components.inventoryitem.canbepickedup = true
		end
	end)
	
	inst:DoPeriodicTask(5,function()
		if not (inst.icemagic or inst.firemagic) then
			local shadowcreatures = 0
			local pt = inst:GetPosition()
			local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 10)
			for k,v in pairs(ents) do
				if v:HasTag("shadow") then	
					shadowcreatures = shadowcreatures + 1
				end
			end	
			if not (inst.components.freezable:IsFrozen() or inst.components.health:IsDead() or inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("busy")) and shadowcreatures > 0 then
				inst.sg:GoToState("spell")
			end
		elseif inst.firemagic then
			local pt = inst:GetPosition()
			local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 10)
			for k,v in pairs(ents) do
				if v:HasTag("player") then	
					v.components.health:DoDelta(2)
				end
			end	
		end	
	end)
	
	inst.OnSave = function(inst, data)
		if inst.icemagic then 
			data.icemagic = inst.icemagic
		elseif inst.firemagic then
			data.firemagic = inst.firemagic
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
		if data and data.icemagic then
			inst.icemagic = data.icemagic
		elseif data and data.firemagic then
			inst.firemagic = data.firemagic
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

STRINGS.NAMES.SKELETONMAGE = "Skeleton Mage"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SKELETONMAGE = "He masters magic better than me."

return Prefab("common/skeletonmage", fn, assets, prefabs)