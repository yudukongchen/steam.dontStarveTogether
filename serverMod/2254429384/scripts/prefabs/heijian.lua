local assets =
{
    Asset("ANIM", "anim/heijian.zip"),
    Asset("ANIM", "anim/heijian_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/heijian.xml"),
    Asset("IMAGE", "images/inventoryimages/heijian.tex"),
}


local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","heijian_sw","heijian")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
	 if TheWorld:HasTag("cave") then
 inst.components.weapon:SetDamage(136)
 else
 if TheWorld.state.phase == "day" then
       inst.components.weapon:SetDamage(68)
    elseif TheWorld.state.phase == "night" then
       inst.components.weapon:SetDamage(136)
    elseif TheWorld.state.phase == "dusk" then
       inst.components.weapon:SetDamage(102)
    end
	end
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end
	
	local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end
	
local function onattack(inst, owner, target)
local txrt 
if target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion") then
inst.components.finiteuses.current = inst.components.finiteuses.current + 1
end
if TheWorld:HasTag("cave") then
 inst.components.weapon:SetDamage(136)
 txrt = 0.4
 else
 if TheWorld.state.phase == "day" then
       inst.components.weapon:SetDamage(68)
	   txrt = 0.2
    elseif TheWorld.state.phase == "night" then
       inst.components.weapon:SetDamage(136)
	   txrt = 0.4
    elseif TheWorld.state.phase == "dusk" then
	   txrt = 0.3
       inst.components.weapon:SetDamage(102)
    end
	end
if target.components.health:IsDead() and target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion") then
local heatxt = target.components.health.maxhealth/50
if inst.components.finiteuses.current < 600 then
	inst.components.finiteuses.current = inst.components.finiteuses.current + heatxt
	if inst.components.finiteuses.current > 600 then
	inst.components.finiteuses.current = 600
	end
	end
	end
	 if math.random() < txrt then
        local pt
        if target ~= nil and target:IsValid() then
            pt = target:GetPosition()
        else
            pt = owner:GetPosition()
            target = nil
        end
        local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 2, 3, false, true, NoHoles)
        if offset ~= nil then
            local tentacle = SpawnPrefab("shadowtentacle")
            if tentacle ~= nil then
                tentacle.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
                tentacle.components.combat:SetTarget(target)
            end
        end
    end
end
	
local function fn()
     local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetBank("heijian")
    inst.AnimState:SetBuild("heijian")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
  inst.components.tool:SetAction(ACTIONS.CHOP, 2)
   
    inst:AddTag("sharp")
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(1,2)

    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)   
    inst.components.finiteuses:SetOnFinished( onfinished )
	inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/heijian.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("heijian", fn, assets, prefabs)


