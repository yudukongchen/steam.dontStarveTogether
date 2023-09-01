TUNING.LY_HEALDEL = GetModConfigData('heal_del')

TUNING.LY_KEY1 = GetModConfigData('skill_one')
TUNING.LY_KEY2 = GetModConfigData('skill_two')
TUNING.LY_KEY3 = GetModConfigData('skill_three')
TUNING.LY_KEY4 = GetModConfigData('skill_four')
TUNING.LY_KEY5 = GetModConfigData('skill_five')
TUNING.LY_KEY6 = GetModConfigData('skill_six')

TUNING.LY_KEY7 = GetModConfigData('skill_seven')

PrefabFiles = {
	  "yuki",
	  "yuki_none",
    "nfx",
    "broken_sword",
    "hound_fx",
    "sword1",
    "sword2",
    "sword_light",

    "shadow_ly",
    "shadow_ly_ls",
    "hat_yuki",

    "sxy",
    "sxy_none",
    "shadowly_weapon"
}	

Assets = {
    Asset("ANIM", "anim/yuki.zip"),

    Asset( "IMAGE", "images/names_yuki.tex" ),
    Asset( "ATLAS", "images/names_yuki.xml" ),

    Asset( "IMAGE", "bigportraits/yuki.tex" ),
    Asset( "ATLAS", "bigportraits/yuki.xml" ),
 
    Asset( "IMAGE", "bigportraits/sxy.tex" ),
    Asset( "ATLAS", "bigportraits/sxy.xml" ),

	  Asset( "IMAGE", "images/map_icons/yuki.tex" ),
  	Asset( "ATLAS", "images/map_icons/yuki.xml" ),
	
    Asset( "IMAGE", "images/map_icons/sxy.tex" ),
    Asset( "ATLAS", "images/map_icons/sxy.xml" ),

	  Asset( "IMAGE", "images/avatars/avatar_yuki.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_yuki.xml" ),
	
	  Asset( "IMAGE", "images/avatars/avatar_ghost_yuki.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_yuki.xml" ),
	
	  Asset( "IMAGE", "images/avatars/self_inspect_yuki.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_yuki.xml" ),
	
    Asset( "IMAGE", "images/avatars/avatar_sxy.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_sxy.xml" ),
  
    Asset( "IMAGE", "images/avatars/avatar_ghost_sxy.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_sxy.xml" ),
  
    Asset( "IMAGE", "images/avatars/self_inspect_sxy.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_sxy.xml" ),

	  Asset( "IMAGE", "images/names_yuki.tex" ),
    Asset( "ATLAS", "images/names_yuki.xml" ),
	
    Asset( "IMAGE", "images/names_sxy.tex" ),
    Asset( "ATLAS", "images/names_sxy.xml" ),

    Asset( "IMAGE", "bigportraits/yuki_none.tex" ),
    Asset( "ATLAS", "bigportraits/yuki_none.xml" ),

    Asset( "ATLAS", "images/inventoryimages/sword1.xml"),
    Asset( "IMAGE", "images/inventoryimages/sword1.tex" ),

    Asset( "ATLAS", "images/inventoryimages/sword2.xml"),
    Asset( "IMAGE", "images/inventoryimages/sword2.tex" ),

    Asset( "ATLAS", "images/inventoryimages/broken_sword.xml"),
    Asset( "IMAGE", "images/inventoryimages/broken_sword.tex" ),

    Asset("ATLAS_BUILD", "images/inventoryimages/broken_sword.xml", 256),
    Asset("ATLAS_BUILD", "images/inventoryimages/sword1.xml", 256),
    Asset("ATLAS_BUILD", "images/inventoryimages/sword2.xml", 256)    
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

local FOODTYPE = GLOBAL.FOODTYPE
local FOODGROUP = GLOBAL.FOODGROUP

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

modimport("scripts/ly_action.lua")
modimport("scripts/sxy_action.lua")

TUNING.YUKI_HEALTH = 175
TUNING.YUKI_HUNGER = 200
TUNING.YUKI_SANITY = 200

TUNING.SXY_HEALTH = 175
TUNING.SXY_HUNGER = 200
TUNING.SXY_SANITY = 200

TUNING.STARTING_ITEM_IMAGE_OVERRIDE.broken_sword = {atlas = "images/inventoryimages/broken_sword.xml", image = "broken_sword.tex"}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE.shadowly_weapon = {atlas = "images/inventoryimages/shadowly_weapon.xml", image = "shadowly_weapon.tex"}

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.YUKI = {"broken_sword"} 
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.SXY = {"shadowly_weapon"} 

PREFAB_SKINS["yuki_none"] = {   --修复人物大图显示
	"yuki_none",
}

PREFAB_SKINS["sxy_none"] = {   --修复人物大图显示
  "sxy_none",
}


STRINGS.SKIN_NAMES.yuki_none = "洛忧"  --检查界面显示的名字

STRINGS.NAMES.YUKI = "洛忧"
STRINGS.CHARACTER_TITLES.yuki = "洛忧"
STRINGS.CHARACTER_NAMES.yuki = "洛忧"
STRINGS.CHARACTER_DESCRIPTIONS.yuki = "*暴食\n*江南萌虎\n*星空恐惧症"

STRINGS.CHARACTER_QUOTES.yuki = "只有怪物才能击败神明！"
STRINGS.CHARACTER_SURVIVABILITY.yuki = "不老不死, 永生不灭!"

STRINGS.NAMES.yuki = "洛忧"


STRINGS.SKIN_NAMES.sxy_none = "瑟西娅"
STRINGS.NAMES.SXY = "瑟西娅"
STRINGS.CHARACTER_TITLES.sxy = "瑟西娅"
STRINGS.CHARACTER_NAMES.sxy = "瑟西娅"
STRINGS.CHARACTER_DESCRIPTIONS.sxy = "*吸血鬼\n*有自己的武器"

STRINGS.CHARACTER_QUOTES.sxy = "为您而战, 我的主人！"
STRINGS.CHARACTER_SURVIVABILITY.sxy = "不老不死, 永生不灭!"

STRINGS.NAMES.BROKEN_SWORD = "赤伞"
STRINGS.RECIPE_DESC.BROKEN_SWORD  = "要刺的快，刺的狠"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BROKEN_SWORD  = "如同艺术品一般" 

STRINGS.NAMES.SWORD1 = "赤伞(猩红女王)"
STRINGS.RECIPE_DESC.SWORD1  = "砸！"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD1  = "超重的" 

STRINGS.NAMES.SWORD2 = "赤伞(余烬)"
STRINGS.RECIPE_DESC.SWORD2  = "小心烧家"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD2  = "无比炽热!" 

STRINGS.NAMES.HAT_YUKI = "军帽"
STRINGS.RECIPE_DESC.HAT_YUKI  = "一顶帅气的帽子"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HAT_YUKI  = "帝国永存"

STRINGS.NAMES.SHADOW_LY_LS = "始祖之魂"
STRINGS.RECIPE_DESC.SHADOW_LY_LS  = "始祖之魂"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_LY_LS  = "始祖之魂"

STRINGS.NAMES.SHADOW_LY = "瑟西娅" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_LY  = "瑟西娅!" 

STRINGS.NAMES.SHADOW_LY2 = "血佣" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOW_LY2  = "血佣!" 


STRINGS.NAMES.SHADOWLY_WEAPON = "血狱" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOWLY_WEAPON  = "血狱!" 

AddMinimapAtlas("images/map_icons/yuki.xml")
AddMinimapAtlas("images/map_icons/sxy.xml")
AddMinimapAtlas("images/inventoryimages/hat_yuki.xml")

AddModCharacter("yuki", "FEMALE")
AddModCharacter("sxy", "FEMALE")


Recipe("sword1", {Ingredient("broken_sword", 1, "images/inventoryimages/broken_sword.xml"), Ingredient("houndstooth", 10), Ingredient("boneshard", 10), Ingredient("thulecite", 20)}, RECIPETABS.WAR,  TECH.NONE, 
nil, nil, nil, nil, "yuki",
"images/inventoryimages/sword1.xml", 
"sword1.tex")

Recipe("sword2", {Ingredient("sword1", 1, "images/inventoryimages/sword1.xml"), Ingredient("ruins_bat", 1), Ingredient("redgem", 10), Ingredient("dragon_scales", 1)}, RECIPETABS.WAR,  TECH.NONE, 
nil, nil, nil, nil, "yuki",
"images/inventoryimages/sword2.xml", 
"sword2.tex")

Recipe("hat_yuki", {Ingredient("walrushat", 1), Ingredient("silk", 4), Ingredient("goldnugget", 2)}, RECIPETABS.DRESS,  TECH.NONE, 
nil, nil, nil, nil, "yuki",
"images/inventoryimages/hat_yuki.xml", 
"hat_yuki.tex")

Recipe("shadow_ly_ls", {Ingredient("nightmarefuel", 20), Ingredient("shadowheart", 1)}, RECIPETABS.REFINE,  TECH.NONE, 
nil, nil, nil, nil, "yuki_builder",
"images/inventoryimages/shadow_ly_ls.xml", 
"shadow_ly_ls.tex")
----------------等级显示
--[[
local hello = GLOBAL.require("widgets/hello") --加载hello类

local function addHelloWidget(self)
    self.hello = self:AddChild(hello())-- 为controls添加hello widget。
    self.hello:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.hello:SetVAnchor(1) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.hello:SetPosition(-700,-880,0) -- 设置hello widget相对原点的偏移量，70，-50表明向右70，向下50，第三个参数无意义。
end

AddClassPostConstruct("widgets/controls", addHelloWidget) 
]]
local yuuki_night_ui = require("widgets/night_ui")

local function AddNight_Ui(self) 
  if self.owner and self.owner:HasTag("ly") then
     self.yuuki_night_ui = self:AddChild(yuuki_night_ui(self.owner)) 

    
    self.owner:DoTaskInTime(0.5, function()
      local x1 ,y1,z1 = self.stomach:GetPosition():Get()
      local x2 ,y2,z2 = self.brain:GetPosition():Get()    
      local x3 ,y3,z3 = self.heart:GetPosition():Get()    
      if y2 == y1 or  y2 == y3 then
        self.yuuki_night_ui:SetPosition(self.stomach:GetPosition() + Vector3(x1-x2, 0, 0))
        self.boatmeter:SetPosition(self.moisturemeter:GetPosition() + Vector3(x1-x2, 0, 0))
      else
        self.yuuki_night_ui:SetPosition(self.stomach:GetPosition() + Vector3(x1-x2, 0, 0))
      end

      local s1 = self.stomach:GetScale().x
      local s2 = self.boatmeter:GetScale().x    
      local s3 = self.yuuki_night_ui:GetScale().x 
  
      if s1 ~= s2 then
        self.boatmeter:SetScale(s1/s2,s1/s2,s1/s2)  --修改船的耐久值大小
      end

      if s1 ~= s3 then
          self.yuuki_night_ui:SetScale(s1/s3,s1/s3,s1/s3)--避免wg的显示mod有问题修正一下大小
      end
    end)
  local old_SetGhostMode = self.SetGhostMode --死亡/复活 隐藏/显示
  function self:SetGhostMode(ghostmode,...)
    old_SetGhostMode(self,ghostmode,...)
      if ghostmode then   
           if self.yuuki_night_ui ~= nil then 
              self.yuuki_night_ui:Hide()
           end 
    else
          if self.yuuki_night_ui ~= nil then
                self.yuuki_night_ui:Show()
           end
        end
      end
   end
end

AddClassPostConstruct("widgets/statusdisplays", AddNight_Ui)
------------------------------------------------------------------------------------------------------------  

local yuuki_ui = require("widgets/hello")

local function AddYuuki_Ui(self) 
  if self.owner and (self.owner:HasTag("ly") or self.owner:HasTag("sxy")) then
    self.yuuki_ui = self:AddChild(yuuki_ui(self.owner)) 
    
    self.owner:DoTaskInTime(0.5, function()
      local x1 ,y1,z1 = self.stomach:GetPosition():Get()
      local x2 ,y2,z2 = self.brain:GetPosition():Get()    
      local x3 ,y3,z3 = self.heart:GetPosition():Get()    
      if y2 == y1 or  y2 == y3 then
        self.yuuki_ui:SetPosition(self.stomach:GetPosition() + Vector3(x1-x2, 0, 0))
        self.boatmeter:SetPosition(self.moisturemeter:GetPosition() + Vector3(x1-x2, 0, 0))
      else
        self.yuuki_ui:SetPosition(self.stomach:GetPosition() + Vector3(x1-x3, 0, 0))
      end
      local s1 = self.stomach:GetScale().x
      local s2 = self.boatmeter:GetScale().x    
      local s3 = self.yuuki_ui:GetScale().x 
  
      if s1 ~= s2 then
        self.boatmeter:SetScale(s1/s2,s1/s2,s1/s2)  --修改船的耐久值大小
      end

      if s1 ~= s3 then
        self.yuuki_ui:SetScale(s1/s3,s1/s3,s1/s3)--避免wg的显示mod有问题修正一下大小
      end
    end)
  local old_SetGhostMode = self.SetGhostMode --死亡/复活 隐藏/显示
  function self:SetGhostMode(ghostmode,...)
    old_SetGhostMode(self,ghostmode,...)
      if ghostmode then   
           if self.yuuki_ui ~= nil then 
                 self.yuuki_ui:Hide()
           end 
    else
             if self.yuuki_ui ~= nil then
                  self.yuuki_ui:Show()
           end
        end
      end
   end
end

AddClassPostConstruct("widgets/statusdisplays", AddYuuki_Ui)

local yuki_item = {
       broken_sword = true,
       sword1 = true,
       sword2 = true
}

local function draw(inst)
  if inst.components.drawable then
    local oldondrawnfn = inst.components.drawable.ondrawnfn or nil
    inst.components.drawable.ondrawnfn = function(inst, image, src)

    if oldondrawnfn ~= nil then
          oldondrawnfn(inst, image, src)
    end

    if image ~= nil and yuki_item[image] ~= nil then
          inst.AnimState:OverrideSymbol("SWAP_SIGN", resolvefilepath("images/inventoryimages/"..image..".xml"), image..".tex")
    end
    end
  end
end

AddPrefabPostInit("minisign", draw)
AddPrefabPostInit("minisign_drawn", draw)

AddPrefabPostInit("spider", function(inst)
       if not TheWorld.ismastersim then
             return inst
       end

       inst.leader = nil
end)

local function HoundAtk(inst, target)
  if inst.CanBeHound then
        local Buff_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("HoundAtk") or 0) or nil

         if inst.components.hunger and inst.components.hunger.current >= 5 and Buff_Cd <= 0 and target then  --and inst.components.playercontroller:IsEnabled()
              local hound = SpawnPrefab("hound_fx")              
              local pt = Vector3(inst.Transform:GetWorldPosition())
              local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "companion", "abigail", "shadow_ly"}

                    if not TheNet:GetPVPEnabled() then
                         table.insert(nottags, "player")
                end              

              local hound = SpawnPrefab("hound_fx")

              inst:AddTag("hound_yuki")
              inst.components.hunger:DoDelta(-5)
              inst.components.timer:StartTimer("HoundAtk", 10)
              hound.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
              --hound.Transform:SetRotation(inst.Transform:GetRotation())
              hound:ForceFacePoint(target:GetPosition():Get())

              hound:ListenForEvent("animqueueover", function()
                        local fx = SpawnPrefab("sand_puff")                                     
                           hound:Remove()

                           if fx.Transform then
                                  fx.Transform:SetScale(2, 2, 2)
                                  fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                           end                            
              end)

              hound.SoundEmitter:PlaySound("dontstarve/creatures/hound/attack")              

           inst:DoTaskInTime(0.5, function()
                    target.components.combat:GetAttacked(inst, 200)
                                       if target.components.health and target.components.health:IsDead() and target.components.health.maxhealth and not target:HasTag("chess") and not target:HasTag("shadowcreature") and not target:HasTag("shadow") and not target:HasTag("shadowchesspiece") then

                                               if target.components.lootdropper then
                                                      target.components.lootdropper.DropLoot = function(self, pt) end
                                              end          

                                                   inst.gxb = inst.gxb + (target.components.health.maxhealth*0.1)
                                                   print(target.components.health.maxhealth*0.1)
                                                         if inst.gxb >= inst.gxb_max then
                                                             inst.gxb = inst.gxb_max
                                                    end             
                                             inst._gxb:set(inst.gxb) --ui更新
                                        end      
                        --break                                                                      
           end)
            --  elseif inst.components.hunger and inst.components.hunger.current < 5 and inst.components.playercontroller:IsEnabled()  then
                  -- inst.components.talker:Say("我好饿!")
            end

           -- else
               -- inst.components.talker:Say("未掌握该能力!")         
      end          
