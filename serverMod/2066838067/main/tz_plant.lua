STRINGS.NAMES.TZ_SEED_BDZX = "冰冻之心"
STRINGS.RECIPE_DESC.TZ_SEED_BDZX = "千年之冰，永冻吾心"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_SEED_BDZX = "“摸起来仿佛自己也要被冻住！”"
STRINGS.NAMES.TZ_PLANT_BDZX = "冰冻之心"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_PLANT_BDZX = "快快长大吧，我的小精灵"
STRINGS.NAMES.TZ_FOLLWERS_AKXY = "阿克茜娅"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_FOLLWERS_AKXY = "冰原风雪中舞蹈的精灵！"

STRINGS.NAMES.TZ_SEED_HHZX = "黄昏之息"
STRINGS.RECIPE_DESC.TZ_SEED_HHZX = "落日之晖，染尽尘世"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_SEED_HHZX = "“绯红色的花种”"
STRINGS.NAMES.TZ_PLANT_HHZX = "黄昏之息"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_PLANT_HHZX = "快快长大吧，我的小精灵"
STRINGS.NAMES.TZ_FOLLWERS_ABL = "吉恩蒂亚"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_PLANT_ABL= "黄昏时的精灵更美丽！"

local  TZ_PLANT_ZHAOHUAN = Action({priority=1,mount_valid = true})
TZ_PLANT_ZHAOHUAN.id = "TZ_PLANT_ZHAOHUAN"
TZ_PLANT_ZHAOHUAN.str = "触摸"
TZ_PLANT_ZHAOHUAN.fn = function(act)
    local targ = act.target or act.invobject
    if targ and  targ.components.tz_plant_use then
        return targ.components.tz_plant_use:Use(act.doer)
    end
end
AddAction(TZ_PLANT_ZHAOHUAN)
AddComponentAction("SCENE", "tz_plant_use" , function(inst, doer, actions, right)
	if right and doer:HasTag("player") then
    	table.insert(actions, ACTIONS.TZ_PLANT_ZHAOHUAN)
	end
end)
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.TZ_PLANT_ZHAOHUAN, "doshortaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.TZ_PLANT_ZHAOHUAN, "doshortaction"))

local  TZ_PLANT_FERTILIZE = Action({priority=1,mount_valid = true})
TZ_PLANT_FERTILIZE.id = "TZ_PLANT_FERTILIZE"
TZ_PLANT_FERTILIZE.str = "施肥"
TZ_PLANT_FERTILIZE.fn = function(act)
    local targ = act.target
    if act.invobject and  targ and  targ.components.tz_plant_grower then
        targ.components.tz_plant_grower:Fertilize(act.invobject,act.doer,true)
        return true
    end
end
AddAction(TZ_PLANT_FERTILIZE)
AddComponentAction("USEITEM", "tz_plant_fertilizer" , function(inst, doer, target, actions)
	if target and target:HasTag("tz_plant_fertilized") then
    	table.insert(actions, ACTIONS.TZ_PLANT_FERTILIZE)
	end
end)
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.TZ_PLANT_FERTILIZE, "dolongaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.TZ_PLANT_FERTILIZE, "dolongaction"))

AddComponentAction("EQUIPPED", "wateryprotection" , function(inst, doer, target, actions, right)
    if right and target:HasTag("tz_plant_fertilized") then
        table.insert(actions, ACTIONS.POUR_WATER)
    end
end)
local old_fn = ACTIONS.POUR_WATER.fn
ACTIONS.POUR_WATER.fn = function(act)
    if act.target ~= nil and act.target:IsValid() and act.target.components.tz_plant_grower then
        if act.invobject ~= nil and act.invobject:IsValid() then
            if act.invobject.components.finiteuses ~= nil and act.invobject.components.finiteuses:GetUses() <= 0 then
			    return false, (act.invobject:HasTag("wateringcan") and "OUT_OF_WATER" or nil)
            end
            act.invobject.components.wateryprotection:SpreadProtection(act.target)
            act.target.components.tz_plant_grower:Fertilize({prefab = "waterwater"},act.doer)
            return true
        end
    end
    return old_fn(act)
end

local fertilizers = {
    "poop","spoiled_food","guano","fertilizer"
}
for i,v in ipairs(fertilizers) do
    AddPrefabPostInit(v,function(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("tz_plant_fertilizer")
    end)
end


local function doneaowu(inst)
    inst.aowu_task = nil
end
local function aowu(inst)
    if inst.components.tzsama and inst.components.sanity then
        if inst.aowu_task then
            return
        end
        inst.components.tzsama:DoDelta(10)
        inst.components.sanity:DoDelta(5)
        inst.aowu_task = inst:DoTaskInTime(480,doneaowu)
    end
end
local myzhiling = {
	["/嗷呜"] = function(inst)
        aowu(inst)
	end,
	["嗷呜"] = function(inst)
        aowu(inst)
	end,
}
local function GetPlayerById(playerid)
	for k,v in ipairs(_G.AllPlayers) do
		if v and v.userid and v.userid == playerid then
			return v
		end
	end
	return nil
end

local Old_Networking_Say = GLOBAL.Networking_Say
GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    if message and myzhiling[message] then
		local player = GetPlayerById(userid)
		if player then
			myzhiling[message](player,message)
		end
	end
	Old_Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
end
