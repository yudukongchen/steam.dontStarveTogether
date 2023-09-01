local assets=
{ 
    Asset("ANIM", "anim/swap_asa_blade.zip"),
	Asset("ANIM", "anim/asa_blade.zip"),
}
local prefabs = 
{
}

local function onattack(inst, owner, target)
	if target:HasTag("asa_zan") then
		local defence =	target.components.combat.externaldamagetakenmultipliers and 1 - target.components.combat.externaldamagetakenmultipliers:Get() or 0	--适配加强防御，破甲率67%
		local extra = (1 - defence/3) / (1 - defence)
		local damage = owner.components.combat:CalcDamage(target, inst, 4/3)
		target.components.combat:GetAttacked(owner, damage * extra, inst, nil)
		target:RemoveTag("asa_zan")
		target.AnimState:SetAddColour(0, 0, 0, 0)
		SpawnPrefab("zan_light").Transform:SetPosition(target.Transform:GetWorldPosition())
		ShakeAllCameras(CAMERASHAKE.VERTICAL, 0.2, 0.05, 0.8, owner, 0.2)
	end
	--inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/atk1")
--inst.components.finiteuses:Use(1)
end

local function OnEquip(inst, owner) 
	-- if owner.asa_blade2 and owner.asa_blade2:value() == true then
		-- owner.AnimState:OverrideSymbol("swap_object", "swap_asa_blade2", "swap_asa_blade2")
	-- else
	owner.AnimState:OverrideSymbol("swap_object", "swap_asa_blade", "swap_asa_blade")
	-- end
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
	
	-- if not owner:HasTag("asa_equipped2") then
		-- owner:AddTag("asa_equipped2")
	-- end
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
    inst.components.weapon:SetDamage(51)
    inst.components.weapon.onattack = onattack
   
	inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "asa_blade"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_blade.xml"

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
return  Prefab("common/inventory/asa_blade", fn, assets, prefabs)