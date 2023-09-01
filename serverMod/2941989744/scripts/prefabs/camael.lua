local assets = {
    Asset("ANIM", "anim/camael.zip"), 
    Asset("ANIM", "anim/swap_camael.zip"),
    Asset("ANIM", "anim/camael_skillon.zip"),
    Asset("ANIM", "anim/camael_fx.zip"), 
    Asset("ATLAS", "images/camael.xml"), 
    Asset("IMAGE", "images/camael.tex"),
    Asset("ATLAS", "images/camael_skillon.xml"), 
    Asset("IMAGE", "images/camael_skillon.tex"),

}

local perdamage = 20 --每点温度对应多少伤害
local pertem = 0.5 --每秒增加多少温度
local cd = 3 --写0就是不要冷却

local function  setskillon(inst,owner)
    if inst.skillmode == "skill" then
        return
    end
    if inst.components.tool then
        inst:RemoveComponent("tool")
    end
    inst:AddTag("camael_noattack")
    inst.skillmode = "skill"
    if inst.components.rechargeable:IsCharged() then
        inst.components.camael_skill.skill_on = true
    end
    inst.components.inventoryitem.atlasname = "images/camael_skillon.xml"
    inst.components.inventoryitem:ChangeImageName("camael_skillon" )
    if owner then
        owner.AnimState:OverrideSymbol("swap_object", "camael_skillon", "swap_blunderbuss")
        if owner.components.combat then
            owner.components.combat.canattack = false
        end
    end
end

local function setnomal(inst,owner,uneauip)
    if inst.skillmode == "nomal" then
        return
    end
    if not inst.components.tool then
        inst:AddComponent("tool")
		inst.components.tool:EnableToughWork(true)

    end
	inst.components.tool:EnableToughWork(true)
    inst.components.tool:SetAction(ACTIONS.CHOP, 2)
    inst.components.tool:SetAction(ACTIONS.MINE, 2)
    inst:RemoveTag("camael_noattack")
    inst.skillmode = "nomal"
    inst.components.camael_skill.skill_on = false
    inst.components.inventoryitem.atlasname = "images/camael.xml"
    inst.components.inventoryitem:ChangeImageName("camael" )
    if owner then
        if owner.components.combat then
            owner.components.combat.canattack = true
        end
        if not uneauip then
            owner.AnimState:OverrideSymbol("swap_object", "swap_camael", "symbol0")
        end
    end
end