end  

AddModRPCHandler(modname, "HoundAtk", HoundAtk)

--if TUNING.LY_KEY7 == false then
AddComponentAction("SCENE", "inventory" , function(inst, doer, actions, right)
    if right and inst == doer and doer.prefab == "yuki" then  --and (inst == ThePlayer or TheWorld.ismastersim)
        if doer._CanBeHound ~= nil and doer._CanBeHound:value() == true and inst._CanSpawnChild ~= nil and inst._CanSpawnChild:value() == true and inst._gxb_max:value() and inst._gxb_max:value() >= 500
               and not inst:HasTag("NoDead_Cd") and inst.replica.inventory and inst.replica.inventory:GetActiveItem() == nil                 
             and not (inst.replica.rider and inst.replica.rider:IsRiding()) then
                   table.insert(actions, ACTIONS.TRANSFIGURATION)
           end
      end 
end)
--end

if TUNING.LY_KEY7 then
TheInput:AddKeyDownHandler(TUNING.LY_KEY7, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"
local target = TheInput:GetWorldEntityUnderMouse() or nil

    if player.prefab == "yuki" and not player:HasTag("playerghost") and IsHUDActive and target ~= nil and target:IsNear(ThePlayer, 4) and ThePlayer.replica.combat:CanTarget(target) and not ThePlayer.replica.combat:IsAlly(target) then
          SendModRPCToServer(MOD_RPC[modname]["HoundAtk"], target)
    end 
end)
end

