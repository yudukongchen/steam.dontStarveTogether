GLOBAL.setmetatable(env, { __index = function(t, k)
    return GLOBAL.rawget(GLOBAL, k)
end })
local require = GLOBAL.require

modimport "kuangsan/language.lua"
modimport "kuangsan/kuangsanyuyan.lua"
modimport "kuangsan/shijianzantingapi.lua"
modimport "kuangsan/jiangui.lua"
modimport("kuangsan/kurumibilibili.lua")
GLOBAL.kuangsan = true
GLOBAL.mpatubiaozhuce = AddMinimapAtlas
GLOBAL.baizhinvwangzhenshi = GetModConfigData("白之女王真实伤害")
GLOBAL.xiaofushanghaijiangdi = GetModConfigData("校服降低伤害")
GLOBAL.jiesuoikejishizhidan = GetModConfigData("解锁科技")

PrefabFiles = {
    "kurumi",
    --"kurumi_none",
    "krm_items",
    "krm_bullet",
    "kurumi_pets",
    "krm_nightmarecreature",
    "krm_armor",
    "krm_wangguan",
    "krm_fuyoupao",
    "krm_meowbag",
	"camael",
    "krm_spirit_crystal",
    "krm_pocketwatch_weapon",
    "krm_lance",
    "krm_wingsshelter",
    "taluopaiyuzhiwu",
}

Assets = {

    Asset("ANIM", "anim/kurumi.zip"),
    Asset("ANIM", "anim/kurumi1.zip"),
    Asset("ANIM", "anim/kurumi2.zip"),
    Asset("ANIM", "anim/kurumi3.zip"),
    Asset("ANIM", "anim/ghost_kurumi_build.zip"),

    Asset("ATLAS", "images/saveslot_portraits/kurumi.xml"),
    Asset("ATLAS", "images/selectscreen_portraits/kurumi.xml"),
    Asset("ATLAS", "images/selectscreen_portraits/kurumi_silho.xml"),
    Asset("ATLAS", "bigportraits/kurumi.xml"),
    Asset("ATLAS", "bigportraits/kurumi_none.xml"),
    Asset("ATLAS", "bigportraits/krm_gothic_nun.xml"),
    Asset("ATLAS", "images/avatars/avatar_kurumi.xml"),
    Asset("ATLAS", "images/avatars/avatar_ghost_kurumi.xml"),
    Asset("ATLAS", "images/avatars/self_inspect_kurumi.xml"),
    Asset("ATLAS", "images/names_kurumi.xml"),
    Asset("ATLAS", "images/map_icons/kurumi.xml"),
    Asset("ANIM", "anim/krm_shoot.zip"),
    Asset("ANIM", "anim/krm_gothic_nun.zip"),
    Asset("ANIM", "anim/daofeng_actions_pistol.zip"),
	--ThePlayer.AnimState:SetBuild("krm_gothic_nun")
    Asset("SOUNDPACKAGE", "sound/lw_homura.fev"),  
    Asset("SOUND", "sound/lw_homura.fsb"),    
	
    Asset("SOUNDPACKAGE", "sound/guipai.fev"),  
    Asset("SOUND", "sound/guipai.fsb"), 

    Asset("SOUNDPACKAGE", "sound/shijianzanting.fev"),  
    Asset("SOUND", "sound/shijianzanting.fsb"),    	

    Asset("SOUNDPACKAGE", "sound/kuangsankaiqiang.fev"),  
    Asset("SOUND", "sound/kuangsankaiqiang.fsb"),   	

}

AddModCharacter("kurumi", "FEMALE")
AddMinimapAtlas("images/map_icons/kurumi.xml")

TUNING.KURUMI_SHADOW_CHANCE = GetModConfigData("shaodw_chance")

PREFAB_SKINS["kurumi"] = {
    "kurumi_none"
}

RegisterInventoryItemAtlas("images/inventoryimages/krm_items.xml", "krm_cane.tex")  

RegisterInventoryItemAtlas("images/inventoryimages/krm_items.xml", "krm_armor.tex") 
RegisterInventoryItemAtlas("images/inventoryimages/krm_items.xml", "krm_zafkiel.tex")  
RegisterInventoryItemAtlas("images/inventoryimages/krm_items.xml", "krm_gun.tex") 
RegisterInventoryItemAtlas("images/inventoryimages/krm_items.xml", "krm_knife.tex") 
RegisterInventoryItemAtlas("images/inventoryimages/krm_items.xml", "krm_key.tex") 
RegisterInventoryItemAtlas("images/inventoryimages/krm_items.xml", "krm_uniform.tex") 
RegisterInventoryItemAtlas("images/inventoryimages/krm_meowbag.xml", "krm_meowbag.tex") 

