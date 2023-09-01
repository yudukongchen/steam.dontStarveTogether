local assets =
{
    Asset("ANIM", "anim/tz_pi.zip"),
	Asset("ANIM", "anim/ui_tz_pi_1x1.zip"),
	Asset("ATLAS", "images/inventoryimages/tz_pi.xml"),
	Asset("IMAGE", "images/inventoryimages/tz_pi.tex"),
}
--inst.SoundEmitter:SetVolume("dream", 1)
local function play(inst)
	if inst.components.container:IsEmpty() then
	inst:DoTaskInTime(1, function()inst.components.machine:TurnOff() end )	
	return
	end
	local container = inst.components.container 
	local item = container:GetItemInSlot(1)
	if item ~=nil and item:HasTag("tz_cd1") then	
	inst.songToPlay = "tzsound/tzsound/qq"	
	--print(inst.songToPlay)
	elseif item ~=nil and item:HasTag("tz_cd2") then
	inst.songToPlay = "tzsound/tzsound/qq"
	elseif item ~=nil and item:HasTag("tz_cd3") then
	inst.songToPlay = "tzsound/tzsound/qq"
	end
	inst.AnimState:PlayAnimation("play_loop", true)
   	inst.SoundEmitter:PlaySound(inst.songToPlay, "gramaphone_ragtime")
	inst.SoundEmitter:SetVolume("gramaphone_ragtime", 0.8)
   	inst:PushEvent("turnedon")
	inst.components.container.canbeopened = false

end

local function stop(inst)
    inst.SoundEmitter:KillSound("gramaphone_ragtime")
	inst.AnimState:PlayAnimation("idle")
    inst:PushEvent("turnedoff")
	inst.components.container.canbeopened = true
end
local function itemtest(item, slot)
	return item:HasTag("tz_cd")
end

local function onsave(inst, data)
	data.songToPlay = inst.songToPlay or nil
end
local function onload(inst, data)
    if data ~= nil and data.songToPlay ~= nil then
        inst.songToPlay = data.songToPlay
    end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddDynamicShadow()	
	MakeObstaclePhysics(inst, 1)
    inst.AnimState:SetBank("tz_pi")
    inst.AnimState:SetBuild("tz_pi")
    inst.AnimState:PlayAnimation("idle")
	--inst.Transform:SetScale(1.8, 1.8, 1.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.songToPlay = nil
    
	inst:AddComponent("inspectable")
    --inst:AddComponent("container")
    --inst.components.container:WidgetSetup("tz_pi")
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = play
	inst.components.machine.turnofffn = stop
	inst.components.machine.cooldowntime = 1
    MakeHauntableLaunchAndSmash(inst)
    inst.OnSave = onsave
    inst.OnLoad = onload
    return inst
end

return Prefab("tz_pi", fn, assets),
		MakePlacer("tz_pi_placer", "tz_pi", "tz_pi", "idle")
