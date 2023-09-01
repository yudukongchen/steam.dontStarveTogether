local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")
local cooking = require("cooking")

local assets = {
    Asset("ANIM", "anim/tz_fhym.zip"),
    Asset("ANIM", "anim/swap_tz_fhym.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fhym.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fhym.xml")
}

local function UpdateLight(inst)
    if inst.components.equippable:IsEquipped() and inst.form_status == 3 then
        local owner = inst.components.inventoryitem.owner
        if inst.light == nil then
            inst.light = SpawnPrefab("nightstickfire")
		    inst.light.entity:AddFollower()
            inst.light.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -110, 0)      
        end
    else 
        if inst.light then
            inst.light:Remove()
            inst.light = nil 
        end
    end
end

local function OnEquip(inst,data)
    UpdateLight(inst)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
	if data ~= nil and data.owner and data.owner:HasTag("player") then
		inst.components.container:Open(data.owner)
	end
end

local function OnUnEquip(inst,data)
    UpdateLight(inst)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
	if data ~= nil and data.owner and data.owner:HasTag("player") then
		inst.components.container:Close(data.owner)
	end
end

local form_desc = {
    "雷罚形态！",
    "冰霜形态！",
    "曙光形态！",
}

local function GetStimuliMultOn(inst,attacker,target)
    local stimuli = inst.components.weapon.stimuli
    if inst.components.weapon.overridestimulifn ~= nil then
        stimuli = inst.components.weapon.overridestimulifn(inst,attacker, target)
    end
    if stimuli == nil and attacker.components.electricattacks ~= nil then
        stimuli = "electric"
    end

    local electric_mult =
        stimuli == "electric" and not (target:HasTag("electricdamageimmune") or
                (target.components.inventory ~= nil and target.components.inventory:IsInsulated()))
        and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (target.components.moisture ~= nil and target.components.moisture:GetMoisturePercent() or (target:GetIsWet() and 1 or 0))
        or 1

    return electric_mult,stimuli
end

local function DoPiercingDamage(attacker,target,damage,weapon,stimuli)
	attacker.components.health:DoDelta(-damage*-0.005)
    target.components.health:DoDelta(-damage,nil,attacker.prefab,false,attacker,true)
    if target.components.health:IsDead() then
        attacker:PushEvent("killed", { victim = target })
		if target:HasTag("shadow") then
			attacker.components.sanity:DoDelta(15)
		end
    end 
    target:PushEvent("attacked", { attacker = attacker, damage = damage, weapon = weapon ,stimuli = stimuli})
    attacker:PushEvent("onhitother", { target = target, damage = damage, damageresolved = damage,weapon = weapon,stimuli = stimuli})
end
---------------------------------------------------------------
local greygemTime = loadstring("\114\101\116\117\114\110\32\123\32\101\118\101\114\103\114\101\101\110\32\61\32\34\114\111\99\107\95\112\101\116\114\105\102\105\101\100\95\116\114\101\101\95\116\97\108\108\34\44\32\101\118\101\114\103\114\101\101\110\95\116\97\108\108\32\61\32\34\114\111\99\107\95\112\101\116\114\105\102\105\101\100\95\116\114\101\101\95\116\97\108\108\34\44\32\101\118\101\114\103\114\101\101\110\95\115\112\97\114\115\101\32\61\32\34\114\111\99\107\95\112\101\116\114\105\102\105\101\100\95\116\114\101\101\95\116\97\108\108\34\44\32\101\118\101\114\103\114\101\101\110\95\115\112\97\114\115\101\95\116\97\108\108\32\61\32\34\114\111\99\107\95\112\101\116\114\105\102\105\101\100\95\116\114\101\101\95\116\97\108\108\34\44\32\98\101\114\114\121\98\117\115\104\32\61\32\34\98\101\114\114\121\98\117\115\104\50\34\44\32\98\101\114\114\121\98\117\115\104\50\32\61\32\34\98\101\114\114\121\98\117\115\104\95\106\117\105\99\121\34\44\32\98\101\114\114\121\98\117\115\104\95\106\117\105\99\121\32\61\32\34\98\101\114\114\121\98\117\115\104\34\44\32\115\97\112\108\105\110\103\95\109\111\111\110\32\61\32\34\115\97\112\108\105\110\103\34\44\32\103\114\97\115\115\103\101\107\107\111\32\61\32\34\103\114\97\115\115\34\44\32\115\97\112\108\105\110\103\32\61\32\34\115\97\112\108\105\110\103\95\109\111\111\110\34\44\32\112\108\97\110\116\101\100\95\102\108\111\119\101\114\32\61\32\34\102\108\111\119\101\114\95\101\118\105\108\34\44\32\102\108\111\119\101\114\95\101\118\105\108\32\61\32\34\112\108\97\110\116\101\100\95\102\108\111\119\101\114\34\44\32\111\99\101\97\110\102\105\115\104\95\109\101\100\105\117\109\95\56\95\105\110\118\32\61\32\34\111\99\101\97\110\102\105\115\104\95\115\109\97\108\108\95\56\95\105\110\118\34\44\32\111\99\101\97\110\102\105\115\104\95\115\109\97\108\108\95\56\95\105\110\118\32\61\32\34\111\99\101\97\110\102\105\115\104\95\109\101\100\105\117\109\95\56\95\105\110\118\34\44\32\98\117\116\116\101\114\32\61\32\34\103\111\97\116\109\105\108\107\34\44\32\103\111\97\116\109\105\108\107\32\61\32\34\109\105\108\107\121\119\104\105\116\101\115\34\44\32\109\105\108\107\121\119\104\105\116\101\115\32\61\32\34\98\117\116\116\101\114\34\44\32\115\112\105\100\101\114\113\117\101\101\110\32\61\32\34\115\112\105\100\101\114\100\101\110\95\51\34\44\32\115\112\105\100\101\114\100\101\110\32\61\32\34\115\112\105\100\101\114\113\117\101\101\110\34\44\32\115\112\105\100\101\114\104\111\108\101\32\61\32\34\109\111\111\110\115\112\105\100\101\114\100\101\110\34\44\32\109\111\111\110\115\112\105\100\101\114\100\101\110\32\61\32\34\115\112\105\100\101\114\104\111\108\101\34\44\32\103\105\110\103\101\114\98\114\101\97\100\104\111\117\115\101\32\61\32\34\112\105\103\104\111\117\115\101\34\44\32\112\105\103\104\111\117\115\101\32\61\32\34\103\105\110\103\101\114\98\114\101\97\100\104\111\117\115\101\34\44\32\114\97\98\98\105\116\32\61\32\34\98\117\110\110\121\109\97\110\34\44\32\98\117\110\110\121\109\97\110\32\61\32\34\114\97\98\98\105\116\34\44\32\115\108\117\114\116\108\101\32\61\32\34\115\110\117\114\116\108\101\34\44\32\115\110\117\114\116\108\101\32\61\32\34\115\108\117\114\116\108\101\34\44\32\108\105\116\116\108\101\95\119\97\108\114\117\115\32\61\32\34\119\97\108\114\117\115\34\32\125")()
greygemTime.goldnugget = "lucky_goldnugget"
greygemTime.lucky_goldnugget = "goldnugget"
greygemTime.grass = "grassgekko"
greygemTime.walrus = "little_walrus"
greygemTime.flower = "flower_evil"
greygemTime.butterfly = "moonbutterfly"
greygemTime.moonbutterfly = "butterfly"
greygemTime.butterflywings = "butter"

