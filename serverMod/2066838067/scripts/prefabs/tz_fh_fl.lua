local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fh_fl.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_fl.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_fl.xml")
}


local function DoGooseStepFX(inst)
    local is_moving = inst.sg:HasStateTag("moving")
    local is_running = inst.sg:HasStateTag("running")
    if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() then
        if is_running or is_moving then 
            SpawnPrefab("weregoose_splash_less"..tostring(math.random(2))).entity:SetParent(inst.entity)
        end
    end
end

local function SetWereDrowning(inst, mode,load)
    if inst.components.drownable ~= nil then
        if mode then
            if not load and inst.components.talker then
                inst.components.talker:Say("开启水面行走")
            end
            if inst._fh_fl_task then
                inst._fh_fl_task:Cancel()
            end
            inst._fh_fl_task = inst:DoPeriodicTask(0.35,DoGooseStepFX)
            if inst.components.drownable.enabled ~= false then
                inst.components.drownable.enabled = false
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.GROUND)
                inst.Physics:CollidesWith(COLLISION.OBSTACLES)
                inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GIANTS)
                inst.Physics:Teleport(inst.Transform:GetWorldPosition())
            end
        elseif inst.components.drownable.enabled == false then
            if not load and inst.components.talker then
                inst.components.talker:Say("关闭水面行走")
            end
            if inst._fh_fl_task then
                inst._fh_fl_task:Cancel()
                inst._fh_fl_task = nil
            end
            inst.components.drownable.enabled = true
            if not inst:HasTag("playerghost") then
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.WORLD)
                inst.Physics:CollidesWith(COLLISION.OBSTACLES)
                inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GIANTS)
                inst.Physics:Teleport(inst.Transform:GetWorldPosition())
            end
        end
    end
end

local function OnEquip(inst,owner)
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("tz_fh_fl_light")
        inst._light.Light:SetRadius((8+0.1*inst.skills.fireflies)/4)
    end
    if owner ~= nil then
        inst._light.entity:SetParent(owner.entity)
    end
    if inst.walk_onwater and owner.components.drownable ~= nil then
        SetWereDrowning(owner,true)
    end
end

local function OnUnEquip(inst,owner)
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end
    if  owner.components.drownable ~= nil then
        SetWereDrowning(owner,false)
    end
    inst.walk_onwater = false
end

local canlevelup = {
    ["goose_feather"] ={
        max = 25,
        fn = function(inst)
            inst.components.equippable.walkspeedmult = 1+ 0.01*inst.skills.goose_feather
        end
    },
    ["fireflies"] ={
        max = 100,
        fn = function(inst)
            if inst._light then
                inst._light.Light:SetRadius((8+0.1*inst.skills.fireflies)/4)
            end 
        end
    },
}

local repairmaterial ={
    nightmarefuel = 500,
}
local function ShouldAcceptItem(inst, item)
    if repairmaterial[item.prefab] then
        return true
    end
    return canlevelup[item.prefab] and ( inst.skills[item.prefab] < canlevelup[item.prefab].max)
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item  and canlevelup[item.prefab] then
        inst.skills[item.prefab] = inst.skills[item.prefab] + 1
        canlevelup[item.prefab].fn(inst)
        giver.components.talker:Say("当前进度"..inst.skills[item.prefab].."/"..canlevelup[item.prefab].max)
    elseif repairmaterial[item.prefab] then
        inst.components.armor:Repair(repairmaterial[item.prefab])
    end
end

local function OnSave(inst,data)
    data.skills = inst.skills
    data.walk_onwater = inst.walk_onwater
end

local function OnLoad(inst,data)
    if data ~= nil then
        if data.skills ~= nil then
            for k, v in pairs(canlevelup) do
                if data.skills[k] then
                    inst.skills[k] = data.skills[k]
                    v.fn(inst)
                end
            end
        end
        if data.walk_onwater then
            inst.walk_onwater = true
        end
    end
end

local function onuse(inst,doer,load)
    local owner = inst.components.inventoryitem.owner
    if owner and owner.components.drownable ~= nil then
        if inst.walk_onwater then
            inst.walk_onwater = false
            SetWereDrowning(owner,false)
        else
            inst.walk_onwater = true
            SetWereDrowning(owner,true)
        end
    end
    return false
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetFalloff(0.4)
    inst.Light:SetIntensity(.8)
    inst.Light:SetRadius(2)
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function onpercent(inst,data)
	local percent =  data and data.percent or inst.components.armor.condition
	if percent <= 0 then 
		inst.components.armor.absorb_percent = 0 
	else
		inst.components.armor.absorb_percent = 0.8
	end
end

return Prefab("tz_fh_fl_light",lightfn),
    TzEntity.CreateNormalArmor({
    assets = assets,
    prefabname = "tz_fh_fl",
    tags = {"tz_fh_fl","tz_fanhao","waterproofer"},
    bank = "tz_fh_fl",
    build = "tz_fh_fl",
    anim = "idle",

    armor_data = {
        onequip_anim_override = OnEquip,
        onunequip_anim_override = OnUnEquip,
    },
    clientfn = function(inst)
        TzFh.AddFhLevel(inst,true)
        TzFh.AddOwnerName(inst)
    end,
    serverfn = function(inst)
        inst.walk_onwater =  false
        inst.skills = {

        }
        for k, v in pairs(canlevelup) do
            inst.skills[k] = 0
        end
        inst.OnSave = OnSave 
        inst.OnLoad = OnLoad
        TzFh.MakeWhiteList(inst)

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(30000, 0.8)
        inst.components.armor.SetCondition = function(self,amount)
            if self.indestructible then
                return
            end
            if self.condition <= 0 and (amount <= 0) then
                return
            end
            self.condition = math.floor(math.min(amount, self.maxcondition))
            if self.condition <= 0 then
                self.condition = 0
            end
            self.inst:PushEvent("percentusedchange", { percent = self:GetPercent() })
        end
        inst:ListenForEvent("percentusedchange", onpercent)
        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.acceptnontradable = true

        inst:AddComponent("useableitem")
        inst.components.useableitem:SetOnUseFn(onuse)
            
        --[[ night explosion
        inst.explosion_fn = TzFh.SKILL_LIBIARY.night_explosion.on_attack_fn_wrapper(3,
            { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost","wall","structure" }
        )]]

        TzFh.AddLibrarySkill(inst,{name = "yingci"})
        TzFh.AddLibrarySkill(inst,{name = "anyingjisi"})
    end,
})