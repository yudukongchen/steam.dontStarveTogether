--------------------------------------------------------------------------
require "prefabutil"
require "modutil"
--------------------
require "recipe"
--------------------
local cooking = require("cooking")
--------------------

local assets=
{
	Asset("ANIM", "anim/elaina_bag.zip"),
	Asset("IMAGE", "images/inventoryimages/nicebigbag_open.tex"), --物品栏贴图
	Asset("ATLAS", "images/inventoryimages/nicebigbag_open.xml"),
	Asset("IMAGE", "images/inventoryimages/nicebigbag.tex"), --物品栏贴图
	Asset("ATLAS", "images/inventoryimages/nicebigbag.xml"),
}

--------------------------------------------------------------------------
local function getitem_nicebigbag(inst, data)
    if data and data.item ~= nil then
			-- if data.item:HasTag("spoiled") and data.item.components.perishable:GetPercent() < 1 then
                -- data.item.components.perishable:SetPercent(1)
				-- inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
            -- elseif data.item:HasTag("stale") and data.item.components.perishable:GetPercent() < 1 then
                -- data.item.components.perishable:SetPercent(1)
				-- inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
            -- elseif data.item:HasTag("fresh") and data.item.components.perishable:GetPercent() < 1 then
                -- data.item.components.perishable:SetPercent(1)
				-- inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
            -- end
            -- if data.item.components.finiteuses and data.item.components.finiteuses:GetPercent() < 1 then
                -- data.item.components.finiteuses:SetPercent(1)
				-- inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
            -- end
            -- if data.item.components.fueled and data.item.components.fueled:GetPercent() < 1 then
                -- data.item.components.fueled:SetPercent(1)
				-- inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
            -- end
            -- if data.item.components.armor and data.item.components.armor:GetPercent() < 1 then
                -- data.item.components.armor:SetPercent(1)
				-- inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
            -- end
		
		if data.item.prefab == "heatrock" then
			local currenttemp = data.item.components.temperature:GetCurrent()
			if TheWorld.state.iswinter and currenttemp <= 25 then
				data.item.components.temperature:SetTemperature(currenttemp + 40)
				inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
			elseif TheWorld.state.issummer and currenttemp >= 30 then
				data.item.components.temperature:SetTemperature(currenttemp - 40)
				inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
			end
		end
		
	end
end

local function insulatorstate(inst)
	if inst.components.insulator ~= nil then
		inst:RemoveComponent("insulator") 
	end
	if TheWorld.state.iswinter then
		inst:AddComponent("insulator") 
		inst.components.insulator:SetWinter()
		inst.components.insulator:SetInsulation(500)
	elseif TheWorld.state.issummer then
		inst:AddComponent("insulator") 
		inst.components.insulator:SetSummer()
		inst.components.insulator:SetInsulation(500)
	end

end

local function DoBenefit_nicebigbag(inst)
    if not TheWorld.state.isfullmoon then
		return
	else
	if TUNING.NICE_BAGREFRESH and inst.components.container and not inst.components.container:IsEmpty() then
	local owner = inst.components.inventoryitem.owner
	if owner ~= nil then
	inst.components.container:Close()
	owner:DoTaskInTime(
            0.5,
            function()
                owner.components.inventory:DropItem(inst)
            end
     )
	 end

    inst:DoTaskInTime(3, function()
        for i = 1, inst.components.container.numslots do
            local item = inst.components.container.slots[i]
            if item ~= nil then
                if item:HasTag("spoiled") then
                    item.components.perishable:SetPercent(1)
                elseif item:HasTag("stale") then
                    item.components.perishable:SetPercent(1)
                elseif item:HasTag("fresh") then
                    item.components.perishable:SetPercent(1)
                end
                if item.components.finiteuses then
                    item.components.finiteuses:SetPercent(1)
                end
                if item.components.fueled then
                    item.components.fueled:SetPercent(1)
                end
                if item.components.armor then
                    item.components.armor:SetPercent(1)
                end
            end
        end
	   
        for i = 1, inst.components.container.numslots do
            local item = inst.components.container.slots[i]
            if item ~= nil then
                if item.components.stackable then
					local itemnum = item.components.stackable:StackSize()
					if itemnum <= item.components.stackable.maxsize/2 then
						item.components.stackable:SetStackSize(itemnum*2)
					else
						item.components.stackable:SetStackSize(item.components.stackable.maxsize)
					end
                end
            end
        end
	
        local fx = SpawnPrefab("chesterlight")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:TurnOn()
        inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/raise")
        inst:DoTaskInTime(1, function()
            if fx ~= nil then
                fx:TurnOff()
            end
        end)
    end)
	end
	end
end


local function onopen(inst)
	inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	if inst.components.inventoryitem then
		inst.components.inventoryitem.imagename = "nicebigbag_open"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/nicebigbag_open.xml"
	end