local trypicking = loadstring("\114\101\116\117\114\110\32\102\117\110\99\116\105\111\110\40\120\44\32\121\44\32\122\44\32\112\114\101\102\97\98\44\32\99\97\115\116\101\114\41\32\102\111\114\32\105\44\32\118\32\105\110\32\105\112\97\105\114\115\40\84\104\101\83\105\109\58\70\105\110\100\69\110\116\105\116\105\101\115\40\120\44\32\121\44\32\122\44\32\50\48\44\32\123\32\34\95\105\110\118\101\110\116\111\114\121\105\116\101\109\34\32\125\44\32\123\32\34\98\97\114\114\101\110\34\44\32\34\115\116\117\109\112\34\44\32\34\119\105\116\104\101\114\101\100\34\44\32\34\73\78\76\73\77\66\79\34\44\32\34\78\79\67\76\73\67\75\34\44\32\34\107\110\111\99\107\98\97\99\107\100\101\108\97\121\105\110\116\101\114\97\99\116\105\111\110\34\44\32\34\99\97\116\99\104\97\98\108\101\34\44\32\34\102\105\114\101\34\44\32\34\109\105\110\101\115\112\114\117\110\103\34\44\32\34\109\105\110\101\97\99\116\105\118\101\34\32\125\41\41\32\100\111\32\105\102\32\118\46\112\114\101\102\97\98\32\61\61\32\112\114\101\102\97\98\32\111\114\32\40\112\114\101\102\97\98\32\61\61\32\110\105\108\32\97\110\100\32\118\46\99\111\109\112\111\110\101\110\116\115\46\105\110\118\101\110\116\111\114\121\105\116\101\109\32\97\110\100\32\118\46\99\111\109\112\111\110\101\110\116\115\46\105\110\118\101\110\116\111\114\121\105\116\101\109\46\99\97\110\98\101\112\105\99\107\101\100\117\112\32\61\61\32\116\114\117\101\41\32\116\104\101\110\32\105\102\32\118\46\99\111\109\112\111\110\101\110\116\115\46\98\117\114\110\97\98\108\101\32\126\61\32\110\105\108\32\116\104\101\110\32\105\102\32\118\46\99\111\109\112\111\110\101\110\116\115\46\98\117\114\110\97\98\108\101\58\73\115\66\117\114\110\105\110\103\40\41\32\116\104\101\110\32\118\46\99\111\109\112\111\110\101\110\116\115\46\98\117\114\110\97\98\108\101\58\69\120\116\105\110\103\117\105\115\104\40\41\32\101\108\115\101\105\102\32\118\46\99\111\109\112\111\110\101\110\116\115\46\98\117\114\110\97\98\108\101\58\73\115\83\109\111\108\100\101\114\105\110\103\40\41\32\116\104\101\110\32\118\46\99\111\109\112\111\110\101\110\116\115\46\98\117\114\110\97\98\108\101\58\83\109\111\116\104\101\114\83\109\111\108\100\101\114\40\41\32\101\110\100\32\101\110\100\32\105\102\32\118\46\99\111\109\112\111\110\101\110\116\115\46\116\114\97\112\32\126\61\32\110\105\108\32\97\110\100\32\118\46\99\111\109\112\111\110\101\110\116\115\46\116\114\97\112\58\73\115\83\112\114\117\110\103\40\41\32\116\104\101\110\32\118\46\99\111\109\112\111\110\101\110\116\115\46\116\114\97\112\58\72\97\114\118\101\115\116\40\99\97\115\116\101\114\41\32\101\108\115\101\32\99\97\115\116\101\114\46\99\111\109\112\111\110\101\110\116\115\46\105\110\118\101\110\116\111\114\121\58\71\105\118\101\73\116\101\109\40\118\44\32\110\105\108\44\32\118\58\71\101\116\80\111\115\105\116\105\111\110\40\41\41\32\101\110\100\32\101\110\100\32\101\110\100\32\101\110\100")()
local deploy = loadstring("\114\101\116\117\114\110\32\102\117\110\99\116\105\111\110\40\105\110\115\116\44\32\105\116\101\109\44\32\97\99\116\95\112\111\115\44\32\100\101\112\108\111\121\101\114\44\32\114\111\116\97\116\105\111\110\41\32\105\102\32\105\116\101\109\46\99\111\109\112\111\110\101\110\116\115\46\100\101\112\108\111\121\97\98\108\101\58\67\97\110\68\101\112\108\111\121\40\97\99\116\95\112\111\115\44\32\110\105\108\44\32\100\101\112\108\111\121\101\114\44\32\114\111\116\97\116\105\111\110\41\32\116\104\101\110\32\105\102\32\105\116\101\109\46\99\111\109\112\111\110\101\110\116\115\46\100\101\112\108\111\121\97\98\108\101\46\107\101\101\112\95\105\110\95\105\110\118\101\110\116\111\114\121\95\111\110\95\100\101\112\108\111\121\32\116\104\101\110\32\105\116\101\109\46\99\111\109\112\111\110\101\110\116\115\46\100\101\112\108\111\121\97\98\108\101\58\68\101\112\108\111\121\40\97\99\116\95\112\111\115\44\32\100\101\112\108\111\121\101\114\44\32\114\111\116\97\116\105\111\110\41\32\101\108\115\101\32\108\111\99\97\108\32\111\98\106\32\61\32\105\110\115\116\46\99\111\109\112\111\110\101\110\116\115\46\99\111\110\116\97\105\110\101\114\58\82\101\109\111\118\101\73\116\101\109\40\105\116\101\109\41\32\111\114\32\110\105\108\32\105\102\32\111\98\106\32\126\61\32\110\105\108\32\116\104\101\110\32\105\102\32\110\111\116\32\111\98\106\46\99\111\109\112\111\110\101\110\116\115\46\100\101\112\108\111\121\97\98\108\101\58\68\101\112\108\111\121\40\97\99\116\95\112\111\115\44\32\100\101\112\108\111\121\101\114\44\32\114\111\116\97\116\105\111\110\41\32\116\104\101\110\32\105\110\115\116\46\99\111\109\112\111\110\101\110\116\115\46\99\111\110\116\97\105\110\101\114\58\71\105\118\101\73\116\101\109\40\111\98\106\41\32\101\110\100\32\101\110\100\32\101\110\100\32\101\108\115\101\32\108\111\99\97\108\32\111\98\106\32\61\32\105\110\115\116\46\99\111\109\112\111\110\101\110\116\115\46\99\111\110\116\97\105\110\101\114\58\82\101\109\111\118\101\73\116\101\109\40\105\116\101\109\41\32\111\114\32\110\105\108\32\105\102\32\111\98\106\32\126\61\32\110\105\108\32\116\104\101\110\32\105\102\32\111\98\106\46\99\111\109\112\111\110\101\110\116\115\46\100\101\112\108\111\121\97\98\108\101\46\111\110\100\101\112\108\111\121\32\126\61\32\110\105\108\32\116\104\101\110\32\111\98\106\46\99\111\109\112\111\110\101\110\116\115\46\100\101\112\108\111\121\97\98\108\101\46\111\110\100\101\112\108\111\121\40\111\98\106\44\32\97\99\116\95\112\111\115\44\32\100\101\112\108\111\121\101\114\44\32\114\111\116\97\116\105\111\110\32\111\114\32\48\41\32\101\110\100\32\100\101\112\108\111\121\101\114\58\80\117\115\104\69\118\101\110\116\40\34\100\101\112\108\111\121\105\116\101\109\34\44\32\123\32\112\114\101\102\97\98\32\61\32\111\98\106\46\112\114\101\102\97\98\32\125\41\32\105\102\32\111\98\106\58\72\97\115\84\97\103\40\34\100\101\112\108\111\121\101\100\112\108\97\110\116\34\41\32\116\104\101\110\32\105\110\115\116\46\121\121\120\107\87\111\114\108\100\58\80\117\115\104\69\118\101\110\116\40\34\105\116\101\109\112\108\97\110\116\101\100\34\44\32\123\32\100\111\101\114\32\61\32\100\101\112\108\111\121\101\114\44\32\112\111\115\32\61\32\97\99\116\95\112\111\115\32\125\41\32\101\110\100\32\101\110\100\32\101\110\100\32\101\110\100")()

