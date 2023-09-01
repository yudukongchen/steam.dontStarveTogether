GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

local function BuildItem(inst)
	--print("制造")
    if inst:HasTag("krm_bullent_buff10") then  --ThePlayer:AddTag("krm_bullent_buff10")
    	inst.krm_bullet_buff_task10 = inst:DoTaskInTime(0, function(inst)
            inst:RemoveTag("krm_bullent_buff10")
            inst.components.builder:GiveAllRecipes()
            inst.components.builder:GiveAllRecipes()

            if inst.krm_bullet_buff_task10 then
                inst.krm_bullet_buff_task10:Cancel()
                inst.krm_bullet_buff_task10 = nil
            end            
        end)
    end	 
end

AddPlayerPostInit(function(inst)
    inst.AnimState:AddOverrideBuild("daofeng_actions_pistol")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("krm_bullet_buff")

    inst:ListenForEvent("builditem", BuildItem)
    inst:ListenForEvent("buildstructure", BuildItem)
    --inst:ListenForEvent("makerecipe", BuildItem)      
end)

AddPrefabPostInit("minotaurhorn", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if inst.components.tradable == nil then  
        inst:AddComponent("tradable")
    end  
end) 

AddPrefabPostInit("houndstooth", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if inst.components.tradable == nil then 
        inst:AddComponent("tradable")
    end  
end) 

local MUST_TAG = {"krm_zafkiel"}
local CANT_TAGS = { "INLIMBO" }
local function OnTeach(inst)
    local armor = FindEntity(inst, 20, nil, MUST_TAG, CANT_TAGS)
    if armor and armor:IsValid() then
        local dress = SpawnPrefab("krm_armor")
        dress.Transform:SetPosition(armor.Transform:GetWorldPosition()) 

        local fx = SpawnPrefab("abigail_retaliation")
        fx.persists = false
        fx.Transform:SetPosition(armor:GetPosition():Get())

        armor:Remove()
    end    
end

AddPrefabPostInit("archive_lockbox", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("onteach", OnTeach)
end) 


AddComponentPostInit("combat", function(self)
    local OldGetAttacked = self.GetAttacked
    function self:GetAttacked(attacker, damage, weapon, stimuli, ...)
        if self.inst.krm_bullet_buff_task5 or self.inst.krm_bullrt5_fx then
            damage = 0

            local fx = SpawnPrefab("shadow_shield"..math.random(1, 4))
            fx.entity:SetParent(self.inst.entity)
        end  
     
        return OldGetAttacked(self, attacker, damage, weapon, stimuli, ...)
    end    
end)


local TechTree = require("techtree")

AddComponentPostInit("builder", function(self)
    local OldKnowsRecipe = self.KnowsRecipe
    function self:KnowsRecipe(recipe, ignore_tempbonus, ...)
        if type(recipe) == "string" then
		    recipe = GetValidRecipe(recipe)
	    end
     
        if recipe and self.inst:HasTag("krm_bullent_buff10") then
            return true
        end	

        return OldKnowsRecipe(self, recipe, ignore_tempbonus, ...)
    end

    local OldAddRecipe = self.AddRecipe
    function self:AddRecipe(recname, ...)
        if self.inst:HasTag("krm_bullent_buff10") then
            return 
        end	

        return OldAddRecipe(self, recname, ...)
    end 
--[[
    local OldUnlockRecipe = self.UnlockRecipe
    function self:KnowsRecipe(recname, ...)
        if self.inst:HasTag("krm_bullent_buff10") then
            return 
        end	

        return OldUnlockRecipe(self, recname, ...)
    end
]]                 
end)


local function HookComponent(name, fn)
    fn(require ("components/"..name))
end

HookComponent("builder_replica", function(Builder)
    local Old_KnowsRecipe = Builder.KnowsRecipe
    Builder.KnowsRecipe = function(self, recipe, ignore_tempbonus, ...)
        if type(recipe) == "string" then
		    recipe = GetValidRecipe(recipe)
	    end
        if recipe and self.inst:HasTag("krm_bullent_buff10") then
            return true
        end

        return Old_KnowsRecipe(self, recipe, ignore_tempbonus, ...)
    end
end)
--[[
ACTIONS.CAST_POCKETWATCH.fn = function(act)
    local caster = act.doer
    print("施法")
    if act.invobject ~= nil and caster ~= nil and caster:HasTag("pocketwatchcaster") then
		act.invobject.components.pocketwatch:CastSpell(caster, act.target, act:GetActionPoint())
	end

	return true
end
]]
local function Yurri_Change(inst)
    if inst.components.inventory:EquipHasTag("krm_gun") then 
        local hand = inst ~= nil and inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
        if hand and hand.prefab == "krm_gun" then
            hand:Change(inst)
        end

		
    end
