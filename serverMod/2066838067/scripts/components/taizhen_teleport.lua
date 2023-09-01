local function ontraveller(self, traveller)
	self.inst.replica.taizhen_teleport:SetTraveller(traveller)
end

local default_dist_cost = 20
local max_sanity_cost = 0
local min_hunger_cost = 10

local taizhen_teleport =
	Class(
	function(self, inst)
		self.inst = inst
		self.dist_cost = default_dist_cost
        self.TeleTask = nil
        self.traveller = nil
		self.destinations = {}
        self.destination = nil
	end,nil,
	{
		traveller = ontraveller
	}
)

function taizhen_teleport:ListDestination(traveller)
    self.destinations = {}
    for k,v  in pairs(Ents) do
        if v and v:IsValid() and v ~= self.inst and v.components.taizhen_teleport and not v.components.inventoryitem 
            and v.components.writeable and v.components.writeable:IsWritten() and v.components.writeable:GetText() ~= "" then
            table.insert(self.destinations, v)
        end
    end
	table.sort(self.destinations,function(destA, destB) return self.inst:GetDistanceSqToInst(destA) < self.inst:GetDistanceSqToInst(destB) end)
end

function taizhen_teleport:BeginTravel(traveller)
    self:EndTravel()
	local comment = self.inst.components.talker
	if not traveller then comment:Say("谁摸了我？") return end
	local talk = traveller.components.talker
    if self.inst.components.rechargeable then
        if self.inst.components.rechargeable:GetPercent() <1 then
            talk:Say("它还需要休息一会.")
            return
        end
    end
    self:ListDestination(traveller)
	self:MakeInfos()	
	self.traveller = traveller
	if traveller.HUD ~= nil then
		self.screen = traveller.HUD:ShowTZTeleScreen(self.inst)
	end
end

function taizhen_teleport:MakeInfos()
	local infos = ""
	for i, destination in ipairs(self.destinations) do
		local name = destination.components.writeable and destination.components.writeable:GetText() or "~nil"
        if name =="" then name = "~nil" end
		local cost_hunger = min_hunger_cost
		local cost_sanity = 0
        local sq = self.inst:GetDistanceSqToInst(destination)
		local dist = math.sqrt(sq)
		cost_hunger = cost_hunger + math.ceil(dist / self.dist_cost)
		cost_sanity = 0
		if destination == self.inst then
			cost_hunger = 0
			cost_sanity = 0
		end
		infos = infos .. (infos == "" and "" or "\n") .. i .. "\t" .. name .. "\t" .. cost_hunger .. "\t" .. cost_sanity
	end
	self.inst.replica.taizhen_teleport:SetDestInfos(infos)
end
local function TeleportEnd(inst,hunger,dpos)
    
    inst:SnapCamera()
    inst:ScreenFade(true, 1)
    if inst.DynamicShadow ~= nil then 
       inst.DynamicShadow:Enable(true)
    end
    inst.sg:GoToState(inst:HasTag("playerghost") and "appear" or "doshortaction")
	inst:Show()
    SpawnPrefab("statue_transition_2").Transform:SetPosition(dpos:Get())
    SpawnPrefab("spawn_fx_medium").Transform:SetPosition(dpos:Get()) 
    inst.components.hunger:DoDelta(hunger)
end

