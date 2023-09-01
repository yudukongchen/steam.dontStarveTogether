local TzEntity = require("util/tz_entity")
local TzWeaponSkill = require("util/tz_weaponskill")
local TzFh = require("util/tz_fh")

local assets = {
    Asset("ANIM", "anim/tz_fh_ht.zip"),
    Asset("IMAGE", "images/inventoryimages/tz_fh_ht.tex"),
    Asset("ATLAS", "images/inventoryimages/tz_fh_ht.xml")
}

local function SpawnFX(inst,weapon,target)
    if inst._ht_firefx_task then
        inst._ht_firefx_task:Cancel()
    end
    local time = 5.1
    local max = weapon and weapon.maxlevel
    inst._ht_firefx_task = inst:DoTaskInTime(time,function()
        inst._ht_firefx_task = nil
        if inst._ht_firefx and inst._ht_firefx:IsValid() then
            inst._ht_firefx:Remove()
            inst._ht_firefx = nil
        end
        if inst.components.locomotor then
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "tz_fh_ht") 
        end
    end)
    if inst._ht_firefx then
        inst._ht_firefx.owner = target
        if max then
            inst._ht_firefx.num = math.min((inst._ht_firefx.num or 1)+ 1,3)
        end
        return
    end
    if inst.components.locomotor then
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "tz_fh_ht", 0)
    end
    local fxdata =  inst.components.burnable  and inst.components.burnable.fxdata  or {{ x = 0, y = 0, z = 0, level = 2 }}
    local fxoffset = inst.components.burnable  and inst.components.burnable.fxoffset or Vector3(0, 0, 0)

    local level =  inst.components.burnable and inst.components.burnable.fxlevel or 2
    
    for k, v in pairs(fxdata) do
        local fx = SpawnPrefab("tz_fh_ht_fire")
        if fx ~= nil then
            if v.build ~= nil then
                fx.AnimState:SetBank(v.build)
                fx.AnimState:SetBuild(v.build)
            end
            if v.finaloffset ~= nil then
                fx.AnimState:SetFinalOffset(v.finaloffset)
            end

            local scale = inst.Transform:GetScale()
            if v.scale then
                scale = scale * v.scale
            end
            fx.Transform:SetScale(scale,scale,scale)
            
            local xoffs, yoffs, zoffs = v.x + fxoffset.x, v.y + fxoffset.y, v.z + fxoffset.z
            if v.follow ~= nil then
                if v.followaschild then
                    inst:AddChild(fx)
                end
                fx.entity:AddFollower()
                fx.Follower:FollowSymbol(inst.GUID, v.follow, xoffs, yoffs, zoffs)
            else
                inst:AddChild(fx)
                fx.Transform:SetPosition(xoffs, yoffs, zoffs)
            end
            fx.persists = false
            fx:SetLevel(level)
            inst._ht_firefx  = fx
            inst._ht_firefx.owner = target
            inst._ht_firefx.num = 1
            inst._ht_firefx:DoPeriodicTask(1,function()
                if inst:IsValid() and inst.components.health and not inst.components.health:IsDead() and inst.components.combat then
                    local combat = inst._ht_firefx.owner ~= nil and inst._ht_firefx.owner:IsValid() and inst._ht_firefx.owner.components.combat or nil
                    local damagemultiplie = combat ~= nil and  (combat.damagemultiplier * combat.externaldamagemultipliers:Get()) or 0
                    local damage = (inst._ht_firefx.num or 1)*60 * damagemultiplie
                    if damage ~= 0 then
                        inst.components.combat:GetAttacked(inst._ht_firefx.owner,damage)
                    end
                elseif inst._ht_firefx:IsValid() then
                    inst._ht_firefx:Remove()
                    inst._ht_firefx = nil
                    if inst._ht_firefx_task then
                        inst._ht_firefx_task:Cancel()
                        inst._ht_firefx_task = nil
                    end
                    if inst.components.locomotor then
                        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "tz_fh_ht") 
                    end
                end
            end)
            break
        end
    end
end