----特效？？
local function sword_do_trail(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    if not owner.entity:IsVisible() then
        return
    end

    local x, y, z = owner.Transform:GetWorldPosition()
    if owner.sg ~= nil and owner.sg:HasStateTag("moving") then
        local theta = -owner.Transform:GetRotation() * DEGREES
        local speed = owner.components.locomotor:GetRunSpeed() * .1
        x = x + speed * math.cos(theta)
        z = z + speed * math.sin(theta)
    end
    local mounted = owner.components.rider ~= nil and owner.components.rider:IsRiding()
    local map = TheWorld.Map
    local offset = FindValidPositionByFan(math.random() * 2 * PI, (mounted and 1 or .5) + math.random() * .5, 4,
        function(offset)
            local pt = Vector3(x + offset.x, 0, z + offset.z)
            return map:IsPassableAtPoint(pt:Get()) and not map:IsPointNearHole(pt) and
                       #TheSim:FindEntities(pt.x, 0, pt.z, .7, {"shadowtrail"}) <= 0
        end)

    if offset ~= nil then
        SpawnPrefab("cane_ancient_fx").Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end

local function sword_equipped(inst)
    if inst._trailtask == nil then
        inst._trailtask = inst:DoPeriodicTask(6 * FRAMES, sword_do_trail, 2 * FRAMES)
    end
end

local function sword_unequipped(inst)
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
end

local function settem(inst,doer)
    if doer and doer.components.temperature then
        local self = doer.components.temperature 
        local last = self.current
        self.current = math.clamp(last + pertem, self.mintemp, self.maxtemp)
        if (self.current < 0) ~= (last < 0) then
            self.inst:PushEvent(self.current < 0 and "startfreezing" or "stopfreezing")
        end
        if (self.current > self.overheattemp) ~= (last > self.overheattemp) then
            self.inst:PushEvent(self.current > self.overheattemp and "startoverheating" or "stopoverheating")
        end
        self.inst:PushEvent("temperaturedelta", { last = last, new = self.current })
    end
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_camael", "symbol0")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if not inst.tem_task and owner.components.temperature then
        inst.tem_task = inst:DoPeriodicTask(1,settem,1,owner)
    end

    if owner.shengminghuixve == nil then
        owner.shengminghuixve = owner:DoPeriodicTask(60, function()
            if owner and owner.components.health then
                owner.components.health:DoDelta(30) ---基础回血，对部分人物不生效
            end
        end)
    end
    if "true" == "true" then ---这写的是什么吖？？？看不懂，不改了
        if "cane_victorian_fx" == "cane_ancient_fx" then
            sword_equipped(inst)
        else
            if inst._vfx_fx_inst == nil then
                inst._vfx_fx_inst = SpawnPrefab("cane_victorian_fx")
                inst._vfx_fx_inst.entity:AddFollower()
            end
            inst._vfx_fx_inst.entity:SetParent(owner.entity)
            inst._vfx_fx_inst.Follower:FollowSymbol(owner.GUID, "swap_object", 0, inst.vfx_fx_offset or 0, 0)
        end
    end
    setnomal(inst,owner)
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if owner.shengminghuixve ~= nil then
        owner.shengminghuixve:Cancel()
        owner.shengminghuixve = nil
    end
    if inst.tem_task then
        inst.tem_task:Cancel()
        inst.tem_task = nil
    end

    if "true" == "true" then ---这写的是什么吖？？？看不懂。
        if "cane_victorian_fx" == "cane_ancient_fx" then
            sword_unequipped(inst)
        else
            if inst._vfx_fx_inst ~= nil then
                inst._vfx_fx_inst:Remove()
                inst._vfx_fx_inst = nil
            end
        end
    end
    setnomal(inst,owner,true)
end
--
local function skillfn(inst,doer,pos)
    if doer and pos then
        if not inst.components.rechargeable:IsCharged() then
            return
        end
        local fx = SpawnPrefab("camael_fx")
        fx:StartAttack(doer,pos)
        if cd ~= 0 then
            inst.components.rechargeable:Discharge(cd)
        end
        local numsteps = 55
        local x, y, z = doer.Transform:GetWorldPosition()
        local angle = (doer.Transform:GetRotation() + 90) * DEGREES
        local step = .45
        local offset = 2 - step
        local ground = TheWorld.Map
        local targets, skiptoss = {}, {}
        local i = -1
        local fx, dist, delay, x1, z1
        while i < numsteps do
            i = i + 1
            dist = i * step + offset
            delay = math.max(0, i - 1)
            x1 = x + dist * math.sin(angle)
            z1 = z + dist * math.cos(angle)
            fx = SpawnPrefab("camael_damage")
            fx.Transform:SetPosition(x1, 0, z1)
            fx.caster = doer
            fx:Trigger(0, targets, skiptoss)
        end
        if i < numsteps then
            dist = (i + .5) * step + offset
            x1 = x + dist * math.sin(angle)
            z1 = z + dist * math.cos(angle)
        end
		if doer.components.temperature then
		
			local self = doer.components.temperature 
			local last = self.current
				  self.current = 0
				
			if (self.current < 0) ~= (last < 0) then
				self.inst:PushEvent(self.current < 0 and "startfreezing" or "stopfreezing")
			end
			
			if (self.current > self.overheattemp) ~= (last > self.overheattemp) then
				self.inst:PushEvent(self.current > self.overheattemp and "startoverheating" or "stopoverheating")
			end

			self.inst:PushEvent("temperaturedelta", { last = last, new = self.current })
	
		end
    end
end

local function OnCharged(inst)
    if inst.skillmode == "skill" then
        inst.components.camael_skill.skill_on = true
    end
end

local function OnDischarged(inst)
    inst.components.camael_skill.skill_on = false
end

local function bush_onuse(inst)
    local owner = inst.components.inventoryitem.owner
    if owner then
        if inst.skillmode == "skill" then
            setnomal(inst,owner)
        else
            setskillon(inst,owner)
        end
        return false
    end
end
local function fn()

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("camael")
    inst.AnimState:SetBuild("camael")
    inst.AnimState:PlayAnimation("idle")
    inst.MiniMapEntity:SetIcon("camael.tex")
    inst:AddTag("sharp")
    inst:AddTag("camael")
    inst:AddTag("allow_action_on_impassable")
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.skillmode = "nomal"

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(75)
    inst.components.weapon:SetRange(0.75, 0.75)

    inst:AddComponent("tool")
	inst.components.tool:EnableToughWork(true)
    inst.components.tool:SetAction(ACTIONS.CHOP, 2)
    inst.components.tool:SetAction(ACTIONS.MINE, 2)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("rechargeable")
	inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
	inst.components.rechargeable:SetOnChargedFn(OnCharged)

    inst:AddComponent("camael_skill")
    inst.components.camael_skill:SetFn(skillfn)

    inst.components.inventoryitem.imagename = "camael"
    inst.components.inventoryitem.atlasname = "images/camael.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	
	
    inst:AddComponent("useableitem")
    inst.components.useableitem:SetOnUseFn(bush_onuse)


    return inst
end


local function startattack(inst,owner,pos)
    local launchoffset = Vector3(0.5, 1.3, 0)
    if owner ~= nil and launchoffset ~= nil then
        local x, y, z = owner.Transform:GetWorldPosition()
        local facing_angle = owner.Transform:GetRotation() * DEGREES
        inst.Transform:SetPosition(x + launchoffset.x * math.cos(facing_angle), y + launchoffset.y, z - launchoffset.x * math.sin(facing_angle))
    end
    local direction = pos - inst:GetPosition()
    direction:Normalize()
    local angle = math.acos(direction:Dot(Vector3(1, 0, 0))) / DEGREES
    inst.Transform:SetRotation(angle)
    inst:FacePoint(pos)
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("camael_fx")
    inst.AnimState:SetBuild("camael_fx")
    inst.AnimState:PlayAnimation("iiii")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetBloomEffectHandle("shaders/anim_haunted.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:HideSymbol("flash01")
    --flash01
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    
    local s  = 1.3
    inst.Transform:SetScale(s, s, s)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.StartAttack = startattack

    inst.persists = false
    inst:ListenForEvent("animover", inst.Remove)
    inst:DoTaskInTime(2, inst.Remove)
    
    return inst
end

local function KeepTargetFn()
    return false
end
local DAMAGE_CANT_TAGS = { "playerghost", "INLIMBO", "companion","wall","DECOR", "INLIMBO","player" }
local DAMAGE_ONEOF_TAGS = { "_combat", "pickable", "NPC_workable", "CHOP_workable", "HAMMER_workable", "MINE_workable", "DIG_workable" }
local LAUNCH_MUST_TAGS = { "_inventoryitem" }
local LAUNCH_CANT_TAGS = { "locomotor", "INLIMBO" }
local LAUNCH_SPEED = .2
local RADIUS = .7
local function DoDamage(inst, targets, skiptoss)
    inst.task = nil
    inst.components.combat.ignorehitrange = true
    local x, y, z = inst.Transform:GetWorldPosition()
    inst.components.combat.ignorehitrange = true
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, 4, nil, DAMAGE_CANT_TAGS, DAMAGE_ONEOF_TAGS)) do
        if not targets[v] and v:IsValid() and not v:IsInLimbo() and not (v.components.health ~= nil and v.components.health:IsDead()) then
            local vradius = v:GetPhysicsRadius(.5)
            local range = RADIUS + vradius
            if v:GetDistanceSqToPoint(x, y, z) < range * range then
                local isworkable = false
                if v.components.workable ~= nil then
                    local work_action = v.components.workable:GetWorkAction()
                    isworkable =
                        (   work_action == nil and v:HasTag("NPC_workable") ) or
                        (   v.components.workable:CanBeWorked() and
                            (   work_action == ACTIONS.CHOP or
                                work_action == ACTIONS.HAMMER or
                                work_action == ACTIONS.MINE or
                                (   work_action == ACTIONS.DIG and
                                    v.components.spawner == nil and
                                    v.components.childspawner == nil
                                )
                            )
                        )
                end
                if isworkable then
                    targets[v] = true
                    local fx = SpawnPrefab("explosivehit")
                    fx.Transform:SetPosition(v.Transform:GetWorldPosition())
                    fx:DoTaskInTime(1.5,fx.Remove)
                    v.components.workable:Destroy(inst)
                    if v:IsValid() and v:HasTag("stump") then
                        v:Remove()
                    end
                elseif v.components.pickable ~= nil
                    and v.components.pickable:CanBePicked()
                    and not v:HasTag("intense") then
                    targets[v] = true
                    local num = v.components.pickable.numtoharvest or 1
                    local product = v.components.pickable.product
                    local x1, y1, z1 = v.Transform:GetWorldPosition()
                    v.components.pickable:Pick(inst) -- only calling this to trigger callbacks on the object
                    if product ~= nil and num > 0 then
                        for i = 1, num do
                            local loot = SpawnPrefab(product)
                            loot.Transform:SetPosition(x1, 0, z1)
                            skiptoss[loot] = true
                            targets[loot] = true
                            Launch(loot, inst, LAUNCH_SPEED)
                        end
                    end
                elseif inst.components.combat:CanTarget(v) and v.components.combat then
                    targets[v] = true
                    if inst.caster ~= nil and inst.caster:IsValid() and inst.caster.components.temperature then
                        local damage = inst.caster.components.temperature.current*perdamage
                        inst.caster.components.combat.ignorehitrange = true
                        local fx = SpawnPrefab("explosivehit")
                        fx.Transform:SetPosition(v.Transform:GetWorldPosition())
                        fx:DoTaskInTime(1.5,fx.Remove)
                        v.components.combat:GetAttacked(inst.caster,damage)
                        inst.caster.components.combat.ignorehitrange = false
                    else
                        inst.components.combat:DoAttack(v)
                    end
                end
            end
        end
    end
    inst.components.combat.ignorehitrange = false
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, RADIUS + 3, LAUNCH_MUST_TAGS, LAUNCH_CANT_TAGS)) do
        if not skiptoss[v] then
            local range = RADIUS + v:GetPhysicsRadius(.5)
            if v:GetDistanceSqToPoint(x, y, z) < range * range then
                if v.components.mine ~= nil then
                    targets[v] = true
                    skiptoss[v] = true
                    v.components.mine:Deactivate()
                end
                if not v.components.inventoryitem.nobounce and v.Physics ~= nil and v.Physics:IsActive() then
                    targets[v] = true
                    skiptoss[v] = true
                    Launch(v, inst, LAUNCH_SPEED)
                end
            end
        end
    end
end
local function Trigger(inst, delay, targets, skiptoss)
    if (delay or 0) > 0 then
        inst.task = inst:DoTaskInTime(delay, DoDamage, targets or {}, skiptoss or {})
    else
        DoDamage(inst, targets or {}, skiptoss or {})
    end
end
local function damagefn(isempty)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("notarget")
    inst:AddTag("hostile")
    inst:AddTag("fx")

    inst:SetPrefabNameOverride("camael")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(300)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst.Trigger = Trigger
    inst.persists = false

    inst:DoTaskInTime(1, inst.Remove)

    return inst
end

return Prefab("camael", fn, assets),
    Prefab("camael_fx", fxfn, assets),
    Prefab("camael_damage", damagefn)
