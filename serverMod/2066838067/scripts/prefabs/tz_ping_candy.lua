local assets=
{
    Asset("ANIM", "anim/ping_candy.zip"),
    Asset("ANIM", "anim/swap_ping_candy.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_ping_candy.xml"),
    Asset("IMAGE", "images/inventoryimages/tz_ping_candy.tex"),
}

local function killed(inst, data)
	if data ~= nil and data.victim ~= nil and data.victim:HasTag("epic") then
		
	end
end

local function onunequip(inst, owner)
	-- inst:RemoveEventCallback("killed", killed,owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end
local function onequip(inst, owner)
	-- inst:ListenForEvent("killed", killed,owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_ping_candy", "swap_ping_candy")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function onattack(inst,attacker,target)
	if target ~=nil and target.components.health and target.components.health:IsDead() and target:HasTag("epic") then
		if math.random() <= inst.gail then
			inst.gail = 0
			local wrapped = SpawnPrefab("gift") 
			if wrapped ~= nil and wrapped.components.unwrappable ~= nil then
				wrapped.components.unwrappable.origin = TheWorld.meta.session_identifier
				wrapped.components.unwrappable.itemdata = {
					{prefab="tz_spiritualism",x=0,z=0},
					{prefab="taffy",x=0,z=0},
					{prefab="taffy",x=0,z=0},
					{prefab="taffy",x=0,z=0},
					{prefab="taffy",x=0,z=0},
					{prefab="taffy",x=0,z=0},
				}
				if target:IsValid() then
					wrapped.Transform:SetPosition(target.Transform:GetWorldPosition())
				else
					wrapped.Transform:SetPosition(inst.Transform:GetWorldPosition())	
				end
			end
		else
			inst.gail = inst.gail + 0.1
		end
	end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("ping_candy")
    inst.AnimState:SetBuild("ping_candy")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", 0.1, {1.5, 0.5, 1.5})

	inst:AddTag("weapon")
	inst:AddTag("sharp")  

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	inst.gail = 0.1
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_ping_candy.xml"
	-- inst.components.inventoryitem:ChangeImageName("mazes_harp")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
	
	-- inst:AddComponent("finiteuses")
	-- inst.components.finiteuses:SetMaxUses(100)
	-- inst.components.finiteuses:SetUses(100)
	-- inst.components.finiteuses:SetOnFinished(data.finiteuses_data.onfinished or inst.Remove)
			
	-- inst:AddComponent("trader")
	-- inst.components.trader:SetAcceptTest(function(inst,item)
		-- if item.prefab == "nightmarefuel" then
			-- inst.components.finiteuses:Repair(25)
			-- return true
		-- end
		-- return false
	-- end)
		
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(5)
	inst.components.weapon:SetRange(1)
	inst.components.weapon:SetOnAttack(onattack)
	
    MakeHauntableLaunch(inst)

    return inst
end


return Prefab("tz_ping_candy", fn, assets)