local assets =
{
    Asset("ANIM", "anim/shouhu.zip"),
    Asset("ANIM", "anim/shouhu_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/shouhu.xml"),
    Asset("IMAGE", "images/inventoryimages/shouhu.tex"),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","shouhu_sw","shouhu")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end
	
	local function CustomOnHaunt(inst)
	
	local ll = inst.components.lengliang.lengliang
	 inst.components.finiteuses.current = inst.components.finiteuses.current - (240 - ll)
	 local sxz = inst.components.finiteuses.current
	if sxz <= 0 then 
	inst:Remove()
   end
   
   local pos = Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 30)
    for k,v in pairs(ents) do
	if v:HasTag("player") then 
	v.components.health:DoDelta(100)
	v:DoTaskInTime(5, function() v.components.health:DoDelta(100) end)
	end 
        if not v:HasTag("player") 
		and v.components.health 
		and not v:HasTag("wall") 
		and not v:HasTag("chester") 
		and not v:HasTag("abigail") 
		and not v:HasTag("glommer") 
		and not v:HasTag("hutch") 
		and not v:HasTag("boat")   then	
		if v.components.farmplanttendable ~= nil then
			v.components.farmplanttendable:TendTo(musician)
        elseif v.components.sleeper ~= nil then
            v.components.sleeper:AddSleepiness(10, TUNING.PANFLUTE_SLEEPTIME)
        elseif v.components.grogginess ~= nil then
            v.components.grogginess:AddGrogginess(10, TUNING.PANFLUTE_SLEEPTIME)
        else
            v:PushEvent("knockedout")
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

    inst.AnimState:SetBank("shouhu")
    inst.AnimState:SetBuild("shouhu")
    inst.AnimState:PlayAnimation("idle")

	inst:DoPeriodicTask(1, function()
if inst.components.lengliang.lengliang < 240 then
inst.components.lengliang.lengliang =inst.components.lengliang.lengliang + 1
end
	end)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)
	 
    inst:AddTag("sharp")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
	

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
    inst.components.weapon:SetRange(1,2)

    inst:AddComponent("inspectable")
	
	inst:AddComponent("lengliang")
    inst.components.lengliang.maxlengliang = 240
	inst.components.lengliang.lengliang = 240
	
	
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/shouhu.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
	  AddHauntableCustomReaction(inst, CustomOnHaunt, true, nil, true)
    return inst
end

return Prefab("shouhu", fn, assets, prefabs)


