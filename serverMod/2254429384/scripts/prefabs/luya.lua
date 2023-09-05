local assets =
{
    Asset("ANIM", "anim/luya.zip"),
    Asset("ANIM", "anim/luya_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/luya.xml"),
    Asset("IMAGE", "images/inventoryimages/luya.tex"),
}

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end



local function spawntornadoz(staff, target, pos)
if staff.components.fueled.currentfuel > 30 then
    local tornadoz = SpawnPrefab("tornadoz")
    tornadoz.WINDSTAFF_CASTER = staff.components.inventoryitem.owner
    tornadoz.WINDSTAFF_CASTER_ISPLAYER = tornadoz.WINDSTAFF_CASTER ~= nil and tornadoz.WINDSTAFF_CASTER:HasTag("player")
    tornadoz.Transform:SetPosition(getspawnlocation(staff, target))
    tornadoz.components.knownlocations:RememberLocation("target", target:GetPosition())

    if tornadoz.WINDSTAFF_CASTER_ISPLAYER then
        tornadoz.overridepkname = tornadoz.WINDSTAFF_CASTER:GetDisplayName()
        tornadoz.overridepkpet = true
    end
    staff.components.finiteuses:Use(1)
	staff.components.fueled.currentfuel = staff.components.fueled.currentfuel - 30
	staff:AddTag("feng")
	staff.components.lengliang.lengliang=30
	staff.components.lengliang.maxlengliang = staff.components.lengliang.maxlengliang + 5
	if staff.components.lengliang.maxlengliang>=30 and staff:HasTag("feng")   then 
	 staff.components.weapon:SetRange(12,15)
	 else
	  staff.components.weapon:SetRange(1,2)
	end 
	else
	local caster = staff.components.inventoryitem.owner
			caster.components.talker:Say("武器没有能量了") 
	end
	end



local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object","luya_sw","luya")
	owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end
	
local function onattack(inst, owner, target)

if inst.components.fueled.currentfuel<180 then
		inst.components.fueled.currentfuel = inst.components.fueled.currentfuel + 10
		elseif inst.components.fueled.currentfuel < 0   then
		inst.components.fueled.currentfuel = 0
		end
if inst:HasTag("feng") then
if inst.components.lengliang.maxlengliang>=30 then 
 
	local pt = target:GetPosition()
	 local x, y, z = target.Transform:GetWorldPosition()
	 local x1, y1, z1 = owner.Transform:GetWorldPosition()
	local juli = (x - x1)*(x - x1) + (z - z1)*(z - z1)
	if juli > 16 then 
    owner:Hide()
	 owner.DynamicShadow:Enable(true)
	 	 SpawnPrefab("grasspartfx").Transform:SetPosition(x1, y1, z1)
	  SpawnPrefab("sand_puff_large_front").Transform:SetPosition(x1, y1, z1)
	   owner:DoTaskInTime(0.25, function() 
	
	  owner:Show()
	   owner.DynamicShadow:Enable(true)
	  if TheWorld.Map:IsPassableAtPoint(target.Transform:GetWorldPosition()) then 
	 owner.Transform:SetPosition(pt.x, pt.y, pt.z)
	  end 
	  --owner.components.health:DoDelta(-20)
	 inst.components.combat:DoAreaAttack(inst, 5)
	 SpawnPrefab("yotb_confetti").Transform:SetPosition(owner.Transform:GetWorldPosition())
	 end)
	 else
	 --owner.components.health:DoDelta(20)
	  inst.components.combat:DoAreaAttack(inst, 5)
	  SpawnPrefab("yotb_confetti").Transform:SetPosition(owner.Transform:GetWorldPosition())
    end 

	  
	 local tornadoz = SpawnPrefab("tornadoz")
    tornadoz.WINDSTAFF_CASTER = inst.components.inventoryitem.owner
	tornadoz.WINDSTAFF_CASTER_ISPLAYER = tornadoz.WINDSTAFF_CASTER ~= nil and tornadoz.WINDSTAFF_CASTER:HasTag("player")
	tornadoz.Transform:SetPosition(x+5, 0, z)
	tornadoz.components.knownlocations:RememberLocation("target", target:GetPosition())
	local tornadoz = SpawnPrefab("tornadoz")
    tornadoz.WINDSTAFF_CASTER = inst.components.inventoryitem.owner
	tornadoz.WINDSTAFF_CASTER_ISPLAYER = tornadoz.WINDSTAFF_CASTER ~= nil and tornadoz.WINDSTAFF_CASTER:HasTag("player")
	tornadoz.Transform:SetPosition(x-5, 0, z)
	tornadoz.components.knownlocations:RememberLocation("target", target:GetPosition())
	 local tornadoz = SpawnPrefab("tornadoz")
    tornadoz.WINDSTAFF_CASTER = inst.components.inventoryitem.owner
	tornadoz.WINDSTAFF_CASTER_ISPLAYER = tornadoz.WINDSTAFF_CASTER ~= nil and tornadoz.WINDSTAFF_CASTER:HasTag("player")
	tornadoz.Transform:SetPosition(x, 0, z+5)
	tornadoz.components.knownlocations:RememberLocation("target", target:GetPosition())
	local tornadoz = SpawnPrefab("tornadoz")
    tornadoz.WINDSTAFF_CASTER = inst.components.inventoryitem.owner
	tornadoz.WINDSTAFF_CASTER_ISPLAYER = tornadoz.WINDSTAFF_CASTER ~= nil and tornadoz.WINDSTAFF_CASTER:HasTag("player")
	tornadoz.Transform:SetPosition(x, 0, z-5)
	tornadoz.components.knownlocations:RememberLocation("target", target:GetPosition())

	
	 inst.components.lengliang.maxlengliang=0
	 inst.components.weapon:SetRange(1,2)
	 else
	  inst.components.weapon:SetRange(1,2)
	end 
	
