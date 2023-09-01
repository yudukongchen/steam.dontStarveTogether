local TzEntity = require("util/tz_entity")
local TzFh = require("util/tz_fh")
local TzWeaponSkill = require("util/tz_weaponskill")

local assets = {
    Asset("ANIM", "anim/tz_fh_fishgirl.zip"),
    Asset("ANIM", "anim/swap_tz_fh_fishgirl.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_fishgirl.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_fishgirl.xml"),

    Asset("ANIM", "anim/lavaarena_heal_projectile.zip"),
    Asset("ANIM", "anim/tz_fh_fishgirl_projectile.zip"),

    
    Asset("ANIM", "anim/elza_dragon.zip"),
}

local function TzFhFishgirlClient(inst)
    TzFh.AddOwnerName(inst)
    TzFh.AddFhLevel(inst,true)
    inst.projectiledelay = 3 * FRAMES

    TzWeaponSkill.AddAoetargetingClient(inst,"point",nil,12)
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

local function OnAttackFn(inst,attacker,target)
    if target.components.freezable then
        target.components.freezable:AddColdness(1,3)
    end
end

local function TzFhFishgirlServer(inst)
    inst.components.weapon:SetProjectile("tz_fh_fishgirl_projectile")
    inst.components.weapon:SetOnAttack(OnAttackFn)
    -- inst.components.weapon:

    inst.components.equippable.walkspeedmult = 1.3

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)

    TzFh.MakeWhiteList(inst)
    
    TzFh.AddFueledComponent(inst)
    TzWeaponSkill.AddAoetargetingServer(inst,function(inst,doer,pos)
        SpawnAt("tz_fh_fishgirl_dragonbite",pos).owner = doer
    end)
    

    inst:ListenForEvent("equipped",OnEquip)
    inst:ListenForEvent("unequipped",OnUnEquip)
end

--------------------------------------------------------------------------------------------

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

local function OnUpdateProjectileTail(inst, bank, build, speed, lightoverride, addcolour, multcolour, hitfx, tails)
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
        local offsradius = math.random() * .2 + .2
        local hoffset = math.cos(offsangle) * offsradius
        local voffset = math.sin(offsangle) * offsradius
        tail.Transform:SetPosition(x + math.sin(rot) * hoffset, y + voffset, z + math.cos(rot) * hoffset)
        tail.Physics:SetMotorVel(speed * (.2 + math.random() * .3), 0, 0)
        tails[tail] = true
        inst:ListenForEvent("onremove", function(tail) tails[tail] = nil end, tail)
        tail:ListenForEvent("onremove", function(inst)
            tail.Transform:SetRotation(tail.Transform:GetRotation() + math.random() * 30 - 15)
        end, inst)
    end
end

local function OnProjectileHit(inst,attacker, target)
    SpawnAt("tz_fh_fishgirl_projectile_hitfx",target)
	inst:Remove()
end

local function projectilefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("lavaarena_heal_projectile")
    inst.AnimState:SetBuild("tz_fh_fishgirl_projectile")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.AnimState:SetLightOverride(1)

    inst:AddTag("projectile")

    if not TheNet:IsDedicated() then
        inst:DoPeriodicTask(0, OnUpdateProjectileTail, nil,
            "lavaarena_heal_projectile", "tz_fh_fishgirl_projectile", 15, 1, nil, nil, nil, {})
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
      return inst
    end

	inst:AddComponent("projectile")
	inst.components.projectile:SetSpeed(15)
	inst.components.projectile:SetHoming(true) -- Lock the target and follow it
	inst.components.projectile:SetOnHitFn(OnProjectileHit)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetHitDist(1.5) -- distance before the target is registered "hits" by the projectile
	inst:ListenForEvent("onthrown", function(inst, data)
		inst.AnimState:SetOrientation(ANIM_ORIENTATION.Default)
		if inst.Physics ~= nil and not inst:HasTag("nocollisionoverride") then
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.GROUND)	
		end
        inst:AddTag("NOCLICK")

        
        inst:DoTaskInTime(4 * FRAMES,function()
            SpawnAt("tz_fh_fishgirl_projectile_castfx",inst)
        end)

	    inst:ListenForEvent("entitysleep", inst.Remove)
	end)
		
    return inst
end

return TzEntity.CreateNormalWeapon({
    assets = assets,
    prefabname = "tz_fh_fishgirl",
    tags = {"tz_fh_fishgirl","tz_fanhao"},
    bank = "tz_fh_fishgirl",
    build = "tz_fh_fishgirl",
    anim = "idle",

    weapon_data = {
        damage = 100,
        ranges = 10,
    },
    
    clientfn = TzFhFishgirlClient,
    serverfn = TzFhFishgirlServer,
}),
Prefab("tz_fh_fishgirl_projectile",projectilefn,assets),
TzEntity.CreateNormalFx({
    assets = assets,
    prefabname = "tz_fh_fishgirl_projectile_hitfx",
    tags = {"NOCLICK","FX"},
    bank = "lavaarena_heal_projectile",
    build = "tz_fh_fishgirl_projectile",
    anim = "hit",

    clientfn = function(inst)
        inst.AnimState:SetLightOverride(1)
    end,
}),
TzEntity.CreateNormalFx({
    assets = assets,
    prefabname = "tz_fh_fishgirl_projectile_castfx",
    tags = {"NOCLICK","FX"},
    bank = "lavaarena_heal_projectile",
    build = "tz_fh_fishgirl_projectile",
    anim = "cast",

    clientfn = function(inst)
        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetAddColour(0, .1, .05, 0)
    end,
}),
TzEntity.CreateNormalFx({
    assets = assets,
    prefabname = "tz_fh_fishgirl_dragonbite",
    tags = {"NOCLICK","FX"},
    bank = "elza_dragon",
    build = "elza_dragon",
    anim = "idlc",

    animover_remove = false,

    clientfn = function(inst)
        inst.AnimState:SetLightOverride(1)
    end,

    serverfn = function(inst)
        inst.owner = nil 

        inst.timeline = {
            TimeEvent(0.8,function(inst)
                -- TODO:Play water spalash sfx
                inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/waterspout")
            end),

            TimeEvent(1,function(inst)
                -- TODO:Play dragon open mouth sfx
            end),

            TimeEvent(1.3,function(inst)
                -- TODO:Play dragon bite sfx,do damage here
                if inst.owner and inst.owner:IsValid() and inst.owner.components.combat then
                    local x,y,z = inst:GetPosition():Get()
                    for k,v in pairs(TheSim:FindEntities(x,y,z,4.5,{"_combat","_health"},{"INLIMBO"})) do
                        if not inst.owner.components.combat:IsAlly(v) then
                            v.components.combat:GetAttacked(inst.owner,500)
                        end
                    end
                end
                
            end),

            TimeEvent(1.4,function(inst)
                -- TODO:Freeze nearby
                local x,y,z = inst:GetPosition():Get()
                for k,v in pairs(TheSim:FindEntities(x,y,z,4,nil,{"INLIMBO"})) do
                    if v.components.freezable then
                        v.components.freezable:Freeze(5)
                    end
                end
            end),

            TimeEvent(1.7,function(inst)
                -- TODO:Play water spalash sfx
                inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/waterspout")
            end),
        }

        for k,v in pairs(inst.timeline) do
            inst:DoTaskInTime(v.time,v.fn)
        end

        inst:ListenForEvent("animover",function(inst)
            inst:Hide()
            inst:DoTaskInTime(1.5,inst.Remove)
        end)
    end,
})