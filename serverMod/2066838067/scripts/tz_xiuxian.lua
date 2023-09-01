local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local tz_xx = require "screens/tz_xx"
local taizhen_xiaoshuo = require "widgets/taizhen_xiaoshuo"
local tz_shikong = require "widgets/tz_shikong"
local UIAnimButton = require "widgets/uianimbutton"
local UIAnim = require "widgets/uianim"
--加载ui控件
modimport("scripts/util/tz_ui_control")

AddClassPostConstruct("widgets/statusdisplays", function(self)
	if self.owner and self.owner:HasTag("taizhen") then
		self.tz_batover = self:AddChild(require "widgets/tz_batover"(ThePlayer or self.owner))
		self.inst:ListenForEvent( "tz_xx_skilldrity", function(...)
			self.tz_batover:TriggerBats()
			if self.owner.tz_xx_skill ~= nil and self.owner.tz_xx_skill:value() == 2 then
				self.tz_xx_texie = self:AddChild(UIAnim())	
				self.tz_xx_texie:SetHAnchor(1)
				self.tz_xx_texie:SetVAnchor(2)
				self.tz_xx_texie:SetScale(3) --大小
				self.tz_xx_texie:SetPosition(0, 0, 0) --坐标 xy
				self.tz_xx_texie:MoveToFront()
				
				self.tz_xx_texie:GetAnimState():SetBank("tz_xx_texie")
				self.tz_xx_texie:GetAnimState():SetBuild("tz_xx_texie")
				self.tz_xx_texie:GetAnimState():PlayAnimation("jineng_ui")
				
				self.tz_xx_texie.inst:ListenForEvent("animover", function(...)
					self.tz_xx_texie:Kill()
				end)
			end
		end,self.owner)
	end
end)

AddClassPostConstruct("widgets/controls", function(self)
	if not(self.owner and self.owner:HasTag("taizhen")) then --太真专属
		return
	end
	--修仙
	self.tz_xx_button = self.topleft_root:AddChild(UIAnimButton("tz_button_fx_xiuxian", "tz_button_fx_xiuxian"))
	self.tz_xx_button.animstate:PlayAnimation("button_fx_pre")
	self.tz_xx_button.animstate:PushAnimation("button_fx_loop")
	self.tz_xx_button:SetOnClick(function()
		self.tz_xx_button.animstate:PlayAnimation("button_fx_loop_press")
		self.tz_xx_button.animstate:PushAnimation("button_fx_loop")
		TheFrontEnd:PushScreen(tz_xx(ThePlayer or self.owner))
	end)
	self.tz_xx_button:SetScale(0.9)	--大小
	self.tz_xx_button:SetPosition(160, 10, 0)--坐标
	self.tz_xx_button:SetTooltip("嗷呜修仙(已中止)")
	self.tz_xx_button:SetTooltipPos(0, 40, 0)
	self.inst:ListenForEvent("tz_isxiuxiandirty",function ()
		if self.owner.isxiuxian then
			self.tz_xx_button:SetTooltip(self.owner.isxiuxian:value() and "嗷呜修仙" or"嗷呜修仙(已中止)" )
		end
	end,self.owner)
	Add_Tz_Ui_Button_Controls(self.tz_xx_button,"tz_xx_button_newpos",true) --添加控制
	---=====================

	--看小说
	self.tz_readbook = self:AddChild(taizhen_xiaoshuo(self.owner))
	self.tz_readbook:Hide()
	self.tz_read_button = self.topleft_root:AddChild(UIAnimButton("tz_button_readbook", "tz_button_readbook"))
	self.tz_read_button.animstate:PlayAnimation("fx",true)
	self.tz_read_button:SetOnClick(function()
		self.tz_read_button.animstate:PlayAnimation("press")
		self.tz_read_button.animstate:PushAnimation("fx")
		if self.tz_readbook.shown then
			self.tz_readbook:Close()
		else
			self.tz_readbook:Start()
		end
	end)
	self.tz_read_button:SetScale(0.9)	--大小
	self.tz_read_button:SetPosition(450, -90, 0) --坐标
	self.tz_read_button:SetTooltip("太真窝文选")
	self.tz_read_button:SetTooltipPos(0, 40, 0)
	Add_Tz_Ui_Button_Controls(self.tz_read_button,"tz_read_button_newpos",true) --添加控制
	---=====================

	--星愿祭
	self.tz_xingyuan_button = self.topleft_root:AddChild(UIAnimButton("tz_button_duihuan", "tz_button_huihuan_fx"))
	self.tz_xingyuan_button.animstate:PlayAnimation("normal",true)
	self.tz_xingyuan_button:SetOnClick(function()
		self.tz_xingyuan_button.animstate:PlayAnimation("press")
		self.tz_xingyuan_button.animstate:PushAnimation("normal")
		TheFrontEnd:PushScreen(require("tz_xin/tz_xin_duihuan")(self.owner))
	end)
	self.tz_xingyuan_button:SetScale(0.9)	--大小
	self.tz_xingyuan_button:SetPosition(300, 10, 0) --坐标
	self.tz_xingyuan_button:SetTooltip("星愿祭")
	self.tz_xingyuan_button:SetTooltipPos(0, 40, 0)
	Add_Tz_Ui_Button_Controls(self.tz_xingyuan_button,"tz_xingyuan_button_newpos",true) --添加控制
	--时空ui
	self.tz_shikong = self:AddChild(tz_shikong(self.owner))
	self.tz_shikong:Hide()
	self.tz_shikong_button = self.topleft_root:AddChild(UIAnimButton("tz_trip_fx", "tz_trip_fx"))
	self.tz_shikong_button.animstate:PlayAnimation("background_loop",true)
	self.tz_shikong_button1 = self.tz_shikong_button:AddChild(UIAnim())	
	self.tz_shikong_button1:SetPosition(0, 0, 0)
	self.tz_shikong_button1:GetAnimState():SetBank("tz_trip_fx")
	self.tz_shikong_button1:GetAnimState():SetBuild("tz_trip_fx")
	self.tz_shikong_button1:GetAnimState():PlayAnimation("front_loop")
	self.tz_shikong_button:SetOnClick(function()
		self.tz_shikong_button1:GetAnimState():PlayAnimation("press")
		self.tz_shikong_button1:GetAnimState():PushAnimation("front_loop")
		if self.tz_shikong.shown then
			self.tz_shikong:Close()
		else
			if TUNING.TZSHIKONG then
				self.tz_shikong:Start()
			else
				self.owner.components.talker:Say("关闭！")
			end
		end
	end)
	self.tz_shikong_button:SetScale(0.9)	--大小
	self.tz_shikong_button:SetPosition(570, 10, 0) --坐标
	self.tz_shikong_button:SetTooltip("时空")
	self.tz_shikong_button:SetTooltipPos(0, 40, 0)
	Add_Tz_Ui_Button_Controls(self.tz_shikong_button,"tz_shikong_button",true) --添加控制
	
end)


