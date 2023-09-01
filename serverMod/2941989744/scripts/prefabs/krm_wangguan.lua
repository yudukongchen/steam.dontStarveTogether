local containers = require "containers"
local cooking = require("cooking")
local params = containers.params

params["krm_wangguan"] = {
    widget = {
        slotpos = {Vector3(-2, 18, 0)},
        slotbg = {{
            image = "spore_slot.tex",
            atlas = "images/hud2.xml"
        }},
        animbank = "ui_alterguardianhat_1x1",
        animbuild = "ui_alterguardianhat_1x1",
        pos = Vector3(106, 40, 0)
    },
    acceptsstacks = false,
    type = "hand_inv",
    excludefromcrafting = true
}

for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local assets = {}

local prefabs = {"alterguardian_hat_equipped", "alterguardianhatlight", "alterguardianhat_projectile",
                 "alterguardianhatshard"}

local function OnCooldown(inst)
    inst._cdtask = nil
end
local RESISTANCES = {"_combat", "explosive", "quakedebris", "caveindebris", "trapdamage"}

local function OnBlocked(owner, data, inst)
    if inst._cdtask == nil and data ~= nil and not data.redirected then
        inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)

        SpawnPrefab("bramblefx_armor"):SetFXOwner(owner)

        if owner.SoundEmitter ~= nil then
            owner.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
        end
    end
end

local function ShouldResistFn(inst)
    if not inst.components.equippable:IsEquipped() then
        return false
    end
    local owner = inst.components.inventoryitem.owner
    return owner ~= nil and not inst.resisttask
end

local function OnResistDamage(inst, damage_amount)
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    owner:SpawnChild("shadow_shield" .. math.random(1, 6))
    inst.resisttask = inst:DoTaskInTime(5, function()
        if inst.heianxinzang ~= nil then
            inst.resisttask = nil
        end
    end)
end

local function OnPutInInventory(inst)
    inst.components.container:Close()
end

local function OnDropped(inst)
    inst.Light:Enable(true)
end

local function OnPickup(inst)
    inst.Light:Enable(true)
end

local function simple_onequiptomodel(inst, owner, from_ground)

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function SetWereDrowning(inst, mode)
    if inst.components.drownable ~= nil then
        if mode then
	
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

local function DoRipple(inst)
    if inst ~= nil then
        if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() and inst.sg and
            inst.sg:HasStateTag("moving") then
            if inst.components.rider ~= nil and inst.components.rider:IsRiding() or math.random(1, 100) <= 4 or
                math.random(1, 100) <= 8 then
                SpawnPrefab("weregoose_splash").entity:SetParent(inst.entity)
            elseif math.random(1, 100) <= 12 then
                SpawnPrefab("weregoose_splash_med" .. tostring(math.random(2))).entity:SetParent(inst.entity)
            elseif math.random(1, 100) <= 20 then
                SpawnPrefab("weregoose_splash_less" .. tostring(math.random(2))).entity:SetParent(inst.entity)
            else
                SpawnPrefab("weregoose_ripple" .. tostring(math.random(2))).entity:SetParent(inst.entity)
            end
        end
    end
end