local itemget = function(inst, data)
    if data.slot == 1 and data.item then
        if data.item.components.weapon ~= nil then
            inst.weapon = data.item
            if inst.weapon.components.weapon:CanRangedAttack() then
                inst.components.weapon:SetProjectile(inst.weapon.components.weapon.projectile)
            end
            inst.components.weapon:SetDamage(inst.weapon.components.weapon.damage)
        end
        if data.item:HasTag("rangedlighter") then
            inst:AddTag("rangedlighter")
        elseif data.item:HasTag("extinguisher") then
            inst:AddTag("extinguisher")
        end
		if data.item.prefab == "townportaltalisman" then
			inst:AddTag("tz_fhym_tp")
		end
    end
end
local itemlose = function(inst, data)
    if data then
        if data.slot == 1 then
            inst.weapon = nil
            inst.components.weapon:SetDamage(0)
            if inst:HasTag("rangedlighter") then
                inst:RemoveTag("rangedlighter")
            elseif inst:HasTag("extinguisher") then
                inst:RemoveTag("extinguisher")
            end
			if inst:HasTag("tz_fhym_tp") then
                inst:RemoveTag("tz_fhym_tp")
            end
        end
    end
end

local INITIAL_LAUNCH_HEIGHT = 0.1
local SPEED = 8
local function launch_away(inst, position)
    local ix, iy, iz = inst.Transform:GetWorldPosition()
    inst.Physics:Teleport(ix, iy + INITIAL_LAUNCH_HEIGHT, iz)

    local px, py, pz = position:Get()
    local angle = (180 - inst:GetAngleToPoint(px, py, pz)) * DEGREES
    local sina, cosa = math.sin(angle), math.cos(angle)
    inst.Physics:SetVel(SPEED * cosa, 4 + SPEED, SPEED * sina)
