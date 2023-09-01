-- In this file: Miscellaneous edits to prefabs, components, widgets, etc.

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local TUNING = GLOBAL.TUNING
local CHARACTER_INGREDIENT = GLOBAL.CHARACTER_INGREDIENT
local CHARACTER_INGREDIENT_SEG = GLOBAL.CHARACTER_INGREDIENT_SEG
local AllRecipes = GLOBAL.AllRecipes
local SpawnPrefab = GLOBAL.SpawnPrefab
local ACTIONS = GLOBAL.ACTIONS
local RemovePhysicsColliders = GLOBAL.RemovePhysicsColliders
local FRAMES = GLOBAL.FRAMES
local ActionHandler = GLOBAL.ActionHandler
local EventHandler = GLOBAL.EventHandler
local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local GetValidRecipe = GLOBAL.GetValidRecipe
local FOODTYPE = GLOBAL.FOODTYPE
local GetGameModeProperty = GLOBAL.GetGameModeProperty
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local PREFAB_SKINS = GLOBAL.PREFAB_SKINS
local PREFAB_SKINS_IDS = GLOBAL.PREFAB_SKINS_IDS
local SKIN_AFFINITY_INFO = GLOBAL.require("skin_affinity_info")
local Vector3 = GLOBAL.Vector3
local Lerp = GLOBAL.Lerp
local DEGREES = GLOBAL.DEGREES

local reskintool_item_tags = {
	stu_chainsaw = 1,
	stu_chainsaw_skin = 2,
    stu_hat = 3,
    stu_hat_skin = 4
}

local reskintool_item_prefab = {	
	"stu_chainsaw_skin",
	"stu_chainsaw",
    "stu_hat_skin",
    "stu_hat"
}

AddPrefabPostInit("reskin_tool", function(inst)
    if not TheWorld.ismastersim then
         return inst
    end

    if inst.components.spellcaster.spell then  

    local can_cast_fn_old = inst.components.spellcaster.can_cast_fn
    inst.components.spellcaster:SetCanCastFn(function(doer, target, pos, ...)
        if target and reskintool_item_tags[target.prefab] then
            return true
        end

        if can_cast_fn_old ~= nil then
            return can_cast_fn_old(doer, target, pos, ...)
        end
    end)

    local spell_old = inst.components.spellcaster.spell
    inst.components.spellcaster:SetSpellFn(function(tool, target, pos, ...)
        if target and reskintool_item_tags[target.prefab] then

            local fx_prefab = "explode_reskin"
            local skin_fx = SKIN_FX_PREFAB[inst:GetSkinName()]
            if skin_fx ~= nil and skin_fx[1] ~= nil then
            fx_prefab = skin_fx[1]
            end

            local fx = SpawnPrefab(fx_prefab)
            local x, y, z = target.Transform:GetWorldPosition()
            if fx then
                fx.Transform:SetPosition(x, 0, z)
            end

            local chain = SpawnPrefab(reskintool_item_prefab[reskintool_item_tags[target.prefab]])
            if chain then

                if target.skill then
                    print("武器")
                    chain.skill = target.skill
                else
                    print("帽子")
                    if target.get_eyeball then
                        chain.get_eyeball = true
                    end

                    if target.level then
                        chain.level = target.level
                    end
                    chain:LoadBuff()                        
                end    
            	chain.Transform:SetPosition(x, 0, z)
                target:Remove()
            end 

            return true
        end

        if spell_old ~= nil then
            return spell_old(tool, target, pos, ...)
        end
    end)
    end
end)


--=================
--[[
local function stubaseenable(self)
    if self.name == "LoadoutSelect" then
        if not table.contains(DST_CHARACTERLIST, "stu") then
            table.insert(DST_CHARACTERLIST, "stu")
        end

    elseif  self.name == "LoadoutRoot" then
        if table.contains(DST_CHARACTERLIST, "stu") then
            RemoveByValue(DST_CHARACTERLIST, "stu")
        end
    end
end

AddClassPostConstruct("widgets/widget", stubaseenable)

local oldTheInventoryCheckOwnership = TheInventory.CheckOwnership
local mt = getmetatable(TheInventory)
    mt.__index.CheckOwnership  = function(i, name, ...) 
    if name and type(name) == "string" and name:find("stu") then
        return true 
        else
        return oldTheInventoryCheckOwnership(i, name, ...)
    end
end

local oldTheInventoryCheckClientOwnership = TheInventory.CheckClientOwnership
    mt.__index.CheckClientOwnership  = function(i,userid,name,...) 
        if name and type(name ) == "string" and name:find("stu") then
        return true 
        else
        return oldTheInventoryCheckClientOwnership(i, userid, name, ...)
    end
end 

local oldExceptionArrays = GLOBAL.ExceptionArrays
    GLOBAL.ExceptionArrays = function(ta,tb,...)
    local need
         for i=1,100,1 do
            local data = debug.getinfo(i, "S")
            if data then
            if data.source and data.source:match("^scripts/networking.lua") then
            need = true
            end
            else
            break
        end
    end

    if need then
        local newt = oldExceptionArrays(ta, tb, ...)
        table.insert(newt, "stu")   
        return newt
    else
        return oldExceptionArrays(ta, tb, ...)
    end
end 
]]

local PREFAB_SKINS = GLOBAL.PREFAB_SKINS
local PREFAB_SKINS_IDS = GLOBAL.PREFAB_SKINS_IDS  
local SKIN_AFFINITY_INFO = GLOBAL.require("skin_affinity_info")

modimport("scripts/util/stu_skin_api.lua")

SKIN_AFFINITY_INFO.stu = { "stu_skin1_none" }

PREFAB_SKINS_IDS = {}
for prefab,skins in pairs(PREFAB_SKINS) do
    PREFAB_SKINS_IDS[prefab] = {}
    for k,v in pairs(skins) do
          PREFAB_SKINS_IDS[prefab][v] = k
    end
end

AddSkinnableCharacter("stu") 
