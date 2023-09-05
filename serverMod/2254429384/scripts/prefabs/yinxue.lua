local assets =
{
    Asset("ANIM", "anim/yinxue.zip"),
    Asset("ANIM", "anim/yinxue_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/yinxue.xml"),
    Asset("IMAGE", "images/inventoryimages/yinxue.tex"),
}

local hudun

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
 hudun = function() 
	        local inv=owner.components.inventory
			local hat=inv and inv:GetEquippedItem(EQUIPSLOTS.HANDS)
	if inst.components.armor.condition > 500 and hat and hat.prefab=="yinxue"  then
	    owner.components.health:SetInvincible(true)
		owner:DoTaskInTime(0.25, function()
                owner.components.health:SetInvincible(false)
        end)
        inst:AddTag("forcefield")
        inst.components.armor:SetAbsorption(1)
        local fx = SpawnPrefab("forcefieldfx")
        fx.entity:SetParent(owner.entity)
        fx.Transform:SetPosition(0, 0, 0)
        local fx_hitanim = function()
            fx.AnimState:PlayAnimation("hit")
            fx.AnimState:PushAnimation("idle_loop")
        end
        fx:ListenForEvent("blocked", fx_hitanim, owner)

        inst.components.armor.ontakedamage = function(inst, damage_amount)
            if owner then
                local sanity = owner.components.sanity
                if sanity then
                    local unsaneness = damage_amount * TUNING.ARMOR_RUINSHAT_DMG_AS_SANITY
                    sanity:DoDelta(-unsaneness, false)
                end
            end
        end

        inst.active = true

        owner:DoTaskInTime( 8, function()
            fx:RemoveEventCallback("blocked", fx_hitanim, owner)
            fx.kill_fx(fx)
            if inst:IsValid() then
                inst:RemoveTag("forcefield")
                inst.components.armor.ontakedamage = nil
                inst.components.armor:SetAbsorption(0.0000)
                owner:DoTaskInTime( 2.5, function() inst.active = false end)
            end
        end)
		else 
		inst.components.armor:SetAbsorption(0.0000)
		end
	 end
    owner.AnimState:OverrideSymbol("swap_object","yinxue_sw","yinxue")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
	 owner:ListenForEvent("attacked",hudun)
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
inst.components.armor:SetAbsorption(0.0000)
	 owner:RemoveEventCallback("attacked", hudun )	
    end
	
local function onattack(inst, owner, target)
if owner.components.health and owner.components.health.currenthealth == owner.components.health.maxhealth - owner.components.health.penalty*owner.components.health.maxhealth  and not target:HasTag("wall") then
        inst.components.armor.condition =  inst.components.armor.condition + 13.6
		end
 owner.components.health:DoDelta(13.6)
	end
	
	local function PercentChanged(inst, data)
    if inst.components.armor
       and data.percent and data.percent <= 0.1
       and inst.components.inventoryitem and inst.components.inventoryitem.owner then
        inst.components.armor.indestructible = true
		else
		inst.components.armor.indestructible = false
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

    inst.AnimState:SetBank("yinxue")
    inst.AnimState:SetBuild("yinxue")
    inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)
   
    inst:AddTag("sharp")
	
	inst:AddComponent("armor")
	
	inst.components.armor.maxcondition =1000
    inst.components.armor:SetCondition(500)
	inst.components.armor:SetAbsorption(0.0000)
	inst:ListenForEvent("percentusedchange", PercentChanged)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(0)

    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)   
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/yinxue.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("yinxue", fn, assets, prefabs)