local function BSZQ(inst)
        print("不死之躯启动")
        inst.nodead = true
        inst:AddTag("NoDead_Cd")
        inst.components.timer:StartTimer("NoDead", 60)
end

AddModRPCHandler(modname, "BSZQ", BSZQ)

TheInput:AddKeyDownHandler(TUNING.LY_KEY1, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"

--local target = TheInput:GetWorldEntityUnderMouse() or nil

    --if player.prefab == "yuki" and not player:HasTag("playerghost") and IsHUDActive and target ~= nil and target:IsNear(ThePlayer, 4) and ThePlayer.replica.combat:CanTarget(target) and not ThePlayer.replica.combat:IsAlly(target) then
    if player:HasTag("ly") and not player:HasTag("playerghost") and IsHUDActive and player._CanBeHound and player._CanBeHound:value()
          and player._CanSpawnChild and player._CanSpawnChild:value() --and player._gxb_max:value() and player._gxb_max:value() >= 500
              and not player:HasTag("NoDead_Cd") and player.replica.inventory and player.replica.inventory:GetActiveItem() == nil 
                 and not (player.replica.rider and player.replica.rider:IsRiding()) then  
          SendModRPCToServer(MOD_RPC[modname]["BSZQ"])
    end 
end)

local function sxypick(inst)
   if inst.follower then
         print(inst.follower.prefab)
         if inst.follower.pickbrain == false and not inst.follower:HasTag("IsHide") and not inst.follower:HasTag("notarget") and not inst.follower.sg:HasStateTag("shadowatk") 
                 and inst.follower.components.combat.target == nil then
                print("开始采集")
                inst.follower.pickbrain = true
                inst.components.talker:Say("瑟西娅，收集周围物资")
                inst.follower.components.talker:Say("遵命，主人")

         elseif inst.follower.pickbrain then
                print("停止采集")
                inst.follower.pickbrain = false
                inst.follower.components.inventory:DropEverything(true, true) 
                inst.components.talker:Say("放下物资")
                --inst.components.locomotor:Stop()         
         end       
     end 
