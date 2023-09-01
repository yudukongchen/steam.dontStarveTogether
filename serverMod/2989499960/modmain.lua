PrefabFiles = {
	"deluxe_firepit",
	"deluxe_firepit_fire",
	"endo_firepit",
	"endo_firepit_fire",
	"ice_star",
	"ice_star_flame",
	"heat_star",
	"heat_star_flame",
}

Assets = 
{
	Asset("ATLAS", "images/inventoryimages/deluxe_firepit.xml"),
	Asset( "IMAGE", "minimap/deluxe_firepit.tex" ),
	Asset( "ATLAS", "minimap/deluxe_firepit.xml" ),	

	Asset("ATLAS", "images/inventoryimages/endo_firepit.xml"),
	Asset( "IMAGE", "minimap/endo_firepit.tex" ),
	Asset( "ATLAS", "minimap/endo_firepit.xml" ),	

	Asset("ATLAS", "images/inventoryimages/ice_star.xml"),
	Asset( "IMAGE", "minimap/ice_star.tex" ),
	Asset( "ATLAS", "minimap/ice_star.xml" ),	

	Asset("ATLAS", "images/inventoryimages/heat_star.xml"),
	Asset( "IMAGE", "minimap/heat_star.tex" ),
	Asset( "ATLAS", "minimap/heat_star.xml" ),	
}
	AddMinimapAtlas("minimap/deluxe_firepit.xml")
	AddMinimapAtlas("minimap/endo_firepit.xml")
	AddMinimapAtlas("minimap/ice_star.xml")
	AddMinimapAtlas("minimap/heat_star.xml")

	STRINGS = GLOBAL.STRINGS
	RECIPETABS = GLOBAL.RECIPETABS
	Recipe = GLOBAL.Recipe
	Ingredient = GLOBAL.Ingredient
	TECH = GLOBAL.TECH


---------------------------------------------------
--  Heaters
---------------------------------------------------
--DELUXE FIREPIT

	-- Deluxe Firepit dialog
		GLOBAL.STRINGS.NAMES.DELUXE_FIREPIT = "豪华火堆"
		STRINGS.RECIPE_DESC.DELUXE_FIREPIT = "哇，真是……高效!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "不知何故仍然取悦即使其熄灭.",
					EMBERS = "刚好足够.",
					LOW = "适合一个烧烤.",
					NORMAL = "现在我要是四面墙和屋顶...",
					HIGH = "是的,你可以从看得到三度烧伤.",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "我需要重新启动它!",
					EMBERS = "它几乎是!",
					LOW = "足够的",
					NORMAL = "它非常适合冬天",
					HIGH = "警告:热量超过指定的限制",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "都是坏了的!",
					EMBERS = "几乎是过时的!",
					LOW = "是完美的烹饪和黑暗时间吗.",
					NORMAL = "非常强大的火.",
					HIGH = "火太大了!火焰退后!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "啊,无聊...",
					EMBERS = "我火一样无聊.",
					LOW = "这是足够的.",
					NORMAL = "火焰是好看…但越大越好!",
					HIGH = "哈哈哈哈哈哈哈!完美!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "至少看起来还不错.",
					EMBERS = "我应该扇火焰.",
					LOW = "这将很好的达到我的目的.",
					NORMAL = "完美……在冬天!!",
					HIGH = "这种程度的过度是最适合疯子!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "小提琴棒.",
					EMBERS = "除了我的书...",
					LOW = "这是一个教科书式的篝火.",
					NORMAL = "这应该让一个雪人温暖.",
					HIGH = "我想我太好了!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "又冷又黑,像我的心.",
					EMBERS = "只有最小的余烬坚持烧焦的木头.",
					LOW = "一个小火焰将不得不做",
					NORMAL = "我能忍受它.",
					HIGH = "任何热,它就像站在地狱!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "看来我们需要更多的日志.",
					EMBERS = "它看起来不很温暖了...",
					LOW = "挤作一团我们仍然可以得到一些温暖",
					NORMAL = "这是回家的壁炉.",
					HIGH = "退后……火焰看起来很危险!",
				}

		--if GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) then 

			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DELUXE_FIREPIT  =
					{
						OUT = "需要更多..",
						EMBERS = "真是神奇...",
						LOW = "瓜子是一个很有人气的人.",
						NORMAL = "听说有一个人叫树苗？",
						HIGH = "让我们欢呼！",
					}


			 GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.DELUXE_FIREPIT  =
					{
						OUT = "全没了!",
						EMBERS = "火花和煤渣.",
						LOW = "我们可以容忍这个.",
						NORMAL = "这正是我们需要的.",
						HIGH = "明智的保持.",
					}

		--end

	-- Deluxe Firepit config opions
		GLOBAL.deluxeFirepitBurnRate = GetModConfigData("deluxeFirepitBurnRate")
		GLOBAL.deluxeFirepitDropLoot = GetModConfigData("dropLoot")
	--

	-- Deluxe firepit Recipe





		-- standard cost
		local deluxeFirePitIngredient_logs = 6
		local deluxeFirePitIngredient_goldNuggets = 3
		local deluxeFirePitIngredient_cutstone = 14

		local deluxeFirePitRecipeCost = (GetModConfigData("recipeCost"))

		if deluxeFirePitRecipeCost == "testing" then
			local deluxe_firepit = AddRecipe("deluxe_firepit",
			{
				Ingredient("log", 1),
			},
				RECIPETABS.LIGHT, TECH.NONE, "deluxe_firepit_placer" ) 
				deluxe_firepit.atlas = "images/inventoryimages/deluxe_firepit.xml"
		else


			if deluxeFirePitRecipeCost == "cheap" then
				deluxeFirePitIngredient_logs = 3
				deluxeFirePitIngredient_goldNuggets = 1
				deluxeFirePitIngredient_cutstone = 5
			elseif deluxeFirePitRecipeCost == "expensive" then
				deluxeFirePitIngredient_logs = 9
				deluxeFirePitIngredient_goldNuggets = 6
				deluxeFirePitIngredient_cutstone = 20
			end


				local deluxe_firepit = AddRecipe("deluxe_firepit",
			{
				Ingredient("log", deluxeFirePitIngredient_logs),
				Ingredient("goldnugget",deluxeFirePitIngredient_goldNuggets),
				Ingredient("cutstone", deluxeFirePitIngredient_cutstone)
			},
				RECIPETABS.LIGHT, TECH.NONE, "deluxe_firepit_placer" ) 
				deluxe_firepit.atlas = "images/inventoryimages/deluxe_firepit.xml"
		end
	--

