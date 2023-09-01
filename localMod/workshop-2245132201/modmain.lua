PrefabFiles = {
	  "chogath",
	  "chogath_none",
      "nfx"
}	

Assets = {

    Asset("ANIM", "anim/chogath.zip"),

    Asset( "IMAGE", "images/names_chogath.tex" ),
    Asset( "ATLAS", "images/names_chogath.xml" ),

    Asset( "IMAGE", "images/skill_ui/chocath_level.tex" ),
    Asset( "ATLAS", "images/skill_ui/chocath_level.xml" ),

    Asset( "IMAGE", "images/skill_ui/skillone_ui.tex" ),
    Asset( "ATLAS", "images/skill_ui/skillone_ui.xml" ), 
    
    Asset( "IMAGE", "images/skill_ui/skillone_ui_cd.tex" ),
    Asset( "ATLAS", "images/skill_ui/skillone_ui_cd.xml" ),

    Asset( "IMAGE", "images/skill_ui/skilltwo_ui.tex" ),
    Asset( "ATLAS", "images/skill_ui/skilltwo_ui.xml" ),

    Asset( "IMAGE", "images/skill_ui/skilltwo_ui_cd.tex" ),
    Asset( "ATLAS", "images/skill_ui/skilltwo_ui_cd.xml" ),                 

    Asset( "IMAGE", "images/saveslot_portraits/chogath.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/chogath.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/chogath.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/chogath.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/chogath_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/chogath_silho.xml" ),

    Asset( "IMAGE", "bigportraits/chogath.tex" ),
    Asset( "ATLAS", "bigportraits/chogath.xml" ),

	Asset( "IMAGE", "images/map_icons/chogath.tex" ),
	Asset( "ATLAS", "images/map_icons/chogath.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_chogath.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_chogath.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_chogath.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_chogath.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_chogath.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_chogath.xml" ),
	
	Asset( "IMAGE", "images/names_chogath.tex" ),
    Asset( "ATLAS", "images/names_chogath.xml" ),
	
    Asset( "IMAGE", "bigportraits/chogath_none.tex" ),
    Asset( "ATLAS", "bigportraits/chogath_none.xml" )
}
--[[
RemapSoundEvent( "dontstarve/characters/tecolin/death_voice", "tecolin/characters/tecolin/death_voice" )
RemapSoundEvent( "dontstarve/characters/tecolin/hurt", "tecolin/characters/tecolin/hurt" )
RemapSoundEvent( "dontstarve/characters/tecolin/talk_LP", "tecolin/characters/tecolin/talk_LP" )
RemapSoundEvent( "dontstarve/characters/tecolin/emote", "tecolin/characters/tecolin/emote" )
RemapSoundEvent( "dontstarve/characters/tecolin/ghost_LP", "tecolin/characters/tecolin/ghost_LP" )
RemapSoundEvent( "dontstarve/characters/tecolin/yawn", "tecolin/characters/tecolin/yawn" )
RemapSoundEvent( "dontstarve/characters/tecolin/pose", "tecolin/characters/tecolin/pose" )
]]

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

local FOODTYPE = GLOBAL.FOODTYPE
local FOODGROUP = GLOBAL.FOODGROUP

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

TUNING.HEALTH = GetModConfigData("initial_health")
TUNING.HUNGER = GetModConfigData("initial_hunger")

TUNING.CHOGATH_HEALTH = TUNING.HEALTH
TUNING.CHOGATH_HUNGER = TUNING.HUNGER
TUNING.CHOGATH_SANITY = 150

TUNING.TJ_MAX = GetModConfigData("tj")
TUNING.KJS_SPEED = GetModConfigData("kjs_speed")

TUNING.SKILL_ONE = GetModConfigData("skill_one")
TUNING.SKILL_TWO = GetModConfigData("skill_two")

TUNING.R_COOLING = GetModConfigData("R_coolingtime")
TUNING.V_COOLING = GetModConfigData("V_coolingtime")


modimport("scripts/scare_brain.lua")
modimport("scripts/chogath_action.lua")

PREFAB_SKINS["chogath_none"] = {   --修复人物大图显示
	"chogath_none",
}

STRINGS.SKIN_NAMES.chogath_none = "虚空恐惧"  --检查界面显示的名字

STRINGS.NAMES.CHOGATH = "虚空恐惧"
STRINGS.CHARACTER_TITLES.chogath = "虚空恐惧"
STRINGS.CHARACTER_NAMES.chogath = "虚空恐惧"
STRINGS.CHARACTER_DESCRIPTIONS.chogath = "*通过吞噬其他生物来成长\n*可以发出令人畏惧的尖叫\n*它会长得很大，真的很大"

