local assets =
{
    Asset("ANIM", "anim/tz_luobostaff.zip"),
    Asset("ANIM", "anim/swap_tz_luobostaff.zip"),
	Asset("IMAGE", "images/inventoryimages/tz_luobostaff.tex"),
	Asset("ATLAS", "images/inventoryimages/tz_luobostaff.xml"),
}
local prefabs =
{
	"tz_luobo",
	}
local NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost" ,"player", "companion"}
local function spell(inst, doer, pos)
	local tz_meteor = SpawnPrefab("tz_luobo")
	tz_meteor.Transform:SetPosition(pos:Get())
	tz_meteor.AnimState:PlayAnimation("crash")
	tz_meteor.AnimState:PushAnimation("crash_pst")
	tz_meteor:DoTaskInTime(tz_meteor.AnimState:GetCurrentAnimationLength(),function()
		local x, y, z = tz_meteor.Transform:GetWorldPosition()
		if not tz_meteor:IsOnValidGround() then
		tz_meteor:Remove()
		else
		tz_meteor.AnimState:PlayAnimation("idle")
		local fx1   = SpawnPrefab("tz_luobo_fx")
		fx1.Transform:SetPosition(x, y, z)
		fx1.components.luobo_groundpounder:GroundPound()
        local launched = {}
        local ents = TheSim:FindEntities(x, y, z, 4, nil, NON_SMASHABLE_TAGS, nil)
        for i, v in ipairs(ents) do
            if v:IsValid() and not v:IsInLimbo() then
				if v.components.combat ~= nil then
					v.components.combat:SuggestTarget(doer)
					v.components.combat:GetAttacked(doer, 50, inst)
				end
            end
        end
    end
	end)
	inst.components.aoetargeting:SetEnabled(false)
	inst:DoTaskInTime(12, function()
	inst.components.aoetargeting:SetEnabled(true)
	end)
	inst.components.finiteuses:Use(1)
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_tz_luobostaff", "swap_tz_luobostaff")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end
local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    for r = 7, 0, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tz_luobostaff")
    inst.AnimState:SetBuild("tz_luobostaff")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    
    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoe"
    inst.components.aoetargeting.reticule.pingprefab = "reticuleaoeping"
    inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true
	inst.components.aoetargeting:SetRange(14)
    MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
	inst.components.weapon.attackwear = 0
	
	inst:AddComponent("tz_aoespell")
    inst.components.aoespell = inst.components.tz_aoespell
	inst.components.aoespell.canuseonpoint = true
	inst.components.aoespell:SetSpellFn(spell)
	inst:RegisterComponentActions("aoespell")
	
	
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(9)
    inst.components.finiteuses:SetUses(9)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "tz_luobostaff"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tz_luobostaff.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("tz_luobostaff", fn, assets, prefabs)