local assets =
{
   Asset("ANIM", "anim/dianhu.zip"),
    Asset("ANIM", "anim/dianhu_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/dianhu.xml"),
    Asset("IMAGE", "images/inventoryimages/dianhu.tex"),
}

local function onfinished(inst)
    inst:ListenForEvent("animover", function() inst:Remove() end)
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
    owner.AnimState:OverrideSymbol("swap_object","dianhu_sw","dianhu")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
	inst.AnimState:PlayAnimation("idle")
		if inst.components.fueled.currentfuel >0 then
	  turnon(inst)
	  end
end

local function OnHitOwner(inst)
	inst.AnimState:PlayAnimation("idle")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
		turnoff(inst)
    end
	
local function OnPutInInventory(inst)
    inst.hitcount = 0
    inst.hittargets = {}
    inst.AnimState:PlayAnimation("idle")
end

local function OnThrown(inst, owner, target)
if inst.components.fueled.currentfuel >0 and inst.fire == nil then
	  turnon(inst)
	  end
local weapons = owner.components.inventory:FindItems(function(item)
			return item.components.weapon
		end)
		
local poinzt = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if weapons then
		for k,v in pairs(weapons) do
			if v and v.prefab == "dianhu" then
			if poinzt == nil then
			owner.components.inventory:Equip(v)
			elseif poinzt.prefab == "dianhu" then
			
			elseif poinzt.prefab ~= "dianhu" then
			owner.components.inventory:Equip(v)
			end
			end
            	end
        end	
    if target ~= owner then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_throw")
    end
    inst.AnimState:PlayAnimation("qifei", true)
end

local function FindTarget(inst) --获取附近目标
    if inst.hitcount > 506502 then return nil end
    local x, y, z = inst:GetPosition():Get()
    local ents = TheSim:FindEntities(x, 0, z, 8, {'_combat'}, {'FX', 'NOCLICK', 'INLIMBO', 'DECOR', 'hiding', 'player','wall',"companion","abigail"})
    for k, v in pairs(ents)do
        if not inst.hittargets[v] then
            if v.components.health and not v.components.health:IsDead() and not v:HasTag("wall") and not v:HasTag("chester") and not v:HasTag("abigail") and not v:HasTag("glommer") and not v:HasTag("hutch") and not v:HasTag("boat") then
                return v
            end
        end
    end
end

local function OnCaught(inst, catcher)
    if catcher then
        if catcher.components.inventory then
            if inst.components.equippable and not catcher.components.inventory:GetEquippedItem(inst.components.equippable.equipslot) then
                catcher.components.inventory:Equip(inst)
            else
                catcher.components.inventory:GiveItem(inst)
            end
            catcher:PushEvent("catch")
        end
    end
end

local function ReturnToOwner(inst, owner)
    if owner then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_return")
        inst.components.projectile:Throw(owner, owner)
    end
end

local function Bounce(inst, owner, target)
    inst.components.projectile:Throw(owner, target)
end

local function OnHit(inst, owner, target)
    inst.hittargets[target or 1] = true
    inst.hitcount = inst.hitcount + 1

    if owner == target then  --击中玩家
        OnHitOwner(inst) 
    else
        local target = FindTarget(inst)
        if target then
            Bounce(inst, owner, target) --攻击下一个目标
			
        else
            ReturnToOwner(inst, owner)  --返回玩家
			
        end
    end
    local impactfx = SpawnPrefab("impact")
    if impactfx then
        local follower = impactfx.entity:AddFollower()
        follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0 )
        impactfx:FacePoint(inst:GetPosition())
    end
end

local function getdamagefn(inst)
    if inst.hitcount > 5 then
        return 68
    else
        return math.max(Remap(inst.hitcount, 0, 5, 68, 68))
    end
end

local function onattack(inst, owner, target)
if target ~= nil and target:IsValid() and owner ~= nil and owner:IsValid() then
        SpawnPrefab("electrichitsparks"):AlignToTarget(target, owner, true)
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
    RemovePhysicsColliders(inst)
	
    --inst.entity:SetPristine()
	
	inst:AddTag("thrown")

    inst:AddTag("weapon")

    inst:AddTag("projectile")

    inst:AddTag("sharp")
    if not TheWorld.ismastersim then
        return inst
    end

     inst.AnimState:SetBank("dianhu")
    inst.AnimState:SetBuild("dianhu")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetRayTestOnBB(true);
	
	inst.hitcount = 0
    inst.hittargets = {}
	  
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
    inst.components.weapon:SetRange(9, 12)
    inst.components.weapon.getdamagefn = getdamagefn
	inst.components.weapon.onattack = onattack
	inst.components.weapon:SetElectric()
	
	inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20) --飞行速度
    inst.components.projectile:SetCanCatch(true)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(ReturnToOwner)
    inst.components.projectile:SetOnCaughtFn(OnCaught)
    inst.components.projectile:SetLaunchOffset(Vector3(0, 0, 0))
	
local oldhit = inst.components.projectile.Hit
	
function inst.components.projectile:Hit(target)
		
	if target == self.owner and target.components.catcher then

			target:PushEvent("catch", {projectile = self.inst})
 
			self.inst:PushEvent("caught", {catcher = target})

			self:Catch(target)

			target.components.catcher:StopWatching(self.inst)

		else
			
			oldhit(self, target)
		
	end

end

	inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(1200)
	inst.components.fueled.fueltype = "NIGHTMARE"
	inst.components.fueled.accepting = true
	inst.components.fueled:SetDepletedFn(nofuel)
    inst.components.fueled.ontakefuelfn = takefuel
	
	
    inst:AddComponent("inspectable")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1200)
    inst.components.finiteuses:SetUses(1200)
    inst.components.finiteuses:SetOnFinished( onfinished )
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dianhu.xml"
	inst:ListenForEvent('onputininventory', OnPutInInventory)
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("dianhu", fn, assets, prefabs)


