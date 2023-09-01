local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fh_hf.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_hf.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_hf.xml"),
}

local prefabs = {}

--未闻花名 来自小穹mod
local function trygrowth(inst,doer)
    if inst:IsInLimbo()
         then
        return
    end

    if inst.components.pickable ~= nil then
        if inst:HasTag("sunflower") and TUNING.SUNFLOWER_REGROW_TIME then
            inst.time = GetTime() - TUNING.SUNFLOWER_REGROW_TIME
        end
        if inst.components.pickable:CanBePicked() and inst.components.pickable.caninteractwith then
            return
        end
        inst.components.pickable:FinishGrowing()
    end

    if inst.components.crop ~= nil then
        inst.components.crop:DoGrow(TUNING.TOTAL_DAY_TIME * 6, true)
    end
	if inst.components.timer ~= nil and inst.components.timer:TimerExists("grow") then
        inst.components.timer:StopTimer("grow")
        inst:PushEvent("timerdone", { name = "grow" })
    end
    if inst.components.timer ~= nil and inst.components.timer:TimerExists("growth") then
        inst.components.timer:StopTimer("growth")
        inst:PushEvent("timerdone", { name = "growth" })
    end
    if inst.components.timer ~= nil and inst.components.timer:TimerExists("growup") then
        inst.components.timer:StopTimer("growup")
        inst:PushEvent("timerdone", { name = "growup" })
    end
    
    if inst.components.worldsettingstimer and inst.components.worldsettingstimer:TimerExists("grow") then
        inst.components.worldsettingstimer:StopTimer("grow")
        inst:PushEvent("timerdone", { name = "grow" })
    end
    if inst.components.worldsettingstimer and inst.components.worldsettingstimer:TimerExists("growth") then
        inst.components.worldsettingstimer:StopTimer("growth")
        inst:PushEvent("timerdone", { name = "growth" })
    end
	if inst.components.crop_legion ~= nil then
        inst.components.crop_legion:DoGrow(TUNING.TOTAL_DAY_TIME * 6, true) --增加3天生长时间
    end
	if inst.components.perennialcrop ~= nil then
        inst.components.perennialcrop:DoMagicGrowth(doer,TUNING.TOTAL_DAY_TIME * 3) --增加3天生长时间
    end
    if inst.components.perennialcrop2 ~= nil then
        inst.components.perennialcrop2:DoMagicGrowth(doer,TUNING.TOTAL_DAY_TIME * 3) --增加3天生长时间
    end
    if inst.components.growable ~= nil and
        (inst:HasTag("tree") or inst:HasTag("peachtree")  or inst:HasTag("plant") or inst:HasTag("winter_tree") or inst:HasTag("boulder")  or inst.components.growable.magicgrowable ) then
		local stage =  inst.components.growable.stage 
		local maxstage = #inst.components.growable.stages
		if inst:HasTag("evergreens") then
		maxstage = maxstage -1
		end
		if stage == maxstage then
		inst.components.growable:Pause()
		elseif stage == maxstage-1 then
		inst.components.growable:DoGrowth()
		inst.components.growable:Pause()
		else
		inst.components.growable:DoGrowth()
		end
    end

    if inst.components.harvestable ~= nil and (inst:HasTag("mushroom_farm") )then --or inst:HasTag("beebox") 不再能催熟蜂箱
        if inst.components.harvestable.task then
			inst.components.harvestable:Grow()
			inst.components.harvestable:Grow()
			inst.components.harvestable:Grow()
			inst.components.harvestable:Grow()
			inst.components.harvestable:Grow()
			inst.components.harvestable:Grow()
		end
    end
end

local function dogrow(inst,maker)
    inst.components.rechargeable:Discharge(20)
    local x, y, z = maker.Transform:GetWorldPosition()
    local range = 60
    local ents = TheSim:FindEntities(x, y, z, range, nil, { "pickable", "stump", "withered", "INLIMBO" })
    if #ents > 0 then
        trygrowth(table.remove(ents, math.random(#ents)),maker)
        if #ents > 0 then
            local timevar = 1 - 1 / (#ents + 1)
            for i, v in ipairs(ents) do
                v:DoTaskInTime(timevar * math.random()/3, trygrowth)
            end
        end
    end
end
local function OnEquip(inst,data)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function OnUnEquip(inst,data)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end
return  
    TzEntity.CreateNormalWeapon({
    assets = assets,
    prefabname = "tz_fh_hf",
    tags = {"rechargeable","tz_fh_hf","tz_fanhao"},
    bank = "tz_fh_hf",
    build = "tz_fh_hf",
    anim = "idle",
    weapon_data = {
        swapanims = {"tz_fh_hf","swap"},
        damage = 50,
        ranges = 1,
    },
    clientfn = function(inst)
        TzFh.AddOwnerName(inst)
        TzFh.AddFhLevel(inst,true)
    end,
    serverfn = function(inst)
        TzFh.AddLibrarySkill(inst,{name = "shadowstep"})
        TzFh.AddLibrarySkill(inst,{name = "anyexingzhe"})
        TzFh.AddLibrarySkill(inst,{name = "alltools",fishingrod = true,tillable = true,supertill = true})
        TzFh.MakeWhiteList(inst)
        TzFh.AddFueledComponent(inst)
        TzFh.SetReturnSpiritualism(inst)

        inst:AddComponent("rechargeable")
        inst.TryTrigerSkill = function(inst,doer)
            if not doer then
                return
            end
            if  not inst.components.rechargeable:IsCharged() then
                if doer.components.talker then
                    doer.components.talker:Say("技能还未冷却完毕！")
                end
                return
            end
            dogrow(inst,doer)
        end
        inst:ListenForEvent("equipped",OnEquip)
        inst:ListenForEvent("unequipped",OnUnEquip)
    end,
})