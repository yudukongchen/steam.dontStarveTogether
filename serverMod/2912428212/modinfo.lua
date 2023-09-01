name = "最厉害的风幻龙 By YJC"
description = [[
  介绍：居于塞尔菲亚镇掌握符文之力的圣龙.
  1、击杀怪物掉落符文结晶.
  2、白天稍微降低受到的伤害,适度提高攻击力,适度降低饥饿速度.
  3、黑夜中提高移速,适度降低受到的伤害,稍微提高饥饿速度,稍微降低攻击力.
  4、吃火龙果升级!(满级30,等级越高,升级几率越低)
  5、自带武器金芜菁之杖(附带冰柱/着火特效,触发几率自选).
  6、移动速度随等级提高加快!
  7、是图书管理员的朋友(可以使用书本).
]]
author = "老熊&小北 搬运修改By YJC"
version = "1.4.0"

--------更新网址
forumthread = ""

api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = { "character" }

configuration_options = { {
    name = "zzj_damage",
    label = "配剑攻击力:",
    options = { {
        description = "35(默认)",
        data = 35
    }, {
        description = "60",
        data = 60
    }, {
        description = "100",
        data = 100
    }, {
        description = "260",
        data = 260
    }, {
        description = "一招秒吧",
        data = 999999999
    } },
    default = 999999999
}, {
    name = "zzj_range",
    label = "配剑攻击距离:",
    options = { {
        description = "1.5",
        data = 1.5
    }, {
        description = "2",
        data = 2
    }, {
        description = "3",
        data = 3
    }, {
        description = "5",
        data = 5
    }, {
        description = "所见之处,只怪不生(默认)",
        data = 18
    } },
    default = 18
}, {
    name = "fhl_hjopen",
    label = "背包护甲功能",
    options = { {
        description = "开启(默认)",
        data = true
    }, {
        description = "关闭",
        data = false
    } },

    default = true
}, {
    name = "zzj_fireopen",
    label = "配剑火焰特效:",
    options = { {
        description = "开启",
        data = true
    }, {
        description = "关闭(默认)",
        data = false
    } },
    default = false
}, {
    name = "zzj_pre",
    label = "配剑特效伤害百分比:",
    options = { {
        description = "50%(默认)",
        data = .5
    }, {
        description = "100%(默认)",
        data = 1
    }, {
        description = "150%",
        data = 1.5
    } },
    default = 1
}, {
    name = "zzj_times",
    label = "配剑特效触发几率:",
    options = { {
        description = "5%",
        data = .05
    }, {
        description = "10%",
        data = .1
    }, {
        description = "20%",
        data = .2
    }, {
        description = "30%",
        data = .3
    }, {
        description = "50%",
        data = .5
    }, {
        description = "范围攻击模式(默认)",
        data = 1
    } },
    default = 1
}, {
    name = "openlight",
    label = "幻儿自己会发光吗:",
    options = { {
        description = "会(默认)",
        data = true
    }, {
        description = "不会",
        data = false
    } },
    default = true
}, {
    name = "zzj_cankanshu",
    label = "配剑可以当做斧子:",
    options = { {
        description = "是(默认)",
        data = true
    }, {
        description = "否",
        data = false
    } },
    default = true
}, {
    name = "zzj_canwakuang",
    label = "配剑可以当做搞头:",
    options = { {
        description = "是(默认)",
        data = true
    }, {
        description = "否",
        data = false
    } },
    default = true
}, {
    name = "zzj_canuseashammer",
    label = "配剑可以当做锤子:",
    options = { {
        description = "是",
        data = true
    }, {
        description = "否(默认)",
        data = false
    } },
    default = false
}, {
    name = "zzj_canuseasshovel",
    label = "配剑可当做铲子:",
    options = { {
        description = "是",
        data = true
    }, {
        description = "否(默认)",
        data = false
    } },
    default = false
}, {
    name = "zzj_finiteuses",
    label = "配剑耐久度:",
    options = { {
        description = "120(默认)",
        data = 120
    }, {
        description = "210",
        data = 210
    }, {
        description = "300",
        data = 300
    }, {
        description = "无限",
        data = 0
    } },
    default = 0
}, {
    name = "DROPGLASSES",
    label = "断线时掉落护身符",
    options = { {
        description = "是",
        data = 1
    }, {
        description = "否(默认)",
        data = 0
    } },

    default = 0
}, {
    name = "openli",
    label = "狗箱发光",
    options = { {
        description = "是",
        data = true
    }, {
        description = "否(默认)",
        data = false
    } },

    default = false
}, {
    name = "buffgo",
    label = "护身符吸收一半伤害",
    options = { {
        description = "开启",
        data = true
    }, {
        description = "关闭(默认)",
        data = false
    } },

    default = false
} }