if math.random() < 0.35 and inst.components.fueled.currentfuel > 30 then
	local tornadoz = SpawnPrefab("tornadoz")
    tornadoz.WINDSTAFF_CASTER = inst.components.inventoryitem.owner
	tornadoz.WINDSTAFF_CASTER_ISPLAYER = tornadoz.WINDSTAFF_CASTER ~= nil and tornadoz.WINDSTAFF_CASTER:HasTag("player")
	tornadoz.Transform:SetPosition(getspawnlocation(inst, target))
	tornadoz.components.knownlocations:RememberLocation("target", target:GetPosition())
	inst.components.fueled.currentfuel = inst.components.fueled.currentfuel - 30
	 inst.components.lengliang.maxlengliang = inst.components.lengliang.maxlengliang + 5
		end
	inst.components.lengliang.lengliang=30
	
		end	
		if inst.components.lengliang.maxlengliang>=30 and inst:HasTag("feng")   then 
	 inst.components.weapon:SetRange(12,15)
	 else
	  inst.components.weapon:SetRange(1,2)
	end 
end
	
local function fn()
     local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.entity:SetPristine()
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("luya.tex")
    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetBank("luya")
    inst.AnimState:SetBuild("luya")
    inst.AnimState:PlayAnimation("idle")

	inst:DoPeriodicTask(1, function() 
	if inst:HasTag("feng") then
	inst.components.equippable.walkspeedmult = 1.5
	else
	inst.components.equippable.walkspeedmult = 1.25
	end
	if inst.components.lengliang.maxlengliang>=30 and inst:HasTag("feng")   then 
	 inst.components.weapon:SetRange(12,15)
	 else
	  inst.components.weapon:SetRange(1,2)
	  inst.components.lengliang.maxlengliang = inst.components.lengliang.maxlengliang + 1
	end 
	inst.components.lengliang.lengliang = inst.components.lengliang.lengliang - 1 
	if inst.components.lengliang.lengliang > 30 then
	inst.components.lengliang.lengliang = 30 
	elseif inst.components.lengliang.lengliang < 0 then
	inst:RemoveTag("feng")
	inst.components.lengliang.lengliang = 0
	end
	end)

    inst:AddComponent("tool")
   
    inst:AddTag("sharp")
	
	inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(150)
    inst.components.combat.playerdamagepercent = 0
	
	inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(180)
	inst.components.fueled.fueltype = "NIGHTMARE"
	inst.components.fueled.accepting = true
	
	inst:AddComponent("lengliang")
    inst.components.lengliang.lengliang=30
	inst.components.lengliang.maxlengliang=30
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
	inst.components.weapon.onattack = onattack
    inst.components.weapon:SetRange(1,2)

    inst:AddComponent("inspectable")
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canonlyuseonworkable = true
    inst.components.spellcaster.canonlyuseoncombat = true
    inst.components.spellcaster.quickcast = true
    inst.components.spellcaster:SetSpellFn(spawntornadoz)
    inst.components.spellcaster.castingstate = "castspell_tornadoz"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1000)
    inst.components.finiteuses:SetUses(1000)   
    inst.components.finiteuses:SetOnFinished( onfinished )
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/luya.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip ) 
    return inst
end

return Prefab("luya", fn, assets, prefabs)


