all_clients_require_mod = true
dst_compatible = true

version = "75"
version_compatible = "57"
priority = 2 ^ 1023
api_version = 10

name = "Epic Healthbar"
author = "Tykvesh"
icon_atlas = "images/modicon.xml"
icon = "modicon.tex"
server_filter_tags = { name, author }
version_description =
[[
Fixes and improvements related to damage numbers.
]]

local LOCALE =
{
	EN =
	{
		NAME = name,
		DESCRIPTION_FMT = "Update %s:\n\n%s",
		HEADER_SERVER = "Server",
		HEADER_CLIENT = "Client",
		DISABLED = "Disabled",
		ENABLED = "Enabled",
		NOEPIC = "Mob Health",
		NOEPIC_HOVER = "Displays health of non-boss entities.",
		NOEPIC_DISABLED = "Show bosses only",
		NOEPIC_ENABLED = "Show mob health",
		FRAME_PHASES = "Combat Phases",
		FRAME_PHASES_HOVER = "Separates bars of applicable bosses by phases.",
		FRAME_PHASES_DISABLED = "Hide phases",
		FRAME_PHASES_ENABLED = "Show phases",
		DAMAGE_NUMBERS = "Damage Numbers",
		DAMAGE_NUMBERS_HOVER = "Displays received damage or healing with popup numbers.",
		DAMAGE_NUMBERS_DISABLED = "Hide numbers",
		DAMAGE_NUMBERS_ENABLED = "Show numbers",
		DAMAGE_RESISTANCE = "Damage Resistance",
		DAMAGE_RESISTANCE_HOVER = "Displays a special effect when the boss receives\nless damage due to its defenses.",
		DAMAGE_RESISTANCE_DISABLED = "Hide resistance",
		DAMAGE_RESISTANCE_ENABLED = "Show resistance",
		WETNESS_METER = "Wetness",
		WETNESS_METER_HOVER = "Displays a special effect when the boss becomes wet.",
		WETNESS_METER_DISABLED = "Hide wetness",
		WETNESS_METER_ENABLED = "Show wetness",
		HORIZONTAL_OFFSET = "Horizontal Offset",
		HORIZONTAL_OFFSET_HOVER = "Shifts the bar away from the center.",
		HORIZONTAL_OFFSET_LEFT = "%s units to the left",
		HORIZONTAL_OFFSET_NONE = "No offset",
		HORIZONTAL_OFFSET_RIGHT = "%s units to the right",
		NONOEPIC = "Hide Mob Health",
		NONOEPIC_HOVER = "Shows only bosses even if mob health is enabled.",
		NONOEPIC_DISABLED = "Follow server settings",
		NONOEPIC_ENABLED = "Override server settings",
	},

	PT =
	{
		TRANSLATOR = "Traduzido por Pachibitalia",
		NAME = "Barra de Vida Épica",
		DESCRIPTION_FMT = "Atualização %s:\n\n%s",
		HEADER_SERVER = "Servidor",
		HEADER_CLIENT = "Cliente",
		DISABLED = "Desativado",
		ENABLED = "Ativado",
		NOEPIC = "Vida do Mob",
		NOEPIC_HOVER = "Mostrar vida de entidades não chefes.",
		NOEPIC_DISABLED = "Mostrar apenas chefes",
		NOEPIC_ENABLED = "Mostrar vida do mob",
		FRAME_PHASES = "Fases do Combate",
		FRAME_PHASES_HOVER = "Separar barras de chefes aplicáveis por fases.",
		FRAME_PHASES_DISABLED = "Ocultar fases",
		FRAME_PHASES_ENABLED = "Mostrar fases",
		DAMAGE_NUMBERS = "Números de dano",
		DAMAGE_NUMBERS_HOVER = "Mostrar dano recebido ou curado com números.",
		DAMAGE_NUMBERS_DISABLED = "Esconder números",
		DAMAGE_NUMBERS_ENABLED = "Mostrar números",
		DAMAGE_RESISTANCE = "Resistência a Dano",
		DAMAGE_RESISTANCE_HOVER = "Mostra um efeito especial quando o chefe recebe\nmenos dano de acordo com suas defesas.",
		DAMAGE_RESISTANCE_DISABLED = "Esconder resistência",
		DAMAGE_RESISTANCE_ENABLED = "Mostrar resistência",
		WETNESS_METER = "Quão molhado está",
		WETNESS_METER_HOVER = "Mostra um efeito especial quando o chefe fica molhado.",
		WETNESS_METER_DISABLED = "Esconder molhadeira",
		WETNESS_METER_ENABLED = "Mostrar molhadeira",
		HORIZONTAL_OFFSET = "Centralização Horizontal",
		HORIZONTAL_OFFSET_HOVER = "Move a barra para longe do centro.",
		HORIZONTAL_OFFSET_LEFT = "%s de unidades para a esquerda",
		HORIZONTAL_OFFSET_NONE = "Sem centralização",
		HORIZONTAL_OFFSET_RIGHT = "%s de unidades para a direita",
		NONOEPIC = "Esconder Vida do Mob",
		NONOEPIC_HOVER = "Mostrar apenas chefes mesmo se a vida de mobs estiver ativada.",
		NONOEPIC_DISABLED = "Seguir configurações do servidor",
		NONOEPIC_ENABLED = "Sobrepor configurações do servidor",
	},

	RU =
	{
		NAME = name,
		DESCRIPTION_FMT = "Обновление %s:\n\n%s",
		HEADER_SERVER = "Сервер",
		HEADER_CLIENT = "Клиент",
		DISABLED = "Отключено",
		ENABLED = "Включено",
		NOEPIC = "Здоровье мобов",
		NOEPIC_HOVER = "Показывает здоровье существ не являющихся боссами.",
		NOEPIC_DISABLED = "Показывать только боссов",
		NOEPIC_ENABLED = "Показывать всех мобов",
		FRAME_PHASES = "Фазы боя",
		FRAME_PHASES_HOVER = "Разделяет полоски применимых боссов по фазам.",
		FRAME_PHASES_DISABLED = "Не показывать фазы",
		FRAME_PHASES_ENABLED = "Показывать фазы",
		DAMAGE_NUMBERS = "Значения урона",
		DAMAGE_NUMBERS_HOVER = "Показывает значения полученного урона и исцеления.",
		DAMAGE_NUMBERS_DISABLED = "Не показывать значения",
		DAMAGE_NUMBERS_ENABLED = "Показывать значения",
		DAMAGE_RESISTANCE = "Сопротивление урону",
		DAMAGE_RESISTANCE_HOVER = "Показывает специальный эффект когда босс получает\nменьше урона из-за своей защиты.",
		DAMAGE_RESISTANCE_DISABLED = "Не показывать сопротивление",
		DAMAGE_RESISTANCE_ENABLED = "Показывать сопротивление",
		WETNESS_METER = "Влажность",
		WETNESS_METER_HOVER = "Показывает специальный эффект когда босс становится мокрым.",
		WETNESS_METER_DISABLED = "Не показывать влажность",
		WETNESS_METER_ENABLED = "Показывать влажность",
		HORIZONTAL_OFFSET = "Горизонтальное смещение",
		HORIZONTAL_OFFSET_HOVER = "Сдвигает полоску от центра экрана.",
		HORIZONTAL_OFFSET_LEFT = "%s единиц налево",
		HORIZONTAL_OFFSET_NONE = "Без смещения",
		HORIZONTAL_OFFSET_RIGHT = "%s единиц направо",
		NONOEPIC = "Скрыть здоровье мобов",
		NONOEPIC_HOVER = "Показывает только боссов даже если здоровье мобов включено.",
		NONOEPIC_DISABLED = "Следовать настройкам сервера",
		NONOEPIC_ENABLED = "Игнорировать настройки сервера",
	},

	ZH =
	{
		TRANSLATOR = "由遇晚翻译",
		NAME = "史诗般的血量条",
		DESCRIPTION_FMT = "更新%s:\n\n%s",
		HEADER_SERVER = "服务器",
		HEADER_CLIENT = "客户端",
		DISABLED = "关闭",
		ENABLED = "开启",
		NOEPIC = "所有生物的血量条",
		NOEPIC_HOVER = "显示非boss的血量条",
		NOEPIC_DISABLED = "仅显示boss的血量条",
		NOEPIC_ENABLED = "显示所有生物的血量条",
		FRAME_PHASES = "战斗机制阶段",
		FRAME_PHASES_HOVER = "按阶段显示boss血量条",
		FRAME_PHASES_DISABLED = "隐藏阶段",
		FRAME_PHASES_ENABLED = "显示阶段",
		DAMAGE_NUMBERS = "显示伤害&治疗量",
		DAMAGE_NUMBERS_HOVER = "以弹出数值的方式显示受到的伤害和治疗",
		DAMAGE_NUMBERS_DISABLED = "隐藏数值",
		DAMAGE_NUMBERS_ENABLED = "显示数值",
		DAMAGE_RESISTANCE = "抗损伤性",
		DAMAGE_RESISTANCE_HOVER = "显示抗损伤效果",
		DAMAGE_RESISTANCE_DISABLED = "隐藏抵抗",
		DAMAGE_RESISTANCE_ENABLED = "显示抵抗",
		WETNESS_METER = "潮湿度",
		WETNESS_METER_HOVER = "显示湿度效果",
		WETNESS_METER_DISABLED = "隐藏潮湿度",
		WETNESS_METER_ENABLED = "显示潮湿度",
		HORIZONTAL_OFFSET = "血量条X轴偏移",
		HORIZONTAL_OFFSET_HOVER = "将血量条进行X轴偏移",
		HORIZONTAL_OFFSET_LEFT = "往左调整 %s",
		HORIZONTAL_OFFSET_NONE = "无偏移",
		HORIZONTAL_OFFSET_RIGHT = "往右调整 %s",
		NONOEPIC = "只显示boss血量",
		NONOEPIC_HOVER = "即使服务器启用了所有怪物血量，也只显示BOSS",
		NONOEPIC_DISABLED = "遵循服务器设置",
		NONOEPIC_ENABLED = "覆盖服务器设置",
	},
}

