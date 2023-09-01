GLOBAL.setmetatable(env,{__index = function(t, k)return GLOBAL.rawget(GLOBAL, k) end})

local tzsamabadge = require("widgets/tzsamabadge")
local tzfhbm_ui = require("widgets/tzfhbm_ui")
--添加太真sama
AddClassPostConstruct("widgets/statusdisplays", function(self)
    if self.owner and self.owner:HasTag("taizhen") then
        self.tzsamabadge = self:AddChild(tzsamabadge(self.owner))
        self.tzfhbm_ui = self:AddChild(tzfhbm_ui(self.owner))
        self.owner:DoTaskInTime(0.5,function()
			local x1, y1, z1 = self.stomach:GetPosition():Get()
			local x2, y2, z2 = self.brain:GetPosition():Get()
			local x3, y3, z3 = self.heart:GetPosition():Get()
			if y2 == y1 or y2 == y3 then
				self.tzsamabadge:SetPosition(self.stomach:GetPosition() + Vector3(x1 - x2, 0, 0))
                self.tzfhbm_ui:SetPosition(self.stomach:GetPosition() + Vector3(x1 - x2, -85, 0))
				self.boatmeter:SetPosition(self.moisturemeter:GetPosition() + Vector3(x1 - x2, 0, 0))
			else
				self.tzsamabadge:SetPosition(self.stomach:GetPosition() + Vector3(x1 - x3, 0, 0))
                self.tzfhbm_ui:SetPosition(self.stomach:GetPosition() + Vector3(x1 - x3, -85, 0))
			end
			local s1 = self.stomach:GetScale().x
			local s2 = self.boatmeter:GetScale().x
			local s3 = self.tzsamabadge:GetScale().x

			if s1 ~= s2 then
				self.boatmeter:SetScale(s1 / s2, s1 / s2, s1 / s2) --修改船的耐久值大小
			end
		end)
        local old_SetGhostMode = self.SetGhostMode --死亡/复活 隐藏/显示
        function self:SetGhostMode(ghostmode, ...)
            old_SetGhostMode(self, ghostmode, ...)
            if ghostmode then
                if self.tzsamabadge ~= nil then
                    self.tzsamabadge:Hide()
                end
            else
                if self.tzsamabadge ~= nil then
                    self.tzsamabadge:Show()
                end
            end
        end
    end
end)

--添加太真fn
AddClassPostConstruct("widgets/healthbadge", function(self)
    if self.owner ~= nil then
        self.tzfh = self.underNumber:AddChild(Image("images/inventoryimages/tz_fuhuo.xml", "tz_fuhuo.tex"))
        self.tzfh:SetPosition(-24, 20, 0)
        self.tzfh:SetScale(0.95, 0.95, 0.95)
        self.tzfh:Hide()
        if self.owner.apingfuhuo ~= nil and self.owner.apingfuhuo:value() == true then
            self.tzfh:Show()
        end
        self.inst:ListenForEvent("apingfuhuodrity",function(...)
			if self.owner.apingfuhuo:value() == true then
				self.tzfh:Show()
			else
				self.tzfh:Hide()
			end
		end,
		self.owner)
    end
end)

local tz_pillui = require("widgets/tz_pillui")
local tz_skillui = require("widgets/tz_skillui")
--添加太真pillui
AddClassPostConstruct("widgets/inventorybar", function(self)
    local y = MAXITEMSLOTS > 20 and 80 or 0
    if self.owner then
        self.tz_pillui = self:AddChild(tz_pillui(self.owner))
        self.tz_pillui:SetPosition(265, 125 + y, 0) --坐标
        self.tz_pillui:SetScale(1.5, 1.5, 1.5) --大小
        self.tz_pillui:MoveToBack()
    end

    if self.owner:HasTag("taizhen") then
        self.tz_skillui = self:AddChild(tz_skillui(self.owner))
        self.tz_skillui:SetPosition(-600, 0 + y, 0) --坐标
        self.tz_skillui:SetScale(1, 1, 1) --大小
        self.tz_skillui:MoveToBack()
    end
end)

--eat
local FOODTYPE = GLOBAL.FOODTYPE
FOODTYPE.NIGHTMAREFUEL = "NIGHTMAREFUEL"

AddPrefabPostInit("nightmarefuel",function(inst)
	if TheWorld.ismastersim then
		inst:AddComponent("edible")
		inst.components.edible.foodtype = "NIGHTMAREFUEL"
		inst.components.edible.healthvalue = 0
		inst.components.edible.hungervalue = 0
		inst.components.edible.sanityvalue = 15
	end
end)

local once = false
AddComponentPostInit("health",function(self)
	self.tz_bighealth = 0
	self.basemaxhealth = 100
	self.SetTzMaxHealth = function(self, value)
		self.tz_bighealth = value
	end
	if once then
		return
	end
	once = true
	local c = GLOBAL.getmetatable(self)
	local c_newindex = c.__newindex
	c.__newindex = function(tb, k, v)
		if k == "maxhealth" then
			c_newindex(tb, "basemaxhealth", v)
			c_newindex(tb, "maxhealth", v + (GLOBAL.rawget(tb, "tz_bighealth") or 0))
		else
			c_newindex(tb, k, v)
		end
	end
end)
local MATERIALS = GLOBAL.MATERIALS
MATERIALS.TRANSISTOR = "transistor"
AddPrefabPostInit("transistor",function(inst)
	if TheWorld.ismastersim then
		inst:AddComponent("repairer")
		inst.components.repairer.repairmaterial = MATERIALS.TRANSISTOR
		inst.components.repairer.perishrepairpercent = .1
	end
end)

AddComponentPostInit("eater",function(self)
	self.SetCanEatNightmarefuel = function()
		table.insert(self.preferseating, "NIGHTMAREFUEL")
		table.insert(self.caneat, "NIGHTMAREFUEL")
		self.inst:AddTag("NIGHTMAREFUEL_eater")
	end
end)
local PlayerController = require("components/playercontroller")
local old_HasAOETargeting = PlayerController.HasAOETargeting
function PlayerController:HasAOETargeting()
    if self.inst.replica.inventory:GetActiveItem() == nil then
        return old_HasAOETargeting(self)
    end
    return false
end

local CHANGEHUNGER = GLOBAL.Action({priority = -1, rmb = true, mount_valid = false})
CHANGEHUNGER.id = "CHANGEHUNGER"
CHANGEHUNGER.str = STRINGS.XIAOGUSHIFA
CHANGEHUNGER.fn = function(act)
    if
        act.doer ~= nil and act.invobject ~= nil and act.invobject.components.hungermaker ~= nil and
            act.doer:HasTag("player")
     then
        act.invobject.components.hungermaker:MakeHunger(act.doer)
        return true
    end
end
AddAction(CHANGEHUNGER)

AddComponentAction("EQUIPPED","hungermaker",function(inst, doer, target, actions, right)
	if
		right and doer and doer:HasTag("player") and doer:HasTag("taizhen") and target:HasTag("taizhen") and
			doer ~= target
	 then
		table.insert(actions, GLOBAL.ACTIONS.CHANGEHUNGER)
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.CHANGEHUNGER, "castspell"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.CHANGEHUNGER, "castspell"))

--balloon
local PANGBAIXIONG = GLOBAL.Action({mount_valid = true})
PANGBAIXIONG.id = "PANGBAIXIONG"
PANGBAIXIONG.str = STRINGS.PANGBAIXIONGCHUI
PANGBAIXIONG.fn = function(act)
    if
        act.doer ~= nil and act.invobject ~= nil and act.invobject.components.qiqiuballoonmaker ~= nil and
            act.doer:HasTag("player")
     then
        if act.doer.components.hunger ~= nil then
            if act.doer.components.hunger.current < 10 then
                return false
            end
            act.doer.components.hunger:DoDelta(-10)
        end
        local x, y, z = act.doer.Transform:GetWorldPosition()
        local angle = act.doer.Transform:GetRotation()
        local angle_offset = GLOBAL.GetRandomMinMax(-10, 10)
        angle_offset = angle_offset + (angle_offset < 0 and -65 or 65)
        angle = (angle + angle_offset) * GLOBAL.DEGREES
        act.invobject.components.qiqiuballoonmaker:MakeBalloon(
            x + .5 * math.cos(angle),
            0,
            z - .5 * math.sin(angle),
            act.doer
        )
        return true
    end
end
AddAction(PANGBAIXIONG)

AddComponentAction("INVENTORY","qiqiuballoonmaker",function(inst, doer, actions)
	if doer and doer:HasTag("player") then
		table.insert(actions, GLOBAL.ACTIONS.PANGBAIXIONG)
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PANGBAIXIONG, "makeballoon"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PANGBAIXIONG, "makeballoon"))

-----pack
local TZPACK = GLOBAL.Action({priority = 5})
TZPACK.id = "TZPACK"
TZPACK.str = STRINGS.TZPACK
local function canshrink(target)
    if target then
        return not target.components.combat or target.components.combat.defaultdamage == 0
    end
end

TZPACK.fn = function(act)
    local target = act.target
    local invobject = act.invobject
    local doer = act.doer
    if target ~= nil then
        local targetpos = target:GetPosition()
        if target:HasTag("structure") or target:HasTag("hostile") or target.components.growable then
            local package = GLOBAL.SpawnPrefab("tz_packbox_buildfull")
            if package then
                package.components.tzpacker:SetCanPackFn(canshrink)
                if package.components.tzpacker:Pack(target) then
                    package.Transform:SetPosition(targetpos:Get())
                    invobject:Remove()
                    if doer and doer.SoundEmitter then
                        doer.SoundEmitter:PlaySound("dontstarve/common/staff_dissassemble")
                    end
                else
                    package:Remove()
                end
            end
        else
            local package = GLOBAL.SpawnPrefab("tz_packbox_full")
            if package then
                package.components.tzpacker:SetCanPackFn(canshrink)
                if package.components.tzpacker:Pack(target) then
                    package.Transform:SetPosition(targetpos:Get())
                    invobject:Remove()
                    if doer and doer.SoundEmitter then
                        doer.SoundEmitter:PlaySound("dontstarve/common/staff_dissassemble")
                    end
                else
                    package:Remove()
                end
            end
        end
        return true
    end
end

AddAction(TZPACK)
AddComponentAction("USEITEM","tz_packbox",function(inst, doer, target, actions)
	if inst:HasTag("tz_packbox") and not target:HasTag("player") and not target:HasTag("teleportato") and
		not target:HasTag("companion") and
		not target:HasTag("character") then
		table.insert(actions, GLOBAL.ACTIONS.TZPACK)
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZPACK, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZPACK, "dolongaction"))
-----远古钥匙
local TZ_YEXINGCHA = GLOBAL.Action()
TZ_YEXINGCHA.id = "TZ_YEXINGCHA"
TZ_YEXINGCHA.str = STRINGS.TZ_YEXINGCHA
TZ_YEXINGCHA.fn = function(act)
    if act.target ~= nil and act.invobject ~= nil and act.target.components.tz_yexinglvl ~= nil then
        act.target.components.tz_yexinglvl:DoDelta(-100)
        act.target.components.tz_yexinglvl:Chazuo(act.invobject)
        if act.target.SoundEmitter then
            act.target.SoundEmitter:PlaySound("dontstarve/common/destroy_tool")
        end
        return true
    end
end
AddAction(TZ_YEXINGCHA)
AddComponentAction("USEITEM","atrium_key_tz",function(inst, doer, target, actions)
	if target:HasTag("yexing") and target._lvl:value() == 100 and not target:HasTag("INLIMBO") then
		table.insert(actions, ACTIONS.TZ_YEXINGCHA)
	end
end)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(ACTIONS.TZ_YEXINGCHA, "dolongaction"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(ACTIONS.TZ_YEXINGCHA, "dolongaction"))
--unpack
local TZUNPACK = GLOBAL.Action({rmb = true, priority = 2})
TZUNPACK.id = "TZUNPACK"
TZUNPACK.str = STRINGS.TZUNPACK
TZUNPACK.fn = function(act)
    local target = act.target or act.invobject
    local doer = act.doer
    if target ~= nil and target.components.tzpacker ~= nil then
        local x, y, z = target.Transform:GetWorldPosition()
        target.components.tzpacker:Unpack(x, y, z)
        target:Remove()
        if doer and doer.components.inventory then
            local tz_packbox = GLOBAL.SpawnPrefab("tz_packbox")
            doer.components.inventory:GiveItem(tz_packbox)
        end
        return true
    end