--ENDO FIREPIT (renamed to Blue Firepit for DST)
	--if (GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS)) then 

	-- ENDO Firepit dialog
		GLOBAL.STRINGS.NAMES.ENDO_FIREPIT = "豪华吸热的火"
		STRINGS.RECIPE_DESC.ENDO_FIREPIT = "神奇的!冷和高效!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "这将是完美的夏天!",
					EMBERS = "只剩下一点光,我开始热身了.",
					LOW = "足够的冷却……也许会更好!",
					NORMAL = "蓝色的火焰...",
					HIGH = "往后站,你可以从那火焰体温过低!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "我需要重新启动它!",
					EMBERS = "快出去!温度上升!",
					LOW = "充分冷却",
					NORMAL = "它非常适合夏天",
					HIGH = "警告:冻结迫在眉睫!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "都是坏了的!",
					EMBERS = "几乎是过时的!",
					LOW = "冷却我足够吗...",
					NORMAL = "强大的蓝色火焰!!",
					HIGH = "火太大了!这种程度的冷却是不自然的",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "冷吗? ? ! !火灾只能热!",
					EMBERS = "可怜的冷蓝色的火焰...",
					LOW = "这是足够的.",
					NORMAL = "蓝色的火焰是好看…和冷却我好",
					HIGH = "哈哈哈哈哈哈哈哈!完美!火灾可能很冷…",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "至少看起来还不错。",
					EMBERS = "我应该添加更多的燃料",
					LOW = "这将很好的达到我的目的.",
					NORMAL = "完美……夏天的时间!!",
					HIGH = "我应该从那火焰退后!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "冷火灾不是我的书,我想知道它是如何工作的...",
					EMBERS = "一个稳定的,如果不是小州",
					LOW = "这种冷却火是适合我的需要",
					NORMAL = "这火是惊人的,我需要更新我的日记",
					HIGH = "我想我太好了!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "它看起来不令人印象深刻...",
					EMBERS = "冷和蓝色的——就像我的灵魂",
					LOW = "这将为现在做",
					NORMAL = "任何保护从太阳是一种幸福",
					HIGH = "它比我的心更冷!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "露西,我们需要这火的燃料",
					EMBERS = "嘿,露西,看小火焰了...",
					LOW = "至少我们免受太阳常数热",
					NORMAL = "这种程度的冷却是适合我们俩...",
					HIGH = "露西,退后的火焰...他们可以冻结你的灵魂!",
				}


			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ENDO_FIREPIT  =
					{
						OUT = "真是缓慢.",
						EMBERS = "这么小?行么？",
						LOW = "这是正常的温度",
						NORMAL = "挺不错的?",
						HIGH = "这温度不对?!",
					}


			 GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.ENDO_FIREPIT  =
					{
						OUT = "全没了!",
						EMBERS = "小蓝和小冷却",
						LOW = "我们可以容忍这个.",
						NORMAL = "这正是我们需要的.",
						HIGH = "我们认为它明智的保持.",
					}


	-- Endo Firepit config opions
		GLOBAL.deluxeEndoFirepitBurnRate = GetModConfigData("deluxeEndoFirepitBurnRate")
		GLOBAL.endoDropLoot = GetModConfigData("endoDropLoot")
	--

	-- Endo firepit Recipe

		-- standard cost
		local deluxeEndoFirePitIngredient_nitre = 4
		local deluxeEndoFirePitIngredient_doodads = 2
		local deluxeEndoFirePitIngredient_cutstone = 14

		local deluxeEndoFirePitRecipeCost = (GetModConfigData("recipeCost"))


		if deluxeEndoFirePitRecipeCost == "testing" then
			local endo_firepit = AddRecipe("endo_firepit",
			{
				Ingredient("log", 1),
			},
				RECIPETABS.LIGHT, TECH.NONE, "endo_firepit_placer" ) 
				endo_firepit.atlas = "images/inventoryimages/endo_firepit.xml"
		else



			if deluxeEndoFirePitRecipeCost == "cheap" then
				deluxeEndoFirePitIngredient_nitre = 2
				deluxeEndoFirePitIngredient_doodads = 1
				deluxeEndoFirePitIngredient_cutstone = 5
			elseif deluxeEndoFirePitRecipeCost == "expensive" then
				deluxeEndoFirePitIngredient_nitre = 9
				deluxeEndoFirePitIngredient_doodads = 4
				deluxeEndoFirePitIngredient_cutstone = 20
			end


				local endo_firepit = AddRecipe("endo_firepit",
			{
				Ingredient("nitre", deluxeEndoFirePitIngredient_nitre),
				Ingredient("transistor",deluxeEndoFirePitIngredient_doodads),
				Ingredient("cutstone", deluxeEndoFirePitIngredient_cutstone)
			},
				RECIPETABS.LIGHT, TECH.NONE, "endo_firepit_placer" ) 
				endo_firepit.atlas = "images/inventoryimages/endo_firepit.xml"
		--
		end



