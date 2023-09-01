--技能点相关Rpc
AddModRPCHandler("asakiri", "SkillChange", function(player, slot, val)
	--技能槽位，值
	player.components.asa_power:SetSkill(slot, val)
end)

--退点惩罚
AddModRPCHandler("asakiri", "SkillUndoPenalty", function(player, val)
	if player.components.sanity.mode == SANITY_MODE_INSANITY then
		player.components.sanity:DoDelta(-5 * val)
	else
		player.components.sanity:DoDelta(5 * val)
	end
end)

--技能点变化
AddModRPCHandler("asakiri", "SkpChange", function(player, val)
-- 	player.asa_skp:set(val)  修改技能点获取基数
	player.asa_skp:set(val + 4)
end)

--打开面板更新点数
AddModRPCHandler("asakiri", "SkillRefresh", function(player)
	local sks1 = player.components.asa_power.sks
	local usedpt = 0
	for i,v in ipairs(sks1) do --分情况计算消耗量
		if v == 1 then
			if i == 3 or i == 6 or i == 9 then
				usedpt = usedpt + 3
			elseif i == 2 or i == 5 or i == 8 then
				usedpt = usedpt + 2
			else
				usedpt = usedpt + 1
			end
		end
	end
	player.asa_skp:set(player.asa_maxpw:value() - usedpt) --更新技能点
end)