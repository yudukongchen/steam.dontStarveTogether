local assets =
{
    Asset( "ANIM", "anim/tz_xx_flash.zip" ),
    Asset( "ANIM", "anim/tz_xx_reticuleaoe.zip" ),	
    Asset( "ANIM", "anim/tz_xx_light_on.zip" ),		
}

--闪电
local function DoDamage(inst)
	local x, y, z = inst.Transform:GetWorldPosition()	
	for i, v in ipairs(TheSim:FindEntities(x, 0, z, 6.5, {"_combat", }, { "playerghost", "INLIMBO", "player","companion","wall","abigail"})) do
		if v and  v:IsValid() and not v:IsInLimbo() and not (v.components.health ~= nil and v.components.health:IsDead()) then
			local attacker = inst.owner
			local damage = (300+ (attacker.lingxxdamage or 0)) * (attacker.addxxdamagemultiplier or 1)
			if attacker ~= nil and attacker:IsValid() and attacker.components.combat and attacker.components.combat:CanTarget(v) then
				v.components.combat:GetAttacked(attacker, damage)
				
				if  v.tz_shandian_fx and v.tz_shandian_fx:IsValid() then
					v.tz_shandian_fx:Remove()
				end
				v.tz_shandian_fx = SpawnPrefab("tz_shandian_fx")
				v.tz_shandian_fx.entity:SetParent(v.entity)					
			end
		end
	end
end

local function flashfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLight()

    inst.AnimState:SetBank("tz_xx_flash") 
	inst.AnimState:SetBuild("tz_xx_flash")
    inst.AnimState:PlayAnimation("flash")
	inst.Transform:SetScale(2.5, 2.5, 2.5)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/shocked")
	
	inst.Light:Enable(true)
	inst.Light:SetRadius(3)
	inst.Light:SetFalloff(.9)
	inst.Light:SetIntensity(.9)
	inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
	inst.AnimState:SetLightOverride(1)
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("fx")
	inst:AddTag("tz_xx_flash")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false 
	
	inst:DoTaskInTime(0.2,DoDamage)
	inst:ListenForEvent("animover", inst.Remove)
    return inst
end

local function fuzhoufn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tz_xx_reticuleaoe") 
	inst.AnimState:SetBuild("tz_xx_reticuleaoe")
    inst.AnimState:PlayAnimation("tz_fuzhou_loop")
	--inst.AnimState:SetAddColour(1, 1, 0, 1)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("fx")
	inst:AddTag("tz_xx_fuzhou")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false 
	
	inst:ListenForEvent("animover", inst.Remove)
    return inst
end

local function kill(inst)
	if not inst.killed then
		inst.killed  = true
		if inst.owner then
			inst.owner.daweifx = nil
		end
		ErodeAway(inst)
	end
	
end

local function loop(inst)
	inst.AnimState:PlayAnimation("tz_fazhen_loop",true)
	inst:DoTaskInTime(12,kill)
end

local function daweifn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tz_xx_reticuleaoe") 
	inst.AnimState:SetBuild("tz_xx_reticuleaoe")
    inst.AnimState:PlayAnimation("tz_fazhen_pre")
	inst.Transform:SetScale(1.06, 1.06, 1.06)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	--inst.AnimState:SetAddColour(1, 1, 0, 1)
	inst:AddTag("NOBLOCK")
	inst:AddTag("fx")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false 
	inst.Kill = kill
	inst:ListenForEvent("animover", loop)
    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
	
	inst.Light:Enable(true)
	inst.Light:SetRadius(16)
	inst.Light:SetFalloff(0.8)
	inst.Light:SetIntensity(.9)
	inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)

	inst:AddTag("NOBLOCK")
	inst:AddTag("fx")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false 
    return inst
end

--light
local MAX_LIGHT_ON_FRAME = 15
local MAX_LIGHT_OFF_FRAME = 30
local function OnUpdateLight(inst, dframes)
    local frame = inst._lightframe:value() + dframes
    if frame >= inst._lightmaxframe then
        inst._lightframe:set_local(inst._lightmaxframe)
        inst._lighttask:Cancel()
        inst._lighttask = nil
    else
        inst._lightframe:set_local(frame)
    end
    local k = frame / inst._lightmaxframe
    if inst._islighton:value() then
        inst.Light:SetRadius(4 * k)
    else
        inst.Light:SetRadius(4 * (1 - k))
    end
    if TheWorld.ismastersim then
        inst.Light:Enable(inst._islighton:value() or frame < inst._lightmaxframe)
        if not inst._islighton:value() then
        end
    end
end

local function OnLightDirty(inst)
    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    inst._lightmaxframe = inst._islighton:value() and MAX_LIGHT_ON_FRAME or MAX_LIGHT_OFF_FRAME
    OnUpdateLight(inst, 0)
end 
local function Turnoon(inst)
    if not inst._islighton:value() then
        inst._islighton:set(true)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_OFF_FRAME) * MAX_LIGHT_ON_FRAME + .5))
		inst.AnimState:PlayAnimation("light_pre")
		inst.AnimState:PushAnimation("light_loop")
        OnLightDirty(inst)
    end
end	

local function Turnoff(inst)
    if inst._islighton:value() then
        inst._islighton:set(false)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_ON_FRAME) * MAX_LIGHT_OFF_FRAME + .5))
		inst.AnimState:PlayAnimation("light_pst")
        OnLightDirty(inst)
		inst:ListenForEvent("animover", inst.Remove)
    end
end

local function lighton()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst:AddTag("FX")
    inst.AnimState:SetBank("tz_xx_light_on")
    inst.AnimState:SetBuild("tz_xx_light_on")
	inst.Light:Enable(false)
	inst.Light:SetRadius(0)
	inst.Light:SetFalloff(0.8)
	inst.Light:SetIntensity(.9)
	inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
	inst.Light:EnableClientModulation(true)
	inst._lightframe = net_smallbyte(inst.GUID, "tzxx_light", "tzxx_lightdirty")
	inst._islighton = net_bool(inst.GUID, "tzxx_lighton", "tzxx_lightdirty")
	inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
	inst._lightframe:set(inst._lightmaxframe)
	inst._lighttask = nil
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("tzxx_lightdirty", OnLightDirty)
        return inst
    end
    inst.persists = false
	inst.Turnoon = Turnoon
	inst.Turnoff = Turnoff
    return inst
end

return Prefab("tz_xx_flash", flashfn, assets),
		Prefab("tz_xx_fuzhou", fuzhoufn),
		Prefab("tz_xx_light", lightfn),
		Prefab("tz_xx_light_on", lighton),
		Prefab("tz_xx_fazhen", daweifn)