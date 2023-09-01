local assets =
{
    Asset("ANIM", "anim/tz_darkhand_fx.zip"),
}

local prefabs =
{
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

	inst.AnimState:SetBank("tz_darkhand_fx")
    inst.AnimState:SetBuild("tz_darkhand_fx")
    inst.AnimState:PlayAnimation("one")
	inst.AnimState:SetFinalOffset(3)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    --inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 10 )

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.entity:SetCanSleep(false)
    inst.persists = false

	inst:ListenForEvent("animover", ErodeAway)

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

	inst.AnimState:SetBank("tz_darkhand_fx")
    inst.AnimState:SetBuild("tz_darkhand_fx")
    inst.AnimState:PlayAnimation("two")
	inst.AnimState:SetFinalOffset(3)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    --inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 10 )

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.entity:SetCanSleep(false)
    inst.persists = false

	inst:ListenForEvent("animover", ErodeAway)

    return inst
end

local function SetOwner(inst,owner)
    local x,y,z = owner.Transform:GetWorldPosition()
	inst.Transform:SetPosition(x,y,z)
	inst.Transform:SetRotation(owner.Transform:GetRotation() + 90 )
    inst.gensui = inst:DoPeriodicTask(0,function()
        if owner:IsValid() then
            local x,y,z = owner.Transform:GetWorldPosition()
            inst.Transform:SetPosition(x,y,z)
            inst.Transform:SetRotation(owner.Transform:GetRotation() + 90 )     
        end
    end)
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

	inst.AnimState:SetBank("tz_darkhand_fx")
    inst.AnimState:SetBuild("tz_darkhand_fx")
    inst.AnimState:PlayAnimation("three")
	inst.AnimState:SetFinalOffset(3)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    --inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 10 )

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.Set = SetOwner
	inst:ListenForEvent("animover", function()
        if inst.gensui then
            inst.gensui:Cancel()
            inst.gensui = nil
        end
        if inst.damagetask then
            inst.damagetask:Cancel()
            inst.damagetask = nil
        end
        ErodeAway(inst)
    end)
    return inst
end
local function fn4()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

	inst.AnimState:SetBank("tz_darkhand_fx")
    inst.AnimState:SetBuild("tz_darkhand_fx")
    inst.AnimState:PlayAnimation("four_a")
	inst.AnimState:SetFinalOffset(10)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.num  =  1

	inst.entity:SetCanSleep(false)
    inst.persists = false
    inst.DoKillSelf = function()
        inst.doremove = true
        if inst.damagetask then
            inst.damagetask:Cancel()
        end
        if inst.fx1 and inst.fx1:IsValid() then
            inst.fx1:DoKillSelf()
        end
        if inst.fx2 and inst.fx2:IsValid() then
            inst.fx2:DoKillSelf()
        end
        ErodeAway(inst)
    end

    inst.Set = SetOwner
	inst:ListenForEvent("animover", function()
        if inst.doremove then
            return
        end
        inst.num = inst.num + 1
        if inst.num > 15 then
            if inst.damagetask then
                inst.damagetask:Cancel()
            end
            ErodeAway(inst)
        else
            inst.AnimState:PlayAnimation("four_a")
            if inst.num == 6 then
                if inst.damagetask then
                    inst.damagetask:Cancel()
                end
                inst.damagetask = inst:DoPeriodicTask(0.15,function()
                    if inst.owner and inst.owner:IsValid() then
                        local x,y,z = inst.owner.Transform:GetWorldPosition()
                        local range = inst.range*(1+inst.rate)
                        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")
                        inst.damage(inst,x,y,z, range,nil,8,"tz_darkhand_fx_fx1",true,inst.adddamage or 0)
                    end
                end)
                inst.AnimState:SetDeltaTimeMultiplier(2) 
            end
        end
    end)
    inst.fx1 = inst:SpawnChild("tz_darkhand_fx_fx3")
    inst:DoTaskInTime(3,function()
        inst.fx2 = inst:SpawnChild("tz_darkhand_fx_fx4")
    end)
    return inst
end

local function fx3fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

	inst.AnimState:SetBank("tz_darkhand_fx")
    inst.AnimState:SetBuild("tz_darkhand_fx")
    inst.AnimState:PlayAnimation("four",true)
	inst.AnimState:SetFinalOffset(3)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.num  =  1
	inst.entity:SetCanSleep(false)
    inst.persists = false
    inst.DoKillSelf = function()
        inst.doremove = true
        ErodeAway(inst)    
    end
	inst:ListenForEvent("animover", function()
        if inst.doremove then
            return
        end
        inst.num = inst.num + 1
        if inst.num > 15 then
            ErodeAway(inst)
        else
            inst.AnimState:PlayAnimation("four")
            if inst.num == 6 then
                inst.AnimState:SetMultColour(.5, .5, .5, .5)
                inst.AnimState:SetDeltaTimeMultiplier(2) 
            end
        end
    end)
    return inst
end


local function fx1fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    local s  = 1.7
    inst.Transform:SetScale(s, s, s)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

	inst.AnimState:SetBank("tz_darkhand_fx")
    inst.AnimState:SetBuild("tz_darkhand_fx")
    inst.AnimState:PlayAnimation("att_fx_00"..math.random(3))
	inst.AnimState:SetFinalOffset(3)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.entity:SetCanSleep(false)
    inst.persists = false

	inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fx2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    local s  = 1.7
    inst.Transform:SetScale(s, s, s)
	inst.AnimState:SetBank("tz_darkhand_fx")
    inst.AnimState:SetBuild("tz_darkhand_fx")
    inst.AnimState:PlayAnimation("att_fx_004")
	inst.AnimState:SetFinalOffset(3)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.entity:SetCanSleep(false)
    inst.persists = false

	inst:ListenForEvent("animover", inst.Remove)

    return inst
end
local function fx4fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

	inst.AnimState:SetBank("tz_darkhand_fx")
    inst.AnimState:SetBuild("tz_darkhand_fx")
    inst.AnimState:PlayAnimation("four_b",false)
	inst.AnimState:SetFinalOffset(3)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.DoKillSelf = function()
        inst.doremove = true
        ErodeAway(inst)    
    end

	inst:ListenForEvent("animover", function()
        if inst.doremove then
            return 
        end
        ErodeAway(inst)    
    end)

    return inst
end
--DebugSpawn"tz_darkhand_fx_four"
return Prefab("tz_darkhand_fx_one", fn, assets),
    Prefab("tz_darkhand_fx_two", fn2, assets),   
    Prefab("tz_darkhand_fx_three", fn3, assets), 
    Prefab("tz_darkhand_fx_four", fn4, assets), 
	Prefab("tz_darkhand_fx_fx1", fx1fn),
	Prefab("tz_darkhand_fx_fx2", fx2fn),
    Prefab("tz_darkhand_fx_fx3", fx3fn),
    Prefab("tz_darkhand_fx_fx4", fx4fn)
