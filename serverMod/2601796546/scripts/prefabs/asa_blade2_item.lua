local assets=
{ 
	Asset("ANIM", "anim/swap_asa_blade2.zip"),
	Asset("ANIM", "anim/asa_blade.zip"),
	Asset( "IMAGE", "images/inventoryimages/asa_blade2_item.tex" ),  --武器图标
    Asset( "ATLAS", "images/inventoryimages/asa_blade2_item.xml" ),
}
local prefabs = 
{
	"asa_lightning_red",
}

local function onattack(inst, owner, target)
	if target:HasTag("asa_zan") then
		local defence =	target.components.combat.externaldamagetakenmultipliers and 1 - target.components.combat.externaldamagetakenmultipliers:Get() or 0	--适配加强防御，破甲率67%
		local extra = (1 - defence/3) / (1 - defence)
		local damage = owner.components.combat:CalcDamage(target, inst, 3/2)
		target.components.combat:GetAttacked(owner, damage * extra, inst, nil)
		target:RemoveTag("asa_zan")
		target.AnimState:SetAddColour(0, 0, 0, 0)
		SpawnPrefab("zan_light").Transform:SetPosition(target.Transform:GetWorldPosition())
		ShakeAllCameras(CAMERASHAKE.VERTICAL, 0.2, 0.05, 0.8, owner, 0.2)
	end
end

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_asa_blade2", "swap_asa_blade2")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
	-- if owner.components.hunger ~= nil then
		-- owner.components.hunger.burnratemodifiers:SetModifier(inst, 8)
	-- end
	
	if not owner:HasTag("asa_equipped") then
		owner:AddTag("asa_equipped")
	end
	
	if not owner:HasTag("asa_equipped1") then
		owner:AddTag("asa_equipped1")
	end
	
	owner.red_fx1 = SpawnPrefab("asa_lightning_red")
	owner.red_fx1.entity:AddFollower()
	owner.red_fx1.entity:SetParent(owner.entity)
	owner.red_fx1.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -300, 0)
	
	owner.red_fx2 = SpawnPrefab("asa_lightning_red")
	owner.red_fx2.entity:AddFollower()
	owner.red_fx2.entity:SetParent(owner.entity)
	owner.red_fx2.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -250, 0)
	
	owner.red_fx3 = SpawnPrefab("asa_lightning_red")
	owner.red_fx3.entity:AddFollower()
	owner.red_fx3.entity:SetParent(owner.entity)
	owner.red_fx3.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -200, 0)
	
	owner.red_fx4 = SpawnPrefab("asa_lightning_red")
	owner.red_fx4.entity:AddFollower()
	owner.red_fx4.entity:SetParent(owner.entity)
	owner.red_fx4.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -150, 0)
	
	owner.red_fx5 = SpawnPrefab("asa_lightning_red")
	owner.red_fx5.entity:AddFollower()
	owner.red_fx5.entity:SetParent(owner.entity)
	owner.red_fx5.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -100, 0)
end

local function OnUnequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
	-- if owner.components.hunger ~= nil then
        -- owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    -- end
	
	if owner:HasTag("asa_equipped") then
		owner:RemoveTag("asa_equipped")
	end
	
	if owner.red_fx1 then
		owner.red_fx1:Remove()
		owner.red_fx1 = nil
	end
	
	if owner.red_fx2 then
		owner.red_fx2:Remove()
		owner.red_fx2 = nil
	end
	
	if owner.red_fx3 then
		owner.red_fx3:Remove()
		owner.red_fx3 = nil
	end
	
	if owner.red_fx4 then
		owner.red_fx4:Remove()
		owner.red_fx4 = nil
	end
	
	if owner.red_fx5 then
		owner.red_fx5:Remove()
		owner.red_fx5 = nil
	end
	
	owner:DoTaskInTime(0,function()
		inst:Remove()
	end)
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("asa_blade")
    inst.AnimState:SetBuild("asa_blade")
    inst.AnimState:PlayAnimation("idle")
	--inst.AnimState:AddOverrideBuild("player_parryblock")
	--my input
	
	inst:AddTag("sharp")
	inst:AddTag("asa_blade")
	--inst:AddTag("shadow")  --暗影音效

------------  don't know use
   if not TheWorld.ismastersim then
		return inst
	end
	inst.entity:SetPristine()
-----------

	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
	inst.components.weapon:SetRange(0.2)
    inst.components.weapon.onattack = onattack
   
	inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "asa_blade2_item"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_blade2_item.xml"

	inst:AddComponent("asa_parry")
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	
	-- inst:DoTaskInTime(0.1,function()
		-- if inst.components.inventoryitem and inst.components.inventoryitem.owner and inst.components.inventoryitem.owner.asa_blade2:value() == true then
			-- inst.components.weapon:SetDamage(68)
			-- inst.components.inventoryitem.imagename = "asa_blade2"
			-- inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_blade2.xml"
		-- end
	-- end)
	
    MakeHauntableLaunch(inst)

    return inst
end

----------------------------------------------------------------
return  Prefab("common/inventory/asa_blade2_item", fn, assets, prefabs)