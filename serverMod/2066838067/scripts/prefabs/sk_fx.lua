local assets =
{
    Asset("ANIM", "anim/tz_rection_01.zip"),
}

local assets03 =
{
    Asset("ANIM", "anim/tz_Effects_01.zip"),
}

local assets04 =
{
    Asset("ANIM", "anim/QM_ALLSK.zip"),
}

local assets06 =
{
    Asset("ANIM", "anim/reticulearc.zip"),
}

local assets07 =
{
    Asset("ANIM", "anim/cddt.zip"),
}


local assets10 = 
{
    Asset("ANIM", "anim/tz_hit_fx.zip"),
}

local assets11 = 
{
    Asset("ANIM", "anim/tz_red_light.zip"),
	Asset("ANIM", "anim/forcefield.zip"),
    Asset("IMAGE", "fx/smoke.tex"),
    Asset("SHADER", "shaders/vfx_particle_add.ksh"),
}

local assets12 = 
{
    Asset("ANIM", "anim/tz_buff_fx_a.zip"),
	Asset("ANIM", "anim/tz_eyes.zip"),
	Asset("ANIM", "anim/tz_eyes_fx.zip"),
}

local assets15 = 
{
    Asset("ANIM", "anim/tz_chongci_fx.zip")
}



local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tz_rection")
    inst.AnimState:SetBuild("tz_rection_01")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")
    inst.AnimState:SetLightOverride(1)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:ListenForEvent("animover", inst.Remove)
	
	inst.persists = false

    return inst
end

local function fn02()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("tz_shadow_01")
    inst.AnimState:SetBuild("tz_shadow_01")
    inst.AnimState:PlayAnimation("shadow")
    inst.AnimState:SetLightOverride(1)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:DoTaskInTime(3, inst.Remove)
	
	inst.persists = false

    return inst
end

local function fn03()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("tz_Effects_01")
    inst.AnimState:SetBuild("tz_Effects_01")
    inst.AnimState:PlayAnimation("huichen")

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:ListenForEvent("animover", inst.Remove)

	inst:DoTaskInTime(3, inst.Remove)
	
	inst.persists = false

    return inst
end

local itemji = {
	["item_NaiHan01"] = 2,
	["item_NaiHan02"] = 2,
	["item_NaiRe01"] = 2,
	["item_NaiRe02"] = 2,
	
	["item_z_ljs"] = 1,
}

local function GetItemJi(data, zu, key, anim)
	local function fn04()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		inst.AnimState:SetBank("QM_ALLSK")
		inst.AnimState:SetBuild("QM_ALLSK")
		inst.AnimState:PlayAnimation(anim)
		
		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst, "med", nil, 0.6)
		
		inst.entity:SetPristine()
		
		inst:AddTag("QM_SK")
		
		if not TheWorld.ismastersim then
			return inst
		end
		inst.zu = zu
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/QM_UI10.xml"
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("xuexiji")
		inst.components.xuexiji:SetData(key, zu)
		
		MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
		MakeSmallPropagator(inst)
		
		return inst
	end
	return Prefab(string.lower(data), fn04, assets04)
end

local tbl03 = {}
for k1,v1 in pairs(QMSkTable) do
	for k,v in pairs(v1) do
		table.insert(tbl03, GetItemJi("item_" .. v.tex, k1, k, k1 == 1 and "item_z_ljs" or 'item_NaiRe01'))
		--table.insert(tbl03, GetItemJi( k1 == 1 and "item_z_ljs" or 'item_NaiRe01', k1, k))
	end
end
---------------------------
local function fn06()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	inst.AnimState:SetBank("reticulearc")
	inst.AnimState:SetBuild("reticulearc")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetScale(1.5, 1.5)

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:DoTaskInTime(5, inst.Remove)
	
	inst.persists = false

    return inst
end

local function fn07()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	inst.AnimState:SetBank("cdkuai")
	inst.AnimState:SetBuild("cddt")
	inst.AnimState:PlayAnimation("idle")


    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:DoTaskInTime(5, inst.Remove)
	
	inst.persists = false

    return inst
end


