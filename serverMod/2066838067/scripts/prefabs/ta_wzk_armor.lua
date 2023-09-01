local assets =
{
    Asset("ANIM", "anim/ta_wzk_armor.zip"),
    Asset("ANIM", "anim/ta_wzk_armor_frontfx.zip"),
    Asset("ANIM", "anim/ta_wzk_armor_backfx.zip"),
    Asset("ANIM", "anim/ta_wzk_armor_sidefx.zip"),
    Asset("ANIM", "anim/tz_wzk_armor_fx.zip"),
    Asset("ATLAS", "images/inventoryimages/ta_wzk_armor.xml"),
    Asset("IMAGE", "images/inventoryimages/ta_wzk_armor.tex"),
}

local function onremove(inst)
    for k, v in pairs(inst.addbuff) do
		if  k  and k.components.tz_wzk_hd  then 
            if k.components.tz_wzk_hd:HasHD() then
                k.components.tz_wzk_hd:EndHd()
            end	
		end
    end
    inst.addbuff = {}
end

local function setname(inst)
    local name = "王之铠 : 浩瀚"
    name = name.."\n已装填 "..(9999+inst.nengliang).." 能量"
    name = name.."\n浩瀚空间充盈 "..inst.jishu.." 点"
    inst.components.named:SetName(name)

    if inst.jishu >= (9999+inst.nengliang) then
        local damage = inst.jishu
        local owner = inst.components.inventoryitem:GetGrandOwner()
        SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.components.container:DropEverythingWithTag("irreplaceable")
        inst:Remove()
        if owner and owner.components.combat then
            owner.components.combat:GetAttacked(nil,damage)
        end
    end
end

local function Oncheckbuff(inst,nofx)
    if inst.components.equippable:IsEquipped() and inst.nengliang > 0 then
        local x, y, z = inst.Transform:GetWorldPosition() 
        for i, v in ipairs(AllPlayers) do
            if inst:IsValid() and v:IsValid() and (v:GetDistanceSqToInst(inst) < 400) and not inst.addbuff[v] then
                if v.components.tz_wzk_hd:CanSpawnHd() then
                    v.components.tz_wzk_hd:SpawnHd(inst,nofx)
                    inst.addbuff[v] = true
                end
            end
        end
        for k, v in pairs(inst.addbuff) do
            if k:IsValid() then 
                if inst:IsValid() and k.components.health and (k.components.health:IsDead() or k:GetDistanceSqToInst(inst) > 10000) then
                    if k.components.tz_wzk_hd:HasHD() then
                        k.components.tz_wzk_hd:EndHd()
                    end	
                end
            else
                inst.addbuff[k] = nil
            end
        end
    end
    if inst.jishu > 0 then
        inst.jishu = math.max(inst.jishu - 1 ,0)
        setname(inst)
    end
end

local function OnBlocked(owner)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_body", "ta_wzk_armor", "swap_body")

    if not inst.frontfx then
        inst.frontfx = SpawnPrefab("ta_wzk_armor_frontfx")
        inst.frontfx.entity:SetParent(owner.entity)
        inst.frontfx.entity:AddFollower()
        inst.frontfx.Follower:FollowSymbol(owner.GUID, "swap_body", 0, -50, 0)
    end
    if not inst.sidefx then
        inst.sidefx = SpawnPrefab("ta_wzk_armor_sidefx")
        inst.sidefx.entity:SetParent(owner.entity)
        inst.sidefx.entity:AddFollower()
        inst.sidefx.Follower:FollowSymbol(owner.GUID, "swap_body", -10, 0, 0)
        inst.sidefx:SetOwner(owner)
    end
    inst:ListenForEvent("blocked", OnBlocked, owner)
    Oncheckbuff(inst,true)
    owner:SpawnChild("tz_wzk_armor_lightfx")
    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
end

