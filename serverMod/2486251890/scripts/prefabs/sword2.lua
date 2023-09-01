local assets =
{
    Asset("ANIM", "anim/broken_sword.zip"),
    Asset("ANIM", "anim/swap_broken_sword.zip"),

    Asset("ANIM", "anim/sword2.zip"),
    Asset("ANIM", "anim/swap_sword2.zip"),

    Asset("ANIM", "anim/swap_ly_sword2.zip"),

    Asset("ANIM", "anim/umbrella.zip"),
    Asset("ANIM", "anim/swap_umbrella.zip"),

    Asset("ANIM", "anim/pickaxe.zip"),
    Asset("ANIM", "anim/goldenpickaxe.zip"),       

    Asset( "ATLAS", "images/inventoryimages/broken_sword.xml"),
	Asset( "IMAGE", "images/inventoryimages/broken_sword.tex" ),

    Asset( "ATLAS", "images/inventoryimages/broken_sword.xml"),
  Asset( "IMAGE", "images/inventoryimages/broken_sword.tex" ),

    Asset( "ATLAS", "images/inventoryimages/sword2.xml"),
	Asset( "IMAGE", "images/inventoryimages/sword2.tex" )	
}

local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "companion", "abigail", "player"}
local function onattack(inst, attacker, target)--1619

    if inst.wplevel == 3 then
              local pt = Vector3(target.Transform:GetWorldPosition())
              local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 4, {"_combat"}, nottags)
                  for k,v in pairs(ents) do 
                        if v ~= target and inst.components.combat:CanTarget(v) and not inst.components.combat:IsAlly(v) then
                              v.components.combat:GetAttacked(attacker, 30) 
                end
          end
    end  

    if inst.wplevel == 4 and target ~= nil and target:IsValid() and target.components.burnable ~= nil then
          target.components.burnable:Ignite(nil, attacker)
          inst.SoundEmitter:PlaySound("dontstarve/common/together/moonbase/repair", nil, 0.5)
               if target.Transform then
                        --  local fx = SpawnPrefab("miniboatlantern_loseballoon")
                            local fx = SpawnPrefab("halloween_firepuff_1")
                                   if fx.Transform then
                                          fx.Transform:SetScale(1.5, 1.5, 1.5)
                                end
                          fx.Transform:SetPosition(target.Transform:GetWorldPosition())
           end             
     end
end  

local function SpawnFx(inst, owner, fxname)
     local fx = SpawnPrefab(fxname)
           fx.entity:AddFollower()
           fx.Follower:FollowSymbol(owner.GUID, "swap_object", 50, -25, 0)
end    

local function OnIsNight(inst, isnight)
    if not TheWorld.state.isday and (inst._light == nil or not inst._light:IsValid()) and ((inst.components.inventoryitem.owner and inst.components.equippable:IsEquipped())) then
        inst._light = SpawnPrefab("sword_light") --生成光源
        inst._light.entity:SetParent(inst.entity)  --给光源设置父节点
        --inst._light.Transform:SetScale(0, 0, 0)
            --fx.entity:AddFollower()
            --fx.Follower:FollowSymbol(inst.GUID, "swap_object", fx.fx_offset_x or 0, fx.fx_offset, 0)
            --fx:AttachLightTo(owner)
    end
end    

local function OnIsDay(inst)    
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()    --把光源去掉
        end
        inst._light = nil
    end
end