end

AddAction(TZUNPACK)
AddComponentAction("SCENE","tzpacker",function(inst, doer, actions, right)
	if right and inst:HasTag("tz_packbox_full") then
		table.insert(actions, GLOBAL.ACTIONS.TZUNPACK)
	end
end)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZUNPACK, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZUNPACK, "dolongaction"))
--
local TZICESWORD = GLOBAL.Action({mount_valid = true, encumbered_valid = true})
TZICESWORD.id = "TZICESWORD"
TZICESWORD.str = STRINGS.TZICESWORD
TZICESWORD.fn = function(act)
    local inv = act.invobject
    local tar = act.target
    if inv.prefab == "ice" then
        if tar.components.finiteuses then
            tar.components.finiteuses:Use(-40)
            if tar.components.finiteuses:GetPercent() > 1 then
                tar.components.finiteuses:SetPercent(1)
            end
        end
        if inv.components.stackable then
            inv.components.stackable:Get(1):Remove()
        end
        return true
    elseif inv.prefab == "transistor" then
        if tar.components.fueled then
            tar.components.fueled:DoDelta(720)
            if tar.components.fueled:GetPercent() > 1 then
                tar.components.fueled:SetPercent(1)
            end
        end
        if inv.components.stackable then
            inv.components.stackable:Get(1):Remove()
        end
        return true
    end
end
AddAction(TZICESWORD)
AddComponentAction("USEITEM","inventoryitem",function(inst, doer, target, actions, right)
	if right and inst.prefab == "ice" and target:HasTag("tz_icesword") then
		table.insert(actions, GLOBAL.ACTIONS.TZICESWORD)
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZICESWORD, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZICESWORD, "dolongaction"))

---
local TZ_GIVENEW = GLOBAL.Action({mount_valid = true, priority = 10})
TZ_GIVENEW.id = "TZ_GIVENEW"
TZ_GIVENEW.strfn = function(act)
    if act.target and act.target:HasTag("tzlostday") then
        return "GIVE"
    elseif act.target and act.target:HasTag("tz_pugalisk_crystal") then
        return "QIEHE"
    end
    return "EAT"
end
TZ_GIVENEW.fn = function(act)
    local inv = act.invobject
    local tar = act.target
    if inv and tar and tar:HasTag("tzlostday") then
        if tar.components.trader and tar.components.trader:AbleToAccept(inv, act.doer) then
            tar.components.trader:AcceptGift(act.doer, inv)
        end
        return true
    elseif inv and inv:HasTag("tz_fanhao") and tar and tar:HasTag("tz_fanhao") and tar.components.tz_fh_level then
        tar.components.tz_fh_level:GiveItem(inv,act.doer)
        return true
    elseif inv and tar and tar.components.tz_giveitem then
        return tar.components.tz_giveitem:GiveItem(inv,act.doer)
    end
end
AddAction(TZ_GIVENEW)
AddComponentAction("USEITEM","equippable",function(inst, doer, target, actions, right)
    if target and (target:HasTag("tzlostday") or (inst:HasTag("tz_fanhao") and target:HasTag("tz_fanhao"))) then
        table.insert(actions, GLOBAL.ACTIONS.TZ_GIVENEW)
    end
end)
AddComponentAction("USEITEM","tz_giveitem",function(inst, doer, target, actions, right)
    if inst.tz_giveitemfn ~= nil and inst.tz_giveitemfn(inst,target,doer) then
        table.insert(actions, GLOBAL.ACTIONS.TZ_GIVENEW)
    end
end)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZ_GIVENEW, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZ_GIVENEW, "give"))
STRINGS.ACTIONS.TZ_GIVENEW = {
    GIVE = "给予",
    EAT = "祭祀",
    QIEHE = "嵌合",
}

local TZTNTER = GLOBAL.Action({mount_valid = true})
TZTNTER.id = "TZTNTER"
TZTNTER.str = STRINGS.TZTNTER
TZTNTER.fn = function(act)
    local inv = act.invobject
    local doer = act.doer
    local doergetpos = doer:GetPosition()
    if doer ~= nil and doer.components.burnable and not doer.components.burnable:IsBurning() then
        local explode_small = GLOBAL.SpawnPrefab("explode_small")
        if explode_small then
            explode_small.Transform:SetPosition(doergetpos:Get())
        end
        if doer.components.combat ~= nil and doer.components.combat:CanBeAttacked() then
            doer.components.combat:GetAttacked(inst, 5, nil, "tz_cannedtnt")
        end
        if doer.components.burnable ~= nil then
            doer.components.burnable.burntime = 30
            doer.components.burnable:Ignite(nil, inst)
            doer:DoTaskInTime(
                1,
                function()
                    doer.components.burnable.burntime = TUNING.PLAYER_BURN_TIME
                end
            )
        end
        if doer.onburning ~= true then
            if math.random() < 0.01 then
                doer.onburning = true
                doer.components.health.fire_damage_scale = 0
                doer.components.talker:Say("运气爆棚，获得了永久免疫火焰伤害效果")
            end
        end
        if inv.components.stackable then
            inv.components.stackable:Get(1):Remove()
        end
        return true
    end
end
AddAction(TZTNTER)

AddComponentAction("INVENTORY","inventoryitem",function(inst, doer, actions)
	if inst:HasTag("tztnt") and doer and doer:HasTag("player") then
		table.insert(actions, GLOBAL.ACTIONS.TZTNTER)
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZTNTER, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZTNTER, "dolongaction"))

--提神布偶
local TZBUOU = GLOBAL.Action({mount_valid = true})
TZBUOU.id = "TZBUOU"
TZBUOU.str = "使用"
TZBUOU.fn = function(act)
    local inv = act.invobject
    local doer = act.doer
    if inv ~= nil then
        if doer.apingfuhuo ~= nil then
            doer.apingfuhuo:set(true)
        end
        inv:Remove()
        return true
    end
end
AddAction(TZBUOU)

AddComponentAction("INVENTORY","tz_doubles",function(inst, doer, actions, right)
	if doer:HasTag("player") then
		table.insert(actions, ACTIONS.TZBUOU)
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZBUOU, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZBUOU, "dolongaction"))

local function onburning(inst)
    if inst.onburning then
        inst.components.health.fire_damage_scale = 0
    end
end

local function onpreload(inst, data)
    if data then
        if inst.old_onpreload ~= nil then
            inst.old_onpreload(inst, data)
        end
        inst.onburning = data.onburning or false
        inst.burningcd = data.burningcd or false
        inst.apingfuhuoa = data.apingfuhuoa or false
    end
    onburning(inst)
end

local function OnLoad(inst, data)
    if data then
        if inst.old_onload ~= nil then
            inst.old_onload(inst, data)
            if inst.apingfuhuoa then
                inst.apingfuhuo:set(true)
                inst:DoTaskInTime(0.1,function()
					if inst:HasTag("playerghost") then
						inst:PushEvent("respawnfromghost", {source = nil})
					end
				end)
            end
        end
    end
end

local function onsave(inst, data)
    if inst.old_Save ~= nil then
        inst.old_Save(inst, data)
    end
    data.onburning = inst.onburning
    data.burningcd = inst.burningcd
    data.apingfuhuoa = inst.apingfuhuo:value() == true and true or false
end

AddPlayerPostInit(function(inst)
	if inst.prefab ~= nil then --不等于nil可以支持所有人物，应该是可省略，nil换成mod人物可屏蔽
		inst.onburning = false
		inst.burningcd = false
		inst.old_Save = inst.OnSave
		inst.old_onpreload = inst.OnPreLoad
		inst.old_onload = inst.OnLoad
		inst.OnSave = onsave
		inst.OnPreLoad = onpreload
		inst.OnLoad = OnLoad
	end
end)

AddPrefabPostInit("beequeen",function(inst)
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("tz_whitewing", 0.33)
	end
end)
AddPrefabPostInit("dragonfly",function(inst)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("tz_jrby", 0.33)
    end
end)
-------blink
AddStategraphState("wilson",
    State {
        name = "tzblink",
        tags = {"doing", "busy", "canrotate"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("lunge_pre")
            inst.AnimState:OverrideSymbol("fx_lunge_streak", "hhhh", "hhhh")
        end,
        timeline = {
            TimeEvent(
                10 * FRAMES,
                function(inst)
                    inst.AnimState:ClearOverrideSymbol("fx_lunge_streak")
                    inst:PerformBufferedAction()
                end
            )
        },
        events = {
            EventHandler(
                "animqueueover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end
            )
        }
    }
)
AddStategraphState("wilson_client",
    State {
        name = "tzblink",
        tags = {"doing", "busy", "canrotate"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("lunge_pre")
            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(2)
        end,
        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,
        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end
    }
)
local TZBLINK = GLOBAL.Action({priority = 10, rmb = true, distance = 28, mount_valid = false})
TZBLINK.id = "TZBLINK"
TZBLINK.str = STRINGS.TZBLINK
TZBLINK.fn = function(act)
    local act_pos = act:GetActionPoint()
    if act.invobject and act.invobject.components.tzblink and act_pos then
        act.invobject.components.tzblink:Blink(act_pos, act.doer, act.invobject)
        return true
    end
end
AddAction(TZBLINK)
AddComponentAction("POINT","tzblink",function(inst, doer, pos, actions, right)
    local x,y,z = pos:Get()
	if right and inst:HasTag("tzblinkcd") and (TheWorld.Map:IsAboveGroundAtPoint(x,y,z) or TheWorld.Map:GetPlatformAtPoint(x,z) ~= nil) and
		not TheWorld.Map:IsGroundTargetBlocked(pos) then
		table.insert(actions, ACTIONS.TZBLINK)
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZBLINK, "tzblink"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZBLINK, "tzblink"))

local TZREAD = Action({mount_valid = true, priority = 2})
TZREAD.id = "TZREAD"
TZREAD.str = STRINGS.TZREAD
TZREAD.fn = function(act)
    local targ = act.target or act.invobject
    if targ ~= nil and act.doer ~= nil and targ.components.tzbook ~= nil then
        return targ.components.tzbook:OnRead(act.doer)
    end
end
AddAction(TZREAD)
AddComponentAction("INVENTORY","tzbook",function(inst, doer, actions)
	if doer:HasTag("taizhen") then
		table.insert(actions, ACTIONS.TZREAD)
	end
end)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZREAD, "book"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZREAD, "book"))
---打开和关闭
local TZTURNON = Action({priority = 2})
local TZTURNOFF = Action({priority = 2})
TZTURNON.id = "TZTURNON"
TZTURNOFF.id = "TZTURNOFF"
TZTURNON.str = STRINGS.TZTURNON
TZTURNOFF.str = STRINGS.TZTURNOFF
TZTURNON.fn = function(act)
    local tar = act.target or act.invobject
    if tar and tar.components.tzmachine and not tar.components.tzmachine:IsOn() then
        tar.components.tzmachine:TurnOn(tar)
        return true
    end
end

TZTURNOFF.fn = function(act)
    local tar = act.target or act.invobject
    if tar and tar.components.tzmachine and tar.components.tzmachine:IsOn() then
        tar.components.tzmachine:TurnOff(tar)
        return true
    end
end
AddAction(TZTURNON)
AddAction(TZTURNOFF)
AddComponentAction("SCENE","tzmachine",function(inst, doer, actions, right)
	if
		right and not inst:HasTag("cooldown") and not inst:HasTag("fueldepleted") and
			not (inst.replica.equippable ~= nil and not inst.replica.equippable:IsEquipped() and
				inst.replica.inventoryitem ~= nil and
				inst.replica.inventoryitem:IsHeld()) and
			not inst:HasTag("alwayson") and
			not inst:HasTag("emergency")
	 then
		table.insert(actions, inst:HasTag("turnedon") and ACTIONS.TZTURNOFF or ACTIONS.TZTURNON)
	end
end)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZTURNOFF, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZTURNOFF, "give"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZTURNON, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZTURNON, "give"))
---==========
local TZCASTAOE = Action({priority = -1, rmb = true, distance = 6, mount_valid = false, instant = false})
TZCASTAOE.id = "TZCASTAOE"
TZCASTAOE.str = STRINGS.TZCASTAOE
TZCASTAOE.fn = function(act)
    local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    local act_pos = act:GetActionPoint()
    if staff and staff.components.tz_hyspell and staff.components.tz_hyspell:CanCast(act.doer, act.target, act_pos) then
        staff.components.tz_hyspell:CastSpell(act.doer, act.target, act_pos)
        return true
    end
