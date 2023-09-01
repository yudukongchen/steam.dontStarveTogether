local function emptyfn()
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    return inst
end

local function emptypingfn()
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:DoTaskInTime(0.5, inst.Remove)

    return inst
end

local assets =
{
    Asset("ANIM", "anim/reticuleaoe.zip"),
    --Asset("ANIM", "anim/reticuleaoebase.zip"),
}

local PAD_DURATION = .1
local SCALE = 1.5
local FLASH_TIME = .3

local function MakeReticule(name, anim)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.AnimState:SetBank("reticuleaoe")
        inst.AnimState:SetBuild("reticuleaoe")
        inst.AnimState:PlayAnimation(anim)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
        inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
        inst.AnimState:SetScale(SCALE, SCALE)

        inst:AddTag("FX")
        inst:AddTag("NOCLICK")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end
        inst.entity:SetCanSleep(false)
        inst.persists = false
	    inst:ListenForEvent("animover", function(inst)
		    inst:DoTaskInTime(1,inst.Remove)
	    end)
        return inst
    end

    return Prefab(name, fn, assets)
end
return Prefab("tz_reticule_empty", emptyfn),
    Prefab("tz_reticule_emptyping", emptypingfn),
    MakeReticule("tz_reticuleaoesmall", "idle_small")