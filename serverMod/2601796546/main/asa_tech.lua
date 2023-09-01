-- 代码作者：ti_Tout

--------------------------------------------------------------------------
--[[ 修改默认的科技树生成方式 ]]
--------------------------------------------------------------------------

local TechTree = require("techtree")

table.insert(TechTree.AVAILABLE_TECH, "ASA_TECH")	--其实就是加个自己的科技树名称

--------------------------------------------------------------------------
--[[ 制作等级中加入自己的部分 ]]
--------------------------------------------------------------------------

TECH.NONE.ASA_TECH = 0
TECH.ASA_TECH_ONE = { ASA_TECH = 2 }
TECH.ASA_TECH_TWO = { ASA_TECH = 4 }

--------------------------------------------------------------------------
--[[ 解锁等级中加入自己的部分 ]]
--------------------------------------------------------------------------

for k,v in pairs(TUNING.PROTOTYPER_TREES) do
    v.ASA_TECH = 0
end

TUNING.PROTOTYPER_TREES.ASA_TECH_ONE = TechTree.Create({
    ASA_TECH = 2,
})

TUNING.PROTOTYPER_TREES.ASA_TECH_THREE = TechTree.Create({
    ASA_TECH = 4,
})

--------------------------------------------------------------------------
--[[ 修改全部制作配方，对缺失的值进行补充 ]]
--------------------------------------------------------------------------

for i, v in pairs(AllRecipes) do
	if v.level.ASA_TECH == nil then
		v.level.ASA_TECH = 0
	end
end