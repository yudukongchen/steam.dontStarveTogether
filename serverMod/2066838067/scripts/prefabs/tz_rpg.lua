local containers = require "containers"
local containers_params = containers.params
-- local UIAnim = require "widgets/uianim"
local TzRpgChargeProgressbar = require "widgets/tz_rpg_charge_progressbar"
local TzDebuffUtil = require "tz_debuff_util"
local TzUtil = require "tz_util"

require "vecutil"

local gaizhuang_name = {
    ["bearger_fur"] = "迫击炮",
    ["lavae_egg"] = "超蓄力",
    ["dragon_scales"] = "速射",
    -- ["deerclops_eyeball"] = "连射",
    ["deer_antler1"] = "快速装填",
    ["deer_antler2"] = "快速装填",
    ["deer_antler3"] = "快速装填",
    ["gears"] = "快速冷却",
    ["minotaurhorn"] = "狙击枪",
    ["shroom_skin"] = "军火库",
}

local fumo_name = {
    ["bluegem"] = "北极星",
    ["redgem"] = "红巨星",
    ["greengem"] = "卫星",
    ["purplegem"] = "彗星",
    ["yellowgem"] = "银河",
    ["orangegem"] = "小行星",
    ["opalpreciousgem"] = "星云裂变",
}

containers_params.tz_rpg =
{
    widget =
    {
        slotpos =
        {
            Vector3(-50,   35,  0),
            Vector3(55, 35, 0),
        },
        -- slotbg =
        -- {
        --     { image = "fishing_slot_bobber.tex" },
        --     { image = "fishing_slot_lure.tex" },
        -- },
        animbank = "tz_rpg_container_bg",
        animbuild = "tz_rpg_container_bg",
        pos = Vector3(0, 12, 0),
    },
    acceptsstacks = false,
    usespecificslotsforitems = true,
    type = "hand_inv",
    itemtestfn = function(container, item, slot)
        return (slot == nil and (fumo_name[item.prefab] or gaizhuang_name[item.prefab]))
		or (slot == 1 and gaizhuang_name[item.prefab])
		or (slot == 2 and fumo_name[item.prefab])
    end,
}

local assets =
{   
    Asset("ANIM", "anim/tz_rpg.zip"),
    Asset("ANIM", "anim/tz_rpg_emperor.zip"),
    Asset("ANIM", "anim/tz_rpg_battery.zip"),
    Asset("ANIM", "anim/tz_rpg_progressbar.zip"),
    Asset("ANIM", "anim/tz_rpg_progressbar_addition.zip"),
    Asset("ANIM", "anim/tz_rpg_reload.zip"),
	Asset("ANIM", "anim/tz_actions_rpg.zip"),
	Asset("ANIM", "anim/tz_rpg_projectile.zip"),
    Asset("ANIM", "anim/swap_tz_rpg.zip"),
    Asset("ANIM", "anim/swap_tz_rpg_emperor.zip"),
    Asset("ANIM", "anim/tz_rpg_container_bg.zip"),
    

    Asset("IMAGE","images/inventoryimages/tz_rpg.tex"),
    Asset("ATLAS","images/inventoryimages/tz_rpg.xml"),

    Asset("IMAGE","images/inventoryimages/tz_rpg_emperor.tex"),
    Asset("ATLAS","images/inventoryimages/tz_rpg_emperor.xml"),

    Asset( "SOUND" , "sound/tz_rpg.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/tz_rpg.fev" ),
}



local function onequip(inst, owner)
    local swap_symbol = inst.components.tz_rpg_emperor_upgrate:IsUpgrated() and "swap_tz_rpg_emperor" or "swap_tz_rpg"
    owner.AnimState:OverrideSymbol("swap_object", swap_symbol, "swap_object")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end

    inst:ListenForEvent("onhitother",inst._OnOwnerHitOther,owner)
    inst._owner:set(owner)
    -- inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/equip")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
    if inst.charge_fx then 
        inst.charge_fx:KillFX()
        inst.charge_fx = nil 
    end
    inst:RemoveEventCallback("onhitother",inst._OnOwnerHitOther,owner)
    inst._owner:set(inst)
end

local function LaunchPaodanAtPos(inst,player,pos,dmg_multi)
    local percent = player.components.tz_weaponcharge:GetPercent()
    local proj = SpawnAt("tz_rpg_projectile",inst)
    local gaizhuang_item,fumo_item = inst:GetGaizhuangAndFumoItems(true)
    local tz_level = inst.components.tz_exp:GetLevel()
    local charge_complete = percent >= 1 or (percent >= 0.5 and gaizhuang_item == "lavae_egg") 
    
    proj.weapon = inst
    proj.gaizhuang_item = gaizhuang_item
    proj.fumo_item = fumo_item
    proj.tz_level = tz_level
    proj.dmg_multi = dmg_multi or 1
    proj.max_dist = percent >= 1.0 and 28 or 20

    -- print(string.format("Prepare to launch percent:%.2f",percent))

    proj._usetail:set(true)
    if charge_complete then 
        proj.AnimState:PlayAnimation("MAXpaodan",true)
        proj.charge_complete = true
        proj.components.complexprojectile:SetHorizontalSpeed(25)
    end

    if fumo_item == "purplegem" and tz_level == 9 then 
        proj.components.complexprojectile:SetHorizontalSpeed(proj.components.complexprojectile.horizontalSpeed + 5)
    elseif fumo_item == "orangegem" then 
        proj.components.complexprojectile:SetHorizontalSpeed(proj.components.complexprojectile.horizontalSpeed + 2 * tz_level)
        if tz_level == 9 then 
            proj.piercing = true
            proj.dmg_multi = proj.dmg_multi * 0.33
        end
    end

    if gaizhuang_item == "bearger_fur" and tz_level == 9 then 
        proj.components.complexprojectile:SetHorizontalSpeed(proj.components.complexprojectile.horizontalSpeed - 5)
    elseif gaizhuang_item == "minotaurhorn" then 
        proj.components.complexprojectile:SetHorizontalSpeed(proj.components.complexprojectile.horizontalSpeed + 5)
        if tz_level == 9 then 
            proj.components.complexprojectile:SetHorizontalSpeed(proj.components.complexprojectile.horizontalSpeed + 5)
        end
    elseif gaizhuang_item == "lavae_egg" then 
        if percent >= 1 then 
            proj.dmg_multi = proj.dmg_multi * 2
            proj.max_dist = proj.max_dist + 12
            proj.components.complexprojectile:SetHorizontalSpeed(proj.components.complexprojectile.horizontalSpeed + 4)
        elseif percent >= 0.5 then 


        end

        if tz_level == 9 then 
            proj.components.complexprojectile:SetHorizontalSpeed(proj.components.complexprojectile.horizontalSpeed + 4)
            proj.max_dist = proj.max_dist + 4
        end
    end

    proj.components.complexprojectile:Launch(pos,player,inst)
    proj:DoInitSpeed()

    if inst.components.tz_rpg_battery:IsReloading() then 
        inst.components.tz_rpg_battery:StopReload()
    end 
