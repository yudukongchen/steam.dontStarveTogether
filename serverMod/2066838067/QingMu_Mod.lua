--by:う丶青木
--ps:转载请注明来源
GLOBAL.setmetatable(env, {__index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end})

local function GetFaceVector(inst,add)
	local angle = (inst.Transform:GetRotation() + 90 + (add or 0)) * DEGREES
	local sinangle = math.sin(angle)
	local cosangle = math.cos(angle)

	return Vector3(sinangle,0,cosangle)
end 

local isstr = function(vla) return type(vla) == "string" end
local isnum = function(vla) return type(vla) == "number" end
local isnil = function(vla) return type(vla) == "nil" end
local isbool = function(vla) return type(vla) == "boolean" end
local istbl = function(vla) return type(vla) == "table" end
local isfnn = function(vla) return type(vla) == "function" end

local qmAssets =
{
	Asset("ATLAS", "images/QM_UI10.xml"),
	Asset("IMAGE", "images/QM_UI10.tex"),

	Asset("ATLAS", "images/ghostskillui.xml"),
	Asset("IMAGE", "images/ghostskillui.tex"),

	-- Asset("ATLAS", "images/tzui/ly_skill_icon/space_jump_icon.xml"),
	-- Asset("IMAGE", "images/tzui/ly_skill_icon/space_jump_icon.tex"),

	-- Asset("ATLAS", "images/tzui/ly_skill_desc/space_jump_desc.xml"),
	-- Asset("IMAGE", "images/tzui/ly_skill_desc/space_jump_desc.tex"),

	-- Asset("ATLAS", "images/inventoryimages/item_space_jump.xml"),
	-- Asset("IMAGE", "images/inventoryimages/item_space_jump.tex"),
	
	Asset("ANIM", "anim/tz_quikly.zip"),
	Asset("ANIM", "anim/tz_rection_01.zip"),
	Asset("ANIM", "anim/tz_shadow_01.zip"),
	Asset("ANIM", "anim/qm_cdui.zip"),
	Asset("ANIM", "anim/tz_go.zip"),
	Asset("ANIM", "anim/tz_jump.zip"),
    Asset("IMAGE", "fx/smoke.tex"),
    Asset("SHADER", "shaders/vfx_particle_add.ksh"),

    Asset("ANIM", "anim/tz_player_action_fanta_blade.zip"),
    -- Asset("ANIM", "anim/tz_fanta_blade_stream.zip"),
	
	Asset("ANIM", "anim/tz_fangun.zip"),
	Asset("ANIM", "anim/tz_lijianshu.zip"),
	Asset("ANIM", "anim/tz_chongci_fx.zip"),

	
	Asset("ANIM", "anim/tz_huanying_texie.zip"),
}

local qmPrefabFiles = {
	"sk_fx",
}

for k,v in pairs(qmAssets) do
	table.insert(Assets, v)
end

for k,v in pairs(qmPrefabFiles) do
	table.insert(PrefabFiles, v)
end

local itemji = {
	["item_NaiHan01"] = "【耐寒】学习机",
	["item_NaiHan02"] = "【寒气无效】学习机",
	["item_NaiRe01"] = "【耐暑】学习机",
	["item_NaiRe02"] = "【高温无效】学习机",
	
	["item_z_ljs"] = "【咆哮·斩突破】学习机",
	["item_BeiShuiYiZhan"] = "【背水一战】学习机",
	["item_DaWeiWang"] = "【大胃王】学习机",
	["item_JianZhenRouDian"] = "【减震肉垫】学习机",
	["item_JuShouLieShou"] = "【巨兽猎手】学习机",
	["item_ShiShen"] = "【食神】学习机",
	["item_ShuJiAiHaoZhe"] = "【书籍爱好者】学习机",
	["item_SiRenBaoXianGongSi"] = "【私人保险公司】学习机",
	["item_SuoXiang"] = "【锁箱】学习机",
	["item_TeJiChuShi"] = "【特级厨师】学习机",
	["item_WaErJiLi"] = "【瓦尔基里】学习机",
	["item_XueJuRen"] = "【穴局人】学习机",
	["item_GeDang"] = "【完美格挡】学习机",
	["item_ShengYu"] = "【圣域】学习机",
	["item_rdgz"] = "【弱点感知】学习机",
	["item_FanGun"] = "【翻滚回避】学习机",

	["item_killknife_skill"] = "【影子分身斩】学习机",
	["item_fanta_blade"] = "【幻影剑舞】学习机",
	["item_space_jump"] = "【空间跳跃】学习机",
}

for k,v in pairs(itemji) do
	STRINGS.NAMES[string.upper(k)] = v
end

local AllCao,AllBCao = {},{}

local QMSkTable = {
	{
		[1] = { tex = "z_ljs",		txt = "ljs_z",		key = "ljs",		cd = 35,		sg = 'qm_ljs01',	eq = true,		},
		[2] = { tex = "GeDang",		txt = "GeDang_B",	key = "wmgd",		cd = 4,			sg = 'qm_wmgd',		eq = true,		},
		[3] = { tex = "ShengYu",	txt = "ShengYu_B",	key = "sys",		cd = 60,		sg = 'qm_syshu01',	eq = true,		},
		[4] = { tex = "rdgz",		txt = "rdgz_B",		key = "rdgz",		cd = 40,		sg = 'qm_ruodian',	eq = false,		},
		[5] = { tex = "FanGun",		txt = "FanGun_B",	key = "fangun",		cd = 3,			sg = 'qm_fangun',	eq = false,		},

		[6] = { tex = "killknife_skill",txt = "killknife_skill_desc",key = "killknife_skill_key",cd = 10,sg = 'killknife_skill_sg',eq = true, range = 8},
		[7] = { tex = "fanta_blade",txt = "fanta_blade_desc",key = "fanta_blade_key",cd = 45,sg = 'fanta_blade_sg',eq = true,costs = {hunger = 25}},
		[8] = { 
			tex = "space_jump",
			txt = "space_jump_desc",
			key = "space_jump_key",
			cd = 1,
			sg = 'space_jump_sg',
			eq = false,
			costs = {hunger = 5},
		},

		-- tex is small skill icon in slot of left-down UI 
		-- txt is skill desc img 
		-- key is skill unique key 
		-- cd is skill cool down 
		-- sg is the sg that will GoToState when skill is triggered 
		-- eq is "Should equip sth when cast skill"

		-- Skill that Hua-Hua should write is huahua_skill_1 ~ huahua_skill_4
		--image.png
		[9] = { 
			tex = "ghostskill_image1",
			txt = "ghostskill1",
			key = "huahua_skill_1_key",
			cd = 3.5,
			sg = 'huahua_skill_1_sg',
			eq = false,
			isghosskill = true, --使用我得xml
			costs = {
				tz_sama = 30,
			},
		},

		[10] = { 
			tex = "ghostskill_image2",
			txt = "ghostskill2",
			key = "huahua_skill_2_key",
			cd = 3.5,
			sg = 'huahua_skill_2_sg',
			eq = false,
			isghosskill = true, --使用我得xml
			costs = {
				tz_sama = 20,
			},
		},

		[11] = { 
			tex = "ghostskill_image3",
			txt = "ghostskill3",
			key = "huahua_skill_3_key",
			cd = 8,
			sg = 'huahua_skill_3_sg',
			eq = false,
			isghosskill = true, --使用我得xml
			costs = {
				tz_sama = 15,
			},
		},

		[12] = { 
			tex = "ghostskill_image4",
			txt = "ghostskill4",
			key = "huahua_skill_4_key",
			cd = 60,
			sg = 'huahua_skill_4_sg',
			eq = false,
			isghosskill = true, --使用我得xml
			costs = {
				tz_sama = 50,
			},
		},
		
		-- [7] = { tex = "guitar_skill",txt = "guitar_skill_desc",key = "guitar_skill_key",cd = 3,eq = true,clientfn = nil},
	},
	{
		[1] = { tex = "NaiRe01", txt = "NaiRe01_B", key = "NaiRe01" },
		[2] = { tex = "NaiRe02", txt = "NaiRe02_B", key = "NaiRe02" },
		[3] = { tex = "NaiHan01", txt = "NaiHan01_B", key = "NaiHan01" },
		[4] = { tex = "NaiHan02", txt = "NaiHan02_B", key = "NaiHan02" },
		[5] = { tex = "DaWeiWang", txt = "DaWeiWang_B", key = "DaWeiWang" },
		[6] = { tex = "ShiShen", txt = "ShiShen_B", key = "ShiShen02" },
		[7] = { tex = "ShuJiAiHaoZhe", txt = "ShuJiAiHaoZhe_B", key = "ShuJiAiHaoZhe" },
		[8] = { tex = "BeiShuiYiZhan", txt = "BeiShuiYiZhan_B", key = "BeiShuiYiZhan" },
		[9] = { tex = "XueJuRen", txt = "XueJuRen_B", key = "XueJuRen" },
		[10] = { tex = "WaErJiLi", txt = "WaErJiLi_B", key = "WaErJiLi" },
		[11] = { tex = "JianZhenRouDian", txt = "JianZhenRouDian_B", key = "JianZhenRouDian" },
		[12] = { tex = "JuShouLieShou", txt = "JuShouLieShou_B", key = "JuShouLieShou" },
		[13] = { tex = "SuoXiang", txt = "SuoXiang_B", key = "SuoXiang" },
		
		[14] = { tex = "SiRenBaoXianGongSi", txt = "SiRenBaoXianGongSi_B", key = "SiRenBaoXianGongSi" },
		[15] = { tex = "TeJiChuShi", txt = "TeJiChuShi_B", key = "TeJiChuShi" },
	}
}


_G.QMSkTable = QMSkTable

local QMSkTablKey = {}
for k,v in pairs(QMSkTable[1]) do
	QMSkTablKey[v.key] = { tex = v.tex, txt = v.txt, key = v.key, cd = v.cd, sg = v.sg, eq = v.eq,range = v.range,costs = v.costs }
end

local function IsValPlayer( inst )
	if inst and not inst:HasTag("playerghost") and inst.replica.inventory and not inst:HasTag("busy") then
		local inv = inst.replica.inventory
		if inv:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil then
			return true
		end
	end
	return false
end

local function IsDaiWu(inst)
	return inst and inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil
end

local function KIsValSg(inst)
	return not ( inst.replica.health:IsDead() or
	( inst.sg ~= nil and (inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("dead")
	or inst.sg:HasStateTag("drowning") or inst.sg:HasStateTag("sleeping") ) ) or
	inst:HasTag("busy") or inst.replica.rider:IsRiding() ) and not ( TheFrontEnd:GetOpenScreenOfType("ChatInputScreen") or
	TheFrontEnd:GetOpenScreenOfType("ConsoleScreen") )
end

local function DoRPC( key, target )
	local x, y, z = TheSim:ProjectScreenPos(TheSim:GetPosition())

	-- 限定最大距离
	local range = QMSkTablKey[key] and QMSkTablKey[key].range
	if range ~= nil then 
		local player_pos = ThePlayer:GetPosition()
		local target_pos = Vector3(x,y,z)
		local vec_pos = target_pos - player_pos
		local vec_pos_norm = vec_pos:GetNormalized()
		if vec_pos:Length() > range then 
			x,y,z = (player_pos + vec_pos_norm * range):Get()
		end
	end

	if TheWorld and TheWorld.ismastersim then
		if KIsValSg(ThePlayer) then
			local sg = QMSkTablKey[key] and QMSkTablKey[key].sg
			if sg and ThePlayer.sg and ThePlayer.sg:HasState(sg) then
				ThePlayer.sg:GoToState(sg, Point(x,0,z))
			end
		end
	else
		local clientfn = QMSkTablKey[key] and QMSkTablKey[key].clientfn
		if clientfn then 
			clientfn(ThePlayer,x,y,z,target)
		end
		SendModRPCToServer(MOD_RPC.QMRPCSK.SK, "DoSk", key, x, z, target)
	end
end

local function IsValSg(inst)
	return not ( inst.components.health:IsDead() or inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("dead")
	or inst.sg:HasStateTag("drowning") or inst.sg:HasStateTag("sleeping") or inst.components.rider:IsRiding() )
end