local function fn10()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("tz_killknife_fx")
    inst.AnimState:SetBuild("tz_hit_fx")
    inst.AnimState:PlayAnimation("hit"..math.random(0,5))
    inst.AnimState:SetLightOverride(1)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SetTargetPos = function(inst, pos)
		inst.Transform:SetPosition(pos.x, 1, pos.z)
	end
	
	inst:ListenForEvent("animover", inst.Remove)

	inst:DoTaskInTime(3, inst.Remove)
	
	inst.persists = false

    return inst
end
-----------------------------
local SYSMAX = 10
local function tab_fn01(inst)
	if inst._bool then
		inst.AnimState:PlayAnimation("idle_tab")
		inst.AnimState:PushAnimation("idle_02", true)
		inst._bool = nil
		inst:RemoveTag("ShengYu")
	else
		local x, _, z = inst.Transform:GetWorldPosition()
		local ens = TheSim:FindEntities(x, 0, z, 10, {"player","_health"}, {"playerghost"})
		for i,v in ipairs(AllPlayers) do
			if v:IsValid() and not v.components.health:IsDead() and v.components.health.canheal and v.components.health:IsHurt() then
				v.components.health:DoDelta(TUNING.REDAMULET_CONVERSION, true, "redamulet")
			end
		end
	end
end


local function hudunfx()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("forcefield")
    inst.AnimState:SetBuild("forcefield")
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("idle_loop", true)
	inst.AnimState:SetAddColour(1, 1, 0, 1)
	inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
	
	inst._CD = FRAMES * 3
	inst._task03 = inst:DoPeriodicTask(FRAMES, function()
		inst._CD = inst._CD - FRAMES
		if inst._CD <= 0 then
			inst.AnimState:PlayAnimation("close")
			local ow = inst.entity:GetParent()
			if ow ~= nil then
				ow._hudunfx = nil
			end
			inst:DoTaskInTime(.6, inst.Remove)
			inst._task03:Cancel()
			inst._task03 = nil
		end
	end)
	
	inst:ListenForEvent("onremove", function()
		inst.entity:SetParent(nil)
	end)
	
	return inst
end

local function tab_fn02()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:SetCanSleep(false)
    inst.AnimState:SetBank("tz_shengyu")
    inst.AnimState:SetBuild("tz_red_light")
    inst.AnimState:PlayAnimation("huan_01_pro")
	inst.AnimState:PushAnimation("idlehuan_01", true)
    inst.AnimState:SetLightOverride(1)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")
	inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
	
	inst.persists = false

	inst._task01 = inst:DoPeriodicTask(FRAMES, function()
		for k,v in pairs(AllPlayers) do
			if v:IsValid() and inst:IsNear(v, SYSMAX) then
				if v._hudunfx then
					if v._hudunfx._CD then
						v._hudunfx._CD = FRAMES * 3
					end
				else
					v._hudunfx = hudunfx()
					v._hudunfx.entity:SetParent(v.entity)
				end
			end
		end
	end)
	
	inst:DoTaskInTime(9, function()
		if inst._task01 then
			inst._task01:Cancel()
			inst._task01 = nil
		end
		inst.AnimState:PlayAnimation("huan_02_pro")
		inst.AnimState:PushAnimation("idlehuan_02", true)
	end)

	return inst
end

local SYSMAX = 10
local function tab_fn01(inst)
	if inst._bool then
		inst.AnimState:PlayAnimation("idle_tab")
		inst.AnimState:PushAnimation("idle_02", true)
		inst._bool = nil
		inst:RemoveTag("ShengYu")
	else
		local x, _, z = inst.Transform:GetWorldPosition()
		local ens = TheSim:FindEntities(x, 0, z, 10, {"player","_health"}, {"playerghost"})
		for i,v in ipairs(AllPlayers) do
			if v:IsValid() and not v.components.health:IsDead() and v.components.health.canheal and v.components.health:IsHurt() then
				v.components.health:DoDelta(TUNING.REDAMULET_CONVERSION, true, "redamulet")
			end
		end
	end
end
local SPARKLE_TEXTURE = "fx/smoke.tex"
local ADD_SHADER = "shaders/vfx_particle_add.ksh"
local MAX_LIFETIME = 1
local COLOUR_ENVELOPE_NAME = "qm_colour005"
local SCALE_ENVELOPE_NAME = "qm_scale005"