local function IsValidVictim(victim)
    return victim ~= nil
        and not (
                victim:HasTag("structure") or
                victim:HasTag("wall") or
                victim:HasTag("balloon"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end

--农场种植发事件
AddPrefabPostInit("world", function(inst)
	inst:ListenForEvent("itemplanted", function(inst,data)
		if data and data.doer ~= nil then
			data.doer:PushEvent("plantonfarm")
		end
	end)
	inst:AddComponent("tz_startitem")
end)

local chesss = {"bishop_nightmare","knight_nightmare","rook_nightmare"}	
for _,v in ipairs(chesss) do
	AddPrefabPostInit(v, function(inst)
		if inst.components.follower then
			local old_SetLeader = inst.components.follower.SetLeader
			inst.components.follower.SetLeader = function(self,player,...)
				if player and player:HasTag("player") and not player.makechessfriendincd  then
					player:PushEvent("makechessfriend")
					player.makechessfriendincd = true
					player:DoTaskInTime(0.2,function(doer)doer.makechessfriendincd = false end)
				end
				return old_SetLeader(self,player,...)
			end
		end
	end)
end		

AddComponentPostInit("locomotor", function(self)
	local old_PushTempGroundSpeedMultiplier = self.PushTempGroundSpeedMultiplier
	function self:PushTempGroundSpeedMultiplier(mult, tile)
		if self.inst:HasTag("tzxx_nospeedlow") and mult ~= nil and mult < 1 then
			return
		end
		old_PushTempGroundSpeedMultiplier(self,mult, tile)
	end
	local old_UpdateGroundSpeedMultiplier = self.UpdateGroundSpeedMultiplier
	function self:UpdateGroundSpeedMultiplier(...)
		if self.inst:HasTag("tzxx_nospeedlow") and self.triggerscreep then
			self.triggerscreep = false
		end
		old_UpdateGroundSpeedMultiplier(self,...)
	end
	local oldGetRunSpeed = self.GetRunSpeed
	function self:GetRunSpeed(...)
		local old = oldGetRunSpeed(self,...)
		if self.inst.components.inventory ~= nil and self.inst.components.rider ~= nil and self.inst.components.rider:IsRiding() then
			local mount = self.inst.components.rider:GetMount()
			if mount and mount.prefab == "tz_elong" then
				local is_mighty = self.inst.components.mightiness ~= nil and self.inst.components.mightiness:GetState() == "mighty"
				for k, v in pairs(self.inst.components.inventory.equipslots) do
					if v.components.equippable ~= nil then
						local item_speed_mult = v.components.equippable:GetWalkSpeedMult()
						if is_mighty and item_speed_mult < 1 then
							item_speed_mult = 1
						end
						old = old * item_speed_mult
					end
				end				
			end
		elseif self.inst.replica.inventory and self.inst.replica.rider and self.inst.replica.rider:IsRiding() then
			local mount = self.inst.replica.rider:GetMount()
			if mount and mount.prefab == "tz_elong" then
				local inventory = self.inst.replica.inventory
				local is_mighty = self.inst:HasTag("mightiness_mighty")
				for k, v in pairs(inventory:GetEquips()) do
					local inventoryitem = v.replica.inventoryitem
					if inventoryitem ~= nil then
						local item_speed_mult = inventoryitem:GetWalkSpeedMult()
						if is_mighty and item_speed_mult < 1 then
							item_speed_mult = 1
						end
						old = old * item_speed_mult
					end
				end			
			end
		end
		return old
	end	
end)

AddPrefabPostInit("slurper", function(inst)
	if inst.onattach ~= nil then
		local old_onattach = inst.onattach
		inst.onattach = function(owner)
			old_onattach(owner)
			owner:PushEvent("equipslurper")
		end
	end
end)

AddPrefabPostInit("shadowhand", function(inst)
	inst:ListenForEvent("onremove",function()
		local x,y,z = inst.Transform:GetWorldPosition()
		if x ~= nil then
		local ents = TheSim:FindEntities(x, 0, z, 4, {"player"})
			for i, v in ipairs(ents) do
				v:PushEvent("killshadowhand")
				break
			end
		end
	end)
end)


--施肥发事件
local old = ACTIONS.FERTILIZE.fn
ACTIONS.FERTILIZE.fn = function(act)
	local oldreturn = old(act)
	if oldreturn and act.doer ~= nil then
		act.doer:PushEvent("fertilize_tz")
	end
	return oldreturn
end

local pigs = {
	pigman = true,
	pigguard = true,
	moonpig = true,
}
local hounds = {
	hound = true,
	firehound = true,
	icehound = true,
	moonhound = true,
	clayhound = true,
	mutatedhound = true,
}
local  flower_caves ={
	flower_cave = true,
	flower_cave_double = true,
	flower_cave_triple = true,
}
local spores = {
	spore_tall = true,
	spore_medium = true,
	spore_small = true,
}
local shadows = {
	terrorbeak = true,
	crawlinghorror = true,
	crawlingnightmare = true,
	nightmarebeak = true,
}

local function IsCrazyGuy(guy)
    local sanity = guy ~= nil and guy.replica.sanity or nil
    return sanity ~= nil and sanity:IsInsanityMode() and sanity:GetPercentNetworked() <= (guy:HasTag("dappereffects") and TUNING.DAPPER_BEARDLING_SANITY or TUNING.BEARDLING_SANITY)
end

local boss = {"warg",
	"beequeen",
	"deerclops",
	"dragonfly",
	"klaus",
	"toadstool_dark",
	"toadstool",
	"bearger",
	"minotaur",
	"moose",
	"walrus",
	"ancient_hulk"
}

local function jt()
    local inst = CreateEntity()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst.entity:SetCanSleep(false)
    inst.persists = false
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.AnimState:SetBank("tz_zsq")
    inst.AnimState:SetBuild("tz_zsq")
    inst.AnimState:PlayAnimation("idle")
	
	inst.Transform:SetScale(1, 1, 1)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    return inst
end

local function RotateToTarget(inst,dest)
    local direction = (dest - inst:GetPosition()):GetNormalized()
    local angle = math.acos(direction:Dot(Vector3(1, 0, 0))) / DEGREES
    inst.Transform:SetRotation(angle)
    inst:FacePoint(dest)
end
local function creatjiantou(inst)
	inst:DoTaskInTime(0,function()
		if not inst:IsValid() then
			return
		end
		inst.jiantou = inst:DoPeriodicTask(0.02,function()
			if not (ThePlayer ~= nil and ThePlayer:IsValid() and inst:IsValid()) then
				return
			end
			if  not inst[ThePlayer]  and ThePlayer.prefab == "taizhen" and ThePlayer.tz_xx ~= nil 
				and  ThePlayer.tz_xx:value()[1] ~= nil and  ThePlayer.tz_xx:value()[1] > 3 then
				inst[ThePlayer] = jt()
				inst[ThePlayer].Transform:SetPosition(ThePlayer.Transform:GetWorldPosition())
				RotateToTarget(inst[ThePlayer],inst:GetPosition())
			end			
			if inst[ThePlayer] ~= nil and inst[ThePlayer]:IsValid()  then
				local dis = inst:GetDistanceSqToInst(ThePlayer)
				if dis < 3600  and dis > 576 then
					inst[ThePlayer]:Show()
					inst[ThePlayer].Transform:SetPosition(ThePlayer.Transform:GetWorldPosition())
					RotateToTarget(inst[ThePlayer],inst:GetPosition())
				else
					inst[ThePlayer]:Hide()				
				end
			end
		end)
	end)
end

for i ,v in ipairs(boss) do
AddPrefabPostInit(v,function(inst)
	if not TheNet:IsDedicated() then
		creatjiantou(inst)
		inst:ListenForEvent("onremove", function()
			if inst[ThePlayer] ~= nil then
				inst[ThePlayer]:Remove()
			end
		end)
	end
end)
end

tzxxevent = {
	[1] = {
		[1] = function(player,data)	
			if data.action and data.action == ACTIONS.MINE then
				if player.components.tz_xx.jieduan < 10 then --如果是任务1-9 那么+1
					player.components.tz_xx:DoDeltaJd("1","sh") --增加任务1 的数量  改变的是sh
				end
			end
		end,
		[2] = function(player,data)	
			if data.food and data.food.components.edible and data.food.components.edible.foodtype == FOODTYPE.VEGGIE then
				if player.components.tz_xx.jieduan < 10 then --如果是任务1-9 那么+1
					player.components.tz_xx:DoDeltaJd("4","ba")
				end
			end
		end,
		[3] = function(player,data)	--承受攻击
			if player.components.tz_xx.jieduan < 10 then --如果是任务1-9 那么+1
				player.components.tz_xx:DoDeltaJd("2","hd")
			end
		end,
		[4] = function(player,data)	--击杀
			if data and data.victim  then
				if player.components.tz_xx.jieduan > 9 then --10
					if data.victim.prefab == "spider" then --普通蜘蛛？
						player.components.tz_xx:DoDeltaJd("3","sh")
					elseif data.victim.prefab == "butterfly" then --蝴蝶
						player.components.tz_xx:DoDeltaJd("1","ba")
					elseif data.victim.prefab == "bee" or data.victim.prefab == "killerbee" then --蜜蜂
						player.components.tz_xx:DoDeltaJd("2","kz")
					elseif data.victim.prefab == "deer_blue"then --蓝宝石鹿
						player.components.tz_xx:DoDeltaJd("4","hd")
					end
				elseif IsValidVictim(data.victim) then
					player.components.tz_xx:DoDeltaJd("3","kz")
				end
			end
		end,
	},
	[2] = {
		[1] = function(player,data)	
			if player.components.tz_xx.jieduan < 10 then --如果是任务1-9 那么+1
				player.components.tz_xx:DoDeltaJd("3","sh") --增加任务1 的数量  改变的是sh
			end
		end,
		[2] = function(player,data)	
			if data.food and data.food.components.edible and data.food.components.edible.foodtype == FOODTYPE.MEAT then
				if player.components.tz_xx.jieduan < 10 then --如果是任务1-9 那么+1
					player.components.tz_xx:DoDeltaJd("1","ba")
				end
			end
		end,
		[3] = function(player,data)
			if player.components.tz_xx.jieduan < 10 then --如果是任务1-9 那么+1
				player.components.tz_xx:DoDeltaJd("2","hd")
			end
		end,
		[4] = function(player,data)	--右键击杀
			if player.components.tz_xx.jieduan < 10 then --如果是任务1-9 那么+1
				player.components.tz_xx:DoDeltaJd("4","kz")
			end
		end,
		[5] = function(player,data)	--击杀
			if data and data.victim  then
				if player.components.tz_xx.jieduan > 9 then
					if data.victim.prefab == "bearger" then
						player.components.tz_xx:DoDeltaJd("1","hd")
					elseif data.victim.prefab == "rabbit" then
						player.components.tz_xx:DoDeltaJd("3","ba")
					elseif data.victim.prefab == "penguin"then
						player.components.tz_xx:DoDeltaJd("4","kz")
					elseif data.victim.prefab == "mosquito"then
						player.components.tz_xx:DoDeltaJd("2","sh")
					end
				end
			end
		end,
	},
	[3] = {
		[1] = function(player,data)	
			if data.action and data.action == ACTIONS.HAMMER then
				if data.target and data.target:HasTag("structure") then
					if player.components.tz_xx.jieduan < 10 then --如果是任务1-9 那么+1
						player.components.tz_xx:DoDeltaJd("3","hd") --增加任务1 的数量  改变的是sh
					end
				end
			end
		end,
		[2] = function(player,data)	
			if data.food and data.food.components.edible and data.food.components.edible.foodtype == FOODTYPE.GOODIES then
				if player.components.tz_xx.jieduan < 10 then --如果是任务1-9 那么+1
					player.components.tz_xx:DoDeltaJd("4","ba")
				end
			end
		end,
		[3] = function(player,data)
			if player.components.tz_xx.jieduan < 10 then --如果是任务1-9 那么+1
				player.components.tz_xx:DoDeltaJd("1","sh")
			end
		end,
		[4] = function(player,data)	--击杀
			if data and data.victim  then
				if player.components.tz_xx.jieduan > 9 then
					if data.victim.prefab == "antlion" then
						player.components.tz_xx:DoDeltaJd("1","hd")
					elseif data.victim.prefab == "crow" then
						player.components.tz_xx:DoDeltaJd("3","ba")
					elseif data.victim.prefab == "pigman" then --普通猪人
						player.components.tz_xx:DoDeltaJd("2","kz")
					elseif hounds[data.victim.prefab] then
						player.components.tz_xx:DoDeltaJd("4","sh")
					end
				elseif data.victim.prefab == "spider_warrior" then
					player.components.tz_xx:DoDeltaJd("2","kz")
				end
			end
		end,
	},
	[4] = {
		[1] = function(player,data)	
			if data.action and data.action == ACTIONS.NET then
				if player.components.tz_xx.jieduan < 10 then 
					player.components.tz_xx:DoDeltaJd("3","sh")
				end
			end
		end,
		[2] = function(player,data)	
			if data.food and data.food.prefab == "meatballs" then
				if player.components.tz_xx.jieduan < 10 then
					player.components.tz_xx:DoDeltaJd("2","ba")
				end
			end
		end,
		[3] = function(player,data)
			if player.components.tz_xx.jieduan < 10 then
				player.components.tz_xx:DoDeltaJd("4","hd")
			end
		end,
		[4] = function(player,data)	--击杀
			if data and data.victim  then
				if player.components.tz_xx.jieduan > 9 then
					if data.victim.prefab == "beequeen" then
						player.components.tz_xx:DoDeltaJd("3","hd")
					elseif data.victim.prefab == "perd" then
						player.components.tz_xx:DoDeltaJd("4","ba")
					elseif data.victim.prefab == "pigman" and data.victim:HasTag("werepig") then  --疯猪
						player.components.tz_xx:DoDeltaJd("1","sh")
					elseif data.victim.prefab == "beefalo" then
						player.components.tz_xx:DoDeltaJd("2","kz")
					end
				elseif pigs[data.victim.prefab] then
					player.components.tz_xx:DoDeltaJd("1","kz")
				end
			end
		end,
	},
	[5] = {
		[1] = function(player,data)	
			if player.components.tz_xx.jieduan < 10 then 
				player.components.tz_xx:DoDeltaJd("4","sh")
			end
		end,
		[2] = function(player,data)	
			if data.food and data.food.prefab == "dragonpie" then
				if player.components.tz_xx.jieduan < 10 then
					player.components.tz_xx:DoDeltaJd("3","ba")
				end
			end
		end,
		[3] = function(player,data)
			if player.components.tz_xx.jieduan < 10 then
				player.components.tz_xx:DoDeltaJd("1","hd")
			end
		end,
		[4] = function(player,data)	--击杀
			if data and data.victim  then
				if player.components.tz_xx.jieduan > 9 then
					if data.victim.prefab == "malbatross" then
						player.components.tz_xx:DoDeltaJd("2","hd")
					elseif data.victim.prefab == "lightninggoat" then
						player.components.tz_xx:DoDeltaJd("4","kz")
					elseif data.victim.prefab == "grassgekko" then
						player.components.tz_xx:DoDeltaJd("3","ba")
					elseif data.victim.prefab == "tentacle" then
						player.components.tz_xx:DoDeltaJd("1","sh")
					end
				elseif data.victim.prefab == "bat" then
					player.components.tz_xx:DoDeltaJd("2","kz")
				end
			end
		end,
	},
	[6] = {
		[1] = function(player,data)
			if data and data.object and flower_caves[data.object.prefab] then
				if player.components.tz_xx.jieduan < 10 then 
					player.components.tz_xx:DoDeltaJd("2","sh")
				end
			end
		end,
		[2] = function(player,data)	
			if data.food and (data.food.prefab == "eel" or data.food.prefab == "eel_cooked") then
				if player.components.tz_xx.jieduan < 10 then
					player.components.tz_xx:DoDeltaJd("4","ba")
				end
			end
		end,
		[3] = function(player,data)
			if player.components.tz_xx.jieduan < 10 then
				player.components.tz_xx:DoDeltaJd("3","hd")
			end
		end,
		[4] = function(player,data)	--击杀
			if data and data.victim  then
				if player.components.tz_xx.jieduan > 9 then
					if data.victim.prefab == "stalker" then
						player.components.tz_xx:DoDeltaJd("3","hd")
					elseif data.victim.prefab == "bunnyman" and IsCrazyGuy(player) then --胡须领主
						player.components.tz_xx:DoDeltaJd("1","kz")
					elseif data.victim.prefab == "mole" then
						player.components.tz_xx:DoDeltaJd("2","ba")
					elseif data.victim.prefab == "spider_spitter" then
						player.components.tz_xx:DoDeltaJd("4","sh")
					end
				elseif data.victim.prefab == "bunnyman" and not IsCrazyGuy(player) then --普通兔人
					player.components.tz_xx:DoDeltaJd("1","kz")
				end
			end
		end,
	},
	[7] = {
		[1] = function(player,data)
			if data.action and data.action == ACTIONS.NET and data.target and spores[data.target.prefab]then
				if player.components.tz_xx.jieduan < 10 then 
					player.components.tz_xx:DoDeltaJd("1","sh")
				end
			elseif data.action and data.action == ACTIONS.HAMMER and data.target and data.target:HasTag("chess")then
				if player.components.tz_xx.jieduan < 10 then 
					player.components.tz_xx:DoDeltaJd("2","hd",10)
				end
			end
		end,
		[2] = function(player,data)	
			if data.food and (data.food.prefab == "cave_banana" or data.food.prefab == "cave_banana_cooked") then
				if player.components.tz_xx.jieduan < 10 then
					player.components.tz_xx:DoDeltaJd("3","ba")
				end
			end
		end,
		[3] = function(player,data)	--击杀
			if data and data.victim  then
				if player.components.tz_xx.jieduan > 9 then
					if data.victim.prefab == "minotaur" then
						player.components.tz_xx:DoDeltaJd("3","hd")
					elseif data.victim.prefab == "rocky" then
						player.components.tz_xx:DoDeltaJd("4","kz")
					elseif data.victim.prefab == "canary" then
						player.components.tz_xx:DoDeltaJd("1","ba")
					elseif data.victim.prefab == "slurtle" then
						player.components.tz_xx:DoDeltaJd("2","sh")
					end
				elseif data.victim.prefab == "monkey" and not data.victim:HasTag("nightmare") then
					player.components.tz_xx:DoDeltaJd("4","kz")
				end
			end
		end,
	},		
	[8] = {
		[1] = function(player,data)
			if data.action and data.action == ACTIONS.MINE and data.target and data.target:HasTag("cavedweller") then				
				if player.components.tz_xx.jieduan < 10 then 
					player.components.tz_xx:DoDeltaJd("2","sh",10)
				end
			elseif data.action and data.action == ACTIONS.HAMMER and data.target and data.target:HasTag("altar") then
				if player.components.tz_xx.jieduan < 10 then 
					player.components.tz_xx:DoDeltaJd("2","sh",data.target.prefab == "ancient_altar" and 15 or 5)
				end			
			end
		end,
		[2] = function(player,data)	
			if data.food and (data.food.prefab == "wormlight" or data.food.prefab == "wormlight_lesser") then
				if player.components.tz_xx.jieduan < 10 then
					player.components.tz_xx:DoDeltaJd("1","ba")
				end
			end
		end,
		[3] = function(player,data)
			if player.components.tz_xx.jieduan < 10 then
				player.components.tz_xx:DoDeltaJd("4","hd")
			end
		end,
		[4] = function(player,data)	--击杀
			if data and data.victim  then
				if player.components.tz_xx.jieduan > 9 then
					if data.victim.prefab == "stalker_atrium" then
						player.components.tz_xx:DoDeltaJd("4","hd")
					elseif shadows[data.victim.prefab] then
						player.components.tz_xx:DoDeltaJd("1","kz")
					elseif data.victim.prefab == "deer" then
						player.components.tz_xx:DoDeltaJd("2","ba")
					elseif data.victim.prefab == "monkey" and data.victim:HasTag("nightmare") then
						player.components.tz_xx:DoDeltaJd("3","sh")
					end
				elseif data.victim:HasTag("chess") then
					player.components.tz_xx:DoDeltaJd("3","kz")
				end
			end
		end,
	},	
	[9] = {
		[1] = function(player,data)
			if player.components.tz_xx.jieduan < 10 then 
				player.components.tz_xx:DoDeltaJd("2","hd")
			end
		end,
		[2] = function(player,data)	--击杀
			if data and data.victim  then
				if player.components.tz_xx.jieduan > 9 then
					if data.victim.prefab == "klaus" and data.victim.IsUnchained ~= nil  and data.victim:IsUnchained() then
						player.components.tz_xx:DoDeltaJd("1","kz")
					elseif data.victim.prefab == "toadstool_dark" then
						player.components.tz_xx:DoDeltaJd("2","hd")
					elseif data.victim.prefab == "alterguardian_phase3" then
						player.components.tz_xx:DoDeltaJd("3","ba")
					elseif data.victim.prefab == "crabking" then
						player.components.tz_xx:DoDeltaJd("4","sh")
					end
				else
					--if data.victim:HasTag("ghost") then
					--	player.components.tz_xx:DoDeltaJd("3","sh")
					--elseif data.victim.prefab == "carrat" then
					--	player.components.tz_xx:DoDeltaJd("4","ba")
					if data.victim.prefab == "beeguard" then
						player.components.tz_xx:DoDeltaJd("1","kz")
					end
				end
			end
		end,
		[3] = function(player,data)	
			if data.food and data.food.prefab == "bonestew" then
				if player.components.tz_xx.jieduan < 10 then
					player.components.tz_xx:DoDeltaJd("4","ba")
				end
			end
		end,
		[4] = function(player,data)	
			if player.components.tz_xx.jieduan < 10 then
				player.components.tz_xx:DoDeltaJd("3","sh")
			end
		end,
	},
}

TUNING.TZXX  ={
	--第一个任务
	[1] = {
		task1 ={ --也就是1-9阶段
			[1] = {ms = "矿石开采",num =9},
			[2] = {ms = "承受攻击",num =9},
			[3] = {ms = "消灭生物",num =9},
			[4] = {ms = "食用蔬菜类食物",num =9},
		},
		task2 ={ --也就是10阶段
			[1] = {ms = "消灭蝴蝶",num =99},
			[2] = {ms = "消灭蜜蜂",num =99},
			[3] = {ms = "消灭蜘蛛",num =99},
			[4] = {ms = "击杀使用霜冻魔法的生物",num =1},
		},
		ListenForEvent = function(player)
			player:ListenForEvent("finishedwork", tzxxevent[1][1]) --开采的	
			player:ListenForEvent("oneat", tzxxevent[1][2]) --吃蔬菜
			player:ListenForEvent("attacked", tzxxevent[1][3]) --承受攻击			
			player:ListenForEvent("killed", tzxxevent[1][4]) --击杀	
			end,
		RemoveEventCallback = function(player)
			player:RemoveEventCallback("finishedwork", tzxxevent[1][1])
			player:RemoveEventCallback("oneat", tzxxevent[1][2])
			player:RemoveEventCallback("attacked", tzxxevent[1][3])
			player:RemoveEventCallback("killed", tzxxevent[1][4])
		end,		
		jl = { },--终极奖励
	},
	--第2个任务
	[2] = {
		task1 ={ --也就是1-9阶段
			[1] = {ms = "食用肉类食物",num =9},
			[2] = {ms = "点燃物体",num =9},
			[3] = {ms = "农田种植",num =9},
			[4] = {ms = "完成生物杀害",num =9},
		},
		task2 ={ --也就是10阶段
			[1] = {ms = "狩猎丰收季的大型生物",num =1},
			[2] = {ms = "消灭蚊子",num =99},
			[3] = {ms = "消灭兔子",num =99},
			[4] = {ms = "消灭企鹅",num =99},
		},
		ListenForEvent = function(player)
			player:ListenForEvent("plantonfarm", tzxxevent[2][1]) --开采的	
			player:ListenForEvent("oneat", tzxxevent[2][2]) --吃蔬菜
			player:ListenForEvent("onstartedfire", tzxxevent[2][3]) --点燃目标
			player:ListenForEvent("murdered", tzxxevent[2][4]) --右键击杀			
			player:ListenForEvent("killed", tzxxevent[2][5]) --击杀	
		end,
		RemoveEventCallback = function(player)
			player:RemoveEventCallback("plantonfarm", tzxxevent[2][1])
			player:RemoveEventCallback("oneat", tzxxevent[2][2])
			player:RemoveEventCallback("onstartedfire", tzxxevent[2][3])
			player:RemoveEventCallback("murdered", tzxxevent[2][4])	
			player:RemoveEventCallback("killed", tzxxevent[2][5])	
		end,		
		jl = { },--终极奖励
	},
	--第3个任务
	[3] = {
		task1 ={ --也就是1-9阶段
			[1] = {ms = "施肥枯萎植物",num =9},
			[2] = {ms = "消灭斗士蜘蛛",num =9},
			[3] = {ms = "敲毁建筑",num =9},
			[4] = {ms = "食用糖类食物",num =9},
		},
		task2 ={ --也就是10阶段
			[1] = {ms = "狩猎掌控大地的大型生物",num =1},
			[2] = {ms = "消灭普通猪人",num =99},
			[3] = {ms = "消灭乌鸦",num =99},
			[4] = {ms = "消灭猎犬",num =99},
		},
		ListenForEvent = function(player)
			player:ListenForEvent("finishedwork", tzxxevent[3][1])
			player:ListenForEvent("oneat", tzxxevent[3][2])
			player:ListenForEvent("fertilize_tz", tzxxevent[3][3])			
			player:ListenForEvent("killed", tzxxevent[3][4])
		end,
		RemoveEventCallback = function(player)
			player:RemoveEventCallback("finishedwork", tzxxevent[3][1])
			player:RemoveEventCallback("oneat", tzxxevent[3][2])
			player:RemoveEventCallback("fertilize_tz", tzxxevent[3][3])
			player:RemoveEventCallback("killed", tzxxevent[3][4])
		end,		
		jl = { },--终极奖励
	},
	--第4个任务
	[4] = {
		task1 ={ --也就是1-9阶段
			[1] = {ms = "消灭猪人",num =9},
			[2] = {ms = "食用肉丸",num =9},
			[3] = {ms = "捕虫成功",num =9},
			[4] = {ms = "触碰尖刺",num =9},
		},
		task2 ={ --也就是10阶段
			[1] = {ms = "消灭疯猪",num =99},
			[2] = {ms = "消灭牦牛",num =99},
			[3] = {ms = "狩猎昆虫类的大型生物1次",num =1},
			[4] = {ms = "消灭火鸡",num =99},
		},
		ListenForEvent = function(player)
			player:ListenForEvent("finishedwork", tzxxevent[4][1])
			player:ListenForEvent("oneat", tzxxevent[4][2])
			player:ListenForEvent("thorns", tzxxevent[4][3])			
			player:ListenForEvent("killed", tzxxevent[4][4])
		end,
		RemoveEventCallback = function(player)
			player:RemoveEventCallback("finishedwork", tzxxevent[4][1])
			player:RemoveEventCallback("oneat", tzxxevent[4][2])
			player:RemoveEventCallback("thorns", tzxxevent[4][3])
			player:RemoveEventCallback("killed", tzxxevent[4][4])
		end,		
		jl = { },--终极奖励
	},
	--第5个任务
	[5] = {
		task1 ={ --也就是1-9阶段
			[1] = {ms = "经历燃烧",num =9},
			[2] = {ms = "消灭洞穴蝙蝠",num =9},
			[3] = {ms = "食用火龙果派",num =9},
			[4] = {ms = "钓鱼成功",num =9},
		},
		task2 ={ --也就是10阶段
			[1] = {ms = "消灭触手",num =99},
			[2] = {ms = "狩猎掌管天空的巨大飞行生物1次",num =1},
			[3] = {ms = "消灭草蜥蜴",num =99},
			[4] = {ms = "消灭福特山羊",num =99},
		},
		ListenForEvent = function(player)
			player:ListenForEvent("fishingcatch", tzxxevent[5][1])
			player:ListenForEvent("oneat", tzxxevent[5][2])
			player:ListenForEvent("startfiredamage", tzxxevent[5][3])			
			player:ListenForEvent("killed", tzxxevent[5][4])
		end,
		RemoveEventCallback = function(player)
			player:RemoveEventCallback("fishingcatch", tzxxevent[5][1])
			player:RemoveEventCallback("oneat", tzxxevent[5][2])
			player:RemoveEventCallback("startfiredamage", tzxxevent[5][3])
			player:RemoveEventCallback("killed", tzxxevent[5][4])
		end,		
		jl = { },--终极奖励
	},
	--第6个任务
	[6] = {
		task1 ={ --也就是1-9阶段
			[1] = {ms = "消灭兔人",num =9},
			[2] = {ms = "荧光果采摘",num =9},
			[3] = {ms = "被啜食兽包住头部",num =9},
			[4] = {ms = "食用鳗鱼",num =9},
		},
		task2 ={ --也就是10阶段
			[1] = {ms = "消灭胡须领主",num =99},
			[2] = {ms = "消灭鼹鼠",num =99},
			[3] = {ms = "击杀洞穴的守护者",num =1},
			[4] = {ms = "消灭喷射蜘蛛",num =99},
		},
		ListenForEvent = function(player)
			player:ListenForEvent("picksomething", tzxxevent[6][1])
			player:ListenForEvent("oneat", tzxxevent[6][2])
			player:ListenForEvent("equipslurper", tzxxevent[6][3])			
			player:ListenForEvent("killed", tzxxevent[6][4])
		end,
		RemoveEventCallback = function(player)
			player:RemoveEventCallback("picksomething", tzxxevent[6][1])
			player:RemoveEventCallback("oneat", tzxxevent[6][2])
			player:RemoveEventCallback("equipslurper", tzxxevent[6][3])
			player:RemoveEventCallback("killed", tzxxevent[6][4])
		end,		
		jl = { },--终极奖励
	},
	--第7个任务
	[7] = {
		task1 ={ --也就是1-9阶段
			[1] = {ms = "捕捉孢子生物",num =9},
			[2] = {ms = "敲毁远古残骸",num =9},
			[3] = {ms = "食用香蕉",num =9},
			[4] = {ms = "消灭暴躁猴",num =9},
		},
		task2 ={ --也就是10阶段
			[1] = {ms = "消灭金丝雀",num =99},
			[2] = {ms = "消尖壳蜗牛",num =99},
			[3] = {ms = "击杀野蛮冲撞的大型生物1次",num =1},
			[4] = {ms = "消灭石虾",num =99},
		},
		ListenForEvent = function(player)
			player:ListenForEvent("finishedwork", tzxxevent[7][1])
			player:ListenForEvent("oneat", tzxxevent[7][2])
			--player:ListenForEvent("equipslurper", tzxxevent[7][3])			
			player:ListenForEvent("killed", tzxxevent[7][3])
		end,
		RemoveEventCallback = function(player)
			player:RemoveEventCallback("finishedwork", tzxxevent[7][1])
			player:RemoveEventCallback("oneat", tzxxevent[7][2])
			--player:RemoveEventCallback("equipslurper", tzxxevent[7][3])
			player:RemoveEventCallback("killed", tzxxevent[7][3])
		end,		
		jl = { },--终极奖励
	},
	--第8个任务
	[8] = {
		task1 ={ --也就是1-9阶段
			[1] = {ms = "食用发光蓝莓",num =9},
			[2] = {ms = "开采远古雕像",num =9},
			[3] = {ms = "消灭发条生物",num =9},
			[4] = {ms = "雇佣残破发条生物",num =9},
		},
		task2 ={ --也就是10阶段
			[1] = {ms = "消灭暗影爬行生物",num =99},
			[2] = {ms = "消灭无眼鹿",num =99},
			[3] = {ms = "消灭暗影暴躁猴",num =99},
			[4] = {ms = "击杀暗影的支配者",num =1},
		},
		ListenForEvent = function(player)
			player:ListenForEvent("finishedwork", tzxxevent[8][1])
			player:ListenForEvent("oneat", tzxxevent[8][2])
			player:ListenForEvent("makechessfriend", tzxxevent[8][3])			
			player:ListenForEvent("killed", tzxxevent[8][4])
		end,
		RemoveEventCallback = function(player)
			player:RemoveEventCallback("finishedwork", tzxxevent[8][1])
			player:RemoveEventCallback("oneat", tzxxevent[8][2])
			player:RemoveEventCallback("makechessfriend", tzxxevent[8][3])
			player:RemoveEventCallback("killed", tzxxevent[8][4])
		end,		
		jl = { },--终极奖励
	},
	--第9个任务
	[9] = {
		task1 ={ --也就是1-9阶段
			[1] = {ms = "消灭守卫蜂",num =9},--{ms = "消灭蝾螈",num =9},
			[2] = {ms = "击退黑暗鬼手",num =9},
			[3] = {ms = "划船",num = 9},--{ms = "消灭幽灵",num =9}
			[4] = {ms = "使用炖肉汤",num =9},--{ms = "消灭胡萝卜鼠",num =9}
		},
		task2 ={ --也就是10阶段
			[1] = {ms = "狩猎宝藏收集家",num =1},
			[2] = {ms = "狩猎蕴含剧毒的大型生物",num =1},
			[3] = {ms = "狩猎天体文明",num =1},
			[4] = {ms = "狩猎海洋的管理员",num =1},
		},
		ListenForEvent = function(player)
			player:ListenForEvent("killshadowhand", tzxxevent[9][1])		
			player:ListenForEvent("killed", tzxxevent[9][2])
			player:ListenForEvent("oneat", tzxxevent[9][3])
			player:ListenForEvent("rowing", tzxxevent[9][4])
		end,
		RemoveEventCallback = function(player)
			player:RemoveEventCallback("killshadowhand", tzxxevent[9][1])
			player:RemoveEventCallback("killed", tzxxevent[9][2])
			player:RemoveEventCallback("oneat", tzxxevent[9][3])
			player:RemoveEventCallback("rowing", tzxxevent[9][4])
		end,		
		jl = { },--终极奖励
	}
}	

--[[
【等级九：观月】
第一阶修炼内容：
守恒：消灭幽灵9次
不安：消灭胡萝卜鼠9次
狂躁：消灭蝾螈9次
混沌：击退nighthand9次（踩掉整条偷火的手，船上那个也算上）

*第十阶修炼内容：
守恒：狩猎海洋的管理员3次（大螃蟹）
不安：狩猎天空的霸者3次（蜻蜓龙）
狂躁：狩猎宝藏收集家3次（克劳斯）
混沌：狩猎蕴含剧毒的大型生物3次（加强蟾蜍）
]]

--[[
【等级一：小狐夭】
第一阶修炼内容：
守恒：矿石开采9次
不安：食用蔬菜类食物9次
狂躁：消灭生物9次（打怪）
混沌：承受攻击9次

*第十阶修炼内容：
守恒：消灭蜘蛛99次
不安：消灭蝴蝶99次
狂躁：消灭蜜蜂99次（杀人蜂和蜜蜂都算）
混沌：击杀使用霜冻魔法的生物1次（克劳斯的蓝宝石鹿）

【等级二：小个子祠侍】
第一阶修炼内容：
守恒：农田种植9次
不安：食用肉类食物9次
狂躁：完成生物杀害9次（物品栏右键杀害）
混沌：点燃物体9次

*第十阶修炼内容：
守恒：消灭蚊子99次
不安：消灭兔子99次（雪兔和普通兔）
狂躁：消灭企鹅99次
混沌：狩猎丰收季的大型生物1次（熊獾）

【等级三：尖耳朵术士长】
第一阶修炼内容：
守恒：施肥枯萎植物9次
不安：食用糖类食物9次
狂躁：消灭斗士蜘蛛9次
混沌：敲毁建筑9次

*第十阶段修炼内容：
守恒：消灭猎犬99次
不安：消灭乌鸦99次
狂躁：消灭猪人99次
混沌：狩猎掌控大地的大型生物1次（蚁狮）

【等级四：大尾巴巫师】
第一阶修炼内容：
守恒：捕虫成功9次（捕虫网抓任何虫）
不安：食用肉丸9次
狂躁：消灭猪人9次（就普通猪人）
混沌：触碰尖刺9次（摘仙人掌和荆棘丛）

*第十阶修炼内容：
守恒：消灭疯猪99次
不安：消灭火鸡99次
狂躁：消灭牦牛99次
混沌：狩猎昆虫类的大型生物1次（蜂后）

【等级五：灵眸祭司】
第一阶修炼内容：
守恒：钓鱼成功9次
不安：食用火龙果派9次
狂躁：消灭洞穴蝙蝠9次
混沌：经历燃烧9次（身上着火）

*第十阶修炼内容：
守恒：消灭触手99次
不安：消灭草蜥蜴99次
狂躁：消灭福特山羊99次
混沌：狩猎掌管天空的巨大飞行生物1次（邪天翁）

【等级六：狐灵殿禁卫军】
第一阶修炼内容：
守恒：荧光果采摘9次
不安：食用鳗鱼9次（生鳗鱼和烤鳗鱼）
狂躁：消灭兔人9次
混沌：被啜食兽包住头部9次

*第十阶修炼内容：
守恒：消灭喷射蜘蛛99次
不安：消灭鼹鼠99次
狂躁：消灭胡须领主99次
混沌：击杀洞穴的守护者1次（骨架在地下复活那个）

【等级七：番号护法】
第一阶修炼内容：
守恒：捕捉孢子生物9次（3种颜色的孢子）
不安：食用香蕉9次（生香蕉和烤香蕉）
狂躁：消灭暴躁猴9次（普通猴子）
混沌：敲毁远古残骸9次（爆烂电线和齿轮的那些建筑）

*第十阶修炼内容：
守恒：消尖壳蜗牛99次
不安：消灭金丝雀99次（武器击杀）
狂躁：消灭石虾99次
混沌：击杀野蛮冲撞的大型生物1次（犀牛）

【等级八：织影长者】
第一阶修炼内容：
守恒：开采远古雕像9次（各种远古雕像）
不安：食用发光蓝莓9次
狂躁：消灭发条生物9次（普通和残破的都算）
混沌：雇佣残破发条生物9次

*第十阶修炼内容：
守恒：消灭暗影暴躁猴99次
不安：消灭无眼鹿99次
狂躁：消灭暗影爬行生物99次（尖嘴和爬行影怪） 
混沌：击杀暗影的支配者1次（中庭boss） stalker_atrium

【等级九：观月】
第一阶修炼内容：
守恒：消灭幽灵9次
不安：消灭胡萝卜鼠9次
狂躁：消灭蝾螈9次
混沌：击退nighthand9次（踩掉整条偷火的手，船上那个也算上）

*第十阶修炼内容：
守恒：狩猎海洋的管理员3次（大螃蟹）
不安：狩猎天空的霸者3次（蜻蜓龙）
狂躁：狩猎宝藏收集家3次（克劳斯）
混沌：狩猎蕴含剧毒的大型生物3次（加强蟾蜍）


【等级一：小狐夭】
解锁技能：人家可是凶猛的灵狐！嗷！           发动：伤害倍率+10%
（不累加）获得能力：撒麻值上限+25

【等级二：小个子祠侍】
解锁技能：小个子才不好欺负           发动：蛛网地形、塌陷地形、粘液地形减速无效
获得能力：撒麻值上限+75

【等级三：尖耳朵术士长】
解锁技能：长耳朵不是装饰哦          发动：获得一定范围内大型生物的位置
获得能力：撒麻值上限+125

【等级四：大尾巴巫师】
解锁技能：大尾巴用来保持身体平衡           发动：对攻击闪避几率+15%
获得能力：撒麻值上限+175、食用噩梦燃料回复效率+20%

【等级五：灵眸祭司】
解锁技能：要成为大法师，不学习魔法知识怎么行？           发动：获得所有书籍使用权
获得能力：撒麻值上限+225、食用噩梦燃料回复效率+40%

【等级六：狐灵殿禁卫军】
解锁技能：灵狐族人世代流传繁荣昌盛          发动：食用噩梦燃料时，周围的灵狐人获得噩梦燃料50%的回复效果
获得能力：撒麻值上限+275、食用噩梦燃料回复效率+60%

【等级七：番号护法】
解锁技能：番号乃是我族操控暗影的利器          发动：佩戴番号时，获得伤害倍率+25%、撒麻值+12/min
获得能力：撒麻值上限+325、食用噩梦燃料回复效率+80%、影人召唤数量上限+1

【等级八：织影长者】
解锁技能：暗影人偶是从一本书中学到的          发动：召唤暗影随从时50%概率召唤2只
获得能力：撒麻值上限+375、食用噩梦燃料回复效率+100%、影人召唤数量上限+2

【等级九：观月】
解锁技能：【二次觉醒】 八荒六界，我是嗷呜，任我行！         发动：召唤暗影轰雷降临凡间
获得能力：撒麻值上限+425、食用噩梦燃料回复效率+120%、影人召唤数量上限+3



    每1点摸摸属性=减伤+0.5%、食用食物回复效率+1%、饥饿度上限+2  ba 
    每1点嗷呜属性=生命值上限+1、对攻击闪避几率+0.5%、撒麻值回复+1/min sh
    每1点摇尾巴属性=攻击吸收精神+0.1%、伤害倍率+1% kz
    每1点影子舞属性=攻击吸血+0.1%、脑力值上限+1 hd

	鼠标放在属性上面显示：
	每一点该项属性对人物的提升：攻击吸血+0.1%、脑力值上限+1
）


一觉解锁时，人物说：太真身体里的暗影能力已经被唤醒
二觉解锁时，人物说：这就是……灵狐的极限了吗？
技能cd中按技能，人物说：技能冷却中

【嗷石】配方上的话：要睡觉的都出去，我要修仙了！
检查语句：灵狐人开启修炼之路的神石
（其他角色右键是检查)

完成1-9阶任务：主人，太真完成了一个修炼内容哦
播放音效：学习蓝图

完成10阶任务：太真又变强了！嗷呜！
播放音效：暗影操纵器学习东西

完成所有修仙内容：已经掌握灵狐的所有奥义
]]

AddStategraphState("wilson",
    State{
        name = "tz_xx_pre",
        tags = { "notalking", "busy", "nodangle","tzxx"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
			if inst.components.talker ~= nil then
				inst.components.talker:IgnoreAll("tzxx")
			end
			inst:ClearBufferedAction()
			if not inst.tzxx_light then
				inst.tzxx_light = SpawnPrefab("tz_xx_light_on")
				inst.tzxx_light.entity:SetParent(inst.entity)
				inst.tzxx_light:Turnoon()
			end

			local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if weapon ~= nil  then			
				inst.components.inventory:GiveItem(weapon)
			end
			
            inst.AnimState:PlayAnimation("dawei_pre")
			inst.components.health:SetInvincible(true)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
			inst._hungerxxtask = inst:DoPeriodicTask(1, function()
				inst.components.hunger:DoDelta(-2, nil, true)
			end)
			if inst.components.tz_xx_ling then
				inst.lingxxdamage = inst.components.tz_xx_ling:DespawnAllPets()
			end
        end,

        timeline =
        {
            TimeEvent(0.4, function(inst) --生成法阵
				if not inst.daweifx then
					inst.daweifx = SpawnPrefab("tz_xx_fazhen")
					inst.daweifx.Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst.daweifx.owner = inst
				end
            end),
            TimeEvent(0.8, function(inst) --生成法阵
				if not inst.tz_xx_light then
					inst.tz_xx_light = SpawnPrefab("tz_xx_light")
					inst.tz_xx_light.entity:SetParent(inst.entity)
				end
            end),
        },
        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					inst.sg.statemem._tzxxhunger = true 
                    inst.sg:GoToState("tz_xx_loop")
                end
            end),
        },
        onexit = function(inst)
			inst.components.health:SetInvincible(false)
            if not inst.sg.statemem._tzxxhunger then
				if inst._hungerxxtask then
					inst._hungerxxtask:Cancel()
					inst._hungerxxtask = nil
				end	
				if inst.tz_xx_light then
					inst.tz_xx_light:Remove()
					inst.tz_xx_light = nil
				end	
            end
        end,
    }
)

