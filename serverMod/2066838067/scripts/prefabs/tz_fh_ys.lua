local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fh_ys.zip"),
    Asset("ANIM", "anim/tz_sh_ys_fx.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_ys.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_ys.xml"),
}

local prefabs = {}

local function SetAbsorption(inst,e)
	if e ~= nil then
		inst.exp = inst.exp + e
		-- local owner = inst.components.inventoryitem.owner
		-- if owner ~= nil then
			-- owner.components.talker:Say("经验值:"..inst.exp)
		-- end
	end
	inst.components.armor:SetAbsorption(math.min(0.4+math.floor(inst.exp/200),0.8))
end

local function OnBlocked(owner,data)
	if data.attacker ~= nil then
		SpawnPrefab("electrichitsparks"):AlignToTarget(data.attacker, owner, true)
	else
		SpawnPrefab("electrichitsparks").Transform:SetPosition(owner.Transform:GetWorldPosition())	
	end
end

local function onstopuse(inst,owner)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
	if inst.fx ~= nil then
		inst.fx:Remove()
		inst.fx = nil
	end
	inst.issk = false
	owner:Show()
	SetAbsorption(inst)
	inst.components.useableitem:StopUsingItem()
end

local function ProtectionLevels(inst, data)
    local equippedArmor = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil
    if equippedArmor ~= nil then
        if inst.sg:HasStateTag("shell") then
            equippedArmor.components.armor:SetAbsorption(TUNING.FULL_ABSORPTION)
			equippedArmor.issk = true
        elseif equippedArmor.issk then
			onstopuse(equippedArmor,inst)
        end
    end
end

local TARGET_MUST_TAGS = { "_combat" }
local TARGET_CANT_TAGS = { "INLIMBO" }
local function droptargets(inst)
    inst.task = nil
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
    if owner ~= nil and owner.sg:HasStateTag("shell") then
		owner:Hide()
		if inst.fx == nil then
			inst.fx = SpawnPrefab("tz_sh_ys_fx")
			inst.fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
		end
        local x, y, z = owner.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 20, TARGET_MUST_TAGS, TARGET_CANT_TAGS)
        for i, v in ipairs(ents) do
            if v.components.combat ~= nil and v.components.combat.target == owner then
                v.components.combat:SetTarget(nil)
            end
        end
    end
end