end

local magic = { 
redgem = function(inst, caster, target, pos)
	SpawnPrefab("sporecloud").Transform:SetPosition(pos:Get())
	caster.components.sanity:DoDelta(-15)
end, moonrocknugget = function(inst, caster, target, pos)
    if target ~= nil and target:IsValid() then
		local x, y, z = caster.Transform:GetWorldPosition()
		if TheWorld.Map:IsPassableAtPoint(x, y, z) then
			if target.Physics ~= nil then
				target.Physics:Teleport(x, y, z)
			else
				target.Transform:SetPosition(x, y, z)
			end
		end
    end
end, orangegem = function(inst, caster, target, pos)
	caster.components.sanity:DoDelta(-15)
	if target == nil then
		target = inst.components.container:GetItemInSlot(1)
	end
	if target ~= nil and target._onattackother == nil then
		if caster.components.electricattacks == nil then
			caster:AddComponent("electricattacks")
		end
		caster.components.electricattacks:AddSource(target)
		target._onattackother = function(attacker, data)
			if data.weapon ~= nil then
				if data.projectile == nil then
					if data.weapon.components.projectile ~= nil then
						return
					elseif data.weapon.components.complexprojectile ~= nil then
						return
					elseif data.weapon.components.weapon:CanRangedAttack() then
						return
					end
				end
			end
			if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
				SpawnPrefab("electrichitsparks"):AlignToTarget(data.target, data.projectile ~= nil and data.projectile:IsValid() and data.projectile or attacker, true)
			end
		end
		target:ListenForEvent("onattackother", target._onattackother, caster)
	end
	TheWorld:PushEvent("ms_sendlightningstrike", pos)
  
end, yellowgem = function(inst, caster, target, pos)
		local x, y, z = pos:Get()
		SpawnPrefab("crab_king_icefx").Transform:SetPosition(x, y, z)
		for i, v in ipairs(TheSim:FindEntities(x, y, z, 4, nil, { "NOCLICK", "FX", "catchable", "fire", "minesprung", "mineactive" })) do
			if v.components.perishable ~= nil then
				v.components.perishable:SetPercent(1)
				if v.components.perishable:IsPerishing() then
					v.components.perishable:StartPerishing()
				end
			elseif v.components.container ~= nil then
				for ck, cv in pairs(v.components.container.slots) do
					if cv.components.perishable ~= nil then
						cv.components.perishable:SetPercent(1)
						if cv.components.perishable:IsPerishing() then
							cv.components.perishable:StartPerishing()
						end
					end
				end
			end
		end
	
end, moonglass = function(inst, caster, target, pos)
		local x, y, z = pos:Get()
		local ents = TheSim:FindEntities(x, y, z, 4, nil, inst.CONSTANT_TAG)
		caster.components.hunger:DoDelta(-15)
		for i, v in ipairs(ents) do
			local name = greygemTime[v.prefab]
			if name ~= nil then
				local loot = SpawnPrefab(name)
				local sum = v.components.stackable ~= nil and v.components.stackable.stacksize or 1
				if loot.components.stackable ~= nil then
					local smax = loot.components.stackable.maxsize
					local curr = sum - smax
					loot.components.stackable:SetStackSize(curr > 0 and smax or sum)
					while (curr > 0) do
						local loot1 = SpawnPrefab(name)
						if curr > smax then
							loot1.components.stackable:SetStackSize(smax)
						else
							loot1.components.stackable:SetStackSize(curr)
						end
						loot1.Transform:SetPosition(v.Transform:GetWorldPosition())
						curr = curr - smax
					end
				elseif sum > 1 then
					for ii = 2, sum do
						SpawnPrefab(name).Transform:SetPosition(v.Transform:GetWorldPosition())
					end
				end
				loot.Transform:SetPosition(v.Transform:GetWorldPosition())
				v:Remove()
			end
		end
		SpawnPrefab("halloween_moonpuff").Transform:SetPosition(x, y, z)
	
end, log = function(inst, caster, target, pos)
    local x, y, z = pos:Get()
    local items = {}
    local containers = {}
    for i, v in ipairs(TheSim:FindEntities(x, y, z, 30, nil, inst.CONSTANT_TAG)) do
        if v.components.container ~= nil then
            table.insert(containers, v)
        elseif v.components.inventoryitem ~= nil then
            if items[v.prefab] == nil then
                items[v.prefab] = {}
            end
            table.insert(items[v.prefab], v)
        end
    end
    for i, c in ipairs(containers) do
        local num = c.components.container:NumItems()
        for k, v in pairs(c.components.container.slots) do
            if items[v.prefab] ~= nil then
                for i1, item in pairs(items[v.prefab]) do
                    if v.components.stackable ~= nil and not v.components.stackable:IsFull() and v.components.stackable:Put(item) == nil then
                        items[v.prefab][i1] = nil
                    elseif num < c.components.container.numslots then
                        c.components.container:GiveItem(item)
                        items[v.prefab][i1] = nil
                        num = num + 1
                    end
                end
            end
        end
    end
end, bluegem = function(inst, caster, target, pos)
		local x, y, z = pos:Get()
		if not TheWorld.Map:IsOceanTileAtPoint(x, y, z) and TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
			for i, v in ipairs(TheSim:FindEntities(x, y, z, 20, { "fishable" })) do
				if v.components.fishable ~= nil and v.components.fishable:GetFishPercent() > 0 then
					local fish = v.components.fishable:HookFish(caster)
					if fish ~= nil then
						caster:PushEvent("fishingstrain")
						local caughtfish = v.components.fishable:RemoveFish(fish)
						if caughtfish then
							if caughtfish.Physics ~= nil then
								caughtfish.Physics:SetActive(true)
								caughtfish.Physics:Teleport(caster.Transform:GetWorldPosition())
							else
								caughtfish.Transform:SetPosition(caster.Transform:GetWorldPosition())
							end
							caster:PushEvent("fishingcatch", { build = caughtfish.build })
							caughtfish.entity:Show()
							if caughtfish.DynamicShadow ~= nil then
								caughtfish.DynamicShadow:Enable(true)
							end
							caughtfish.persists = true
							caster:PushEvent("fishingcollect", { fish = caughtfish })
						end
					end
				end
			end
		else
			for _, v in ipairs(TheSim:FindEntities(x, y, z, TUNING.TRIDENT.SPELL.RADIUS, nil, {"INLIMBO", "outofreach", "DECOR"})) do
				if v:IsOnOcean(false) then
					if v.components.oceanfishable ~= nil then
						if v.components.weighable ~= nil then
							v.components.weighable:SetPlayerAsOwner(caster)
						end
						local projectile = v.components.oceanfishable:MakeProjectile()
						local ae_cp = projectile.components.complexprojectile
						if ae_cp then
							ae_cp:SetHorizontalSpeed(16)
							ae_cp:SetGravity(-30)
							ae_cp:SetLaunchOffset(Vector3(0, 0.5, 0))
							ae_cp:SetTargetOffset(Vector3(0, 0.5, 0))
							ae_cp:Launch(caster:GetPosition(), projectile)
						else
							launch_away(projectile, pos)
						end
					elseif v.components.inventoryitem ~= nil then
						launch_away(v, pos)
						v.components.inventoryitem:SetLanded(false, true)
					elseif v.waveactive then
						v:DoSplash()
					end
				end
			end
			local angle = GetRandomWithVariance(-45, 20)
			local FX_RADIUS = TUNING.TRIDENT.SPELL.RADIUS * 0.65
			for _ = 1, 4 do
				angle = angle + 90
				local ox = x + FX_RADIUS * math.cos(angle * DEGREES)
				local oz = z - FX_RADIUS * math.sin(angle * DEGREES)
				if TheWorld.Map:IsOceanTileAtPoint(ox, y, oz) and not TheWorld.Map:IsVisualGroundAtPoint(ox, y, oz) then
					SpawnPrefab("crab_king_waterspout").Transform:SetPosition(ox, y, oz)
				end
			end
		end

end, cutgrass = function(inst, caster, target, pos)
    if target ~= nil and target.components.stewer ~= nil then
        local x, y, z = pos:Get()
        for i, v in ipairs(TheSim:FindEntities(x, y, z, 20, { "stewer" }, inst.CONSTANT_TAG)) do
            if v.prefab == target.prefab and not v:HasTag("burnt") and v.components.container ~= nil and v.components.container.canbeopened then
                for n = 2, 5 do
                    local item = inst.components.container:GetItemInSlot(n)
                    if item ~= nil and cooking.IsCookingIngredient(item.prefab) then
                        v.components.container:GiveItem(inst.components.container:RemoveItem(item))
                    end
                end
                if v.components.container:IsFull() then
                    BufferedAction(caster, v, ACTIONS.COOK):Do()
                end
            end
        end
    end
end, goldnugget = function(inst, caster, target, pos)
    if target ~= nil and target.components.workable ~= nil then
		local WorkAction = target.components.workable:GetWorkAction()
        local x, y, z = target.Transform:GetWorldPosition()
        for k, v in ipairs(TheSim:FindEntities(x, y, z, 10, { WorkAction.id .. "_workable" }, inst.CONSTANT_TAG)) do
            if v.prefab == target.prefab and v.components.workable ~= nil and v.components.workable:GetWorkAction() and v.components.workable:CanBeWorked() then
                v.components.workable:Destroy(caster)
            end
        end
	else
		local x, y, z = pos:Get()
        TheWorld.components.farming_manager:AddSoilMoistureAtPoint(x, 0, z, TUNING.PREMIUMWATERINGCAN_USES)
		for i, v in ipairs(TheSim:FindEntities(x, y, z, 4, nil, { "FX", "DECOR", "INLIMBO", "burnt","player"})) do
			if v.components.burnable ~= nil then
				if v.components.witherable ~= nil then
					v.components.witherable:Protect(TUNING.WATERINGCAN_PROTECTION_TIME)
				end
				if v.components.burnable:IsBurning() or v.components.burnable:IsSmoldering() then
					v.components.burnable:Extinguish(true, TUNING.WATERINGCAN_EXTINGUISH_HEAT_PERCENT)
				end
			end
			if v.components.temperature ~= nil then
				v.components.temperature:SetTemperature(v.components.temperature:GetCurrent() - TUNING.WATERINGCAN_TEMP_REDUCTION)
			end
			if v.components.moisture ~= nil then
				local waterproofness = v.components.inventory and math.min(v.components.inventory:GetWaterproofness(),1) or 0
				v.components.moisture:DoDelta(TUNING.WATERINGCAN_WATER_AMOUNT * (1 - waterproofness))
			end
		end
    end
end,nightmarefuel = function(inst, caster, target, pos)
	local item = inst.components.container:GetItemInSlot(1)
	local item4 = inst.components.container:GetItemInSlot(4)
	local item5 = inst.components.container:GetItemInSlot(5)
	if item ~= nil and item4 ~= nil and item5 ~= nil and item4.prefab == "moon_cap" and item5.prefab == "tz_spiritualism" then
		local obj = inst.components.container:RemoveItem(item) or nil
		if obj ~= nil then
			local x, y, z = pos:Get()
			for k, v in ipairs(TheSim:FindEntities(x, y, z, 5, nil, inst.CONSTANT_TAG)) do
				local recipe = AllRecipes[v.prefab]
				if recipe ~= nil and recipe.ingredients ~= nil then
					for i, v in pairs(recipe.ingredients) do
						for i = 1,v.amount do
							local sp = SpawnPrefab(v.type)
							if sp ~= nil then
								sp.Transform:SetPosition(x, y, z)
							end
						end
					end
					-- v:Remove()
				end
			end
			obj:Remove()
		end
	end
end,purplegem = function(inst, caster, target, pos)
	local x, y, z = pos:Get()
	for k, v in ipairs(TheSim:FindEntities(x, y, z, 5)) do
		if v.components.finiteuses ~= nil then 
			v.components.finiteuses:Use(math.ceil(v.components.finiteuses.total*0.2))
		elseif v.components.armor ~= nil then 
			v.components.armor:SetCondition(math.ceil(v.components.armor.condition-v.components.armor.maxcondition*0.2)) 
		elseif v.components.fueled ~= nil then 
			v.components.fueled:DoDelta(math.ceil(-0.2*v.components.fueled.maxfuel), caster)
		end
	end
end,opalpreciousgem = function(inst, caster, target, pos)
	caster.components.hunger:DoDelta(-15)
	local x, y, z = pos:Get()
	for k, v in ipairs(TheSim:FindEntities(x, y, z, 5)) do
		if v.components.finiteuses ~= nil then 
			v.components.finiteuses:Use(math.floor(-0.2*v.components.finiteuses.total))
		elseif v.components.armor ~= nil then 
			v.components.armor.condition = math.floor(v.components.armor.condition+v.components.armor.maxcondition*0.2)
		elseif v.components.fueled ~= nil then 
			v.components.fueled.currentfuel = v.components.fueled.currentfuel+ math.floor(0.2*v.components.fueled.maxfuel)
		end
	end
end}