end

local function WrappedLaunchProjectileAtPos(inst,player,pos)
    local gaizhuang_item,fumo_item = inst:GetGaizhuangAndFumoItems(true)
    local tz_level = inst.components.tz_exp:GetLevel()

    if fumo_item == "opalpreciousgem" and (math.random() <= 0.10 * tz_level or tz_level == 9) then 
        local mypos = player:GetPosition()
        local x1,z1 = VecUtil_RotateAroundPoint(mypos.x,mypos.z,pos.x,pos.z,PI / 12)
        local x2,z2 = VecUtil_RotateAroundPoint(mypos.x,mypos.z,pos.x,pos.z,-PI / 12)

        LaunchPaodanAtPos(inst,player,Vector3(x1,0,z1),0.5)
        LaunchPaodanAtPos(inst,player,Vector3(x2,0,z2),0.5)
        LaunchPaodanAtPos(inst,player,pos,0.5)
    else
        LaunchPaodanAtPos(inst,player,pos)
    end 

    if inst.components.tz_rpg_overheat:IsOverload() then 
        inst.components.finiteuses:Use(5)
    else
        inst.components.finiteuses:Use()
    end 
    inst.components.tz_rpg_battery:DoDelta(-1)
    inst.components.tz_rpg_overheat:DoDelta(5)

    inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/launch")
end

local function OnFakePorjLaunch(inst, attacker, target)
    WrappedLaunchProjectileAtPos(inst,attacker,target:GetPosition())
end

local function ShouldAcceptItem(inst, item, giver)
    return item.prefab == "gunpowder" and inst.components.finiteuses:GetPercent() < 1.0
end

local function OnGetItemFromPlayer(inst, giver, item)
    inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/repair_done")
    inst.components.finiteuses:SetUses(math.min(inst.components.finiteuses.total,inst.components.finiteuses:GetUses() + 10))
end

local function OnRefuseItem(inst, giver, item)
    if giver.components.talker then 
        if item.prefab == "gunpowder" then 
            giver.components.talker:Say("塞满了~")
        else
            giver.components.talker:Say("只能用火药填充哦~")
        end 
    end
end

local function CreateChargeFxClient(owner)
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddFollower()

    inst.AnimState:SetBank("deer_ice_charge")
    inst.AnimState:SetBuild("deer_ice_charge")
    inst.AnimState:PlayAnimation("pre")
    inst.AnimState:PushAnimation("loop",true)
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(3)

    inst.SuitFace = function(inst,owner)
        local face = owner.Transform:GetFacing()
        if face == 0 or face == 2 then 
            inst.Follower:FollowSymbol(owner.GUID,"swap_object", 200, -100, 0)
        elseif face == 1 then 
            inst.Follower:FollowSymbol(owner.GUID,"swap_object", 0, -180, 0)
        elseif face == 3 then 
            inst.Follower:FollowSymbol(owner.GUID,"swap_object", 0, 85, 0)
        else
            inst.Follower:FollowSymbol(owner.GUID,"swap_object", 0, 0, 0)
        end
    end

    inst.KillFX = function(inst)
        inst.AnimState:PlayAnimation("blast")
        inst:ListenForEvent("animover",inst.Remove)
    end

    inst.entity:SetParent(owner.entity)
    inst:SuitFace(owner)
    inst:DoPeriodicTask(0,function()
        inst:SuitFace(owner)
    end)    

    return inst
end

local function OnOwnerDirty(inst)
    local owner = inst._owner:value()
    if owner ~= inst then

    else
        if inst._charge_fx then 
            inst._charge_fx:KillFX()
            inst._charge_fx = nil 
        end 
    end
end

local function OnChargeProgressDirty(inst)
    if not (ThePlayer and inst.replica.inventoryitem)then 
        return 
    end

    local owner = inst._owner:value()
    local held_by_theplayer = inst.replica.inventoryitem:IsHeldBy(ThePlayer)
    local percent = inst._charge_progress:value()

    if percent <= 0 then 
        if inst._charge_fx then 
            inst._charge_fx:KillFX()
            inst._charge_fx = nil 
        end
    elseif percent >= 1 then 
        CreateChargeFxClient(owner):KillFX()
    else
        if not inst._charge_fx then 
            inst._charge_fx = CreateChargeFxClient(owner)
        end
    end 

    if held_by_theplayer then 
        if percent <= 0 then 
            if ThePlayer.HUD.controls.TzRpgChargeProgressbar then 
                ThePlayer.HUD.controls.TzRpgChargeProgressbar:Kill()
                ThePlayer.HUD.controls.TzRpgChargeProgressbar = nil 
            end
        elseif percent >= 1 then 
            if ThePlayer.HUD.controls.TzRpgChargeProgressbar then 
                ThePlayer.HUD.controls.TzRpgChargeProgressbar:SetPercent(percent)
                ThePlayer.HUD.controls.TzRpgChargeProgressbar:PopOut()
                ThePlayer.HUD.controls.TzRpgChargeProgressbar = nil 
            end
        else
            if not ThePlayer.HUD.controls.TzRpgChargeProgressbar then 
                local progressbar = ThePlayer.HUD.controls:AddChild(TzRpgChargeProgressbar(ThePlayer))
                ThePlayer.HUD.controls.TzRpgChargeProgressbar = progressbar
                ThePlayer.HUD.controls.TzRpgChargeProgressbar:SetVAnchor(ANCHOR_BOTTOM)
                ThePlayer.HUD.controls.TzRpgChargeProgressbar:SetHAnchor(ANCHOR_MIDDLE)
                ThePlayer.HUD.controls.TzRpgChargeProgressbar:SetPosition(0,250)
                ThePlayer.HUD.controls.TzRpgChargeProgressbar:PopIn()
                ThePlayer.HUD.controls.TzRpgChargeProgressbar.inst:ListenForEvent("onremove",function()
                    progressbar:Kill()
                    ThePlayer.HUD.controls.TzRpgChargeProgressbar = nil 
                end,inst)
                if inst:HasTag("tz_rpg_super_charge") then 
                    ThePlayer.HUD.controls.TzRpgChargeProgressbar:EnableSuper(true)
                end
            end
            ThePlayer.HUD.controls.TzRpgChargeProgressbar:SetPercent(percent)
        end
    end 