local function onuse(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil then
        owner.sg:GoToState("shell_enter")
        if inst.task ~= nil then
            inst.task:Cancel()
        end
        inst.task = inst:DoTaskInTime(0.5, droptargets)
    end
end

local function moisturedelta(inst)
	local owner = inst.components.inventoryitem.owner
    if owner ~= nil then
		if owner.components.moisture and owner.components.moisture.moisture>50 and owner.components.health then
			owner.components.health:DoDelta(1)
		end
		if inst.fx ~= nil then
			inst.fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
		end
	end
end

local HORTICULTURE_CANT_TAGS = { "pickable", "stump", "withered", "barren", "INLIMBO"}
local function emote(inst, data)
	if data.item_type == "emote_dance_chicken" then
		local x, y, z = inst.Transform:GetWorldPosition()
		for i, v in ipairs(TheSim:FindEntities(x, y, z, 30, nil, HORTICULTURE_CANT_TAGS)) do
			if v.components.farmplanttendable ~= nil then 
				v.components.farmplanttendable:TendTo(inst)
			end
		end
	end
end

--self.inst:PushEvent("moisturedelta", { old = oldLevel, new = self.moisture })
local function OnEquip(inst,data)
	local owner = data and data.owner or nil
    if owner ~= nil then
		owner.AnimState:OverrideSymbol("swap_body_tall", "tz_fh_ys", "swap_body_tall")
		inst:ListenForEvent("emote", emote, owner)
		inst:ListenForEvent("newstate", ProtectionLevels, owner)
		-- inst:ListenForEvent("blocked", OnBlocked, owner)
		-- inst:ListenForEvent("moisturedelta", moisturedelta, owner)
		if inst.moisturedeltaTask == nil then
			inst.moisturedeltaTask = inst:DoPeriodicTask(1, moisturedelta)
		end
    end
end

local function OnUnEquip(inst,data)
    local owner = data and data.owner or nil
    if owner ~= nil then
		owner.AnimState:ClearOverrideSymbol("swap_body_tall")
		inst:RemoveEventCallback("newstate", ProtectionLevels, owner) 
		inst:RemoveEventCallback("emote", emote, owner) 
		-- inst:RemoveEventCallback("blocked", OnBlocked, owner)
		-- inst:RemoveEventCallback("moisturedelta", moisturedelta, owner) 
		if inst.moisturedeltaTask ~= nil then
			inst.moisturedeltaTask:Cancel()
			inst.moisturedeltaTask = nil
		end
		onstopuse(inst,owner)
    end
	
end

local trade_list = {
"houndstooth",
"stinger",
"spidergland",
"silk",
"flint",
"rocks",
"goldnugget",
"nitre",
"moonrocknugget",
"boneshard",
"thulecite",
"thulecite_pieces",
"gears",
"tz_coin",
}


local function fxfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("tz_sh_ys_fx")
	inst.AnimState:SetBuild("tz_sh_ys_fx")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("NOCLICK")
	inst:AddTag("FX")

	inst.entity:SetPristine()
	inst.persists = false
	if not TheWorld.ismastersim then
		return inst
	end
	
	
	return inst
end

return  Prefab("tz_sh_ys_fx",fxfn),
    TzEntity.CreateNormalArmor({
    assets = assets,
    prefabname = "tz_fh_ys",
    tags = {"tz_fh_ys","tz_fanhao","shell"},
    bank = "tz_fh_ys",
    build = "tz_fh_ys",
    anim = "idle",
    armor_data = {
        swapanims = {"tz_fh_ys","swap_body_tall"},
        equipslot = EQUIPSLOTS.BODY,
    },
    clientfn = function(inst)
        TzFh.AddOwnerName(inst)
        TzFh.AddFhLevel(inst,true)
    end,
    serverfn = function(inst)
        TzFh.MakeWhiteList(inst)
		
		inst.exp = 0
		inst.SetAbsorption = SetAbsorption
        
        inst:AddComponent("container")
        inst.components.container:WidgetSetup("tz_fh_ys")
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true
		inst.components.container.canbeopened = false
		
		inst:AddComponent("useableitem")
		inst.components.useableitem:SetOnUseFn(onuse)
		
		inst:AddComponent("armor")
		inst.components.armor:InitCondition(1260, 0.4)
		inst.components.armor.ontakedamage = function(inst, damage_amount)
			SpawnPrefab("electrichitsparks").Transform:SetPosition(inst.Transform:GetWorldPosition())	
		end
		function inst.components.armor:SetCondition(amount)
			if self.indestructible then
				return
			end
			self.condition = math.min(amount, self.maxcondition)
			if self.condition < 0 then
				self.condition = 1
			end
			self.inst:PushEvent("percentusedchange", { percent = self:GetPercent() })
		end
		
		inst:AddComponent("trader")
		inst.components.trader.acceptnontradable = true
		inst.components.trader:SetAbleToAcceptTest(function(inst, item, giver)
			for k,v in pairs(trade_list) do
				if item.prefab == v then
					return true
				end
			end
			return false
		end)
		inst.components.trader.onaccept = function(inst,giver,item)
			if item.prefab == "tz_coin" then
				local target = inst.components.container:GetItemInSlot(1)
				if target ~= nil then
					if target.components.finiteuses ~= nil then 
						target.components.finiteuses:Repair(target.components.finiteuses.total)
					elseif target.components.armor ~= nil then 
						target.components.armor:Repair(target.components.armor.maxcondition) 
					elseif target.components.fueled ~= nil then 
						target.components.fueled:DoDelta(target.components.fueled.maxfuel, giver)
					end
					inst.components.armor:SetCondition(inst.components.armor.condition-1260/2)
				end
			else
				inst.components.armor:Repair(126)
				SetAbsorption(inst,1)
			end
		end

        inst:ListenForEvent("equipped",OnEquip)
        inst:ListenForEvent("unequipped",OnUnEquip)
		inst:ListenForEvent("onremove", function(inst)
			if inst.fx ~= nil then
				inst.fx:Remove()
			end
		end)
		
		inst.OnSave = function (inst, data)
			data.exp = inst.exp
		end
		inst.OnLoad = function (inst, data)
			if data ~= nil then
				if data.exp ~= nil then 
					inst.exp = data.exp
					SetAbsorption(inst)
				end
			end
		end

    end,
})