local function OnEquip(inst, owner)

    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
    -- owner:PushEvent("equipskinneditem", inst:GetSkinName())
    owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", inst.GUID, "krm_wangguan")
    else
    owner.AnimState:OverrideSymbol("swap_hat", "krm_wangguan", "swap_hat")
    end

    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    owner.AnimState:Show("HEAD")
    owner.AnimState:Hide("HEAD_HAT")

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end

    if owner.wanguang == nil then
        owner.wanguang = owner:DoPeriodicTask(0.1, function()
            local item = inst.components.container:GetItemInSlot(1)
            if inst and item and item.prefab == "shadowheart" and inst.heianxinzang == nil then
                inst.heianxinzang = 1
                inst.resisttask = nil
            elseif inst and item == nil or item and item.prefab ~= "shadowheart" then
                inst.heianxinzang = nil
                inst.resisttask = 1
            end
            if inst and item and item.prefab == "shroom_skin" and inst.kuahaikaiqi == nil then
                inst.kuahaikaiqi = 1
                if owner.kuahai == nil then
                    owner.kuahai = owner:DoPeriodicTask(.15, function()
                        DoRipple(owner)
                        SetWereDrowning(owner, true)
						RemovePhysicsColliders(owner)
                    end, FRAMES)
                end
            elseif inst and item == nil and inst.kuahaikaiqi == 1 or item and item.prefab ~= "shroom_skin" and
                inst.kuahaikaiqi == 1 then
                inst.kuahaikaiqi = nil
                if owner.kuahai ~= nil then
                    SetWereDrowning(owner, false)
					ChangeToCharacterPhysics(owner)
                    owner.kuahai:Cancel()
                    owner.kuahai = nil
                end
            end
            if inst and item and item.prefab == "deerclops_eyeball" and inst.fangyugongnneg == nil then
                inst.fangyugongnneg = 1
                if inst.components.waterproofer then
                    inst.components.waterproofer:SetEffectiveness(1)
                end
            elseif inst and item == nil and inst.fangyugongnneg == 1 or item and item.prefab ~= "deerclops_eyeball" and
                inst.fangyugongnneg == 1 then
                inst.fangyugongnneg = nil
                if inst.components.waterproofer then
                    inst.components.waterproofer:SetEffectiveness(0)
                end
            end
            if inst and item and item.prefab == "alterguardianhatshard" and inst.shanghaizengfu == nil then
                inst.shanghaizengfu = 1
                if owner.components.combat then
                    owner.components.combat.externaldamagemultipliers:SetModifier("shanghaizengfu", 2.5)
                end
            elseif inst and item == nil and inst.shanghaizengfu == 1 or item and item.prefab ~= "alterguardianhatshard" and
                inst.shanghaizengfu == 1 then
                inst.shanghaizengfu = nil
                if owner.components.combat then
                    owner.components.combat.externaldamagemultipliers:RemoveModifier("shanghaizengfu")
                end
            end
            if inst and item and item.prefab == "dragon_scales" and inst.hujiafangyu == nil then
                inst.hujiafangyu = 1
                if inst.components.armor then
                    inst.components.armor:InitIndestructible(0.80)
                end
            elseif inst and item == nil and inst.hujiafangyu == 1 or item and item.prefab ~= "dragon_scales" and
                inst.hujiafangyu == 1 then
                inst.hujiafangyu = nil
                if inst.components.armor then
                    inst.components.armor:InitIndestructible(0)
                end
            end
            if inst and item and item.prefab == "townportaltalisman" and inst.fangzhifengsha == nil then
                inst.fangzhifengsha = 1
				if not inst:HasTag("goggles") then
				inst:AddTag("goggles")
				end	
            elseif inst and item == nil and inst.fangzhifengsha == 1 or item and item.prefab ~= "townportaltalisman" and
                inst.fangzhifengsha == 1 then
                inst.fangzhifengsha = nil
				if inst:HasTag("goggles") then
				inst:RemoveTag("goggles")
				end
            end
        end)
    end

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end

    if owner:HasTag("player") then
        inst:ListenForEvent("onhitother", inst._onhitfn, owner)
    end

end

local function _onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end

    if owner.components.skinner ~= nil then
        owner.components.skinner.base_change_cb = owner.old_base_change_cb
    end

    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end

    if owner.wanguang ~= nil then
        owner.wanguang:Cancel()
        owner.wanguang = nil
    end

    if owner.kuahai ~= nil then
		SetWereDrowning(owner, false)
		ChangeToCharacterPhysics(owner)
		owner.kuahai:Cancel()
        owner.kuahai = nil
    end
	
		inst.kuahaikaiqi = nil

      inst.shanghaizengfu = nil
	  
        if owner.components.combat then
            owner.components.combat.externaldamagemultipliers:RemoveModifier("shanghaizengfu")
        end
				
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end

    if owner:HasTag("player") then
        inst:RemoveEventCallback("onhitother", inst._onhitfn, owner)
    end
end