---===================================================鬼人的技能
local function ToggleOffPhysics(inst)
    inst.sg.statemem.isphysicstoggle = true
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
	inst.Physics:CollidesWith(COLLISION.WORLD)
end

local function ToggleOnPhysics(inst)
    inst.sg.statemem.isphysicstoggle = nil
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end
local xu = {{0,1},{1,1},{1,-1},{0,-1}}

local function GoAngle(player, w, h)
	local t = {}
	local d = player.entity
	for i,v in ipairs(xu) do
		local x,_,z = d:LocalToWorldSpace(v[1] * h, 0, v[2] * w)
		table.insert(t, {x,z})
	end
	local range = ( ( w * w ) + ( h * h ) ) ^ 0.5
	return t, range, Point( d:LocalToWorldSpace(h * 0.5, 0, 0) )
end
local REPEL_RADIUS = 0.5
local REPEL_RADIUS_SQ = REPEL_RADIUS * REPEL_RADIUS

local function GetPositionAdjacentTo(p1, p2,distance)
    local offset = p1-p2
    offset:Normalize()
    offset = offset * distance
    return (p2 + offset)
end
local function UpdateRepel(inst,creatures)
    for i = #creatures, 1, -1 do
        local v = creatures[i]
        if not (v.inst:IsValid() and v.inst.entity:IsVisible() and v.inst.tz_touyingpos) then
            table.remove(creatures, i)
		else
            local distsq = v.inst:GetDistanceSqToPoint(v.inst.tz_touyingpos.x, 0, v.inst.tz_touyingpos.z)
            if distsq > REPEL_RADIUS_SQ  then
				local new = GetPositionAdjacentTo(v.inst.tz_touyingpos, v.inst:GetPosition(),1)
				v.inst.Transform:SetPosition(new:Get())
			end
		end
    end
end

local function SingleUpdateRepel(inst,range)
	if inst:IsValid() and inst.entity:IsVisible() and inst.tz_touyingpos_4 and inst.components.locomotor then
		local distsq = inst:GetDistanceSqToPoint(inst.tz_touyingpos_4.x, 0, inst.tz_touyingpos_4.z)
		if distsq > 1  then
			local new = GetPositionAdjacentTo(inst.tz_touyingpos_4, inst:GetPosition(),range or 0.2)
			inst.Transform:SetPosition(new:Get())
		end
	end
end
--ThePlayer.Physics:SetMotorVelOverride(math.sin(60* DEGREES) * 6, 0, math.cos(60* DEGREES) * 6)

local function TimeoutRepel(inst, creatures, task)
    task:Cancel()
    for i, v in ipairs(creatures) do
        if v.speed ~= nil then
            v.inst.Physics:ClearMotorVelOverride()
            v.inst.Physics:Stop()
        end
    end
end
local function GetTouYing( p1, p2,pos)
	local p3 = p1 - p2
	local p4 = pos - p1
	local p5 = p3:GetNormalized()
	local len = p4:Dot( p5 )
    return p1 + p5 * len
end

local function CalcDamage(self,target, damage,adddamage)
    if target:HasTag("alwaysblock") then
        return 0
    end
    local basedamage =  damage
    local basemultiplier = self.damagemultiplier
    local externaldamagemultipliers = self.externaldamagemultipliers
    local bonus = adddamage
    local playermultiplier = target ~= nil and target:HasTag("player")
    local pvpmultiplier = playermultiplier and self.inst:HasTag("player") and self.pvp_damagemod or 1
	local mount = nil
    playermultiplier = playermultiplier and self.playerdamagepercent or 1
    return basedamage
        * (basemultiplier or 1)
        * externaldamagemultipliers:Get()
        * playermultiplier
        * pvpmultiplier
        + (bonus or 0)
end

local function setfxscale(fx,target)
	local scale = (target:HasTag("smallcreature") and 1)
	or (target:HasTag("largecreature") and 2)
	or 1.5
	fx.Transform:SetScale(scale, scale, scale)
end
local function doauredamage(inst,x,y,z, range,tbl,damage,fx,domove,adddamage)
	if inst.owner and inst.owner:IsValid() and inst.owner.components.tzsama then
		inst.owner.ghost_samaskilladd = 0 
	end
	local ents = TheSim:FindEntities(x,y,z, range, {"_combat","_health"},{"companion","FX","NOCLICK","DECOR","INLIMBO","player","playerghost"})
	for k,v in pairs(ents) do
		if v ~= inst and v:IsValid() and v.components.combat and v.components.health ~= nil and not v.components.health:IsDead() then
			local x2,y2,z2 = v.Transform:GetWorldPosition()

			if type(tbl) == "table" then
				if  TheSim:WorldPointInPoly(x2,z2, tbl) then
					if inst.owner and inst.owner:IsValid() and inst.owner.components.combat then
						v.components.combat:GetAttacked(inst.owner,CalcDamage(inst.owner.components.combat,v, damage,adddamage))
						if inst.owner.components.tzsama and inst.owner.ghost_samaskilladd and (inst.owner.ghost_samaskilladd < 10) then
							inst.owner.ghost_samaskilladd = inst.owner.ghost_samaskilladd + 2
							inst.owner.components.tzsama:DoDelta(2, true)
						end
						setfxscale(v:SpawnChild(fx),v)
						if domove then
							if not v.tz_touyingpos_4 then
								v.tz_touyingpos_4 =  Point(x,y,z)
							end
							SingleUpdateRepel(v)
						end
					end
				end
			elseif type(tbl) == "number" and math.abs(v:GetAngleToPoint(x, y, z)) < tbl then
				if inst.owner and inst.owner:IsValid() and inst.owner.components.combat then
					v.components.combat:GetAttacked(inst.owner,CalcDamage(inst.owner.components.combat,v, damage,adddamage))
					if inst.owner.components.tzsama and inst.owner.ghost_samaskilladd and (inst.owner.ghost_samaskilladd < 10) then
						inst.owner.ghost_samaskilladd = inst.owner.ghost_samaskilladd + 2
						inst.owner.components.tzsama:DoDelta(2, true)
					end
					setfxscale(v:SpawnChild(fx),v)
					if domove then
						if not v.tz_touyingpos_4 then
							v.tz_touyingpos_4 =  Point(x,y,z)
						end
						SingleUpdateRepel(v)
					end
				end
			else
				if inst.owner.components.combat then
					v.components.combat:GetAttacked(inst.owner,CalcDamage(inst.owner.components.combat,v, damage,adddamage))
					if inst.owner.components.tzsama and inst.owner.ghost_samaskilladd and (inst.owner.ghost_samaskilladd < 10) then
						inst.owner.ghost_samaskilladd = inst.owner.ghost_samaskilladd + 2
						inst.owner.components.tzsama:DoDelta(2, true)
					end
					setfxscale(v:SpawnChild(fx),v)
					if domove then
						if not v.tz_touyingpos_4 then
							v.tz_touyingpos_4 =  Point(x,y,z)
						end
						SingleUpdateRepel(v)
					end
				end
			end
		end
	end	
end
local function huahua_skill_1_fn(inst)
	local player = inst
	if player then
		local fx = SpawnPrefab("tz_darkhand_fx_one")
		local x,y,z = player.Transform:GetWorldPosition()
		fx.Transform:SetPosition(x,y,z)
		fx.Transform:SetRotation(player.Transform:GetRotation() + 90 )
		local x1,y1,z1 = player.entity:LocalToWorldSpace(0, 0, 2)

		local rate = player.components.tzsama and player.components.tzsama.max*0.001 or 0
		local damage =  player.components.tzsama and player.components.tzsama.max*0.1 or 0
		--print("技能1",rate)
		fx.Transform:SetScale(0.9+rate, 0.9+rate, 0.9+rate)--动画大小默认开始 0.9
		local tbl, range, p = GoAngle(player, 4*(1+rate), 8*(1+rate))
		fx.owner = player
		fx:DoTaskInTime(0.6,function()
			ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .05, .2, fx, 40)
			fx.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
			doauredamage(fx,x,y,z, range,tbl,12,"tz_darkhand_fx_fx2",false,damage) --12伤害
		end)

		fx:DoTaskInTime(0.917,function()
			fx.dodamage_task = fx:DoPeriodicTask(0.1,function()
				doauredamage(fx,x,y,z, range,tbl,12,"tz_darkhand_fx_fx1",false,damage) --12
				fx.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/out")
			end,0.1)
			fx.dodamage_task.limit = 3

			local creatures = {}
			local ents = TheSim:FindEntities(x,y,z, range, {"_combat","_health"},{"FX","NOCLICK","DECOR","INLIMBO","player","playerghost"})
			for k,v in pairs(ents) do
				if v:IsValid() and v.Physics ~= nil and v.components.locomotor then
					local x2,y2,z2 = v.Transform:GetWorldPosition()
					local new = GetTouYing( Point(x,y,z),Point(x1,y1,z1),Point(x2,y2,z2))
					if  TheSim:WorldPointInPoly(x2,z2, tbl) then
						v.tz_touyingpos = new
						table.insert(creatures, { inst = v })
					end
				end
			end
			if #creatures > 0 then
				fx:DoTaskInTime(0.2, TimeoutRepel, creatures,
				fx:DoPeriodicTask(0, UpdateRepel, nil,creatures)
				)
			end
		end)
	end
end

local function huahua_skill_2_fn(inst)
	local player = inst
	if  player then
		local fx = SpawnPrefab("tz_darkhand_fx_two")
		local x,y,z = player.Transform:GetWorldPosition()
		fx.Transform:SetPosition(x,y,z)
		fx.Transform:SetRotation(player.Transform:GetRotation() + 90 )

		local x1,y1,z1 = player.entity:LocalToWorldSpace(4, 0, 0)
		local rate = player.components.tzsama and player.components.tzsama.max*0.001 or 1
		local damage =  player.components.tzsama and player.components.tzsama.max*1 or 0
		--print("技能2",rate)
		fx.Transform:SetScale(1+rate, 1+rate, 1+rate)--动画大小默认开始 1
		local tbl, range, p = GoAngle(player, 8*(1+rate), 8*(1+rate)) 
		fx.owner = player

		fx.owner = player
		fx:DoTaskInTime(0.5,function()
			local creatures = {}
			local ents = TheSim:FindEntities(x,y,z, range, {"_combat","_health"},{"FX","NOCLICK","DECOR","INLIMBO","player","playerghost"})
			for k,v in pairs(ents) do
				if v:IsValid() and v.Physics ~= nil and v.components.locomotor then
					local x2,y2,z2 = v.Transform:GetWorldPosition()
					local new = GetTouYing( Point(x,y,z),Point(x1,y1,z1),Point(x2,y2,z2))
					if  TheSim:WorldPointInPoly(x2,z2, tbl) then
						v.tz_touyingpos = new
						table.insert(creatures, { inst = v })
					end
				end
			end
			if #creatures > 0 then
				fx:DoTaskInTime(0.1, TimeoutRepel, creatures,
				fx:DoPeriodicTask(0, UpdateRepel, nil,creatures)
				)
			end
		end)
		fx:DoTaskInTime(0.72,function()
			ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .05, .2, fx, 40)
			doauredamage(fx,x,y,z, range,tbl,50,"tz_darkhand_fx_fx2",false,damage) --50伤害
			fx.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/punchimpact")
		end)
	end
