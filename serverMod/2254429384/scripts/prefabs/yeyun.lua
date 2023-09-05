local assets =
{
    Asset("ANIM", "anim/yeyun.zip"),
    Asset("ANIM", "anim/yeyun_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/yeyun.xml"),
    Asset("IMAGE", "images/inventoryimages/yeyun.tex"),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","yeyun_sw","yeyun")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end
	
	local function onattack(inst, owner, target)
	inst.components.lengliang.lengliang = 12
	if inst:HasTag("youming") then
	inst.components.lengliang.maxlengliang = 1
	else
	if inst.components.lengliang.maxlengliang < 3  then 
	inst.components.lengliang.maxlengliang = inst.components.lengliang.maxlengliang + 1
	else
	inst.components.lengliang.maxlengliang = 1
	 inst:AddTag("youming")
	end
	end
	  if  target.components.health.currenthealth <= 0 then
		   owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed+2
              owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed+2
			   owner:DoTaskInTime( 2, function()
        owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed-2
	owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed-2
	 end)
	 
	 else
	  owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed+1
      owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed+1
        owner:DoTaskInTime( 2, function()
        owner.components.locomotor.walkspeed =  owner.components.locomotor.walkspeed-1
		owner.components.locomotor.runspeed =  owner.components.locomotor.runspeed-1
		end)
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

   inst.AnimState:SetBank("yeyun")
    inst.AnimState:SetBuild("yeyun")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER, 2)
   

    inst:AddTag("sharp")
	inst:DoPeriodicTask(0.5, function() 
	if inst:HasTag("youming") and inst.components.lengliang.lengliang > 0  then
	local owner = inst.components.inventoryitem.owner
	if owner ~= nil then
	local fx = SpawnPrefab("youming")
        fx.entity:SetParent(owner.entity)
        fx.Transform:SetPosition(0, 0, 0)
		end
	local pos = Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 8)
    for k,v in pairs(ents) do
        if not v:HasTag("player") and v.components.health and not v:HasTag("wall") and not v:HasTag("chester") and not v:HasTag("abigail") and not v:HasTag("glommer") and not v:HasTag("hutch") and not v:HasTag("boat") then
		v.components.health:DoDelta(-17)
        end
		end	
		else
		 inst:RemoveTag("youming")
	end
	inst.components.lengliang.lengliang = inst.components.lengliang.lengliang - 1 
	end)

    inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetDamage(68)
    inst.components.weapon:SetRange(1,2)

    inst:AddComponent("inspectable")
	inst:AddComponent("lengliang")
    inst.components.lengliang.lengliang=12
	inst.components.lengliang.maxlengliang=1
	

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)
    inst.components.finiteuses:SetOnFinished( onfinished )
	inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
    
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/yeyun.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("yeyun", fn, assets, prefabs)


