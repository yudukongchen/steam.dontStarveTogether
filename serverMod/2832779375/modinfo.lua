name = "一些修改"
version = "1.2.2"
description = "version: " .. version .. "\n\n非常多选项可在模组菜单里开关，游戏愉快！"
author = "朋也"
forumthread = ""

api_version = 10

--[[
    感谢幻想家帮忙制作modicon
]]
icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

all_clients_require_mod = true
client_only_mod = false
dst_compatible = true
-- priority = -9999 --优先级，值越大越先加载 默认0
server_filter_tags = {"stuff"}

configuration_options = {
    {name = "Title", label = "爽 (COOL)", options = {{description = "", data = ""},}, default = "",},
    {
        name = "super_attack_speed",
        label = "1秒5刀",
        hover = "Super Attack Speed",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "ice_salt_box_no_spoiled",
        label = "冰/盐箱保鲜",
        hover = "Fridge & saltbox preservation",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "no_pick_eater",
        label = "不挑食",
        hover = "女武神/鱼妹/沃利啥都吃\nWigfrid/Wurt/Warly not fussy food",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "cookpot_enhance",
        label = "红锅是啥",
        hover = "普通锅可制作红锅料理\nCookpot can cook warly food",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "krampus_sack",
        label = "背包留下",
        hover = "坎普斯必掉背包/Krampus drop krampus sack 100%",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "koalefant_tooth",
        label = "象牙留下",
        hover = "考拉象掉象牙/Koalefant drop walrus tusk",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "lightninggoathorn",
        label = "羊角留下",
        hover = "伏特羊必掉羊角/Volt Goat drop horn 100%",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "onday_beefalo",
        label = "一刷驯牛",
        hover = "刷一下驯服度增加95%，剩下5%留给驯势\nBrush, and the taming degree increases by 95%, and the remaining 5% is left for the taming potential",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "niubility_wolfgang",
        label = "永远的大力士",
        hover = "大力士力量值不降\nWolfgang power does not decrease",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "niubility_hambat",
        label = "坚挺的火腿棒",
        hover = "火腿棒耐久不会随新鲜度下降\nHambat durability does not decrease with freshness",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "notafraid_cold",
        label = "不畏严寒酷暑",
        hover = "草树枝浆果冬天也会生长，夏天不会枯萎\nGrass/sapling/berrybush grow in winter and not wither in summer",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    -- {
    --     name = "drop_stack",
    --     label = "掉落堆叠",
    --     hover = "",
    --     options = {{
    --         description = "ON",
    --         data = true,
    --         hover = ""
    --     }, {
    --         description = "OFF",
    --         data = false,
    --         hover = ""
    --     }},
    --     default = false
    -- },
    {
        name = "_99stack",
        label = "可堆叠",
        hover = "部分物品可堆叠（如：犀牛角，海鱼，黑心等）\nSome items can stack(like: Guardian's Horn, Oceanfish, Shadow Atrium)",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "_99stack1",
        label = "99堆叠",
        hover = "可堆叠物品堆叠上限均为99\nMax stack size are 99",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "krampus_sack_fresh",
        label = "小偷包保鲜",
        hover = "Krampus sack preservation",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "explode_rockavocade",
        label = "整组炸石果",
        hover = "Gunpowder mining stone fruit with wholestack",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "cane_projectile",
        label = "手杖远程攻击",
        hover = "手杖远程攻击，伤害17，加速1.4，可当镐、斧、鱼竿、捕虫网\nCane ranged attack with damage 17, speed x1.4 can be used as pickaxe, axe, fishing rod, and net trap",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "hambat_aoe",
        label = "火腿棒AOE",
        hover = "Hambat aoe damage",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    -- {
    --     name = "origin_healthbar",
    --     label = "官方血条",
    --     hover = "",
    --     options = {{
    --         description = "ON",
    --         data = true,
    --         hover = ""
    --     }, {
    --         description = "OFF",
    --         data = false,
    --         hover = ""
    --     }},
    --     default = false
    -- },
    {
        name = "niubility_abigail",
        label = "强大的阿比盖尔",
        hover = "回血30/s 移速x2 \n+30hp/s speed x2",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "niubility_wanda",
        label = "旺达YYDS",
        hover = "旺达可从食物回复血量且全年龄段都保持最高伤害\nWanda can recover health from food and all ages keep the highest damage",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "wormwood_foodhealth",
        label = "植物人食物回血",
        hover = "Wormwood can recover health from food",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "wortox_nofooddebuff",
        label = "恶魔人食物无扣减",
        hover = "Wortox eat food no deduction",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "auto_fuel",
        label = "自动加燃料",
        hover = "警告表，魔光护符，骨甲，矿工帽，鼹鼠帽会自动从身上找燃料添加。鼹鼠帽可添加光果作为燃料\nAlarming Clock,Magiluminescence,Bone Armor,Miner Hat,Moggles can auto add fuel from inventory.",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "oceantreenut_landplant",
        label = "疙瘩树果陆地种植",
        hover = "Knobbly Tree Nut can deploy on land",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "stronggrip",
        label = "武器不脱手",
        hover = "武器不脱手\nStrong Grip",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "hermitcrab_refuse_nobody",
        label = "蟹奶奶来者不拒",
        hover = "蟹奶奶收任意重量的鱼\nHermitcrab takes any weight of fish",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "more_fossil_piece",
        label = "化石碎片必掉",
        hover = "每个石笋里都有化石碎片\nThere are fossil fragments in every stalagmite",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "reasonable_bundle",
        label = "合理的打包袋",
        hover = "解开打包袋返还打包纸和绳子\nUntie the packing bag and return the packing paper and rope",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "deepocean_deploy_dockkit",
        label = "深海可放码头",
        hover = "深海可放码头\nDeploy DockKit in Deep Ocean",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "merm_pigking_gold",
        label = "鱼妹的伪装",
        hover = "鱼妹戴上猪皮帽可跟猪王换金子\nWurt can trade with pigking by wearing footballhat",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "dumbbells_autopickup",
        label = "自动捡哑铃",
        hover = "自动捡起扔出去的哑铃\nWolfgang automatically picked up the thrown dumbbell",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },

    {name = "Title", label = "种地 (Farm)", options = {{description = "", data = ""},}, default = "",},
    {
        name = "farm_high_stress",
        label = "抗压",
        hover = "作物不管种在哪都是巨大、不会腐烂\nCrops are huge and will not rot",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "niubility_gardening",
        label = "牛逼园艺",
        hover = "园艺书可催熟最多999个作物\nGardening book can mature most 999 crops",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "hoe_9x9",
        label = "一锄9坑",
        hover = "一次锄9个坑\nHoe 9 pits at a time",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "staffcoldlight_grow_farmplants",
        label = "光合作用",
        hover = "冷星也能让作物在夜间生长\nPolar Light can let farmplants grow",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },

    {name = "Title", label = "效率 (Efficiency)", options = {{description = "", data = ""},}, default = "",},
    {
        name = "magic_marble",
        label = "魔法催熟大理石",
        hover = "造林学可以催熟大理石\nApplied Silviculture can mature marble",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "no_stump",
        label = "砍树没树根",
        hover = "Chop tree no stump and return one log",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "tree_stop",
        label = "树/大理石循环停止",
        hover = "Tree or Marble will not cycle",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "auto_drop_rock_avocado_fruit",
        label = "石果自动掉落",
        hover = "Rock fruit will drop automatically",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "reed_shoval",
        label = "芦苇可移植",
        hover = "Reeds can shovel",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "banana_shoval",
        label = "洞穴香蕉可移植",
        hover = "Cave Banana Tree can shovel",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "quick_work",
        label = "快速工作",
        hover = "Quick Work",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "one_axe",
        label = "一键砍树",
        hover = "Chop tree only one axe",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "one_mine",
        label = "一键挖矿",
        hover = "Mine only one pick",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "one_second_fishrod",
        label = "一秒上钩",
        hover = "One second fishing rod",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "more_containers",
        label = "更多容器",
        hover = "矿工帽，暖石，鼹鼠帽添加容器\nAdd container for minerhat, molehat, heatrock",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "worldtime_faster",
        label = "世界时间加速",
        hover = "世界时间加速\nWorld time acceleration",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },

    {name = "Title", label = "无耐久 (Unlimit Uses)", options = {{description = "", data = ""},}, default = "",},
    {
        name = "unlimituses_tentaclespike",
        label = "触手尖刺无耐久",
        hover = "触手尖刺无耐久\nTentacle spike unlimit uses",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "unlimituses_heatrock",
        label = "暖石无耐久",
        hover = "暖石无耐久\nHeatrock unlimit uses",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "unlimituses_molehat",
        label = "鼹鼠帽无耐久",
        hover = "鼹鼠帽无耐久\nMole hat unlimit uses",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },

    {name = "Title", label = "能力 (Ability)", options = {{description = "", data = ""},}, default = "",},
    {
        name = "became_winona",
        label = "女工",
        hover = "拥有女工的能力\nHas Winona's ability",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "became_wormwood",
        label = "植物人",
        hover = "拥有植物人的能力\nHas Wormwood's ability",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "became_wickerbottom",
        label = "图书管理员",
        hover = "拥有图书管理员的能力\nHas Wickerbottom's ability",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "became_wathgrithr",
        label = "女武神",
        hover = "拥有女武神的能力\nHas Wathgrithr's ability",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "became_wanda",
        label = "旺达",
        hover = "拥有旺达的能力\nHas Wanda's ability",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "became_warly",
        label = "厨师",
        hover = "拥有厨师的能力\nHas Warly's ability",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "became_walter",
        label = "小男孩",
        hover = "拥有小男孩的能力\nHas Walter's ability",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },

    {name = "Title", label = "海洋 (Ocean)", options = {{description = "", data = ""},}, default = "",},
    {
        name = "oceanfish_no_season",
        label = "海鱼串季",
        hover = "四季鱼可在任意季节刷新\nSeason fish can spawn in any season",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "oceanfish_into_inventory",
        label = "海钓直接进背包",
        hover = "Ocean Fishing directly into the inventory",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "fishrod_onwater",
        label = "鱼竿踏水",
        hover = "手持鱼竿可踏水\nHolding a oceanfish rod can walk on water",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },

    {name = "Title", label = "天体 (Celestial)", options = {{description = "", data = ""},}, default = "",},
    {
        name = "one_celestial_task",
        label = "一次任务即可",
        hover = "做一次天体任务，老头给3个静电\nDoing a celestial task gives 3 energetic static",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "nibility_alterguardianhat",
        label = "体面的启迪之冠",
        hover = "永远发光，默认关闭，吸收70%伤害，100%防雨\nAlways shining, close default, absorbs 70% damage, 100% insulation",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },

    {name = "Title", label = "制作 (Craft)", options = {{description = "", data = ""},}, default = "",},
    {
        name = "magic_craft_ancient",
        label = "魔法二本=远古塔",
        hover = "魔法二本=远古塔\nShadow Manipulator can craft ancient staff.",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "alchemy",
        label = "炼金术",
        hover = "魔法本处可使用金子制作各种矿石\nShadow Manipulator can use gold to make all kinds of ores",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "messagebottleempty",
        label = "制作瓶子",
        hover = "制作瓶子\nCraft message bottle",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },

    {name = "Title", label = "养殖 (Breed)", options = {{description = "", data = ""},}, default = "",},
    {
        name = "koalefant_breed",
        label = "大象繁殖",
        hover = "大象繁殖\nKoalefant can breed",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "spat_breed",
        label = "钢羊繁殖",
        hover = "钢羊繁殖\nEwecus can breed",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "bearger_breed",
        label = "熊大繁殖",
        hover = "熊大繁殖\nBearger can breed",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
    {
        name = "deerclops_breed",
        label = "巨鹿繁殖",
        hover = "巨鹿繁殖\nDeerclops can breed",
        options = {{
            description = "ON",
            data = true,
            hover = ""
        }, {
            description = "OFF",
            data = false,
            hover = ""
        }},
        default = false
    },
}