end

local function OnTzChargeTimeChange(inst,data)
    local old_percent = data.old_percent
    local percent = data.current_percent
    local owner = inst.components.inventoryitem:GetGrandOwner()
    local equipped = inst.components.equippable:IsEquipped()

    inst._charge_progress:set(percent)

    if percent <= 0 then 
        if inst.charge_fx then 
            inst.charge_fx:KillFX()
            inst.charge_fx = nil 
        end
        if inst.reticuleline then 
            inst.reticuleline:Remove()
            inst.reticuleline = nil 
        end
    elseif percent >= 1 then 
        -- local explo_fx = SpawnPrefab("tz_rpg_charge_fx")
        -- explo_fx.entity:SetParent(owner.entity)
        -- explo_fx.entity:AddFollower()
        -- explo_fx.Follower:FollowSymbol(owner.GUID,"swap_object", 0, 0, 0)
        -- explo_fx:KillFX()

        if inst:HasTag("tz_rpg_super_charge") then 
            inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/super_charge_done")
        else
            -- inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/charge_done")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
        end
    elseif owner and equipped then 
        if not inst.charge_fx then 
            -- inst.charge_fx = SpawnPrefab("tz_rpg_charge_fx")
            -- inst.charge_fx.entity:SetParent(owner.entity)
            -- inst.charge_fx.entity:AddFollower()
            -- inst.charge_fx.Follower:FollowSymbol(owner.GUID,"swap_object", 0, 0, 0)
        end
        if not inst.reticuleline then 
            -- inst.reticuleline = SpawnAt("tz_rpg_reticuleline",owner)
            -- inst.reticuleline.Transform:SetRotation(owner.Transform:GetRotation())
            inst.reticuleline = owner:SpawnChild("tz_rpg_reticuleline")
        end
        -- inst.reticuleline:DoPeriodicTask(0,function(reticuleline)
        --     reticuleline.Transform:SetPosition(owner.Transform:GetWorldPosition())
        --     reticuleline.Transform:SetRotation(owner.Transform:GetRotation())
        -- end)
        if old_percent < 0.5 and percent >= 0.5 and inst:HasTag("tz_rpg_super_charge") then 
            inst.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
        end
    end
end

local function RenameRPG(inst)
    local gaizhuang_item,fumo_item = inst:GetGaizhuangAndFumoItems(true)
    local tz_level = inst.components.tz_exp:GetLevel()
    local tz_exp = inst.components.tz_exp:GetExp()
    local tz_max_exp = inst.components.tz_exp:GetMaxExp()

    -- rename the rpg
    local new_name = inst.components.tz_rpg_emperor_upgrate:IsUpgrated() and STRINGS.NAMES.TZ_RPG_EMPEROR or STRINGS.NAMES.TZ_RPG
    if gaizhuang_item ~= nil then
        new_name = new_name.."•"..gaizhuang_name[gaizhuang_item]
    end
    if fumo_item ~= nil then
        new_name = new_name.."•"..fumo_name[fumo_item]
    end
    for i =1,tz_level do 
        new_name = new_name.."★"
    end
    -- new_name = new_name.."(Lv."..tostring(tz_level)..")"
    new_name = new_name.."\n"
    if not inst.components.tz_exp:IsLevelMax() then 
        new_name = new_name..string.format("Exp:%d/%d",tz_exp,tz_max_exp)
    else
        new_name = new_name.."已经满级了"
    end 
    new_name = new_name.."\n"
    local current_heat = inst.components.tz_rpg_overheat.current
    local max_heat = inst.components.tz_rpg_overheat.max 
    new_name = new_name..string.format("热量:%d/%d",current_heat,max_heat)
    if inst.components.tz_rpg_overheat:IsOverHeated() then 
        new_name = new_name.."(已无法使用)"
    elseif inst.components.tz_rpg_overheat:IsOverload() then 
        new_name = new_name.."(已过载)"
    end
    inst.components.named:SetName(new_name)
    -- end of rename rpg
end