end
local function Yurri_shanchu(inst,target)
    if inst.components.inventory:EquipHasTag("krm_broom") then 
        local hand = inst ~= nil and inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
        if hand and hand.prefab == "krm_broom" then
			if target and target:IsValid() and target:HasTag("yanpin") then
			target:Remove()
			end
        end
    end
end
AddModRPCHandler("Yurri_Change", "Yurri_Change", Yurri_Change)
AddModRPCHandler("Yurri_Change", "shanchufuzhi", Yurri_shanchu)
local KEY1 = _G["KEY_"..GetModConfigData("KEY_Z")]
local KEY2 = _G["KEY_"..GetModConfigData("KEY_Z_NEW")]

TheInput:AddKeyDownHandler(KEY1, function()
if ThePlayer and ThePlayer:HasTag("kurumi")  then       ----没必要让不是狂三的玩家执行不必要的代码      
    local player = ThePlayer
    local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
    local IsHUDActive = screen and screen.name == "HUD"
 
    if player and player:HasTag("kurumi") and not player:HasTag("playerghost") and IsHUDActive then
	
		local target = TheInput:GetHUDEntityUnderMouse()											----获取鼠标指向物品栏
		if target ~= nil then
			target = target.widget ~= nil and target.widget.parent ~= nil and target.widget.parent.item
		else
			target = TheInput:GetWorldEntityUnderMouse()											----获取鼠标指向地面
		end
		
        SendModRPCToServer(MOD_RPC["Yurri_Change"]["Yurri_Change"]) 
		if target then  SendModRPCToServer(MOD_RPC["Yurri_Change"]["shanchufuzhi"],target) end
    end

end
end)

local function GetTagEquip(self,tag)
    for k, v in pairs(self.equipslots) do
        if v:HasTag(tag) then
            return v
        end
    end
end
local function IsHUDScreen()
	local s = TheFrontEnd:GetActiveScreen()
	if s then
		if s:IsEditing() then
			return false
		elseif type(s.name)  == "string" and s.name == "HUD" then
			return true
		end
	end
	return false
end
AddModRPCHandler("Yurri_Change","knife",function(inst)
    if inst:HasTag("playerghost") or inst.replica.health:IsDead() then
        return
    end
    local hat = inst.components.inventory and GetTagEquip(inst.components.inventory,"krm_knife") or nil 
    if hat and hat.Use_Skill then
        hat:Use_Skill(inst)
    end
end)
TheInput:AddKeyDownHandler(KEY2, function()
    if ThePlayer and ThePlayer:HasTag("kurumi")  then       ----没必要让不是狂三的玩家执行不必要的代码    
        if IsHUDScreen() then
            SendModRPCToServer(MOD_RPC["Yurri_Change"]["knife"])  
        end
    end
end)



--[[
local Old_BuildFn = ACTIONS.BUILD.fn
ACTIONS.BUILD.fn = function(act)
    if act.doer then
        BuildItem(act.doer)
    end	
    return Old_BuildFn(act)             
end
]]

AddShardModRPCHandler( "krm_shard_spirit", "krm_shard_spirit", function(inst,value)
    if TheWorld and TheWorld.components.krm_spirit_limit then
        TheWorld.components.krm_spirit_limit:SetNoDrop()
    end
end)
AddPrefabPostInit("world",function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("krm_spirit_limit") 
end)
local drop_boss = {
    klaus = 0.10,    ----10%
    krampus = 0.01, ----1%
}
for k,v in pairs(drop_boss) do
    AddPrefabPostInit(k,function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        inst:ListenForEvent("death",function()
            if math.random() < v then
                TheWorld:PushEvent("krm_spirit_drop",{inst= inst})
            end
        end)
    end)
end