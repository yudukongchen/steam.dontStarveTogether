--Skins system by Hornet
local _G = GLOBAL
local PREFAB_SKINS = _G.PREFAB_SKINS
local PREFAB_SKINS_IDS = _G.PREFAB_SKINS_IDS
local SKIN_AFFINITY_INFO = GLOBAL.require("skin_affinity_info")
local STRINGS = GLOBAL.STRINGS

modimport("ManutsaweeSkins_api")

SKIN_AFFINITY_INFO.manutsawee = {
	"manutsawee_yukata",
	"manutsawee_yukatalong", 
	"manutsawee_fuka", 
	"manutsawee_maid", 
	"manutsawee_shinsengumi",
	"manutsawee_jinbei",
	"manutsawee_miko",
	"manutsawee_qipao",
	"manutsawee_sailor",
}

PREFAB_SKINS["manutsawee"] = {
	"manutsawee_none", 	
	"manutsawee_yukata",
	"manutsawee_yukatalong",
	"manutsawee_fuka",
	"manutsawee_maid",
	"manutsawee_shinsengumi",
	"manutsawee_jinbei",
	"manutsawee_miko",
	"manutsawee_qipao",
	"manutsawee_sailor",
} 


PREFAB_SKINS_IDS = {} 
for prefab,skins in pairs(PREFAB_SKINS) do
    PREFAB_SKINS_IDS[prefab] = {}
    for k,v in pairs(skins) do
      	  PREFAB_SKINS_IDS[prefab][v] = k
    end
end

AddSkinnableCharacter("manutsawee") 

--Skin STRINGS
STRINGS.SKIN_NAMES.manutsawee_none = "默认服装"
STRINGS.SKIN_QUOTES.manutsawee_none = "我讨厌这身制服。"
STRINGS.SKIN_DESCRIPTIONS.manutsawee_none = "泰国的校服"
--SAILOR
STRINGS.SKIN_NAMES.manutsawee_sailor = "水手制服"
STRINGS.SKIN_QUOTES.manutsawee_sailor = "\"嗯哼󰀍\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_sailor = "󰀍"
--JS
STRINGS.SKIN_NAMES.manutsawee_yukata = "日式短裙"
STRINGS.SKIN_QUOTES.manutsawee_yukata = "\"剪，剪，剪!\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_yukata = "󰀍"
--Jlong
STRINGS.SKIN_NAMES.manutsawee_yukatalong = "日式服装"
STRINGS.SKIN_QUOTES.manutsawee_yukatalong = "\"剪，剪，剪!\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_yukatalong = "󰀍"
--miko
STRINGS.SKIN_NAMES.manutsawee_miko = "巫女装"
STRINGS.SKIN_QUOTES.manutsawee_miko = "\"神社少女'\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_miko = "󰀍"
--qipao
STRINGS.SKIN_NAMES.manutsawee_qipao = "旗袍"
STRINGS.SKIN_QUOTES.manutsawee_qipao = "\"中国服装'\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_qipao = "󰀍"
--Sur
STRINGS.SKIN_NAMES.manutsawee_fuka = "动漫真人秀"
STRINGS.SKIN_QUOTES.manutsawee_fuka = "\"把它们都剪掉！\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_fuka = "󰀍"
--Maid
STRINGS.SKIN_NAMES.manutsawee_maid = "女仆装"
STRINGS.SKIN_QUOTES.manutsawee_maid = "\"你已经死了！\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_maid = "󰀍"
--Shinsen
STRINGS.SKIN_NAMES.manutsawee_shinsengumi = "武士服"
STRINGS.SKIN_QUOTES.manutsawee_shinsengumi = "\"任何人都不能违反武士守则！\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_shinsengumi = "新成员国的法律\n任何人不得违反武士法典\n任何人不得擅离职守\n任何人不得任意筹集资金\n任何人不得任意处理诉讼\n任何人不得参与个人冲突\n"
--jinbei
STRINGS.SKIN_NAMES.manutsawee_jinbei = "睡衣"
STRINGS.SKIN_QUOTES.manutsawee_jinbei = "\"放松，感觉良好。\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_jinbei = "󰀍"
