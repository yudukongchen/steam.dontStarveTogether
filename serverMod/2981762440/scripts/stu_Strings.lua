GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

if TUNING.STU_Language == 0 then

STRINGS.CHARACTER_TITLES.stu = "归溟幽灵鲨"
STRINGS.CHARACTER_NAMES.stu = "归溟幽灵鲨"
STRINGS.CHARACTER_DESCRIPTIONS.stu = "*自远方而来的深海猎人，有两种截然不同的战斗风格。\n*轻微挑食的雕塑家。\n*潮湿不会让她感到困扰。但是潮湿的衣服会"
STRINGS.CHARACTER_QUOTES.stu = "\"我认识你，你也认识我，我们应该省去无趣的“初次见面”。\""

STRINGS.SKIN_NAMES.stu_skin1_none = "生而为一"
STRINGS.SKIN_QUOTES['stu_skin1_none'] = "\"雕刻留下阴影，正如硬币正反，日夜双分。当彼此都意识到自我的两面性时，劳伦缇娜便拥有双月般最完整的灵魂。\"" 

STRINGS.CHARACTERS.STU = require "speech_stu"

STRINGS.NAMES.STU = "归溟幽灵鲨"
STRINGS.SKIN_NAMES.stu_none = "归溟幽灵鲨"  

STRINGS.NAMES.STU_CHAINSAW = "唱片"
STRINGS.RECIPE_DESC.STU_CHAINSAW = "唱片。"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_CHAINSAW = "多么“优雅”的武器。"

STRINGS.NAMES.STU_CHAINSAW_SKIN = "唱片"
STRINGS.RECIPE_DESC.STU_CHAINSAW_SKIN = "唱片。"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_CHAINSAW_SKIN = "再优雅的武器，也是为了杀戮而生。"

STRINGS.NAMES.STU_HAT = "帽子"
STRINGS.RECIPE_DESC.STU_HAT = "可以给予巨鹿眼球解锁100%防水，给予木甲/影甲/铥矿护甲可提升护甲效果。穿戴时可以在水上行走，但会每秒增加1点潮湿度，穿戴时潮湿不会让幽灵鲨工具脱手。"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_HAT = "听说一家理发店里也在卖这种款式的帽子。"

STRINGS.NAMES.STU_HAT_SKIN = "帽子皮肤"
STRINGS.RECIPE_DESC.STU_HAT_SKIN = "可以给予巨鹿眼球解锁100%防水，给予木甲/影甲/铥矿护甲可提升护甲效果。穿戴时可以在水上行走，但会每秒增加1点潮湿度，穿戴时潮湿不会让幽灵鲨工具脱手。"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_HAT_SKIN = "这个帽子在那里没在卖哦。"

STRINGS.NAMES.STU_AMULET2_1 = "一级唱片收藏箱"
STRINGS.RECIPE_DESC.STU_AMULET2_1 = "攻击+20%，生命上限+50，稍微提升替身伤害与替身的减速效果。"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET2_1 = "里面的唱片都是来自伊比利亚黄金时代的杰作。"

STRINGS.NAMES.STU_AMULET2_2 = "二级唱片收藏箱"
STRINGS.RECIPE_DESC.STU_AMULET2_2 = "攻击+30%，防御20%，生命上限+65，提升替身伤害与替身的减速效果。"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET2_2 = "里面的唱片都是来自伊比利亚黄金时代的杰作。"

STRINGS.NAMES.STU_AMULET2_3 = "三级唱片收藏箱"
STRINGS.RECIPE_DESC.STU_AMULET2_3 = "攻击+50%，防御50%，生命上限+90，大量提升替身伤害与替身的减速效果。"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET2_3 = "里面的唱片都是来自伊比利亚黄金时代的杰作。"

STRINGS.NAMES.STU_AMULET1_1 = "一级未竟之美"
STRINGS.RECIPE_DESC.STU_AMULET1_1 = "攻击+10%，防御15%，san值上限+100，稍微提升san值吸收伤害的比例与替身形态的移动速度。"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET1_1 = "我将在斗争中创造独属于我的美。"

STRINGS.NAMES.STU_AMULET1_2 = "二级未竟之美"
STRINGS.RECIPE_DESC.STU_AMULET1_2 = "攻击+20%，防御35%，san值上限+200，提升san值吸收伤害的比例与替身形态的移动速度。"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET1_2 = "我将在斗争中创造独属于我的美。"

STRINGS.NAMES.STU_AMULET1_3 = "三级未竟之美"
STRINGS.RECIPE_DESC.STU_AMULET1_3 = "攻击+35%，防御70%，san值上限+300，大量提升san值吸收伤害的比例与替身形态的移动速度。"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET1_3 = "我将在斗争中创造独属于我的美。"

