
local icecake_assets =
{
    Asset("ANIM", "anim/icecake.zip"),
    Asset("ANIM", "anim/boomerang.zip"), --借来一用，没时间搞新动作了。
    Asset("SOUNDPACKAGE", "sound/sousou.fev"),  --音效
    Asset("SOUND", "sound/sousou.fsb"),
}

local icecake_prefabs =
{
    "icespike_fx_1",
    "icespike_fx_2",
    "icespike_fx_3",
    "icespike_fx_4",
    "reticule",
    "icecakefire",
}

local function DoSpawnIceSpike(x, z)
    SpawnPrefab("icespike_fx_"..tostring(math.random(1, 4))).Transform:SetPosition(x, 0, z)
end

local function OnHitIcecake(inst,attacker,target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local Theicespike = TheSim:FindEntities(x1, y1, z1, 5, {"_combat"},{"player","playerghost"})
    if attacker and not attacker.Change then
        if #Theicespike~=0  then   
            for k, v in pairs(Theicespike) do
                local x, y, z = v.Transform:GetWorldPosition()
                DoSpawnIceSpike(x, z)
                if v then
                    if v.components.freezable ~= nil then
                     v.components.freezable:AddColdness(12, 6)
                    end
                    if v.components.health ~=nil then
                        if v.components.health:GetMaxWithPenalty() > 2000 then
                         v.components.health:DoDelta(-200,false,attacker,nil,attacker)
                         else
                        v.components.health:DoDelta(-50,false,attacker,nil,attacker) 
                        end
                    end
                 end
            end 
        else
            SpawnPrefab("icespike_fx_"..tostring(math.random(1, 4))).Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    elseif attacker then
        if #Theicespike~=0  then   
            for k, v in pairs(Theicespike) do
                if v then
                    if v.components.health ~=nil then
                        if v.components.health:GetMaxWithPenalty() > 2000 then
                         v.components.health:DoDelta(-400,false,attacker,nil,attacker)
                         else
                        v.components.health:DoDelta(-100,false,attacker,nil,attacker) 
                        end
                    end
                 end
            end 
        end
        SpawnPrefab("houndfire").Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "icecake", "swap_icecake")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    if not owner.Change then
        if inst.fires == nil then
             inst.fires = {}
             local fx = SpawnPrefab("icecakefire")
             fx.entity:SetParent(owner.entity)
             fx.entity:AddFollower()
             fx.Follower:FollowSymbol(owner.GUID, "swap_object",  13,50,-1)
             table.insert(inst.fires, fx)
        end
    else
        if inst.fires == nil then
            inst.fires = {}
            local fx = SpawnPrefab("icecakefire_change")
            fx.entity:SetParent(owner.entity)
            fx.entity:AddFollower()
            fx.Follower:FollowSymbol(owner.GUID, "swap_object",  13,30,-1)
            table.insert(inst.fires, fx)
       end
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if inst.fires ~= nil then
        for i, fx in ipairs(inst.fires) do
            fx:Remove()
        end
        inst.fires = nil
    end
end

local function OnThrown(inst, owner, target)
    inst:AddTag("NOCLICK")
    inst.persists = false
    if target ~= owner then
        owner.SoundEmitter:PlaySound("sousou/sousou/mydart") --sousou!
    end
    inst.AnimState:PlayAnimation("spin_loop", true)
end

local function icecake_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("icecake")
    inst.AnimState:SetBuild("icecake")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("thrown")
    inst:AddTag("weapon")
    inst:AddTag("projectile")

    MakeInventoryFloatable(inst, "med", 0.05, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(10)    
    inst.components.weapon:SetRange(TUNING.BOOMERANG_DISTANCE, TUNING.BOOMERANG_DISTANCE + 2)

    inst:AddComponent("inspectable")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(35)
    inst.components.projectile:SetOnThrownFn(OnThrown)  
    inst.components.projectile:SetOnHitFn(OnHitIcecake)     
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/icecake.xml"

    inst:AddComponent("stackable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("icecake",icecake_fn, icecake_assets, icecake_prefabs)