local function ApplyGaizhuangFumoAndStar(inst)
    local battery_cnt = 4
    local weapon_dmg = 60 - 15
    local charge_need_time = 1.5 
    local reload_maxtime = 3 

    local gaizhuang_item,fumo_item = inst:GetGaizhuangAndFumoItems(true)
    local tz_level = inst.components.tz_exp:GetLevel()
    local tz_exp = inst.components.tz_exp:GetExp()
    local tz_max_exp = inst.components.tz_exp:GetMaxExp()

    -- gain 15 ATK for each weapon level
    weapon_dmg = weapon_dmg + tz_level * 15

    if fumo_item == "yellowgem" then 
        weapon_dmg = weapon_dmg + tz_level * 10
    elseif fumo_item == "opalpreciousgem" and tz_level == 9 then 
        weapon_dmg = weapon_dmg + 50
        if tz_level == 9 then 
            inst.components.tz_rpg_overheat.cold_one_time:SetModifier(inst,0.5,"fumo_item_opalpreciousgem_lv9")
        end
    elseif fumo_item == "orangegem" then 
        weapon_dmg = weapon_dmg  - tz_level * 10
        
    end 

    if gaizhuang_item == "bearger_fur" then 
        weapon_dmg = weapon_dmg + 50
    elseif gaizhuang_item == "deerclops_eyeball" and tz_level == 9 then 
        battery_cnt = battery_cnt - 1
    elseif gaizhuang_item == "dragon_scales" then 
        charge_need_time = charge_need_time - 0.5
        if tz_level == 9 then 
            charge_need_time = charge_need_time - 1
            weapon_dmg = weapon_dmg - 50
            inst.components.tz_rpg_overheat.cold_one_time:SetModifier(inst,-2,"gaizhuang_item_dragon_scales_lv9")
        end
    elseif gaizhuang_item ~= nil and string.find(gaizhuang_item,"deer_antler") then 
        reload_maxtime = reload_maxtime - 1
        if tz_level == 9 then 
            reload_maxtime = reload_maxtime - 1.5
            inst.components.tz_rpg_overheat.cold_one_time:SetModifier(inst,-1,"gaizhuang_item_deer_antler_lv9")
        end
    elseif gaizhuang_item == "armorskeleton" then 
        inst.components.tz_rpg_overheat.cold_one_time:SetModifier(inst,-1,"gaizhuang_item_armorskeleton")
        if tz_level == 9 then 
            battery_cnt = battery_cnt + 3
            inst.components.tz_rpg_overheat.cold_one_time:SetModifier(inst,-1.5,"gaizhuang_item_armorskeleton_lv9")
        end
    elseif gaizhuang_item == "minotaurhorn" then 
        weapon_dmg = weapon_dmg + 50
        if tz_level == 9 then 
            weapon_dmg = weapon_dmg + 50
            battery_cnt = battery_cnt - 1 
            inst.components.tz_rpg_overheat.cold_one_time:SetModifier(inst,1,"gaizhuang_item_minotaurhorn_lv9")
        end
    elseif gaizhuang_item == "shroom_skin" then 
        battery_cnt = battery_cnt + 2
        if tz_level == 9 then 
            battery_cnt = battery_cnt + 3
            reload_maxtime = reload_maxtime + 2
            
        end
    end

    if gaizhuang_item == "lavae_egg" then 
        inst:AddTag("tz_rpg_super_charge")
        charge_need_time = charge_need_time + 1
        inst.components.tz_rpg_overheat.cold_one_time:SetModifier(inst,1,"gaizhuang_item_lavae_egg")
        if tz_level == 9 then 
            weapon_dmg = weapon_dmg * 2 
        end
    else
        inst:RemoveTag("tz_rpg_super_charge")
    end
    
    reload_maxtime = math.max(reload_maxtime,3 * FRAMES)
    charge_need_time = math.max(charge_need_time,3 * FRAMES)

    inst.components.weapon:SetDamage(weapon_dmg)
    inst.components.tz_rpg_battery:SetMax(battery_cnt)
    inst.components.tz_rpg_battery.reload_maxtime = reload_maxtime
    inst.components.tz_chargeable_weapon.need_time = charge_need_time
    


    inst:RenameRPG()
end

local function OnContainerItemChange(inst)
    inst:ApplyGaizhuangFumoAndStar()
end

local function OnRpgLevelDelta(inst,data)
    if data.old < data.current then
        inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/level_up")
    end
    
    inst:ApplyGaizhuangFumoAndStar()
end

local function OnRpgExpDelta(inst,data)
    inst:ApplyGaizhuangFumoAndStar()
end

local function OnRpgBatteryDelta(inst,data)
    if inst.components.tz_rpg_battery:IsFull() and data.current > data.old then 
        inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/reload_done")
    end
end

local function OnRpgHeatDelta(inst,data)
    local old = data.old 
    local current = data.current 

    local overload_threshold = inst.components.tz_rpg_overheat.overload_threshold
    local max = inst.components.tz_rpg_overheat.max

    local owner = inst.components.inventoryitem.owner 
    local equipped = inst.components.equippable:IsEquipped()
    
    if equipped and owner and owner.components.talker then 
        if old < overload_threshold and current >= overload_threshold then 
            owner.components.talker:Say("炮膛超载！")
        elseif old < max and current >= max then 
            owner.components.talker:Say("武器过热，需要10秒冷却！")
        elseif old >= max and current < max then 
            owner.components.talker:Say("武器重新冷却完毕！")
        end
    end 

    inst:RenameRPG()
end

local function OnRpgRemove(inst)
    if inst.reticuleline then 
        inst.reticuleline:Remove()
        inst.reticuleline = nil 
    end
end

local function GetGaizhuangAndFumoItems(inst,return_prefab)
    local gaizhuang_item = inst.components.container.slots[1]
    local fumo_item = inst.components.container.slots[2]

    if return_prefab then 
        return gaizhuang_item and gaizhuang_item.prefab,fumo_item and fumo_item.prefab
    else
        return gaizhuang_item,fumo_item
    end 
end

local function OnSaveRPG(inst,data)

end

local function OnLoadRPG(inst,data)
    if data ~= nil then 

    end

    inst:ApplyGaizhuangFumoAndStar()
end



