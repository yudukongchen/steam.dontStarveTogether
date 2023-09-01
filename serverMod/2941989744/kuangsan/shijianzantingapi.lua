GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

--TheWorld.components.krm_time_manager:AddTimeMagicCenter(ThePlayer)  --开启时停
--TheWorld.components.krm_time_manager:RemoveTimeMagicCenter(ThePlayer)  --结束时停
--免疫部分在组件 krm_time_util

AddPrefabPostInit("world", function(inst)
    inst:AddComponent("krm_time_manager")
	
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
        if self.krm_isstatic then
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
        period.krmisstatic = true
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
            self.krm_nextupdatetick = nil
        else
            -- 2022.1.14 fix state.onupdate() is not stopped
            if sleep_time == 0 then
                sleep_time = FRAMES
            end

            local sleep_ticks = sleep_time/GetTickTime()
            sleep_ticks = sleep_ticks == 0 and 1 or sleep_ticks
            self.krm_nextupdatetick = math.floor(sleep_ticks + GetTick())+1
        end

        return sleep_time
    end

    function self:AddTick(dt)
        dt = dt or GetTickTime()
        self.statestarttime = self.statestarttime + dt
        if self.krm_nextupdatetick then
            local thislist = SGManager.tickwaiters[self.krm_nextupdatetick]
            if not thislist then return end
            self.krm_nextupdatetick = self.krm_nextupdatetick + 1
            if not SGManager.tickwaiters[self.krm_nextupdatetick]then
                SGManager.tickwaiters[self.krm_nextupdatetick] = {}
            end
            local nextlist = SGManager.tickwaiters[self.krm_nextupdatetick]
            thislist[self] = nil
            nextlist[self] = true
        end
    end
end)

-- AI
AddGlobalClassPostConstruct("behaviourtree", "BT", function(self)
    local old_update = self.Update
    function self:Update(...)
        if self.inst:HasTag("krmTag_pause") then
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
            inst.krmVar_is_precipitation = true
            inst.krm_timemagic_onstart = function(inst)
                inst.VFXEffect:SetDragCoefficient(0,1)
            end
            inst.krm_timemagic_onstop = function(inst)
                inst.VFXEffect:SetDragCoefficient(0,v)
            end
        end)
    end
end

--------------------------
-- 玩家界面、本地音效 --
-------------------------------------------------------

local BEAVERVISION_COLOURCUBES = --测试滤镜
{
    day = "images/colour_cubes/purple_moon_cc.tex",
    dusk = "images/colour_cubes/purple_moon_cc.tex",
    night = "images/colour_cubes/purple_moon_cc.tex",
    full_moon = "images/colour_cubes/purple_moon_cc.tex",
}

AddClientModRPCHandler("kuangsan", "shitinglvjing", function(moshi)
 if ThePlayer and  moshi then
 
	if ThePlayer.components.playervision then
        ThePlayer.components.playervision:SetCustomCCTable(BEAVERVISION_COLOURCUBES)
	end
  
  else
  
    if ThePlayer.components.playervision then
       ThePlayer.components.playervision:SetCustomCCTable(nil)
	end
  
  end
  
end)

local AMB = require "krm_amb"
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

    --inst.components.krm_timepauseblast:Start()
    
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
    if inst.components.playervision then
        inst.components.playervision:SetCustomCCTable(BEAVERVISION_COLOURCUBES)
		SendModRPCToClient(CLIENT_MOD_RPC["kuangsan"]["shitinglvjing"], inst.userid, true)
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
    if inst.components.playervision then
        inst.components.playervision:SetCustomCCTable(nil)
		SendModRPCToClient(CLIENT_MOD_RPC["kuangsan"]["shitinglvjing"], inst.userid)
    end
end

AddReplicableComponent("krm_timepauseskill")
AddPlayerPostInit(function(inst) 
    if TheWorld.ismastersim then
        inst:AddComponent("krm_timepauseskill")
    end
    inst:ListenForEvent("krm_enter_timemagic", Pause)
    inst:ListenForEvent("krm_exit_timemagic", Resume)
end)

AddPrefabPostInitAny(function(inst)
    if not inst.components.krm_ignoretimemagic and not inst.Pathfinder then
        if (TheWorld and TheWorld.ismastersim) or not inst.Network then
            inst:AddComponent("krm_ignoretimemagic")
        end
    end
end)

local LoadComponent = function(path) return require("components/"..path) end