end
AddAction(TZCASTAOE)
AddComponentAction("POINT","tz_hyspell",function(inst, doer, pos, actions, right)
	if right and inst:HasTag("tzcccd") and TheWorld.Map:IsAboveGroundAtPoint(pos:Get()) and
		not TheWorld.Map:IsGroundTargetBlocked(pos) then
		table.insert(actions, ACTIONS.TZCASTAOE)
	end
end)
AddComponentAction("EQUIPPED","tz_hyspell",function(inst, doer, target, actions, right)
	if right and inst:HasTag("tzcccd") and target:HasTag("_health") and not target:HasTag("player") then
		table.insert(actions, ACTIONS.TZCASTAOE)
	end
end)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZCASTAOE, "dotfaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZCASTAOE, "dotfaction"))
--===============================================
local tz_cosplay = GLOBAL.State {
    name = "tz_cosplay",
    tags = {"busy", "pausepredict", "nomorph", "nodangle"},
    onenter = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(false)
            inst.components.playercontroller:Enable(false)
        end
        inst.AnimState:OverrideSymbol("shadow_hands", "shadow_skinchangefx", "shadow_hands")
        inst.AnimState:OverrideSymbol("shadow_ball", "shadow_skinchangefx", "shadow_ball")
        inst.AnimState:OverrideSymbol("splode", "shadow_skinchangefx", "splode")
        inst.AnimState:PlayAnimation("skin_change")
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:RemotePausePrediction()
        end
        inst:ShowHUD(false)
        inst:SetCameraDistance(14)
    end,
    timeline = {
        GLOBAL.TimeEvent(
            42 * GLOBAL.FRAMES,
            function(inst)
            end
        )
    },
    events = {
        GLOBAL.EventHandler(
            "animover",
            function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end
        )
    },
    onexit = function(inst)
        inst.AnimState:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")
        inst:ShowHUD(true)
        inst:SetCameraDistance()
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(true)
            inst.components.playercontroller:Enable(true)
        end
        inst.components.inventory:Show()
        inst:ShowActions(true)
        if not inst.sg.statemem.isclosingwardrobe then
            inst.sg.statemem.isclosingwardrobe = true
            inst:PushEvent("ms_closewardrobe")
        end
    end
}

local tz_cosplay_a = GLOBAL.State {
    name = "tz_cosplay_a",
    tags = {"busy", "pausepredict", "nomorph", "nodangle", "tz_bianshen"},
    onenter = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(false)
            inst.components.playercontroller:Enable(false)
            inst.components.playercontroller:RemotePausePrediction()
        end
        inst.components.health:SetInvincible(true)
        inst.AnimState:OverrideSymbol("shadow_hands", "shadow_skinchangefx", "shadow_hands")
        inst.AnimState:OverrideSymbol("shadow_ball", "shadow_skinchangefx", "shadow_ball")
        inst.AnimState:OverrideSymbol("splode", "shadow_skinchangefx", "splode")
        inst.AnimState:PlayAnimation("skin_change")
        inst:ShowHUD(false)
        inst:SetCameraDistance(14)
        if inst.components.tzsama ~= nil then
            inst.components.tzsama:Pause()
        end
    end,
    timeline = {
        GLOBAL.TimeEvent(
            1.5,
            function(inst)
                inst._bianshen:set(false)
            end
        )
    },
    events = {
        GLOBAL.EventHandler(
            "animover",
            function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end
        )
    },
    onexit = function(inst)
        inst.AnimState:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")
        inst:ShowHUD(true)
        inst:SetCameraDistance()
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(true)
            inst.components.playercontroller:Enable(true)
        end
        if inst.components.tzsama ~= nil then
            inst.components.tzsama:Resume()
        end
        inst.components.inventory:Show()
        inst:ShowActions(true)
        inst.components.health:SetInvincible(false)
        if not inst.sg.statemem.isclosingwardrobe then
            inst.sg.statemem.isclosingwardrobe = true
            inst:PushEvent("ms_closewardrobe")
        end
    end
}

local function tingwode(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, 24, {"player"}, {"playerghost", "INLIMBO"})) do
        if v and v:IsValid() and v.apingbianshen ~= nil and v ~= inst then
            v.apingbianshen:set_local(0)
            v.apingbianshen:set(2)
        end
    end
end

local tz_bianshen_meishaonv = GLOBAL.State {
    name = "tz_bianshen_meishaonv",
    tags = {"busy", "pausepredict", "nomorph", "nodangle", "tz_bianshen"},
    onenter = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:RemotePausePrediction()
            inst.components.playercontroller:EnableMapControls(false)
            inst.components.playercontroller:Enable(false)
        end
        inst.components.health:SetInvincible(true)
        inst.Physics:Stop()
        inst.AnimState:PlayAnimation("bianshen_pre")
        inst.AnimState:PushAnimation("bianshen_loop", false)
        inst.AnimState:PushAnimation("bianshen_pst", false)
        inst.apingbianshen:set_local(0)
        inst.apingbianshen:set(1)
        tingwode(inst)
        if inst.components.tzsama ~= nil then
            inst.components.tzsama:Pause()
        end
        --inst:ShowHUD(false)
        inst:SetCameraDistance(14)
    end,
    timeline = {
        GLOBAL.TimeEvent(
            0.613,
            function(inst)
                inst._bianshen:set(true)
            end
        ),
        GLOBAL.TimeEvent(
            1.9,
            function(inst)
                inst.SoundEmitter:PlaySound("tz_bianshen_sound/a/b")
            end
        )
    },
    events = {
        GLOBAL.EventHandler(
            "animqueueover",
            function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end
        )
    },
    onexit = function(inst)
        --inst:ShowHUD(true)
        inst:SetCameraDistance()
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(true)
            inst.components.playercontroller:Enable(true)
        end
        if inst.components.tzsama ~= nil then
            inst.components.tzsama:Resume()
        end
        inst.components.health:SetInvincible(false)
        --inst.components.inventory:Show()
        --inst:ShowActions(true)
    end
}
AddStategraphState("wilson", tz_cosplay)
AddStategraphState("wilson", tz_cosplay_a)
AddStategraphState("wilson", tz_bianshen_meishaonv)
--AddStategraphState("wilson_client", tz_cosplay)

local TZCOSPLAY = GLOBAL.Action()
TZCOSPLAY.id = "TZCOSPLAY"
TZCOSPLAY.str = STRINGS.TZCOSPLAY
local TZCOSPLAYBLUE = GLOBAL.Action()
TZCOSPLAYBLUE.id = "TZCOSPLAYBLUE"
TZCOSPLAYBLUE.str = STRINGS.TZCOSPLAY
local TZCOSPLAYYELLOW = GLOBAL.Action()
TZCOSPLAYYELLOW.id = "TZCOSPLAYYELLOW"
TZCOSPLAYYELLOW.str = STRINGS.TZCOSPLAY
local TZCOSPLAYBLACK = GLOBAL.Action()
TZCOSPLAYBLACK.id = "TZCOSPLAYBLACK"
TZCOSPLAYBLACK.str = STRINGS.TZCOSPLAY

local TZCOSPLAYPINK = GLOBAL.Action()
TZCOSPLAYPINK.id = "TZCOSPLAYPINK"
TZCOSPLAYPINK.str = STRINGS.TZCOSPLAY

TZCOSPLAYBLUE.fn = function(act)
    local inv = act.invobject
    local doer = act.doer
    if doer ~= nil then
        if doer.components.playercontroller ~= nil then
            doer.components.playercontroller:EnableMapControls(false)
            doer.components.playercontroller:Enable(false)
            doer.sg:GoToState("tz_cosplay")
            doer:DoTaskInTime(
                1.5,
                function()
                    doer.AnimState:SetBuild("taizhen_blue")
                    doer:AddTag("taizhen_blue")
                    doer:RemoveTag("taizhen_pink")
                    doer:RemoveTag("taizhen_black")
                    if doer.components.temperature and doer:HasTag("taizhen") then --保暖效果只有太真有效
                        doer.components.temperature.inherentinsulation = 0
                        doer.components.temperature.inherentsummerinsulation = 60
                        doer._yellow = false
                        doer._blue = true
                        doer._black = false
                        doer._yellowpro = false
                        doer._pink = false
                    end
                    if doer:HasTag("taizhen_yellow") then
                        doer:RemoveTag("taizhen_yellow")
                        doer.AnimState:ClearOverrideSymbol("swap_body")
                        doer.AnimState:ClearOverrideSymbol("backpack")
                        local current = doer.components.inventory:Unequip(EQUIPSLOTS.HEAD)
                        if current ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(current)
                        end
                        local body = doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
                        if body ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(body)
                        end
                    end
                    if doer:HasTag("taizhen_yellowpro") then
                        doer:RemoveTag("taizhen_yellowpro")
                        doer.AnimState:Show("backpack")
                        local current = doer.components.inventory:Unequip(EQUIPSLOTS.HEAD)
                        if current ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(current)
                        end
                        local body = doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
                        if body ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(body)
                        end
                    end
                end
            )
        end
        return true
    end
end
TZCOSPLAYYELLOW.fn = function(act)
    local inv = act.invobject
    local doer = act.doer
    if doer ~= nil then
        if doer.components.playercontroller ~= nil then
            doer.components.playercontroller:EnableMapControls(false)
            doer.components.playercontroller:Enable(false)
            doer.sg:GoToState("tz_cosplay")
            if doer.components.temperature and doer:HasTag("taizhen") then
                doer.components.temperature.inherentinsulation = 60
                doer.components.temperature.inherentsummerinsulation = 0
                doer._blue = false
                doer._yellow = true
                doer._black = false
                doer._yellowpro = false
                doer._pink = false
            end
            doer:DoTaskInTime(
                1.5,
                function()
                    doer.AnimState:SetBuild("taizhen_yellow")
                    doer.AnimState:OverrideSymbol("backpack", "swap_tzwings", "backpack")
                    doer.AnimState:OverrideSymbol("swap_body", "swap_tzwings", "swap_body")
                    doer.AnimState:ClearOverrideSymbol("swap_hat")
                    doer.AnimState:Show("hair")
                    doer:AddTag("taizhen_yellow")
                    doer:RemoveTag("taizhen_blue")
                    doer:RemoveTag("taizhen_black")
                    doer:RemoveTag("taizhen_pink")

                    if doer:HasTag("taizhen_yellowpro") then
                        doer:RemoveTag("taizhen_yellowpro")
                        doer.AnimState:Show("backpack")
                        local current = doer.components.inventory:Unequip(EQUIPSLOTS.HEAD)
                        if current ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(current)
                        end
                        local body = doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
                        if body ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(body)
                        end
                    end
                end
            )
        end
        return true
    end
end

TZCOSPLAYBLACK.fn = function(act)
    local inv = act.invobject
    local doer = act.doer
    if doer ~= nil then
        if doer.components.playercontroller ~= nil then
            doer.components.playercontroller:EnableMapControls(false)
            doer.components.playercontroller:Enable(false)
            doer.sg:GoToState("tz_cosplay")
            if doer.components.temperature and doer:HasTag("taizhen") then
                doer.components.temperature.inherentinsulation = 0
                doer.components.temperature.inherentsummerinsulation = 0
                doer._blue = false
                doer._yellow = false
                doer._black = true
                doer._yellowpro = false
                doer._pink = false
            end
            doer:DoTaskInTime(
                1.5,
                function()
                    doer.AnimState:SetBuild("taizhen_black")
                    doer:AddTag("taizhen_black")
                    doer:RemoveTag("taizhen_blue")
                    doer:RemoveTag("taizhen_pink")

                    if doer:HasTag("taizhen_yellow") then
                        doer:RemoveTag("taizhen_yellow")
                        doer.AnimState:ClearOverrideSymbol("swap_body")
                        doer.AnimState:ClearOverrideSymbol("backpack")
                        local current = doer.components.inventory:Unequip(EQUIPSLOTS.HEAD)
                        if current ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(current)
                        end
                        local body = doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
                        if body ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(body)
                        end
                    end

                    if doer:HasTag("taizhen_yellowpro") then
                        doer:RemoveTag("taizhen_yellowpro")
                        doer.AnimState:Show("backpack")
                        local current = doer.components.inventory:Unequip(EQUIPSLOTS.HEAD)
                        if current ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(current)
                        end
                        local body = doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
                        if body ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(body)
                        end
                    end
                end
            )
        end
        return true
    end
