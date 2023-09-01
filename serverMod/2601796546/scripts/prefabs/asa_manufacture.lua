require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/asa_manufacture.zip"),
    Asset( "IMAGE", "images/inventoryimages/asa_mine.tex" ),  --武器图标
    Asset( "ATLAS", "images/inventoryimages/asa_mine.xml" ),
    Asset( "IMAGE", "images/inventoryimages/asa_mirage.tex" ),  --武器图标
    Asset( "ATLAS", "images/inventoryimages/asa_mirage.xml" ),
    Asset( "IMAGE", "images/inventoryimages/asa_mirage_off.tex" ),  --武器图标
    Asset( "ATLAS", "images/inventoryimages/asa_mirage_off.xml" ),
}

local prefabs = 
{
	"asa_mine_fx",
	"collapse_small",
}
local function OnExplode(inst, target)
	inst.AnimState:PlayAnimation("launch")
	local pos1 = inst:GetPosition()
	local pos2 = target:GetPosition()
	inst.Physics:SetMotorVel((pos2.x-pos1.x)*4, (pos2.y-pos1.y)*4, (pos2.z-pos1.z)*4)
	inst:DoTaskInTime(0.25,function()
				local pos4 = inst:GetPosition()
                local ents1 = TheSim:FindEntities(pos4.x,pos4.y,pos4.z,2.5,{"_combat", }, { "playerghost", "INLIMBO" })
				for k,v in pairs(ents1)do
                    if v and v.components.health and not v.components.health:IsDead()  then
							v.components.combat:GetAttacked(inst,200,nil,nil)
					end
				end
                inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/upgrade1")
                inst.SoundEmitter:PlaySound("asakiri_sfx/asakiri_sfx/upgrade2")
				local coll = SpawnPrefab("collapse_small")
				coll.Transform:SetPosition(inst:GetPosition():Get())
				SpawnPrefab("asa_mine_fx").Transform:SetPosition(inst:GetPosition():Get())
				inst:Remove()
				end)
end

local function OnDroppedFn(inst)
	inst.AnimState:PlayAnimation("idle")
    inst.components.mine:Reset()
    local ang = math.random(-180,180)
    inst.Physics:SetVel(7 * (1.5 + math.random()) * math.cos(ang), 0, 7 * (1.5 + math.random()) * math.sin(ang))
    inst:DoTaskInTime(2,function()
         inst.Physics:Stop()
    end)
end

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddPhysics()
	inst.entity:AddDynamicShadow()
	inst.DynamicShadow:SetSize(2, 1.5)
	
    MakeFlyingCharacterPhysics(inst, 1, 2)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("asa_mine")
    inst.AnimState:SetBuild("asa_manufacture")
	inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetLightOverride(0.4)

    inst:AddTag("mine")
	inst:AddTag("asa_mine")

	inst.Physics:SetMass(0.3)
    inst.Physics:SetFriction(0.6)
    inst.Physics:SetDamping(0.2)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 20

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "asa_mine"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_mine.xml"
	inst.components.inventoryitem:SetOnDroppedFn(OnDroppedFn)
    local oldOnDropped = inst.components.inventoryitem.OnDropped
    inst.components.inventoryitem.OnDropped = function(self, randomdir, speedmult)
        local size = self.inst.components.stackable:StackSize()
        local pos = self.inst:GetPosition()
        if size > 1 then
            for i = 1, size, 1 do
                SpawnPrefab("asa_mine"):AutoDrop(pos)
            end
            self.inst:Remove()
        else
            oldOnDropped(self, randomdir, speedmult)
        end
    end



    inst:AddComponent("mine")
    inst.components.mine:SetRadius(6)
    inst.components.mine:SetAlignment("player")
    inst.components.mine:SetOnExplodeFn(OnExplode)

    inst.AutoDrop = function(inst, pos)
        inst.Transform:SetPosition(pos:Get())
        inst.components.inventoryitem:OnDropped()
    end

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:SetPristine()
    
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst.AnimState:SetBank("asa_mine")
    inst.AnimState:SetBuild("asa_manufacture")
	inst.AnimState:PlayAnimation("blast")
	inst.AnimState:SetLightOverride(0.6)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	local s = 2
	inst.AnimState:SetScale(s,s,s)
	
	inst.entity:SetPristine()
	local light = inst.entity:AddLight()
    inst.Light:Enable(true)

    light:SetColour(100/255, 160/255, 255/255)
    light:SetIntensity(0.9)
    light:SetRadius(3)
    light:SetFalloff(.5)

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:ListenForEvent("animover", function()
		inst:Remove()
	end)
	
    return inst
end

local function miragepowerdown(inst)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_mirage_off.xml"
    inst.components.inventoryitem:ChangeImageName("asa_mirage_off")

    local owner = inst.components.inventoryitem.owner
    local inventory = owner and owner.components.inventory
    if owner and inventory
            and (inventory:GetEquippedItem(EQUIPSLOTS.NECK) and inventory:GetEquippedItem(EQUIPSLOTS.NECK) == inst)
            or (inventory:GetEquippedItem(EQUIPSLOTS.BODY) and inventory:GetEquippedItem(EQUIPSLOTS.BODY) == inst)
    then
        owner:RemoveTag("notarget")
        inst.components.fueled:StopConsuming()
    end
    if owner.asa_mirage then
        Asa_unMiraging(owner)
        owner.asa_mirage:Disappear()
        owner.asa_mirage = nil
    end
end