local function onunequip(inst, owner)
    if inst.frontfx then
        inst.frontfx:Remove()
        inst.frontfx  = nil
    end
    if inst.sidefx then
        inst.sidefx:Remove()
        inst.sidefx  = nil
    end
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    onremove(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end
local function ondamaged(inst,damage)
    if damage and type(damage) == "number" then
        inst.jishu =  inst.jishu + math.floor(damage+0.5)
        setname(inst)
    end
end

local function onitemchange(inst)
	local container = inst.components.container
    local hashuij = false
    local nengliang = 0
	for i = 1,container:GetNumSlots() do
        local item = container:GetItemInSlot(i)
        if item ~= nil and item.prefab == "tz_pugalisk_crystal" and item.level > 0  then
            hashuij = true
            nengliang = math.floor(nengliang + 1000+100*item.level*(1-item.level/(item.level+100))+0.5)
        end
	end
    if not hashuij then
        onremove(inst)
    end
    inst.nengliang = nengliang
    setname(inst)
end

local function OnSave(inst, data)
    data.jishu = inst.jishu
end
local function OnLoad(inst, data)
    if data ~= nil then
        if data.jishu ~= nil then
            inst.jishu = data.jishu
            setname(inst)
        end
    end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ta_wzk_armor")
    inst.AnimState:SetBuild("ta_wzk_armor")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hide_percentage")

    inst.foleysound = "dontstarve/movement/foley/metalarmour"

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.jishu  = 0
    inst.nengliang = 0
	inst.addbuff = {}
    inst.buffs = inst:DoPeriodicTask(1, Oncheckbuff)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ta_wzk_armor.xml"

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("ta_wzk_armor")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(9999, 0.75)
    inst.components.armor.indestructible = true

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst.components.equippable.insulated = true

    inst:AddComponent("named")
    inst:DoTaskInTime(0,function()
        setname(inst)
    end)

    MakeHauntableLaunch(inst)

    inst:ListenForEvent("onremove", onremove)
    inst:ListenForEvent("armordamaged", ondamaged)
    inst:ListenForEvent("itemget", onitemchange)
	inst:ListenForEvent("itemlose", onitemchange)
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    return inst
end

local function fx1()
    local inst = CreateEntity()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
    inst.AnimState:SetBank("ta_wzk_armor_backfx")
    inst.AnimState:SetBuild("ta_wzk_armor_backfx")
    inst.AnimState:PlayAnimation("idle",true)
	inst.AnimState:SetFinalOffset(-3)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetCanSleep(false)
    inst.persists = false

    return inst
end

local function fx2()
    local inst = CreateEntity()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
    inst.AnimState:SetBank("ta_wzk_armor_frontfx")
    inst.AnimState:SetBuild("ta_wzk_armor_frontfx")
    inst.AnimState:PlayAnimation("idle",true)
	inst.AnimState:SetFinalOffset(1)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetCanSleep(false)
    inst.persists = false

    return inst
end

local function setsideowner(inst,owner)
    inst:ListenForEvent("mounted", function()
        inst:Hide()
    end,owner)
    inst:ListenForEvent("dismounted", function()
        inst:Show()
    end,owner)
    if owner.components.rider and owner.components.rider:IsRiding() then
        inst:Hide()
    end
end
local function fx3()
    local inst = CreateEntity()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
    inst.AnimState:SetBank("ta_wzk_armor_sidefx")
    inst.AnimState:SetBuild("ta_wzk_armor_sidefx")
    inst.AnimState:PlayAnimation("idle",true)
	inst.AnimState:SetFinalOffset(1)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetCanSleep(false)
    inst.persists = false
    inst.SetOwner = setsideowner
    return inst
end

local function OnTimerDone(inst, data)
    if inst.player ~= nil and inst.player:IsValid() and inst.player.components.tz_wzk_hd:IsHD(inst) then
        inst.player.components.tz_wzk_hd:EndHd(inst)
    else
        inst:DoEnd()
    end
end

local function doend(inst)
    inst.canxishou = false
    inst.AnimState:PlayAnimation("close")
    inst:ListenForEvent("animover", inst.Remove)
end

local function setowner(inst,owner)
    inst:ListenForEvent("mounted", function()
        inst.Transform:SetScale(1.8, 1.8, 1.8)
    end,owner)
    inst:ListenForEvent("dismounted", function()
        inst.Transform:SetScale(1, 1, 1 )
    end,owner)
    if owner.components.rider and owner.components.rider:IsRiding() then
        inst.Transform:SetScale(1.8, 1.8, 1.8)
    end
end

local function takedamage(inst,damage)
    inst.absorb =  inst.absorb - damage
    if inst.absorb <= 0 then
        OnTimerDone(inst)
    end
end

local function fx4()
    local inst = CreateEntity()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:AddSoundEmitter()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tz_wzk_armor_fx")
    inst.AnimState:SetBuild("tz_wzk_armor_fx")
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("loop")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetFinalOffset(1)

    if not TheWorld.ismastersim then
        return inst
    end
    inst.SoundEmitter:PlaySound("tz_wzk_armor_sound/tz_wzk_armor_sound/open")
    inst.absorb = 0
    inst.canxishou = true
    inst:AddComponent("timer")
    inst.components.timer:StartTimer("livetime", 360)
    inst:ListenForEvent("timerdone", OnTimerDone)

    inst.entity:SetCanSleep(false)
    inst.persists = false
    inst.DoEnd = doend
    inst.SetOwner = setowner
    inst.TakeDamage = takedamage

    return inst
end

local function fx5()
    local inst = CreateEntity()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tz_wzk_armor_fx")
    inst.AnimState:SetBuild("tz_wzk_armor_fx")
    inst.AnimState:PlayAnimation("light")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetFinalOffset(1)

    if not TheWorld.ismastersim then
        return inst
    end
    inst.SoundEmitter:PlaySound("tz_wzk_armor_sound/tz_wzk_armor_sound/light")
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst:ListenForEvent("animover", inst.Remove)
    return inst
end
--[[
         a = SpawnPrefab("tz_wzk_armor_fx")
         a.entity:SetParent(ThePlayer.entity)
         a.entity:AddFollower()
         a.Follower:FollowSymbol(ThePlayer.GUID, "swap_body", 0, 40, 0)

         a = ThePlayer:SpawnChild("tz_wzk_armor_fx")
          a.Transform:SetScale(1.8, 1.8, 1.8)

          ThePlayer.components.tz_wzk_hd:SpawnHd()
          骑牛隐藏侧面的
]]
return Prefab("ta_wzk_armor", fn, assets),
Prefab("ta_wzk_armor_backfx", fx1),
Prefab("ta_wzk_armor_frontfx", fx2),
Prefab("ta_wzk_armor_sidefx", fx3),
Prefab("tz_wzk_armor_fx", fx4),
Prefab("tz_wzk_armor_lightfx", fx5)