end
TZCOSPLAY.fn = function(act)
    local inv = act.invobject
    local doer = act.doer
    if doer ~= nil then
        if doer.components.playercontroller ~= nil then
            doer.components.playercontroller:EnableMapControls(false)
            doer.components.playercontroller:Enable(false)
            doer.sg:GoToState("tz_cosplay")
            doer:DoTaskInTime(
                1.5,
                function()
                    local normal_skin = act.doer.prefab

                    local skin_name = doer.components.skinner.skin_name
                    if skin_name ~= nil and skin_name ~= "" then
                        local skin_prefab = Prefabs[skin_name] or nil
                        if skin_prefab and skin_prefab.skins and skin_prefab.skins.normal_skin ~= nil then
                            normal_skin = skin_prefab.skins.normal_skin
                        end
                    end
                    doer.AnimState:SetBuild(normal_skin)

                    if doer.components.temperature and doer:HasTag("taizhen") then
                        doer.components.temperature.inherentinsulation = 0
                        doer.components.temperature.inherentsummerinsulation = 0
                        doer._blue = false
                        doer._yellow = false
                        doer._black = false
                        doer._yellowpro = false
                        doer._pink = false
                    end
                    doer:RemoveTag("taizhen_blue")
                    doer:RemoveTag("taizhen_black")
                    doer:RemoveTag("taizhen_pink")
                    if doer:HasTag("taizhen_yellow") then
                        doer:RemoveTag("taizhen_yellow")
                        doer.AnimState:ClearOverrideSymbol("swap_body")
                        doer.AnimState:ClearOverrideSymbol("backpack")
                        doer.AnimState:Show("hair")
                        local current = doer.components.inventory:Unequip(EQUIPSLOTS.HEAD)
                        if current ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(current)
                        end
                        local body = doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
                        if body ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(body)
                        end
                    end
                    if doer:HasTag("taizhen_yellowpro") then
                        doer:RemoveTag("taizhen_yellowpro")
                        doer.AnimState:Show("backpack")
                        local current = doer.components.inventory:Unequip(EQUIPSLOTS.HEAD)
                        if current ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(current)
                        end
                        local body = doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
                        if body ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(body)
                        end
                    end
                end
            )
        end
        return true
    end
end

AddAction(TZCOSPLAY)
AddAction(TZCOSPLAYBLUE)
AddAction(TZCOSPLAYYELLOW)
AddAction(TZCOSPLAYBLACK)

--change 2019-05-16
--饿龙 pro
local TZCOSPLAYYELLOWPRO = GLOBAL.Action()
TZCOSPLAYYELLOWPRO.id = "TZCOSPLAYYELLOWPRO"
TZCOSPLAYYELLOWPRO.str = STRINGS.TZCOSPLAY
TZCOSPLAYYELLOWPRO.fn = function(act)
    local inv = act.invobject
    local doer = act.doer
    if doer ~= nil then
        if doer.components.playercontroller ~= nil then
            doer.components.playercontroller:EnableMapControls(false)
            doer.components.playercontroller:Enable(false)
            doer.sg:GoToState("tz_cosplay")
            if doer.components.temperature and doer:HasTag("taizhen") then
                doer.components.temperature.inherentinsulation = 0
                doer.components.temperature.inherentsummerinsulation = 0
                doer._blue = false
                doer._yellow = false
                doer._black = false
                doer._yellowpro = true
                doer._pink = false
            end
            doer:DoTaskInTime(
                1.5,
                function()
                    doer.AnimState:SetBuild("taizhen_yellowpro")
                    doer:AddTag("taizhen_yellowpro")
                    doer:RemoveTag("taizhen_blue")
                    doer:RemoveTag("taizhen_black")
                    if doer:HasTag("taizhen_yellow") then
                        doer:RemoveTag("taizhen_yellow")
                        doer.AnimState:ClearOverrideSymbol("swap_body")
                        doer.AnimState:ClearOverrideSymbol("backpack")
                        local current = doer.components.inventory:Unequip(EQUIPSLOTS.HEAD)
                        if current ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(current)
                        end
                        local body = doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
                        if body ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(body)
                        end
                    end
                end
            )
        end
        return true
    end
end
AddAction(TZCOSPLAYYELLOWPRO)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZCOSPLAYYELLOWPRO, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZCOSPLAYYELLOWPRO, "dolongaction"))

TZCOSPLAYPINK.fn = function(act)
    local inv = act.invobject
    local doer = act.doer
    if doer ~= nil then
        if doer.components.playercontroller ~= nil then
            doer.components.playercontroller:EnableMapControls(false)
            doer.components.playercontroller:Enable(false)
            doer.sg:GoToState("tz_cosplay")
            if doer.components.temperature and doer:HasTag("taizhen") then
                doer._blue = false
                doer._yellow = false
                doer._black = false
                doer._yellowpro = false
                doer._pink = true
            end
            doer:DoTaskInTime(
                1.5,
                function()
                    doer.AnimState:SetBuild("taizhen_pink")
                    doer:AddTag("taizhen_pink")
                    doer:RemoveTag("taizhen_blue")
                    doer:RemoveTag("taizhen_black")
                    if doer:HasTag("taizhen_yellow") then
                        doer:RemoveTag("taizhen_yellow")
                        doer.AnimState:ClearOverrideSymbol("swap_body")
                        doer.AnimState:ClearOverrideSymbol("backpack")
                        local current = doer.components.inventory:Unequip(EQUIPSLOTS.HEAD)
                        if current ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(current)
                        end
                        local body = doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
                        if body ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(body)
                        end
                    end
                    if doer:HasTag("taizhen_yellowpro") then
                        doer:RemoveTag("taizhen_yellowpro")
                        doer.AnimState:Show("backpack")
                        local current = doer.components.inventory:Unequip(EQUIPSLOTS.HEAD)
                        if current ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(current)
                        end
                        local body = doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
                        if body ~= nil and doer.components.inventory then
                            doer.components.inventory:Equip(body)
                        end
                    end
                end
            )
        end
        return true
    end
end
AddAction(TZCOSPLAYYELLOWPRO)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZCOSPLAYYELLOWPRO, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZCOSPLAYYELLOWPRO, "dolongaction"))
--盛宴-饿龙

STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.TZCOSPLAYENCHA = {
    AAAAA = "终极升级前还需要更多的燃料"
}

local TZCOSPLAYENCHA = GLOBAL.Action()
TZCOSPLAYENCHA.id = "TZCOSPLAYENCHA"
TZCOSPLAYENCHA.str = STRINGS.TZCOSPLAY
TZCOSPLAYENCHA.fn = function(act)
    local inv = act.invobject
    local doer = act.doer
    local target = act.target
    if doer ~= nil and target ~= nil then
        if doer.components.playercontroller ~= nil then
            if target.prefab == "tz_yexingzhe" then
                if target.components.tz_yexinglvl and target.components.tz_yexinglvl.current == 100 then
                    doer:DoTaskInTime(
                        0.1,
                        function()
                            local new = SpawnPrefab("tz_yexingzhe_purple")
                            if new then
                                new.components.fueled:SetPercent(target.components.fueled:GetPercent())
                                doer.components.inventory:GiveItem(new)
                                target:Remove()
                                inv:Remove()
                            end
                        end
                    )
                else
                    return false, "AAAAA"
                end
            else
                doer:DoTaskInTime(
                    0.1,
                    function()
                        local new =
                            SpawnPrefab(target.prefab == "tz_enchanter" and "tz_enchanter_yellow" or "tz_yezhao_pink")
                        if new then
                            new.components.fueled:SetPercent(target.components.fueled:GetPercent())
                            doer.components.inventory:GiveItem(new)
                            target:Remove()
                            inv:Remove()
                        end
                    end
                )
            end
        end
        return true
    end
end
AddAction(TZCOSPLAYENCHA)
AddAction(TZCOSPLAYPINK)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZCOSPLAYENCHA, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZCOSPLAYENCHA, "dolongaction"))
AddComponentAction("USEITEM","tzcoplay",function(inst, doer, target, actions, right)
	if inst:HasTag("taizhen_cosplayyellow") and target:HasTag("tz_enchanter") and not target:HasTag("tz_yellow") then
		table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAYENCHA)
	elseif inst:HasTag("taizhen_cosplaypink") and target:HasTag("tz_yezhao") and not target:HasTag("tz_yezhao_pink") then
		table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAYENCHA)
	elseif
		inst:HasTag("taizhen_cosplaypurple") and target:HasTag("tz_yexing") and
			not target:HasTag("tz_yexing_purple")
	 then
		table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAYENCHA)
	end
end)

AddComponentAction("INVENTORY","tzcoplay",function(inst, doer, actions)
	if not doer:HasTag("taizhen") or not (doer._bianshen ~= nil and doer._bianshen:value() == true) then --变身状态无法使用是装备包
		if inst:HasTag("taizhen_cosplayblue") and doer:HasTag("player") and not doer:HasTag("taizhen_blue") then
			table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAYBLUE)
		elseif inst:HasTag("taizhen_cosplayyellow") and doer:HasTag("player") and not doer:HasTag("taizhen_yellow") then
			table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAYYELLOW)
		elseif inst:HasTag("taizhen_cosplayblack") and doer:HasTag("player") and not doer:HasTag("taizhen_black") then
			table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAYBLACK)
		elseif inst:HasTag("taizhen_cosplaypink") and doer:HasTag("player") and not doer:HasTag("taizhen_pink") then
			--change 2019-05-16
			--饿龙pro
			table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAYPINK)
		elseif
			inst:HasTag("taizhen_cosplayyellowpro") and doer:HasTag("player") and
				not doer:HasTag("taizhen_yellowpro")
		 then
			table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAYYELLOWPRO)
		elseif inst:HasTag("taizhen_cosplayyellowpro") and doer:HasTag("taizhen_yellowpro") then
			--change
			table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAY)
		elseif inst:HasTag("taizhen_cosplaypink") and doer:HasTag("taizhen_pink") then
			table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAY)
		elseif inst:HasTag("taizhen_cosplayblue") and doer:HasTag("taizhen_blue") then
			table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAY)
		elseif inst:HasTag("taizhen_cosplayyellow") and doer:HasTag("taizhen_yellow") then
			table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAY)
		elseif inst:HasTag("taizhen_cosplayblack") and doer:HasTag("taizhen_black") then
			table.insert(actions, GLOBAL.ACTIONS.TZCOSPLAY)
		end
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZCOSPLAYBLUE, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZCOSPLAYBLUE, "dolongaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZCOSPLAYYELLOW, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZCOSPLAYYELLOW, "dolongaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZCOSPLAYBLACK, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZCOSPLAYBLACK, "dolongaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZCOSPLAY, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZCOSPLAY, "dolongaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TZCOSPLAYPINK, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TZCOSPLAYPINK, "dolongaction"))
local function maoziya(inst)
    inst.apingpipa = net_tinybyte(inst.GUID, "apingpipa", "apingpipadrity")
    inst.apingbianshen = net_tinybyte(inst.GUID, "apingbianshen", "apingbianshendrity")
    inst.apingfuhuo = net_bool(inst.GUID, "apingfuhuo", "apingfuhuodrity")
    inst.apingbighealthtime = net_ushortint(inst.GUID, "apingbighealthtime", "apingbighealthtimedrity")

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("tz_bighealth")
    inst:AddComponent("tz_wzk_hd")
    inst:ListenForEvent(
        "equip",
        function()
            if inst:HasTag("taizhen_yellow") then
                inst.AnimState:OverrideSymbol("backpack", "swap_tzwings", "backpack")
                inst.AnimState:OverrideSymbol("swap_body", "swap_tzwings", "swap_body")
                inst.AnimState:ClearOverrideSymbol("swap_hat")
                inst.AnimState:Show("hair")
            end
        end
    )
end
AddPlayerPostInit(maoziya)