local COLOUR_TINT = {0.4, 0.2}
local MULT_TINT = {0.7, 0.35}
local function UpdateLightState(inst)
    local was_on = inst.Light:IsEnabled()
    if not inst.components.container:IsEmpty() then
        local item = inst.components.container:GetItemInSlot(1)
        local r = (item.prefab == MUSHTREE_SPORE_RED and 1) or 0
        local g = (item.prefab == MUSHTREE_SPORE_GREEN and 1) or 0
        local b = (item.prefab == MUSHTREE_SPORE_BLUE and 1) or 0
        inst.Light:SetColour(COLOUR_TINT[g + b + 1] + r / 3, COLOUR_TINT[r + b + 1] + g / 3,
            COLOUR_TINT[r + g + 1] + b / 3)
        inst.AnimState:SetMultColour(MULT_TINT[g + b + 1], MULT_TINT[r + b + 1], MULT_TINT[r + g + 1], 1)

        if not was_on then
            inst.Light:Enable(true)
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end
    else
        if was_on then
            inst.Light:Enable(false)
            inst.AnimState:ClearBloomEffectHandle()
        end
        inst.AnimState:SetMultColour(.7, .7, .7, 1)

    end
end

local function alterguardianhat_IsRed(inst)
    return inst.prefab == MUSHTREE_SPORE_RED
end
local function alterguardianhat_IsGreen(inst)
    return inst.prefab == MUSHTREE_SPORE_GREEN
end
local function alterguardianhat_IsBlue(inst)
    return inst.prefab == MUSHTREE_SPORE_BLUE
end

local alterguardianhat_colourtint = {0.4, 0.3, 0.25, 0.2, 0.15, 0.1}
local alterguardianhat_multtint = {0.7, 0.6, 0.55, 0.5, 0.45, 0.4}

local function alterguardianhat_animstatemult(animstate, r, g, b)
    animstate:SetMultColour(alterguardianhat_multtint[1 + g + b], alterguardianhat_multtint[r + 1 + b],
        alterguardianhat_multtint[r + g + 1], 1)
end

local function alterguardianhat_updatelight(inst)

    local num_sources = #inst.components.container:FindItems(function(item)
        return item:HasTag("spore")
    end)

    local r = #inst.components.container:FindItems(alterguardianhat_IsRed)
    local g = #inst.components.container:FindItems(alterguardianhat_IsGreen)
    local b = #inst.components.container:FindItems(alterguardianhat_IsBlue)

    if inst._light ~= nil and inst._light:IsValid() then
        if r > 0 or g > 0 or b > 0 then
            inst._light.Light:SetColour(alterguardianhat_colourtint[1 + g + b] + r / 11,
                alterguardianhat_colourtint[r + 1 + b] + g / 11, alterguardianhat_colourtint[r + g + 1] + b / 11)
        else
            inst._light.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
        end
    end

    alterguardianhat_animstatemult(inst.AnimState, r, g, b)

    -- if inst._front and inst._front:IsValid() then
        -- alterguardianhat_animstatemult(inst._front.AnimState, r, g, b)
    -- end

    -- if inst._back and inst._back:IsValid() then
        -- alterguardianhat_animstatemult(inst._back.AnimState, r, g, b)
    -- end

end

local function alterguardian_activate(inst, owner)
    if inst._is_active then
        return
    end
    inst._is_active = true

    if inst._task ~= nil then
        inst._task:Cancel()
        inst._task = nil
    end

    -- if inst._front == nil then
        -- inst._front = SpawnPrefab("alterguardian_hat_equipped")
        -- inst._front:OnActivated(owner, true)
    -- end
    -- if inst._back == nil then
        -- inst._back = SpawnPrefab("alterguardian_hat_equipped")
        -- inst._back:OnActivated(owner, false)
    -- end

    -- local skin_build = inst:GetSkinBuild()
    -- if skin_build then
        -- inst._front:SetSkin(skin_build, inst.GUID)
        -- inst._back:SetSkin(skin_build, inst.GUID)
    -- end

    if inst._light == nil then
        inst._light = SpawnPrefab("alterguardianhatlight")
        inst._light.entity:SetParent(owner.entity)
    end
    alterguardianhat_updatelight(inst)
end

