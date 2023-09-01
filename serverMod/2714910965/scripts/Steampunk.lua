local _G = GLOBAL
local STRINGS = GLOBAL.STRINGS

local nm,rec,gen, ch = _G.STRINGS.NAMES, _G.STRINGS.RECIPE_DESC, _G.STRINGS.CHARACTERS.GENERIC.DESCRIBE, _G.STRINGS.CHARACTERS

--- Strings for items
nm.GEAR_AXE = "齿轮斧"
rec.GEAR_AXE = "耐久300，砍树时降低30%损耗"

nm.GEAR_MACE = "齿轮权杖"
rec.GEAR_MACE = "可以当锤子用，130耐久"

nm.GEAR_HAT = "齿轮帽子"
rec.GEAR_HAT = "提供大量理智恢复，比高礼帽多30%耐久"

nm.GEAR_MASK = "齿轮面具"
rec.GEAR_MASK = "提供生命恢复，但是缓慢降低理智"

nm.GEAR_ARMOR = "齿轮火炉"
rec.GEAR_ARMOR = "根据燃料产生光源，燃烧产生热量，但降低移速20%"

nm.GEAR_HELMET = "齿轮头盔"
rec.GEAR_HELMET = "50%防火，85%减伤，少量理智恢复，降低10%移速"

nm.GEAR_WINGS = "齿轮羽翼"
rec.GEAR_WINGS = "+15%移速，12天耐久"

nm.SENTINEL = "机械蜘蛛"
rec.SENTINEL = "150生命，40伤害，可修复"

nm.WS_03 = "机械蜘蛛王"
rec.WS_03 = "500生命，120伤害，可修复，每天产生齿轮"

nm.GEAR_TORCH = "齿轮火把"
rec.GEAR_TORCH = "装备或扔在地上时提供光源，可自行开关"

nm.BULBO = "移动灯泡"

nm.GEAR_TAB = "齿轮科技栏"

STRINGS.TABS.GEAR_TAB = "齿轮科技栏"

gen.GEAR_AXE = "该砍了！"
gen.GEAR_MACE = "这应该非常有用！"
gen.GEAR_HAT = "我喜欢这顶帽子！"
gen.GEAR_MASK = "非常非常令人毛骨悚然。"
gen.GEAR_ARMOR = "它很重，但我会被加热的！"
gen.GEAR_HELMET = "上面有一个名字.. Kovac."
gen.GEAR_WINGS = "现在我只需要风。"
gen.SENTINEL = "150生命值，40伤害 \n在不下雨和不潮湿时，对所有机械造物提供每秒0.3的生命恢复 \n他为你战斗 \n不需要睡眠和吃东西 \n可以用一些东西治疗：打火机，电线，收音机，机器人，火箭，齿轮 "
gen.WS_03 = "500生命值，120伤害 \n在不下雨和不潮湿时，对所有机械造物提供每秒0.3的生命恢复 \n他为你战斗 \n能和你一起砍树 \n不需要睡眠和吃东西 \n每1.5天可以产生一个齿轮 \n可以用一些东西治疗：打火机，电线，收音机，机器人，火箭，齿轮 \n死亡后掉落3-4个齿轮，并且为拥有者生成5-6个机械蜘蛛 \n可以当作避雷针"
gen.BULBO = "我从没想过这些生物会躲在这里。"
gen.GEAR_TORCH = "我正确地使用了灯泡。"