local apingpipa = GLOBAL.require("widgets/apingpipa")
local apingpipa1 = GLOBAL.require("widgets/apingpipa1")
AddClassPostConstruct("widgets/controls",function(self)
	if self.owner and self.owner:HasTag("player") then
		self.apingpipa = self:AddChild(apingpipa(self.owner))
		self.apingpipa:SetHAnchor(1)
		self.apingpipa:SetVAnchor(2)
		self.apingpipa:SetScale(0.7) --大小
		self.apingpipa:SetPosition(0, 0, 0) --坐标 xy
		self.apingpipa:MoveToFront()

		self.apingpipa1 = self:AddChild(apingpipa1(self.owner))
		self.apingpipa1:SetHAnchor(2)
		self.apingpipa1:SetVAnchor(2)
		self.apingpipa1:SetScale(0.7) --大小
		self.apingpipa1:SetPosition(0, 0, 0) --坐标 xy
		self.apingpipa1:MoveToFront()
	end
end)

--food
local tz_waferchocolate = {
    name = "tz_waferchocolate",
    test = function(cooker, names, tags)
        return names.bird_egg and (names.corn or names.corn_cooked) and names.honey and not tags.meat and not names.ice and
            not names.twigs
    end,
    priority = 50,
    weight = 1,
    foodtype = FOODTYPE.VEGGIE,
    health = 10,
    hunger = 10,
    perishtime = TUNING.PERISH_FASTISH,
    sanity = 10,
    cooktime = 1.5,
    tags = {"catfood"}
}
local tz_icecream = {
    name = "tz_icecream",
    test = function(cooker, names, tags)
        return names.ice and tags.veggie and names.honey and tags.fruit
    end,
    priority = 50,
    weight = 1,
    foodtype = FOODTYPE.VEGGIE,
    health = 10,
    hunger = 30,
    perishtime = 2 * TUNING.PERISH_TWO_DAY,
    sanity = 30,
    cooktime = 1.5,
    tags = {"catfood"}
}
AddCookerRecipe("cookpot", tz_waferchocolate)
AddCookerRecipe("cookpot", tz_icecream)
RegisterInventoryItemAtlas("images/inventoryimages/tz_waferchocolate.xml", "tz_waferchocolate.tex")
RegisterInventoryItemAtlas("images/inventoryimages/tz_icecream.xml", "tz_icecream.tex")
--change 2019-05-18
local function ForceStopHeavyLifting(inst)
    if inst.components.inventory:IsHeavyLifting() then
        inst.components.inventory:DropItem(inst.components.inventory:Unequip(EQUIPSLOTS.BODY), true, true)
    end
end
local function IsNearDanger(inst)
    local hounded = GLOBAL.TheWorld.components.hounded
    if hounded ~= nil and (hounded:GetWarning() or hounded:GetAttacking()) then
        return true
    end
    local burnable = inst.components.burnable
    if burnable ~= nil and (burnable:IsBurning() or burnable:IsSmoldering()) then
        return true
    end
    -- See entityreplica.lua (for _combat tag usage)
    local nospiderdanger = inst:HasTag("spiderwhisperer") or inst:HasTag("spiderdisguise")
    local nopigdanger = not inst:HasTag("monster")
    --Danger if:
    -- being targetted
    -- OR near monster that is not player
    -- ignore shadow monsters when not insane
    return GLOBAL.FindEntity(
        inst,
        10,
        function(target)
            return (target.components.combat ~= nil and target.components.combat.target == inst) or
                ((target:HasTag("monster") or (not nopigdanger and target:HasTag("pig"))) and
                    not target:HasTag("player") and
                    not (nospiderdanger and target:HasTag("spider")) and
                    not (inst.components.sanity:IsSane() and target:HasTag("shadowcreature")))
        end,
        nil,
        nil,
        nopigdanger and {"monster", "_combat"} or {"monster", "pig", "_combat"}
    ) ~= nil
end
local function SetSleeperSleepState(inst)
    if inst.components.grue ~= nil then
        inst.components.grue:AddImmunity("sleeping")
    elseif inst.components.talker ~= nil then
        inst.components.talker:IgnoreAll("sleeping")
    elseif inst.components.firebug ~= nil then
        inst.components.firebug:Disable()
    elseif inst.components.playercontroller ~= nil then
        inst.components.playercontroller:EnableMapControls(false)
        inst.components.playercontroller:Enable(false)
    end
    inst:OnSleepIn()
    inst.components.inventory:Hide()
    inst:PushEvent("ms_closepopups")
    inst:ShowActions(false)
end
local function SetSleeperAwakeState(inst)
    if inst.components.grue ~= nil then
        inst.components.grue:RemoveImmunity("sleeping")
    elseif inst.components.talker ~= nil then
        inst.components.talker:StopIgnoringAll("sleeping")
    elseif inst.components.firebug ~= nil then
        inst.components.firebug:Enable()
    elseif inst.components.playercontroller ~= nil then
        inst.components.playercontroller:EnableMapControls(true)
        inst.components.playercontroller:Enable(true)
    end
    inst:OnWakeUp()
    inst.components.inventory:Show()
    inst:ShowActions(true)
end

local tz_sleep = GLOBAL.State {
    name = "tz_sleep",
    tags = {"bedroll", "busy", "nomorph"},
    onenter = function(inst, data)
        ForceStopHeavyLifting(inst)
        inst.components.locomotor:Stop()
        local failreason =
            (IsNearDanger(inst) and "ANNOUNCE_NODANGERSLEEP") or
            -- you can still sleep if your hunger will bottom out, but not absolutely
            (inst.components.hunger.current < TUNING.CALORIES_MED and "ANNOUNCE_NOHUNGERSLEEP") or
            (inst.components.beaverness ~= nil and inst.components.beaverness:IsStarving() and "ANNOUNCE_NOHUNGERSLEEP") or
            nil
        -- if inst.components.playercontroller ~= nil then
        -- inst.components.playercontroller:RemotePausePrediction()
        -- end
        if failreason ~= nil then
            inst:PushEvent("performaction", {action = inst.bufferedaction})
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
            if inst.components.talker ~= nil then
                inst.components.talker:Say(GetString(inst, failreason))
            end
            return
        end
        if inst.tzsleeptask then
            inst.tzsleeptask:Cancel()
            inst.tzsleeptask = nil
        end
        inst.tzsleeptask =
            inst:DoPeriodicTask(
            1,
            function(inst)
                local isstarving
                if inst.components.hunger ~= nil then
                    inst.components.hunger:DoDelta(-0.5, true, true)
                    isstarving = inst.components.hunger:IsStarving()
                end
                if inst.components.sanity ~= nil and inst.components.sanity:GetPercentWithPenalty() < 1 then
                    inst.components.sanity:DoDelta(1, true)
                end
                if not isstarving and inst.components.health ~= nil then
                    inst.components.health:DoDelta(1, true, "bedroll", true)
                end
                if isstarving then
                    inst.sg:GoToState("wakeup")
                end
            end
        )
        inst.AnimState:OverrideSymbol("swap_bedroll", "swap_bedroll_furry", "bedroll_furry")
        inst.AnimState:PlayAnimation("yawn")
        inst.components.talker:Say("睡觉觉~~")
        inst.AnimState:PushAnimation("bedroll", false)
        SetSleeperSleepState(inst)
    end,
    timeline = {
        TimeEvent(
            60 * FRAMES,
            function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
            end
        )
    },
    events = {
        EventHandler(
            "firedamage",
            function(inst)
                if inst.sg:HasStateTag("sleeping") then
                    inst.sg.statemem.iswaking = true
                    inst.sg:GoToState("wakeup")
                end
            end
        ),
        EventHandler(
            "animqueueover",
            function(inst)
                if inst.AnimState:AnimDone() then
                    if
                        (inst.components.health ~= nil and inst.components.health.takingfiredamage) or
                            (inst.components.burnable ~= nil and inst.components.burnable:IsBurning())
                     then
                        inst:PushEvent("performaction", {action = inst.bufferedaction})
                        inst:ClearBufferedAction()
                        inst.sg.statemem.iswaking = true
                        inst.sg:GoToState("wakeup")
                    else
                        if inst.components.playercontroller ~= nil then
                            inst.components.playercontroller:Enable(true)
                        end
                        inst.sg:AddStateTag("sleeping")
                        inst.sg:AddStateTag("silentmorph")
                        inst.sg:RemoveStateTag("nomorph")
                        inst.sg:RemoveStateTag("busy")
                        inst.AnimState:PlayAnimation("bedroll_sleep_loop", true)
                    end
                end
            end
        )
    },
    onexit = function(inst)
        if inst.tzsleeptask then
            inst.tzsleeptask:Cancel()
            inst.tzsleeptask = nil
        end
        if not inst.sg.statemem.iswaking then
            --Interrupted before we are "sleeping"
            SetSleeperAwakeState(inst)
        end
    end
}

local function ClearStatusAilments(inst)
    if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
        inst.components.freezable:Unfreeze()
    end
    if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
        inst.components.pinnable:Unstick()
    end
end
AddStategraphState("wilson", State {
    name = "tz_forcetele",
    tags = { "busy", "nopredict", "nomorph" },

    onenter = function(inst)
        ClearStatusAilments(inst)

        --inst.components.rider:ActualDismount()
        inst.components.locomotor:Stop()
        inst.components.health:SetInvincible(true)
        inst.DynamicShadow:Enable(false)
        inst:Hide()
        inst:ScreenFade(false, 2)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
    end,

    onexit = function(inst)
        inst.components.health:SetInvincible(false)
        inst.DynamicShadow:Enable(true)
        inst:Show()
        if inst.sg.statemem.teleport_task ~= nil then
            -- Still have a running teleport_task
            -- Interrupt!
            inst.sg.statemem.teleport_task:Cancel()
            inst.sg.statemem.teleport_task = nil
            inst:ScreenFade(true, .5)
        end
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
    end,
})
AddStategraphState("wilson", tz_sleep)



local function IsHUDScreen()
    local defaultscreen = false
    if
        TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name and
            type(TheFrontEnd:GetActiveScreen().name) == "string" and
            TheFrontEnd:GetActiveScreen().name == "HUD"
     then
        defaultscreen = true
    end
    return defaultscreen
end

AddModRPCHandler("tz_skill","Z",function(player)
	if player:HasTag("playerghost") or player.replica.health:IsDead() then
		return
	end

	if player.components.rider and player.components.rider:IsRiding() then
		return
	end

	if player.sg and player.sg:HasStateTag("tz_bianshen") then
		return
	end

	if player.sg and player.sg:HasStateTag("tzxx") then
		return
	end
	if not player:HasTag("taizhen_sleep") then
		player:AddTag("taizhen_sleep")
		player:DoTaskInTime(
			3,
			function(inst)
				inst:RemoveTag("taizhen_sleep")
			end
		)
		if player:HasTag("taizhen_yellowpro") and not player.sg:HasStateTag("bedroll") then
			--player.AnimState:PlayAnimation("yawn")
			player.sg:GoToState("tz_sleep")
		elseif player.sg.currentstate.name == "tz_sleep" then
			player.sg:GoToState("wakeup")
		end
	end
end)

AddModRPCHandler("tz_skill","G",function(inst)
	if inst:HasTag("playerghost") or inst.replica.health:IsDead() then
		return
	end

	if inst.components.rider and inst.components.rider:IsRiding() then
		return
	end

	if inst.sg and inst.sg:HasStateTag("tz_bianshen") then
		return
	end

	if inst.sg and inst.sg:HasStateTag("tzxx") then
		return
	end

    --print(ThePlayer._bianshen:value())

	if inst._bianshen:value() == false then
		if inst._tzsamamax:value() < 250 then
            inst.components.talker:Say("撒麻坂町最大值不足250")
			return
		elseif inst._tzsamacurrent:value() < 40 then
			inst.components.talker:Say("撒麻坂町需要得到补充")
			return
		end
		inst._blue = false
		inst._yellow = false
		inst._black = false
		inst._yellowpro = false
		inst._pink = false
		inst:RemoveTag("taizhen_pink")
		inst:RemoveTag("taizhen_blue")
		inst:RemoveTag("taizhen_black")
		if inst:HasTag("taizhen_yellow") then
			inst:RemoveTag("taizhen_yellow")
			inst.AnimState:ClearOverrideSymbol("swap_body")
			inst.AnimState:ClearOverrideSymbol("backpack")
			local current = inst.components.inventory:Unequip(EQUIPSLOTS.HEAD)
			if current ~= nil and inst.components.inventory then
				inst.components.inventory:Equip(current)
			end
			local body = inst.components.inventory:Unequip(EQUIPSLOTS.BODY)
			if body ~= nil and inst.components.inventory then
				inst.components.inventory:Equip(body)
			end
		end
		if inst:HasTag("taizhen_yellowpro") then
			inst:RemoveTag("taizhen_yellowpro")
			inst.AnimState:Show("backpack")
			local current = inst.components.inventory:Unequip(EQUIPSLOTS.HEAD)
			if current ~= nil and inst.components.inventory then
				inst.components.inventory:Equip(current)
			end
			local body = inst.components.inventory:Unequip(EQUIPSLOTS.BODY)
			if body ~= nil and inst.components.inventory then
				inst.components.inventory:Equip(body)
			end
		end
		for k, v in pairs(inst.components.inventory.equipslots) do
			if k == "hands" then
				inst.components.inventory:GiveItem(v)
			end
		end
		inst.sg:GoToState("tz_bianshen_meishaonv")
		inst.tz_xx_skill:set_local(0)
		inst.tz_xx_skill:set(1)
	elseif inst._bianshen:value() == true then
		inst.sg:GoToState("tz_cosplay_a")
	end
end)