local function alterguardian_deactivate(inst, owner)
    if not inst._is_active then
        return
    end
    inst._is_active = false

    if inst._light ~= nil then
        inst._light:Remove()
        inst._light = nil
    end

    -- if inst._front ~= nil then
        -- inst._front:OnDeactivated()
        -- inst._front = nil
        -- inst._task = inst:DoTaskInTime(8 * FRAMES, function()
            -- OnEquip(inst, owner)
            -- inst._task = nil
        -- end)
    -- else
        -- OnEquip(inst, owner)
    -- end

    -- if inst._back ~= nil then
        -- inst._back:OnDeactivated()
        -- inst._back = nil
    -- end
end

local function alterguardian_onsanitydelta(inst, owner)
    local sanity = owner.components.sanity ~= nil and owner.components.sanity:GetPercentWithPenalty() or 0
    if sanity >= 0 then
        alterguardian_activate(inst, owner)
    else
        alterguardian_deactivate(inst, owner)
    end
end

local function alterguardian_spawngestalt_fn(inst, owner, data)
    if not inst._is_active then
        return
    end

    if owner ~= nil and (owner.components.health == nil or not owner.components.health:IsDead()) then
        local target = data.target
        if target and target ~= owner and target:IsValid() and
            (target.components.health == nil or not target.components.health:IsDead() and not target:HasTag("structure") and
                not target:HasTag("wall")) then

            if data.weapon ~= nil and data.projectile == nil and
                (data.weapon.components.projectile ~= nil or data.weapon.components.complexprojectile ~= nil or
                    data.weapon.components.weapon:CanRangedAttack()) then
                return
            end

            local x, y, z = target.Transform:GetWorldPosition()

            local gestalt = SpawnPrefab("alterguardianhat_projectile")
            local r = GetRandomMinMax(3, 5)
            local delta_angle = GetRandomMinMax(-90, 90)
            local angle = (owner:GetAngleToPoint(x, y, z) + delta_angle) * DEGREES
            gestalt.Transform:SetPosition(x + r * math.cos(angle), y, z + r * -math.sin(angle))
            gestalt:ForceFacePoint(x, y, z)
            gestalt:SetTargetPosition(Vector3(x, y, z))
            gestalt.components.follower:SetLeader(owner)

        end
    end
end

local function alterguardian_onequip(inst, owner)
    OnEquip(inst, owner)

    -- inst.alterguardian_spawngestalt_fn = function(_owner, _data)
        -- alterguardian_spawngestalt_fn(inst, _owner, _data)
    -- end
    -- inst:ListenForEvent("onattackother", inst.alterguardian_spawngestalt_fn, owner)

    inst._onsanitydelta = function()
        alterguardian_onsanitydelta(inst, owner)
    end
    inst:ListenForEvent("sanitydelta", inst._onsanitydelta, owner)

    local sanity = owner.components.sanity ~= nil and owner.components.sanity:GetPercent() or 0
    if sanity >= 0 then
        alterguardian_activate(inst, owner)
    end

    if inst.components.container ~= nil and inst.keep_closed ~= owner.userid then
        inst.components.container:Open(owner)
    end
end

local function alterguardian_onunequip(inst, owner)
    inst._is_active = false

    inst:RemoveEventCallback("sanitydelta", inst._onsanitydelta, owner)
    -- inst:RemoveEventCallback("onattackother", inst.alterguardian_spawngestalt_fn, owner)

    if inst._light ~= nil then
        inst._light:Remove()
        inst._light = nil
    end

    _onunequip(inst, owner)
    -- if inst._front ~= nil then
        -- inst._front:Remove()
        -- inst._front = nil
    -- end
    -- if inst._back ~= nil then
        -- inst._back:Remove()
        -- inst._back = nil
    -- end

    if inst.components.container ~= nil then
        inst.keep_closed = inst.components.container.opencount == 0 and owner.userid or nil
        inst.components.container:Close()
    end
end

local function alterguardianhat_onremove(inst)
    -- if inst._front ~= nil and inst._front:IsValid() then
        -- inst._front:Remove()
    -- end
    -- if inst._back ~= nil and inst._back:IsValid() then
        -- inst._back:Remove()
    -- end