end
----=================================
-------------------------***************************************************************************---------------------------------
-------------------------***************************************************************************---------------------------------
-------------------------***************************************************************************---------------------------------
-------------------------***************************************************************************---------------------------------
if not TheNet:IsDedicated() then					--非服务端模式
	local QM_ALLUI = GLOBAL.require "widgets/qm_ui001"
	AddModRPCHandler("QMRPCSK", "SK", function() end)
	---------------------------------------------------
	AddClassPostConstruct("widgets/controls", function(self)
		self.inst:DoTaskInTime(0.1, function()
				self.kuojian = self:AddChild( QM_ALLUI.QM_GDCS( self.owner, AllCao, AllBCao ) )
				self.kuojian:MoveToBack()
				self.AllSkKey = {}
				self.AllSkCd = {}
				local KEY_TBL = {
					{ KEY_Z , 'Z' },
					{ KEY_X , 'X' },
					{ KEY_C , 'C' },
					{ KEY_V , 'V' }
				}
				for k,v in pairs(KEY_TBL) do
					self.AllSkKey[v[2]] = TheInput:AddKeyDownHandler(v[1], function()
						local x, y, z = TheSim:ProjectScreenPos(TheSim:GetPosition())
						if KIsValSg(ThePlayer) then
							local item = AllCao[k].shu and AllCao[k].shu.key or nil
							if item == nil or QMSkTablKey[item] == nil then
								return
							end
							if QMSkTablKey[item].eq and not IsDaiWu(ThePlayer) then
								if ThePlayer.components.talker then
									ThePlayer.components.talker:Say('需要佩戴武器才可释放此技能', 5, nil, nil, nil, {0,1,1,1})
								end
								return 
							end

							if QMSkTablKey[item].costs then 
								if QMSkTablKey[item].costs.hunger then 
									if ThePlayer.replica.hunger:GetCurrent() < QMSkTablKey[item].costs.hunger then 
										ThePlayer.components.talker:Say(string.format("饥饿不够，需要%d饥饿才能使用",QMSkTablKey[item].costs.hunger))
										return 
									end
								end

								if QMSkTablKey[item].costs.health then 
									if ThePlayer.replica.health:GetCurrent() < QMSkTablKey[item].costs.health then 
										ThePlayer.components.talker:Say(string.format("生命不够，需要%d生命才能使用",QMSkTablKey[item].costs.health))
										return 
									end
								end

								if QMSkTablKey[item].costs.sanity then 
									if ThePlayer.replica.sanity:GetCurrent() < QMSkTablKey[item].costs.sanity then 
										ThePlayer.components.talker:Say(string.format("精神不够，需要%d精神才能使用",QMSkTablKey[item].costs.sanity))
										return 
									end
								end


								if QMSkTablKey[item].costs.tz_sama then 
									if ThePlayer._tzsamacurrent == nil or ThePlayer._tzsamacurrent:value() < QMSkTablKey[item].costs.tz_sama then 
										ThePlayer.components.talker:Say(string.format("撒嘛不够，需要%d撒嘛才能使用",QMSkTablKey[item].costs.tz_sama))
										return 
									end
								end
							end
							local cd = QMSkTablKey[item].cd
							local timecd = GetTime()
							if item and cd and ( self.AllSkCd[item] == nil or ( timecd - self.AllSkCd[item] ) >= cd ) then
								DoRPC( item )
								if not ThePlayer.replica.inventory:EquipHasTag(item) then
									self.AllSkCd[item] = timecd
									AllCao[k]:DoCD(cd)
								end

								if not TheNet:IsDedicated() then 
									local sg = QMSkTablKey[item] and QMSkTablKey[item].sg
									if sg and ThePlayer.sg and ThePlayer.sg.sg.name == "wilson_client" and ThePlayer.sg:HasState(sg) then
										ThePlayer.sg:GoToState(sg, Point(x,0,z))
									end
								end 
							end
						end
					end)
				end
		end)
	end)
	--------------------------------------------------------------	SG行为组
	local qm_ljs01 = State({
		["name"] = "qm_ljs01",
		["tags"] = { "busy", "doing", "nomorph", "nopredict", "canrotate" },

		["onenter"] = function(inst, pos)
			if inst.components.locomotor then
				inst.components.locomotor:Stop()
			end
			inst:ClearBufferedAction()
			inst:ForceFacePoint(pos:Get())
			inst.AnimState:PlayAnimation("ljs")
		end,
	})
	-------------
	local qm_syshu01 = State({
		["name"] = "qm_syshu01",
		["tags"] = { "busy", "doing", "nomorph", "qm_syshu01", "canrotate" },

		["onenter"] = function(inst, pos)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			inst:ForceFacePoint(pos:Get())
			inst.AnimState:PlayAnimation("tiao_pre")
		end,
		
		["events"] = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("tiao_pre") then
                    inst.sg:GoToState("qm_syshu02")
                end
            end),
		},
	})
	
	local qm_syshu02 = State({
		["name"] = "qm_syshu02",
		["tags"] = { "busy", "doing", "nomorph", "qm_syshu02", "canrotate" },

		["onenter"] = function(inst, pos)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("tiao_loop")
			inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
		end,
		
		["ontimeout"] = function(inst)
            inst.sg:GoToState("idle")
        end,
		
		["events"] = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("tiao_loop") then
                    inst.sg:GoToState("idle")
                end
            end),
		},
	})
	-------------
	local qm_wmgd = State({
		["name"] = "qm_wmgd",
		["tags"] = { "busy", "doing", "nomorph", "nopredict", "qm_wmgd", "canrotate" },

		["onenter"] = function(inst, pos)
			if inst.components.locomotor then
				inst.components.locomotor:Stop()
			end
			inst:ClearBufferedAction()
			inst:ForceFacePoint(pos:Get())
			inst.AnimState:PlayAnimation("parry_pre")
			inst.AnimState:PushAnimation("parry_loop", true)
		end,
	})
	
	local qm_ruodian = State({
		["name"] = "qm_ruodian",
		["tags"] = { "busy", "doing", "nomorph", "qm_syshu02", "canrotate" },

		["onenter"] = function(inst)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("emote_slowclap")
			inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
		end,
		
		["ontimeout"] = function(inst)
            inst.sg:GoToState("idle")
        end,
		
		["timeline"] = {
			TimeEvent(30 * FRAMES, function(inst)
				TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/get_gold")
			end),
		},
		
		["events"] = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
		},
	})
	
	local qm_fangun = State({
		["name"] = "qm_fangun",
		["tags"] = { "busy", "doing", "nomorph", "qm_syshu02", "canrotate" },

		["onenter"] = function(inst, pos)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			inst:ForceFacePoint(pos:Get())
			inst.AnimState:PlayAnimation("fangun_pre")
			inst.AnimState:PushAnimation("fangun_loop", false)
			inst.AnimState:PushAnimation("fangun_pst", false)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/backpack_close")
			inst.sg:SetTimeout(1.5)
		end,
		
		["timeline"] = {
			TimeEvent(25 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
				inst.sg:RemoveStateTag("nomorph")
			end),
		},
		
		["ontimeout"] = function(inst)
            inst.sg:GoToState("idle")
        end,
	})

	local killknife_skill_sg = State{
		name = "killknife_skill_sg",
        tags = { "busy", "doing", "nomorph", "qm_syshu02", "canrotate" },
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("atk_leap_pre")	
			inst.AnimState:PushAnimation("atk_leap_lag",false)
			inst:ClearBufferedAction()
			inst.sg:SetTimeout(3.2)
		end,

		
		timeline =
		{

		},

		events =
		{
			EventHandler("unequip", function(inst)
                inst.sg:GoToState("idle")
            end),
		},
		
		ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
		


		onexit = function(inst)			

		end,
			
	}

	-- Client
	local fanta_blade_sg = State{
		name = "fanta_blade_sg",
        tags = { "busy","doing","nointerrupt","nomorph", "qm_syshu02", "canrotate"  },
		onenter = function(inst,pos)
			inst.components.locomotor:Stop()
			inst:ForceFacePoint(pos:Get())
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("tzskill_fanta_blade_pre")	
			inst.AnimState:PushAnimation("tzskill_fanta_blade_loop",false)
			inst.AnimState:PushAnimation("tzskill_fanta_blade_pst",false)
		end,

		events =
		{
			-- EventHandler("unequip", function(inst)
   --              inst.sg:GoToState("idle")
   --          end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("tzskill_fanta_blade_pst") then                	
                    inst.sg:GoToState("idle",true)
                end
            end),
		},
			
	}
	
	AddStategraphPostInit("wilson_client", function(sg)
		sg.states["qm_ljs01"] = qm_ljs01
		sg.states["qm_wmgd"] = qm_wmgd
		sg.states["qm_syshu01"] = qm_syshu01
		sg.states["qm_syshu02"] = qm_syshu02
		sg.states["qm_ruodian"] = qm_ruodian
		sg.states["qm_fangun"] = qm_fangun

		sg.states["killknife_skill_sg"] = killknife_skill_sg
		sg.states["fanta_blade_sg"] = fanta_blade_sg
	end)
	---------------------------------------------------------------------------------
	local HaiLiLvJing = {
		day="images/colour_cubes/beaver_vision_cc.tex",
		dusk="images/colour_cubes/beaver_vision_cc.tex",
		night="images/colour_cubes/beaver_vision_cc.tex",
		full_moon="images/colour_cubes/beaver_vision_cc.tex",
	}
	
	local function qm_kaideng(inst, bool)
		if inst._dengkai ~= nil then
			inst._dengkai:Cancel()
			inst._dengkai = nil
		end
		if bool then
			inst._dengkai = inst:DoPeriodicTask(1, function()
				if TheWorld and TheWorld:HasTag("cave") --[[TheWorld.state.isnight]] then
					if not inst.HUD.beaverOL:IsVisible() then
						if inst.components.playervision then
							inst.components.playervision:ForceNightVision(true)
							inst.components.playervision:SetCustomCCTable(HaiLiLvJing)
							if inst.HUD.beaverOL then
								inst.HUD.beaverOL:Show()
							end
						end
					end
				elseif inst.HUD.beaverOL:IsVisible() then
					if inst.components.playervision then
						inst.components.playervision:ForceNightVision(false)
						inst.components.playervision:SetCustomCCTable(nil)
					end
					if inst.HUD.beaverOL then
						inst.HUD.beaverOL:Hide()
					end
				end
			end, 0)
		else
			if inst.HUD.beaverOL then
				inst.HUD.beaverOL:Hide()
			end
			if inst.components.playervision then
				inst.components.playervision:ForceNightVision(false)
			end
		end
	end

	AddPlayerPostInit(function(inst)
		inst._KaiDeng = qm_kaideng
	end)