local function TakeFuelItem(self,item, doer)
    if self:CanAcceptFuelItem(item) then
        local wetmult = item:GetIsWet() and TUNING.WET_FUEL_PENALTY or 1
        local masterymult = doer ~= nil and doer.components.fuelmaster ~= nil and doer.components.fuelmaster:GetBonusMult(item, self.inst) or 1
        self:DoDelta(50 * self.bonusmult * wetmult * masterymult, doer)
        if doer and doer:HasTag("player") then
            local pos = doer:GetPosition()
            SpawnAt("tz_takefuel",pos + Vector3(-0.1,-2.6,0))
        end
        self.inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        item:Remove()
        self.inst:PushEvent("takefuel", { fuelvalue = 50 })
        if self.inst.level and not self.inst.maxlevel then
            self.inst.level = math.min(99,self.inst.level + 1)
            if doer and doer.components.talker then
                doer.components.talker:Say("当前进度"..self.inst.level.."/99")
            end
            if self.inst.level >= 99 then
                self.inst.maxlevel =  true
                if self.inst._light then
                    self.inst._light.Light:Enable(true)
                end
            end
        end
        return true
    end
end

local function OnEquip(inst,data)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("tz_fh_ht_light")
    end
    local owner = data and data.owner or inst
    if owner ~= nil then
        inst._light.entity:SetParent(owner.entity)
    end
    if inst.maxlevel then
        inst._light.Light:Enable(true)
    end
    if data and data.owner then
        inst:ListenForEvent("emote",inst.emotefn,data.owner)
    end
end

local function OnUnEquip(inst,data)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end
    if data and data.owner then
        inst:RemoveEventCallback("emote",inst.emotefn,data.owner)
    end
end

local function OnAttack(inst, attacker, target)
    if target and target:IsValid() then
        if not (target.components.health and target.components.health:IsDead()) then
            SpawnFX(target,inst,attacker)
        end
    end
end

local function SetNew(inst)
    if inst.ismoon_charged then
        inst.components.weapon:SetDamage(100)
        inst:AddTag("tz_no_attacked_sg")
    else
        inst.components.weapon:SetDamage(50)
        inst:RemoveTag("tz_no_attacked_sg") 
    end
end

local function OnSave(inst,data)
    data.maxlevel = inst.maxlev
    data.ismoon_charged = inst.ismoon_charged
    data.level = inst.level
end

local function OnLoad(inst,data)
    if data ~= nil then
        if data.level ~= nil then
            inst.level = data.level
        end
        if data.maxlevel ~= nil then
            inst.maxlevel = data.maxlevel
        end
        if data.ismoon_charged then
            inst.ismoon_charged = true
            SetNew(inst)
        end
    end
end

local NOTENTCHECK_CANT_TAGS = { "FX", "INLIMBO" }
local function noentcheckfn(pt)
    return not TheWorld.Map:IsPointNearHole(pt) and #TheSim:FindEntities(pt.x, pt.y, pt.z, 1, nil, NOTENTCHECK_CANT_TAGS) == 0
end
local function Use_Map_Skill(inst,doer,x,z)
    if doer and x and z then
        local pt = doer:GetPosition()
        local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 3 + math.random(), 16, false, true, noentcheckfn, true, true)
                        or FindWalkableOffset(pt, math.random() * 2 * PI, 5 + math.random(), 16, false, true, noentcheckfn, true, true)
                        or FindWalkableOffset(pt, math.random() * 2 * PI, 7 + math.random(), 16, false, true, noentcheckfn, true, true)
        if offset ~= nil then
            pt = pt + offset
        end
        local portal = SpawnPrefab("pocketwatch_portal_entrance")
        portal.Transform:SetPosition(pt:Get())
        portal:SpawnExit(TheShard:GetShardId(), x, 0, z)
        inst.components.rechargeable:Discharge(30)
        --inst.SoundEmitter:PlaySound("wanda1/wanda/portal_entrance_pre")
    end
end

local firelevels =
{
    "loop_small",
    "loop_med",
    "loop_large",
}

local function SetLevel(inst,level)
    if level then
        inst.AnimState:PlayAnimation(firelevels[level] or "loop_med", true)
    end
end

local function spawnreadfx(reader,fx,fxmount)
    local ismount = reader.components.rider ~= nil and reader.components.rider:IsRiding()
    local fx = ismount and fxmount or fx
    if fx ~= nil then
        fx = SpawnPrefab(fx)
        if ismount then
            fx.Transform:SetSixFaced()
        end
        fx.Transform:SetPosition(reader.Transform:GetWorldPosition())
        fx.Transform:SetRotation(reader.Transform:GetRotation())
    end