local function IntColour(r, g, b, a)
    return { r / 255, g / 255, b / 255, a / 255 }
end

local function InitEnvelope()
    local envs = {}
	table.insert(envs, { 0, IntColour(36, 255, 57, 255) })
	table.insert(envs, { 0.5, IntColour(200, 255, 200, 255) })
	table.insert(envs, { 1, IntColour(0, 255, 0, 0) })

    EnvelopeManager:AddColourEnvelope(COLOUR_ENVELOPE_NAME, envs)
	local sparkle_max_scale = 1
    EnvelopeManager:AddVector2Envelope(
        SCALE_ENVELOPE_NAME,
        {
            { 0,    { sparkle_max_scale * 0.1, sparkle_max_scale * 1 } },
			{ 0.5,    { sparkle_max_scale * 0.1, sparkle_max_scale * 1.3 } },
            { 1,    { sparkle_max_scale * 0.1, sparkle_max_scale * 0.05 } },
        }
    )
	
    InitEnvelope = nil
    IntColour = nil
end

local function hudunfx()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("forcefield")
    inst.AnimState:SetBuild("forcefield")
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("idle_loop", true)
	inst.AnimState:SetAddColour(1, 1, 0, 1)
	inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
	
	inst._CD = FRAMES * 3
	inst._task03 = inst:DoPeriodicTask(FRAMES, function()
		inst._CD = inst._CD - FRAMES
		if inst._CD <= 0 then
			inst.AnimState:PlayAnimation("close")
			local ow = inst.entity:GetParent()
			if ow ~= nil then
				ow._hudunfx = nil
			end
			inst:DoTaskInTime(.6, inst.Remove)
			inst._task03:Cancel()
			inst._task03 = nil
		end
	end)
	
	inst:ListenForEvent("onremove", function()
		inst.entity:SetParent(nil)
	end)
	
	return inst
end

local function tab_fn02()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:SetCanSleep(false)
    inst.AnimState:SetBank("tz_shengyu")
    inst.AnimState:SetBuild("tz_red_light")
    inst.AnimState:PlayAnimation("huan_01_pro")
	inst.AnimState:PushAnimation("idlehuan_01", true)
    inst.AnimState:SetLightOverride(1)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")
	inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
	
	inst.persists = false

	inst._task01 = inst:DoPeriodicTask(FRAMES, function()
		for k,v in pairs(AllPlayers) do
			if v:IsValid() and inst:IsNear(v, SYSMAX) then
				if v._hudunfx then
					if v._hudunfx._CD then
						v._hudunfx._CD = FRAMES * 3
					end
				else
					v._hudunfx = hudunfx()
					v._hudunfx.entity:SetParent(v.entity)
				end
			end
		end
	end)
	
	inst:DoTaskInTime(9, function()
		if inst._task01 then
			inst._task01:Cancel()
			inst._task01 = nil
		end
		inst.AnimState:PlayAnimation("huan_02_pro")
		inst.AnimState:PushAnimation("idlehuan_02", true)
	end)

	return inst
end