local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_rpg")
    inst.AnimState:SetBuild("tz_rpg")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("tz_rpg")
    inst:AddTag("tz_chargeable_weapon")
    inst:AddTag("allow_action_on_impassable")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst._owner = net_entity(inst.GUID,"inst._owner","on_owner_dirty")
    inst._charge_progress = net_float(inst.GUID,"inst._charge_progress","on_charge_progress_dirty")

    if not TheNet:IsDedicated() then 
        inst._charge_fx = nil 

        inst:ListenForEvent("on_owner_dirty",OnOwnerDirty)
        inst:ListenForEvent("on_charge_progress_dirty",OnChargeProgressDirty)
        inst:ListenForEvent("onremove",function()
            if inst._charge_fx then 
                inst._charge_fx:KillFX()
                inst._charge_fx = nil 
            end 
        end)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("tz_rpg") 
		end
        
        return inst
    end

    inst.battery_ui = nil 
    inst.reloadbar = nil 
    inst.charge_fx = nil 

    
    inst.RenameRPG = RenameRPG
    inst.ApplyGaizhuangFumoAndStar = ApplyGaizhuangFumoAndStar
    inst.GetGaizhuangAndFumoItems = GetGaizhuangAndFumoItems
    inst.OnSave = OnSaveRPG
    inst.OnLoad = OnLoadRPG

    inst._OnOwnerHitOther = function(owner,data)
        local damage = data.damageresolved 
        if damage and damage > 0 then 
            inst.components.tz_exp:DoDeltaExp(damage)
        end
    end

    inst:AddComponent("named")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(20,100)
    inst.components.weapon:SetProjectile("tz_rpg_projectile_fake")
    inst.components.weapon:SetOnProjectileLaunch(OnFakePorjLaunch)
    inst.components.weapon.attackwear = 0

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(400)
    inst.components.finiteuses:SetUses(400)
    -- inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.imagename = "tz_rpg"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_rpg.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = false

    inst:AddComponent("tz_rpg_overheat")

    inst:AddComponent("tz_rpg_battery")
    inst.components.tz_rpg_battery.reload_maxtime = 3
    inst.components.tz_rpg_battery:SetMax(4)

    inst:AddComponent("tz_rpg_emperor_upgrate")

    inst:AddComponent("tz_chargeable_weapon")
    inst.components.tz_chargeable_weapon.need_time = 1.5
    inst.components.tz_chargeable_weapon.small_attack_override = function(player,face_vec)
        WrappedLaunchProjectileAtPos(inst,player,player:GetPosition() + face_vec * 10)
    end
    inst.components.tz_chargeable_weapon.super_attack_override = function(player,face_vec)

    end

    inst:AddComponent("tz_exp")
    inst.components.tz_exp:SetCalcMaxExpFn(function(inst,level)
        return level * 100000
    end)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("tz_rpg")
	inst.components.container.canbeopened = false

    inst:ListenForEvent("itemget", OnContainerItemChange)
    inst:ListenForEvent("itemlose", OnContainerItemChange)
    inst:ListenForEvent("tz_charge_time_change",OnTzChargeTimeChange)
    inst:ListenForEvent("tz_level_delta",OnRpgLevelDelta)
    inst:ListenForEvent("tz_exp_delta",OnRpgExpDelta)
    inst:ListenForEvent("tz_rpg_battery_delta",OnRpgBatteryDelta)
    inst:ListenForEvent("onremove",OnRpgRemove)
    inst:ListenForEvent("tz_rpg_heat_delta",OnRpgHeatDelta)

    inst:ApplyGaizhuangFumoAndStar()

    return inst
end

local function SpikeLaunch(inst, launcher, basespeed)
    local x0, y0, z0 = launcher.Transform:GetWorldPosition()
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local dx, dz = x1 - x0, z1 - z0
    local dsq = dx * dx + dz * dz
    local angle
    if dsq > 0 then
        local dist = math.sqrt(dsq)
        angle = math.atan2(dz / dist, dx / dist) + (math.random() * 20 - 10) * DEGREES
    else
        angle = 2 * PI * math.random()
    end
    local sina, cosa = math.sin(angle), math.cos(angle)
    local speed = basespeed + math.random()
    inst.Physics:SetVel(cosa * speed, speed * 3 + math.random() * 2, sina * speed)
end

local function DoToss(inst,range)
    range = range or 0.7
    local x, y, z = inst.Transform:GetWorldPosition()
    local totoss = TheSim:FindEntities(x, 0, z, range, { "_inventoryitem" }, { "locomotor", "INLIMBO" })
    for i, v in ipairs(totoss) do
        if v.components.mine ~= nil then
            v.components.mine:Deactivate()
        end
        if not v.components.inventoryitem.nobounce and v.Physics ~= nil and v.Physics:IsActive() then
            v.components.inventoryitem:SetLanded(false,true)
            SpikeLaunch(v, inst,5)
        end
    end
end

