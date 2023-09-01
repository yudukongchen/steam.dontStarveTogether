local TzEntity = require("util.tz_entity")

local function cangive(inst,target,doer)
    return target and target.prefab == "tz_pugalisk_crystal"
end
local function getname(inst)
    if inst.level >= 301 then
        return "【星河 "..(inst.level- 300).."】"
    elseif inst.level >= 201 then
        return "【璀璨 "..(inst.level- 200).."】"
    elseif inst.level >= 101 then
        return "【闪耀 "..(inst.level- 100).."】"
    else
        return "【明亮 "..(inst.level).."】"
    end
end
local function setname(inst)
    local name = STRINGS.NAMES.TZ_PUGALISK_CRYSTAL
    if inst.level ~= 0 then
        name  = getname(inst)..name
    end
    inst.components.named:SetName(name)
end
local function onaccept(inst,item,giver)
    inst.level = inst.level + (item.level or 0) + 1
    item:Remove()
    setname(inst)
end
local function OnSave(inst, data)
    data.level = inst.level
end
local function OnLoad(inst, data)
    if data ~= nil then
        if data.level ~= nil then
            inst.level = data.level
        end
    end
end
return TzEntity.CreateNormalInventoryItem({
    prefabname = "tz_pugalisk_crystal",

    assets = {
        Asset("ANIM","anim/tz_pugalisk_crystal.zip"),
        Asset("IMAGE", "images/inventoryimages/tz_pugalisk_crystal.tex"),
        Asset("ATLAS", "images/inventoryimages/tz_pugalisk_crystal.xml"),
    },


    bank = "tz_pugalisk_crystal",
    build = "tz_pugalisk_crystal",
    anim = "idle",
    loop_anim = true,

    clientfn = function(inst)
        inst:AddTag("tz_pugalisk_crystal")
        inst.tz_giveitemfn = cangive
        inst.entity:AddDynamicShadow()
        inst.DynamicShadow:SetSize(2, .75)
    end,

    serverfn = function(inst)
        inst.level = 0
        inst:AddComponent("named")
        inst:AddComponent("tz_pugalisk_crystal")
        inst:AddComponent("tz_giveitem")
        inst.components.tz_giveitem.test = cangive
        inst.components.tz_giveitem.onaccept= onaccept
        
        inst.DoFall = function(inst)
            inst.falling = true 
            inst.AnimState:PlayAnimation("lost")
            inst.components.inventoryitem:OnDropped()
            inst.fall_task = inst:DoPeriodicTask(0,function()
                if inst.falling and inst:GetPosition().y < 0.05 then
                    inst.AnimState:PlayAnimation("idle",true)
                    inst.falling = false 

                    inst.fall_task:Cancel()
                    inst.fall_task = nil 
                end
            end)
        end
        inst.OnSave = OnSave
        inst.OnLoad = OnLoad
    end,
})