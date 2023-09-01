require "prefabutil"


local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/auto_seeding_machine.zip"),
    Asset("IMAGE", "images/inventoryimages/auto_seeding_machine.tex"),
    Asset("ATLAS", "images/inventoryimages/auto_seeding_machine.xml"),
    Asset("ANIM", "anim/ui_seeding_1x1.zip"),
}

local prefabs =
{

}

local FIRE_RANGE = 20
if TUNING.IS_NEW_AGRICULTURE then
    FIRE_RANGE = 15
end

-----发射种子部分在Poop Flingomatic mod基础上修改来的
--URL：https://steamcommunity.com/sharedfiles/filedetails/?id=2174620235


local function OnHitSeed(inst, attacker, target)
    if (inst.target.prefab == "slow_farmplot" or inst.target.prefab == "fast_farmplot") and inst.target.components.grower then      --旧农场
        inst.target.components.grower:PlantItem(inst, attacker.planter)
        inst:Remove()
    end
    if inst.target and inst.target.prefab == "farm_soil" and inst.components.farmplantable then   --新农场
        inst.components.farmplantable:Plant(inst.target, attacker.planter)
    else
        inst:RemoveComponent("complexprojectile")
        inst:RemoveComponent("locomotor")
        inst:RemoveTag("projectile")
        inst.Physics:SetActive(false)
    end
end

local function LaunchProjectile(inst, targetpos, target)
    local x, y, z = inst.Transform:GetWorldPosition()

    if target == nil then       --新农场在种植后会移除farm_soli
        --print("target为空，发射失败")   --print
        return
    end     

    if (target.prefab == "slow_farmplot" or target.prefab == "fast_farmplot") and not (target.components.grower:IsEmpty() and target.components.grower:IsFertile()) then
            return  --如果农场临时发生变化不能种植了，则不发射
    end

    local item = inst.components.container:GetItemInSlot(1)
    if item then
        local projectile = inst.components.container:RemoveItem(item)
        projectile.Transform:SetPosition(x, y, z)
        projectile.target = target

        if not projectile.Physics then
            projectile.entity:AddPhysics()
            projectile.Physics:SetMass(1)
            projectile.Physics:SetFriction(0)
            projectile.Physics:SetDamping(0)
            projectile.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
            projectile.Physics:ClearCollisionMask()
            projectile.Physics:CollidesWith(COLLISION.GROUND)
            projectile.Physics:SetCapsule(0.2, 0.2)
            projectile.Physics:SetDontRemoveOnSleep(true)
        end
        if not projectile:HasTag("projectile") then
            projectile:AddTag("projectile")
        end
        if not projectile.components.complexprojectile then
            projectile:AddComponent("locomotor")
            projectile:AddComponent("complexprojectile")
            projectile.components.complexprojectile:SetHorizontalSpeed(15)
            projectile.components.complexprojectile:SetGravity(-25)
            projectile.components.complexprojectile:SetLaunchOffset(Vector3(0, 3, 0))
            projectile.components.complexprojectile:SetOnHit(OnHitSeed)
        end

        local dx = targetpos.x - x
        local dz = targetpos.z - z
        local rangesq = dx * dx + dz * dz
        local maxrange = FIRE_RANGE
        local speed = easing.linear(rangesq, 25, 3, maxrange * maxrange)

        projectile.components.complexprojectile:SetHorizontalSpeed(speed)
        projectile.components.complexprojectile:SetGravity(-25)
        -- local remove_item = inst.components.container:RemoveItem(item, false)   --接收从容器移除的种子
        -- if remove_item then     --从世界中移除它
        --     remove_item:Remove()
        -- end
        inst.AnimState:PlayAnimation("seed")
        inst.AnimState:PushAnimation("idle")
        projectile.components.complexprojectile:Launch(targetpos, inst, inst)

        -- local item_now = inst.components.container:GetItemInSlot(1)
        -- if item_now and item_now.components.complexprojectile then
        --     item_now:RemoveComponent("complexprojectile")
        --     item_now:RemoveTag("projectile")
        --     item_now.entity:RemovePhysics()
        -- end
    end