local function tryspell(inst, target, pos)
	local caster = inst.components.inventoryitem.owner
	if caster == nil then
		return
	end
	if pos == nil then
		pos = target:GetPosition()
	end
	local item = inst.components.container:GetItemInSlot(1)
	if item ~= nil then
		if magic[item.prefab] ~= nil then
			magic[item.prefab](inst, caster, target, pos)
		else
			local curruse = nil
			if item.components.finiteuses ~= nil then
				curruse = item.components.finiteuses:GetPercent()
				item.components.finiteuses.current = item.components.finiteuses.current + 1
			end
			local oldOwner = nil
			if item.components.inventoryitem ~= nil then
				oldOwner = item.components.inventoryitem.owner
				item.components.inventoryitem.owner = caster
			end
			local staff = item.components.spellcaster
			if staff ~= nil and staff.spell ~= nil then
				if staff:CanCast(caster, target, pos) then
					staff:CastSpell(target, pos)
				elseif (staff.canuseonpoint or staff.canuseonpoint_water) and pos ~= nil then
					staff.spell(item, target, pos)
					if staff.onspellcast ~= nil then
						staff.onspellcast(item, target, pos)
					end
				elseif staff.canuseontargets and target ~= nil then
					staff.spell(item, target, pos)
					if staff.onspellcast ~= nil then
						staff.onspellcast(item, target, pos)
					end
				end
			elseif item.components.pocketwatch then
				if item.components.rechargeable ~= nil then
					item.components.rechargeable:Discharge(9)
					if item.components.writeable ~= nil and not item.components.writeable:IsWritten() then
						item.components.writeable:BeginWriting(caster)
					end
				end
			elseif item.components.aoespell and pos ~= nil then
				item.components.aoespell:CastSpell(caster, pos)
			elseif item.components.instrument then
				item.components.instrument:Play(caster)
			elseif item.components.book then
				item.components.book:OnRead(caster)
			elseif item.components.blinkstaff ~= nil then
				if not item.components.blinkstaff:Blink(pos, caster) then
					if caster.Physics ~= nil then
						caster.Physics:Teleport(pos:Get())
					else
						caster.Transform:SetPosition(pos:Get())
					end
				end
			elseif item.components.farmtiller ~= nil then
				local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(pos.x, 0, pos.z)
				item.components.farmtiller:Till(Vector3(tile_x, tile_y, tile_z), caster)
				for i = 0, 3 do
					local tx = 1.3 * math.cos(math.rad(i * 90)) + tile_x
					local tz = -1.3 * math.sin(math.rad(i * 90)) + tile_z
					if TheWorld.Map:CanTillSoilAtPoint(tx, 0, tz, false) then
						TheWorld.Map:CollapseSoilAtPoint(tx, 0, tz)
						SpawnPrefab("farm_soil").Transform:SetPosition(tx, 0, tz)
					end
				end
				for i = 0, 3 do
					local tx = 1.9 * math.cos(math.rad(i * 90 + 45)) + tile_x
					local tz = -1.9 * math.sin(math.rad(i * 90 + 45)) + tile_z
					if TheWorld.Map:CanTillSoilAtPoint(tx, 0, tz, false) then
						TheWorld.Map:CollapseSoilAtPoint(tx, 0, tz)
						SpawnPrefab("farm_soil").Transform:SetPosition(tx, 0, tz)
					end
				end
			elseif item.components.quagmire_tiller ~= nil then
				item.components.quagmire_tiller:Till(pos, caster)
			elseif item.components.fertilizer ~= nil then
				local x, y, z = pos:Get()
				for i, v in ipairs(TheSim:FindEntities(x, y, z, 10, { "witherable" }, { "fire", "smolder", "INLIMBO", "NOCLICK", "FX" })) do
					if (v:HasTag("notreadyforharvest") and not v:HasTag("withered")) or v:HasTag("fertile") or v:HasTag("infertile") or v:HasTag("barren") or v:HasTag("fertilizable") then
						local applied = false
						if v.components.crop ~= nil and not (v.components.crop:IsReadyForHarvest() or v:HasTag("withered")) then
							applied = v.components.crop:Fertilize(item, caster)
						elseif v.components.grower ~= nil and v.components.grower:IsEmpty() then
							applied = v.components.grower:Fertilize(item, caster)
						elseif v.components.pickable ~= nil and v.components.pickable:CanBeFertilized() then
							applied = v.components.pickable:Fertilize(item, caster)
							TheWorld:PushEvent("CHEVO_fertilized", { target = v, doer = caster })
						elseif v.components.quagmire_fertilizable ~= nil then
							applied = v.components.quagmire_fertilizable:Fertilize(item, caster)
						end
						if applied then
							item.components.fertilizer:OnApplied(caster, v)
							if not item:IsValid() then
								break ;
							end
						end
					end
				end
			elseif item.components.deployable ~= nil then
				local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(pos.x, 0, pos.z)
				local x, y, z = caster.Transform:GetWorldPosition()
				local rotation = -math.atan2(pos.z - z, pos.x - x) / DEGREES
				local n = 1
				if item.components.stackable ~= nil then
					n = item.components.stackable:StackSize()
					if n > 9 then n = 9;end
				end
				deploy(inst, item, Vector3(tile_x, 0, tile_z), caster, rotation)
				n = n - 1
				if n > 0 then
					for i = 1, n do
						if i < 5 then
							local tx = 1.3 * math.cos(math.rad(i * 90)) + tile_x
							local tz = -1.3 * math.sin(math.rad(i * 90)) + tile_z
							deploy(inst, item, Vector3(tx, 0, tz), caster, rotation)
						else
							local tx = 1.8384 * math.cos(math.rad(i * 90 + 45)) + tile_x
							local tz = -1.8384 * math.sin(math.rad(i * 90 + 45)) + tile_z
							deploy(inst, item, Vector3(tx, 0, tz), caster, rotation)
						end
					end
				end
			end
			if item.components.inventoryitem ~= nil then
				item.components.inventoryitem.owner = oldOwner
			end
			if item:IsValid() then
				if curruse ~= nil then
					item.components.finiteuses:SetPercent(curruse)
				end
			else
				inst.components.container:DropItemBySlot(1)
			end
		end
	else
		if target ~= nil then
			local x, y, z = target.Transform:GetWorldPosition()
			if target.components.inventoryitem ~= nil then
				trypicking(x, y, z, target.prefab, caster)
			else
				for k, v in ipairs(TheSim:FindEntities(x, y, z, 20, nil, { "INLIMBO", "NOCLICK", "FX" })) do
					if v.prefab == target.prefab then
						if v.components.pickable ~= nil then
							if v.components.pickable:CanBePicked() then
								v.components.pickable:Pick(caster)
							end
						elseif v.components.crop ~= nil then
							v.components.crop:Harvest(caster)
						elseif v.components.harvestable ~= nil then
							if v.components.harvestable:CanBeHarvested() then
								v.components.harvestable:Harvest(caster)
							end
						elseif v.components.stewer ~= nil then
							v.components.stewer:Harvest(caster)
						elseif v.components.dryer ~= nil then
							v.components.dryer:Harvest(caster)
						elseif v.components.occupiable ~= nil and v.components.occupiable:IsOccupied() then
							local item1 = v.components.occupiable:Harvest(caster)
							if item1 ~= nil then
								caster.components.inventory:GiveItem(item1)
							end
						elseif v.components.quagmire_tappable ~= nil then
							v.components.quagmire_tappable:Harvest(caster)
						end
					end
				end
			end
		else
			local x, y, z = pos:Get()
			trypicking(x, y, z, nil, caster)
		end
	end