AddModRPCHandler("tz_skill","R",function(inst)
	if inst:HasTag("playerghost") or inst.replica.health:IsDead() then
		return
	end

	if inst.components.rider and inst.components.rider:IsRiding() then
		return
	end

	if inst.sg and inst.sg:HasStateTag("tz_bianshen") then
		return
	end

	if inst.sg and inst.sg:HasStateTag("tzxx") then
		return
	end

	if inst.components.hunger.current < 50 then
		inst.components.talker:Say("肚子还没有准备好")
		return
	end
	inst.sg:GoToState("tz_xx_pre")
	inst.tz_xx_skill:set_local(0)
	inst.tz_xx_skill:set(2)
end)

local function GetTagEquip(self,tag)
    for k, v in pairs(self.equipslots) do
        if v:HasTag(tag) then
            return v
        end
    end
end
AddModRPCHandler("tz_skill","Alt",function(inst)
    if inst:HasTag("playerghost") or inst.replica.health:IsDead() then
        return
    end
    local hat = inst.components.inventory and GetTagEquip(inst.components.inventory,"tz_fh_ml") or nil 
    if hat and hat.Use_Skill then
        hat:Use_Skill(inst)
    end
end)

AddModRPCHandler("tz_skill","j",function(inst,valve,valve1,valve2)
    if inst:HasTag("playerghost") or inst.replica.health:IsDead() then
        return
    end
    if checkstring(valve) then
        if valve == "ht" and checknumber(valve1) and checknumber(valve2) then
            local weapon = inst.components.inventory and GetTagEquip(inst.components.inventory,"tz_fh_ht_map") or nil 
            if weapon and weapon.Use_Map_Skill then
                weapon:Use_Map_Skill(inst,valve1,valve2)
            end
        end
    else
        local weapon = inst.components.inventory and GetTagEquip(inst.components.inventory,"tz_fhbm") or nil 
        if weapon and weapon.Use_Time_Skill then
            weapon:Use_Time_Skill(inst)
        end
    end
end)

AddModRPCHandler("tz_skill","f2",function(inst)
    if inst:HasTag("playerghost") or inst.replica.health:IsDead() then
        return
    end
    if inst.components.tz_xin_pets then
        inst.components.tz_xin_pets:JinJIn()
    end
end)

AddComponentPostInit("wardrobe",function(self)
	local old_ApplySkins = self.ApplySkins
	function self:ApplySkins(doer, diff)
		old_ApplySkins(self, doer, diff)
		if doer and doer.prefab == "taizhen" and doer._bianshen ~= nil and doer._bianshen:value() == true then
			doer.AnimState:SetBuild("taizhen_avatar")
		end
	end
end)

ACTIONS.EQUIP.fn = function(act)
    if act.doer:HasTag("tzsfing") then
        return nil
    end
    if act.doer.components.inventory ~= nil then
        return act.doer.components.inventory:Equip(act.invobject)
    end
end

local sqtz_sf = GLOBAL.State {
    name = "tz_sf",
    tags = {"doing", "busy"},
    onenter = function(inst, data)
        inst.rightClicked = false
        inst.components.locomotor:Stop()
        inst:AddTag("tzsfing")
        inst:AddTag("tzsfing2")
        inst.AnimState:PlayAnimation("loop_pre", false)
        inst.AnimState:PushAnimation("loop", true)
        if inst.tzsftask ~= nil then
            inst.tzsftask:Cancel()
            inst.tzsftask = nil
        end
        inst.SoundEmitter:PlaySound("shadow_buff/untitled/shadow_buff", "shadow_buff", nil, true)
        for k, v in pairs(inst.components.tzpetshadow.pets) do
            if v.buff and not v.buff:IsValid() then
                v.buff:Remove()
                v.buff = nil
            end
            if not v.buff then
                v.buff = GLOBAL.SpawnPrefab("tz_shadow_buff")
                v.buff.entity:SetParent(v.entity)
                -- v.buff.entity:AddFollower()
                v.buff.Transform:SetPosition(0, 4, 0)
                -- buff后的伤害
                v.components.combat:SetDefaultDamage(v.components.combat.defaultdamage + 50)
                -- buff后的移速
                v.components.locomotor.walkspeed = v.components.locomotor.walkspeed + 3
            end
        end
        local fh = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        -- 施法时降精神
        fh.components.equippable.dapperness = -TUNING.SANITYAURA_LARGE / 10
    end,
    timeline = {
        TimeEvent(
            7 * FRAMES,
            function(inst)
                inst.sg:RemoveStateTag("busy")
            end
        ),
        TimeEvent(
            9 * FRAMES,
            function(inst)
                inst:PerformBufferedAction()
            end
        )
    },
    events = {
        EventHandler(
            "firedamage",
            function(inst)
                inst.sg:GoToState("idle")
            end
        ),
        EventHandler(
            "animqueueover",
            function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end
        ),
        EventHandler(
            "unequip",
            function(inst, data)
                if data and data.eslot == EQUIPSLOTS.HANDS then
                    inst.sqtz_sf_olditem = data.item
                    inst.sg:GoToState("idle")
                end
            end
        )
    },
    onexit = function(inst)
        local fh = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or inst.sqtz_sf_olditem
        inst.sqtz_sf_olditem = nil
        fh.components.rechargeable:StartRecharge()
        fh.components.equippable.dapperness = 0
        inst:DoTaskInTime(
            0,
            function()
                inst.SoundEmitter:KillSound("shadow_buff")
                inst:RemoveTag("tzsfing")
                for k, v in pairs(inst.components.tzpetshadow.pets) do
                    if v.buff then
                        v.buff:Remove()
                        v.buff = nil
                        v.components.combat:SetDefaultDamage(v.components.combat.defaultdamage - 50)
                        v.components.locomotor.walkspeed = v.components.locomotor.walkspeed - 3
                    end
                end
            end
        )
        inst:RemoveTag("tzsfing2")
        if inst.tzsftask ~= nil then
            inst.tzsftask:Cancel()
            inst.tzsftask = nil
        end
    end
}

local sqtz_sf_client = GLOBAL.State {
    name = "tz_sf",
    tags = {"doing", "busy", "nodangle"},
    onenter = function(inst, data)
        inst.AnimState:PlayAnimation("loop_pre", false)
        inst.AnimState:PushAnimation("loop", true)
        inst.SoundEmitter:PlaySound("shadow_buff/untitled/shadow_buff", "shadow_buff", nil, true)
    end,
    timeline = {
        TimeEvent(
            7 * FRAMES,
            function(inst)
                inst.sg:RemoveStateTag("busy")
            end
        )
    },
    events = {
        EventHandler(
            "firedamage",
            function(inst)
                inst.sg:GoToState("idle")
            end
        ),
        EventHandler(
            "animqueueover",
            function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end
        )
    },
    onexit = function(inst)
        inst.SoundEmitter:KillSound("shadow_buff")
    end
}

AddStategraphState("wilson", sqtz_sf)
AddStategraphState("wilson_client", sqtz_sf_client)

AddStategraphPostInit("wilson",function(sg)
	local old_CASTAOE = sg.actionhandlers[ACTIONS.CASTAOE].deststate
	sg.actionhandlers[ACTIONS.CASTAOE].deststate = function(inst, action)
		local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if weapon then
			if weapon:HasTag("tz_enchanter") then
				return "tz_sf"
			end
		end
		return old_CASTAOE(inst, action)
	end
end)

AddStategraphPostInit("wilson_client",function(sg)
	local old_CASTAOE = sg.actionhandlers[ACTIONS.CASTAOE].deststate
	sg.actionhandlers[ACTIONS.CASTAOE].deststate = function(inst, action)
		local weapon = inst.replica.combat:GetWeapon()
		if weapon then
			if weapon:HasTag("tz_enchanter") then
				return "tz_sf"
			end
		end
		return old_CASTAOE(inst, action)
	end
end)

-- Mod RPC ------------------------------
AddModRPCHandler("TZ","Travel",function(player, inst, index)
	local a = inst and type(inst) == "table" and inst.GUID and inst.components.taizhen_teleport
	if a ~= nil then
		a:Travel(player, index)
	end
end)

-- PlayerHud UI -------------------------
local TZTeleScreen = require "screens/tztelescreen"

AddClassPostConstruct("screens/playerhud",function(self, anim, owner)
	self.ShowTZTeleScreen = function(_, attach)
		if attach then
			if self.controls and self.controls.containerroot then
				self.TZTeleScreen = self.controls.containerroot:AddChild(TZTeleScreen(self.owner, attach))
				--self:OpenScreenUnderPause(self.TZTeleScreen)
				return self.TZTeleScreen
			end
		end
	end

	self.CloseTZTeleScreen = function(_)
		if self.TZTeleScreen then
			self.TZTeleScreen:Close()
			self.TZTeleScreen = nil
		end
	end
end)

-- Actions ------------------------------

local TZ_TELRPORT = AddAction("TZ_TELRPORT","打开时空漩涡",function(act)
	local target = act.target or act.invobject
	if act.doer and target and act.doer:HasTag("player") and target.components.taizhen_teleport and
		not target:HasTag("burnt") and
		not target:HasTag("fire") then
		target.components.taizhen_teleport:BeginTravel(act.doer)
		return true
	end
end)
TZ_TELRPORT.mount_valid = true

-- Component actions ---------------------

AddComponentAction("SCENE","taizhen_teleport",function(inst, doer, actions, right)
	if right and not doer:HasTag("playerghost") then
		if not inst:HasTag("burnt") and not inst:HasTag("fire") and not inst.replica.inventoryitem then
			table.insert(actions, TZ_TELRPORT)
		end
	end
end)
AddComponentAction("INVENTORY","taizhen_teleport",function(inst, doer, actions, right)
	--if doer and doer.sg and doer.sg.currentstate.name == "idle" then
	table.insert(actions, TZ_TELRPORT)
	--end
end)
-- Stategraph ----------------------------

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(TZ_TELRPORT, "give"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(TZ_TELRPORT, "give"))

AddMinimapAtlas("images/inventoryimages/tz_teleport.xml")
AddMinimapAtlas("images/inventoryimages/tz_delivery.xml")

local function AddFog(self)
    local tz_lvjing = require "widgets/tz_lvjing"

    local old_CreateOverlays = self.CreateOverlays
    function self:CreateOverlays(owner, ...)
        old_CreateOverlays(self, owner, ...)
        if owner and owner:HasTag("taizhen") then
            self.tz_lvjing = self.overlayroot:AddChild(tz_lvjing(owner))
        end
    end
end
AddClassPostConstruct("screens/playerhud", AddFog)

----发射雪球
local TZ_ICEBALL = GLOBAL.Action({priority = 51, distance = 36})
TZ_ICEBALL.id = "TZ_ICEBALL"
TZ_ICEBALL.str = "发射雪球"
TZ_ICEBALL.fn = function(act)
    local act_pos = nil
    if act.target then
        act_pos = act.target:GetPosition()
    else
        act_pos = act:GetActionPoint()
    end
    if act_pos ~= nil and act.invobject ~= nil and act.doer ~= nil then
        if act.invobject.components.tz_iceball ~= nil then
            return act.invobject.components.tz_iceball:Throw(act.doer, act_pos)
        end
    end
end

AddAction(TZ_ICEBALL)

AddComponentAction("POINT","tz_iceball",function(inst, doer, pos, actions, right)
	if right and inst.replica.equippable and inst.replica.equippable:IsEquipped() then
		table.insert(actions, ACTIONS.TZ_ICEBALL)
	end
end)