local function OnProjectileExplode(inst, attacker,target)
    if inst.charge_complete then     
        inst:SpawnChild("tz_rpg_explode_vfx")
        DoToss(inst,3.5)    
    else
        -- Spawn a normal explode fx
        SpawnAt("tz_rpg_explode_small",inst).Transform:SetScale(1.7,1.7,1.7)
    end 

    inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/explode")
    inst.SoundEmitter:PlaySound("tz_rpg/"..TUNING.TZ_RPG_CONFIG.SOUND_NAME.."/explode2")
    ShakeAllCameras(CAMERASHAKE.FULL, .35, .02, 1, inst, 25)
    

    local gaizhuang_item,fumo_item,tz_level = inst.gaizhuang_item,inst.fumo_item,inst.tz_level
    local rad = inst.charge_complete and 3 or 2.75
    local x,y,z = inst:GetPosition():Get()

    if fumo_item == "yellowgem" and tz_level == 9 then 
        rad = rad + 4
    end

    if fumo_item == "opalpreciousgem" and tz_level == 9 then 
        rad = rad + 2
    end

    if gaizhuang_item == "bearger_fur" and tz_level == 9 then
        rad = rad + 6
    end

    -- tz_rpg_hit
    local all_ents_maybe_attacked = TheSim:FindEntities(x,y,z,rad,nil,{"INLIMBO","playerghost"},{"_combat","_inventoryitem","CHOP_workable","MINE_workable"})

    -- print("OnProjectileExplode target:",target)
    if target ~= nil and target:IsValid() and not table.contains(all_ents_maybe_attacked,target) then
        table.insert(all_ents_maybe_attacked,target)
    end
    
    for k,v in pairs(all_ents_maybe_attacked) do 
        if fumo_item == "greengem" then 
            local is_rideable = v.components.rideable ~= nil
            local rider = is_rideable and v.components.rideable:GetRider()
            local leader = inst.components.follower and inst.components.follower:GetLeader()
            local mount = v:HasTag("player") and v.components.rider:GetMount()
            if v:HasTag("player") 
                or (is_rideable and leader and leader:HasTag("player"))
                or (rider and rider:HasTag("player"))
                then
                
                local weapon = inst.weapon 
                if v.components.health then 
                    if weapon and weapon:IsValid() and weapon.components.weapon then
                        local damage = weapon.components.weapon.damage 
                        local recover = 0.2 * (inst.charge_complete and 1.5 or 1) *damage * attacker.components.combat.externaldamagemultipliers:Get()
                        v.components.health:DoDelta(recover)
                    end
                end 
                
                if mount and mount.components.health then
                    if weapon and weapon:IsValid() and weapon.components.weapon then
                        local damage = weapon.components.weapon.damage 
                        local recover = 0.2 * (inst.charge_complete and 1.5 or 1) *damage * attacker.components.combat.externaldamagemultipliers:Get()
                        mount.components.health:DoDelta(recover)
                    end
                end
                if v:HasTag("player") and tz_level == 9 then 
                    -- 为击中目标添加35%减伤，持续15秒（仅限玩家）
                    v.components.debuffable:AddDebuff("tz_rpg_debuff_greengem_lv9","tz_rpg_debuff_greengem_lv9")
                end
            end
        elseif attacker.components.combat:CanTarget(v) and not attacker.components.combat:IsAlly(v) then 
            attacker.components.combat.ignorehitrange = true
            attacker.components.combat:DoAttack(v,nil,inst,nil,(inst.charge_complete and 1.5 or 1) * inst.dmg_multi)
            attacker.components.combat.ignorehitrange = false

            if inst.charge_complete then 
                v:PushEvent("knockback", { knocker = inst, radius = GetRandomMinMax(1.2,1.4) + v:GetPhysicsRadius(.5)})
            end 

            if fumo_item == "bluegem" then 
                local freeze_time = 3
                if math.random() <= tz_level * 0.1 and v.components.freezable then 
                    v.components.freezable:AddColdness(1,freeze_time)
                end 
                if tz_level == 9 then 
                    -- 击中目标时使其减速30%
                    if v.components.locomotor then 
                        if not v.components.debuffable then 
                            v:AddComponent("debuffable")
                        end
                        v.components.debuffable:AddDebuff("tz_rpg_debuff_bluegem_lv9","tz_rpg_debuff_bluegem_lv9")
                    end
                end
            elseif fumo_item == "redgem" then 
                if v.components.burnable then 
                    local old_burntime = v.components.burnable.burntime
                    local new_burntime = tz_level * 0.8
                    v.components.burnable:SetBurnTime(new_burntime)
                    v.components.burnable:Ignite(true,inst,attacker)
                    v.components.burnable:SetBurnTime(old_burntime)
                end
            elseif fumo_item == "purplegem" then
                
                if not v.components.debuffable then 
                    v:AddComponent("debuffable")
                end

                if v.components.combat then 
                    local debuff = v.components.debuffable:AddDebuff("tz_rpg_debuff_purplegem","tz_rpg_debuff_purplegem")
                    debuff:ApplyDepth(tz_level)
                end 
            end 

        elseif v.components.workable and v.components.workable:CanBeWorked()
            and (v.components.workable.action == ACTIONS.CHOP or v.components.workable.action == ACTIONS.MINE) then    

            v.components.workable:WorkedBy(attacker,8)  

        end
    end


    -- tz_rpg_explode
    if fumo_item == "redgem" and tz_level == 9 then 
        -- 爆炸的地方会留下3个燃烧物，存在30秒
        local pos = inst:GetPosition()
        for i = 1,3 do 
            local roa = math.random() * 2 * PI
            local length = GetRandomMinMax(0.1,2)
            local offset = Vector3(math.cos(roa),0,math.sin(roa)) * length

            SpawnAt("tz_rpg_redgem_fire",pos+offset):SetFire("large",30 + math.random())
        end
    end
end

local function OnProjectileHit(inst, attacker, target)
    inst.hitted = true
    inst._usetail:set(false)
    inst.DynamicShadow:Enable(false)
    OnProjectileExplode(inst, attacker, target)
    inst:Hide()
    inst:DoTaskInTime(1.5,inst.Remove)
end

local function CreateTail(bank, build, lightoverride, addcolour, multcolour)
    local inst = CreateEntity()
  
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false
  
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
  
    MakeInventoryPhysics(inst)
    inst.Physics:ClearCollisionMask()
  
    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("disappear")
    if addcolour ~= nil then
        inst.AnimState:SetAddColour(unpack(addcolour))
    end
    if multcolour ~= nil then
        inst.AnimState:SetMultColour(unpack(multcolour))
    end
    if lightoverride > 0 then
        inst.AnimState:SetLightOverride(lightoverride)
    end
    inst.AnimState:SetFinalOffset(-1)
  
    inst:ListenForEvent("animover", inst.Remove)
  
    return inst
end
  
local function OnUpdateProjectileTail(inst, bank, build, speed, lightoverride, addcolour, multcolour, m_offset, tails)
    if not inst._usetail:value() then return end
    m_offset = m_offset or Vector3(0,0,0)
    local x, y, z = inst.Transform:GetWorldPosition()
    for tail, _ in pairs(tails) do
        tail:ForceFacePoint(x, y, z)
    end
    if inst.entity:IsVisible() then
        local tail = CreateTail(bank, build, lightoverride, addcolour, multcolour)
        local rot = inst.Transform:GetRotation()
        tail.Transform:SetRotation(rot)
        rot = rot * DEGREES
        local offsangle = math.random() * 2 * PI
        local offsradius = math.random() * .05 + .05
        local hoffset = math.cos(offsangle) * offsradius
        local voffset = math.sin(offsangle) * offsradius
        tail.Transform:SetPosition(x + math.sin(rot) * hoffset + m_offset.x, y + voffset + m_offset.y, z + math.cos(rot) * hoffset + m_offset.z)
        tail.Physics:SetMotorVel(speed * (.2 + math.random() * .3), 0, 0)
        tails[tail] = true
        inst:ListenForEvent("onremove", function(tail) tails[tail] = nil end, tail)
        tail:ListenForEvent("onremove", function(inst)
            tail.Transform:SetRotation(tail.Transform:GetRotation() + math.random() * 30 - 15)
        end, inst)
    end
end

