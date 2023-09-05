local assets =
{
    Asset("ANIM", "anim/chengxing.zip"),
    Asset("ANIM", "anim/chengxing_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/chengxing.xml"),
    Asset("IMAGE", "images/inventoryimages/chengxing.tex"),
}

local function onfinished(inst)
    inst:Remove()
end

local function turnon(inst)
 if inst.components.fueled then
                inst.components.fueled:StartConsuming()        
            end
	if not inst.fire then 
	            inst.fire = SpawnPrefab( "nightstickfire" )
	            local follower = inst.fire.entity:AddFollower()
	            follower:FollowSymbol( inst.GUID, "swap_object", 0, 0, 0 )
	        end 
end

local function turnoff(inst)
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end
	    if inst.fire then 
	        inst.fire:Remove()
	        inst.fire = nil
	    end 
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","chengxing_sw","chengxing")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
	if inst.components.fueled.currentfuel >0 then
	  turnon(inst)
	  end
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
	turnoff(inst)
    end
	
local function onattack(inst, owner, target)
if target ~= nil and target:IsValid() and owner ~= nil and owner:IsValid() then
        SpawnPrefab("electrichitsparks"):AlignToTarget(target, owner, true)
    end
	end
	
	local function createlightning(inst, target, pos)

	local caster = inst.components.inventoryitem.owner

	local ground = TheWorld

	local pt = pos
	local tg = target:GetPosition()
	local x, y, z = target.Transform:GetWorldPosition()
	local sd = 25
	local pl = 10

	

	if target ~= nil then
	SpawnPrefab("lightning").Transform:SetPosition(x, y + 3, z)
	if target:HasTag("player") then
	
	if target.prefab == ("wx78") then
		ground:PushEvent("ms_sendlightningstrike", tg)
	end
		
	SpawnPrefab("electrichitsparks").Transform:SetPosition(x, y, z)
	target.components.health:DoDelta(-pl)
	target.sg:GoToState("electrocute")
		
	else
		if target.components.health ~= nil then
		target.sg:GoToState("hit")
		SpawnPrefab("electrichitsparks").Transform:SetPosition(x, y, z)
		target.components.combat:GetAttacked(caster, sd, nil)
		end
	end
	
	end
end

local function nofuel(inst)
    turnoff(inst)
end

local function takefuel(inst)
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        turnon(inst)
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

    inst.AnimState:SetBank("chengxing")
    inst.AnimState:SetBuild("chengxing")
    inst.AnimState:PlayAnimation("idle")
   
    inst:AddTag("sharp")
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(1,2)
	inst.components.weapon:SetElectric()
	
	inst:AddComponent("lengliang")
    inst.components.lengliang.lengliang=1

    inst:AddComponent("inspectable")
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createlightning)
	inst.components.spellcaster.canuseontargets = true
	inst.components.spellcaster.canuseonpoint = false
	inst.components.spellcaster.canonlyuseonlocomotors = true
	inst.components.spellcaster.canonlyuseonworkable = false

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)   
    inst.components.finiteuses:SetOnFinished( onfinished )
   
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/chengxing.xml"
	
	inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(540)
	inst.components.fueled.fueltype = "NIGHTMARE"
	inst.components.fueled.accepting = true
	inst.components.fueled:SetDepletedFn(nofuel)
    inst.components.fueled.ontakefuelfn = takefuel
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("chengxing", fn, assets, prefabs)


