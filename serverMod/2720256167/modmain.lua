PrefabFiles = 
{
	"firesuppressor",
	
}


GLOBAL.TUNING.FIRESUPPRESSOR_MAX_FUEL_TIME = 480 * GetModConfigData("mhqsj")
GLOBAL.TUNING.FIRE_DETECTOR_RANGE = 15 * math.floor(GetModConfigData("mhqfw")+0.4)
GLOBAL.TUNING.BUM = GetModConfigData("bum")
TUNING.FG = GetModConfigData("fg")
TUNING.MHQKDFW = GetModConfigData("mhqfw")
TUNING.MHQRLKG = GetModConfigData("rlkg")
TUNING.MHQBMYH = GetModConfigData("bmyh")
TUNING.FWXS = GetModConfigData("fwxs")
TUNING.JZMHQ = GetModConfigData("jzmhq")

STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

local function MakeCircle(inst,n)
	local circle = GLOBAL.CreateEntity()
	circle.entity:AddTransform()
	circle.entity:AddAnimState()

	circle.entity:SetParent(inst.entity)
	circle.Transform:SetRotation(n)
	circle.Transform:SetScale(TUNING.MHQKDFW,TUNING.MHQKDFW,TUNING.MHQKDFW)
	circle.AnimState:SetAddColour(30/255, 30/255, 30/255, 0)

	circle.AnimState:SetBank("firefighter_placement")
	circle.AnimState:SetBuild("firefighter_placement")
	circle.AnimState:PlayAnimation("idle")
	circle.AnimState:SetLightOverride(1)

	circle.AnimState:SetOrientation(GLOBAL.ANIM_ORIENTATION.OnGround)
	circle.AnimState:SetLayer(GLOBAL.LAYER_BACKGROUND)
	circle.AnimState:SetSortOrder(3)
	
	return circle
end


if TUNING.FWXS == 2 then
AddPrefabPostInit("firesuppressor",function(inst)MakeCircle(inst,0) end)
else
end

if TUNING.JZMHQ == 2 then
AddRecipe("firesuppressor", {Ingredient("gears", 2),Ingredient("ice", 15),Ingredient("transistor", 2)}, RECIPETABS.SCIENCE, TECH.NONE, "firesuppressor_placer",0.5)	--如果是Recipe,会造成皮肤无法使用
else
end