local allowsg = {
    wakeup = true,
    powerup = true,
    powerdown = true,
    transform_wereplayer = true,
    transform_werebeaver = true,
    transform_beaver_person = true,
    transform_weremoose = true,
    transform_moose_person = true,
    transform_weregoose = true,
    transform_goose_person = true,
    electrocute = true,
    rebirth = true,
    death = true,
    idle = true,
    funnyidle = true,
    bow = true,
    bow_loop = true,
    bow_pst = true,
    bow_pst2 = true,
    mounted_idle = true,
    tz_fanhao_idle = true,
    graze = true,
    graze_empty = true,
    bellow = true,
    shake = true,
    chop_start = true,
    chop = true,
    mine_start = true,
    mine = true,
    hammer_start = true,
    hammer = true,
    gnaw = true,
    hide = true,
    shell_enter = true,
    shell_idle = true,
    shell_hit = true,
    parry_pre = true,
    parry_idle = true,
    parry_hit = true,
    parry_knockback = true,
    terraform = true,
    dig_start = true,
    dig = true,
    bugnet_start = true,
    bugnet = true,
    fishing_pre = true,
    fishing = true,
    fishing_pst = true,
    fishing_nibble = true,
    fishing_strain = true,
    catchfish = true,
    loserod = true,
    eat = true,
    quickeat = true,
    refuseeat = true,
    opengift = true,
    usewardrobe = true,
    openwardrobe = true,
    changeinwardrobe = true,
    changeoutsidewardrobe = true,
    dressupwardrobe = true,
    talk = true,
    mime = true,
    unsaddle = true,
    heavylifting_start = true,
    heavylifting_stop = true,
    heavylifting_item_hat = true,
    heavylifting_drop = true,
    dostandingaction = true,
    doshortaction = true,
    dosilentshortaction = true,
    dohungrybuild = true,
    domediumaction = true,
    revivecorpse = true,
    dolongaction = true,
    dojostleaction = true,
    dochannelaction = true,
    makeballoon = true,
    shave = true,
    enter_onemanband = true,
    play_onemanband = true,
    play_onemanband_stomp = true,
    play_flute = true,
    play_horn = true,
    play_bell = true,
    play_whistle = true,
    book = true,
    blowdart = true,
    throw = true,
    catch_pre = true,
    catch = true,
    attack = true,
    attack_prop_pre = true,
    attack_prop = true,
    run_start = true,
    run = true,
    run_stop = true,
    item_hat = true,
    item_in = true,
    item_out = true,
    give = true,
    bedroll = true,
    tent = true,
    knockout = true,
    hit = true,
    hit_souloverload = true,
    hit_darkness = true,
    hit_spike = true,
    hit_push = true,
    hop_master = true,
    startle = true,
    mount_plank = true,
    raiseanchor = true,
    steer_boat_idle_pre = true,
    steer_boat_idle_loop = true,
    steer_boat_turning = true,
    steer_boat_turning_pst = true,
    stop_steering = true,
    sink = true,
    sink_fast = true,
    abandon_ship_pre = true,
    abandon_ship = true,
    washed_ashore = true,
    cast_net = true,
    cast_net_retrieving = true,
    cast_net_release = true,
    cast_net_release_pst = true,
    repelled = true,
    knockback = true,
    knockback_pst = true,
    knockbacklanded = true,
    mindcontrolled = true,
    mindcontrolled_loop = true,
    mindcontrolled_pst = true,
    toolbroke = true,
    tool_slip = true,
    armorbroke = true,
    spooked = true,
    teleportato_teleport = true,
    amulet_rebirth = true,
    portal_rez = true,
    reviver_rebirth = true,
    corpse = true,
    corpse_rebirth = true,
    jumpin_pre = true,
    jumpin = true,
    jumpout = true,
    entertownportal = true,
    exittownportal_pre = true,
    exittownportal = true,
    castspell = true,
    quickcastspell = true,
    quicktele = true,
    forcetele = true,
    combat_lunge_start = true,
    combat_lunge = true,
    combat_leap_start = true,
    combat_leap = true,
    combat_superjump_start = true,
    combat_superjump = true,
    combat_superjump_pst = true,
    multithrust_pre = true,
    multithrust = true,
    helmsplitter_pre = true,
    helmsplitter = true,
    blowdart_special = true,
    throw_line = true,
    catch_equip = true,
    emote = true,
    frozen = true,
    thaw = true,
    pinned_pre = true,
    pinned = true,
    pinned_hit = true,
    breakfree = true,
    use_fan = true,
    yawn = true,
    migrate = true,
    mount = true,
    dismount = true,
    falloff = true,
    bucked = true,
    bucked_post = true,
    bundle = true,
    bundling = true,
    bundle_pst = true,
    startconstruct = true,
    construct = true,
    constructing = true,
    construct_pst = true,
    startchanneling = true,
    channeling = true,
    stopchanneling = true,
    till_start = true,
    till = true,
    portal_jumpin_pre = true,
    portal_jumpin = true,
    portal_jumpout = true,
    form_log = true,
    fertilize = true,
    fertilize_short = true,
    furl_boost = true,
    furl = true,
    furl_fail = true,
    tackle_pre = true,
    tackle_start = true,
    tackle = true,
    tackle_collide = true,
    tackle_stop = true,
}
local function Action(doer,hunger)
		
        
end

