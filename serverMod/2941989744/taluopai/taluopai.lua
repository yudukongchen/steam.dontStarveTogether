local function bofangyinxiao(inst)    ---播放所有人都可以听到的塔罗牌音效
	if inst then
		if inst.SoundEmitter then
			inst.SoundEmitter:PlaySound("guipai/NGXY/guipaiya")
		end
	end
end
local function yuzhe(inst, reader) ---愚者：从零开始
	if TheNet then
		TheNet:Announce("*愚者：此次效果作废（愚者应当从头开始）。")
	end
	if reader then
		bofangyinxiao(reader)
	end
	return true
end
local function yuzhe2(inst, reader) ---愚者：从零开始
	if TheNet then
		TheNet:Announce("*？愚者：愚者应当从头开始。")
	end
	if reader then
		bofangyinxiao(reader)
	end
	if reader and reader.components.health then
	reader.components.health:SetVal(0.1, "daodiaoren")
	if reader.components.inventory then
	reader.components.inventory:GiveItem(SpawnPrefab("lifeinjector"))
	reader.components.inventory:GiveItem(SpawnPrefab("lifeinjector"))
	reader.components.inventory:GiveItem(SpawnPrefab("lifeinjector"))
	end
	end
	return true
end

local function emo(inst, reader) ---恶魔：神秘所带来未知
	if TheNet then
		TheNet:Announce("*恶魔：世界玩家精神归零（神秘所带来未知）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v.components.sanity then
				v.components.sanity:SetPercent(0, inst)
				bofangyinxiao(v)
			end
		end
	end
	return true
end

local function emo2(inst, reader) ---恶魔：神秘所带来未知
	if TheNet then
		TheNet:Announce("*？恶魔：世界玩家饥饿值归零（神秘所带来未知）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v.components.hunger then
				v.components.hunger:SetPercent(0, inst)
				bofangyinxiao(v)
			end
		end
	end
	return true
end


local function sishen(inst, reader) ---死神：畏惧所带来毁灭
	if TheNet then
		TheNet:Announce("*死神：全屏猎杀，每个目标随机造成一次伤害并生成燃料（畏惧所带来毁灭）。")
	end
	local x, y, z = reader.Transform:GetWorldPosition()
	local range = 45
	local ents = TheSim:FindEntities(x, y, z, range, nil, { "INLIMBO", "companion" })


	for k, v in pairs(ents) do
		if v and v.components.combat and v.components.health and v:IsValid() then
			SpawnPrefab("lightning").Transform:SetPosition(v.Transform:GetWorldPosition())
			SpawnPrefab("nightmarefuel").Transform:SetPosition(v.Transform:GetWorldPosition())
			v.components.combat:GetAttacked(reader, math.random(500, 100000))
			bofangyinxiao(v)
		end
	end
	return true
end

local function sishen2(inst, reader) ---死神：畏惧所带来毁灭
	if TheNet then
		TheNet:Announce("*？死神：全屏范围内的所有非生命体直接摧毁并生成燃料（畏惧所带来毁灭）。")
	end
	local x, y, z = reader.Transform:GetWorldPosition()
	local range = 45
	local ents = TheSim:FindEntities(x, y, z, range, nil, { "INLIMBO", "companion" })


	for k, v in pairs(ents) do
		if v and v:IsValid() and v.components.workable ~= nil and v.components.workable:GetWorkAction() and v.components.workable:CanBeWorked() then
			SpawnPrefab("lightning").Transform:SetPosition(v.Transform:GetWorldPosition())
			SpawnPrefab("nightmarefuel").Transform:SetPosition(v.Transform:GetWorldPosition())
            v.components.workable:Destroy(reader)              
			bofangyinxiao(v)
		end
	end
	return true
end

local function nvjisi(inst, reader) ---女祭司：献祭所带来希望
	if TheNet then
		TheNet:Announce("*女祭司：世界内玩家从幽灵中复活（献祭所带来希望）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v:HasTag("playerghost") then
			v:PushEvent("respawnfromghost", { source = reader })
			end
			bofangyinxiao(v)
		end
	end
	return true
end
local function nvjisi2(inst, reader) ---女祭司：献祭所带来希望
	if TheNet then
		TheNet:Announce("*?女祭司：世界内玩家从幽灵中复活并回满三维（献祭所带来希望）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v:HasTag("playerghost") then
			v:PushEvent("respawnfromghost", { source = reader })
				if v.components.hunger then v.components.hunger:SetPercent(1, inst) end
				if v.components.sanity then v.components.sanity:SetPercent(1, inst) end
				if v.components.health then v.components.health:SetPercent(1, inst)	end 	
			end
			bofangyinxiao(v)
		end
	end
	return true
end

local function daodiaoren(inst, reader) ---倒吊人：畏惧所带来绝望
	if TheNet then
		TheNet:Announce("*倒吊人：即死（畏惧所带来绝望）。")
	end

	if reader and reader.components.health and not reader.components.health:IsDead() and not reader:HasTag("playerghost")  then
		reader.components.health:SetVal(0, "daodiaoren")
		reader:PushEvent("death", { cause = "daodiaoren", afflicter = nil })
		bofangyinxiao(reader)
	end
	return true
end

local function daodiaoren2(inst, reader) ---倒吊人：畏惧所带来绝望
	if TheNet then
		TheNet:Announce("*?倒吊人：?畏惧死亡（畏惧所带来绝望）。")
	end

	if reader and reader.components.inventory then
	for k = 1,40 do
       if reader.components.inventory then reader.components.inventory:GiveItem(SpawnPrefab("nightmarefuel")) end
	end
		bofangyinxiao(reader)
	end
	return true
end

STRINGS.NAMES.DAODIAOREN = "倒吊人"

local function yueliang(inst, reader) ---月亮：愿你失而复得
	if TheNet then
		TheNet:Announce("*月亮：设置世界黑夜+满月（愿你失而复得）。")
	end
	if TheWorld:HasTag("cave") then
		return false
	end
	if reader then
		bofangyinxiao(reader)
	end
	TheWorld:PushEvent("ms_setclocksegs", { day = 0, dusk = 0, night = 16 })
	TheWorld:PushEvent("ms_setmoonphase", { moonphase = "full" })
	return true
end


local function xingxing(inst, reader) ---星星：愿你心想事成
	if TheNet then
		TheNet:Announce("*星星：设置世界黑夜+新月（愿你心想事成）。")
	end
	if TheWorld:HasTag("cave") then
		return false
	end
	if reader then
		bofangyinxiao(reader)
	end
	TheWorld:PushEvent("ms_setclocksegs", { day = 0, dusk = 0, night = 16 })
	TheWorld:PushEvent("ms_setmoonphase", { moonphase = "new", iswaxing = true })
	return true
end
local function taiyang(inst, reader) ---太阳：愿光赐你启示
	if TheNet then
		TheNet:Announce("*太阳：世界设置为天亮（愿光赐你启示）。")
	end
	if TheWorld:HasTag("cave") then
		return false
	end
	if reader then
		bofangyinxiao(reader)
	end
	TheWorld:PushEvent("ms_setclocksegs", { day = 16, dusk = 0, night = 0 })
	return true
end


local function zhanche(inst, reader) ---战车：愿您所向披靡
	if TheNet then
		TheNet:Announce("*战车：愿您所向披靡。")
	end
	if reader then
		bofangyinxiao(reader)
	end
	if reader then
		SpawnPrefab("minotaur").Transform:SetPosition(reader.Transform:GetWorldPosition())
	end
	return true
end

local function zhanche2(inst, reader) ---战车：愿您所向披靡
	if TheNet then
		TheNet:Announce("*？战车：？愿您所向披靡。")
	end
	if reader then
		bofangyinxiao(reader)
	end
	if reader then
		SpawnPrefab("shadow_knight").Transform:SetPosition(reader.Transform:GetWorldPosition())
		SpawnPrefab("shadow_bishop").Transform:SetPosition(reader.Transform:GetWorldPosition())
		SpawnPrefab("shadow_rook").Transform:SetPosition(reader.Transform:GetWorldPosition())
	end
	return true
end

local function shenpan(inst, reader) ---审判：为避审而审判
	if TheNet then
		TheNet:Announce("*审判：除使用者之外的玩家即死（为避审而审判）")
		TheNet:Announce(
			"我又看见死了的人，无论大小，都站在宝座前。案卷展开了。并且另有一卷展开，就是生命册。死了的人都凭着这些案卷所记载的，照他们所行的受审判。于是海交出其中的死人。死亡和阴间也交出其中的死人。他们都照各人所行的受审判。死亡和阴间也被扔在火湖里。这火湖就是第二次的死")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v ~= reader and reader and v.components.health and not v.components.health:IsDead() and not v:HasTag("playerghost")  then
				v.components.health:SetVal(0, "shenpan")
				v:PushEvent("death", {
					cause = "shenpan",
					afflicter = nil
				})
				bofangyinxiao(v)
			end
		end
	end
	return true
end
local function shenpan2(inst, reader) ---审判：为避审而审判
	if TheNet then
		TheNet:Announce("*？审判：？世界 黑暗 冰凌 阴霾（？你会审判我吗）")
		TheNet:Announce(
			"无论如何，我看到了死亡，看到了残忍和埋葬，我不希望世界如此灰暗，假如一切归于黑暗，将世间万物抹掉，这会是人类最好的结局。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v ~= reader and reader and v.components.health and not v.components.health:IsDead() and not v:HasTag("playerghost")  then
			    if v.components.moisture then
					v.components.moisture:DoDelta(100)
				end
				bofangyinxiao(v)
			end
		end
	end
	TheWorld:PushEvent("ms_forceprecipitation", true)
	TheWorld:PushEvent("ms_setclocksegs", { day = 0, dusk = 0, night = 16 })
	return true
end
STRINGS.NAMES.SHENPAN = "审判"
local function yinzhe(inst, reader) ---隐者：愿您看破红尘
	if TheNet then
		TheNet:Announce("*隐者：当前世界玩家回满精神（愿您看破红尘）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v.components.sanity then
				v.components.sanity:SetPercent(1, inst)
				bofangyinxiao(v)
			end
		end
	end
	return true
end
local function yinzhe2(inst, reader) ---隐者：愿您看破红尘
	if TheNet then
		TheNet:Announce("*?隐者：当前世界玩家疾病缠身（愿您看破红尘）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v.components.health then
                v.components.health:DeltaPenalty(0.25)
				bofangyinxiao(v)
			end
		end
	end
	return true
end

local function ta(inst, reader)
	if TheNet then
		TheNet:Announce("*塔：当前世界玩家脚下生成火药（毁灭带来创造）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v then
				local zhadanranshaode = SpawnPrefab("gunpowder")
				if zhadanranshaode then zhadanranshaode.Transform:SetPosition(v.Transform:GetWorldPosition()) end
				bofangyinxiao(v)
			end
		end
	end
	return true
end

local function ta2(inst, reader)
	if TheNet then
		TheNet:Announce("*塔：当前世界玩家停止移动三秒（毁灭带来创造）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v.components.combat then
				if v.taluopaita ~= nil then
					v.taluopaita:Cancel()
					v.taluopaita = nil
				end
				if v.components.locomotor then v.components.locomotor:SetExternalSpeedMultiplier(v, "taluopaita", 0) end
				v.taluopaita = v:DoTaskInTime(5, function()
					if v and v.components.combat then
						if v.components.locomotor then v.components.locomotor:RemoveExternalSpeedMultiplier(v, "taluopaita") end
						bofangyinxiao(v)
					end
				end)
			end
		end
	end
	return true
end


local function lianren(inst, reader) ---恋人：愿您健康繁盛
	if TheNet then
		TheNet:Announce("*恋人：当前世界玩家健康回满并消除生命上限惩罚（愿您健康繁盛）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v.components.health then
				v.components.health:DeltaPenalty(-1)
				v.components.health:SetPercent(1, inst)
				bofangyinxiao(v)
			end
		end
	end
	return true
end

local function lianren2(inst, reader) ---恋人：愿您健康繁盛
	if TheNet then
		TheNet:Announce("*?恋人：当前世界三维全部回满（愿您健康繁盛）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v.components.health  and v.components.sanity then
				if v.components.hunger then v.components.hunger:SetPercent(1, inst) end
				if v.components.sanity then v.components.sanity:SetPercent(1, inst) end
				if v.components.health then v.components.health:SetPercent(1, inst)	end 
				bofangyinxiao(v)
			end
		end
	end
	return true
end

local function shijie(inst, reader) ---世界：睁眼洞察世界
	if TheNet then
		TheNet:Announce("*世界：你将获得全图视野（睁眼洞察世界）。")
	end
	local x1, y1 = TheWorld.Map:GetSize()
	for x = -x1 * 4, y1 * 4, 30 do
		for y = -x1 * 4, y1 * 4, 30 do
			if reader then reader.player_classified.MapExplorer:RevealArea(x, 0, y) end
		end
	end
	if reader then bofangyinxiao(reader) end
	return true
end

local function moshushi(inst, reader) ---魔术师：全世界玩家将传送你的脚下
	if TheNet then
		TheNet:Announce("*魔术师：当前世界玩家将脚下生成肉雕像（你是女巫吗）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v then
				local roudiaoxiang = SpawnPrefab("resurrectionstatue")
				roudiaoxiang.Transform:SetPosition(v.Transform:GetWorldPosition())
				bofangyinxiao(v)
			end
		end
	end
	return true
end

local function moshushi2(inst, reader) ---魔术师：全世界玩家将传送你的脚下
	if TheNet then
		TheNet:Announce("*?魔术师：全世界玩家将传送你的脚下（你是女巫吗）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v ~= reader then
				v.Transform:SetPosition(reader.Transform:GetWorldPosition())
				bofangyinxiao(v)
			end
		end
	end
	return true
end

local function jiezhi(inst, reader) ---节制：愿您内心纯洁
	if TheNet then
		TheNet:Announce("*节制：阅读者给予随机蓝图（愿您内心纯洁）。")
	end
	-- if AllPlayers then
		-- for i, v in ipairs(AllPlayers) do
			-- if v and v.components.health then
				-- v.components.health:SetPercent(0.01, inst)
				-- bofangyinxiao(v)
			-- end
		-- end
	-- end
	if reader.components.inventory then reader.components.inventory:GiveItem(SpawnPrefab("blueprint")) end
	
	return true
end
local function zhengyi(inst, reader) ---正义：愿您仕途平稳
	if TheNet then
		TheNet:Announce("正义：愿您仕途平稳")
	end
	local zhengyisuiji = math.random(1, 3)
	if reader then
		if zhengyisuiji and zhengyisuiji == 1 then
			local bearger = SpawnPrefab("bearger")
			if bearger and bearger.components.health and reader then
				bearger.components.health.maxhealth = 1000000
				bearger.components.health:SetPercent(1, bearger)
				bearger.Transform:SetPosition(reader.Transform:GetWorldPosition())
			end
		end
		if zhengyisuiji and zhengyisuiji == 2 then
			local deerclops = SpawnPrefab("deerclops")
			if deerclops and deerclops.components.health and reader then
				deerclops.components.health.maxhealth = 1000000
				deerclops.components.health:SetPercent(1, deerclops)
				deerclops.Transform:SetPosition(reader.Transform:GetWorldPosition())
			end
		end

		if zhengyisuiji and zhengyisuiji == 3 then
			local toadstool = SpawnPrefab("toadstool")
			if toadstool and toadstool.components.health and reader then
				toadstool.components.health.maxhealth = 1000000
				toadstool.components.health:SetPercent(1, toadstool)
				toadstool.Transform:SetPosition(reader.Transform:GetWorldPosition())
			end
		end
		bofangyinxiao(reader)
	end
	return true
end
local function zhengyi2(inst, reader) ---正义：愿您仕途平稳
	if TheNet then
		TheNet:Announce("?正义：?愿您仕途平稳")
	end
	local zhengyisuiji = math.random(1, 3)
	if reader then
		if zhengyisuiji and zhengyisuiji == 1 then
			local bearger = SpawnPrefab("klaus")
			if bearger and bearger.components.health and reader then
				-- bearger.components.health.maxhealth = 1000000
				bearger.components.health:SetPercent(1, bearger)
				bearger.Transform:SetPosition(reader.Transform:GetWorldPosition())
			end
		end
		if zhengyisuiji and zhengyisuiji == 2 then
			local deerclops = SpawnPrefab("klaus")
			if deerclops and deerclops.components.health and reader then
				-- deerclops.components.health.maxhealth = 1000000
				deerclops.components.health:SetPercent(1, deerclops)
				deerclops.Transform:SetPosition(reader.Transform:GetWorldPosition())
			end
		end

		if zhengyisuiji and zhengyisuiji == 3 then
			local toadstool = SpawnPrefab("klaus")
			if toadstool and toadstool.components.health and reader then
				-- toadstool.components.health.maxhealth = 1000000
				toadstool.components.health:SetPercent(1, toadstool)
				toadstool.Transform:SetPosition(reader.Transform:GetWorldPosition())
			end
		end
		bofangyinxiao(reader)
	end
	return true
end

local function liliang(inst, reader) ---力量：愿您仕途平稳
	if TheNet then
		TheNet:Announce("*力量：世界玩家 攻击伤害提升 300% 持续 300 秒（愿您力中唤怒）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v.components.combat then
			v.components.combat.externaldamagemultipliers:RemoveModifier("liliang")
				if v.liliangjiechu ~= nil then
					v.liliangjiechu:Cancel()
					v.liliangjiechu = nil
				end
				v.components.combat.externaldamagemultipliers:SetModifier("liliang", 3)
				v.liliangjiechu = v:DoTaskInTime(300, function()
					if v and v.components.combat then
						v.components.combat.externaldamagemultipliers:RemoveModifier("liliang")
						bofangyinxiao(v)
					end
				end)
			end
		end
	end
	return true
end
local function liliang2(inst, reader) ---力量：愿您仕途平稳
	if TheNet then
		TheNet:Announce("*?力量：世界玩家 攻击伤害减少 100% 持续 60 秒（愿您力中唤怒）。")
	end
	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v.components.combat then
			v.components.combat.externaldamagemultipliers:RemoveModifier("liliang")
				if v.liliangjiechu ~= nil then
					v.liliangjiechu:Cancel()
					v.liliangjiechu = nil
				end
				v.components.combat.externaldamagemultipliers:SetModifier("liliang", 0)
				v.liliangjiechu = v:DoTaskInTime(60, function()
					if v and v.components.combat then
						v.components.combat.externaldamagemultipliers:RemoveModifier("liliang")
						bofangyinxiao(v)
					end
				end)
			end
		end
	end
	return true
end

local function huangdi(inst, reader) ---皇帝：挑战我！
	if TheNet then
		TheNet:Announce("皇帝：挑战我！")
	end
	local qingtinglong = SpawnPrefab("dragonfly")
	if qingtinglong and qingtinglong.components.health and reader then
		qingtinglong.components.health.maxhealth = 1000000
		qingtinglong.components.health:SetPercent(1, qingtinglong)
		qingtinglong.Transform:SetPosition(reader.Transform:GetWorldPosition())
		bofangyinxiao(reader)
	end
	return true
end

local function huangdi2(inst, reader) ---皇帝：挑战我！
	if TheNet then
		TheNet:Announce("？皇帝：？挑战我？")
	end
	local qingtinglong = SpawnPrefab("minotaur")
	if qingtinglong and qingtinglong.components.health and reader then
		qingtinglong.components.health.maxhealth = 1000000
		qingtinglong.components.health:SetPercent(1, qingtinglong)
		qingtinglong.Transform:SetPosition(reader.Transform:GetWorldPosition())
		bofangyinxiao(reader)
	end
	return true
end

local function nvhuang(inst, reader) ---女皇：愿您怒中生力！
	if TheNet then
		TheNet:Announce("*女皇：当前世界玩家获得 200% 移速加成，持续 300 秒（愿您怒中生力）。")
	end

	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v.components.locomotor then
				v.components.locomotor:RemoveExternalSpeedMultiplier(v, "nvhuang")
				if v.nvhuang ~= nil then
					v.nvhuang:Cancel()
					v.nvhuang = nil
				end
				v.components.locomotor:SetExternalSpeedMultiplier(v, "nvhuang", 2)
				v.nvhuang = v:DoTaskInTime(300, function()
					if v and v.components.locomotor then
						v.components.locomotor:RemoveExternalSpeedMultiplier(v, "nvhuang")
						bofangyinxiao(v)
					end
				end)
			end
		end
	end
	return true
end
local function nvhuang2(inst, reader) ---女皇：愿您怒中生力！
	if TheNet then
		TheNet:Announce("*？女皇：当前世界玩家获得 50% 伤害吸收，持续 300 秒（愿您怒中生力）。")
	end

	if AllPlayers then
		for i, v in ipairs(AllPlayers) do
			if v and v.components.health then
			
				v["components"]["health"]["externalabsorbmodifiers"]:RemoveModifier(v, "nvhuang2")
				if v.nvhuang2 ~= nil then
					v.nvhuang2:Cancel()
					v.nvhuang2 = nil
				end
				v["components"]["health"]["externalabsorbmodifiers"]:SetModifier(v, .5, "nvhuang2")
				v.nvhuang2 = v:DoTaskInTime(300, function()
					if v and v.components.health then
						v["components"]["health"]["externalabsorbmodifiers"]:RemoveModifier(v, "nvhuang2")
						bofangyinxiao(v)
					end
				end)
			end
		end
	end
	return true
end
function suijitaluopai(inst, reader) ---随机一张塔罗牌
	local taluoxiaoguo = math.random(1, 22)
	if taluoxiaoguo and inst and reader and reader.components.inventory then
		local taluopaizifuchuan = taluoxiaoguo == 1 and "taluopai_daodiaoren" or  
		taluoxiaoguo == 2 and "taluopai_em" or
		taluoxiaoguo == 3 and "taluopai_huangdi" or
		taluoxiaoguo == 4 and "taluopai_jiezhi" or
		taluoxiaoguo == 5 and "taluopai_lianren" or
		taluoxiaoguo == 6 and "taluopai_liliang" or
		taluoxiaoguo == 7 and "taluopai_mingyun" or
		taluoxiaoguo == 8 and "taluopai_moshushi" or
		taluoxiaoguo == 9 and "taluopai_nvhuang" or
		taluoxiaoguo == 10 and "taluopai_nvjisi" or
		taluoxiaoguo == 11 and "taluopai_shenpan" or
		taluoxiaoguo == 12 and "taluopai_shijie" or
		taluoxiaoguo == 13 and "taluopai_sishen" or
		taluoxiaoguo == 14 and "taluopai_ta" or
		taluoxiaoguo == 15 and "taluopai_taiyang" or
		taluoxiaoguo == 16 and "taluopai_xingxing" or
		taluoxiaoguo == 17 and "taluopai_yinzhe" or
		taluoxiaoguo == 18 and "taluopai_yueliang" or
		taluoxiaoguo == 19 and "taluopai_yuzhe" or
		taluoxiaoguo == 20 and "taluopai_zhengyi" or
		taluoxiaoguo == 21 and "taluopai_zhanche" or
		taluoxiaoguo == 22 and "taluopai_jiaohuang" 
		if taluopaizifuchuan then
		reader.components.inventory:GiveItem(SpawnPrefab(taluopaizifuchuan))
		end
		if taluoxiaoguo == 1 then
			daodiaoren(inst, reader) ---抽到倒吊人 得死一次。
		end
		bofangyinxiao(reader)
	end
end

GLOBAL.suijitaluopai = suijitaluopai

local function mingyun(inst, reader) ---命运-转动命运之轮
				if TheNet then
					TheNet:Announce("命运之轮：转动命运之轮")
				end
				suijitaluopai(inst, reader)
end

local function jiaohuang(inst, reader) ---教皇：祷告两次！
	if TheNet then
		TheNet:Announce("*教皇：祷告两次。")
	end
				suijitaluopai(inst, reader)				suijitaluopai(inst, reader)

	return true
end

local function taluopaiduiyingxiaoguo(inst,reader)
if inst and reader then
	if inst.prefab == "taluopai_daodiaoren" then
			if math.random(1, 100) <= 50  then 
				daodiaoren(inst, reader)
			else
				daodiaoren2(inst, reader)
			end
	elseif inst.prefab == "taluopai_em" then
			if math.random(1, 100) <= 50  then 
				emo(inst, reader)
			else
				emo2(inst, reader)
			end
	elseif inst.prefab == "taluopai_huangdi" then
			if math.random(1, 100) <= 50  then 
				huangdi(inst, reader)
			else
				huangdi2(inst, reader)
			end
	elseif inst.prefab == "taluopai_jiezhi" then
	
			jiezhi(inst, reader) 
	elseif inst.prefab == "taluopai_lianren" then
			if math.random(1, 100) <= 50  then 
				lianren(inst, reader)
			else
				lianren2(inst, reader)
			end
	elseif inst.prefab == "taluopai_liliang" then
			if math.random(1, 100) <= 50  then 
				liliang(inst, reader)
			else
				liliang2(inst, reader)
			end

	elseif inst.prefab == "taluopai_mingyun" then

				mingyun(inst, reader)

	elseif inst.prefab == "taluopai_moshushi" then
			if math.random(1, 100) <= 50  then 
			moshushi(inst, reader) 
			else
			moshushi2(inst, reader) 
			end
	elseif inst.prefab == "taluopai_nvhuang" then
			if math.random(1, 100) <= 50  then 
			nvhuang(inst, reader) 
			else
			nvhuang2(inst, reader) 
			end
	elseif inst.prefab == "taluopai_nvjisi" then
			if math.random(1, 100) <= 50 then 
			nvjisi(inst, reader) 
			else
			nvjisi2(inst, reader) 
			end

	elseif inst.prefab == "taluopai_shenpan" then
			if math.random(1, 100) <= 50 then 
						shenpan(inst, reader) 
			else
						shenpan2(inst, reader) 
			end
	elseif inst.prefab == "taluopai_shijie" then
			shijie(inst, reader) 
	elseif inst.prefab == "taluopai_sishen" then
			if math.random(1, 100) <= 50  then 
				sishen(inst, reader)
			else
				sishen2(inst, reader)
			end
	elseif inst.prefab == "taluopai_ta" then
			if math.random(1, 100) <= 50  then 
				ta(inst, reader)
			else
				ta2(inst, reader)
			end
	elseif inst.prefab == "taluopai_taiyang" then
			taiyang(inst, reader) 
	elseif inst.prefab == "taluopai_xingxing" then
			xingxing(inst, reader) 
	elseif inst.prefab == "taluopai_yinzhe" then
			if math.random(1, 100) <= 50  then 
				yinzhe(inst, reader)
			else
				yinzhe2(inst, reader)
			end
	elseif inst.prefab == "taluopai_yueliang" then
			yueliang(inst, reader) 
	elseif inst.prefab == "taluopai_yuzhe" then
			if math.random(1, 100) <= 50  then 
				yuzhe(inst, reader)
			else
				yuzhe2(inst, reader)
			end
	elseif inst.prefab == "taluopai_zhengyi" then
			if math.random(1, 100) <= 50  then 
				zhengyi(inst, reader)
			else
				zhengyi2(inst, reader)
			end
	elseif inst.prefab == "taluopai_zhanche" then
			if math.random(1, 100) <= 50  then 
				zhanche(inst, reader)
			else
				zhanche2(inst, reader)
			end
	elseif inst.prefab == "taluopai_jiaohuang" then
			jiaohuang(inst, reader) 	
	end
	bofangyinxiao(reader)
end
end
local TALUOPAIYUEDU = Action({ priority = 1, mount_valid = false })
TALUOPAIYUEDU.id = "TALUOPAIYUEDU"
TALUOPAIYUEDU.str = "激活塔罗牌"
TALUOPAIYUEDU.fn = function(act)
local target = act and act.target or act and act.invobject or nil
if act and target and act.doer and target:IsValid() and act.doer:HasTag("player") and not act.doer:HasTag("playerghost") then
  taluopaiduiyingxiaoguo(target,act.doer)
  
				if target and target:IsValid() then
					if target.components.stackable then
						target.components.stackable:Get(1):Remove()
					else
						target:Remove()
					end
				end
end
return true
end
AddAction(TALUOPAIYUEDU)

-- AddComponentAction("INVENTORY", "inventoryitem", function(inst, doer, actions, right)
	-- if doer then
		-- if inst and inst:HasTag("taluopai") then
			-- table.insert(actions, ACTIONS.TALUOPAIYUEDU)
		-- end
	-- end
-- end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TALUOPAIYUEDU, "doshortaction"))      ----快速的
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TALUOPAIYUEDU, "doshortaction"))