end

local function firefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)

    inst.AnimState:SetBank("fire_large_character")
    inst.AnimState:SetBuild("fire_large_character")

    inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)
    inst.AnimState:SetMultColour(0, 0, 0, 1)
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    inst.SetLevel = SetLevel
    return inst
end
local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetFalloff(0.4)
    inst.Light:SetIntensity(.7)
    inst.Light:SetRadius(2.5)
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
    inst.Light:Enable(false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function OnCharged(inst)
    inst:AddTag("tz_fh_ht_map")
end

local function OnDischarged(inst)
    inst:RemoveTag("tz_fh_ht_map")
end

return Prefab("tz_fh_ht_fire",firefn),
    Prefab("tz_fh_ht_light",lightfn),
    TzEntity.CreateNormalWeapon({
    assets = assets,
    prefabname = "tz_fh_ht",
    tags = {"tz_fh_ht_map","tz_fh_ht","tz_fanhao"},
    bank = "tz_fh_ht",
    build = "tz_fh_ht",
    anim = "idle",

    weapon_data = {
        -- However,the damage delt by this weapon is pierce damage
        -- So do this in another way....
        swapanims = {"tz_fh_ht","swap"},
        damage = 50,
        ranges = 14,
    },
    
    clientfn = function(inst)
        TzFh.AddFhLevel(inst,true)
        TzFh.AddOwnerName(inst)
    end,
    serverfn = function(inst)

        inst.maxlevel = false
        inst.ismoon_charged =  false
        inst.level = 0
        inst.OnSave = OnSave 
        inst.OnLoad = OnLoad
        inst.Use_Map_Skill = Use_Map_Skill
        TzFh.MakeWhiteList(inst)
        TzFh.AddFueledComponent(inst,{
            max = 5000,
        })
        inst.components.fueled.TakeFuelItem = TakeFuelItem
        TzFh.SetReturnSpiritualism(inst)
            
        -- night explosion
        inst.explosion_fn = TzFh.SKILL_LIBIARY.night_explosion.on_attack_fn_wrapper(3,
            { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost","wall","structure" }
        )
        inst.components.weapon:SetOnAttack(function(inst,owner,target)
            inst.explosion_fn(inst,owner,target)
            OnAttack(inst, owner, target)
        end)
        inst:AddComponent("timer")

        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
        inst.components.rechargeable:SetOnChargedFn(OnCharged)

        TzFh.AddLibrarySkill(inst,{name = "shadowstep"})
        TzFh.AddLibrarySkill(inst,{name = "yingci"})
        TzFh.AddLibrarySkill(inst,{name = "shadow_ball"})

        inst:ListenForEvent("equipped",OnEquip)
        inst:ListenForEvent("unequipped",OnUnEquip)
        inst:WatchWorldState("cycles", function()
            if inst.ismoon_charged then
                inst.ismoon_charged = false
                SetNew(inst)
            end
        end)
        inst.emotefn = function(owner,data)
            if data and data.item_type and data.item_type == "emote_carol" and not inst.components.timer:TimerExists("newmoon_cd") then
                if TheWorld:HasTag("cave") then --洞穴无法改变
                    owner.components.talker:Say(STRINGS.CHARACTERS.WAXWELL.ACTIONFAIL.READ.NOMOONINCAVES)
                    return
                --elseif TheWorld.state.moonphase == "new" then
                --    owner.components.talker:Say(STRINGS.CHARACTERS.WAXWELL.ACTIONFAIL.READ.ALREADYFULLMOON)
                --    return
                end
                --TheWorld:PushEvent("ms_setmoonphase", {moonphase = "new",iswaxing = true})
                --if not TheWorld.state.isnight then
                --    owner.components.talker:Say(STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_BOOK_MOON_DAYTIME)
                --end
                TheWorld:PushEvent("ms_stopthemoonstorms")
                inst.components.timer:StartTimer("newmoon_cd",30*60)
                spawnreadfx(owner,"fx_book_moon","fx_book_moon_mount")
                inst.ismoon_charged = true
                SetNew(inst)
            end
        end
    end,
})