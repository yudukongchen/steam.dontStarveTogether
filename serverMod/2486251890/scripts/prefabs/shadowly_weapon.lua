local assets =
{
    Asset("ANIM", "anim/broken_sword.zip"),
    Asset("ANIM", "anim/sword_open.zip"),       

    Asset("ATLAS", "images/inventoryimages/shadowly_weapon.xml"),
    Asset("ATLAS", "images/inventoryimages/shadowly_weapon.xml")
}

local function LevelUp(inst)
    print("升级")
    local weapon = inst ~= nil and inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil

    if weapon == nil or (weapon ~= nil and weapon.prefab ~= "shadowly_weapon") then
         return
    end

    local damage = inst.gxb_max - 300
    weapon.components.weapon:SetDamage(45 + weapon.wplevel + damage)
end

local function Killed(inst, data)
    local target = data.victim or nil
    local sword = inst and inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
    
    if sword == nil or (sword and sword.prefab ~= "shadowly_weapon") then return end  --武器不存在或者武器不是该武器也不执行下面的操作

    if sword and target and target.components.health 
           and target.components.combat then 

               sword.wpexp = sword.wpexp + 1
               print("当前经验"..sword.wpexp)

               if sword.components.weapon and sword.components.weapon.damage then 
                        if sword.components.weapon.damage < 55 and (sword.wpexp >= sword.components.weapon.damage/2) then
                                  sword.wplevel = sword.wplevel + 1

                        elseif sword.components.weapon.damage >= 55 and (sword.wpexp >= sword.components.weapon.damage) then
                                   sword.wplevel = sword.wplevel + 1
                      end
                     print("当前等级"..sword.wplevel)

                     local damage = inst.gxb_max - 300
                     sword.components.weapon:SetDamage(45 + sword.wplevel + damage)       
             end   
     end 
end 

local function onattack(inst, owner, target)
      local gxb_percent = owner.gxb_max - owner.gxb 

      if gxb_percent >= 3 then
            owner.gxb = owner.gxb + 3

      elseif gxb_percent < 3 then
                owner.gxb = owner.gxb_max
      end

      owner._gxb:set(owner.gxb)

      local damage = owner.gxb_max - 300
      inst.components.weapon:SetDamage(45 + inst.wplevel + damage)      
end  
   
local function onequip(inst, owner)           
      owner.AnimState:OverrideSymbol("swap_object", "swap_shadowly_weapon", "swap_shadowly_weapon")
      owner.AnimState:Show("ARM_carry")
      owner.AnimState:Hide("ARM_normal")

      owner:ListenForEvent("killed", Killed) 
      owner:ListenForEvent("levelup", LevelUp)

      owner.equiptask = owner:DoTaskInTime(0, function()
            LevelUp(owner)

            if owner.equiptask then
                  owner.equiptask:Cancel()
                  owner.equiptask = nil
            end  
      end)    
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    owner:RemoveEventCallback("killed", Killed)
    owner:RemoveEventCallback("levelup", LevelUp)
end

local function onsave(inst, data)
     data.wpexp = inst.wpexp or 0 
     data.wplevel = inst.wplevel or 0
end

local function onpreload(inst, data)
    if data and data.wpexp then
          inst.wpexp = data.wpexp
    end  

    if data ~= nil and data.wplevel ~= nil then
           inst.wplevel = data.wplevel
           inst.components.weapon:SetDamage(45+inst.wplevel)
    end
end 

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_shadowly_weapon")
    inst.AnimState:SetBuild("swap_shadowly_weapon")
    inst.AnimState:PlayAnimation("idle")

   -- inst.Transform:SetScale(2, 2, 2)

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    inst:AddTag("weapon")
    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.wpexp = 0
    inst.wplevel = 0

    inst:AddComponent("weapon")
    inst.components.weapon:SetRange(1)
    inst.components.weapon:SetDamage(45)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("inspectable")  

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "shadowly_weapon"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/shadowly_weapon.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.restrictedtag = "sxy"
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst.OnSave = onsave
    inst.OnPreLoad = onpreload    

    MakeHauntableLaunch(inst) 

    return inst
end

return Prefab("shadowly_weapon", fn, assets)