local pick_exp_with_object ={
	----采集组件
	--一般采集
	["flower_evil"] = 2,--恶魔花
	["blue_mushroom"] = 2,--蓝蘑菇
	["reeds"] = 2,--芦苇
	["tallbirdnest"] = 2,--高脚鸟巢
	["statueglommer"] = 3,--格罗姆雕像
	["wormlight_plant"] = 3,--发光浆果
	["lichen"] = 3,--苔藓
	["cave_banana_tree"] = 3,--香蕉树
	["bullkelp_plant"] = 3,--海带
	["rock_avocado_bush"] = 3,--石果树
	["rosebush"] = 2,--棱镜蔷薇花
	["orchidbush"] = 2,--棱镜兰草花
	["lilybush"] = 2,--棱镜蹄莲花
	["monstrain"] = 3,--棱镜雨竹
	["shyerryflower"] = 3,--棱镜颤栗花
	["compostingbin"] = 3,--堆肥桶
	--农作物
	["farm_plant_asparagus"] = 10,--芦笋
	["farm_plant_garlic"] = 10,--大蒜
	["farm_plant_pumpkin"] = 10,--南瓜
	["farm_plant_corn"] = 10,--玉米
	["farm_plant_onion"] = 10,--洋葱
	["farm_plant_potato"] = 10,--土豆
	["farm_plant_dragonfruit"] = 10,--火龙果
	["farm_plant_pomegranate"] = 10,--石榴
	["farm_plant_eggplant"] = 10,--茄子
	["farm_plant_tomato"] = 10,--西红柿
	["farm_plant_watermelon"] = 10,--西瓜
	["farm_plant_pepper"] = 10,--辣椒
	["farm_plant_durian"] = 10,--榴莲
	["farm_plant_carrot"] = 10,--胡萝卜
	["weed_firenettle"] = 3,--火荨麻
	["weed_forgetmelots"] = 3,--必忘我
	["weed_ivy"] = 3,--针刺旋花
	["weed_tillweed"] = 3,--犁地草
	--多汁浆果
	["berrybush_juicy"] = 2,--多汁浆果

	----收获组件
	["mushroom_farm"] = 5,--蘑菇农场
	["beebox"] = 5,--蜂箱
	["beebox_hermit"] = 3,--寄居蟹蜂箱
	["waterplant"] = 3,--海草
	["waterplant_baby"] = 2,--海芽

	----剃刮组件
	["waterplant"] = 3,--海草
	["waterplant_baby"] = 2,--海芽
	["spiderden"] = 2,--蜘蛛巢

	----胡子组件
	["beefalo"] = 2,--皮弗娄
	["webber"] = 2,--韦伯
	["wilson"] = 2,--威尔逊
	["woodie"] = 2,--吴迪

	----刷洗组件
	["beefalo"] = 2,--皮弗娄

	----风干组件
	["meatrack"] = 3,--晾肉架
	["meatrack_hermit"] = 2,--寄居蟹晾肉架

	----烹饪组件
	["cookpot"] = 2,--烹饪锅
	["archive_cookpot"] = 3,--远古锅
	["portablecookpot"] = 2,--便携烹饪锅
	["portablespicer"] = 2,--便携香料站

	--鸟笼
	["birdcage"] = 2,--鸟笼

	----工作组件
	--盐堆
	["saltstack"] = 3,--盐堆
	--敲毁
	["firepit"] = 2,--石头营火
	["coldfirepit"] = 3,--石头冷火
	["cookpot"] = 2,--烹饪锅
	["archive_cookpot"] = 3,--远古锅
	["icebox"] = 4,--冰箱
	["siestahut"] = 2,--午睡小屋
	["tent"] = 2,--帐篷
	["birdcage"] = 2,--鸟笼
	["meatrack"] = 3,--晾肉架
	["lightning_rod"] = 2,--避雷针
	["nightlight"] = 3,--暗夜照明灯
	["researchlab"] = 2,--科学机器
	["researchlab2"] = 3,--炼金引擎
	["researchlab3"] = 3,--暗影操控器
	["researchlab4"] = 4,--灵子分解器
	["dragonflychest"] = 5,--龙鳞宝箱
	["wall_stone"] = 2,--石墙
	["wall_ruins"] = 3,--铥墙
	["pighouse"] = 2,--猪房
	["rabbithole"] = 3,--兔房
	["mermhouse"] = 3,--鱼人房
	["ancient_altar"] = 3,--远古祭坛
	["ancient_altar_broken"] = 5,--损坏的远古祭
	["telebase"] = 4,--传送核心
	["skeleton"] = 2,--人骨
	["beebox"] = 5,--蜂箱
	["monkeybarrel"] = 3,--猴子桶
	["chessjunk1"] = 2,--损坏的机械1
	["chessjunk2"] = 2,--损坏的机械2
	["chessjunk3"] = 2,--损坏的机械3
	--挖矿
	["ruins_statue_head"] = 3,--远古头像
	["ruins_statue_mage"] = 3,--远古法师雕像
	["archive_moon_statue"] = 4,--远古月亮雕像
	["marbletree"] = 3,--大理石树
	["marbleshrub"] = 3,--大理石灌木
	["rock2"] = 2,--金矿
	["rock_moon"] = 3,--月岩石
	["rock_moon_shell"] = 4,--可疑的月岩石
	["moonglass_rock"] = 3,--月光玻璃
	["gargoyle_houndatk"] = 3,--可疑的月岩
	["gargoyle_hounddeath"] = 3,--可疑的月岩
	["gargoyle_werepigatk"] = 3,--可疑的月岩
	["gargoyle_werepigdeath"] = 3,--可疑的月岩
	["gargoyle_werepighowl"] = 3,--可疑的月岩
	["stalagmite"] = 2,--石笋
	["stalagmite_med"] = 2,--石笋
	["stalagmite_full"] = 2,--石笋
	["spiderhole_rock"] = 4,--蛛网岩
	["shell_cluster"] = 4,--贝壳堆
	--砍树
	["mushtree_tall"] = 3,--蓝蘑菇树
	["mushtree_medium"] = 2,--红蘑菇树
	["mushtree_small"] = 2,--绿蘑菇树
	["mushtree_tall_webbed"] = 3,--蛛网蓝蘑菇树
	["mushtree_moon"] = 4,--月亮蘑菇树
	["deciduoustree"] = 5,--桦树精
}