AddRecipe2(
    "krm_crystal",
    { Ingredient("krm_dregs", 133, "images/inventoryimages/krm_items.xml") },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_crystal.tex", builder_tag = "kurumi" },
    { "CHARACTER" }
)

AddRecipe2(
    "krm_diericijihuibiao",
    {Ingredient("krm_crystal", 1, "images/inventoryimages/krm_items.xml"),Ingredient("livinglog", 5),Ingredient("nightmarefuel", 10)},
    TECH.NONE,
    { product = "pocketwatch_revive", builder_tag = "kurumi", no_deconstruction = true },
    { "CHARACTER" }
)


AddRecipe2(
    "krm_zafkiel",
    { Ingredient("goldnugget", 15), Ingredient("moonglass", 12), Ingredient("petals", 1), Ingredient("opalpreciousgem", 1) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_zafkiel.tex", builder_tag = "kurumi" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_meowbag",
    { Ingredient("silk", 10), Ingredient("coontail", 10),  Ingredient("petals", 20), Ingredient("manrabbit_tail", 5) },
    TECH.SCIENCE_TWO,
    { atlas = "images/inventoryimages/krm_meowbag.xml", image = "krm_meowbag.tex", builder_tag = "kurumi" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_cane",
    { Ingredient("goldnugget", 10), Ingredient("transistor", 5), Ingredient("tentaclespike", 1), Ingredient("krm_crystal", 1, "images/inventoryimages/krm_items.xml") },
    TECH.SCIENCE_TWO,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_cane.tex", builder_tag = "kurumi" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_knife",
    { Ingredient("nightsword", 5), Ingredient("blowdart_pipe", 10), Ingredient("gunpowder", 10), Ingredient("krm_crystal", 5, "images/inventoryimages/krm_items.xml") },
    TECH.SCIENCE_TWO,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_knife.tex", builder_tag = "kur_knife_builder" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_uniform",
    { Ingredient("silk", 10), Ingredient("pigskin", 2), Ingredient("tentaclespots", 2), Ingredient("krm_crystal", 1, "images/inventoryimages/krm_items.xml") },
    TECH.MAGIC_THREE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_uniform.tex", builder_tag = "kurumi" },
    { "MAGIC" }
)
AddRecipe2(
    "krm_flute",
    { Ingredient("livinglog", 10), Ingredient("mandrake", 1), Ingredient("nightmarefuel", 10), Ingredient("thulecite", 5) },
    TECH.LOST,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_flute.tex" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_icebox",
    { Ingredient("livinglog", 10), Ingredient("nightmarefuel", 10) },
    TECH.LOST,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_icebox.tex", placer = "krm_icebox_placer", min_spacing = 1.5 },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_city",
    { Ingredient("livinglog", 2), Ingredient("greengem", 1), Ingredient("lureplantbulb", 1), Ingredient("krm_dregs", 6, "images/inventoryimages/krm_items.xml"), Ingredient("nightmarefuel", 6) },
    TECH.SCIENCE_TWO,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_city.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_pocketwatch_weapon2",
    { Ingredient("krm_dregs", 50, "images/inventoryimages/krm_items.xml"), Ingredient("marble", 4), Ingredient("nightmarefuel", 8) },
    TECH.MAGIC_TWO,
    { atlas = nil, image = nil, builder_tag = "kurumi", product = "pocketwatch_weapon" },
    { "MAGIC" }
)

AddRecipe2(
    "krm_pocketwatch_recall",
    { Ingredient("krm_crystal", 1,"images/inventoryimages/krm_items.xml"), Ingredient("goldnugget", 2), Ingredient("walrus_tusk", 1) },
    TECH.MAGIC_TWO,
    { atlas = nil, image = nil, builder_tag = "kurumi", product = "pocketwatch_recall" },
    { "MAGIC" }
)
AddRecipe2(
    "krm_gun",
    { Ingredient("nightmarefuel", 6), Ingredient("krm_crystal", 1, "images/inventoryimages/krm_items.xml"), Ingredient("goldnugget", 6), Ingredient("livinglog", 4) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_gun.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_magazine",
    { Ingredient("pigskin", 2), Ingredient("slurtle_shellpieces", 2), Ingredient("purplegem", 1), Ingredient("krm_crystal", 1, "images/inventoryimages/krm_items.xml") },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_magazine.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)

AddRecipe2(
    "krm_bullet1",
    { Ingredient("nightmarefuel", 2), Ingredient("krm_dregs", 2, "images/inventoryimages/krm_items.xml"), Ingredient("butterflywings", 5) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet1.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_bullet2",
    { Ingredient("nightmarefuel", 4), Ingredient("krm_dregs", 4, "images/inventoryimages/krm_items.xml"), Ingredient("ice", 6) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet2.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_bullet3",
    { Ingredient("nightmarefuel", 2), Ingredient("krm_dregs", 2, "images/inventoryimages/krm_items.xml"), Ingredient("boneshard", 1) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet3.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)

AddRecipe2(
    "krm_bullet4",
    { Ingredient("nightmarefuel", 2), Ingredient("krm_dregs", 4, "images/inventoryimages/krm_items.xml"), Ingredient("spidergland", 1)},
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet4.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_bullet5",
    { Ingredient("nightmarefuel", 2), Ingredient("krm_dregs", 6, "images/inventoryimages/krm_items.xml"), Ingredient("thulecite_pieces", 2) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet5.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_bullet6",
    { Ingredient("nightmarefuel", 2), Ingredient("krm_dregs", 2, "images/inventoryimages/krm_items.xml"), Ingredient("moonglass", 1) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet6.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_bullet7",
    { Ingredient("nightmarefuel", 4), Ingredient("krm_dregs", 4, "images/inventoryimages/krm_items.xml"), Ingredient("bluegem", 1) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet7.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_bullet8",
    { Ingredient("nightmarefuel", 2), Ingredient("krm_dregs", 2, "images/inventoryimages/krm_items.xml"), Ingredient("beardhair", 1) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet8.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_bullet9",
    { Ingredient("nightmarefuel", 10), Ingredient("purplegem", 2),Ingredient("krm_dregs", 10, "images/inventoryimages/krm_items.xml") },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet9.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_bullet10",
    { Ingredient("nightmarefuel", 6), Ingredient("krm_dregs", 6, "images/inventoryimages/krm_items.xml"), Ingredient("orangegem", 1) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet10.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_bullet11",
    { Ingredient("nightmarefuel", 6), Ingredient("krm_dregs", 6, "images/inventoryimages/krm_items.xml"), Ingredient("opalpreciousgem", 1) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet11.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)
AddRecipe2(
    "krm_bullet12",
    { Ingredient("nightmarefuel", 6), Ingredient("krm_dregs", 6, "images/inventoryimages/krm_items.xml"), Ingredient("opalpreciousgem", 1) },
    TECH.NONE,
    { atlas = "images/inventoryimages/krm_items.xml", image = "krm_bullet12.tex", builder_tag = "krm_recipe" },
    { "CHARACTER" }
)

AddRecipe2(
    "krm_pocketwatch_weapon",
    {Ingredient("krm_crystal", 1, "images/inventoryimages/krm_items.xml"),
     Ingredient("transistor", 10), 
     Ingredient("pocketwatch_weapon", 1),
     Ingredient("bluegem", 1),
     Ingredient("redgem", 1),
    },
    TECH.LOST,
    {},
    { "CHARACTER" }
)

-- AddRecipe2(
    -- "krm_pocketwatch_recall",
    -- { Ingredient("nightmarefuel", 6), Ingredient("krm_dregs", 6, "images/inventoryimages/krm_items.xml"), Ingredient("opalpreciousgem", 1) },
    -- TECH.NONE,
    -- { atlas = nil, image = nil, builder_tag = "krm_recipe", product = "pocketwatch_recall" },
    -- { "CHARACTER" }
-- )
GLOBAL.KrmBooks = {}
GLOBAL.KrmBookLi = {
    "book_tentacles", "book_birds", "book_brimstone", "book_sleep", "book_gardening", "book_horticulture",
    "book_horticulture_upgraded", "book_silviculture", "book_fish", "book_fire", "book_web", "book_temperature",
    "book_light", "book_light_upgraded", "book_rain", "book_moon", "book_bees", "book_research_station"
}
AddPrefabPostInit("deerclops", function(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:AddChanceLoot("krm_icebox_blueprint", 1)
    end
end)
AddPrefabPostInit("eyeofterror", function(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:AddChanceLoot("krm_pocketwatch_weapon_blueprint", 1)
    end
end)
AddPrefabPostInit("twinofterror2", function(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:AddChanceLoot("krm_wingsshelter", 0.5)
    end
end)
AddPrefabPostInit("twinofterror1", function(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:AddChanceLoot("krm_wingsshelter", 0.5)
    end
end)

local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end


AddPrefabPostInit("daywalker", function(inst)
 
-- if inst.components.lootdropper then inst.components.lootdropper:AddChanceLoot("krm_wingsshelter", 1) end
        -- inst:ListenForEvent("minhealth", function( ... )
            -- if inst.defeated and not inst.sg:HasStateTag("defeated") then
				-- if inst.components.lootdropper then 
                -- inst.components.lootdropper:SpawnLootPrefab("krm_wangguan")
				-- end
			-- end
        -- end)
if inst.components.lootdropper then
local jiudediaoluowu = inst.components.lootdropper.lootsetupfn
inst.components.lootdropper.lootsetupfn = function(self,...)
jiudediaoluowu(self,...)
self.inst.components.lootdropper:AddChanceLoot("krm_wangguan", 1)
end
end

end)
AddPrefabPostInit("bearger", function(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:AddChanceLoot("krm_flute_blueprint", 1)
    end
end)
AddPrefabPostInit("crabking", function(inst)
    inst:ListenForEvent("death", function(inst)
        if inst.components.lootdropper then
            if not (TheWorld:HasTag("cave") or TheWorld.unlockli.krm_broom) then
                TheWorld.unlockli.krm_broom = true
                inst.components.lootdropper:SpawnLootPrefab("krm_broom")
            end
        end
    end)
end)
AddPrefabPostInit("klaus", function(inst)
    inst:ListenForEvent("death", function(inst)
        if inst:IsUnchained() and inst.persists and inst.components.lootdropper then
            if not (TheWorld:HasTag("cave") or TheWorld.unlockli.krm_book) then
                TheWorld.unlockli.krm_book = true
                inst.components.lootdropper:SpawnLootPrefab("krm_book")
            end
        end
    end)
end)
AddPrefabPostInit("beequeen", function(inst)
    inst:ListenForEvent("death", function(inst)
        if inst.components.lootdropper then
            if not (TheWorld:HasTag("cave") or TheWorld.unlockli.krm_key) then
                TheWorld.unlockli.krm_key = true
                inst.components.lootdropper:SpawnLootPrefab("krm_key")
            end
        end
    end)
end)

AddPrefabPostInit("dragonfly", function(inst)
    inst:ListenForEvent("death", function(inst)
		if inst.components.lootdropper  and  math.random(1, 100) <= 40 then
			inst.components.lootdropper:AddChanceLoot("camael", 1)
		end
	end)
end)

AddPrefabPostInit("houndstooth", function(inst)
    inst:AddComponent("tradable")
end)
AddPrefabPostInit("gears", function(inst)
    inst:AddComponent("tradable")
end)
AddPrefabPostInit("cane", function(inst)
    inst:AddComponent("tradable")
end)
AddPrefabPostInit("nightmarefuel", function(inst)
    inst:AddTag("krm_bullets")
end)

AddPrefabPostInit("world", function(inst)  --print(ThePlayer.AnimState:GetCurrentFacing())
    if TheWorld.ismastersim then
        inst:DoTaskInTime(0.1, function()
            for i, v in ipairs(KrmBookLi) do
                local item = SpawnPrefab(v)
                if item then
                    KrmBooks[v] = {}
                    KrmBooks[v].fx = item.components.book.fx
                    KrmBooks[v].onread = item.components.book.onread
                    KrmBooks[v].fxmount = item.components.book.fxmount
                    KrmBooks[v].onperuse = item.components.book.onperuse
                    KrmBooks[v].readsanity = item.components.book.read_sanity
                    KrmBooks[v].perusesanity = item.components.book.peruse_sanity
                    item:Remove()
                end
            end
        end)

        inst.unlockli = {}
        inst.OldOnSave = inst.OnSave
        inst.OnSave = function(inst, data)
            if inst.OldOnSave then
                inst:OldOnSave(data)
            end
            if data and inst.unlockli then
                data.unlockli = inst.unlockli
            end
        end
        inst.OldOnLoad = inst.OnLoad
        inst.OnLoad = function(inst, data)
            if inst.OldOnLoad then
                inst:OldOnLoad(data)
            end
            if data and data.unlockli then
                inst.unlockli = data.unlockli
            end
        end
    end
end)

AddClassPostConstruct("widgets/wandaagebadge", function(self)
    local oldSetPercent = self.SetPercent
    function self:SetPercent(val, max, penaltypercent)
        oldSetPercent(self, val, max, penaltypercent)
        if self.owner and self.owner:HasTag("kurumi") then
            self.num:SetString(self.owner.player_classified.currenthealth:value())
        end
    end
end)

local containers = require "containers"
local params = containers.params
params.krm_magazine = {
    widget = {
        slotpos = {},
        animbank = "ui_chester_shadow_3x4",
        animbuild = "ui_chester_shadow_3x4",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160
    },
    type = "chest"
}
for y = 1, 4 do
    for x = 1, 3 do
        table.insert(params.krm_magazine.widget.slotpos, Vector3(74*x-150, -74*y+188, 0))
    end
end
containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.krm_magazine.widget.slotpos and #params.krm_magazine.widget.slotpos or 0)
function params.krm_magazine.itemtestfn(container, item, slot)
    return item:HasTag("krm_bullets") or false
end
params.krm_icebox = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "krm_icebox_ui_3x6",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160
    },
    type = "chest"
}
for y = 1, 6 do
    for x = 1, 6 do
        table.insert(params.krm_icebox.widget.slotpos, Vector3(74*x-260, -74*y+260, 0))
    end
end
params.krm_meowbag = params.krampus_sack
containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.krm_icebox.widget.slotpos and #params.krm_icebox.widget.slotpos or 0)
-- params.krm_gun = {
    -- widget = {
        -- slotpos = { Vector3(-2, 18, 0) },
        -- slotbg = {
            -- { image = "spore_slot.tex", atlas = "images/hud2.xml" }
        -- },
        -- animbank = "ui_alterguardianhat_1x1",
        -- animbuild = "ui_alterguardianhat_1x1",
        -- pos = Vector3(300, -300, 0),
    -- },
    -- type = "chest"
-- }
-- containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.krm_gun.widget.slotpos and #params.krm_gun.widget.slotpos or 0)
-- function params.krm_gun.itemtestfn(container, item, slot)
    -- return item:HasTag("krm_bullets") or false
-- end

local BulletFn = {
    ["krm_bullet1"] = function(inst)
        print("这是一只弹")
    end,
    ["krm_bullet2"] = function(inst, target)
        if target and target.components.locomotor then
            if target.speeddown == nil then
                target.components.locomotor:SetExternalSpeedMultiplier(target, "krm_speeddown", 0.1)
                target.speeddown = inst:DoTaskInTime(10, function()
                    target.speeddown = nil
                    target.components.locomotor:RemoveExternalSpeedMultiplier(target, "krm_speeddown")
                end)
            end
        end
    end,
    ["krm_bullet3"] = function(inst)
        print("这是一只弹")
    end,
    ["krm_bullet4"] = function(inst)
        print("这是一只弹")
    end,
    ["krm_bullet5"] = function(inst)
        print("这是一只弹")
    end,
    ["krm_bullet6"] = function(inst)
        print("这是一只弹")
    end,
    ["krm_bullet7"] = function(inst)
        print("这是一只弹")
    end,
    ["krm_bullet8"] = function(inst)
        print("这是一只弹")
    end,
    ["krm_bullet9"] = function(inst)
        print("这是一只弹")
    end,
    ["krm_bullet10"] = function(inst)
        print("这是一只弹")
    end,
    ["krm_bullet11"] = function(inst)
        print("这是一只弹")
    end,
    ["krm_bullet12"] = function(inst)
        print("这是一只弹")
    end
}
AddStategraphPostInit("wilson", function(sg)
    sg.states["krm_gun_atk"] = State {
        name = "krm_gun_atk",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" },
        onenter = function(inst)
            --print("射击1")
            inst.AnimState:PlayAnimation("hand_shoot")
            inst.AnimState:SetDeltaTimeMultiplier(2)

            local weapon = inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
            if weapon and weapon:HasTag("krm_gun") then
               -- print("左键普通射击，清空弹药记录")
                weapon.bullet = nil
            end    

            local buffaction = inst:GetBufferedAction()
            if buffaction then   
                local target = buffaction.target or nil
                inst.components.combat:SetTarget(target)
                inst.components.combat:StartAttack()
                inst.sg.statemem.target = target
                --inst.components.health:DoDelta(-5, true)
            end
            inst.components.locomotor:Stop()
        end,
        timeline = {
            TimeEvent(14 * FRAMES/1.5, function(inst)
				if GetModConfigData("枪的声音") then
				inst.SoundEmitter:PlaySound("kuangsankaiqiang/NGXY/kuangsankaiqiang", nil, 0.3)
				else
                inst.SoundEmitter:PlaySound("lw_homura/pistol/silent", nil, 0.3)
				end
				
				
                inst.components.combat:DoAttack(inst.sg.statemem.target)
            end)
        },
        onexit = function(inst)
            inst.components.combat:SetTarget(nil)
            inst.AnimState:SetDeltaTimeMultiplier(1)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.components.combat:CancelAttack()
            end
        end,
        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end)
        }
    }

    sg.states["krm_gun_pst"] = State {
        name = "krm_gun_pst",
        tags = { "notalking", "autopredict" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("homura_gun_pst")
        end,
        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end)
        }
    }

    sg.states["krm_handgun_shoot"] = State{
        name = "krm_handgun_shoot",
        tags = { "attack", "notalking", "abouttoattack", "busy", "autopredict" },
        onenter = function(inst, data)
            inst.components.locomotor:Stop()
            inst.sg.statemem.target = data.target
            inst:ForceFacePoint(data.posx, 0, data.posz)

            inst.AnimState:SetDeltaTimeMultiplier(1.5)
            inst.AnimState:PlayAnimation("hand_shoot")
            inst.AnimState:OverrideSymbol("swap_object", "krm_gun", "krm_gun2")
        end,
        timeline = {
            TimeEvent(3 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
            end),
            TimeEvent(5 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("attack")
            end),
            TimeEvent(12 * FRAMES, function(inst)
                local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if weapon and inst.sg.statemem.target then
                    local bullet = weapon.components.container:GetItemInSlot(1)
                    if bullet and BulletFn[bullet.prefab] then
                        BulletFn[bullet.prefab](inst, inst.sg.statemem.target)
                        bullet.components.stackable:Get():Remove()
                        weapon.components.weapon:LaunchProjectile(inst, inst.sg.statemem.target)
                    end
                end
            end)
        },
        onexit = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:SetDeltaTimeMultiplier(1)
            inst.AnimState:OverrideSymbol("swap_object", "krm_gun", "krm_gun1")
        end,
        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end)
        }
    }

    local oldOnAttacked = sg.events["attacked"].fn
    sg.events["attacked"] = EventHandler("attacked", function(inst, data, ...)
        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        if inst:HasTag("kur_knife_builder") or inst:HasTag("kurumi") and equip and equip:HasTag("krm_armor") then
            return
        end
        return oldOnAttacked(inst, data, ...)
    end)
end)
AddStategraphPostInit("wilson_client", function(sg)
    sg.states["krm_gun_atk"] = State {
        name = "krm_gun_atk",
        tags = { "attack", "notalking", "abouttoattack" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hand_shoot")
            inst.AnimState:SetDeltaTimeMultiplier(2)
            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(14 * FRAMES/1.5)
            inst.components.locomotor:Stop()
        end,
        ontimeout = function(inst)
            --inst.sg:GoToState("idle")
        end,
        onexit = function(inst)
            inst.AnimState:SetDeltaTimeMultiplier(1)
            if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat then
                inst.replica.combat:CancelAttack()
            end
        end,
        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end)
        }
    }

    sg.states["krm_handgun_shoot"] = State{
        name = "krm_handgun_shoot",
        tags = {"attack", "notalking", "abouttoattack", "busy", "nopredict"},
        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction then
                inst:PerformPreviewBufferedAction()
                if buffaction.target and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                end
            end
            if inst.replica.combat then
                inst.replica.combat:StartAttack()
            end
            inst.components.locomotor:Stop()

            inst.AnimState:SetDeltaTimeMultiplier(1.5)
            inst.AnimState:PlayAnimation("hand_shoot")
            inst.sg:SetTimeout(15 * FRAMES)
        end,
        timeline = {
            TimeEvent(3 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
            end),
            TimeEvent(5 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("attack")
            end),
            TimeEvent(8 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end)
        },
        onexit = function(inst)
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end,

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end)
        }
    }
end)

AddStategraphPostInit("wilson", function(sg)
    local oldStstate = sg.actionhandlers[ACTIONS.ATTACK].deststate
    sg.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action)
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if inst:HasTag("kurumi") and item and (item:HasTag("krm_gun") or item:HasTag("knife_open"))
        and not (inst.components.rider and inst.components.rider:IsRiding()) then
            return "krm_gun_atk"
        end
        return oldStstate(inst, action)
    end
    local play_flute = sg.states.play_flute
    if play_flute then
        local old_enter = play_flute.onenter
        function play_flute.onenter(inst, ...)
            if old_enter then
                old_enter(inst, ...)
            end
            local inv_obj = inst.bufferedaction and inst.bufferedaction.invobject or nil
            if inv_obj and inv_obj:HasTag("krm_flute") then
                inst.AnimState:OverrideSymbol("pan_flute01", "krm_flute", "pan_flute01")
            end
        end
    end
end)
AddStategraphPostInit("wilson_client", function(sg)
    local oldStstate = sg.actionhandlers[ACTIONS.ATTACK].deststate
    sg.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action)
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if inst:HasTag("kurumi") and item and (item:HasTag("krm_gun") or item:HasTag("knife_open")) 
        and not (inst.replica.rider and inst.replica.rider:IsRiding()) then    
            return "krm_gun_atk"
        end
        return oldStstate(inst, action)
    end
end)

local function Krm_KeyCanDoSg(inst)
    return not (inst:HasTag("playerghost") or (TheFrontEnd:GetOpenScreenOfType("ChatInputScreen")
            or TheFrontEnd:GetOpenScreenOfType("ConsoleScreen"))) and inst:HasTag("kurumi")
end
local function Krm_CanDoSg(inst)
    return not (inst.components.health:IsDead() or inst.sg.statemem.heavy or inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("dead")
            or inst.sg:HasStateTag("drowning") or inst.sg:HasStateTag("sleeping") or inst.components.rider:IsRiding())
end
--[[
TheInput:AddKeyDownHandler(KEY_Z, function()
    if Krm_KeyCanDoSg(ThePlayer) then
        local ent = TheInput:GetWorldEntityUnderMouse()
        local x, y, z = TheInput:GetWorldPosition():Get()
        SendModRPCToServer(MOD_RPC.Krm_Server.DoRpc, ent, x, z)
    end
end)
]]
AddModRPCHandler("Krm_Server", "DoRpc", function(player, val1, val2, val3)
    if val1 and val2 and val3 and Krm_CanDoSg(player) then
        local weapon = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if weapon and weapon:HasTag("krm_gun") and weapon.components.container:GetItemInSlot(1) then
            player.sg:GoToState("krm_handgun_shoot", { target = val1, posx = val2, posz = val3 })
        end
    end
end)

AddAction("KrmChange", "切换", function(act)
    if act.doer and act.invobject and act.doer:HasTag("player") then 
        if act.invobject.krmchange:value() then
            act.invobject.krmchange:set(false)
        else
            act.invobject.krmchange:set(true)
        end
        return true
    end
end)

AddComponentAction("INVENTORY", "krm_bindaction", function(inst, doer, actions, right)
    if inst:HasTag("krm_change") and inst.replica.equippable and inst.replica.equippable:IsEquipped() then
        table.insert(actions,  ACTIONS.KrmChange)
    end
end)

AddStategraphActionHandler("wilson",  ActionHandler( ACTIONS.KrmChange, "give"))
AddStategraphActionHandler("wilson_client",  ActionHandler( ACTIONS.KrmChange, "give"))

AddAction("KrmCity", "打开", function(act)
    if act.doer and act.target and act.doer:HasTag("player") then
        if act.target.krmcity:value() then
            act.target.krmcity:set(false)
        else
            act.target.krmcity:set(true)
        end
        return true
    end
end)

AddComponentAction("SCENE", "krm_bindaction", function(inst, doer, actions, right)
    if right then
        if inst:HasTag("krm_city") and doer:HasTag("kurumi") then  --
            table.insert(actions, ACTIONS.KrmCity)
        end
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.KrmCity, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.KrmCity, "give"))

ACTIONS.KrmCity.priority = 20
ACTIONS.KrmChange.priority = 20
---==================================[[by乌拉]]============================================
modimport("scripts/mains/kurumi_hook.lua") 
modimport("scripts/mains/kurumi_sg.lua") 
modimport("scripts/mains/kurumi_action.lua") 

AddComponentPostInit("cursable", function(self)
	local oldIsCursable = self.IsCursable
	function self:IsCursable(item)
		if item and item.components.curseditem and item.components.curseditem.curse  == "MONKEY" and self.inst:HasTag("kurumi") then
			return false
		end
		return oldIsCursable(self,item)
	end
	local oldApplyCurse = self.ApplyCurse
	function self:ApplyCurse(item)
		if item and item.components.curseditem and item.components.curseditem.curse == "MONKEY" and self.inst:HasTag("kurumi") then
			return
		end
		return oldApplyCurse(self,item)
	end
	local oldForceOntoOwner = self.ForceOntoOwner
	function self:ForceOntoOwner(item)
		if item and item.components.curseditem and item.components.curseditem.curse == "MONKEY" and self.inst:HasTag("kurumi") then
			return
		end
		return oldForceOntoOwner(self,item)
	end
end)

local function onchuansongks(inst,data)
	if data and data.player and data.player.components.follower_krm then
		data.player.components.follower_krm:Active()
	end
end

AddPrefabPostInit("world", function(inst)
	if TheWorld.ismastersim then
		inst:ListenForEvent("ms_playerdespawnandmigrate", onchuansongks)
	end
end)

AddPlayerPostInit(function(inst)
	if TheWorld.ismastersim then
		inst:AddComponent("follower_krm")
		local _OnDespawn = inst._OnDespawn or function() end
		inst._OnDespawn = function(inst,...)
			_OnDespawn(inst,...)
			inst.components.follower_krm:SaveBeefalo()
		end
	end
end)
AddModRPCHandler("kuangsan", "shunjianchuanyue", function(inst, x, y, z)
        local a, b, c = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(a, b, c, 3, {"_health"}, {"wall"})
        for k, v in pairs(ents) do
            if v == inst or v:HasTag("player") then
                if inst and x and y and z then
                    if v.Physics then
                        v.Physics:Teleport(x, y, z)
                    end
                end
            end
        end
end)
AddClientModRPCHandler("kuangsan", "chuansuoditu", function(moshi,yewan)
    if ThePlayer then
		if moshi then
		
				ThePlayer.lastFov = TheCamera.fov or 1
				ThePlayer.zoomstep = TheCamera.zoomstep or 4
				ThePlayer.mindist = TheCamera.mindist or 15
				ThePlayer.maxdist = TheCamera.maxdist or 50
				ThePlayer.mindistpitch = TheCamera.mindistpitch or 30
				ThePlayer.maxdistpitch = TheCamera.maxdistpitch or 60
				ThePlayer.distance = TheCamera.distance or 30
				ThePlayer.distancetarget = TheCamera.distancetarget or 30
				
				TheCamera.zoomstep = 10 
				TheCamera.mindist = 10 
				TheCamera.maxdist = 255
				TheCamera.mindistpitch = 90 
				TheCamera.maxdistpitch = 90 
				TheCamera.distance = 80 
				TheCamera.distancetarget = 80 
				TheCamera.fov = 165
				
				if ThePlayer and yewan and yewan == "night" and ThePlayer.components.playervision then
				ThePlayer.qiehuanlvjingle = true
				ThePlayer.components.playervision:ForceNightVision(true)
                ThePlayer.components.playervision:SetCustomCCTable(BEAVERVISION_COLOURCUBES)
				end
				
				ThePlayer.components.talker:Say("选择穿梭点")
			else
				TheCamera.zoomstep = ThePlayer.zoomstep 
				TheCamera.mindist = ThePlayer.mindist 
				TheCamera.maxdist = ThePlayer.maxdist
				TheCamera.mindistpitch = ThePlayer.mindistpitch 
				TheCamera.maxdistpitch = ThePlayer.maxdistpitch 
				TheCamera.distance = ThePlayer.distance 
				TheCamera.distancetarget = ThePlayer.distancetarget 
				TheCamera.fov = ThePlayer.lastFov
				ThePlayer.lastFov = nil
				ThePlayer.zoomstep = nil
				ThePlayer.mindist = nil
				ThePlayer.maxdist = nil
				ThePlayer.mindistpitch = nil
				ThePlayer.maxdistpitch = nil
				ThePlayer.distance = nil
				
				if ThePlayer and ThePlayer.components.playervision and ThePlayer.qiehuanlvjingle then
					ThePlayer.qiehuanlvjingle = nil
					ThePlayer.components.playervision:ForceNightVision(false)
					ThePlayer.components.playervision:SetCustomCCTable(nil)
				end
				
				ThePlayer.components.talker:Say("瞬间转移")
				
				local x, y, z = (TheInput:GetWorldPosition() or Vector3(255, 192, 203)):Get() ----获取鼠标位置
				SendModRPCToServer(MOD_RPC["kuangsan"]["shunjianchuanyue"], x, y, z)

		end
    end
end)
-----------------
MakeCharacterSkin("kurumi","kurumi_none",{
    name = STRINGS.CHARACTER_NAMES.kurumi,
    des = STRINGS.CHARACTER_TITLES.kurumi,
	build_name_override = "kurumi",
	rarity = "Character",
    quotes = STRINGS.CHARACTER_QUOTES.kurumi,
    skins = {normal_skin = "kurumi", ghost_skin = "ghost_kurumi_build"},
    skin_tags = {"BASE", "kurumi", "CHARACTER"},
})
MakeCharacterSkin("kurumi","krm_gothic_nun",{
    name = "哥特修女",
    des = "获得了二亚力量后的新姿态",
    quotes = "总有一天，我会结束这一切",
	rarity = "Elegant",
	rarity_modifier = "Woven",
    build_name_override = "krm_gothic_nun",
    skins = {normal_skin = "krm_gothic_nun", ghost_skin = "ghost_kurumi_build"},
    skin_tags = {"BASE", "krm_gothic_nun"},
})


modimport "taluopai/taluopai"                   ----塔罗牌

AddComponentAction("INVENTORY", "inventoryitem", function(inst, doer, actions, right)
	if doer then
		if inst and inst:HasTag("taluopai") then
			table.insert(actions, ACTIONS.TALUOPAIYUEDU)
		end
	end
end)