local function FindMyWalkableOffset(position, start_angle, radius, attempts, check_los, ignore_walls, customcheckfn, allow_water, allow_boats)
    return FindValidPositionByFan(start_angle, radius, attempts,
        function(offset)
            local x = position.x + offset.x
            local y = position.y + offset.y
            local z = position.z + offset.z
			return TheWorld.Pathfinder:IsClear(
                            position.x, position.y, position.z,
                            x, y, z)
					and #TheSim:FindEntities(x, 0, z, 4, nil,nil,{"tz_xx_fuzhou","tz_xx_flash"}) <= 0 --这个点周围没有这个标签
        end)
end

local function OnLight(inst)
	local pos = inst:GetPosition()
	local range = math.random(11)
	local offset = FindMyWalkableOffset(pos,math.random() * 2 * PI, math.random(11), 64)
	
	if offset ~= nil then
		pos.x = pos.x + offset.x
		pos.z = pos.z + offset.z
	else
		pos.x = pos.x + math.random(0,22) - 11
		pos.z = pos.z + math.random(0,22) - 11
	end
	
	local fuzhou = SpawnPrefab("tz_xx_fuzhou")
	fuzhou.Transform:SetPosition(pos.x,0,pos.z)
	fuzhou:ListenForEvent("animover", function(fuzhou)
		local shandian = SpawnPrefab("tz_xx_flash")--"tz_xx_flash"
		shandian.Transform:SetPosition(pos.x,0,pos.z)
		shandian.owner = inst
	end)