local function Teleport_end(traveller,spos,dpos,hunger)
		SpawnPrefab("statue_transition_2").Transform:SetPosition(traveller.Transform:GetWorldPosition())
		SpawnPrefab("spawn_fx_medium").Transform:SetPosition(traveller.Transform:GetWorldPosition())
        if traveller.DynamicShadow ~= nil then 
            traveller.DynamicShadow:Enable(true)
        end
        traveller.sg:GoToState(traveller:HasTag("playerghost") and "appear" or "doshortaction")
        traveller.components.hunger:DoDelta(hunger)
		traveller:Show()
end

local function Teleport_continue(traveller,spos,dpos,hunger)
        
        
        if traveller.Physics ~= nil then
		traveller.Physics:Teleport(dpos.x - 1, 0, dpos.z)
		else
		traveller.Transform:SetPosition(dpos.x - 1, 0, dpos.z)
	end
	-- follow
	if traveller.components.leader and traveller.components.leader.followers then
		for kf, vf in pairs(traveller.components.leader.followers) do
			if kf.Physics ~= nil then
				kf.Physics:Teleport(dpos.x + 1, 0, dpos.z)
			else
				kf.Transform:SetPosition(dpos.x + 1, 0, dpos.z)
			end
		end
	end

	local inventory = traveller.components.inventory
	if inventory then
		for ki, vi in pairs(inventory.itemslots) do
			if vi.components.leader and vi.components.leader.followers then
				for kif, vif in pairs(vi.components.leader.followers) do
					if kif.Physics ~= nil then
						kif.Physics:Teleport(dpos.x, 0, dpos.z + 1)
					else
						kif.Transform:SetPosition(dpos.x, 0, dpos.z + 1)
					end
				end
			end
		end
	end

	local container = inventory:GetOverflowContainer()
	if container then
		for kb, vb in pairs(container.slots) do
			if vb.components.leader and vb.components.leader.followers then
				for kbf, vbf in pairs(vb.components.leader.followers) do
					if kbf.Physics ~= nil then
						kbf.Physics:Teleport(dpos.x, 0, dpos.z - 1)
					else
						kbf.Transform:SetPosition(dpos.x, 0, dpos.z - 1)
					end
				end
			end
		end
	end
    
		traveller:SnapCamera()
		traveller:ScreenFade(true, 2)	 
		traveller:DoTaskInTime(1.8, Teleport_end,spos,dpos,hunger)
end

local function DoTeleport(traveller,hunger,spos,dpos)
    local sg = traveller.sg.currentstate.name
    print('sg->',sg)
    if not allowsg[sg] then
        return 
    end
    traveller:ScreenFade(false)
    --traveller:DoTaskInTime(3, Action,hunger)
    SpawnPrefab("spawn_fx_medium").Transform:SetPosition(spos:Get())
    SpawnPrefab("statue_transition_2").Transform:SetPosition(spos:Get())
    traveller.sg:GoToState("tz_forcetele")
    traveller:Hide()
    traveller:DoTaskInTime(1, Teleport_continue,spos,dpos,hunger)
    
    --traveller:DoTaskInTime(1.8,TeleportEnd,hunger,dpos)