end
-------------------------***************************************************************************---------------------------------
-------------------------***************************************************************************---------------------------------
-------------------------***************************************************************************---------------------------------
-------------------------***************************************************************************---------------------------------
-------------------------***************************************************************************---------------------------------
if TheNet:GetIsServer() then	------------------------------------------服务端模式
	local function LJS_DoFn( inst )
		local x,_,z = inst.Transform:GetWorldPosition()
		local qmcombat = inst.components.combat
		local ens = TheSim:FindEntities(x, 0, z, 3, {"_combat","_health"}, {"FX","NOCLICK","DECOR","INLIMBO","nightmarecreature","player"})
		for i,v in ipairs(ens) do
			if inst ~= v and v:IsValid() and not v.components.health:IsDead() and ( v.components.follower == nil
			or v.components.follower:GetLeader() ~= inst ) then
				v.components.combat:GetAttacked(inst, qmcombat:CalcDamage(v, qmcombat:GetWeapon()) + 150 )
				SpawnPrefab("sk_fx10"):SetTargetPos( v:GetPosition() )
			end
		end
	end
	
	local function BeiShui_fn(inst, data)
		if not inst.components.health:IsDead() and not inst:HasTag("playerghost") then
			if inst.beishuibuff == nil and inst.components.health:GetPercent() <= 0.1 then
				inst.player_classified.qm_beishuibuff:set(true)
				inst.beishuibuff = true
				inst.components.combat.externaldamagemultipliers:SetModifier(inst, 3, "BeiShui")
				inst.components.locomotor:SetExternalSpeedMultiplier(inst, "BeiShui", 1.5)
			elseif inst.beishuibuff and inst.components.health:GetPercent() >= 0.1 then
				inst.beishuibuff = nil
				inst.player_classified.qm_beishuibuff:set(false)
				inst.components.combat.externaldamagemultipliers:SetModifier(inst, nil, "BeiShui")
				inst.components.locomotor:SetExternalSpeedMultiplier(inst, "BeiShui", nil)
			end
		end
	end
	
	local function WaErJiLi_fn(inst, data)
		if inst._WaErJiLi_cd == nil or ( os.time() - inst._WaErJiLi_cd ) > 8 * 60 then
			inst._WaErJiLi_cd = os.time()
			inst:DoTaskInTime(0.1, function()
				local target = SpawnPrefab("amulet")
				target.AnimState:SetMultColour(0, 0, 0, 0)
				target.Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst:PushEvent("respawnfromghost", { source = target })
				inst.rezsource = "【瓦尔基里】"
			end)
		end
	end
	----------------------------------------------------------------------
	local preparedfoods_warly = require("preparedfoods_warly")
	local function killed(inst, data)
		if math.random() < 0.01 then
			for k, v in pairs(preparedfoods_warly) do
				if math.random() < 0.2 then
					local a = SpawnPrefab(k)
					if a then
						a.Transform:SetPosition(inst.Transform:GetWorldPosition())
					end
					break
				end
			end
		end
	end
	local JiNengZL = {
		[5] = function(inst, bool)
			if inst.components.hunger then
				if bool then
					--local num = inst.components.hunger.current
					--inst.components.hunger:SetMax(TUNING.WILSON_HUNGER + 200)
					--inst.components.hunger.current = math.min( TUNING.WILSON_HUNGER + 200, num )
					inst.components.hunger.burnratemodifiers:SetModifier(inst, 1.2, "DaWeiWang")
					if inst.qmsktbl2[2][6] == nil and inst.components.eater then
						inst.components.eater:SetAbsorptionModifiers(1, 1.5, 1)
					end
				else
					if inst.qmsktbl2[2][6] == nil and inst.components.eater then
						inst.components.eater:SetAbsorptionModifiers(1, 1, 1)
					end
					--local num = inst.components.hunger.current
					--inst.components.hunger:SetMax(TUNING.WILSON_HUNGER)
					--inst.components.hunger.current = math.min( TUNING.WILSON_HUNGER, num )
					inst.components.hunger.burnratemodifiers:SetModifier(inst, nil, "DaWeiWang")
				end
			end
		end,
		
		[6] = function(inst, bool)
			if inst.components.eater then
				if bool then
					inst.components.eater:SetAbsorptionModifiers(1.25, 1.25, 1.25)
				else
					if inst.qmsktbl2[2][5] == nil then
						inst.components.eater:SetAbsorptionModifiers(1, 1.5, 1)
					else
						inst.components.eater:SetAbsorptionModifiers(1, 1, 1)
					end
				end
			end
		end,
		
		[7] = function(inst, bool)
			if bool then
				inst:AddTag("reader")
				inst:AddTag("bookbuilder")
				inst:AddComponent("reader")
				inst.player_classified.qm_shuj:set(true)
			else
				inst:RemoveTag("reader")
				inst:RemoveTag("bookbuilder")
				inst:RemoveComponent("reader")
				inst.player_classified.qm_shuj:set(false)
			end
		end,
		
		[8] = function(inst, bool)
			if bool then
				BeiShui_fn(inst)
				inst:ListenForEvent("healthdelta", BeiShui_fn)
			else
				inst:RemoveEventCallback("healthdelta", BeiShui_fn)
				inst.player_classified.qm_beishuibuff:set(false)
				inst.beishuibuff = nil
				inst.components.locomotor:SetExternalSpeedMultiplier(inst, "BeiShui", nil)
				inst.components.combat.externaldamagemultipliers:SetModifier(inst, nil, "BeiShui")
			end
		end,
		
		[9] = function(inst, bool)
			if bool then
				if TheWorld and TheWorld:HasTag("cave") then
					inst.player_classified.qm_xjr:set_local(true)
					inst.player_classified.qm_xjr:set(true)
					if inst.components.sanity then
						inst.components.sanity.night_drain_mult = 0
					end
					if inst.components.playervision then
						inst.components.playervision:ForceNightVision(true)
					end
				end
			else
				inst.player_classified.qm_xjr:set_local(false)
				inst.player_classified.qm_xjr:set(false)
				if inst.components.sanity then
					inst.components.sanity.night_drain_mult = 1
				end
				if inst.components.playervision then
					inst.components.playervision:ForceNightVision(false)
				end
			end
		end,
		
		[10] = function(inst, bool)
			if bool then
				inst:ListenForEvent("ms_becameghost", WaErJiLi_fn)
			else
				inst:RemoveEventCallback("ms_becameghost", WaErJiLi_fn)
			end
		end,
		
		[11] = function(inst, bool)
			if bool then
				if inst.components.inventory.damget_fn == nil then
					inst.components.inventory.damget_fn = inst.components.inventory.ApplyDamage
				end
				inst.components.inventory.ApplyDamage = function(self, ...)
					local num = inst.components.inventory.damget_fn(self, ...)
					if num then
						num = num * 0.8
					end
					return num
				end
			else
				if inst.components.inventory.damget_fn then
					inst.components.inventory.ApplyDamage = inst.components.inventory.damget_fn
				end
			end
		end,
		
		[12] = function(inst, bool)
			if bool then
				if inst.components.combat.qm_CalcDamage_fn02 == nil then
					inst.components.combat.qm_CalcDamage_fn02 = inst.components.combat.CalcDamage
				end
				inst.components.combat.CalcDamage = function(self, target, ...)
					local num = inst.components.combat.qm_CalcDamage_fn02(self, target, ...)
					if target:HasTag("largecreature") and num > 0 then
						num = num * 1.5
					end
					return num
				end
			else
				if inst.components.combat.qm_CalcDamage_fn02 ~= nil then
					inst.components.combat.CalcDamage = inst.components.combat.qm_CalcDamage_fn02
				end
			end
		end,
		
		[13] = function(inst, bool)
			if bool then
				if inst.components.inventory.qm_DropEverything_fn03 == nil then
					inst.components.inventory.qm_DropEverything_fn03 = inst.components.inventory.DropEverything
				end
				inst.components.inventory.DropEverything = function() end
			else
				if inst.components.inventory.qm_DropEverything_fn03 ~= nil then
					inst.components.inventory.DropEverything = inst.components.inventory.qm_DropEverything_fn03
				end
			end
		end,
		[15] = function(inst, bool)
			if bool then
				inst:ListenForEvent("killed", killed)
			else
				inst:RemoveEventCallback("killed", killed)
			end
		end,
	}
	
	local RPC_TBL = {
		["DoSk"] = function( player, key, x, z, target )
			if isnum(x) and isnum(z) then
				for k, v in pairs(player.components.inventory.equipslots) do
					if v:HasTag(key) and v.DoSk ~= nil then
						v:DoSk(key)
						break
					end
				end
				player:PushEvent( "qm_dosk", { key = key, pos = Point(x,0,z), target = target } )
			end
		end,
		
		["TAB"] = function( player, tab1, tab2, zu )
			if isnum(tab1) and isnum(tab2) and isnum(zu) then
				local ennet = player.player_classified
				if ennet then
					local tbl = zu > 1 and ennet.AllZSk or ennet.AllBSk
					if tbl and tbl[tab1] and tbl[tab2] then
						local num1, num2 = player.qmsktbl[zu][tab1], player.qmsktbl[zu][tab2]
						player.qmsktbl[zu][tab1], player.qmsktbl[zu][tab2] = player.qmsktbl[zu][tab2], player.qmsktbl[zu][tab1]
						tbl[tab1]:set_local(num2)
						tbl[tab2]:set_local(num1)
					end
				end
			end
		end,
		
		["YiWang"] = function(player, key, zu)
			if isnum(key) and isnum(zu) then
				local ennet = player.player_classified
				local tbl = zu > 1 and ennet.AllBSk or ennet.AllZSk
				local tbl2 = player.qmsktbl[zu]
				if tbl and tbl2 and tbl[key] and tbl2[key] then
					local num = tbl2[key]
					if JiNengZL[num] then
						JiNengZL[num](player, false)
					end
					player.qmsktbl2[zu][tbl2[key]] = nil
					tbl[key]:set_local(0)
					tbl2[key] = 0
				end
			end
		end,
	}
	---------------
	AddModRPCHandler("QMRPCSK", "SK", function( player, rpckey, ... )
		if rpckey and RPC_TBL[rpckey] then
			RPC_TBL[rpckey](player, ...)
		end
	end)

	local qm_ljs01 = State({
		["name"] = "qm_ljs01",
		["tags"] = { "busy", "doing", "nomorph", "nopredict", "nointerrupt", "canrotate" },

		["onenter"] = function(inst, pos)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
			inst.components.locomotor:StopMoving()
			inst:ClearBufferedAction()
			inst:ForceFacePoint(pos:Get())
			inst.AnimState:PlayAnimation("ljs", true)
			inst.AnimState:SetTime( 0.148 )
			
			inst.sg.statemem.ms = 500
			inst.sg.statemem.cd = 0.1
			inst.sg.statemem.pos = pos
			
			local angle = inst.Transform:GetRotation()
			local fx = SpawnPrefab("sk_fx01")
			fx.AnimState:OverrideMultColour(1, 0, 0, 1)
			fx.Transform:SetPosition( inst.Transform:GetWorldPosition() )
			fx.Transform:SetRotation( inst.Transform:GetRotation() )
			local fx1 = SpawnPrefab("sk_fx03")
			fx1.Transform:SetPosition( inst.Transform:GetWorldPosition() )
			fx1.Transform:SetRotation( inst.Transform:GetRotation() )
			for i=0, 8, 1.5 do
				local px, _, pz = inst.entity:LocalToWorldSpace(i, 0, 0)
				inst.sg.statemem.speed = 56 * i / 8
				if not TheWorld.Map:IsPassableAtPoint( px, 0, pz ) then
					break
				end
			end
			if inst.sg.statemem.speed > 0 then
				inst.Physics:SetMotorVelOverride(inst.sg.statemem.speed, 0, 0)
			end
			if inst.components.hunger then
				inst.components.hunger:DoDelta(-20, true)
			end
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/attack")
		end,
		
		['onupdate'] = function(inst, dt)
			local logn = inst.AnimState:GetCurrentAnimationLength()
			local timec = math.min(logn, inst.AnimState:GetCurrentAnimationTime() + dt)
			if inst.sg.statemem.speed > 0 then
				if TheWorld.Map:IsPassableAtPoint( inst.entity:LocalToWorldSpace(1.5, 0, 0) ) then
					inst.Physics:SetMotorVelOverride( inst.sg.statemem.speed * ( 1 - timec / logn ), 0, 0)
				else
					inst.sg.statemem.speed = 0
					inst.Physics:Stop()
				end
			end
			inst.sg.statemem.cd = inst.sg.statemem.cd - dt
			if inst.sg.statemem.cd <= 0 then
				inst.sg.statemem.cd = 0.1
				local x,y,z = inst.Transform:GetWorldPosition()
				local angle = inst.Transform:GetRotation()
				local fx = SpawnPrefab("sk_fx02")
				fx.AnimState:SetLayer(LAYER_BACKGROUND)
				fx.AnimState:SetPercent("shadow", timec)
				fx.AnimState:SetSortOrder(0)
				fx.Transform:SetRotation( angle )
				fx.Transform:SetPosition( x,y,z )
				fx:DoPeriodicTask(FRAMES, function(fx)
					local r,b,g,a = fx.AnimState:GetMultColour()
					fx.AnimState:SetMultColour(r * 0.7, b * 0.7, g * 0.7, a * 0.7)
				end, FRAMES)
				fx:DoTaskInTime(0.4, fx.Remove)
				LJS_DoFn( inst )
			end
			if timec >= logn then
				inst.sg:RemoveStateTag("busy")
				inst.sg:GoToState("idle", true)
			end
		end,
		
		["timeline"] = {
			TimeEvent(4 * FRAMES, function(inst)
				local fx = SpawnPrefab("sk_fx15")
				inst.sg.statemem.fx = fx
				fx.entity:SetParent(inst.entity)
				fx.Transform:SetRotation( inst.Transform:GetRotation() )
            end),
		
            TimeEvent(14 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
				if inst.components.playercontroller ~= nil then
					inst.components.playercontroller:Enable(true)
				end
            end),
		},
		
		["onexit"] = function(inst)
			if inst.components.playercontroller ~= nil then
				inst.components.playercontroller:Enable(true)
			end
			if inst.sg.statemem.fx and inst.sg.statemem.fx:IsValid() then
				inst.sg.statemem.fx.entity:SetParent(nil)
				inst.sg.statemem.fx:Remove()
			end
			inst.Physics:Stop()
		end,
	})
	-------------
	local function DoGeDang_fn( time )
		local timec = time
		local bool = true
		return function(inst, attacker, damage)
			if not inst.components.health:IsDead() and attacker then
				local ang = inst.Transform:GetRotation()
				local x,y,z = attacker.Transform:GetWorldPosition()
				local angle = inst:GetAngleToPoint( x,0,z )
				local drot = math.abs( ang - angle )
				while drot > 180 do
                        drot = math.abs(drot - 360)
				end
				if drot > 135 then
					inst.sg:RemoveStateTag("nointerrupt")
					return damage
				end
				if bool then
					bool = nil
					local ti = GetTime() - timec
					if ti >= 0.75 and ti <= 1.75 then
						damage = 0
					end
				end
				if damage > 40 then
					damage = damage * 0.2
				else
					damage = 0
				end
				if inst.sg:HasStateTag("qm_wmgd") then
					inst.AnimState:PlayAnimation("parryblock")
					inst.AnimState:PushAnimation("parry_loop", true)
					if inst.SoundEmitter then
						inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
					end
					if inst.sg.statemem.fx1 ~= nil and inst.sg.statemem.fx1:IsValid() then
						local fx = inst.sg.statemem.fx1
						inst.sg.statemem.fx1 = nil
						fx.entity:SetParent(nil)
						fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
						fx.AnimState:Pause()
						ErodeAway(fx, 1)
					end
				end
			end
			return damage
		end
	end
	local qm_wmgd = State({
		["name"] = "qm_wmgd",
		["tags"] = { "busy", "doing", "nomorph", "nopredict", "qm_wmgd", "nointerrupt", "canrotate" },

		["onenter"] = function(inst, pos)
			if inst.components.locomotor then
				inst.components.locomotor:Stop()
			end
			inst:ClearBufferedAction()
			inst:ForceFacePoint(pos:Get())
			inst.AnimState:PlayAnimation("parry_loop", true)
			inst.sg:SetTimeout(3.6)
			inst.components.combat.qmtabfn = DoGeDang_fn(GetTime())
			local fx = SpawnPrefab("sk_fx06")
			inst.sg.statemem.fx = fx
			fx.entity:SetParent(inst.entity)
			fx.Transform:SetRotation(0)
			local fx1 = SpawnPrefab("sk_fx07")
			inst.sg.statemem.fx1 = fx1
			fx1.entity:SetParent(inst.entity)
		end,
		
        ["ontimeout"] = function(inst)
			inst.components.combat.qmtabfn = nil
			inst.AnimState:PlayAnimation("parry_pst")
			inst.sg:GoToState("idle", true)
        end,
		
		["timeline"] = {
            TimeEvent(10 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
				inst.sg:RemoveStateTag("nopredict")
            end),
		},
		
		["onexit"] = function(inst)
			inst.components.combat.qmtabfn = nil
			if inst.sg.statemem.fx and inst.sg.statemem.fx:IsValid() then
				inst.sg.statemem.fx:Remove()
				inst.sg.statemem.fx = nil
			end
			if inst.sg.statemem.fx1 and inst.sg.statemem.fx1:IsValid() then
				inst.sg.statemem.fx1:Remove()
				inst.sg.statemem.fx1 = nil
			end
		end,
	})
	------------------
	local qm_syshu01 = State({
		["name"] = "qm_syshu01",
		["tags"] = { "busy", "doing", "nomorph", "qm_syshu01", "canrotate" },

		["onenter"] = function(inst, pos)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			inst:ForceFacePoint(pos:Get())
			inst.AnimState:PlayAnimation("tiao_pre")
			if inst.components.sanity then
				inst.components.sanity:DoDelta(-35, true)
			end
		end,
		
		["events"] = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("tiao_pre") then
                    inst.sg:GoToState("qm_syshu02")
                end
            end),
		},
	})
	
	local qm_syshu02 = State({
		["name"] = "qm_syshu02",
		["tags"] = { "busy", "doing", "nomorph", "qm_syshu02", "canrotate" },

		["onenter"] = function(inst)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("tiao_loop")
			inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
		end,
		
		["ontimeout"] = function(inst)
            inst.sg:GoToState("idle")
        end,
		
		["timeline"] = {
            TimeEvent(10 * FRAMES, function(inst)
				local x,y,z = inst.entity:LocalToWorldSpace(1, 0, 0)
				if TheWorld.Map:IsPassableAtPoint( x,y,z ) then
					local fx = SpawnPrefab("sk_fx11")
					fx.Transform:SetPosition( x, 0, z)
				end
            end),
		},
		
		["events"] = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("tiao_loop") then
                    inst.sg:GoToState("idle")
                end
            end),
		},
	})
	
	local AllRuoDianTarget = {}
	local function DoFXGC(inst)
		if AllRuoDianTarget[inst] then
			local fx = AllRuoDianTarget[inst].fx
			if fx and fx:IsValid() then
				fx.entity:SetParent(nil)
				fx:Remove()
			end
			AllRuoDianTarget[inst] = nil
			inst:RemoveEventCallback("onremove", DoFXGC)
		end
	end
	local function DoRuoDianGanZhi(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		local ens = TheSim:FindEntities(x, 0, z, 16, {"_combat","_health"}, {"FX","NOCLICK","DECOR","INLIMBO","nightmarecreature"})
		for k,v in pairs(ens) do
			if v and not v:HasTag("player") and ( v.components.follower == nil or v.components.follower:GetLeader() == nil or 
			not v.components.follower:GetLeader():HasTag("player")) and not v.components.health:IsDead() then
				if AllRuoDianTarget[v] == nil then
					local targetfx = SpawnPrefab('sk_fx12')
					AllRuoDianTarget[v] = { fx = targetfx }
					targetfx.entity:SetParent(v.entity)
					targetfx.Transform:SetPosition(0,2,0)
					inst:ListenForEvent("onremove", DoFXGC)
				end
				if AllRuoDianTarget[v].fn ~= nil then
					AllRuoDianTarget[v].fn:Cancel()
				end
				AllRuoDianTarget[v].fn = v:DoTaskInTime(40, DoFXGC)
			end
		end
	end
	
	local qm_ruodian = State({
		["name"] = "qm_ruodian",
		["tags"] = { "busy", "doing", "nomorph", "qm_syshu02", "canrotate" },

		["onenter"] = function(inst)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("emote_slowclap")
			inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			if inst.components.sanity then
				inst.components.sanity:DoDelta(-35, true)
			end
		end,
		
		["ontimeout"] = function(inst)
            inst.sg:GoToState("idle")
        end,
		
		["timeline"] = {
            TimeEvent(30 * FRAMES, DoRuoDianGanZhi),
			TimeEvent(31 * FRAMES, function(inst)
				local x,y,z = inst.Transform:GetWorldPosition()
				local fx01 = SpawnPrefab('sk_fx13')
				fx01.entity:SetParent(inst.entity)
				fx01.AnimState:SetScale(3,3)
				fx01.Transform:SetPosition(0, 3.5, 0)
			end),
		},
		
		["events"] = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
		},
	})
	
	
	local qm_fangun = State({
		["name"] = "qm_fangun",
		["tags"] = { "busy", "doing", "nomorph", "qm_syshu02", "canrotate" },

		["onenter"] = function(inst, pos)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			inst:ForceFacePoint(pos:Get())
			inst.AnimState:PlayAnimation("fangun_pre")
			inst.AnimState:PushAnimation("fangun_loop", false)
			inst.AnimState:PushAnimation("fangun_pst", false)
			inst.sg:SetTimeout(1.5)
			inst.Physics:SetMotorVelOverride(5.5, 0, 0)
			if inst.components.hunger then
				inst.components.hunger:DoDelta(-5, true)
			end
		end,
		
		["ontimeout"] = function(inst)
            inst.sg:GoToState("idle")
        end,
		
		["timeline"] = {
			TimeEvent(7 * FRAMES, function(inst)
				if inst.components.health and not inst.components.health:IsDead() then
					inst.components.health:SetInvincible(true)
				end
			end),
			
			TimeEvent(26 * FRAMES, function(inst)
				inst.components.locomotor:Stop()
				if inst.components.health then
					inst.components.health:SetInvincible(false)
				end
				inst.sg:RemoveStateTag("busy")
				inst.sg:RemoveStateTag("nomorph")
			end),
		},
		
		["events"] = {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
			
			EventHandler("blocked", function(inst)
                local x,y,z = inst.Transform:GetWorldPosition()
				local fx = SpawnPrefab("sk_fx14")
				if fx then
					ErodeAway(fx, 1)
					fx.AnimState:SetPercent("fangun_loop", inst.AnimState:GetCurrentAnimationLength())
					fx.Transform:SetRotation( inst.Transform:GetRotation() )
					fx.Transform:SetPosition(x,y,z)
				end
            end),
		},
		
		["onexit"] = function(inst)
			inst.components.locomotor:Stop()
			if inst.components.health then
				inst.components.health:SetInvincible(false)
			end
		end,
	})

	local function TzErodeAway(inst, erode_time)
	    local time_to_erode = erode_time or 1
	    local tick_time = TheSim:GetTickTime()

	    if inst.DynamicShadow ~= nil then
	        inst.DynamicShadow:Enable(false)
	    end

	    local thread = inst:StartThread(function()
	        local ticks = 0
	        while ticks * tick_time < time_to_erode do
	            local erode_amount = ticks * tick_time / time_to_erode
	            inst.AnimState:SetErosionParams(erode_amount, 0.1, 1.0)
	            ticks = ticks + 1
				Yield()
	        end
			inst:PushEvent("tz_erodeaway_finish")
	    end)
		
		return thread
	end

	local TzErodeAwayTime = 0.5
	local DoShadowAtkTime = 0.7

	local killknife_skill_sg = State{
		name = "killknife_skill_sg",
        tags = { "busy", "doing", "nomorph", "qm_syshu02", "canrotate"  },
		onenter = function(inst,pos)
			if inst.components.drownable ~= nil and inst.components.drownable.enabled then
				inst.sg.statemem.drownableenabled = true
				inst.components.drownable.enabled = false
			end
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("atk_leap_pre")	
			inst.AnimState:PushAnimation("atk_leap_lag",false)
			inst.components.health:SetInvincible(true)
			inst.components.playercontroller:Enable(false)
			inst.sg.statemem.TzErodeAwayTask = TzErodeAway(inst,TzErodeAwayTime)
			inst.sg:SetTimeout(3.2)

			inst.sg.statemem.pos = pos
		end,

		
		timeline =
		{
			TimeEvent(0.7, function(inst)
				inst.SoundEmitter:PlaySound("tz_killknife_fx/fx/killknife_skill")
			end),
			TimeEvent(DoShadowAtkTime, function(inst)
				local pos = inst.sg.statemem.pos or inst:GetPosition()
				local weapon = inst.components.combat:GetWeapon()
				local damage = weapon and weapon.components.weapon.damage or 10
						
				local newnums = 10 --math.random(4,6)
				local newdamage = 51
				local roa_little = math.random()*2*math.pi
						
				local sleeptime = 0.15 --math.min(0.1,0.4/newnums)
				local rad = 4.5
				
				inst.Transform:SetPosition(pos:Get())
				inst.sg.statemem.TzKillKnifeThread = inst:StartThread(function()
					for i = 1,newnums do 
						local roa = math.random()*2*math.pi
						local offset = Vector3(math.cos(roa)*rad,0,math.sin(roa)*rad)
						local shadow = SpawnAt("tz_shadow_killknife",pos+offset)
						shadow.caster = inst
                        shadow:ForceFacePoint(pos:Get())
						shadow:SetDamage(newdamage)
						shadow:Init(inst,nil,true,nil,true)
						shadow:StartShadows()
						Sleep(sleeptime)
					end
				end)

				inst.components.playercontroller:Enable(true)
				for k,v in pairs({"busy", "doing", "nomorph", "canrotate" }) do 
					inst.sg:RemoveStateTag(v)
				end
			end),
		},

		events =
		{
			EventHandler("unequip", function(inst)
                inst.sg:GoToState("idle")
            end),
		},
		
		ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
		
		onexit = function(inst)			
			if inst.DynamicShadow ~= nil then
				inst.DynamicShadow:Enable(true)
			end
			if inst.sg.statemem.TzErodeAwayTask then 
				KillThread(inst.sg.statemem.TzErodeAwayTask)
			end
			-- if inst.sg.statemem.TzKillKnifeThread then 
			-- 	KillThread(inst.sg.statemem.TzKillKnifeThread)
			-- end 

			inst.AnimState:SetErosionParams(0, 0, 1.0)
			inst.components.health:SetInvincible(true)
			inst:DoTaskInTime(1.5,function()
				inst.components.health:SetInvincible(false)
			end)
			if inst.sg.statemem.drownableenabled then
			inst:DoTaskInTime(5,function()
				if inst.components.drownable ~= nil then
					inst.components.drownable.enabled = true
				end
			end)
			end
			inst.components.playercontroller:Enable(true)
			SpawnAt("statue_transition",inst:GetPosition()).Transform:SetScale(1.5,1.5,1.5)
			SpawnAt("statue_transition_2",inst:GetPosition()).Transform:SetScale(1.5,1.5,1.5)
		end,
			
	}


	

	-- Server
	local pre_anim_time = 0.152
	local function CreateFantabladeTimeline(inst,anim_type,speed,vec_override)
		local face_vec = vec_override or GetFaceVector(inst) * 15
		local proj = SpawnAt("tz_jianqi",inst:GetPosition() + face_vec:GetNormalized() * 1.5)
		local tar_pos = inst:GetPosition()+face_vec
		proj.caster = inst
        proj.anim_type = anim_type
		
		proj:Launch(inst,tar_pos,speed)
	end
	local fanta_blade_sg = State{
		name = "fanta_blade_sg",
        tags = { "busy","doing","nointerrupt","nomorph", "qm_syshu02", "canrotate"  },
		onenter = function(inst,pos)
			for k,v in pairs(AllPlayers) do 
				if v and v:IsValid() and v:IsNear(inst,20) then 
					local ptype = (v == inst) and "master" or "cave"
					SendModRPCToClient(CLIENT_MOD_RPC["tz_texie"]["huanying"],v.userid,ptype)
				end 
			end 
			inst.components.hunger:DoDelta(-25,true)
			-- inst.components.health:SetInvincible(true)
			inst.components.locomotor:Stop()
			inst:ForceFacePoint(pos:Get())
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("tzskill_fanta_blade_pre")	
			inst.AnimState:PushAnimation("tzskill_fanta_blade_loop",false)
			inst.AnimState:PushAnimation("tzskill_fanta_blade_pst",false)	

			inst.AnimState:OverrideSymbol("swap_object", "swap_tz_fanta_blade_blade", "swap_tz_fanta_blade_blade")

			inst.sg.statemem.shadowtask = inst:DoPeriodicTask(0.1,function()
				local debug_str = inst.entity:GetDebugString()
				local bank,build,anim,frame,frame_all = string.match(debug_str,"bank:%s+(.-)%s+build:%s+(.-)%s+anim:%s+(.-)%s+.-Frame:%s+(.-)/(.-)%s+")
				frame = tonumber(frame)
				frame_all = tonumber(frame_all)

				if frame >= frame_all then 
					frame = frame_all
				end

				local shadow = SpawnAt("tz_character_shadow",inst)
				-- shadow.Transform:SetRotation(inst.Transform:GetRotation())
				shadow:ForceFacePoint(pos:Get())
				-- shadow.AnimState:SetPercent(anim,1)
				-- shadow.AnimState:PlayAnimation(anim)
				-- shadow.AnimState:SetTime(frame * FRAMES)
				-- if anim == "tzskill_fanta_blade_loop" then 
				-- 	shadow.AnimState:PushAnimation("tzskill_fanta_blade_pst",false)
				-- elseif anim == "tzskill_fanta_blade_pre" then 
				-- 	shadow.AnimState:PushAnimation("tzskill_fanta_blade_loop",false)
				-- end 
				-- shadow.AnimState:Pause()
				shadow.AnimState:SetPercent(anim,math.min(frame / frame_all,0.95))
				shadow:FadeOut()
			end)

			-- print(inst,"enter fantablade sg")
		end,

		-- loop开始后 第N秒：
		-- 0.217秒出现A
		-- 0.424秒出现B
		-- 0.576秒出现C
		-- 0.796秒出现A
		-- 1.014秒出现B
		-- 1.242秒出现A
		-- 1.383秒出现C
		-- 1.587秒出现B
		-- 1.800秒出现A
		-- 2.013秒出现D
		-- 2.124秒出现3叉飞行剑气E，角度你定，看动画里的 差不多就行
		timeline = {
			TimeEvent(pre_anim_time + 0.217, function(inst)
				CreateFantabladeTimeline(inst,"a",1)
			end),
			TimeEvent(pre_anim_time + 0.424, function(inst)
				CreateFantabladeTimeline(inst,"b",1)
			end),
			TimeEvent(pre_anim_time + 0.576, function(inst)
				CreateFantabladeTimeline(inst,"c",1)
			end),
			TimeEvent(pre_anim_time + 0.769, function(inst)
				CreateFantabladeTimeline(inst,"a",1)
			end),
			TimeEvent(pre_anim_time + 1.014, function(inst)
				CreateFantabladeTimeline(inst,"b",1)
			end),
			TimeEvent(pre_anim_time + 1.242, function(inst)
				CreateFantabladeTimeline(inst,"a",1)
			end),
			TimeEvent(pre_anim_time + 1.383, function(inst)
				CreateFantabladeTimeline(inst,"c",1)
			end),
			TimeEvent(pre_anim_time + 1.587, function(inst)
				CreateFantabladeTimeline(inst,"b",1)
			end),
			TimeEvent(pre_anim_time + 1.800, function(inst)
				CreateFantabladeTimeline(inst,"a",1)
			end),
			TimeEvent(pre_anim_time + 2.013, function(inst)
				CreateFantabladeTimeline(inst,"d",1)
			end),
			TimeEvent(pre_anim_time + 2.124, function(inst)
				local angle = 15
				CreateFantabladeTimeline(inst,"e",20,GetFaceVector(inst,angle) * 15 )
				CreateFantabladeTimeline(inst,"e",20,GetFaceVector(inst) * 15 )
				CreateFantabladeTimeline(inst,"e",20,GetFaceVector(inst,-angle) * 15 )
			end),
		},

		events =
		{
			-- EventHandler("unequip", function(inst,data)
			-- 	print(inst,"go to idle because of unequip",PrintTable(data))
   --              inst.sg:GoToState("idle")
   --          end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("tzskill_fanta_blade_pst") then                	
                    inst.sg:GoToState("idle",true)
                end
            end),
		},

		
		onexit = function(inst)			
			inst.components.health:SetInvincible(false)
			-- if inst.sg.statemem.shadow then 
			-- 	inst.sg.statemem.shadow:DoTaskInTime(0.33,function(shadow)
			-- 		shadow:FadeOut()
			-- 	end)
			-- end
			if inst.sg.statemem.shadowtask then 
				inst.sg.statemem.shadowtask:Cancel()
			end 

			
			local equip_hand = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if equip_hand then 
				inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
				inst.components.inventory:Equip(equip_hand)
    		else

			end

			-- print(inst,"exiting fantablade sg")
		end,
			
	}
	
	-- ThePlayer.sg:GoToState("space_jump_sg",TheInput:GetWorldPosition())
	local space_jump_sg = State({
		name = "space_jump_sg",
		tags = {"busy","doing","nointerrupt","nomorph", "qm_syshu02", "nopredict" },

		onenter = function(inst,pos)
			inst:ClearBufferedAction()
			inst.Physics:Stop()

			inst.AnimState:PlayAnimation("flashmove")

			inst.sg.statemem.pos = pos
			inst.sg.statemem.fx = inst:SpawnChild("tz_skill_swing_fx")

			-- Ly modified:Teleport max range is 14
			local max_range = 14
			local delta = pos - inst:GetPosition()
			if delta:Length() > max_range then
				local norm = delta:GetNormalized()
				inst.sg.statemem.pos = inst:GetPosition() + norm * max_range
			end

			inst.SoundEmitter:PlaySound("dontstarve/common/staff_blink")

			if inst.components.hunger then
				inst.components.hunger:DoDelta(-5, true)
			end

			inst:ForceFacePoint(pos:Get())
		end,

		timeline = {
			TimeEvent(0.12, function(inst)
				inst.components.health:SetInvincible(true)
			end),

			TimeEvent(0.35, function(inst)
				inst.Transform:SetPosition(inst.sg.statemem.pos:Get())
				inst.SoundEmitter:PlaySound("dontstarve/common/staff_blink")
			end),

			TimeEvent(0.5, function(inst)
				inst.components.health:SetInvincible(false)
			end),
		},

		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle",true)
            end),
		},

		onexit = function(inst)
			inst.components.health:SetInvincible(false)
		end,
	})

	local huahua_skill_1_sg = State({
		name = "huahua_skill_1_sg",
		tags = {"busy","doing","nointerrupt","nomorph", "qm_syshu02", "nopredict" },

		onenter = function(inst,data)
			if data then
				inst.components.tzsama:DoDelta(-30)
				
				inst:ForceFacePoint(data:Get())
				huahua_skill_1_fn(inst)

				

				-- Ly modified:Add other cd 
				for _,v in pairs({"huahua_skill_2_key","huahua_skill_3_key","huahua_skill_4_key"}) do
					SendModRPCToClient(GetClientModRPC("tz_skill","force_set_cd"),inst.userid,v,2,true)
				end
			end
			--inst.components.talker:Say("This is huahua_skill_1_sg!")
			inst.sg:GoToState("idle")
		end,

		timeline = {

		},

		events = {
			-- EventHandler("animover", function(inst)
			-- 	inst.sg:GoToState("idle",true)
            -- end),
		},

		onexit = function(inst)

		end,
	})

	local huahua_skill_2_sg = State({
		name = "huahua_skill_2_sg",
		tags = {"busy","doing","nointerrupt","nomorph", "qm_syshu02", "nopredict" },

		onenter = function(inst,data)
			if data then
				inst.components.tzsama:DoDelta(-20)

				inst:ForceFacePoint(data:Get())
				huahua_skill_2_fn(inst)

				
				-- Ly modified:Add other cd 
				for _,v in pairs({"huahua_skill_1_key","huahua_skill_3_key","huahua_skill_4_key"}) do
					SendModRPCToClient(GetClientModRPC("tz_skill","force_set_cd"),inst.userid,v,1.5,true)
				end
			end
			inst.sg:GoToState("idle")
		end,

		timeline = {

		},

		events = {
			-- EventHandler("animover", function(inst)
			-- 	inst.sg:GoToState("idle",true)
            -- end),
		},

		onexit = function(inst)

		end,
	})

	local huahua_skill_3_sg = State({
		name = "huahua_skill_3_sg",
		tags = {"busy","doing","nointerrupt","nomorph", "qm_syshu02", "nopredict" },

		onenter = function(inst,data)
			if data then
				inst.components.tzsama:DoDelta(-15)

				inst:ForceFacePoint(data:Get())
				inst.components.health:SetInvincible(true)
				local dissq = inst:GetDistanceSqToPoint(data)
				local dis = math.clamp(math.sqrt(dissq), 4, 14)
				ToggleOffPhysics(inst)
				local time = 1
				inst.sg:SetTimeout(time)
				inst.components.locomotor:Stop()
				inst.AnimState:SetPercent("atk", 0.6)
				inst.Physics:SetMotorVel(dis, 0 ,0)

				local rate = inst.components.tzsama and inst.components.tzsama.max*0.001 or 0
				local damage =  inst.components.tzsama and inst.components.tzsama.max*0.08 or 0
				--print("技能3",rate)
				local fx = SpawnPrefab("tz_darkhand_fx_three")
				fx:Set(inst)
				fx.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
				fx.Transform:SetScale(0.75+rate, 0.75+rate, 0.75+rate) --动画大小默认开始 0.8
				fx.owner = inst
				fx.damagetask = fx:DoPeriodicTask(0.2,function()
					if fx.owner and fx.owner:IsValid() then
						local x,y,z = fx.owner.Transform:GetWorldPosition()
						local tbl, range, p = GoAngle(fx.owner, 2*(1+rate), 8*(1+rate))
						doauredamage(fx,x,y,z, range,tbl,5,"tz_darkhand_fx_fx1",false,damage)--5
					end
				end)

				

				-- Ly modified:Add other cd 
				for _,v in pairs({"huahua_skill_1_key","huahua_skill_2_key","huahua_skill_4_key"}) do
					SendModRPCToClient(GetClientModRPC("tz_skill","force_set_cd"),inst.userid,v,1,true)
				end
			end
		end,
        ontimeout = function(inst)
			inst.sg:GoToState("idle")
        end,
		timeline = {

		},
		events = {
		},

		onexit = function(inst)
			inst.components.health:SetInvincible(false)
			inst.Physics:ClearMotorVelOverride()
			inst.components.locomotor:Stop()
			inst.components.locomotor:SetBufferedAction(nil)
			if inst.sg.statemem.isphysicstoggle then
				ToggleOnPhysics(inst)
			end
		end,
	})

	local huahua_skill_4_sg = State({
		name = "huahua_skill_4_sg",
		tags = {"doing","nointerrupt","nomorph", "qm_syshu02", "nopredict" },

		onenter = function(inst)
			inst.components.tzsama:DoDelta(-50)

			inst.components.health:SetInvincible(true)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("ghosthand_skillfour")

			local rate = inst.components.tzsama and inst.components.tzsama.max*0.001 or 0
			local damage =  inst.components.tzsama and inst.components.tzsama.max*0.1 or 0
			--print("技能4",rate)
			local fx = SpawnPrefab("tz_darkhand_fx_four")
			fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			fx.Transform:SetScale(0.8+rate, 0.8+rate, 0.8+rate) --动画大小默认开始 0.8
			inst.sg.statemem.skillfx = fx
			fx.owner = inst
			fx.rate = rate
			fx.damage = doauredamage
			fx.adddamage = damage
			fx.range = 8--伤害范围8基础
			fx.damagetask = fx:DoPeriodicTask(0.3,function()
				if fx.owner and fx.owner:IsValid() then
					local x,y,z = fx.owner.Transform:GetWorldPosition()
					local range = fx.range*(1+rate)
					doauredamage(fx,x,y,z, range,nil,8,"tz_darkhand_fx_fx1",true,damage)--8伤害
					fx.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")
				end
			end)
			inst.sg:SetTimeout(6)

			

			-- Ly modified:Add other cd 
			for _,v in pairs({"huahua_skill_1_key","huahua_skill_2_key","huahua_skill_3_key"}) do
				SendModRPCToClient(GetClientModRPC("tz_skill","force_set_cd"),inst.userid,v,6,true)
			end
		end,

		timeline = {

		},
        ontimeout = function(inst)
			inst.sg.statemem.skillfx = nil
			inst.sg:GoToState("idle")
        end,
		events = {
			-- EventHandler("animover", function(inst)
			-- 	inst.sg:GoToState("idle",true)
            -- end),
		},

		onexit = function(inst)
			if inst.sg.statemem.skillfx and inst.sg.statemem.skillfx:IsValid() then
				inst.sg.statemem.skillfx:DoKillSelf()
			end
			inst.components.health:SetInvincible(false)

			if inst.sg.timeinstate < (6 - 1e-5) then
				-- Ly modified:Add other cd 
				for _,v in pairs({"huahua_skill_1_key","huahua_skill_2_key","huahua_skill_3_key"}) do
					SendModRPCToClient(GetClientModRPC("tz_skill","force_set_cd"),inst.userid,v,0.5)
				end
			end
		end,
	})
	------------------
	AddStategraphPostInit("wilson", function(sg)
		sg.states["qm_ljs01"] = qm_ljs01
		sg.states["qm_wmgd"] = qm_wmgd
		sg.states["qm_syshu01"] = qm_syshu01
		sg.states["qm_syshu02"] = qm_syshu02
		sg.states["qm_ruodian"] = qm_ruodian
		sg.states["qm_fangun"] = qm_fangun

		
		sg.states["killknife_skill_sg"] = killknife_skill_sg
		sg.states["fanta_blade_sg"] = fanta_blade_sg
		sg.states["space_jump_sg"] = space_jump_sg

		sg.states["huahua_skill_1_sg"] = huahua_skill_1_sg
		sg.states["huahua_skill_2_sg"] = huahua_skill_2_sg
		sg.states["huahua_skill_3_sg"] = huahua_skill_3_sg
		sg.states["huahua_skill_4_sg"] = huahua_skill_4_sg

		sg.events["qm_dosk"] = EventHandler("qm_dosk", function(inst, data)
			if not IsValSg(inst) or inst:HasTag("beaver") then
				return
			end
			if data and data.key and data.pos then
				local key = data.key
				if key == "ljs" then
					if IsDaiWu(inst) then
						inst.sg:GoToState("qm_ljs01", data.pos)
					end
				elseif key == "wmgd" then
					if IsDaiWu(inst) then
						inst.sg:GoToState("qm_wmgd", data.pos)
					end
				elseif key == "sys" then
					if IsDaiWu(inst) then
						inst.sg:GoToState("qm_syshu01", data.pos)
					end
				elseif key == "rdgz" then
					inst.sg:GoToState("qm_ruodian")
				elseif key == 'fangun' then
					inst.sg:GoToState("qm_fangun", data.pos)
				elseif key == 'killknife_skill_key' then
					inst.sg:GoToState("killknife_skill_sg", data.pos)
				elseif key == "fanta_blade_key" then 
					inst.sg:GoToState("fanta_blade_sg", data.pos)
				elseif key == "space_jump_key" then 
					inst.sg:GoToState("space_jump_sg", data.pos)
				elseif key == "huahua_skill_1_key" then 
					inst.sg:GoToState("huahua_skill_1_sg", data.pos)
				elseif key == "huahua_skill_2_key" then 
					inst.sg:GoToState("huahua_skill_2_sg", data.pos)
				elseif key == "huahua_skill_3_key" then 
					inst.sg:GoToState("huahua_skill_3_sg", data.pos)
				elseif key == "huahua_skill_4_key" then 
					inst.sg:GoToState("huahua_skill_4_sg", data.pos)
				end
			end
		end)
	end)
	
	----------------------
	local function OnQMsave_1(inst, data, ...)
		if inst.qm_onsave010 ~= nil then
			inst:qm_onsave010(data, ...)
		end
		if inst.qmsktbl then
			data.qmsktbl = inst.qmsktbl
		end
	end
	
	local function OnQMload_1(inst, data, ...)
		if inst.qm_onload010 ~= nil then
			inst:qm_onload010(data, ...)
		end
		if data and data.qmsktbl then
			inst.qmsktbl = data.qmsktbl
		end
	end

	---------------------------------------------------------------
	local function SetQMSk(inst, key, num, bool)
		local ennet = inst.player_classified
		num = num or 0
		if key and num and ennet then
			local tbl = (bool and ennet.AllZSk or ennet.AllBSk)[key]
			if type(num) == "number" and tbl then
				inst.qmsktbl[bool and 2 or 1][key] = num
				inst.qmsktbl2[bool and 2 or 1][num] = true
				tbl:set_local(num)
				tbl:set(num)
				if bool and JiNengZL[num] then
					JiNengZL[num](inst, true)
				end
			end
		end
	end
	------------------
	local function New_GetInsulation(self)
		local a, b = self:qm_oldGetInsulation()
		local a1,b1 = 0,0
		if self.inst.qmsktbl then
			for k,v in pairs(self.inst.qmsktbl[2]) do
				if v then
					if v == 1 then
						b1 = 1000
					elseif v == 3 then
						a1 = 1000
					end
				end
			end
		end
		return math.max(0, a + a1), math.max(0, b + b1)
	end
	--------------------
	
	AddPlayerPostInit(function(inst)
		inst.qmsktbl = {{0,0,0,0},{0,0,0,0}}
		inst.qmsktbl2 = {{},{}}
		
		inst.qm_onsave010 = inst.OnSave
		inst.OnSave = OnQMsave_1
		
		inst.qm_onload010 = inst.OnLoad
		inst.OnLoad = OnQMload_1
		
		inst.SetQMSk = SetQMSk
		
		if inst.components.temperature then
			inst.components.temperature.qm_oldGetInsulation = inst.components.temperature.GetInsulation
			inst.components.temperature.GetInsulation = New_GetInsulation
		end
		
		if inst.components.health then
			inst.components.health.qm_oldDoDelta = inst.components.health.DoDelta
			inst.components.health.DoDelta = function(self, a,b,c, ...)
				if b and isstr(c) and self.inst.qmsktbl2 then
					if c == "cold" and self.inst.qmsktbl2[2][4] then
						return 0
					elseif c == "hot" and self.inst.qmsktbl2[2][2] then
						return 0
					end
				end
				return self:qm_oldDoDelta(a,b,c, ...)
			end
		end
		
		if inst.components.combat then
			inst.components.combat.qmold_GetAttacked = inst.components.combat.GetAttacked
			inst.components.combat.qmold_CalcDamage = inst.components.combat.CalcDamage
			inst.components.combat.GetAttacked = function(self, attacker, damage, ...)
				if inst.components.combat.qmtabfn ~= nil and damage ~= nil and damage > 0 then
					damage = inst.components.combat.qmtabfn(self.inst, attacker, damage, ...)
				end
				if damage and damage > 0 and (FindEntity(self.inst, 10, nil, {"ShengYu"})) then
					damage = 0
				end
				return inst.components.combat.qmold_GetAttacked(self, attacker, damage, ...)
			end
			
			inst.components.combat.qmold_CalcDamage = function(self, target, weapon, multiplier, ...)
				local damget = inst.components.combat:qmold_CalcDamage(target, weapon, multiplier, ...)
				if damget and target and target:IsValid() and AllRuoDianTarget[target] then
					damget = damget * 1.25
				end
				return damget
			end
		end
		
		inst:DoTaskInTime(1, function()
			for i=1, 4 do
				inst:SetQMSk(i, inst.qmsktbl[1][i], false)
				inst:SetQMSk(i, inst.qmsktbl[2][i], true)
			end
		end)
		
	end)
	----------------------掉落相关
	local AllDiaoLuo = {
		items = {
			{
				["item_NaiHan01"]			= 15,
				--["item_NaiHan02"]			= 6,
				["item_NaiRe01"]			= 15,
				--["item_NaiRe02"]			= 6,
				["item_BeiShuiYiZhan"]		= 6,
				--["item_DaWeiWang"]			= 12,
				["item_JianZhenRouDian"]	= 9,
				["item_JuShouLieShou"]		= 9,
				["item_ShiShen"]			= 9,
				--["item_ShuJiAiHaoZhe"]		= 1,
				["item_SuoXiang"]			= 18,
				["item_WaErJiLi"]			= 6,
				["item_XueJuRen"]			= 9,
			},
			
			{
				["item_z_ljs"]				= 9,
				["item_GeDang"]				= 15,
				--["item_ShengYu"]			= 2,
				--["item_rdgz"]				= 15,
				--["item_FanGun"]				= 21,
				["item_killknife_skill"]    = 5,
				["item_fanta_blade"]        = 3,
				["item_space_jump"]			= 10,
			}
		},
		
		guais = {
			['deerclops']			=	0,					--巨鹿
			['bearger']				=	0,					--倒霉熊
			['moose']				=	0,					--卤鸭
			['dragonfly']			=	0,					--龙蝇
			['minotaur']			=	0,					--远古犀牛
			['malbatross']			=	0,					--邪天翁
			['stalker']				=	0,					--远古织影者
			['stalker_atrium']		=	0,					--远古织影者	这个厉害着呢
			['klaus']				=	0,					--克劳斯
			['toadstool']			=	0,					--蟾蜍
			['toadstool_dark']		=	1,					--癞蛤蟆
			['beequeen']			=	0,					--蜂女皇
			['crabking']			=	0,					--帝王蟹
			['antlion']				=	0,					--蚂蚁狮子
			['shadow_rook']			=	0,					--暗影三基佬之大佬
			['shadow_bishop']		=	0,					--暗影三基佬之中佬
			['shadow_knight']		=	0,					--暗影三基佬之小佬
		},
	}
	
	-- for k,v in pairs({
		-- item_TeJiChuShi = {crabking=0.1},
	-- }) do
		-- for kk,vv in pairs(v) do
			-- AddPrefabPostInit(kk, function(inst)
				-- inst:ListenForEvent("death", function(inst,data)
					-- if not inst.tzxkisdeath and inst:IsValid() and math.random() < vv then
						-- inst.tzxkisdeath = true
						-- SpawnPrefab(k).Transform:SetPosition(inst.Transform:GetWorldPosition())
					-- end
				-- end)
			-- end)
		-- end
	-- end
	for k,v in pairs(AllDiaoLuo.guais) do
		AddPrefabPostInit(k, function(inst)
			if inst.components.lootdropper then
				local old_lootfn = inst.components.lootdropper.GenerateLoot
				inst.components.lootdropper.GenerateLoot = function(self, ...)
					local lot = old_lootfn(self, ...)
					local num = math.random(0, 2)
					if lot and num > 0 then
						for i=1, num do
							local keynum = math.random(#AllDiaoLuo.items)
							local tbl = AllDiaoLuo.items[keynum]
							local bool = AllDiaoLuo.guais[k] == keynum
							for k,v in pairs(tbl) do
								local ran = math.random()
								local ran2 = ( v / 100 )
								if ( ran < ran2 ) or ( bool and ran < ( ran2 * 2 ) ) then
									table.insert( lot, k )
									break
								end
							end
						end
					end
					return lot
				end
			end
		end)
	end
end
---------------------------------------------------------------------
local SgTbl = nil

local function DoMoveTab(sg)
	if SgTbl == nil then
		local fn01 = sg.states['run_stop'] and sg.states['run_stop'].onenter
		if fn01 then
			SgTbl = {}
            SgTbl.ConfigureRunState = TZUP.Get(fn01,"ConfigureRunState","wilson")
            SgTbl.PlayMooseFootstep = TZUP.Get(fn01,"PlayMooseFootstep","wilson")
            SgTbl.DoFoleySounds = TZUP.Get(fn01,"DoFoleySounds","wilson")
		end
	end
	if SgTbl ~= nil then
		local old_run_start_onenter = sg.states['run_start'].onenter
		local old_run_onenter = sg.states['run'].onenter
		local old_run_stop_onenter = sg.states['run_stop'].onenter
		sg.states['run_start'].onenter = function(inst, ...)
			if inst.beishuibuff then
				SgTbl.ConfigureRunState(inst)
				inst.components.locomotor:RunForward()
				inst.AnimState:PlayAnimation("move_pre")
				inst.sg.mem.footsteps = (inst.sg.statemem.goose or inst.sg.statemem.goosegroggy) and 4 or 0
			else
				return old_run_start_onenter(inst, ...)
			end
		end
		
		sg.states['run'].onenter = function(inst, ...)
			if inst.beishuibuff then
				SgTbl.ConfigureRunState(inst)
				inst.components.locomotor:RunForward()
				inst.AnimState:PlayAnimation('move_loop', true)
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			else
				return old_run_onenter(inst, ...)
			end
		end
		
		sg.states['run_stop'].onenter = function(inst, ...)
			if inst.beishuibuff then
				SgTbl.ConfigureRunState(inst)
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("move_pst")

				if inst.sg.statemem.moose or inst.sg.statemem.moosegroggy then
					SgTbl.PlayMooseFootstep(inst, .6, true)
					SgTbl.DoFoleySounds(inst)
				end
			else
				return old_run_stop_onenter(inst, ...)
			end
		end
	end
end

AddStategraphPostInit("wilson", function(sg)
	DoMoveTab(sg)
end)

AddStategraphPostInit("wilson_client", function(sg)
	DoMoveTab(sg)
end)
---------------------------------------------------------------------
AddPrefabPostInit("player_classified",function(inst)
	inst.AllZSk, inst.AllBSk = {}, {}
	inst.qm_xjr = net_bool(inst.GUID, "inst.qm_xjr", "kaideng")
	inst.qm_shuj = net_bool(inst.GUID, "inst.qm_shuj", "ShuJiang")
	inst.qm_beishuibuff = net_bool(inst.GUID, "inst.qm_beishuibuff", "beishuibuff")
	for i=1, 4 do
		local entstr01 = string.format("AllZSk_%02d", i)
		local entstr02 = string.format("AllBSk_%02d", i)
		inst.AllZSk[i] = net_smallbyte(inst.GUID, "inst.AllZSk"..i, entstr01)
		inst.AllBSk[i] = net_smallbyte(inst.GUID, "inst.AllBSk"..i, entstr02)
		if not TheNet:IsDedicated() then
			inst:ListenForEvent(entstr02, function()
				if ThePlayer then
					local num = inst.AllBSk[i]:value()
					if AllCao[i] then
						AllCao[i]:SetSk(num, false)
					end
				end
			end)
			inst:ListenForEvent(entstr01, function()
				if ThePlayer then
					local num = inst.AllZSk[i]:value()
					if AllBCao[i] then
						AllBCao[i]:SetSk(num, true)
					end
				end
			end)
		end
	end
	if not TheNet:IsDedicated() then
		if ThePlayer then
			inst:ListenForEvent("kaideng", function()
				if ThePlayer then
					if ThePlayer then
						ThePlayer._xuejuren = inst.qm_xjr:value()
					end
					if ThePlayer.HUD then
						if ThePlayer._xuejuren then
							if ThePlayer.HUD.beaverOL == nil then
								ThePlayer.HUD.beaverOL = ThePlayer.HUD.overlayroot:AddChild(Image("images/woodie.xml", "beaver_vision_OL.tex"))
								ThePlayer.HUD.beaverOL:SetVRegPoint(ANCHOR_MIDDLE)
								ThePlayer.HUD.beaverOL:SetHRegPoint(ANCHOR_MIDDLE)
								ThePlayer.HUD.beaverOL:SetVAnchor(ANCHOR_MIDDLE)
								ThePlayer.HUD.beaverOL:SetHAnchor(ANCHOR_MIDDLE)
								ThePlayer.HUD.beaverOL:SetScaleMode(SCALEMODE_FILLSCREEN)
								ThePlayer.HUD.beaverOL:SetClickable(false)
								ThePlayer.HUD.beaverOL:Hide()
							end
						end
					end
					ThePlayer:_KaiDeng(ThePlayer._xuejuren)
				end
			end)
			
			inst:ListenForEvent("beishuibuff", function()
				if ThePlayer then
					ThePlayer.beishuibuff = inst.qm_beishuibuff:value()
				end
			end)
			
			inst:ListenForEvent("ShuJiang", function()
				if ThePlayer then
					if ThePlayer.HUD then
						if inst.qm_shuj:value() then
							ThePlayer:AddTag("bookbuilder")
						else
							ThePlayer:RemoveTag("bookbuilder")
						end
						local f = ThePlayer.HUD.controls;
						f.crafttabs:Kill();
						local CraftTabs = require("widgets/crafttabs");
						f.crafttabs = f.left_root:AddChild(CraftTabs(f.owner, f.top_root));
						f.crafttabs:Show()
						ThePlayer:PushEvent("unlockrecipe")
					end
				end
			end)
		end
	end
end)
----------
AddAction("XUEXIJI", "学习技能", function(act)
	if act.invobject ~= nil and act.invobject.components.xuexiji and act.doer then
		if act.doer._bianshen ~= nil and  act.doer._bianshen:value() then
			return false
		end
		if act.invobject.components.xuexiji:CanXue(act.doer) then
			act.invobject.components.xuexiji:DoXue(act.doer)
			return true
		end
	end
	return false
end)

AddComponentAction("INVENTORY", "xuexiji", function(inst, doer, actions, right)
	if inst:HasTag("QM_SK") then
		table.insert(actions, ACTIONS.XUEXIJI)
	end
end)


AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.XUEXIJI, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.XUEXIJI, "dolongaction"))