STRINGS.CHARACTER_QUOTES.chogath = "虚空恐惧"
STRINGS.CHARACTER_SURVIVABILITY.chogath = "应该挺容易的吧"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.chogath = --其他玩家检查科加斯的相关对话
{
	GENERIC = "可怕", --默认对话
	ATTACKER = "可怕",  --当科加斯攻击过人时的对话
	MURDERER = "可怕",  --当科加斯杀过人时的对话
	REVIVER = "也许它没看起来那么可怕",  --当科加斯救过他人时的对话
	GHOST = "诡异大小的魂魄",  --当科加斯处于鬼魂状态时的对话
}

AddMinimapAtlas("images/map_icons/chogath.xml")

AddModCharacter("chogath", "FEMALE")

local Chogath_skill = require("widgets/chogath_skill") --加载hello类

local function addChogathWidget(self)
    self.Chogath_skill = self:AddChild(Chogath_skill())-- 为controls添加hello widget。
    self.Chogath_skill:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.Chogath_skill:SetVAnchor(1) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.Chogath_skill:SetPosition(150,-45,0) -- 设置hello widget相对原点的偏移量，70，-50表明向右70，向下50，第三个参数无意义。
end

AddClassPostConstruct("widgets/controls", addChogathWidget) 

AddStategraphState('wilson',

    State{
        name = "scare_taunt",
        tags = {"notalking", "busy", "nopredict", "forcedangle"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("emote_angry", false) 
            inst.sg:SetTimeout(20 * FRAMES)        
        end,
             
        ontimeout = function(inst)
            inst.sg:RemoveStateTag("busy")
            inst.sg:GoToState("idle")
        end,        
    }
)

AddStategraphState('wilson_client',

    State{
        name = "scare_taunt",
        tags = {"busy" },

        onenter = function(inst)  
            inst.components.locomotor:Stop() 
            inst.AnimState:PlayAnimation("emote_angry", false) 
            inst.sg:SetTimeout(20 * FRAMES)       
        end,        
        
        ontimeout = function(inst)
            inst.sg:RemoveStateTag("busy")
            inst.sg:GoToState("idle")
        end,
    }
)

local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 300 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function OnKilledOther(inst, victim)
     if victim and victim.components.lootdropper then

          victim.components.lootdropper.DropLoot = function(self, pt) end

                if victim and victim.components.health then  --把血量大于等于2000的都归为boss吧
                    -- 盛宴叠加被动层数修改 (5 -> 25, 1 -> 5)
                    if victim.components.health.maxhealth >= 2000 then
                        inst.level = inst.level + 25
                    else
                        inst.level = inst.level + 5
                    end
                end     
            if not victim:HasTag("structure") and victim.prefab ~= "lureplant"  and victim.prefab ~= "mushgnome" then        
          local x, y, z = victim.Transform:GetWorldPosition()          

          local loots = victim.components.lootdropper:GenerateLoot()
          local item = nil
             for k, v in pairs(loots) do
                    if v ~= nil then
                          item = SpawnPrefab(v)
                    end 

                  if item ~= nil and not (victim.prefab == "klaus" and not victim:IsUnchained()) then  --吞掉第一个形态的克劳斯不会有掉落物
                       item.Transform:SetPosition(x, 3.5, z)
                       launchitem(item, 180 - inst:GetAngleToPoint(x, 0, z))
                  end     
            end
               if victim and victim.prefab and victim.prefab ~= "klaus" and victim.prefab ~= "mushgnome" then
					if victim.Transform then
						victim.Transform:SetScale(0,0,0)
					end
					if victim.DynamicShadow then
						victim.DynamicShadow:Enable(false)
					end
           end
			end
      end              
end

local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "companion", "abigail"}
      if not TheNet:GetPVPEnabled() then
            table.insert(nottags, "player")
      end
----------------等级显示
local function Skill_One(inst, target)
      if inst.SkillOneUse and target then	      	
                       local damageNum = (100 + inst.level*20) * ((inst.components.combat and inst.components.combat.damagemultiplier) or 1)  --伤害计算 100+层数*20 *攻击倍率
                                   inst.sg:GoToState("chogath_eat")
                                   inst.SkillOneUse = false
                                   inst._canuseskill1:set(false)
                                   inst.components.timer:StartTimer("skillone", TUNING.R_COOLING)

                                           local fx = SpawnPrefab("redpouch_yotc_unwrap")  --红色花瓣特效，类似于血肉横飞的效果
                                           fx.Transform:SetScale(2, 2, 2)  --特效放大
                                           fx.Transform:SetPosition(target.Transform:GetWorldPosition())

                                   target.components.health:DoDelta(-damageNum, nil, (inst.nameoverride or inst.prefab), true, inst, true)  --直接强制扣血，无视防御
                                   target:PushEvent("attacked", { attacker = inst, damage = damageNum, weapon = nil }) 

                                        inst:PushEvent("onhitother", { target = target, damage = damageNum, damageresolved = damageNum, weapon = nil })  --人物发出攻击事件

                                if target.components.health:IsDead() then  --如果目标正好死亡的话
                                        inst:PushEvent("killed", { victim = target }) --人物发出击杀事件

                                          -- local fx2 = SpawnPrefab("halloween_moonpuff")                                           
                                           local fx2 = SpawnPrefab("round_puff_fx_lg")  --其他组织爆炸的效果
                                           fx2.Transform:SetPosition(target.Transform:GetWorldPosition())                                           

                                        OnKilledOther(inst, target)
                                        inst:levelup(inst) --执行人物相关函数,全部写在Modmain里有点乱,所以这里放在人物prefab里面处理                                        
                    end   
                    
          end