else

STRINGS.CHARACTER_TITLES.stu = "Specter the Unchained"
STRINGS.CHARACTER_NAMES.stu = "Specter the Unchained"
STRINGS.CHARACTER_DESCRIPTIONS.stu = "*The deep-sea hunters who come from afar have two completely different combat styles.\n*A sculptor who is slightly picky about food.\n*Dampness won't bother her. But damp clothes can"
STRINGS.CHARACTER_QUOTES.stu = "\"I know you, and you also know me. We should avoid boring 'first time meetings'.\""

STRINGS.SKIN_NAMES.stu_skin1_none = "Born as one"
STRINGS.SKIN_QUOTES['stu_skin1_none'] = "\"Engraving leaves a shadow, just like a coin facing both sides, day and night are divided. When both parties are aware of their own duality, Laurentina possesses the most complete soul like a bimonth.\"" 

STRINGS.CHARACTERS.STU = require "speech_stu"

STRINGS.NAMES.STU = "Specter the Unchained"
STRINGS.SKIN_NAMES.stu_none = "Specter the Unchained"  

STRINGS.NAMES.STU_CHAINSAW = "record"
STRINGS.RECIPE_DESC.STU_CHAINSAW = "record"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_CHAINSAW = "What an elegant weapon."

STRINGS.NAMES.STU_CHAINSAW_SKIN = "record"
STRINGS.RECIPE_DESC.STU_CHAINSAW_SKIN = "record"  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_CHAINSAW_SKIN = "Even the most elegant weapon is born for killing."

STRINGS.NAMES.STU_HAT = "HAT"
STRINGS.RECIPE_DESC.STU_HAT = "Can provide 100% waterproof unlocking for giant deer eyeballs, and providing wooden armor/shadow armor/thulium mineral armor can improve the armor effect. When wearing, you can walk on water, but it will increase the humidity by 1 point per second, and the humidity will not let the Ghost Shark tool go."  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_HAT = "I heard that a barber shop also sells hats of this style."

STRINGS.NAMES.STU_HAT_SKIN = "HAT SKIN"
STRINGS.RECIPE_DESC.STU_HAT_SKIN = "Can provide 100% waterproof unlocking for giant deer eyeballs, and providing wooden armor/shadow armor/thulium mineral armor can improve the armor effect. When wearing, you can walk on water, but it will increase the humidity by 1 point per second, and the humidity will not let the Ghost Shark tool go."  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_HAT_SKIN = "This hat is not sold there."

STRINGS.NAMES.STU_AMULET2_1 = "Record Collection Box LV1"
STRINGS.RECIPE_DESC.STU_AMULET2_1 = "Attack+20%, Max HP+50, slightly increases the damage and deceleration effect of the substitute."  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET2_1 = "All the records in it are masterpieces from the golden age of Iberia."

STRINGS.NAMES.STU_AMULET2_2 = "Record Collection Box LV2"
STRINGS.RECIPE_DESC.STU_AMULET2_2 = "Attack+30%, Defense 20%, Max HP+65, Increases the damage and deceleration effect of the substitute."  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET2_2 = "All the records in it are masterpieces from the golden age of Iberia."

STRINGS.NAMES.STU_AMULET2_3 = "Record Collection Box LV3"
STRINGS.RECIPE_DESC.STU_AMULET2_3 = "Attack+50%, Defense 50%, Max HP+90, greatly increases the damage and deceleration effect of the substitute."  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET2_3 = "All the records in it are masterpieces from the golden age of Iberia."

STRINGS.NAMES.STU_AMULET1_1 = "Unfinished Beauty LV1"
STRINGS.RECIPE_DESC.STU_AMULET1_1 = "Attack+10%, Defense 15%, Max San+100, Slightly increase the proportion of damage absorbed by San and the movement speed of the substitute form."  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET1_1 = "I will create my own beauty in the In Struggle."

STRINGS.NAMES.STU_AMULET1_2 = "Unfinished Beauty LV2"
STRINGS.RECIPE_DESC.STU_AMULET1_2 = "Attack+20%, Defense 35%, Max San+200, Increase the proportion of damage absorbed by San and the movement speed of the substitute form."  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET1_2 = "I will create my own beauty in the In Struggle."

STRINGS.NAMES.STU_AMULET1_3 = "Unfinished Beauty LV3"
STRINGS.RECIPE_DESC.STU_AMULET1_3 = "Attack+35%, Defense 70%, Max San+300, Greatly increases the proportion of damage absorbed by San and the movement speed of the substitute form."  
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STU_AMULET1_3 = "I will create my own beauty in the In Struggle."
end