--HEAT STAR

	-- Heat Star dialog
		GLOBAL.STRINGS.NAMES.HEAT_STAR = "火焰之星"
		STRINGS.RECIPE_DESC.HEAT_STAR = "创建你自己的阳光!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEAT_STAR  =
				{
					OUT = "现在看起来很美,我怎么再次激活它?",
					EMBERS = "我还是不能相信这是一个明星!快,更好的喂它一些",
					LOW = "现在看起来很小",
					NORMAL = "我认为它的安全...",
					HIGH = "它像太阳....只有我旁边……哇很热!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.HEAT_STAR  =
				{
					OUT = "系统错误243:ANCHIALE之星——没有数据;",
					EMBERS = "关键错误:量子通量不能消极:无法计算!",
					LOW = "警告:反向原子波可能会不稳定",
					NORMAL = "警告:稳定性的措施以及未知",
					HIGH = "警告:超过指定的限制",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.HEAT_STAR  =
				{
					OUT = "??!!!?!??",
					EMBERS = "他要求太多!",
					LOW = "小和微弱的明星!",
					NORMAL = "这是一种不可思议的力量！!!",
					HIGH = "怎么能比我的更令人印象深刻的强大的体质吗!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.HEAT_STAR  =
				{
					OUT = "我等不及要激活它的荣耀!",
					EMBERS = "这颗恒星是可悲的!",
					LOW = "多么可爱的景象,但我知道它可以更大!",
					NORMAL = "这是有史以来最好的事情!!",
					HIGH = "我想我恋爱了!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HEAT_STAR  =
				{
					OUT = "漂亮的详细的在各方面",
					EMBERS = "这不会做!!",
					LOW = "这将很好的达到我的目的.",
					NORMAL = "简单的神奇!",
					HIGH = "我真的应该后退几步!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.HEAT_STAR  =
				{
					OUT = "“火焰之星”不是我的书吗??",
					EMBERS = "这仅仅是一个明星...",
					LOW = "应该有人文档这一现象",
					NORMAL = "惊人的可怕,至少它让我温暖",
					HIGH = "这与所有的物理定律!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.HEAT_STAR  =
				{
					OUT = "雕刻在底座上读取的火焰的精神永远不会冷'",
					EMBERS = "不,不要精神!!",
					LOW = "阿比盖尔有伴侣,但我需要加油保持它的活力",
					NORMAL = "另一个精神让我和阿比盖尔温暖和安全",
					HIGH = "我必须做一些事来激怒这个精神。停止你吓到我了!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.HEAT_STAR  =
				{
					OUT = "露西,这看起来不安全...",
					EMBERS = "它看起来不非常强大的露西...",
					LOW = "露西我已经看到一切!",
					NORMAL = "嗨,露西,我想知道它徘徊在这样的?",
					HIGH = "露西,退后...它看起来像要爆炸!",
				}

--		if GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) then 

			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.HEAT_STAR  =
					{
						OUT = "这是神奇!",
						EMBERS = "好像不够!",
						LOW = "喔，好棒!!",
						NORMAL = "真是奇迹！",
						HIGH = "不，太可怕了!!",
					}


			 GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.HEAT_STAR  =
					{
						OUT = "只,燃烧的东西出来...",
						EMBERS = "我们需要让它更只和燃烧的!",
						LOW = "我们已经看到这么多亮,需要更多的燃料!!",
						NORMAL = "现在这仅仅是我们所需要的——一个燃烧的太阳在我们的大本营",
						HIGH = "我们希望它不能再大!!",
					}

--		end

	-- Heat Star config opions
		GLOBAL.heatStarBurnRate = GetModConfigData("heatStarBurnRate")
		GLOBAL.heatStarDropLoot = GetModConfigData("heatStarDropLoot")
		GLOBAL.heatStar_starsSpawnHounds = GetModConfigData("starsSpawnHounds")
	--

	-- heatStar Recipe


		-- standard cost
		local heatStarIngredient_gears = 2
		local heatStarIngredient_cutstone = 30
		local heatStarIngredient_redgem = 1

		local heatStarRecipeCost = (GetModConfigData("recipeCost"))

		if heatStarRecipeCost == "testing" then
			local heatStar = AddRecipe("heat_star",
			{
				Ingredient("log", 1),
			},
				RECIPETABS.LIGHT, TECH.NONE, "heat_star_placer" ) 
				heatStar.atlas = "images/inventoryimages/heat_star.xml"
		else


		if heatStarRecipeCost == "cheap" then
			heatStarIngredient_gears = 1
			heatStarIngredient_cutstone = 5
			heatStarIngredient_redgem = 1
		elseif heatStarRecipeCost == "expensive" then
			heatStarIngredient_gears = 5
			heatStarIngredient_cutstone = 40
			heatStarIngredient_redgem = 2
		end



			local heatStar = AddRecipe("heat_star",
		{
			Ingredient("gears", heatStarIngredient_gears),
			Ingredient("cutstone", heatStarIngredient_cutstone),
			Ingredient("redgem", heatStarIngredient_redgem)
		},
			RECIPETABS.LIGHT, TECH.NONE, "heat_star_placer" ) 
			heatStar.atlas = "images/inventoryimages/heat_star.xml"
	--
	end


--
---------------------------------------------------


---------------------------------------------------
--  Coolers (Only available in RoG DLC)
---------------------------------------------------

--ICE STAR

--	if (GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS)) then 

	-- Ice Star dialog
		GLOBAL.STRINGS.NAMES.ICE_STAR = "北风之神之星"
		STRINGS.RECIPE_DESC.ICE_STAR = "创建一个星冰做的!!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICE_STAR  =
				{
					OUT = "它看起来冷,现在我如何激活一次?",
					EMBERS = "我还是不能相信它的冰星!我不知道会发生什么当它熄灭了?!",
					LOW = "现在看起来很小,不敢相信它还是那么冷!",
					NORMAL = "谢谢巨星……这种程度的冷却是完美的!",
					HIGH = "一个巨大的球的冰. .这个真的不能安全!太太太冷!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.ICE_STAR  =
				{
					OUT = "系统错误243:北风之星——没有数据;",
					EMBERS = "关键错误:量子消极:无法计算!",
					LOW = "警告:反向原子波可能会不稳定",
					NORMAL = "冷却在可接受的水平",
					HIGH = "警告:超过量子极限",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ICE_STAR  =
				{
					OUT = "??!!!?!??",
					EMBERS = "她要求太多!",
					LOW = "我自己会更好!!",
					NORMAL = "我需要在炎热的夏季的一天!!",
					HIGH = "怎么能比我的更令人印象深刻的强大的体质吗!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.ICE_STAR  =
				{
					OUT = "这是一个厌恶! !火焰应该是热的!!",
					EMBERS = "这颗恒星看起来可怜!和蓝色的趣事!",
					LOW = "我讨厌星星蓝色火焰,这不是自然的!",
					NORMAL = "一个寒冷的明星?!!",
					HIGH = "现在你只是炫耀!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ICE_STAR  =
				{
					OUT = "漂亮的详细的在各方面",
					EMBERS = "这不会做!!",
					LOW = "这将很好的达到我的目的.",
					NORMAL = "简单地令人惊叹!这需要的热量",
					HIGH = "我真的应该后退几步,可以冻结另一个世界?!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ICE_STAR  =
				{
					OUT = "“北风之星”不是我的书?",
					EMBERS = "这仅仅是一个明星...",
					LOW = "应该有人文档这一现象",
					NORMAL = "这个东西怎么能冷却我那么好呢??",
					HIGH = "这与物理定律!在很多层面上!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.ICE_STAR  =
				{
					OUT = "雕刻在底座上读取的北风之神的精神将冻结你的骨骼'",
					EMBERS = "不,不要精神!!",
					LOW = "阿比盖尔有伴侣,但我需要加油保持它的活力",
					NORMAL = "我觉得很冷!",
					HIGH = "我必须做一些事来激怒这个精神。停止...你吓到我了!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.ICE_STAR  =
				{
					OUT = "露西,我不相信...",
					EMBERS = "它看起来不非常强大的露西...",
					LOW = "我已经看到一切!",
					NORMAL = "嗨,露西,我想知道它徘徊在这样的?",
					HIGH = "露西,回来...它看起来像要崩溃!",
				}

			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ICE_STAR  =
					{
						OUT = "真难以置信!",
						EMBERS = "不是那么强大!",
						LOW = "真棒!!",
						NORMAL = "它一直这样么？",
						HIGH = "不！它快失控了!!",
					}


			 GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.ICE_STAR  =
					{
						OUT = "带蓝色的东西出来...",
						EMBERS = "我们需要更多!",
						LOW = "我们已经看到这么多亮,几乎没有冷却我们失望!",
						NORMAL = "这正是我们需要整天在加热后",
						HIGH = "它就像冬天...在夏天!!!",
					}

	--

	-- Ice Star config opions
		GLOBAL.iceStarBurnRate = GetModConfigData("iceStarBurnRate")
		GLOBAL.iceStarDropLoot = GetModConfigData("iceStarDropLoot")
		GLOBAL.iceStar_starsSpawnHounds = GetModConfigData("starsSpawnHounds")
	--

	-- iceStar Recipe


		-- standard cost
		local iceStarIngredient_transistor = 2
		local iceStarIngredient_cutstone = 30
		local heatStarIngredient_bluegem = 1

		local iceStarRecipeCost = (GetModConfigData("recipeCost"))

		if iceStarRecipeCost == "testing" then
			local iceStar = AddRecipe("ice_star",
			{
				Ingredient("log", 1),
			},
				RECIPETABS.LIGHT, TECH.NONE, "ice_star_placer" ) 
				iceStar.atlas = "images/inventoryimages/ice_star.xml"
		else


		if iceStarRecipeCost == "cheap" then
			iceStarIngredient_transistor = 1
			iceStarIngredient_cutstone = 5
			heatStarIngredient_bluegem = 1
		elseif iceStarRecipeCost == "expensive" then
			iceStarIngredient_transistor = 5
			iceStarIngredient_cutstone = 40
			heatStarIngredient_bluegem = 2
		end



			local iceStar = AddRecipe("ice_star",
		{
			Ingredient("transistor", iceStarIngredient_transistor),
			Ingredient("cutstone", heatStarIngredient_cutstone),
			Ingredient("bluegem", heatStarIngredient_bluegem)
		},
			RECIPETABS.LIGHT, TECH.NONE, "ice_star_placer" ) 
			iceStar.atlas = "images/inventoryimages/ice_star.xml"
	--
	end
---------------------------------------------------
