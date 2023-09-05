local assets =
{   Asset("ANIM", "anim/wudu.zip"),
    Asset("ANIM", "anim/wudu_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/wudu.xml"),
    Asset("IMAGE", "images/inventoryimages/wudu.tex"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","wudu_sw","wudu")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
    end
	
local function onattack(inst, owner, target)

local fxs = SpawnPrefab("zhongdu")
    fxs.entity:SetParent(target.entity)
    fxs.Transform:SetPosition(0, 0, 0)

local hejus = target:DoPeriodicTask(1, function()  target.components.health:DoDelta(-20) end)
	hejus.limit = 5
		
end

local function onthrown(inst, data)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.components.inventoryitem.pushlandedevents = false
	inst.AnimState:PlayAnimation("dart_pipe")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function onhit(inst, attacker, target)
    local impactfx = SpawnPrefab("impact")
    if impactfx ~= nil then
        local follower = impactfx.entity:AddFollower()
        follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
        if attacker ~= nil and attacker:IsValid() then
            impactfx:FacePoint(attacker.Transform:GetWorldPosition())
        end
    end
    inst:Remove()
end
	
local function fn()
   local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	
	inst:AddTag("blowdart")
    inst:AddTag("sharp")
    inst:AddTag("weapon")
    inst:AddTag("projectile")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetBank("wudu")
    inst.AnimState:SetBuild("wudu")
    inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(8, 10)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(60)
    inst.components.projectile:SetOnHitFn(onhit)
    inst:ListenForEvent("onthrown", onthrown)

    inst:AddComponent("inspectable")
	inst:AddComponent("stackable")
	 inst.components.stackable.maxsize = 40

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/wudu.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
	 inst.components.equippable.equipstack = true
	
	
    return inst
end

return Prefab("wudu", fn, assets, prefabs)


