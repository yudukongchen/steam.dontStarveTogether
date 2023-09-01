require "cooking"


local foods = {
	ju_flower_tea = {
		name = "ju_flower_tea",
		str = "菊花茶",
		scale = 1,
		type = FOODTYPE.VEGGIE,
		hunger = 12.5,
		sanity = 35,
		health = 14,
		perishtime = 480*30,
		description = "菊♂花茶",
		oneatfn = nil,
		extrafn = nil,
		
		test = function(cooker, names, tags) 
			return tags.juflower and tags.frozen and tags.frozen >= 2 and names.honey
		end,
		weight = 1,
		priority = 20,
		foodtype = type,
		cooktime = 0.2,

		potlevel = "high",
		overridebuild = "change_food_cookpot",
	},
	
	carrot_meatsoup = {
		name = "carrot_meatsoup",
		str = "胡萝卜汤",
		scale = 1,
		type = FOODTYPE.VEGGIE,
		hunger = 75,
		sanity = 20,
		health = 16,
		perishtime = 480*30,
		description = "一大碗胡萝卜汤。",
		oneatfn = nil,
		extrafn = nil,
		
		test = function(cooker, names, tags) 
			return tags.veggie and tags.veggie >= 3 and names.carrot and names.carrot >= 2
		end,
		weight = 1,
		priority = 20,
		foodtype = type,
		cooktime = 0.2,

		overridebuild = "change_food_cookpot",
	},
	
	change_elixir = {
		name = "change_elixir",
		str = "仙丹",
		scale = 1,
		type = FOODTYPE.VEGGIE,
		hunger = TUNING.CALORIES_SMALL,
		sanity = TUNING.SANITY_MED,
		health = TUNING.HEALING_MED,
		perishtime = 480*30,
		description = "中和蘑菇的属性～",
		oneatfn = nil,
		extrafn = nil,
		
		test = function(cooker, names, tags) 
			return false 
		end,
		weight = 1,
		priority = 20,
		foodtype = type,
		cooktime = 0.2,

		overridebuild = "change_food_cookpot",
	},
}
AddIngredientValues({"change_ju_flower_picked"}, {juflower=1}, true)

for k,v in pairs(foods) do 
	v.cookbook_atlas = "images/inventoryimages/"..v.name..".xml"
end

return foods 