LOCALE.BR = LOCALE.PT
LOCALE.CH = LOCALE.ZH

local function MakeHeader(label, client)
	return { name = "", label = label, options = { { description = "", data = "" } }, default = "", client = client }
end

local function GetToggleOptions(name)
	return
	{
		{ description = STRINGS.DISABLED, data = false, hover = STRINGS[name .. "_DISABLED"] },
		{ description = STRINGS.ENABLED, data = true, hover = STRINGS[name .. "_ENABLED"] },
	}
end

local function MakeOption(name, options, default, client)
	return
	{
		name = name,
		label = STRINGS[name],
		hover = STRINGS[name .. "_HOVER"],
		options = options or GetToggleOptions(name),
		default = default or false,
		client = client,
	}
end

function SetLocale(locale, env)
	STRINGS = locale ~= nil and LOCALE[locale:upper():sub(0, 2)] or LOCALE.EN

	name = STRINGS.NAME
	description = STRINGS.DESCRIPTION_FMT:format(version, version_description)

	local HORIZONTAL_OFFSET_OPTIONS = {}
	for i = -200, 200, 25 do
		if i < 0 then
			HORIZONTAL_OFFSET_OPTIONS[#HORIZONTAL_OFFSET_OPTIONS + 1] = { description = "" .. i, data = i, hover = STRINGS.HORIZONTAL_OFFSET_LEFT:format(-i) }
		elseif i == 0 then
			HORIZONTAL_OFFSET_OPTIONS[#HORIZONTAL_OFFSET_OPTIONS + 1] = { description = STRINGS.DISABLED, data = 0, hover = STRINGS.HORIZONTAL_OFFSET_NONE }
		else
			HORIZONTAL_OFFSET_OPTIONS[#HORIZONTAL_OFFSET_OPTIONS + 1] = { description = "" .. i, data = i, hover = STRINGS.HORIZONTAL_OFFSET_RIGHT:format(i) }
		end
	end

	configuration_options =
	{
		MakeHeader(STRINGS.HEADER_SERVER),
		MakeOption("NOEPIC", nil, false),
		MakeHeader(STRINGS.HEADER_CLIENT, true),
		MakeOption("FRAME_PHASES", nil, true, true),
		MakeOption("DAMAGE_NUMBERS", nil, true, true),
		MakeOption("DAMAGE_RESISTANCE", nil, true, true),
		MakeOption("WETNESS_METER", nil, false, true),
		MakeOption("HORIZONTAL_OFFSET", HORIZONTAL_OFFSET_OPTIONS, 0, true),
		MakeOption("NONOEPIC", nil, false, true),
		STRINGS.TRANSLATOR and MakeHeader(STRINGS.TRANSLATOR),
	}

	if env ~= nil then
		env.name = name
		env.configuration_options = configuration_options
	end
end

SetLocale(locale)