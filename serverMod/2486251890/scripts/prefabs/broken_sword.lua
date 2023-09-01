local assets =
{
    Asset("ANIM", "anim/broken_sword.zip"),
    Asset("ANIM", "anim/sword_open.zip"),       

    Asset("ATLAS", "images/inventoryimages/broken_sword.xml"),
    Asset("ATLAS", "images/inventoryimages/sword_open.xml")
}
  
local function SpawnFx(inst, owner, fxname)
     local fx = SpawnPrefab(fxname)
           fx.entity:AddFollower()
           fx.Follower:FollowSymbol(owner.GUID, "swap_object", 50, -25, 0)
end    

local function onequip(inst, owner)
   if inst.wplevel == 1 then
              inst.fxname = "halloween_firepuff_cold_1" 
              inst.components.weapon:SetDamage(42) 

              inst:RemoveTag("umbrella")
              inst:RemoveTag("waterproofer")
              owner.DynamicShadow:SetSize(1.7, 1)

                    if inst.components.waterproofer then
                            inst:RemoveComponent("waterproofer") 
                    end

              inst.AnimState:SetBank("broken_sword")
              inst.AnimState:SetBuild("broken_sword")

                 inst.components.inventoryitem.atlasname = "images/inventoryimages/broken_sword.xml"
                 inst.components.inventoryitem:ChangeImageName("broken_sword")              
              owner.AnimState:OverrideSymbol("swap_object", "broken_sword", "swap_broken_sword")

   elseif inst.wplevel == 2 then 
              inst:AddTag("umbrella")
              inst:AddTag("waterproofer")
              owner.DynamicShadow:SetSize(1.3, 0.6)

              inst.components.weapon:SetDamage(3)

                    if inst.components.waterproofer == nil then
                            inst:AddComponent("waterproofer") 
                    end

                    inst.fxname = "yotc_seedpacket_rare_unwrap" 

                 inst.AnimState:SetBank("sword_open")
                 inst.AnimState:SetBuild("sword_open")

                 inst.components.inventoryitem.atlasname = "images/inventoryimages/sword_open.xml"
                 inst.components.inventoryitem:ChangeImageName("sword_open")
              owner.AnimState:OverrideSymbol("swap_object", "sword_open", "swap_sword_open")
   end    
       if owner and inst.fxname then 
              SpawnFx(inst, owner, inst.fxname)
       end 

      owner.AnimState:Show("ARM_carry")
      owner.AnimState:Hide("ARM_normal")
      inst.Transform:SetScale(2, 2, 2)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.DynamicShadow:SetSize(1.7, 1)

           if inst.wplevel == 1 then
               inst.components.weapon:SetDamage(42)
         end

          if inst:HasTag("level1_2") then
                 inst:RemoveTag("level1_2")    
       end 

        if owner.KxTask then
              owner.KxTask:Cancel() 
              owner.KxTask = nil 
     end
end

local function onsave(inst, data)
     data.wplevel = inst.wplevel or 0
end

local function onpreload(inst, data)
    if data ~= nil and data.wplevel ~= nil then
           inst.wplevel = data.wplevel
          -- onequip(inst, owner)
    end
end 

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("broken_sword")
    inst.AnimState:SetBuild("broken_sword")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetScale(2, 2, 2)

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("chg")

    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.wplevel = 1
    inst.maxlevel = 2
    inst.fxname = nil

    inst:AddComponent("weapon")
    inst.components.weapon:SetRange(1)
    inst.components.weapon:SetDamage(42)

    inst:AddComponent("inspectable")

    inst:AddComponent("combat")
   -- inst.components.combat:SetDefaultDamage(100)

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.numRings = 3.5
    inst.components.groundpounder.burner = true
    inst.components.groundpounder.noTags = { "FX", "NOCLICK", "DECOR", "INLIMBO", "player" }
    inst.components.groundpounder.groundpoundfx = "firesplash_fx"
    inst.components.groundpounder.groundpoundringfx = "firering_fx"    

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "broken_sword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/broken_sword.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("named")

    inst.OnSave = onsave
    inst.OnPreLoad = onpreload    

    MakeHauntableLaunch(inst) 

    return inst
end

return Prefab("broken_sword", fn, assets)