-- Ly: Give a projectile normal physics may not suit (glitch with walls)
-- So I delete it.
local function OnProjectileCollide(inst,other)
    
    if not inst.hitted then 
        print("OnProjectileCollide",inst,other)
        local attacker = inst.components.complexprojectile.attacker
        if attacker and other ~= attacker then 
            if inst.piercing then 
                inst.hitted_targets = inst.hitted_targets or {}
                if not inst.hitted_targets[other] then 
                    inst.hitted_targets[other] = true 
                    OnProjectileExplode(inst, attacker, other)
                end 
            else
                inst.components.complexprojectile:Hit(other)
            end 
        end 
    end 
end
  
local function projectile_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()

    inst.Transform:SetEightFaced()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    -- inst.Physics:SetMass(1)
    -- inst.Physics:SetFriction(0)
    -- inst.Physics:SetDamping(0)
    -- inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    -- inst.Physics:ClearCollisionMask()
    -- inst.Physics:CollidesWith(COLLISION.GROUND)
    -- inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    -- inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    -- inst.Physics:CollidesWith(COLLISION.GIANTS)
    -- -- inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    -- inst.Physics:SetCapsule(0.75,0.75)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("tz_rpg_projectile")
    inst.AnimState:SetBuild("tz_rpg_projectile")
    inst.AnimState:PlayAnimation("paodan",true)

    -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLightOverride(1)

    inst.Transform:SetScale(1.1,1.1,1.1)

    inst.DynamicShadow:SetSize(1.3, .6)

    inst._usetail = net_bool(inst.GUID, "tz_rpg_projectile._usetail")
    inst._usetail:set(false)

    if not TheNet:IsDedicated() then
        inst:DoPeriodicTask(0, OnUpdateProjectileTail, nil, "fireball_fx", "fireball_2_fx", 15, 1, {1,1,0,1}, nil, Vector3(0,-0.65,0), {})
    end


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.DoInitSpeed = function(inst)
        inst.Physics:SetMotorVel(inst.components.complexprojectile.horizontalSpeed,0,0)
    end

    -- inst.Physics:SetCollisionCallback(OnProjectileCollide)

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetOnHit(OnProjectileHit)
    inst.components.complexprojectile:SetHorizontalSpeed(20)
    inst.components.complexprojectile:SetOnLaunch(function(inst)
        inst.components.complexprojectile.on_launch_pos = inst:GetPosition()

        local gaizhuang_item,fumo_item,tz_level = inst.gaizhuang_item,inst.fumo_item,inst.tz_level
        if fumo_item == "redgem" and tz_level == 9 then 
            local dt = 2 * FRAMES
            inst:StartThread(function()
                while inst._usetail:value() do
                    -- 导弹飞行轨迹会燃烧，存在4秒，
                    SpawnAt("tz_rpg_redgem_fire",inst:GetPosition()):SetFire("small",4 + math.random() * 0.5)
                    Sleep(dt)
                    dt = math.max(0,dt - FRAMES)
                end
            end)
        end
    end)
    inst.components.complexprojectile.onupdatefn = function(inst,dt)
        dt = dt or FRAMES

        local self = inst.components.complexprojectile
        local x,y,z = inst:GetPosition():Get()
        local gaizhuang_item,fumo_item,tz_level = inst.gaizhuang_item,inst.fumo_item,inst.tz_level

        self.flying_time = (self.flying_time or 0) + dt 
        inst.Physics:SetMotorVel(inst.components.complexprojectile.horizontalSpeed,0,0)


        inst.hitted_targets = inst.hitted_targets or {}

        for k,v in pairs(TheSim:FindEntities(x,y,z,1.5,nil,{"INLIMBO","playerghost"},{"_combat","_inventoryitem","CHOP_workable","MINE_workable"})) do 
            if not inst.hitted_targets[v] then 
                if fumo_item == "greengem" then 
                    if v:HasTag("player") and v ~= self.attacker then 
                        inst.hitted_targets[v] = true
                        if inst.piercing then 
                            OnProjectileExplode(inst,self.attacker,v)
                        else
                            self:Hit(v)
                        end 
                        return true
                    end 
                elseif (self.attacker.components.combat:CanTarget(v) and not self.attacker.components.combat:IsAlly(v))
                        or ( v.components.workable 
                        and v.components.workable:CanBeWorked()
                        and (v.components.workable.action == ACTIONS.CHOP or v.components.workable.action == ACTIONS.MINE)) then 
                    inst.hitted_targets[v] = true
                    if inst.piercing then 
                        OnProjectileExplode(inst,self.attacker,v)
                    else
                        self:Hit(v)
                    end 
                    return true
                end
            end 
        end

        local mypos = inst:GetPosition()
        -- local max_dist = inst.charge_complete and 28 or 20
        local max_dist = inst.max_dist
        if self.flying_time >= 6 or (self.on_launch_pos:Dist(mypos) >= max_dist) then 
            self:Hit()
        end

        return true
    end


    return inst
end

local function projectile_fake_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile.onupdatefn = function(inst,dt)
        inst:Remove()
    end

    inst:DoTaskInTime(0,inst.Remove)

    return inst

end