-- Ly addition
-- local function HandleBufferedActionSkill(player,x,y,z)
-- 	local self = player.components.playercontroller
-- 	local buffaction = nil 
--     local invobject = player.components.combat and player.components.combat:GetWeapon() or player.replica.combat:GetWeapon()
-- 	local pos = Vector3(x,y,z)

-- 	if invobject and invobject:HasTag("key_castable_aoeweapon") and invobject.components.aoetargeting and invobject.components.aoetargeting:IsEnabled()
-- 		and (TheWorld.Map:IsPassableAtPoint(pos:Get()) or invobject.components.aoetargeting.alwaysvalid) then 

-- 		local range = invobject.components.aoetargeting:GetRange()
-- 		buffaction = BufferedAction(player, nil, ACTIONS.CASTAOE, invobject, pos, nil, range, nil, nil)

-- 	end 
	
--     if buffaction ~= nil then
--         if self.ismastersim then
--             self.locomotor:PushAction(buffaction, true)
--             return
--         elseif self.locomotor == nil then 
--         	SendModRPCToServer(MOD_RPC["taizhen_skill"]["bufferedaction_skill"],x,y,z)
--         elseif self:CanLocomote() then
--             if buffaction.action ~= ACTIONS.WALKTO then
--                 buffaction.preview_cb = function()
--                     SendModRPCToServer(MOD_RPC["taizhen_skill"]["bufferedaction_skill"],x,y,z)
--                 end
--             end
--             self.locomotor:PreviewAction(buffaction, true)
--         end
--     end
-- end