end

local function dropItemWeapon(inst)
    local item = inst.components.container:RemoveItem(inst.weapon)
    if item then
        local pos = Vector3(inst.Transform:GetWorldPosition())
        item.Transform:SetPosition(pos:Get())
        if item.components.inventoryitem then
            item.components.inventoryitem:OnDropped(true)
        end
        item.prevcontainer = nil
        item.prevslot = nil
		return item
    end
end

local function night(inst, isnight)
	if isnight then
		if inst._fxaa == nil then
			inst._fxaa = SpawnPrefab("nightstickfire") --minerhatlight
			inst._fxaa.Light:SetRadius(8)
			inst._fxaa.entity:SetParent(inst.entity)
			inst._fxaa.Transform:SetPosition(0, 0, 0)
		end
	elseif inst._fxaa ~= nil then
		inst._fxaa:Remove()
		inst._fxaa = nil
	end
end

return TzEntity.CreateNormalWeapon({
    assets = assets,
    prefabname = "tz_fhym",
    tags = {"tz_fhym","tz_fanhao"},
    bank = "tz_fhym",
    build = "tz_fhym",
    anim = "idle",

    weapon_data = {
        -- However,the damage delt by this weapon is pierce damage
        -- So do this in another way....
        damage = 0,
        ranges = 14,
    },
    
    clientfn = function(inst)
        TzFh.AddFhLevel(inst,true)
        TzFh.AddOwnerName(inst)
		inst:AddTag("allow_action_on_impassable")
    end,
    serverfn = function(inst)
        -- This is Tz-Fh Common
        --TzFh.AddOwnerName(inst)
        TzFh.MakeWhiteList(inst)
        TzFh.AddFueledComponent(inst)
        TzFh.SetReturnSpiritualism(inst)

        -- shadow ball
        TzFh.AddLibrarySkill(inst,{name = "shadow_ball"})
		
		inst.dohealth = false
		inst.yyxkWorld = TheWorld
		inst.onoff = function(inst,doer)
			inst.dohealth = not inst.dohealth
			if doer ~= nil and doer.components.talker ~= nil then
				doer.components.talker:Say(inst.dohealth and "开启" or "关闭") 
			end
		end
		
		inst.components.equippable.walkspeedmult = 1.25
		
		inst:AddComponent("container")
		inst.components.container:WidgetSetup("tz_fhym")
		inst.components.container.skipclosesnd = true
		inst.components.container.skipopensnd = true
		inst:ListenForEvent("itemget", itemget)
		inst:ListenForEvent("itemlose", itemlose)
		
		inst.CONSTANT_TAG = {"fire", "smolder","FX", "INLIMBO", "NOCLICK" }
		inst:AddComponent("spellcaster")
		inst.components.spellcaster:SetSpellFn(tryspell)
		inst.components.spellcaster.veryquickcast = true
		-- inst.components.spellcaster.quickcast = true
		inst.components.spellcaster.canuseontargets = true 
		inst.components.spellcaster.canuseonpoint = true
		inst.components.spellcaster.canuseonpoint_water = true 
		inst.components.spellcaster.CanCast = function(doer, target, pos)return true end
		
        -- -- tz_enchanter ATK 42,like shadow_ball
        -- Modified base ATK to 50,because the owner ask for it
        -- 力量源泉Lv2 +50 ATK
        inst.pierce_attack = 50 + 50
        inst.components.weapon:SetOnAttack(function(inst,attacker,target)
            if target.components.health and not target.components.health:IsDead() then
				if inst.weapon ~= nil and inst.weapon:IsValid() then
					if inst.weapon.components.weapon ~= nil then
						if inst.weapon.components.projectile ~= nil then
							local projectile = dropItemWeapon(inst)
							if projectile ~= nil then
								projectile.components.projectile:Throw(attacker, target)
							end

						elseif inst.weapon.components.complexprojectile ~= nil then
							local projectile = dropItemWeapon(inst)
							if projectile ~= nil then
								projectile.components.complexprojectile:Launch(target:GetPosition(), attacker)
							end

						elseif inst.weapon.components.weapon.onattack ~= nil then
							inst.weapon.components.weapon.onattack(inst.weapon, attacker, target)
						end
					end
				end
			
				local health = target.components.health
				local val = health.currenthealth - 0.01*health.maxhealth - 200
				if val <= 0 then
					if inst.dohealth and health.currenthealth > 0 then
						health.currenthealth = val
						TheWorld:PushEvent("entity_death", { inst = target, cause = attacker.prefab, afflicter = attacker })
						target:PushEvent("death", { cause = attacker.prefab, afflicter = attacker })
						if target:HasTag("player") then
							NotifyPlayerProgress("TotalPlayersKilled", 1, attacker);
						else
							NotifyPlayerProgress("TotalEnemiesKilled", 1, attacker);
						end
						if not health.nofadeout then
							target:AddTag("NOCLICK")
							target.persists = false
							target:DoTaskInTime(health.destroytime or 2, ErodeAway)
						end
					end
				else
					health.currenthealth = val
				end
		
			
                local base_damage = inst.pierce_attack 
                    * (attacker.components.combat.damagemultiplier or 1)
                    * attacker.components.combat.externaldamagemultipliers:Get()
                
                local stimuli_multi,stimuli = GetStimuliMultOn(inst,attacker,target)
                local truely_damage = base_damage * stimuli_multi
                
                -- 第一个形态雷罚（每次攻击造成1%的最大生命伤害）
                if inst.form_status == 1 then
                    truely_damage = truely_damage + target.components.health.maxhealth * 0.01
                end

                
                -- target.components.health:DoDelta(-truely_damage,nil,attacker.prefab,false,nil,true)
                -- target:PushEvent("attacked", { attacker = attacker, damage = truely_damage, weapon = inst })
                DoPiercingDamage(attacker,target,truely_damage,inst,stimuli)

                -- 第二个形态冰霜（AOE和冰冻效果）
                if inst.form_status == 2 then
                    if target.components.freezable ~= nil then
                        target.components.freezable:AddColdness(1)
                        target.components.freezable:SpawnShatterFX()
                    end

                    local radius = 3 
                    local x,y,z = target:GetPosition():Get()
                    local ents = TheSim:FindEntities(x,y,z,radius,{"_combat","_health"},{"INLIMBO"})
                    for k,v in pairs(ents) do
                        if v ~= target 
                            and attacker.components.combat:CanTarget(v) 
                            and not attacker.components.combat:IsAlly(v) then
                            
                            local stimuli_multi,stimuli = GetStimuliMultOn(inst,attacker,v)
                            local do_damage = base_damage * stimuli_multi
                            -- v.components.health:DoDelta(-do_damage,nil,attacker.prefab,false,nil,true)
                            -- v:PushEvent("attacked", { attacker = attacker, damage = do_damage, weapon = inst })
                            DoPiercingDamage(attacker,target,do_damage,inst,stimuli)

                            
                            if v.components.freezable ~= nil then
                                v.components.freezable:AddColdness(1)
                                v.components.freezable:SpawnShatterFX()
                            end
                        end
                        
                    end
                end
            end
        end)

        inst.form_status = 0

        inst.TryTrigerSkill = function(inst,owner)
            inst.form_status = inst.form_status + 1
            if inst.form_status >= 4 then
                inst.form_status = 0
            end

            UpdateLight(inst)

            -- if inst.form_status == 3 then
                -- inst.components.equippable.walkspeedmult = 1.25 
            -- else 
                -- inst.components.equippable.walkspeedmult = 1 
            -- end

            if owner and owner.components.talker then
                if inst.form_status == 0 then
                    owner.components.talker:Say("目前无形态")
                else 
                    owner.components.talker:Say("切换到"..form_desc[inst.form_status])
                end
                
            end
        end
		
		inst:WatchWorldState("isnight", night)
		night(inst, TheWorld.state.isnight)

        inst:ListenForEvent("equipped",OnEquip)
        inst:ListenForEvent("unequipped",OnUnEquip)
        
    end,
})