end

local function onclose(inst)
	inst.AnimState:PlayAnimation("closed")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	if inst.components.inventoryitem then
		inst.components.inventoryitem.imagename = "nicebigbag"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/nicebigbag.xml"
	end
end

local function ondropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
	inst.AnimState:SetBank("elaina_bag")
    inst.AnimState:SetBuild("elaina_bag")
    inst.AnimState:PlayAnimation("idle")
end
--------------------


local function onequip(inst,owner)
    inst.Light:Enable(true)
	
	owner.AnimState:OverrideSymbol("backpack", "elaina_bag", "backpack")
	owner.AnimState:OverrideSymbol("swap_body", "elaina_bag", "swap_body")
    owner:AddTag("fastpicker")  --蜘蛛快采
	owner:AddTag("fastpick")    --成就快采
	if inst.components.container ~= nil then
       inst.components.container:Open(owner)
    end
	if inst.components.container and inst.components.container:IsOpen() then
		inst.components.inventoryitem.imagename = "nicebigbag_open"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/nicebigbag_open.xml"
	else
		inst.components.inventoryitem.imagename = "nicebigbag"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/nicebigbag.xml"
	end
	--insulatorstate(inst)
end


local function onunequip(inst, owner)
    -- light
    inst.Light:Enable(false)
	owner.AnimState:ClearOverrideSymbol("swap_body")
	owner.AnimState:ClearOverrideSymbol("backpack")
     if inst.components.container ~= nil then
		inst.components.container:Close(owner)
	end
	owner:RemoveTag("fastpick")
	owner:RemoveTag("fastpicker")
	if inst.components.container and inst.components.container:IsOpen() then
		inst.components.inventoryitem.imagename = "nicebigbag_open"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/nicebigbag_open.xml"
	else
		inst.components.inventoryitem.imagename = "nicebigbag"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/nicebigbag.xml"
	end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
    --------------------
    -- This needs to be in any entity that you want to create on the server 
    -- and have it show up for all players. 
    -- Most things have this, but in a few cases you want things to 
    -- only exist on the server (e.g. meteorspawners, which are invisible), 
    -- and in some very rare cases you may want to create things independently on each client.
    --------------------
	MakeInventoryPhysics(inst)
	
	inst.MiniMapEntity:SetIcon("nicebigbag.tex")

    inst.entity:AddLight()
    inst.Light:Enable(false)
    inst.Light:SetRadius(0.25)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.25)
    inst.Light:SetColour(255/255,255/255,255/255)
	
	inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("elaina_bag")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("backpack")
    inst:AddTag("fridge")
    inst:AddTag("nocool")
    inst:AddTag("umbrella")
    inst:AddTag("waterproofer")
    inst:AddTag("nicebigbag")
	inst:AddTag("keepfresh")
	
	
	inst.foleysound = "dontstarve/movement/foley/krampuspack"
	MakeInventoryFloatable(inst, "med", 0.1, 0.65)
	

    --------------------
    inst.entity:SetPristine()
    -- This basically says "everything above this was done on both the client or the server, 
    -- so don't bother networking any of that". 
    -- This reduces a bit of the bandwidth used by creating entities. 
    -- I can't think of a case where you wouldn't want this immediately 
    -- after the "if not TheWorld.ismastersim then return inst end" part, 
    -- which is where you'll see it in the game's code.
    --------------------

    --------------------
    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
        inst.replica.container:WidgetSetup("nicebigbag")
		inst.replica.container.onopenfn = onopen
		inst.replica.container.onclosefn = onclose
        end
        return inst
    end
    -- This is really important for almost all prefabs. 
    -- This essentially says "if this is running on the client, stop here". 
    -- Almost all components should only be created on the server 
    -- (the really important ones will get replicated to the client through the replica system). 
    -- Visual things and tags that will always be added can go above this, though.
    --------------------
	if inst.components.preserver==nil then
		inst:AddComponent("preserver")
	end
	inst.components.preserver:SetPerishRateMultiplier(function(inst, item)
	return (item ~= nil) and 0 or nil
	end)

	
	inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.2
    
	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/nicebigbag.xml"
	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem.cangoincontainer = true -- [[can be carried]]!!!!!!!!!!!!!!!!!!!!
	inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"

	inst:AddComponent("waterproofer")
    -- inst.components.waterproofer:SetEffectiveness(0)
	
	insulatorstate(inst)
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("nicebigbag")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
	inst:ListenForEvent("itemget", getitem_nicebigbag)
	inst:WatchWorldState("isfullmoon", DoBenefit_nicebigbag)
	inst:WatchWorldState("isday", insulatorstate)
	
    return inst
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

return Prefab("nicebigbag", fn, assets)