local function get_pick_experience_plus(data)
	local pick_exp_plus = 0
	if data and data.object then
		pick_exp_plus = pick_exp_with_object[data.object.prefab] or 1
	end

	return pick_exp_plus
end
local function cal_max_pick_experience(self, pick_level)
	local pick_level_up_basal_experience = self.pick_level_up_basal_experience

	local max_pick_exp = pick_level_up_basal_experience * math.floor( math.pow(1.5, pick_level) )

	return max_pick_exp
end
local function show_pick_experience(picker, pick_probability, pick_exp, max_pick_exp)
	if picker and picker.components.talker then
		picker.components.talker:Say("采收暴击率："..tostring( pick_probability*100 ).."%".." \n"
			.."当前经验："..pick_exp.."\n"
			.."升级所需经验："..max_pick_exp.."\n"
		)
	end
end


local Ifhexperience = Class(function(self, inst)
    self.inst = inst

    self.pick_level = 0
    self.max_pick_level = 10
    self.pick_exp = 0
    self.max_pick_exp = 0

    self.max_pick_probability = TUNING.IFH_MAX_DOUBLE_PICK_PROBABILITY

    self.pick_probability = (self.pick_level/self.max_pick_level) * self.max_pick_probability

    self.pick_show_experience = TUNING.IFH_DOUBLE_PICK_SHOW_EXPERIENCE
    self.pick_level_up_basal_experience = TUNING.IFH_DOUBLE_PICK_LEVEL_UP_BASAL_EXPERIENCE
end,
nil,
{

})


function Ifhexperience:Set_ifh_name(pick_level, pick_probability)
	local max_pick_level = self.max_pick_level
	local inst = self.inst
	local string_pick_probability = "采收暴击率 "..tostring(pick_probability*100).."%".." \n"

	if pick_level < max_pick_level then
		inst.double_name = ("冰之花环".." \n"
			..string_pick_probability)
	else
		inst.double_name = ("满级冰之花环".." \n"
			..string_pick_probability)
	end

	inst.components.named:SetName(inst.double_name..
				inst.multiple_name)
end
function Ifhexperience:Pick_exp_up(picker, data)
	local pick_level = self.pick_level
	local max_pick_level = self.max_pick_level
	local pick_exp = self.pick_exp
	local max_pick_exp = self.max_pick_exp
	local max_pick_probability = self.max_pick_probability
	local pick_probability = self.pick_probability
	local pick_show_experience = self.pick_show_experience
	
	if pick_level < max_pick_level then
		local pick_exp_plus = get_pick_experience_plus(data)
		pick_exp = pick_exp + pick_exp_plus

		while (true) do
			max_pick_exp = cal_max_pick_experience(self, pick_level)

			if pick_exp < max_pick_exp then
				break
			elseif pick_exp >= max_pick_exp then
				pick_level = pick_level + 1
				pick_exp = pick_exp - max_pick_exp

				pick_probability = (pick_level / max_pick_level) * max_pick_probability
				show_pick_experience(picker, pick_probability, pick_exp, max_pick_exp)
				self:Set_ifh_name(pick_level, pick_probability)

				if pick_level >= max_pick_level then
					pick_exp = 0
					max_pick_exp = 0
					break
				end
			end
		end

		if pick_show_experience == true then
			show_pick_experience(picker, pick_probability, pick_exp, max_pick_exp)
		end
	end

	self.pick_level = pick_level
	self.pick_exp = pick_exp
	self.pick_probability = pick_probability
end

function Ifhexperience:OnSave()
    local data = {
        pick_level = self.pick_level,
        pick_exp = self.pick_exp,
        pick_probability = self.pick_probability
    }
    return data
end
function Ifhexperience:OnLoad(data)
	if data then
		self.pick_level = data.pick_level or 0
		self.pick_exp = data.pick_exp or 0
		self.pick_probability = data.pick_probability or 0
	end
end
function Ifhexperience:Test(inst)
end

return Ifhexperience