end

local function CheckForFarm(inst, planter)
    if not inst:HasTag("burnt") then
        local x, y, z = inst.Transform:GetWorldPosition()
        local n=0
        local willfire = false

        local seed_num = inst.components.container:GetItemInSlot(1) and inst.components.container:GetItemInSlot(1).components.stackable:StackSize() or 0  --容器里种子的数量
        
        inst.planter = planter      --存储按下播种按钮的玩家
        for k, v in ipairs(TheSim:FindEntities(x, y, z, FIRE_RANGE*2)) do
            if ((v.prefab == "slow_farmplot" or v.prefab == "fast_farmplot") and v.components.grower:IsEmpty() and v.components.grower:IsFertile())
            or (v.prefab == "farm_soil" and not v:HasTag("NOCLICK")) then       --新农场
                n=n+1
                if n <= seed_num then   --如果检测到的农场数量不多余种子数量，则发射
                    willfire = true
                    inst:DoTaskInTime(n/2, function()
                        if not inst:HasTag("burnt") then
                            local targetpos = v:GetPosition()
                            --print("检测到农场"..targetpos.x..", "..targetpos.z)     --print
                            LaunchProjectile(inst, targetpos, v)
                        end
                    end)
                end
            end
        end
        ---------在发射过程中不能打开容器
        if willfire then
            inst.components.container.canopen = false
            if inst.components.container:IsOpen() then
                inst.components.container:Close()
            end
        end
        inst:DoTaskInTime(math.min(n, seed_num)/2 + 1, function ()
            inst.components.container.canopen = true
        end)
    end
end

---------------------------------

local function onburnt(inst)
    DefaultBurntStructureFn(inst)
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if not inst:HasTag("burnt") then
        inst.components.container:DropEverything()
    end
    inst.SoundEmitter:KillSound("firesuppressor_idle")
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle",true)
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil then
        if data.burnt and inst.components.burnable ~= nil and inst.components.burnable.onburnt ~= nil then
            inst.components.burnable.onburnt(inst)
        end
    end
    if not data.burnt and not inst.components.container:IsEmpty() then
        inst.isvalid:set(true)
    else    
        inst.isvalid:set(false)
    end
end

local function onbuilt(inst)
    --inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_craft")
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
end
---------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    MakeObstaclePhysics(inst, .5)

    inst.MiniMapEntity:SetIcon("auto_seeding_machine_mini.tex")  --小地图图标

    inst.AnimState:SetBank("auto_seeding_machine")
    inst.AnimState:SetBuild("auto_seeding_machine")
    inst.AnimState:PlayAnimation("idle")

    inst.checkforfarm = CheckForFarm
    inst.isvalid = net_bool(inst.GUID,"seedisvalid")
    inst.isvalid:set(false)

    inst:AddTag("fridge")   --冰箱保鲜功能
    inst:AddTag("structure")

    --MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    ----------------------------------------
    inst.planter = nil;

    inst:AddComponent("container")
    inst.components.container:WidgetSetup( "auto_seeding_machine")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    ----------------------------------------


    MakeMediumBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    --MakeSnowCovered(inst)

    inst:ListenForEvent("onbuilt", onbuilt)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("auto_seeding_machine", fn, assets, prefabs),
    MakePlacer("auto_seeding_machine_placer", "auto_seeding_machine", "auto_seeding_machine", "idle")
    --name：perfab名，约定为原prefab名——placer,
    --bank,build,anim,
    --onground：取值true或false，是否设置为紧贴地面,
    --snap：取值true或false，无用，设置为nil即可,
    --metersnap：取值true或false，与围墙有关，一般建筑物用不上，设置为nil即可,
    --scale,
    --fixedcameraoffset：固定偏移,
    --facing：设置有几个面,
    --postinit_fn：特殊处理