local function onequip(inst, owner)
   if inst.wplevel == 1 then
           inst:RemoveTag("level4")
              inst.fxname = "halloween_firepuff_cold_1"
              inst.components.weapon:SetDamage(42)   
              owner.AnimState:OverrideSymbol("swap_object", "broken_sword", "swap_broken_sword")

             inst.AnimState:SetBank("broken_sword")
             inst.AnimState:SetBuild("broken_sword")              

                 inst.components.inventoryitem.atlasname = "images/inventoryimages/broken_sword.xml"
                 inst.components.inventoryitem:ChangeImageName("broken_sword")               

              OnIsDay(inst)

   elseif inst.wplevel == 2 then 
              inst:AddTag("umbrella")
              inst:AddTag("waterproofer")
              owner.DynamicShadow:SetSize(1.3, 0.6)
                    if inst.components.waterproofer == nil then
                            inst:AddComponent("waterproofer") 
                    end

                    inst.components.weapon:SetDamage(3)                   

                    inst.fxname = "yotc_seedpacket_rare_unwrap" 

                 inst.AnimState:SetBank("sword_open")
                 inst.AnimState:SetBuild("sword_open")

              owner.AnimState:OverrideSymbol("swap_object", "sword_open", "swap_sword_open")
                 inst.components.inventoryitem.atlasname = "images/inventoryimages/sword_open.xml"
                 inst.components.inventoryitem:ChangeImageName("sword_open")              

   elseif inst.wplevel == 3 then

              inst:RemoveTag("umbrella")
              inst:RemoveTag("waterproofer")
              owner.DynamicShadow:SetSize(1.7, 1)

                    if inst.components.waterproofer then
                            inst:RemoveComponent("waterproofer") 
                    end    

              inst.fxname = "round_puff_fx_sm"

                inst.AnimState:SetBank("swap_ly_sword2")
                inst.AnimState:SetBuild("swap_ly_sword2")

                
                    if inst.components.tool == nil then  --1471
                               inst:AddComponent("tool")
                               inst.components.tool:SetAction(ACTIONS.MINE)
                               inst.components.tool:SetAction(ACTIONS.HAMMER)
                    end
                    inst.components.weapon:SetDamage(75)
                    inst.components.equippable.walkspeedmult = 0.9
                    owner.components.combat:SetAttackPeriod(0.6)

                 owner.AnimState:OverrideSymbol("swap_object", "swap_ly_sword2", "swap_ly_sword2")
                 inst.components.inventoryitem.atlasname = "images/inventoryimages/sword1.xml"
                 inst.components.inventoryitem:ChangeImageName("sword1")             

   elseif inst.wplevel == 4 then
              inst:AddTag("level4")
              inst.fxname = "halloween_firepuff_1"

                    if inst.components.tool then  --1471
                               inst:RemoveComponent("tool")
                    end

                   OnIsNight(inst)  

                inst.AnimState:SetBank("sword2")
                inst.AnimState:SetBuild("sword2")

              inst.components.weapon:SetDamage(52)
              inst.components.equippable.walkspeedmult = 1

               owner.components.combat:SetAttackPeriod(0)
               owner.AnimState:OverrideSymbol("swap_object", "swap_sword2", "swap_sword2")
               
               inst.components.inventoryitem.atlasname = "images/inventoryimages/sword2.xml"
               inst.components.inventoryitem:ChangeImageName("sword2") 
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

       OnIsDay(inst)

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
    end
end 

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sword2")
    inst.AnimState:SetBuild("sword2")
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

    inst.wplevel = 4
    inst.maxlevel = 4  
    inst.fxname = nil

    inst:AddComponent("weapon")
    inst.components.weapon:SetRange(1)
    inst.components.weapon:SetDamage(52)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("inspectable")

    inst:AddComponent("combat")

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.numRings = 3.5
    inst.components.groundpounder.burner = true
    inst.components.groundpounder.noTags = { "FX", "NOCLICK", "DECOR", "INLIMBO", "player" }
    inst.components.groundpounder.groundpoundfx = "firesplash_fx"
    inst.components.groundpounder.groundpoundringfx = "firering_fx"    

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "sword2"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sword2.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("named")

    inst:WatchWorldState("iscaveday", OnIsDay)
    inst:WatchWorldState("iscavedusk", OnIsNight)
    inst:WatchWorldState("iscavenight", OnIsNight)

    inst:WatchWorldState("isdusk", OnIsNight)
    inst:WatchWorldState("isday", OnIsDay)

    inst.OnSave = onsave
    inst.OnPreLoad = onpreload    

    MakeHauntableLaunch(inst) 

    return inst
end

return Prefab("sword2", fn, assets)