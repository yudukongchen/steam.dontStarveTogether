
-- Ly:Write white list userid here !
local WHITE_LIST = {
     -- 番号审判天使
     tz_fhspts = 1,
    -- 番号再临者
    tz_fhzlz = 1,
    -- 番号仲裁
    tz_fhzc = 1,

    -- 番号鱼妞的眷恋
    tz_fh_fishgirl = 1,

	-- 番号否天
    tz_fhft = 1,

    -- 番号薄暝
    tz_fhbm = 1,

	-- 番号归墟
    tz_fhgx = 1,

    -- 番号谪仙
    tz_fhdx = 1,

    -- 番号夜幕
    tz_fhym = 1,

   -- 番号魔临
   tz_fh_ml = 1, 
   -- 番号游
   tz_fh_you = 1, 
   --宁心
   tz_fh_nx =1,
    --化凡
   tz_fh_hf = 1,
   --两仪
   tz_fh_ly =1,
   --海洋女神
   tz_fh_ns = 1,
   tz_fh_xhws = 1,
   tz_fh_jhz = 1,
   tz_fh_ht = 1,
   tz_fh_fl = 1,
   tz_fh_ys = 1,
   tz_fhmt = 1,
}


local function ToggleOffPhysics(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:CollidesWith(COLLISION.WORLD)
end

local function ToggleOnPhysics(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end

local function updatelight(inst, phase)
    if phase == "night" then
        if inst._light ~= nil and inst._light:IsValid() then
            inst._light:Turnoon()
        end
    elseif inst._light ~= nil and inst._light:IsValid() then
        inst._light:Turnoff()
    end
end

local SKILL_LIBIARY = {
    -- 影子球
    shadow_ball = {
        ServerFn = function(inst)
            inst.components.weapon:SetProjectile("tz_projectile")
        end,
    },

    -- 全能工作
    alltools = {
        ServerFn = function(inst,data)
            inst:AddComponent("tool")
            inst.components.tool:SetAction(ACTIONS.CHOP)
            inst.components.tool:SetAction(ACTIONS.MINE)
            inst.components.tool:SetAction(ACTIONS.DIG)
            inst.components.tool:SetAction(ACTIONS.HAMMER)
            inst.components.tool:SetAction(ACTIONS.NET)

            if data.fishingrod then
                inst:AddComponent("fishingrod")
                inst.components.fishingrod:SetWaitTimes(2, 10)
                inst.components.fishingrod:SetStrainTimes(0, 2.5)
            end
            if data.tillable then
                inst:AddInherentAction(ACTIONS.TILL)
                inst:AddComponent("farmtiller")
                if not data.supertill then
                    return
                end
                inst.components.farmtiller.Till = function(self,pt, doer)
                    local tilling = false
                    local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(pt.x, 0, pt.z)
                    for x = -1,1 do
                        for y = -1,1 do
                            local till_x = tile_x + x*1.3
                            local till_y = tile_z + y*1.3
                            if TheWorld.Map:CanTillSoilAtPoint(till_x, 0, till_y, false) then
                                TheWorld.Map:CollapseSoilAtPoint(till_x, 0, till_y)
                                SpawnPrefab("farm_soil").Transform:SetPosition(till_x, 0, till_y)
                                tilling = true
                            end
                        end
                    end
                    if tilling then
                        if doer ~= nil then
                            doer:PushEvent("tilling")
                        end
                        return true
                    end
                    return false
                end
            end
        end,
    },

    -- 暗夜爆破 
    -- 攻击造成范围伤害，范围半径3,5,6码；
    night_explosion = {
        -- Return a wrap func that can modify attack radius dynamiclly.
        on_attack_fn_wrapper = function(rad,exclude_tags)
            exclude_tags = exclude_tags or { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" }
            local function OnAttack(weapon,owner,target)
                owner.components.combat:DoAreaAttack(target,rad, weapon,function(v,player)
                    return player.components.combat:CanTarget(v) and not player.components.combat:IsAlly(v)
                end, weapon.components.weapon.stimuli, exclude_tags)
            end

            return OnAttack
        end,
    },

    -- 生命汲取
    -- 普通攻击吸血0.5%,1%,1.5%；
    -- Required to set inst._percent_life_steal
    life_steal = {
        OnEquip = function(inst,data)
            inst:ListenForEvent("onhitother",inst._on_hit_other_life_steal,data.owner)
        end,

        OnUnquip = function(inst,data)
            inst:RemoveEventCallback("onhitother",inst._on_hit_other_life_steal,data.owner)
        end,

        ServerFn = function(inst)
            -- inst._percent_life_steal = 0.5 / 100
            inst._on_hit_other_life_steal = function(owner,data)
                if data.weapon == inst then
                    owner.components.health:DoDelta(data.damage * inst._percent_life_steal,false)
                end
            end
        end,
    },

    --能力照夜 发光
    zhaoye =  {
        ServerFn = function(inst)
            inst:ListenForEvent("equipped",function(inst,data)
                if data and data.owner and not inst._light then
                    inst._light = SpawnPrefab("tz_yexingzhe_light")
                    if TheWorld.state.phase == "night" then
                        inst._light:Turnoon()
                    end
                 inst._light.entity:SetParent(data.owner.entity)
				 inst._light.Transform:SetPosition(0, 0, 0)
             end
            end)
            inst:ListenForEvent("unequipped",function(inst,data)
                if inst._light and inst._light:IsValid() then
                    inst._light:Remove()
                    inst._light = nil
                end
            end)
            inst:WatchWorldState("phase", updatelight)
            updatelight(inst, TheWorld.state.phase)
        end
    },
    -- 暗之能源
    -- 人物伤害+25%,+50%,+75%；
    -- Required to set inst._percent_dark_energy
    dark_energy = {
        OnEquip = function(inst,data)
            data.owner.components.combat.externaldamagemultipliers:SetModifier(inst,inst._percent_dark_energy or 1,inst.prefab)
        end,

        OnUnquip = function(inst,data)
            data.owner.components.combat.externaldamagemultipliers:RemoveModifier(inst,inst.prefab)
        end,
    },

    --影步 支持不一样的数值
    shadowstep = {
        ServerFn = function(inst,data)
            inst.components.equippable.walkspeedmult = data.walkspeedmult or 1.25
        end,
    },
    --背水战阵
    beishui = {
        ServerFn = function(inst,data)
            inst:AddTag("tz_fh_beishui")
        end,
    },
    yingci =  { --无视护甲造成伤害
        ServerFn = function(inst,data)
            inst:AddTag("tz_yingci")
        end,
    },
    anyexingzhe =  { --人物可以穿透物体；
        OnEquip = function(inst,data)
            if data and data.owner and data.owner.Physics then
                ToggleOffPhysics(data.owner)
            end
        end,
        OnUnequip = function(inst,data)
            if data and data.owner and data.owner.Physics then
                ToggleOnPhysics(data.owner)
            end
        end,
    },
    anyingjisi =  { --暗影祭祀
        ServerFn = function(inst,data)
            inst.tz_anyingjisikilled = function(owner,data)
                if math.random() < 0.25 and owner and owner.components.inventory then
                    owner.components.inventory:GiveItem(SpawnPrefab("nightmarefuel"))
                end   
            end
        end,
        OnEquip = function(inst,data)
            if data and data.owner then
                inst:ListenForEvent("killed",inst.tz_anyingjisikilled,data.owner)
            end
        end,
        OnUnequip = function(inst,data)
            if data and data.owner then
                inst:RemoveEventCallback("killed",inst.tz_anyingjisikilled,data.owner)
            end
        end,
    },
}

-- 一键增加眷属名字
local function AddOwnerName(inst)
    local old_GetDisplayName = inst.GetDisplayName
    inst.GetDisplayName = function(self,...)
        local level = inst.tz_fh_level ~= nil and inst.tz_fh_level:value() or 0
        if level == 0 then
            return (old_GetDisplayName(self,...) or "")
            .."\n"..STRINGS.NAMES.TZ_FH_OWNERS.PRE_INDEX..STRINGS.NAMES.TZ_FH_OWNERS[inst.prefab:upper()]
        else
            return (old_GetDisplayName(self,...) or "")
            ..(" +"..level)
            .."\n"..STRINGS.NAMES.TZ_FH_OWNERS.PRE_INDEX..STRINGS.NAMES.TZ_FH_OWNERS[inst.prefab:upper()]
            .."\n伤害 +"..level.."%"
            .."\n移动速度 +"..level.."%"
        end
    end
end

-- 损坏时返还拨浪鼓
local function SetReturnSpiritualism(inst)
    local function onfinished()
        local owner = inst.components.inventoryitem:GetGrandOwner()
        local spiritualism = SpawnAt("tz_spiritualism",owner or inst)
        if owner and owner.components.inventory then
            owner.components.inventory:Equip(spiritualism)
        else
            spiritualism.components.inventoryitem:OnDropped(true)
        end

        inst:Remove()
    end

    if inst.components.fueled then
        inst.components.fueled:SetDepletedFn(onfinished)
    elseif inst.components.finiteuses then
        inst.components.finiteuses:SetOnFinished(onfinished)
    elseif inst.components.armor then
        inst.components.armor.onfinished = onfinished
    end
    
end

-- 通用增加燃料耐久并可以填充噩梦燃料
local function AddFueledComponent(inst,data)
    data = data or {}

    inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(data.max or 3840)
    
    inst.components.fueled:SetTakeFuelFn(data.ontakefuel or function(inst,taker)
        inst.components.fueled:DoDelta(384)
        inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        local owner = inst.components.inventoryitem:GetGrandOwner()
        if owner and owner:HasTag("player") then
            local pos = owner:GetPosition()
            SpawnAt("tz_takefuel",pos + Vector3(-0.1,-2.6,0))
        end
    end)
    if not data.nofirstperiod then
        inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    end

    if data.accepting == true or data.accepting == nil then
        inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
        inst.components.fueled.accepting = true
    end

    SetReturnSpiritualism(inst)
end

-- For some reason,some FanHao weapon can't use fueled component to restore NaiJiu,so I made this to replace it.
-- 交易组件，有些装备不适用燃料组件时备用
local function AddTraderComponent(inst,data)
    data = data or {}
    data.trade_list = data.trade_list or {
        nightmarefuel = 0.15,
    }

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(data.ShouldAcceptItem or function(inst,item)
        for k,v in pairs(data.trade_list) do
            if item.prefab == k then
                return true
            end
        end
    end)
    inst.components.trader.onaccept = data.OnGetItemFromPlayer or function(inst,giver,item)
        local restore = data.trade_list[item.prefab]

        if inst.components.fueled then
            inst.components.fueled:SetPercent(inst.components.fueled:GetPercent() + restore)
        elseif inst.components.finiteuses then
            inst.components.finiteuses:SetPercent(inst.components.finiteuses:GetPercent() + restore)
        elseif inst.components.armor then
            inst.components.armor:SetPercent(inst.components.armor:GetPercent() + restore)
        end
        if data.additionalfn then
            data.additionalfn(inst,giver,item)
        end
    end
    inst.components.trader.onrefuse = data.OnRefuseItem or nil
end

local function IsWhiteListOwner(owner,fh_prefab_name)
    --do return true end
    local is_valid_owner = false
    if not owner:HasTag("player") then
        is_valid_owner = false 
    elseif TaiZhenSkinCheckClientFn(nil,owner.userid, fh_prefab_name) then
        return true
    end

    return is_valid_owner
end

local function should_drop_test(inst,owner)
    if not inst.components.equippable:IsEquipped() then
        return false
    end

    return not IsWhiteListOwner(owner,inst.prefab)
end

local function HasItemWithTag(owner,tag, amount)
	local self = owner.components.inventory
    local num_found = 0
    for k, v in pairs(self.itemslots) do
        if v and v:HasTag(tag) then
            num_found = num_found + 1
        end
    end

    if self.activeitem and self.activeitem:HasTag(tag) then
        num_found = num_found + 1
    end
	
	for k, v in pairs(self.equipslots) do
        if v:HasTag(tag) then
            num_found = num_found + 1
        end
    end

    local overflow = self:GetOverflowContainer()
    if overflow ~= nil then
        local overflow_enough, overflow_found = overflow:HasItemWithTag(tag, amount)
        num_found = num_found + overflow_found
    end

    return num_found > amount
end

local function tzsama(inst)
	--玩家出生只能带1个番号，每增加300撒麻值上限，可多带1个番号
	inst:ListenForEvent("onputininventory", function(inst,ow)
		inst:DoTaskInTime(0.1,function(inst)
			local owner = inst.components.inventoryitem:GetGrandOwner()
			if owner ~= nil and owner.components.inventory then
				if HasItemWithTag(owner,"tz_fanhao", owner.components.tzsama ~= nil and math.ceil(owner.components.tzsama.max/200) or 1) then
					owner.components.inventory:DropItem(inst)
					if owner.components.talker then
						owner.components.talker:Say("撒麻值不足,每增加200撒麻值上限，可多带1个番号")
					end
				end
			end
		end)
    end)
end

local function MakeWhiteList(inst)
    inst:ListenForEvent("equipped",function(inst,data)
        local owner = data.owner
        local should_drop = should_drop_test(inst,owner)

        if should_drop then
            inst:DoTaskInTime(0,function()
                local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner

                if owner and owner.components.inventory then
                    if should_drop_test(inst,owner) then
                        owner.components.inventory:DropItem(inst)
                        if owner.components.talker then
                            owner.components.talker:Say("这把番号的力量我无法驾驭")
                        end
                    end
                end
                
            end)
            
        end
    end)
	tzsama(inst)
end

local function AddLibrarySkill(inst,data)
    local skill_name = data.name 
    local lib_data = SKILL_LIBIARY[skill_name]
    if lib_data ~= nil then

        if lib_data.OnEquip then
            inst:ListenForEvent("equipped",lib_data.OnEquip)
        end

        if lib_data.OnUnequip then
            inst:ListenForEvent("unequipped",lib_data.OnUnequip)
        end

        if lib_data.ServerFn then
            lib_data.ServerFn(inst,data)
        end 
        
    else 
        print("AddLibrarySkill Warning:",skill_name,"lib_data is nil !")
    end
end

local function AddFhLevel(inst,zhuanshu) --专属的话吞噬的属性都是一样的
    inst.tz_fh_level = net_ushortint(inst.GUID, "tzfanhaolevel")
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("tz_fh_level") 
    if zhuanshu then
        inst.components.tz_fh_level.zhuanshu = true
    end
end
for k,v in pairs(WHITE_LIST)  do
    TaizhenRegThanksImg(k,STRINGS.NAMES[k:upper()],"images/inventoryimages/"..k..".xml",k..".tex")
end
return {
    AddOwnerName = AddOwnerName,
    AddFhLevel = AddFhLevel,
    AddFueledComponent = AddFueledComponent,
    AddTraderComponent = AddTraderComponent,
    SetReturnSpiritualism = SetReturnSpiritualism,
    MakeWhiteList = MakeWhiteList,
    tzsama = tzsama,
    AddLibrarySkill = AddLibrarySkill,
    IsWhiteListOwner = IsWhiteListOwner,

    WHITE_LIST = WHITE_LIST,
    SKILL_LIBIARY = SKILL_LIBIARY,
}