local function progressbar_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("tz_rpg_progressbar")
    inst.AnimState:SetBuild("tz_rpg_progressbar")
    -- inst.AnimState:PlayAnimation("xuli_pre")
    inst.AnimState:HideSymbol("text")
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetLightOverride(1)

    inst.Transform:SetScale(1,0.01,1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.StartFX = function(inst)
        inst:StartThread(function()
            local acc = 3
            local length,height,speed = inst.Transform:GetScale()
            while height < 1 do     
                height = math.min(height + acc * FRAMES,1)
                inst.Transform:SetScale(length,height,speed)
                if height >= 0.75 then 
                    inst.AnimState:ShowSymbol("text")
                end
                Sleep(0)
            end
        end)
    end

    inst.SetPercent = function(inst,percent)
        inst.AnimState:SetPercent("xuli_loop",percent)
    end

    inst.KillFX = function(inst)
        inst.AnimState:PlayAnimation("xuli_pst")
        inst:ListenForEvent("animover",inst.Remove)
    end



    return inst
end

local function CreateBatteryClient()
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("tz_rpg_battery")
    inst.AnimState:SetBuild("tz_rpg_battery")
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetLightOverride(1)

    return inst
end

local function battery_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    
    inst._anim_name = net_string(inst.GUID,"inst._anim_name","anim_name_dirty")

    if not TheNet:IsDedicated() then 
        inst._anim = CreateBatteryClient()
        -- inst._anim.entity:SetParent(inst.entity)
        inst._anim:DoPeriodicTask(0,function()
            if TheCamera then 
                local vec = TheCamera:GetRightVec() * 1
                local pos = inst:GetPosition() + vec + Vector3(0,0.25,0)
                inst._anim.Transform:SetPosition(pos:Get())
            end 
        end)
        inst:ListenForEvent("onremove",function()
            inst._anim:Remove()
            inst._anim = nil 
        end)
        
        inst:ListenForEvent("anim_name_dirty",function()
            local val = inst._anim_name:value()
            if val == "hide" then 
                inst._anim:Hide()
            else
                inst._anim:Show()
                inst._anim.AnimState:PlayAnimation(val or "one")
            end 
        end)
    end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.anim_list = {
        "one","two","three","four","five","six","seven","eight","nine","ten","eleven"
    }

    inst.SetCount = function(inst,cnt)
        if cnt > 0 then
            inst._anim_name:set(inst.anim_list[cnt])
        else
            inst._anim_name:set("hide")
        end
    end
    inst:SetCount(10)

    return inst
end

local function reloadbar_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("tz_rpg_reload")
    inst.AnimState:SetBuild("tz_rpg_reload")
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetLightOverride(1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.SetPercent = function(inst,percent)
        inst.AnimState:SetPercent("zhuangtian",percent)
    end

    return inst
end

local function charge_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter() 
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("deer_ice_charge")
    inst.AnimState:SetBuild("deer_ice_charge")
    inst.AnimState:PlayAnimation("pre")
    inst.AnimState:PushAnimation("loop",true)
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(3)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then 
        return inst
    end 

    inst.persists = false

    inst.KillFX = function(inst)
        inst.AnimState:PlayAnimation("blast")
        inst:ListenForEvent("animover",inst.Remove)
    end

    return inst
end

local function fnfiredrop()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SetFire = function(inst,size,burntime)
        burntime = burntime or (6 + math.random() * 6)
        if size == "large" then 
            MakeLargeBurnable(inst, burntime)
            MakeLargePropagator(inst)
        elseif size == "medium" then 
            MakeMediumBurnable(inst, burntime)
            MakeMediumPropagator(inst)
        elseif size == "small" then 
            MakeSmallBurnable(inst,burntime)
            MakeSmallPropagator(inst)
        end

        --Remove the default handlers that toggle persists flag
        inst.components.burnable:SetOnIgniteFn(nil)
        inst.components.burnable:SetOnExtinguishFn(inst.Remove)
        inst.components.burnable:SetOnBurntFn(inst.Remove)
        inst.components.burnable:Ignite()
    end

    return inst
end

local function reticulelinefn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("tz_reticuleline")
    inst.AnimState:SetBuild("tz_reticuleline")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then 
        return inst
    end 

    inst.persists = false

    return inst
end

STRINGS.NAMES.TZ_RPG = "盖亚破坏炮"
STRINGS.RECIPE_DESC.TZ_RPG = "拥有摧毁星系的巨大力量"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_RPG = "蕴含惊人的能量！"
STRINGS.NAMES.TZ_RPG_EMPEROR = "『帝』盖亚破坏炮"

return Prefab("tz_rpg", fn, assets),
Prefab("tz_rpg_projectile", projectile_fn, assets),
Prefab("tz_rpg_projectile_fake", projectile_fake_fn, assets),
-- Prefab("tz_rpg_progressbar",progressbar_fn,assets),
Prefab("tz_rpg_battery",battery_fn,assets),
Prefab("tz_rpg_reloadbar",reloadbar_fn,assets),
-- Prefab("tz_rpg_charge_fx",charge_fn),
Prefab("tz_rpg_redgem_fire",fnfiredrop),
Prefab("tz_rpg_reticuleline",reticulelinefn),
TzUtil.CreateFx("tz_rpg_explode_small",{},"explode","explode","small_firecrackers",false,false,function(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/together/fire_cracker")
end),
TzUtil.CreateFx("tz_rpg_fx_armorbroke",{Asset("ANIM", "anim/lavaarena_sunder_armor.zip"),},"lavaarena_sunder_armor","lavaarena_sunder_armor","nil",false,true,function(inst)
    inst.AnimState:PlayAnimation("pre")
    inst.AnimState:PushAnimation("loop",true)

    inst.persists = false 

    inst.KillFX = function(inst)
        inst.AnimState:PlayAnimation("pst")
        inst:ListenForEvent("animover",inst.Remove)
    end
end),
TzDebuffUtil.CreateTzDebuff({
    prefab = "tz_rpg_debuff_bluegem_lv9",
    OnAttached = function(inst,target)
        target.components.locomotor:SetExternalSpeedMultiplier(inst,inst.prefab,0.7)
    end,
    OnDetached = function(inst,target)
        target.components.locomotor:RemoveExternalSpeedMultiplier(inst,inst.prefab)
    end,
    duration = 5,
}),
TzDebuffUtil.CreateTzDebuff({
    prefab = "tz_rpg_debuff_greengem_lv9",
    OnAttached = function(inst,target)
        target.components.combat.externaldamagetakenmultipliers:SetModifier(inst,0.65,inst.prefab)
    end,
    OnDetached = function(inst,target)
        target.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst,inst.prefab)
    end,
    duration = 15,
}),
TzDebuffUtil.CreateTzDebuff({
    prefab = "tz_rpg_debuff_purplegem",
    OnAttached = function(inst,target)
        inst.deepth = 0
        inst.ApplyDepth = function(inst,val)
            inst.deepth = math.max(inst.deepth,val)
            target.components.combat.externaldamagetakenmultipliers:SetModifier(inst,1+0.05 * inst.deepth,inst.prefab)
        end

        inst.fx = target:SpawnChild("tz_rpg_fx_armorbroke")
        inst.fx.Transform:SetPosition(0,2,0)
    end,
    OnDetached = function(inst,target)
        target.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst,inst.prefab)
        if inst.fx then 
            inst.fx:KillFX()
            inst.fx = nil 
        end 
    end,
    duration = 4,
})