AddComponentAction("EQUIPPED","tz_iceball",function(inst, doer, target, actions, right)
	if right then
		table.insert(actions, ACTIONS.TZ_ICEBALL)
	end
end)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(TZ_ICEBALL, "iceball_throw"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(TZ_ICEBALL, "iceball_throw"))

----填充雪球
AddPrefabPostInit("ice",function(inst)
	if TheWorld.ismastersim then
		inst:AddComponent("ice_iceball")
	end
end)
local TZ_ICEBALLREPAIR = GLOBAL.Action({mount_valid = true, encumbered_valid = true})
TZ_ICEBALLREPAIR.id = "TZ_ICEBALLREPAIR"
TZ_ICEBALLREPAIR.str = "填充"
TZ_ICEBALLREPAIR.fn = function(act)
    if act.target ~= nil and act.target.components.finiteuses ~= nil and
        act.target.components.finiteuses:GetPercent() < 1 then
        local repair_item = act.invobject
        if repair_item ~= nil then
            local total =
                math.min(act.target.components.finiteuses.current + 20, act.target.components.finiteuses.total)
            act.target.components.finiteuses:SetUses(total)
            if repair_item.components.stackable ~= nil then
                repair_item.components.stackable:Get():Remove()
            else
                repair_item:Remove()
            end
        end
        return true
    end
end
AddAction(TZ_ICEBALLREPAIR)
AddComponentAction("USEITEM","ice_iceball",function(inst, doer, target, actions, right)
	if right and target:HasTag("tz_iceball") then
		table.insert(actions, ACTIONS.TZ_ICEBALLREPAIR)
	end
end)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(TZ_ICEBALLREPAIR, "dolongaction_iceball"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(TZ_ICEBALLREPAIR, "dolongaction"))
AddStategraphState("wilson",
	State {
        name = "dolongaction_iceball",
        onenter = function(inst)
            inst.sg:GoToState("dolongaction", 4)
        end
    }
)

AddStategraphState("wilson",
    State {
        name = "iceball_throw",
        tags = {"attack", "notalking", "busy", "autopredict"},
        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("throw")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            inst.sg:SetTimeout(0.67) --0.67秒一次

            if buffaction ~= nil then
                if buffaction.pos ~= nil then
                    inst:ForceFacePoint(buffaction:GetActionPoint():Get())
                elseif buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target.Transform:GetWorldPosition())
                end
            end
        end,
        timeline = {
            TimeEvent(
                0.33,
                function(inst)
                    inst.sg.statemem.thrown = true
                    inst:PerformBufferedAction()
                end
            )
        },
        ontimeout = function(inst)
            inst.sg:RemoveStateTag("busy")
            inst.sg:AddStateTag("idle")
        end,
        events = {
            EventHandler(
                "equip",
                function(inst)
                    inst.sg:GoToState("idle")
                end
            ),
            EventHandler(
                "unequip",
                function(inst, data)
                    if data.eslot ~= EQUIPSLOTS.HANDS or not inst.sg.statemem.thrown then
                        inst.sg:GoToState("idle")
                    end
                end
            ),
            EventHandler(
                "animover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end
            )
        }
    }
)

AddStategraphState("wilson_client",
    State {
        name = "iceball_throw",
        tags = {"busy", "notalking"},
        onenter = function(inst)
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("throw")

            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()
                if buffaction.pos ~= nil then
                    inst:ForceFacePoint(buffaction:GetActionPoint():Get())
                elseif buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target.Transform:GetWorldPosition())
                end
            end
            inst.sg:SetTimeout(0.67) --0.67秒一次
        end,
        timeline = {
            TimeEvent(
                0.33,
                function(inst)
                    inst:ClearBufferedAction()
                end
            )
        },
        ontimeout = function(inst)
            inst.sg:RemoveStateTag("busy")
            inst.sg:AddStateTag("idle")
        end,
        events = {
            EventHandler(
                "animover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end
            )
        }
    }
)
AddComponentPostInit(
    "inventoryitem",
    function(InventoryItem, inst)
        local old_RemoveFromOwner = InventoryItem.RemoveFromOwner
        function InventoryItem:RemoveFromOwner(wholestack, ...)
            local owner = self.owner
            if owner and owner:HasTag("tzlostday")then
                local ret
                if owner.components.inventory ~= nil then
                    ret = owner.components.inventory:RemoveItem(self.inst, wholestack)
                end
                if owner.components.container ~= nil then
                    ret = owner.components.container:RemoveItem(self.inst, wholestack) or ret
                end
                return ret
            end
            return old_RemoveFromOwner(self, wholestack, ...)
        end
    end
)

local ex_fns = require "prefabs/player_common_extensions"
local GivePlayerStartingItems = ex_fns.GivePlayerStartingItems
ex_fns.GivePlayerStartingItems = function(inst,items,...)
    if inst and inst.prefab == "taizhen" then
        if not TheWorld.components.tz_startitem:HasPlayer(inst) then
            TheWorld.components.tz_startitem:AddPlayer(inst)
        else
            GivePlayerStartingItems(inst,{},...)
            return
        end
    end
    GivePlayerStartingItems(inst,items,...)
end

local function launchitem(inst, yoff)
    if not inst and inst:IsValid() then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    local item = SpawnPrefab("tz_coin")
    item.Transform:SetPosition(x, y+yoff, z)
    local speed = math.random() * 2 + 2
    angle = math.random(360) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end
if GetModConfigData("xunbao") then
    AddPrefabPostInit("tumbleweed", function(inst) 
        if inst.components.pickable then
            local pick_fn = inst.components.pickable.onpickedfn
            inst.components.pickable.onpickedfn = function(_inst, picker)
                if math.random() < 0.05 then
                    launchitem(inst, 1.5)
                end
                if pick_fn then
                    return pick_fn(_inst, picker)
                end
            end
        end
    end)
    AddPrefabPostInit("dirtpile", function(inst) 
        if inst.components.activatable then
            local pick_ac = inst.components.activatable.OnActivate
            inst.components.activatable.OnActivate = function(_inst, picker)
                if math.random() < 0.2 then
                    launchitem(inst, 1)
                end
                if pick_ac then
                    return pick_ac(_inst, picker)
                end
            end
        end
    end)
    local function IsValidVictim(victim)
        return victim ~= nil
            and victim.components.health ~= nil
            and (victim:HasTag("largecreature") or victim:HasTag("epic"))
    
    end
    local function ondrop(inst,data)
        if  data.inst and IsValidVictim(data.inst) then
            launchitem(data.inst, 2)
        end
    end
    AddPrefabPostInit("world",function(inst)
        inst:ListenForEvent("entity_death",ondrop)
    end)  
end
--来自晓美焰 已征得作者同意
AddPrefabPostInit("world", function(inst)
    inst:AddComponent("taizhen_time_manager")
end)
local function HookComponent(name, fn)
    fn(require ("components/"..name))
end
-- 延时任务
AddGlobalClassPostConstruct("scheduler", "Periodic", function(self)
    function self:AddTick()
        if not self.nexttick or not scheduler.attime[self.nexttick] then
            return
        end
        -- 2021.10.22 兼容staticScheduler
        if self.taizhen_isstatic then
            return
        end
        
        local thislist = scheduler.attime[self.nexttick]
        self.nexttick = self.nexttick + 1
        if not scheduler.attime[self.nexttick] then
            scheduler.attime[self.nexttick] = {}
        end
        local nextlist = scheduler.attime[self.nexttick]
        thislist[self] = nil
        nextlist[self] = true
        self.list = nextlist
    end
end)

-- 2021.10.22 兼容staticScheduler
if GLOBAL.staticScheduler ~= nil then
AddGlobalClassPostConstruct("scheduler", "staticScheduler", function(self)
    local old_ExecutePeriodic = self.ExecutePeriodic
    function self:ExecutePeriodic(period, fn, limit, initialdelay, id, ...)
        local periodic = old_ExecutePeriodic(self, period, fn, limit, initialdelay, ...)
        period.taizhen_isstatic = true
        return period
    end
end)
end

-- 状态
AddGlobalClassPostConstruct("stategraph", "StateGraphInstance", function(self)
    local old_update = self.Update
    function self:Update(...)
        local sleep_time = old_update(self, ...)
        if not sleep_time then
            self.taizhen_nextupdatetick = nil
        else
            -- 2022.1.14 fix state.onupdate() is not stopped
            if sleep_time == 0 then
                sleep_time = FRAMES
            end

            local sleep_ticks = sleep_time/GetTickTime()
            sleep_ticks = sleep_ticks == 0 and 1 or sleep_ticks
            self.taizhen_nextupdatetick = math.floor(sleep_ticks + GetTick())+1
        end

        return sleep_time
    end

    function self:AddTick(dt)
        dt = dt or GetTickTime()
        self.statestarttime = self.statestarttime + dt
        if self.taizhen_nextupdatetick then
            local thislist = SGManager.tickwaiters[self.taizhen_nextupdatetick]
            if not thislist then return end
            self.taizhen_nextupdatetick = self.taizhen_nextupdatetick + 1
            if not SGManager.tickwaiters[self.taizhen_nextupdatetick]then
                SGManager.tickwaiters[self.taizhen_nextupdatetick] = {}
            end
            local nextlist = SGManager.tickwaiters[self.taizhen_nextupdatetick]
            thislist[self] = nil
            nextlist[self] = true
        end
    end
end)

-- AI
AddGlobalClassPostConstruct("behaviourtree", "BT", function(self)
    local old_update = self.Update
    function self:Update(...)
        if self.inst:HasTag("taizhenTag_pause") then
            return
        else
            return old_update(self, ...)
        end
    end
end)

do -- 控制天气粒子
    local Precipitation = {rain = 0.2, caverain = 0.2, pollen = .0001, snow = 0.8}
    for k, v in pairs(Precipitation)do
        AddPrefabPostInit(k, function(inst)
            inst.taizhenVar_is_precipitation = true
            inst.tz_timemagic_onstart = function(inst)
                inst.VFXEffect:SetDragCoefficient(0,1)
            end
            inst.tz_timemagic_onstop = function(inst)
                inst.VFXEffect:SetDragCoefficient(0,v)
            end
        end)
    end
end

--------------------------
-- 玩家界面、本地音效 --
-------------------------------------------------------
local BEAVERVISION_COLOURCUBES =
{
    day = resolvefilepath("images/colour_cubes/tz_timecubes.tex"),
    dusk = resolvefilepath("images/colour_cubes/tz_timecubes.tex"),
    night = resolvefilepath("images/colour_cubes/tz_timecubes.tex"),
    full_moon = resolvefilepath("images/colour_cubes/tz_timecubes.tex"),
}

local AMB = require "tz_amb"
local function Pause(inst, master)
    if inst ~= ThePlayer then
        return
    end

    if inst.HUD then
        for over,child in pairs({clouds = 1,sandover = 'bg',sanddustover = 1,drops_vig = 1})do
            if inst.HUD[over] then
                if child == 1 then
                    inst.HUD[over]:GetAnimState():Pause()
                else
                    inst.HUD[over][child]:GetAnimState():Pause()
                end
            end
        end
    end
    TheWorld.SoundEmitter:SetVolume("rain", 0)
    TheWorld.SoundEmitter:SetVolume("waves", 0)
    TheWorld.SoundEmitter:SetVolume("nightmare_loop",0)

    for _,v in pairs(AMB)do
        TheWorld.SoundEmitter:KillSound(v)
    end
    if TheWorld.components.ambientsound then
        TheWorld.components.ambientsound:SetWavesEnabled(false)
    end
    TheFocalPoint.SoundEmitter:SetVolume("treerainsound", 0)
    if inst.tz_timer_pause then
        inst.tz_timer_pause:set(true)
    end
end

local function Resume(inst, master)
    if inst.HUD then
        for over,child in pairs({clouds = 1,sandover = 'bg',sanddustover = 1,drops_vig = 1})do
            if inst.HUD[over] then
                if child == 1 then
                    inst.HUD[over]:GetAnimState():Resume()
                else
                    inst.HUD[over][child]:GetAnimState():Resume()
                end
            end
        end
    end
    TheWorld.SoundEmitter:SetVolume("rain", 1)
    TheWorld.SoundEmitter:SetVolume("nightmare_loop", 1)
    if TheWorld.components.ambientsound and TheWorld.prefab ~= 'cave' and TheWorld.prefab ~= 'lavaarena' then
        TheWorld.components.ambientsound:SetWavesEnabled(true)
    end
    TheFocalPoint.SoundEmitter:SetVolume("treerainsound", 1)
    if inst.tz_timer_pause then
        inst.tz_timer_pause:set(false)
    end