end

local function TeleTask (inst,tele)
    local t = inst.components.talker
    local d = tele.destination
    local p = tele.traveller
    if not d or not d:IsValid() then
        t:Say("目的地不再可达.",3)
    else
        if tele.time == 0 then
            local dist = math.sqrt(inst:GetDistanceSqToInst(d))
            local cost_hunger = min_hunger_cost + math.ceil(dist / tele.dist_cost)
            local cost_sanity = 0 
                local pos = tele.inst:GetPosition()
                local dpos = d:GetPosition()
                local players = TheSim:FindEntities(pos.x, pos.y, pos.z,tele.inst.replica.inventoryitem and  1.5 or 3,{"player"})
                if tele.inst.components.rechargeable then
                    if tele.inst.components.rechargeable.StartRecharge then
                        tele.inst.components.rechargeable:StartRecharge() 
                    else
                        tele.inst.components.rechargeable:StartRecharging() 
                    end
                end
                for k,v in pairs(players) do 
                    if v and v:IsValid() then
                        local spos = v:GetPosition()
                        DoTeleport(v,-cost_hunger,spos,dpos)
                    end
                end
        else
            tele.time = tele.time -1
            t:Say(tele.time..'秒后打开时空漩涡,请靠近我.')
            inst.SoundEmitter:PlaySound("dontstarve/HUD/craft_down")
            return
        end
        
    end
    tele:CancelTravel()
end
function taizhen_teleport:Travel(traveller, index)
    self:EndTravel()
    if self.inst.components.rechargeable and self.inst.components.rechargeable:GetPercent() <1 then
        traveller.components.talker:Say("它还需要休息一会.")
        return
    end
    if self.inst:GetDistanceSqToInst(traveller) >9 then
        traveller.components.talker:Say("太远了.")
        return
    end
    self:ListDestination()
    self.traveller = traveller
	local destination = self.destinations[index]
    if not destination or not destination:IsValid() then
        if traveller and traveller.HUD and traveller.HUD.CloseTZTeleScreen then
            traveller.HUD:CloseTZTeleScreen()
        end
        self:EndTravel()
        return
    end
	if traveller then
		self.destination = destination
		local comment = self.inst.components.talker
		local desc = destination.components.writeable:GetText()
		local description = desc and string.format('"%s"', desc) or "未知地点"
		local dist = math.sqrt(self.inst:GetDistanceSqToInst(destination))
        local cost_hunger = min_hunger_cost + math.ceil(dist / self.dist_cost)
        local cost_sanity = 0
		local information ="去: "..description.."\n饥饿: "..string.format("%.0f", cost_hunger)
		--comment:Say(information, 3)
        self.time = 0
        self.traveltask = self.inst:DoPeriodicTask(1,TeleTask,nil,self)
	end
end

function taizhen_teleport:CancelTravel()
    if self.traveltask then
        self.traveller = nil
        self.destinations = {}
        self.traveltask:Cancel()
    end
end

function taizhen_teleport:EndTravel()
	if self.traveller ~= nil then
		if self.screen ~= nil then
			self.traveller.HUD:CloseTZTeleScreen()
			self.screen = nil
		end
		--self.inst:RemoveEventCallback("ms_closepopups", self.onclosepopups, self.traveller)
		--self.inst:RemoveEventCallback("onremove", self.onclosepopups, self.traveller)
        self.traveller  = nil
	elseif self.screen ~= nil then
		if self.screen.inst:IsValid() then
			self.screen:Kill()
		end
	end
    self.screen = nil
    self:CancelTravel()
end

--------------------------------------------------------------------------

function taizhen_teleport:OnRemoveFromEntity()
	self:EndTravel()
	self.inst:RemoveTag("taizhen_teleport")
end

taizhen_teleport.OnRemoveEntity = taizhen_teleport.EndTravel

return taizhen_teleport