end

AddModRPCHandler(modname, "sxypick", sxypick)

TheInput:AddKeyDownHandler(TUNING.LY_KEY2, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"
    if player:HasTag("ly") and not player:HasTag("playerghost") and IsHUDActive then
          SendModRPCToServer(MOD_RPC[modname]["sxypick"])
    end 
end)


local RETARGET_MUST_TAGS = { "_combat" }
local RETARGET_CANT_TAGS = { "wall", "dwx_friend", "player", "INLIMBO", "bee", "glommer", "chester", "playerghost", "shadow_ly" }
local function retargetfn(inst)
    local leader = inst.components.follower:GetLeader()
    return leader ~= nil
        and FindEntity(
            leader,
            TUNING.SHADOWWAXWELL_TARGET_DIST,
            function(guy)
                return guy ~= inst
                    and inst.components.combat:CanTarget(guy)
            end,
            RETARGET_MUST_TAGS, -- see entityreplica.lua
            RETARGET_CANT_TAGS
        )
        or nil
end

local function keeptargetfn(inst, target)
    return inst.components.follower:IsNearLeader(20)
        and inst.components.combat:CanTarget(target)
    and target.components.minigame_participator == nil
end

local function sxyatk(inst)
   if inst.follower then
        if not inst.follower:HasTag("主动攻击") and not inst.follower:HasTag("IsHide") and not inst.follower:HasTag("notarget") and not inst.follower.sg:HasStateTag("shadowatk") then
            inst.follower:AddTag("主动攻击")
            inst.follower.components.combat:SetRetargetFunction(1, retargetfn)
            inst.follower.components.combat:SetKeepTargetFunction(keeptargetfn)
            inst.components.talker:Say("瑟西娅，踏碎我的敌人")
            inst.follower.components.talker:Say("乐意效劳")

        elseif inst.follower:HasTag("主动攻击") then 
            inst.follower:RemoveTag("主动攻击")

            if inst.follower.components.combat.target then
                   inst.follower.components.combat:DropTarget()
            end  

            inst.components.talker:Say("停下")
            inst.follower.components.combat:SetRetargetFunction(1, retargetfn2)
            inst.follower.components.combat:SetKeepTargetFunction(keeptargetfn2)        
        end   
    end 
end

AddModRPCHandler(modname, "sxyatk", sxyatk)

TheInput:AddKeyDownHandler(TUNING.LY_KEY3, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"
    if player:HasTag("ly") and not player:HasTag("playerghost") and IsHUDActive then
          SendModRPCToServer(MOD_RPC[modname]["sxyatk"])
    end 
end)


local function retargetfn(inst)
    return nil
end

local function CalcSanityAura(inst, observer)
    return 0
end

local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "companion", "abigail"}

local function SpiderAtk(inst)
  if inst.CanSpawnChild then
      local Buff_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("SpiderSpawn_Cd") or 0) or nil

        if inst.SpawnNum == 0 and Buff_Cd and Buff_Cd <= 0 then
                inst.SpawnNum = inst.SpawnNum + 1

           if inst.gxb >= 30*(5-inst.SpawnMax) and inst.components.playercontroller:IsEnabled() then  --所有随从都在的话就不执行了 
