local TzEntity = require("util/tz_entity")
local TzFh = require("util/tz_fh")

-- local old_CollidesWith = Physics.CollidesWith
-- Physics.CollidesWith = function(inst,)
    
-- end
local assets = {
    Asset("ANIM", "anim/tz_fhft.zip"),
    Asset("ANIM", "anim/tz_fhft_gift.zip"),
    -- Asset("ANIM", "anim/swap_tz_fhft.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fhft.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fhft.xml"),
    Asset("IMAGE", "images/inventoryimages/tz_fhft_gift.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fhft_gift.xml"),
}

local function HatClientFn(inst)
    TzFh.AddFhLevel(inst,true)
    TzFh.AddOwnerName(inst)
end

local function OnHitOther(owner,data)
    local target = data.target
    if target.components.health and target.components.health:IsDead() then
        local rand = target:HasTag("shadow") and 0.5 or 0.2
        local x,y,z = target:GetPosition():Get()
        if math.random() <= rand then
            SpawnAt("nightmarefuel",target).components.inventoryitem:DoDropPhysics(x,y,z,true)
        end
        if target.components.health.maxhealth >= 2000 then
            if math.random() <= 0.5 then
                SpawnAt("tz_fhft_gift",target).components.inventoryitem:DoDropPhysics(x,y,z,true)
            end
        end
    end
end

local function HatServerFn(inst)
    TzFh.MakeWhiteList(inst)
    
    inst.components.equippable.dapperness = -18 / 54
    inst.components.equippable.walkspeedmult = 1.25

    inst._on_new_state = function(owner,data)
        if data.statename == "emote" and owner.sg:HasStateTag("dancing") then
            local val = owner.components.health.currenthealth * 0.9
            local x,y,z = owner.Transform:GetWorldPosition()
            owner.components.health:DoDelta(-val)

            SpawnAt("groundpound_fx",owner)
            SpawnAt("groundpoundring_fx",owner)

            for k,v in pairs(TheSim:FindEntities(x,y,z,12,nil,{"INLIMBO"},nil)) do
                if v.components.workable ~= nil
                    and v.components.workable:CanBeWorked()
                    and v.components.workable.action ~= ACTIONS.NET then    

                    v.components.workable:Destroy(owner)

                elseif v.components.health and v.components.combat and not owner.components.combat:IsAlly(v) then
                    v.components.combat:GetAttacked(owner,(owner.components.health.maxhealth - owner.components.health.currenthealth) * 10)
                end

                -- For Debug
                -- if v.components.workable then
                --     print("Ft find workable:",v,"is monster?",v.monster)
                --     print(v.components.workable:CanBeWorked(),v.components.workable.action)
                -- end
            end
        end
    end

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(1000,0.15)

    TzFh.AddTraderComponent(inst)
    TzFh.SetReturnSpiritualism(inst)
    

    inst:ListenForEvent("equipped",function(inst,data)
        -- data.owner.Transform:SetScale(1.5,1.5,1.5)
        if inst.consume_naijiu_task then
            inst.consume_naijiu_task:Cancel()
        end
        local max_time = 3840
        local max_condition = inst.components.armor.condition
        inst.consume_naijiu_task = inst:DoPeriodicTask(0,function()
            local damage_amount = FRAMES * max_condition / max_time
            inst.components.armor:SetCondition(inst.components.armor.condition - damage_amount)
        end)
        inst:ListenForEvent("newstate",inst._on_new_state,data.owner)
    end)

    inst:ListenForEvent("unequipped",function(inst,data)
        -- data.owner.Transform:SetScale(1,1,1)
        if inst.consume_naijiu_task then
            inst.consume_naijiu_task:Cancel()
        end
        inst.consume_naijiu_task = nil 
        inst:RemoveEventCallback("newstate",inst._on_new_state,data.owner)
    end)

end

local function GiftClientFn(inst)
    
end

local function OnUnwrapped(inst, pos, doer)

    local loottable = {
        {"fuhua_nine_zhou",1},
        {"kanlu_mountain_fuhuo_festival",1},
        {"tz_pills",10},
        {"shadow_throne",10},
    }

    for k, v in pairs(loottable) do
        if math.random() <= 0.25 then
            for i=1,v[2] do
                SpawnAt(v[1],pos).components.inventoryitem:OnDropped(true, .5)
            end
        end
    end


    if doer ~= nil and doer.SoundEmitter ~= nil then
        doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
    end

    SpawnAt("gift_unwrap",inst)
    inst:Remove()
end

local function GiftServerFn(inst)
    inst:AddComponent("unwrappable")
    inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
end


return TzEntity.CreateNormalHat({
    assets = assets,
    prefabname = "tz_fhft",
    tags = {"tz_fanhao","tz_fhft","tz_no_attacked_sg"},
    bank = "tz_fhft",
    build = "tz_fhft",
    anim = "idle",

    clientfn = HatClientFn,
    serverfn = HatServerFn,

    equippable_data = {
        owner_listeners = {
            {"onhitother",OnHitOther},
        }
    },

    hat_data = {
        onequip_anim_override = function()
            
        end,
    }
}),TzEntity.CreateNormalInventoryItem({
    assets = assets,
    prefabname = "tz_fhft_gift",
    tags = {"tz_fhft_gift"},
    bank = "tz_fhft_gift",
    build = "tz_fhft_gift",
    anim = "idle",

    clientfn = GiftClientFn,
    serverfn = GiftServerFn,
})