end

local function Skill_Two(inst)
    if inst.SkillTwOUse then
          ShakeAllCameras(CAMERASHAKE.FULL, 1.5, .035, .6, inst, 40)

          local pt = Vector3(inst.Transform:GetWorldPosition())

  local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 10, {"_combat"}, nottags)
         for k, v in pairs(ents) do-----------------------------------------------------
                     if v ~= inst and inst.components.combat:CanTarget(v) and not inst.components.combat:IsAlly(v) then 
                            v.components.combat:GetAttacked(inst, 30+(inst.level*3))  --造成10范围的伤害
                 end                 
         end	

          inst.components.epicscare:Scare(8)

          inst.SkillTwOUse = false
          inst._canuseskill2:set(false)
          inst.sg:GoToState("scare_taunt")
          inst.components.timer:StartTimer("skilltwo", TUNING.V_COOLING)

          inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/taunt")

               local fx = SpawnPrefab("groundpoundring_fx")
                     fx.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
          else 
               inst.components.talker:Say("嗓子疼..")
      end 
end            

local function Skill_Cd(inst)      
     inst.components.talker:Say("技能cd中..")
end

AddModRPCHandler(modname, "Skill_Cd", Skill_Cd)  --添加对应rpc以及对应的funcion
AddModRPCHandler(modname, "Skill_One", Skill_One)  --添加对应rpc以及对应的funcion
AddModRPCHandler(modname, "Skill_Two", Skill_Two)  --添加对应rpc以及对应的funcion

if TUNING.SKILL_ONE then
TheInput:AddKeyDownHandler(TUNING.SKILL_ONE, function()
         local screen = TheFrontEnd:GetActiveScreen()
         local IsHUDActive = screen and screen.name == "HUD"
         local x, y, z = TheInput:GetWorldPosition():Get()
         local mouse = Vector3(x, y, z)
         local target = nil
         local ents = TheSim:FindEntities(mouse.x, mouse.y, mouse.z, 15, {"_combat"}, nottags)
                for k, v in pairs(ents) do-----------------------------------------------------
                      if v:IsNear(ThePlayer, 3) and ThePlayer.replica.combat:CanTarget(v) and not ThePlayer.replica.combat:IsAlly(v) then
                              target = v
                            break
                   end
             end           

                   if ThePlayer.prefab == "chogath" and not ThePlayer:HasTag("playerghost") and IsHUDActive and not ThePlayer.replica.health:IsDead() then 
                           if ThePlayer._canuseskill1:value() and target then
                                  if ThePlayer.sg then
                           	             ThePlayer.sg:GoToState("chogath_eat")
                                  end                             
                               SendModRPCToServer(MOD_RPC[modname]["Skill_One"], target)                        

                           elseif target then
                               SendModRPCToServer(MOD_RPC[modname]["Skill_Cd"])
                      end      
               end                         
end)
end

if TUNING.SKILL_TWO then
TheInput:AddKeyDownHandler(TUNING.SKILL_TWO, function()
         local screen = TheFrontEnd:GetActiveScreen()
         local IsHUDActive = screen and screen.name == "HUD"

                   if ThePlayer.prefab == "chogath" and not ThePlayer:HasTag("playerghost") and IsHUDActive and not ThePlayer.replica.health:IsDead() then 
                           if ThePlayer._canuseskill2:value() then

                                  if ThePlayer.sg then
                                         ThePlayer.sg:GoToState("scare_taunt")
                                  end 

                                  if ThePlayer.components.locomotor then      
                                         ThePlayer.components.locomotor:Stop()
                                  end                              
                                 SendModRPCToServer(MOD_RPC[modname]["Skill_Two"])
                           else
                               SendModRPCToServer(MOD_RPC[modname]["Skill_Cd"])
                      end
               end                         
end)
end