--========================================

                 if inst.components.sanity then 
                          if inst.SpawnMax > 0 then
                                   inst.gxb = inst.gxb-(30*(5-inst.SpawnMax))

                                elseif inst.SpawnMax == 0 then
                                           inst.gxb = inst.gxb - 150
                          end       
                          inst._gxb:set(inst.gxb)

                               if inst.SpawnMax == 0 then
                                        inst.components.sanity:AddSanityPenalty("SpiderSpawn", 0.25)--0.5
                               else                                        
                                        inst.components.sanity:AddSanityPenalty("SpiderSpawn", (5-inst.SpawnMax)*0.05)--0.5
                               end          
                          inst.SpawnMax = 5      
                 end  

                for i = 1, 2 do
                        local pos = Vector3(inst.Transform:GetWorldPosition()) + Vector3(4, 0, 0)

                        inst.spidernum = 2

                        local spider = SpawnPrefab("spider")
                        spider:AddTag("yuki_child")
                        spider.Transform:SetPosition(pos:Get())

                        SpawnPrefab("collapse_big").Transform:SetPosition(pos:Get())
                end
--=======================================
                for i = 1, 2 do
                        local pos = Vector3(inst.Transform:GetWorldPosition()) + Vector3(-4, 0, 0)

                        inst.spider_warriorrnum = 2

                        local spider_warrior = SpawnPrefab("spider_warrior")
                        spider_warrior:AddTag("yuki_child")
                        spider_warrior.Transform:SetPosition(pos:Get())

                        SpawnPrefab("collapse_big").Transform:SetPosition(pos:Get())
                end 
--=========================================
                for i = 1, 1 do
                        inst.wormnum = 1

                        local worm = SpawnPrefab("worm")
                        local brain = require "brains/spiderbrain"

                             worm:AddTag("yuki_child")
                             worm:SetBrain(brain)
                             worm:AddComponent("follower")
                             worm.components.combat:SetRetargetFunction(GetRandomWithVariance(2, 0.5), retargetfn)

                             worm.Transform:SetPosition(inst.Transform:GetWorldPosition())

                             SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())                        
                end 

      local pt = Vector3(inst.Transform:GetWorldPosition())          
      local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 50, {"yuki_child"}, nottags)

       for k, v in pairs(ents) do-----------------------------------------------------
               if v ~= nil then
                        v.leader = inst
                        v.persists = false
                        v.Transform:SetScale(1.3, 1.3, 1.3) 
                        inst.components.leader:AddFollower(v)

                     if v.components.sanityaura then
                            v.components.sanityaura.aurafn = CalcSanityAura
                     end         

                     if v.components.eater then
                            v.components.eater:SetDiet({}, {})
                     end 

                     if v.components.trader then
                            v.components.trader.enabled = false
                     end           

                     if v.components.follower then                     
                            v.components.follower.maxfollowtime = TUNING.TOTAL_DAY_TIME*100
                            v.components.follower:SetLeader(inst)
                            v.components.follower:KeepLeaderOnAttacked()
                            v.components.follower.keepdeadleader = true
                            v.components.follower.keepleaderduringminigame = true
                     end 

              inst:ListenForEvent("death", function()   
                               inst.SpawnMax = inst.SpawnMax - 1
                               if inst.components.sanity and inst.SpawnMax <= 0 then
                                     inst.components.sanity:AddSanityPenalty("SpiderSpawn", 0)          
                            end                                  
                    end, v)
               end                 
         end                  

 	                inst:PushEvent("makefriend")



           --  elseif inst.components.sanity and inst.gxb < 30 and inst.components.playercontroller:IsEnabled() then 
             	       -- inst.components.talker:Say("细胞数量过低!")
       end

  --   elseif inst.SpawnNum == 0 and Buff_Cd and Buff_Cd > 0 then
                --  inst.components.talker:Say("技能Cd!") 

        elseif inst.SpawnNum == 1 then
                    inst.SpawnNum = 0 
                    local pt = Vector3(inst.Transform:GetWorldPosition())
                       for k, v in pairs(TheSim:FindEntities(pt.x, pt.y, pt.z, 50, {"yuki_child"}, nottags)) do-----------------------------------------------------
                              if v ~= nil then
                                     SpawnPrefab("collapse_big").Transform:SetPosition(v.Transform:GetWorldPosition())
                                     inst.components.timer:StartTimer("SpiderSpawn_Cd", 180)
                                     v:Remove()

                                    if inst.components.sanity then
                                          inst.components.sanity:AddSanityPenalty("SpiderSpawn", 0)          
                                    end
                          end
                     end
                end          
       -- else
            -- inst.components.talker:Say("未掌握该能力!")
     end
end  

AddModRPCHandler(modname, "SpiderAtk", SpiderAtk)

TheInput:AddKeyDownHandler(TUNING.LY_KEY4, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"

      if player.prefab == "yuki" and not player:HasTag("playerghost") and IsHUDActive then
            SendModRPCToServer(MOD_RPC[modname]["SpiderAtk"])
      end 
end)