end

local function krm_wangguanlight()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(.8)
    inst.Light:SetRadius(4)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function IsValidTarget(inst)
	return  inst.components.health ~= nil and
	not inst.components.health:IsDead() and inst.components.combat ~= nil
end
local function SpawnItems(target,r,num,lsit,fn)
    if target == nil or lsit == nil or #lsit <= 0 then return end 
    local x,y,z = target.Transform:GetWorldPosition()
	local start = math.random(-180,180)
    for k=1,num do
        local angle = k * 2 * PI / num + start
        local item = SpawnPrefab(lsit[math.random(#lsit)])
		item.Transform:SetPosition(r*math.cos(angle)+x, 2.5, r*math.sin(angle)+z)
        if fn ~= nil and type(fn) == "function" then 
            fn(item, target, k)
        end
    end 
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()
	
    MakeInventoryPhysics(inst)
	
    inst.MiniMapEntity:SetIcon("krm_wangguan.tex")

    inst:AddTag("open_top_hat")
    inst:AddTag("gestaltprotection")
    inst:AddTag("hat")
    inst:AddTag("hide_percentage")
	
    inst.AnimState:SetBank("krm_wangguan")
    inst.AnimState:SetBuild("krm_wangguan")
    inst.AnimState:PlayAnimation("anim",true)

    inst.Light:SetRadius(0.5)
    inst.Light:SetFalloff(0.85)
    inst.Light:SetIntensity(0.5)
    inst.Light:Enable(true)
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(alterguardian_onequip)
    inst.components.equippable:SetOnUnequip(alterguardian_onunequip)
    inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable:SetOnEquipToModel(simple_onequiptomodel)
    inst.components.equippable.dapperness = 6 / 60
    inst.components.equippable.walkspeedmult = 1.25

    inst:AddComponent("inventoryitem")
    --------这里设置物品栏
    inst.components.inventoryitem.imagename = "krm_wangguan"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/krm_wangguan.xml"
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPickupFn(OnPickup)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("krm_wangguan")
    inst.components.container.acceptsstacks = false
    -- inst.components.container.canbeopened = false
 -- inst.components.tool:SetAction(ACTIONS.NET)
    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    inst:AddComponent("armor")
    inst.components.armor:AddWeakness("beaver", TUNING.BEAVER_WOOD_DAMAGE)
    inst.components.armor:InitIndestructible(0)

    inst:AddComponent("resistance")
    inst.components.resistance:SetShouldResistFn(ShouldResistFn)
    inst.components.resistance:SetOnResistDamageFn(OnResistDamage)

    for i, v in ipairs(RESISTANCES) do
        if inst.components.resistance then
            inst.components.resistance:AddResistance(v)
        end
    end

    inst._onblocked = function(owner, data)
        OnBlocked(owner, data, inst)
    end

    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0)

    MakeHauntableLaunchAndPerish(inst)

    inst:ListenForEvent("itemget", alterguardianhat_updatelight)
    inst:ListenForEvent("itemlose", alterguardianhat_updatelight)
    inst:ListenForEvent("onremove", alterguardianhat_onremove)

    inst:ListenForEvent("itemget", UpdateLightState)
    inst:ListenForEvent("itemlose", UpdateLightState)

    inst._onhitfn = function(player,data)
        if data.target ~= nil  and IsValidTarget(data.target) then
            if not (data and data.stimuli == "krm_fuyoupao") then
                SpawnItems(data.target,6,3,{"krm_fuyoupao"},function(inst1,target)
                    inst1:SetTarget(data.target,player)
                end)
            end
        end
    end
    return inst
end

local assets =
{
    Asset("ANIM", "anim/krm_wangguan.zip"),
    Asset("ATLAS", "images/inventoryimages/krm_wangguan.xml"),
    Asset("IMAGE", "images/inventoryimages/krm_wangguan.tex"),
}

mpatubiaozhuce("images/inventoryimages/krm_wangguan.xml")

return Prefab("krm_wangguan", fn, assets, prefabs), Prefab("krm_wangguanlight", krm_wangguanlight)