end

local function onpausedirty(inst)
    if inst.components.playervision then
        if inst.tz_timer_pause:value() then
            inst.components.playervision:SetCustomCCTable(BEAVERVISION_COLOURCUBES)
        else
            inst.components.playervision:SetCustomCCTable(nil)
        end
    end
end

AddReplicableComponent("taizhen_timepauseskill")
AddPlayerPostInit(function(inst) 
    inst.tz_timer_pause = net_bool(inst.GUID, "tz.tz_timer_pause", "tz_timer_pausedirty")
    if not TheNet:IsDedicated() then
        inst:ListenForEvent("tz_timer_pausedirty", onpausedirty)
    end
    if TheWorld.ismastersim then
        inst:AddComponent("taizhen_timepauseskill")
    end
    inst:ListenForEvent("taizhen_enter_timemagic", Pause)
    inst:ListenForEvent("taizhen_exit_timemagic", Resume)
end)
--ThePlayer.components.taizhen_timepauseskill:UseSkill()
AddPrefabPostInitAny(function(inst)
    if not inst.components.tz_ignoretimemagic and not inst.Pathfinder then
        if (TheWorld and TheWorld.ismastersim) or not inst.Network then
            inst:AddComponent("tz_ignoretimemagic")
        end
    end
end)

local LoadComponent = function(path) return require("components/"..path) end

do -- 所有实例的组件更新
    local SKIP_COMPOENNTS = {
        tz_ignoretimemagic = true,
        taizhen_timepauseblast = true, -- 特效更新
        container = true,           --保证容器正常关闭
        playercontroller = true,    --动作获取
        highlight = true,           --高亮
    }
    AddGlobalClassPostConstruct("entityscript", "EntityScript", function(self)
        local old_add = self.AddComponent
        function self:AddComponent(name, ...)
            local bugtracker_ignore_flag__AddComponent = true
            old_add(self, name, ...)
            local cmp = self.components[name]
            if not SKIP_COMPOENNTS[name] and cmp.OnUpdate then 
                local old_update = cmp.OnUpdate
                local inst = self
                function cmp:OnUpdate(dt)
                    local bugtracker_ignore_flag__OnUpdate = true
                    if not inst:HasTag('taizhenTag_pause') then 
                        old_update(self, dt)
                    end
                end
            end
            return cmp
        end
    end)
end

do -- 人物的组件更新
    local COMPONENTS = {
        grue = true,
    }

    for k in pairs(COMPONENTS)do
        local self = LoadComponent(k)
        local old_update = self.OnUpdate
        self.OnUpdate = function(self, ...)
            if self.inst:HasTag("player") and not self.inst.tz_timemagic_inrange then
                old_update(self, ...)
            end
        end
    end
end


do -- 环境湿度
    local self = LoadComponent("moisture")
    local old_get = self.GetMoistureRate 
    function self:GetMoistureRate(...)
        return self.inst.tz_timemagic_inrange and 0 or old_get(self, ...)
    end
end

----------------------
--禁用船桨船帆---------
-------------------------------

do -- 禁用玩家控制
    local self = LoadComponent("playercontroller")
    local old_isenabled = self.IsEnabled
    function self:IsEnabled(...)
        if self.inst:HasTag("taizhenTag_pause") then
            return false
        else
            return old_isenabled(self, ...)
        end
    end
end

-- 偷偷刮毛 (欣愿)
AddPrefabPostInit("beefalo", function(inst)
    if inst.components.beard then
        local old_can = inst.components.beard.canshavetest
        inst.components.beard.canshavetest = function(inst, ...)
            if inst:HasTag("taizhenTag_pause") then
                return true
            else
                return old_can(inst, ...)
            end
        end
    end
end)

-- 蜘蛛巢 / 蜂巢 / 猪人房子
AddComponentPostInit("childspawner", function(self)
    local old_spawnall = self.ReleaseAllChildren
    function self:ReleaseAllChildren(...)
        if self.inst:HasTag("taizhenTag_pause") then
            if not self.taizhen_delay then
                local args = {...}
                self.taizhen_delay = self.inst:DoTaskInTime(2.5*FRAMES, function()
                    -- 延时任务被阻断，解除时停后才会执行
                    -- 为避免下一帧直接触发任务，设置为两帧
                    self.taizhen_delay = nil
                    if self.inst.components.childspawner ~= nil then
                        old_spawnall(self, unpack(args))
                    end
                end)
                return {}
            end
        else
            return old_spawnall(self, ...)
        end
    end

    local old_spawn = self.SpawnChild
    function self:SpawnChild(...)
        if self.inst:HasTag("taizhenTag_pause") then
            return nil
        else
            return old_spawn(self, ...)
        end
    end
end)

local function DontShowInTimeMagic(inst)
    if ThePlayer and ThePlayer.tz_timemagic_inrange then
        inst:Hide()
    end
end

for _,v in pairs{"raindrop","wave_shimmer","wave_shimmer_med",
"wave_shimmer_deep","wave_shimmer_flood","wave_shore","impact","shatter",}do 
    AddPrefabPostInit(v, DontShowInTimeMagic) 
end

local function SetImmune(inst)
    inst:AddTag("taizhenTag_ignoretimemagic")
end

for _,v in pairs{"dyc_damagedisplay","damagenumber",'boat_player_collision','boat_item_collision'}do
    AddPrefabPostInit(v, SetImmune)
end

--船的物理修复
local function OnBoatStop(inst)
    if inst.tz_mvels then
        inst.components.boatphysics.velocity_x = inst.tz_mvels[1]
        inst.components.boatphysics.velocity_z = inst.tz_mvels[3]
    end
end

AddPrefabPostInit("boat", function(inst) 
    inst.tz_timemagic_onstop = OnBoatStop
end)

do
    local old_dead = IsEntityDead
    function GLOBAL.IsEntityDead(inst, require_health)
        if inst:IsValid() and not inst.inlimbo and inst:HasTag("taizhenTag_livecorpse") then
            return false
        else
            return old_dead(inst, require_health)
        end
    end
end

local function IsBack(attacker, target)
    if target:IsValid() and target.Transform and attacker:IsValid() and attacker.Transform then
        local angle1 = target.Transform:GetRotation()
        local angle2 = target:GetAngleToPoint(attacker:GetPosition())
        local deltaangle = DeltaAngleAbs(angle1, angle2)
        if deltaangle > 100 then
            return true
        elseif deltaangle > 80 and math.random() < 0.75 then
            return true
        end
    end
end 

HookComponent("combat", function (Combat)

    local old_hit = Combat.GetAttacked
    function Combat:GetAttacked(...)
        local snd = self.hurtsound
        if self.inst:HasTag('taizhenTag_pause') then
            self.hurtsound = nil
        end
        old_hit(self, ...)
        if not self.hurtsound then
            self.hurtsound = snd
        end
    end
end)

local SGTagsToEntTags =
{
    ["attack"] = true,
    ["autopredict"] = true,
    ["busy"] = true,
    ["dirt"] = true,
    ["doing"] = true,
    ["fishing"] = true,
    ["flight"] = true,
    ["giving"] = true,
    ["hiding"] = true,
    ["idle"] = true,
    ["invisible"] = true,
    ["lure"] = true,
    ["moving"] = true,
    ["nibble"] = true,
    ["noattack"] = true,
    ["nopredict"] = true,
    ["pausepredict"] = true,
    ["sleeping"] = true,
    ["working"] = true,
    ["jumping"] = true,
}

AddGlobalClassPostConstruct('stategraph', 'StateGraphInstance', function(self)
    self.tz_sgmemorydata = {params = {}}

    local old_gotostate = self.GoToState
    function self:GoToState(newstate, p, ...)
        self.tz_nextupdatetick = nil

        local state = self.sg.states[newstate]
        if state == nil then 
            return old_gotostate(self, newstate, p, ...)
        end

        if not self.inst:HasTag("taizhenTag_pause") then
            return old_gotostate(self, newstate, p, ...) 
        else
            --print(string.format('should enter state %s but stored.',newstate))
            local oldstate = self.currentstate or {}

            self.tz_sgmemorydata.onexit = oldstate.onexit
            self.tz_sgmemorydata.onenter = state.onenter
            self.tz_sgmemorydata.params = {p, ...}
            self.tz_sgmemorydata.statemem = self.statemem -- onexit函数可能会调用mem
            oldstate.onexit = function() return end
            state.onenter = function() return end

            old_gotostate(self, newstate, p, ...)
            
            oldstate.onexit = self.tz_sgmemorydata.onexit
            state.onenter = self.tz_sgmemorydata.onenter
        end
    end

    function self:TZ_TimeMagic_OnStop()
        local statemem = self.statemem 
        self.statemem = self.tz_sgmemorydata.statemem
        if self.tz_sgmemorydata.onexit then
            self.tz_sgmemorydata.onexit(self.inst)
        end
        self.statemem = statemem
        if self.tz_sgmemorydata.onenter then
            self.tz_sgmemorydata.onenter(self.inst, unpack(self.tz_sgmemorydata.params))
        end

        self.tz_sgmemorydata = {params = {}}
    end
end)
AddComponentPostInit("combat", function(self)
	local oldGetAttacked = self.GetAttacked
	function self:GetAttacked(attacker,damage, ...)
        if damage and self.tz_wzk_hd ~= nil and self.tz_wzk_hd:IsValid() then
            self.tz_wzk_hd:TakeDamage(damage)
            self.inst:PushEvent("blocked", { attacker = attacker })
            return true
        end
		return oldGetAttacked(self,attacker,damage, ...)
	end
end)
AddComponentPostInit("cursable", function(self)
	local oldIsCursable = self.IsCursable
	function self:IsCursable(item)
		if item and item.components.curseditem and item.components.curseditem.curse  == "MONKEY" and self.inst:HasTag("taizhen") then
			return false
		end
		return oldIsCursable(self,item)
	end
	local oldApplyCurse = self.ApplyCurse
	function self:ApplyCurse(item)
		if item and item.components.curseditem and item.components.curseditem.curse == "MONKEY" and self.inst:HasTag("taizhen") then
			item:RemoveTag("applied_curse")
        	item.components.curseditem.cursed_target = nil
			return
		end
		return oldApplyCurse(self,item)
	end
	local oldForceOntoOwner = self.ForceOntoOwner
	function self:ForceOntoOwner(item)
		if item and item.components.curseditem and item.components.curseditem.curse == "MONKEY" and self.inst:HasTag("taizhen") then
			return
		end
		return oldForceOntoOwner(self,item)
	end
end)


AddStategraphState('wilsonghost', 
State{
    name = "tz_appear",
    tags = { "nopredict","busy"},
    onenter = function(inst)
        if inst.loading_ghost then
            inst.sg:GoToState("idle")
            return
        end
        inst.AnimState:PlayAnimation("idle_pre")
        if not inst:HasTag("mime") then
            inst.SoundEmitter:PlaySound(
                inst:HasTag("girl") and
                "dontstarve/ghost/ghost_girl_howl" or
                "dontstarve/ghost/ghost_howl"
            )
        end
    end,
    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
})

AddComponentPostInit("health", function(self)
    local oldDoDelta = self.DoDelta
    function self:DoDelta(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb,...)
        if afflicter and afflicter.components.inventory and afflicter.components.inventory:EquipHasTag("tz_yingci") then
            ignore_absorb = true
        end
        return oldDoDelta(self,amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb,...)
    end
end)

AddComponentPostInit("temperature", function(self)
	local old_SetTemperature =  self.SetTemperature
	function self:SetTemperature(value,...)
		if value < 10 and  self.inst.components.inventory and self.inst.components.inventory:EquipHasTag("tz_cold_resistant", 1) then
			value = 10
		end
		if value > (self.overheattemp - 10 ) and self.inst.components.inventory and self.inst.components.inventory:EquipHasTag("tz_heat_resistant") then
			value = self.overheattemp - 10
		end		
		return old_SetTemperature(self,value,...)
	end
end)

AddClassPostConstruct("widgets/controls",function(self)
    local old = self.ToggleMap
    function self:ToggleMap(...)
        if self.owner and self.owner.tz_fh_ht_map then
            self.owner.tz_fh_ht_map =  false
        end
        return old(self,...)
    end
end)