end

local function ShowLight(inst,radius)
    local pt = Vector3(inst.Transform:GetWorldPosition())
	pt.y = 0
    local theta = math.random() * 2 * PI
    local radius = radius
    local circ = 2*PI*radius
    local numitems = 8
    for i = 1, numitems do
        local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
        local wander_point = pt + offset
		local fuzhou = SpawnPrefab("tz_xx_fuzhou")
		fuzhou.Transform:SetPosition(wander_point.x,0,wander_point.z)
		fuzhou:ListenForEvent("animover", function(fuzhou)
			local shandian = SpawnPrefab("tz_xx_flash")
			shandian.Transform:SetPosition(wander_point.x,0,wander_point.z)
			shandian.owner = inst
		end)
        theta = theta - (2 * PI / numitems)
    end
end

AddStategraphState("wilson",
    State{
        name = "tz_xx_loop",
        tags = { "notalking", "busy", "nodangle","tzxx"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("dawei_loop",true)
			inst.components.health:SetInvincible(true)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
			--开启打雷
			local basemultiplier = inst.components.combat.damagemultiplier or 1
			local externaldamage = inst.components.combat.externaldamagemultipliers:Get()
			inst.addxxdamagemultiplier = basemultiplier*externaldamage
			inst._lightbiubiutask = inst:DoPeriodicTask(0.3, OnLight)
        end,

        timeline =
        {
            TimeEvent(9.5, function(inst)
                --停止任务
				if inst._lightbiubiutask then
					inst._lightbiubiutask:Cancel()
					inst._lightbiubiutask = nil
				end
				ShowLight(inst,3)
            end),
            TimeEvent(9.7, function(inst)
                ShowLight(inst,6)
            end),			
            TimeEvent(9.9, function(inst)
                ShowLight(inst,9)
            end),	
            TimeEvent(10.1, function(inst)
                ShowLight(inst,12)
            end),	
            TimeEvent(10.3, function(inst)
                ShowLight(inst,15)
            end),				
            TimeEvent(11, function(inst)
				inst.sg.statemem._tzxxhunger = true
                inst.sg:GoToState("tz_xx_pst")
            end),
        },
        events =
        {
            EventHandler("tzxx_stop", function(inst)
                inst.sg:GoToState("tz_xx_pst")
            end),
        },
        onexit = function(inst)
			inst.components.health:SetInvincible(false)
			--取消所有的任务
			if inst._lightbiubiutask then
				inst._lightbiubiutask:Cancel()
				inst._lightbiubiutask = nil
			end
            if not inst.sg.statemem._tzxxhunger then
				if inst._hungerxxtask then
					inst._hungerxxtask:Cancel()
					inst._hungerxxtask = nil
				end	
            end
        end,
    }
)
AddStategraphState("wilson",
    State{
        name = "tz_xx_pst",
        tags = { "notalking", "busy", "nodangle","tzxx"},

        onenter = function(inst)
			inst.components.health:SetInvincible(true)
            inst.AnimState:PlayAnimation("dawei_pst")
			if inst.tzxx_light then
				inst.tzxx_light:Turnoff()
				inst.tzxx_light:ListenForEvent("onremove", function()
					if inst.tz_xx_light then
						inst.tz_xx_light:Remove()
						inst.tz_xx_light = nil
					end					
				end)
				inst.tzxx_light = nil
			end			
        end,

        timeline =
        {
        },
        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
        onexit = function(inst)
			if inst.daweifx then
				inst.daweifx:Kill()
			end
			if inst.components.talker ~= nil then
				inst.components.talker:StopIgnoringAll("tzxx")
			end
			inst:DoTaskInTime(2, function() 
				inst.components.health:SetInvincible(false)
			end)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
			if inst._hungerxxtask then
				inst._hungerxxtask:Cancel()
				inst._hungerxxtask = nil
			end	
		end,
    }
)

local TZ_XX_MNQ = GLOBAL.Action({ priority=1}) 
TZ_XX_MNQ.id = "TZ_XX_MNQ"

TZ_XX_MNQ.str = "开启修仙"

TZ_XX_MNQ.fn = function(act)
    if act.doer ~= nil then
        if act.doer.components.tz_xx ~= nil then
            local xx = act.doer.components.tz_xx:StartXiuXian()
			if xx then
				act.invobject:Remove()
				return xx
			else
				return false,"NOXX"
			end
        end
    end
end

AddAction(TZ_XX_MNQ)

AddComponentAction("INVENTORY", "tzxx_mnq" , function(inst, doer, actions)
    if  doer:HasTag("taizhen") then
        table.insert(actions, ACTIONS.TZ_XX_MNQ)
    end
end)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(TZ_XX_MNQ, "dolongaction"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(TZ_XX_MNQ, "dolongaction"))

AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	inst:AddComponent("tz_saveinfo")
end)

AddShardModRPCHandler( "tz_saveinfo", "tz_saveinfo", function(worldid,value)
    if value and type(value) == "string" then
        local tz_saveinfo = TheWorld and TheWorld.components.tz_saveinfo or nil
        if tz_saveinfo and  tz_saveinfo.AddPlayerInfo ~= nil then
            local success, b = pcall(json.decode,value)
            if success and b ~= nil then
                for k, v in pairs(b) do
                    tz_saveinfo:AddPlayerInfo(k, v)
                end
            end
        end
    end
end)