local function fn11()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:SetCanSleep(false)
    inst.AnimState:SetBank("tz_shengyu")
    inst.AnimState:SetBuild("tz_red_light")
	inst.AnimState:PlayAnimation("idle_pro")
    inst.AnimState:PushAnimation("idle_01", true)
    inst.AnimState:SetLightOverride(1)

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
	inst:AddTag("ShengYu")

    inst.entity:SetPristine()

    if not TheNet:IsDedicated() then
		if InitEnvelope then
			InitEnvelope()
		end
		
		local effect = inst.entity:AddVFXEffect()
		effect:InitEmitters(1)
		effect:SetRenderResources(0, SPARKLE_TEXTURE, ADD_SHADER)
		effect:SetRotationStatus(0, true)
		effect:SetUVFrameSize(0, .25, 1)
		effect:SetMaxNumParticles(0, 1024)
		effect:SetMaxLifetime(0, MAX_LIFETIME)
		effect:SetColourEnvelope(0, COLOUR_ENVELOPE_NAME)
		effect:SetScaleEnvelope(0, SCALE_ENVELOPE_NAME)
		effect:SetBlendMode(0, 3)
		effect:EnableBloomPass(0, true)
		effect:SetSortOrder(0, 0)
		effect:SetSortOffset(0, 10)
		
		inst:DoPeriodicTask(FRAMES, function()
			local x,y,z = inst.Transform:GetWorldPosition()
			for k,v in pairs(AllPlayers) do
				if inst:IsNear(v, SYSMAX) then
					local x1,y1,z1 = v.Transform:GetWorldPosition()
					local x2,z2 = x1 - x, z1 - z
					for i=0, math.random(2, 5) do
						effect:AddRotatingParticleUV(0, MAX_LIFETIME * math.random(),
						x2 + UnitRand() * 0.5, 1, z2 + UnitRand() * 0.5,
						0,0.02,0,0,0,math.random(0,3)*0.25,0
						)
					end
				end
			end
		end, 9)
		
		local fx = tab_fn02()
		fx.entity:SetParent(inst.entity)
        return inst
    end
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_smoke")
	inst.SoundEmitter:PlaySound("dontstarve/common/staff_star_LP", "staff_star_loop")
	
	inst._bool = true
	
	inst:DoPeriodicTask(1, tab_fn01, 9)
	
	inst:DoTaskInTime(20, function(inst)
		inst.AnimState:PlayAnimation("idle_over")
		inst:ListenForEvent("animover", inst.Remove)
	end)
	
	inst.persists = false

    return inst
end

local function fn12()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:SetCanSleep(false)
    inst.AnimState:SetBank("tz_eyes")
    inst.AnimState:SetBuild("tz_eyes")
	inst.AnimState:PlayAnimation("eyes_pre")
    inst.AnimState:PushAnimation("eyes_loop", false)
	inst.AnimState:PushAnimation("eyes_pst", false)
    inst.AnimState:SetLightOverride(1)

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
	inst:AddTag("RuoDian")

    inst.entity:SetPristine()

	inst:ListenForEvent("animqueueover", function()
		if inst.AnimState:IsCurrentAnimation("eyes_pst") then
			inst.AnimState:SetBank("tz_eyes_fx")
			inst.AnimState:SetBuild("tz_eyes_fx")
			inst.AnimState:PlayAnimation("eyes_pst", true)
			inst.Transform:SetPosition(0,0,0)
			inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
			inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
		end
	end)

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false

    return inst
end

local function fn13()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:SetCanSleep(false)
    inst.AnimState:SetBank("tz_buff_fx_a")
    inst.AnimState:SetBuild("tz_buff_fx_a")
	inst.AnimState:PlayAnimation("eyes_buff")
    inst.AnimState:SetLightOverride(1)

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
	inst:AddTag("RuoDian")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:ListenForEvent("animover", inst.Remove)
	inst.persists = false

    return inst
end

local function fn14()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:SetCanSleep(false)
    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("woodie")
	inst.AnimState:SetMultColour(0, 0, 0, 0.5)
	
	inst.Transform:SetFourFaced()

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
	inst:AddTag("RuoDian")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false

    return inst
end

local function fn15()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:SetCanSleep(false)
    inst.AnimState:SetBank("tz_chongci_fx")
    inst.AnimState:SetBuild("tz_chongci_fx")
	inst.AnimState:PlayAnimation("shadow")
	
	inst.Transform:SetFourFaced()

    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
	inst:AddTag("RuoDian")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false

    return inst
end
----------------------------
return Prefab("sk_fx01", fn, assets),
	Prefab("sk_fx02", fn02),
	Prefab("sk_fx03", fn03, assets03),
	Prefab("sk_fx06", fn06, assets06),
	Prefab("sk_fx07", fn07, assets07),
	Prefab("sk_fx10", fn10, assets10),
	Prefab("sk_fx11", fn11, assets11),
	Prefab("sk_fx12", fn12, assets12),
	Prefab("sk_fx13", fn13, assets12),
	Prefab("sk_fx14", fn14, assets12),
	Prefab("sk_fx15", fn15, assets15),
	unpack(tbl03)