local function FireAttack(inst)
          local atknum = 0 
          local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "companion", "abigail", "player", "yuki_friend", "yuki_child"}
          local Buff_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("FireAttack_Cd") or 0) or nil     
          local weapons = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
          local pt = Vector3(inst.Transform:GetWorldPosition())
          local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 12, {"_combat"}, nottags)
          
                   if weapons and weapons.prefab == "sword2" and weapons.wplevel == 4 and inst.DoAtkTask == nil and Buff_Cd <= 0 then  
                                if weapons.Transform then
                                      weapons.components.groundpounder:GroundPound()
                                      weapons.SoundEmitter:PlaySound("dontstarve/common/lava_arena/portal_player")
                                    --  weapons.SoundEmitter:PlaySound("dontstarve/rain/thunder_close")                                      

                                        for k,v in pairs(ents) do 
                                               if inst.components.combat:CanTarget(v) and not inst.components.combat:IsAlly(v)  then 
                                                      v.components.combat:GetAttacked(inst, 50)
                                            end
                                      end
                                        

                                 inst.DoAtkTask = inst:DoPeriodicTask(0.5, function(inst)
                                          local pt = Vector3(inst.Transform:GetWorldPosition())
                                          local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 12, {"_combat"}, nottags)
                                             atknum = atknum + 1
                                             weapons.components.groundpounder:GroundPound()


                                        for k,v in pairs(ents) do 
                                               if inst.components.combat:CanTarget(v) and not inst.components.combat:IsAlly(v) then 
                                                      v.components.combat:GetAttacked(inst, 50)
                                            end
                                      end
                                          if atknum >= 2 and inst.DoAtkTask then
                                          	        atknum = 0
                                                    inst.DoAtkTask:Cancel()
                                                    inst.DoAtkTask = nil
                                                    inst.components.timer:StartTimer("FireAttack_Cd", 60)
                                       end
                                 end)
                                        local fx = SpawnPrefab("sand_puff")                           
                                              fx.Transform:SetScale(3, 3, 3)
                                              fx.Transform:SetPosition(weapons.Transform:GetWorldPosition())                                       
                                   end 

                          --  elseif weapons and weapons.prefab == "sword2" and weapons.wplevel == 4 and inst.components.sanity.current < 20 then
                                 --  inst.components.talker:Say("精神不足。。")
                   end
end

AddModRPCHandler(modname, "FireAttack", FireAttack)

TheInput:AddKeyDownHandler(TUNING.LY_KEY5, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"

      if player.prefab == "yuki" and not player:HasTag("playerghost") and IsHUDActive then
            SendModRPCToServer(MOD_RPC[modname]["FireAttack"])
      end 
end)

-----------------------------

local speech =
{
    "瑟西娅",
    "瑟西娅, 听从我的召唤"
}

local function MakeStronger(inst, level)    
            if level >= 0 and level < 2 then
                  inst.components.combat:SetDefaultDamage(60)

                  inst.components.health:StartRegen(5, 2)
                  inst.components.health:SetMaxHealth(1000)

            elseif level >= 2 then
                  inst.components.trader.enabled = false
                  inst.components.combat:SetDefaultDamage(75)

                  inst.components.health:StartRegen(10, 2)
                  inst.components.health:SetMaxHealth(1500)                 
          end
end

local RETARGET_MUST_TAGS = { "_combat" }
local RETARGET_CANT_TAGS = { "wall", "dwx_friend", "player", "INLIMBO", "bee", "glommer", "chester", "playerghost", "shadow_ly" }
local function retargetfn2(inst)
    local leader = inst.components.follower:GetLeader()
    return leader ~= nil
        and FindEntity(
            leader,
            TUNING.SHADOWWAXWELL_TARGET_DIST,
            function(guy)
                return guy ~= inst
                    and (guy.components.combat:TargetIs(leader) or
                        guy.components.combat:TargetIs(inst))
                    and inst.components.combat:CanTarget(guy)
            end,
            RETARGET_MUST_TAGS, -- see entityreplica.lua
            RETARGET_CANT_TAGS
        )
        or nil
end

local function keeptargetfn2(inst, target)
    return inst.components.follower:IsNearLeader(14)
        and inst.components.combat:CanTarget(target)
    and target.components.minigame_participator == nil
end

