local function onequip(inst, owner)
    if owner:HasTag("kurumi") then
        owner:AddTag("kur_knife_builder")
        owner.components.krm_ability:SetSkinKey("kurumi2")
        --owner.krm_armor_task = owner:DoPeriodicTask(10, function()
           -- owner.components.health:DoDelta(2, true, "krm_heal")
        --end)     
    end
end

local function onunequip(inst, owner)
    if owner:HasTag("kurumi") then
        owner:RemoveTag("kur_knife_builder")
        owner.components.krm_ability:SetSkinKey("kurumi")
    end

    --if owner.krm_armor_task then
        --owner.krm_armor_task:Cancel()
        --owner.krm_armor_task = nil
    --end    
end

local function Recall_GetActionVerb(inst, doer, target)
    return inst:HasTag("recall_unmarked") and "RECALL_MARK"
            or "RECALL"
end

local PocketWatchCommon = require "prefabs/pocketwatch_common"
local function DelayedMarkTalker(player)
    -- if the player starts moving right away then we can skip this
    if player.sg == nil or player.sg:HasStateTag("idle") then 
        player.components.talker:Say(GetString(player, "ANNOUNCE_POCKETWATCH_MARK"))
    end 
end

local function Warp_DoCastSpell(inst, doer)
    local tx, ty, tz = doer.components.positionalwarp:GetHistoryPosition(false)
    if tx ~= nil then
        inst.components.rechargeable:Discharge(TUNING.POCKETWATCH_WARP_COOLDOWN)
        doer.sg.statemem.warpback = {dest_x = tx, dest_y = ty, dest_z = tz}
        return true
    end

    return false, "WARP_NO_POINTS_LEFT"
end

local WARP_WATCH_TAGS = {"pocketwatch_warp", "pocketwatch_warp_casting"}

local function warp_hidemarker(inst)
    if inst.marker_owner ~= nil and inst.marker_owner:IsValid() then
        inst.marker_owner:PushEvent("hide_warp_marker")
    end
    inst.marker_owner = nil
end


local function warp_showmarker(inst)
    warp_hidemarker(inst)

    inst.marker_owner = inst.components.inventoryitem:GetGrandOwner()
    if inst.marker_owner ~= nil then
        inst.marker_owner:PushEvent("show_warp_marker")
    end
end

local function OnCharged(inst)
    if inst.components.pocketwatch ~= nil then
        inst.components.pocketwatch.inactive = true
        inst.AnimState:PlayAnimation("idle")
    end
end

local function OnDischarged(inst)
    if inst.components.pocketwatch ~= nil then
        inst.components.pocketwatch.inactive = false
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("krm_armor")
    inst:AddTag("hide_percentage")
    inst:AddTag("pocketwatch_castfrominventory")
    inst:AddTag("pocketwatch_warp_casting")

    inst.AnimState:SetBank("krm_items")
    inst.AnimState:SetBuild("krm_items")
    inst.AnimState:PlayAnimation("krm_armor")

    MakeInventoryPhysics(inst)    
    MakeInventoryFloatable(inst, "small", 0.2)

    inst.GetActionVerb_CAST_POCKETWATCH = "WARP"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.defense = 0.5

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/krm_items.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.restrictedtag = "kurumi" 


	inst:AddComponent("planardefense")
	inst.components.planardefense:SetBaseDefense(10)
		
    inst:AddComponent("pocketwatch")
    inst.components.pocketwatch.DoCastSpell = Warp_DoCastSpell

    inst:ListenForEvent("onputininventory", warp_showmarker)
    inst:ListenForEvent("onownerputininventory", warp_showmarker)
    inst:ListenForEvent("ondropped", warp_hidemarker)
    inst:ListenForEvent("onownerdropped", warp_hidemarker)
    inst:ListenForEvent("onremove", warp_hidemarker)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
    inst.components.rechargeable:SetOnChargedFn(OnCharged)

    inst:AddComponent("armor")
    inst.components.armor:InitIndestructible(inst.defense)

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(function(item, fixer, giver)
        local result = false
        if fixer.prefab == "minotaurhorn" and inst.defense < 0.8 then
            inst.defense = math.min(inst.defense + 0.05, 0.8)
            inst.components.armor:InitIndestructible(inst.defense)
            result = true
        end
        return result
    end)

    inst.OnSave = function(inst, data)
        data.defense = inst.defense
    end

    inst.OnLoad = function(inst, data)
        if data and data.defense then
            inst.defense = data.defense or 0.5
            inst.components.armor:InitIndestructible(inst.defense)
        end
    end

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("krm_armor", fn)