do -- 所有实例的组件更新
    local SKIP_COMPOENNTS = {
        krm_ignoretimemagic = true,
        krm_timepauseblast = true, -- 特效更新
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
                    if not inst:HasTag('krmTag_pause') then 
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
            if self.inst:HasTag("player") and not self.inst.krm_timemagic_inrange then
                old_update(self, ...)
            end
        end
    end
end


do -- 环境湿度
    local self = LoadComponent("moisture")
    local old_get = self.GetMoistureRate 
    function self:GetMoistureRate(...)
        return self.inst.krm_timemagic_inrange and 0 or old_get(self, ...)
    end
end

----------------------
--禁用船桨船帆---------
-------------------------------

do -- 禁用玩家控制
    local self = LoadComponent("playercontroller")
    local old_isenabled = self.IsEnabled
    function self:IsEnabled(...)
        if self.inst:HasTag("krmTag_pause") then
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
            if inst:HasTag("krmTag_pause") then
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
        if self.inst:HasTag("krmTag_pause") then
            if not self.krm_delay then
                local args = {...}
                self.krm_delay = self.inst:DoTaskInTime(2.5*FRAMES, function()
                    -- 延时任务被阻断，解除时停后才会执行
                    -- 为避免下一帧直接触发任务，设置为两帧
                    self.krm_delay = nil
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
        if self.inst:HasTag("krmTag_pause") then
            return nil
        else
            return old_spawn(self, ...)
        end
    end
end)

local function DontShowInTimeMagic(inst)
    if ThePlayer and ThePlayer.krm_timemagic_inrange then
        inst:Hide()
    end
end

for _,v in pairs{"raindrop","wave_shimmer","wave_shimmer_med",
"wave_shimmer_deep","wave_shimmer_flood","wave_shore","impact","shatter",}do 
    AddPrefabPostInit(v, DontShowInTimeMagic) 
end

local function SetImmune(inst)
    inst:AddTag("krmTag_ignoretimemagic")
end

for _,v in pairs{"dyc_damagedisplay","damagenumber",'boat_player_collision','boat_item_collision'}do
    AddPrefabPostInit(v, SetImmune)
end

--船的物理修复
local function OnBoatStop(inst)
    if inst.krm_mvels then
        inst.components.boatphysics.velocity_x = inst.krm_mvels[1]
        inst.components.boatphysics.velocity_z = inst.krm_mvels[3]
    end
end

AddPrefabPostInit("boat", function(inst) 
    inst.krm_timemagic_onstop = OnBoatStop
end)

do
    local old_dead = IsEntityDead
    function GLOBAL.IsEntityDead(inst, require_health)
        if inst:IsValid() and not inst.inlimbo and inst:HasTag("krmTag_livecorpse") then
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
        if self.inst:HasTag('krmTag_pause') then
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
    self.krm_sgmemorydata = {params = {}}

    local old_gotostate = self.GoToState
    function self:GoToState(newstate, p, ...)
        self.krm_nextupdatetick = nil

        local state = self.sg.states[newstate]
        if state == nil then 
            return old_gotostate(self, newstate, p, ...)
        end

        if not self.inst:HasTag("krmTag_pause") then
            return old_gotostate(self, newstate, p, ...) 
        else
            --print(string.format('should enter state %s but stored.',newstate))
            local oldstate = self.currentstate or {}

            self.krm_sgmemorydata.onexit = oldstate.onexit
            self.krm_sgmemorydata.onenter = state.onenter
            self.krm_sgmemorydata.params = {p, ...}
            self.krm_sgmemorydata.statemem = self.statemem -- onexit函数可能会调用mem
            oldstate.onexit = function() return end
            state.onenter = function() return end

            old_gotostate(self, newstate, p, ...)
            
            oldstate.onexit = self.krm_sgmemorydata.onexit
            state.onenter = self.krm_sgmemorydata.onenter
        end
    end

    function self:krm_TimeMagic_OnStop()
        local statemem = self.statemem 
        self.statemem = self.krm_sgmemorydata.statemem
        if self.krm_sgmemorydata.onexit then
            self.krm_sgmemorydata.onexit(self.inst)
        end
        self.statemem = statemem
        if self.krm_sgmemorydata.onenter then
            self.krm_sgmemorydata.onenter(self.inst, unpack(self.krm_sgmemorydata.params))
        end

        self.krm_sgmemorydata = {params = {}}
    end
end)