local function FollowerSpawn(inst)--
  local Spawn_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("CanSpawnFollower") or 0) or nil

        if (inst.components.leader:CountFollowers("shadow_ly") == 0 or inst.follower == nil) and Spawn_Cd <= 0 then
                      inst.follower = SpawnPrefab("shadow_ly")

                      inst.follower.level = inst.folllevel
                      MakeStronger(inst.follower, inst.folllevel)
                      inst.follower.components.follower.leader = inst
                      inst.follower.Transform:SetPosition(inst.Transform:GetWorldPosition())
                      inst.components.talker:Say((speech[math.random(#speech)]))

                      inst.components.leader:AddFollower(inst.follower)
                      inst:ListenForEvent("death", function()
                                  inst.follower = nil 
                                  inst.components.timer:StartTimer("CanSpawnFollower", 480*3)
                  end, inst.follower)

              elseif inst.components.leader:CountFollowers("shadow_ly") == 1 and inst.follower then -- and inst.follower.components.combat.target == nil then
                           if not inst.follower:HasTag("IsHide") then
                                 inst.follower:AddTag("IsHide")
                                 inst.components.talker:Say("回来")
                                 inst.follower:RemoveTag("主动攻击") 
                                 inst.follower.components.combat:SetRetargetFunction(1, retargetfn2)
                                 inst.follower.components.combat:SetKeepTargetFunction(keeptargetfn2) 
                                 --inst.follower.components.inventory:DropEverything(true) 

                                inst.follower.components.combat:DropTarget()

                                 inst.follower:Hide()
                                 inst.follower.Transform:SetScale(0, 0, 0)
                                 inst.follower.Transform:SetPosition(0, -100, 0)
                                 inst.follower.components.health:SetInvincible(true)

                                 if inst.follower.brain then
                                        inst.follower.brain:Stop()
                                 end
                      
                                 if inst.follower.sg then      
                                          inst.follower.sg:Stop()
                                 end      

                                 inst.follower:AddTag("notarget")

                                 if inst.follower.DynamicShadow then 
                                        inst.follower.DynamicShadow:Enable(false)
                                 end  

                      elseif inst.follower and inst.follower:HasTag("IsHide") then
                                 inst.follower:RemoveTag("IsHide")
                                 inst.follower:Show() 

                                 if inst.follower.brain then
                                        inst.follower.brain:Start()
                                 end
                      
                                 if inst.follower.sg then      
                                          inst.follower.sg:Start()
                                 end      

                                 inst.follower:RemoveTag("notarget")

                                 if inst.follower.DynamicShadow then 
                                        inst.follower.DynamicShadow:Enable(true)
                                 end 

                                 inst.follower.sg:GoToState("portal_jumpout")
                                 inst.follower.Transform:SetScale(1, 1, 1)
                                 inst.follower.components.health:SetInvincible(false)
                                 inst.follower.Transform:SetPosition(inst.Transform:GetWorldPosition())

                                 inst.components.talker:Say((speech[math.random(#speech)]))
             end                                             
       end              
end


AddModRPCHandler(modname, "FollowerSpawn", FollowerSpawn)

TheInput:AddKeyDownHandler(TUNING.LY_KEY6, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"

      if player.prefab == "yuki" and not player:HasTag("playerghost") and IsHUDActive then
            SendModRPCToServer(MOD_RPC[modname]["FollowerSpawn"])
      end 
end)
----------------------------

local function WeaponChange(inst)
        local Isweapon = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil

             if Isweapon and Isweapon:HasTag("chg") and Isweapon.wplevel == 1 and not Isweapon:HasTag("level1_2") and inst.KxTask == nil then 
                      Isweapon:AddTag("level1_2")
                      Isweapon.components.weapon:SetDamage(55)
                      inst.KxTask = inst:DoPeriodicTask(2, function(inst)
                                 inst.components.health:DoDelta(-1, true)
                      end)
               -- SpawnPrefab("collapse_big").Transform:SetPosition(inst:GetPosition():Get())     

             elseif Isweapon and Isweapon:HasTag("chg") and Isweapon.wplevel == 1 and Isweapon:HasTag("level1_2") then        
                        Isweapon:RemoveTag("level1_2")
                         Isweapon.components.weapon:SetDamage(42)

                       if inst.KxTask then 
                             inst.KxTask:Cancel() 
                             inst.KxTask = nil
                  end
            -- SpawnPrefab("collapse_big").Transform:SetPosition(inst:GetPosition():Get())                         
       end        
end  


AddModRPCHandler(modname, "WeaponChange", WeaponChange)

TheInput:AddKeyDownHandler(KEY_V, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"

      if player.prefab == "yuki" and not player:HasTag("playerghost") and IsHUDActive then
            SendModRPCToServer(MOD_RPC[modname]["WeaponChange"])
      end 
end)

local CHANGEWP = Action({ priority = 5, mount_valid = false })
      CHANGEWP.id = "CHANGEWP"    --这个操作的id
      CHANGEWP.str = "切换"    --这个操作的名字，比如法杖是castspell，蜗牛壳甲是use
      CHANGEWP.fn = function(act) --这个操作执行时进行的功能函数

            if act.invobject.wplevel >= act.invobject.maxlevel then
                 act.invobject.wplevel = 0
            end

            act.invobject.wplevel = act.invobject.wplevel + 1      

            if act.invobject.wplevel == 1 then
                act.invobject.components.equippable.walkspeedmult = 1
                act.invobject.components.named:SetName("赤伞") 
                act.invobject.components.inspectable.nameoverride = "broken_sword"                                                     

            elseif act.invobject.wplevel == 2 then
                act.invobject.components.named:SetName("赤伞")
                act.invobject.components.inspectable.nameoverride = "broken_sword"

            elseif act.invobject.wplevel == 3 then 
                act.invobject.components.equippable.walkspeedmult = 0.9  
                act.invobject.components.named:SetName("赤伞(猩红女王)")
                act.invobject.components.inspectable.nameoverride = "sword1"

            else
                act.invobject.components.named:SetName("赤伞(余烬)")
                act.invobject.components.equippable.walkspeedmult = 1
                act.invobject.components.inspectable.nameoverride = "sword2"
            end

            if act.doer and act.doer.components.inventory and act.invobject then
                act.doer.components.inventory:Unequip(EQUIPSLOTS.HANDS)
                act.doer.components.inventory:Equip(act.invobject)
            end               
          return true --我把具体操作加进sg中了，不再在动作这里执行
      end
    AddAction(CHANGEWP) --向游戏注册一个动作

    --往具有某组件的物品添加动作的检测函数，如果满足条件，就向人物的动作可执行表中加入某个动作。right表示是否是右键动作 and (inst.replica.inventoryitem and inst.replica.inventoryitem.owner)
AddComponentAction("INVENTORY", "inventoryitem", function(inst, doer, actions, right)
        if inst and inst:HasTag("chg") and (inst.replica.equippable and inst.replica.equippable:IsEquipped()) then
                table.insert(actions, ACTIONS.CHANGEWP) --这里为动作的id
        end
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.CHANGEWP, "doshortaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.CHANGEWP, "doshortaction"))

local INITIAL_LAUNCH_HEIGHT = 0.1
local SPEED = 8
local function launch_away(inst, position)
    local ix, iy, iz = inst.Transform:GetWorldPosition()
    inst.Physics:Teleport(ix, iy + INITIAL_LAUNCH_HEIGHT, iz)

    local px, py, pz = position:Get()
    local angle = (180 - inst:GetAngleToPoint(px, py, pz)) * DEGREES
    local sina, cosa = math.sin(angle), math.cos(angle)
    inst.Physics:SetVel(SPEED * cosa, 4 + SPEED, SPEED * sina)
end

local function do_water_explosion_effect(inst, affected_entity, position)
    if affected_entity.components.health then
        local ae_combat = affected_entity.components.combat
        if ae_combat then
            ae_combat:GetAttacked(inst, TUNING.TRIDENT.SPELL.DAMAGE, inst)
        else
            affected_entity.components.health:DoDelta(-TUNING.TRIDENT.SPELL.DAMAGE, nil, inst.prefab, nil, inst)
        end
    elseif affected_entity.components.oceanfishable ~= nil then
    if affected_entity.components.weighable ~= nil then
          affected_entity.components.weighable:SetPlayerAsOwner(inst)
    end

        local projectile = affected_entity.components.oceanfishable:MakeProjectile()

        local ae_cp = projectile.components.complexprojectile
        if ae_cp then
            ae_cp:SetHorizontalSpeed(16)
            ae_cp:SetGravity(-30)
            ae_cp:SetLaunchOffset(Vector3(0, 0.5, 0))
            ae_cp:SetTargetOffset(Vector3(0, 0.5, 0))

            local v_position = affected_entity:GetPosition()
            local launch_position = v_position + (v_position - position):Normalize() * SPEED
            ae_cp:Launch(launch_position, projectile)
        else
            launch_away(projectile, position)
        end
    elseif affected_entity.prefab == "bullkelp_plant" then
        local ae_x, ae_y, ae_z = affected_entity.Transform:GetWorldPosition()

        if affected_entity.components.pickable and affected_entity.components.pickable:CanBePicked() then
            local product = affected_entity.components.pickable.product
            local loot = SpawnPrefab(product)
            if loot ~= nil then
                loot.Transform:SetPosition(ae_x, ae_y, ae_z)
                if loot.components.inventoryitem ~= nil then
                    loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
                end
                if loot.components.stackable ~= nil
                        and affected_entity.components.pickable.numtoharvest > 1 then
                    loot.components.stackable:SetStackSize(affected_entity.components.pickable.numtoharvest)
                end
                launch_away(loot, position)
            end
        end

        local uprooted_kelp_plant = SpawnPrefab("bullkelp_root")
        if uprooted_kelp_plant ~= nil then
            uprooted_kelp_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
            launch_away(uprooted_kelp_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
        end

        affected_entity:Remove()
    elseif affected_entity.components.inventoryitem ~= nil then
        launch_away(affected_entity, position)
        affected_entity.components.inventoryitem:SetLanded(false, true)
    elseif affected_entity.waveactive then
        affected_entity:DoSplash()
    elseif affected_entity.components.workable ~= nil and affected_entity.components.workable:GetWorkAction() == ACTIONS.MINE then
        affected_entity.components.workable:WorkedBy(inst, TUNING.TRIDENT.SPELL.MINES)
    end
end

local PLANT_TAGS = {"tendable_farmplant"}
local MUST_HAVE_SPELL_TAGS = nil
local CANT_HAVE_SPELL_TAGS = {"INLIMBO", "outofreach", "DECOR", "player"}
local MUST_HAVE_ONE_OF_SPELL_TAGS = nil
local FX_RADIUS = TUNING.TRIDENT.SPELL.RADIUS * 0.65
local COST_PER_EXPLOSION = TUNING.TRIDENT.USES / TUNING.TRIDENT.SPELL.USE_COUNT
local function create_water_explosion(inst, target, position)
    local px, py, pz = position:Get()

    -- Do gameplay effects.
    local affected_entities = TheSim:FindEntities(px, py, pz, TUNING.TRIDENT.SPELL.RADIUS, MUST_HAVE_SPELL_TAGS, CANT_HAVE_SPELL_TAGS, MUST_HAVE_ONE_OF_SPELL_TAGS)
    for _, v in ipairs(affected_entities) do
        if v:IsOnOcean(false) and not v:HasTag("player") then
            do_water_explosion_effect(inst, v, position)
        end
    end

    -- Spawn visual fx.
    local angle = GetRandomWithVariance(-45, 20)
    for _ = 1, 4 do
        angle = angle + 90
        local offset_x = FX_RADIUS * math.cos(angle * DEGREES)
        local offset_z = FX_RADIUS * math.sin(angle * DEGREES)
        local ox = px + offset_x
        local oz = pz - offset_z

        if TheWorld.Map:IsOceanTileAtPoint(ox, py, oz) and not TheWorld.Map:IsVisualGroundAtPoint(ox, py, oz) then
            local platform_at_point = TheWorld.Map:GetPlatformAtPoint(ox, oz)
            if platform_at_point ~= nil then
                -- Spawn a boat leak slightly further in to help avoid being on the edge of the boat and sliding off.
                local bx, by, bz = platform_at_point.Transform:GetWorldPosition()
                if bx == ox and bz == oz then
                    platform_at_point:PushEvent("spawnnewboatleak", {pt = Vector3(ox, py, oz), leak_size = "med_leak", playsoundfx = true})
                else
                    local p_to_ox, p_to_oz = VecUtil_Normalize(bx - ox, bz - oz)
                    local ox_mod, oz_mod = ox + (0.5 * p_to_ox), oz + (0.5 * p_to_oz)
                    platform_at_point:PushEvent("spawnnewboatleak", {pt = Vector3(ox_mod, py, oz_mod), leak_size = "med_leak", playsoundfx = true})
                end

                local boatphysics = platform_at_point.components.boatphysics
                if boatphysics ~= nil then
                    boatphysics:ApplyForce(offset_x, -offset_z, 1)
                end
            else
                local fx = SpawnPrefab("crab_king_waterspout")
                fx.Transform:SetPosition(ox, py, oz)
            end
        end
    end
end

local CASTSPELL_ON_WATER = Action({ priority=10, rmb=false, distance=20, mount_valid=true  })
      CASTSPELL_ON_WATER.id = "CASTSPELL_ON_WATER"    
      CASTSPELL_ON_WATER.str = "演奏"     
      CASTSPELL_ON_WATER.fn = function(act)
          act.doer.components.sanity:DoDelta(-10)
          create_water_explosion(act.doer, nil, act:GetActionPoint())            
          return true 
      end

AddAction(CASTSPELL_ON_WATER) 

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.CASTSPELL_ON_WATER, "play_strum"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.CASTSPELL_ON_WATER, "play_strum"))  

local function buff1(inst, open)
    if open then
        inst._buff1_open:set(true)
    else
        inst._buff1_open:set(false)       
    end
end

AddModRPCHandler("buff1", "buff1", buff1)