-- AddModRPCHandler("taizhen_skill", "bufferedaction_skill", function(inst,x,y,z) 
-- 	HandleBufferedActionSkill(inst,x,y,z)
-- end)

-- TheInput:AddKeyDownHandler(KEY_R,function()
-- 	if KIsValSg(ThePlayer) then 
-- 		local x,y,z = TheInput:GetWorldPosition():Get()
-- 		HandleBufferedActionSkill(ThePlayer,x,y,z)
-- 	end
-- end)

local TzHuanYingTeXie = require("widgets/tz_huanying_texie")
AddClassPostConstruct("widgets/controls", function(self)
	self.TzHuanYingTeXie = self:AddChild(TzHuanYingTeXie())
	-- ThePlayer.HUD.controls.TzHuanYingTeXie:Play()
end)

AddClientModRPCHandler("tz_texie","huanying",function(ptype)
	ThePlayer.HUD.controls.TzHuanYingTeXie:Play(ptype)
	-- print(a,b,c,d,e)
	-- SendModRPCToClient(CLIENT_MOD_RPC["tz_texie"]["huanying"],user_id,ptype)
end)

-- Ly modifide:Add force_set_cd RPC,send from server to client,because the CD handle is in client. 
-- SendModRPCToClient(GetClientModRPC("tz_skill","force_set_cd"),ThePlayer.userid,1,4,true)
-- SendModRPCToClient(GetClientModRPC("tz_skill","force_set_cd"),ThePlayer.userid,"fanta_blade_key",4)
AddClientModRPCHandler("tz_skill","force_set_cd",function(index,cd,not_quicker)
	if type(index) == "string" then
		for k,v in pairs(AllCao) do
			if v ~= nil and v.shu and v.shu.key and v.shu.key == index then
				index = k 
				break 
			end
		end		
	end


	if AllCao[index] then
		local item = AllCao[index].shu and AllCao[index].shu.key or nil
		if item == nil or QMSkTablKey[item] == nil then
			return
		end

		local defaultcd = QMSkTablKey[item].cd
		local last_cast = ThePlayer.HUD.controls.AllSkCd[item]
		if not not_quicker or last_cast == nil or (defaultcd - GetTime() + last_cast <= cd) then
			ThePlayer.HUD.controls.AllSkCd[item] = GetTime() - defaultcd + cd 
			AllCao[index]:DoCD(cd)
		end
		
	end
end)

AddModRPCHandler("tz_skill","force_interrupt",function(inst)
	if inst.sg and inst.sg.currentstate.name == "fanta_blade_sg" then 
		inst.sg:GoToState("idle")
	end
end)


local MOVE_BTNS = {
	CONTROL_PRIMARY,
	CONTROL_MOVE_UP,
	CONTROL_MOVE_DOWN,
	CONTROL_MOVE_LEFT,
	CONTROL_MOVE_RIGHT,
}
TheInput:AddGeneralControlHandler(function(control, pressed)
	if pressed and table.contains(MOVE_BTNS,control) then 
		if ThePlayer then
			SendModRPCToServer(MOD_RPC["tz_skill"]["force_interrupt"])
			if ThePlayer.sg and ThePlayer.sg.currentstate.name == "fanta_blade_sg" then 
				ThePlayer.sg:GoToState("idle")
			end
		end
	end
end)








