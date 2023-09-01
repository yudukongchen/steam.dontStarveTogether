
local assets=
{
	Asset("ANIM", "anim/asa_vizard.zip"),  --动画文件
	Asset("IMAGE", "images/inventoryimages/asa_vizard.tex"), --物品栏贴图
	Asset("ATLAS", "images/inventoryimages/asa_vizard.xml"),
}

local prefabs =
{
	"asa_alertring",
}

local function onunequiphat(inst, owner) --解除帽子
	inst.components.fueled:StopConsuming()

	owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/charge")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
	
	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
	else 
		return
	end

	if owner:HasTag("asakiri") then
		owner._zanvision:set(owner._zanvision:value() - 1)
	else
		owner.scanvision:set(owner.scanvision:value() - 1)
	end
	if owner.alerttask ~= nil then
		owner.alerttask:Cancel()
		owner.alerttask = nil
	end
	if owner.targettask ~= nil then
		owner.targettask:Cancel()
		owner.targettask = nil
	end
	if owner.epictask ~= nil then
		owner.epictask:Cancel()
		owner.epictask = nil
	end
end

local function opentop_onequip(inst, owner)
--这里其实跟装备是一样的 唯一的区别是这个不会隐藏head 这样适用于花环之类的不会遮住头发的帽子
	owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/vizard", nil, 0.4)
	owner.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/equip2", nil, 0.7)
	owner.AnimState:OverrideSymbol("swap_hat", "asa_vizard", "swap_hat")
	owner.AnimState:Show("HAT")
	owner.AnimState:Hide("HAT_HAIR")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	
	owner.AnimState:Show("HEAD")
	owner.AnimState:Hide("HEAD_HAIR")

	if not owner:HasTag("player") then
        return
    end

	inst.components.fueled:StartConsuming()

	if owner:HasTag("asakiri") then
		owner._zanvision:set(owner._zanvision:value() + 1)
	else
		owner.scanvision:set(owner.scanvision:value() + 1)
	end
	
	owner.alerttask = owner:DoPeriodicTask(1.2,function()	--地下威胁指示器
		local pos = owner:GetPosition()
		local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,25,{"hostile"})
		for k,v in pairs(ents) do
			if v:HasTag("tentacle") or v:HasTag("worm") then
				if not v.alertfx then
					v.alertfx = SpawnPrefab("asa_alertring") 
					v.alertfx.Transform:SetPosition(v.Transform:GetWorldPosition())
					v:DoTaskInTime(0.9,function()
						v.alertfx = nil
					end)
				end
			end
		end
	end)
	
	owner.targettask = owner:DoPeriodicTask(1.2,function()	--威胁生物指示器
		local pos = owner:GetPosition()
		local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,40,{"_combat"},{"epic", "tentacle", "shadowcreature"})
		for k,v in pairs(ents) do
			if not (((v.replica.inventoryitem and v.replica.inventoryitem.owner == owner))
					or (TheWorld.ismastersim and (v.components.inventoryitem and v.components.inventoryitem.owner == owner)))
					and (v:HasTag("hostile") or (v.components.combat and v.components.combat.defaultdamage ~= 0 and v.components.combat.target == owner))

			then
				local fx = SpawnPrefab("asa_targetring")
				fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
				fx:FacePoint(v.Transform:GetWorldPosition())
				if v:HasTag("hive") or v:HasTag("structure") then
					fx.AnimState:SetScale(2,2,2)
				end
			end
		end
	end)
	
	owner.epictask = owner:DoPeriodicTask(1,function()	--BOSS指示器
		local pos = owner:GetPosition()
		local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,80,{"epic"})
		for k,v in pairs(ents) do
			local dist = math.sqrt(v:GetDistanceSqToInst(owner))
			if dist > 15 then
				local fx = SpawnPrefab("asa_targetring")
				local s = 7
				fx.AnimState:SetScale(s,s,s)
				fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
				fx:FacePoint(v.Transform:GetWorldPosition())
			end
		end
	end)
	   
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("asa_vizard")  --地上动画
    inst.AnimState:SetBuild("asa_vizard")
    inst.AnimState:PlayAnimation("anim")

	inst:AddTag("hat")
	inst:AddTag("nightvision")
	inst:AddTag("asa_vizard")
	inst:AddTag("asa_item")
    	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable") --可检查

	inst:AddComponent("inventoryitem") --物品组件
	inst.components.inventoryitem.imagename = "asa_vizard"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_vizard.xml"

	inst:AddComponent("equippable") --装备组件
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD --装在头上
	-- inst.components.equippable:SetOnEquip( onequiphat ) --装备
	inst.components.equippable:SetOnUnequip( onunequiphat ) --解除装备
	--inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE  --装备回复san
	inst.components.equippable:SetOnEquip(opentop_onequip) --这个只适用于不会遮住头发的帽子 才会加上这一条  没用就删除

	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.CAVE
	inst.components.fueled.accepting = true
	inst.components.fueled:InitializeFuelLevel(960)
	inst.components.fueled:SetDepletedFn(function()
		local owner = inst.components.inventoryitem.owner
		owner.components.inventory:GiveItem(SpawnPrefab("asa_boost"), nil, owner:GetPosition())
		inst:Remove()
	end)
	MakeHauntableLaunch(inst) --作祟相关
    return inst
end 
    
return Prefab( "common/inventory/asa_vizard", fn, assets, prefabs) 