local function Dismirage(owner)
    local inventory = owner and owner.components.inventory
    local item = inventory
            and (inventory:GetEquippedItem(EQUIPSLOTS.NECK) and inventory:GetEquippedItem(EQUIPSLOTS.NECK))
            or (inventory:GetEquippedItem(EQUIPSLOTS.BODY) and inventory:GetEquippedItem(EQUIPSLOTS.BODY))
    if item and item:HasTag("asa_mirage") then
        item.components.rechargeable:Discharge(3)
    end
    --恢复正常
    owner:RemoveTag("notarget")
    if owner.asa_mirage then
        item.components.fueled:StopConsuming()
        Asa_unMiraging(owner)
        owner.asa_mirage:Disappear()
        owner.asa_mirage = nil
    end
end

local function Stopmirage(owner)
    local inventory = owner and owner.components.inventory
    local item = inventory
            and (inventory:GetEquippedItem(EQUIPSLOTS.NECK))
            or (inventory:GetEquippedItem(EQUIPSLOTS.BODY))
    if owner.components.locomotor:WantsToMoveForward() then
        if item and item:HasTag("asa_mirage") and item.components.rechargeable:IsCharged() then--重置
            item.components.rechargeable:Discharge(120)
            --恢复正常
            owner:RemoveTag("notarget")
            if owner.asa_mirage then
                item.components.fueled:StopConsuming()
                Asa_unMiraging(owner)
                owner.asa_mirage:Disappear()
                owner.asa_mirage = nil
            end
        end
    else
        if owner.sg:HasStateTag("moving") then
            --重置
            if item and item:HasTag("asa_mirage") and not item.components.rechargeable:IsCharged() then
                item.components.rechargeable:Discharge(3)
            end
        end
    end
end

local function mirage_equip(inst, owner)
    if not inst.components.fueled:IsEmpty()
            --and not owner.sg:HasStateTag("moving")
    then
        inst.components.rechargeable:Discharge(3)
    end
end

local function mirage_unequip(inst, owner)
    inst.components.fueled:StopConsuming()
    Dismirage(owner)
    owner:RemoveEventCallback("AsaUse", Dismirage)
    owner:RemoveEventCallback("dodgeend", Stopmirage)
    owner:RemoveEventCallback("attacked", Dismirage)
    owner:RemoveEventCallback("locomote", Stopmirage)
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("asa_mirage")
    inst.AnimState:SetBuild("asa_manufacture")
    inst.AnimState:PlayAnimation("idle_off")

    inst:AddTag("asa_item")
    inst:AddTag("asa_mirage")

    MakeInventoryFloatable(inst, "small", 0.05, 0.95)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "asa_mirage"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_mirage.xml"

    inst:AddComponent("fueled")
    inst.components.fueled.maxfuel = 240
    inst.components.fueled:InitializeFuelLevel(240)
    inst.components.fueled.accepting = true
    inst.components.fueled:SetDepletedFn(miragepowerdown)

    local oldDoDelta = inst.components.fueled.DoDelta
    inst.components.fueled.DoDelta = function(self, amount, doer)
        if amount > 0 and self:IsEmpty() then
            local owner = self.inst.components.inventoryitem.owner
            local inventory = owner and owner.components.inventory
            local item = inventory
                    and (inventory:GetEquippedItem(EQUIPSLOTS.NECK) and inventory:GetEquippedItem(EQUIPSLOTS.NECK))
                    or (inventory:GetEquippedItem(EQUIPSLOTS.BODY) and inventory:GetEquippedItem(EQUIPSLOTS.BODY))
            if item == self.inst then
                mirage_equip(self.inst, owner)
            end
            self.inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_mirage.xml"
            self.inst.components.inventoryitem:ChangeImageName("asa_mirage")
        end
        oldDoDelta(self, amount, doer)
    end

    inst:AddComponent("equippable") --装备组件
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnUnequip(mirage_unequip) --解除装备
    inst.components.equippable:SetOnEquip(mirage_equip)

    inst:DoTaskInTime(2,function()
        if inst.components.fueled:IsEmpty() then
            inst.components.inventoryitem.imagename = "asa_mirage_off"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/asa_mirage_off.xml"
        end
    end)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetChargeTime(480)
    inst.components.rechargeable:SetOnChargedFn(function(inst)
        if not inst.components.fueled:IsEmpty() then
            local owner = inst.components.inventoryitem.owner
            local inventory = owner and owner.components.health and not owner.components.health:IsDead() and owner.components.inventory
            if inventory then
                if (inventory:GetEquippedItem(EQUIPSLOTS.NECK) and inventory:GetEquippedItem(EQUIPSLOTS.NECK) == inst)
                        or (inventory and inventory:GetEquippedItem(EQUIPSLOTS.BODY) and inventory:GetEquippedItem(EQUIPSLOTS.BODY) == inst)
                then
                    if not owner.components.locomotor:WantsToMoveForward() and not owner.sg:HasStateTag("moving") then
                        inst.Startmirage(inst, owner)
                    else
                        Dismirage(owner)
                    end
                end
            end
        end
    end)

    inst.Startmirage = function(inst, owner)
        owner:AddTag("notarget")
        Asa_Miraging(owner)
        SpawnPrefab("asa_mirage_fx"):Appear(owner)
        inst.components.fueled:StartConsuming()
        owner:ListenForEvent("locomote", Stopmirage, owner)
        owner:ListenForEvent("attacked", Dismirage, owner)
        owner:ListenForEvent("AsaUse", Dismirage, owner)
        owner:ListenForEvent("dodgeend", Stopmirage, owner)
    end

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("asa_mine", fn1, assets),
	Prefab("asa_mine_fx", fn2),
    Prefab("asa_mirage", fn3)
