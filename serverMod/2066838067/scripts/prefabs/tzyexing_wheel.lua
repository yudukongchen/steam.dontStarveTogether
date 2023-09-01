local assets =
{
    Asset("ANIM", "anim/tzyexing_wheel.zip"),
}


local function ToggleSpin(inst, spin) 
	if spin then
        if spin >=0  and spin < 20 	then
			inst.AnimState:PlayAnimation("level_1", true)
        elseif spin >=20  and spin < 40 	then
			inst.AnimState:PlayAnimation("level_2", true)
        elseif spin >=20  and spin < 40 	then
			inst.AnimState:PlayAnimation("level_2", true)		
        elseif spin >=40  and spin < 60 	then
			inst.AnimState:PlayAnimation("level_3", true)		
        elseif spin >=60  and spin < 80 	then
			inst.AnimState:PlayAnimation("level_4", true)
        elseif spin >=80  and spin < 100 	then
			inst.AnimState:PlayAnimation("level_5", true)
		elseif spin ==100 then
            inst.AnimState:PlayAnimation("level_6", true)
		end
	end
end

local function CreateFanWheelFX(proxy)
    local parent = proxy.entity:GetParent()
    if parent == nil then
        return
    end

    local inst = CreateEntity()

    inst:AddTag("FX")
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddFollower()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("tzyexing_wheel")
    inst.AnimState:SetBuild("tzyexing_wheel")
    inst.AnimState:PlayAnimation("level_1",true)
    inst.AnimState:SetFinalOffset(1)
	inst.AnimState:SetSortOrder(-3)

    inst.entity:SetParent(parent.entity)
    inst.Follower:FollowSymbol(parent.GUID, "swap_object", 22, -277, 0)

    inst._toggle = false
    inst:ListenForEvent("isyexingdirty", function() ToggleSpin(inst, proxy._isspinning:value()) end, proxy)
    ToggleSpin(inst, proxy._isspinning:value())

    inst:ListenForEvent("onremove", function() inst:Remove() end, proxy)
end

local function SetSpinning(inst, isspinning)
    inst._isspinning:set(isspinning)
end

local function transfertostatemem(inst, sg)
    if sg.statemem.followfx == nil then
        sg.statemem.followfx = { inst }
    else
        table.insert(sg.statemem.followfx, inst)
    end
end

local function delayedremove(inst)
    inst._timeout = inst:DoTaskInTime(0, inst.Remove)
end

local function StartUnequipping(inst, item)
    local parent = inst.entity:GetParent()
    if parent == nil or
        item.components.inventoryitem == nil or
        item.components.inventoryitem.owner ~= parent then
        inst:Remove()
        return
    end

    inst:ListenForEvent("ondropped", function() inst:Remove() end, item)
    if parent.sg.currentstate.name ~= "item_in" then
        inst._timeout = inst:DoTaskInTime(0, delayedremove)
        inst:ListenForEvent("newstate", function(parent, data)
            if data.statename ~= "item_in" then
                inst:Remove()
            else
                inst._timeout:Cancel()
                transfertostatemem(inst, parent.sg)
            end
        end, parent)
    else
        transfertostatemem(inst, parent.sg)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    -----------------------------------------------------
    inst:AddTag("FX")

    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, CreateFanWheelFX)
    end
	inst._isspinning = net_byte(inst.GUID, "tzyexing_wheel._isspinning", "isyexingdirty")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SetSpinning = SetSpinning
    inst.StartUnequipping = StartUnequipping

    inst.persists = false

    return inst
end
return Prefab("tzyexing_wheel", fn, assets)
