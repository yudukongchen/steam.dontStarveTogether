require "prefabutil"

local cooking = require("cooking")
local containers = require "containers"
local params = containers.params
local ContainerWidget = require("widgets/containerwidget")
local TzDarkCookpotUI = require("widgets/tz_darkcookpot_ui")
local TzDarkCookpotUtil = require("tz_darkcookpot_util")

local cookpot_recipes = cooking.recipes["cookpot"]
local cookpot_recipes_warly = cooking.recipes["portablecookpot"]
for k,recipe in pairs (cookpot_recipes) do 
    AddCookerRecipe("tz_dark_cookpot", recipe,cooking.IsModCookerFood(k)) 
end  
for k,recipe in pairs (cookpot_recipes_warly) do 
    AddCookerRecipe("tz_dark_cookpot", recipe,cooking.IsModCookerFood(k)) 
end  

-- local function IsFishInv(prefab)
--     -- body
-- end

local BAR_SKIP_HEIGHT = 175
local SLOT_DIST = 80
params.tz_dark_cookpot =
{
    widget =
    {
        slotpos =
        {
            -- 一共10个格子 3-4-3结构
            Vector3(-SLOT_DIST,BAR_SKIP_HEIGHT,0),Vector3(0,BAR_SKIP_HEIGHT,0),Vector3(SLOT_DIST,BAR_SKIP_HEIGHT,0),
            Vector3(-SLOT_DIST*1.5,0,0),Vector3(-SLOT_DIST*0.5,0,0),Vector3(SLOT_DIST*0.5,0,0),Vector3(SLOT_DIST*1.5,0,0),
            Vector3(-SLOT_DIST,-BAR_SKIP_HEIGHT,0),Vector3(0,-BAR_SKIP_HEIGHT,0),Vector3(SLOT_DIST,-BAR_SKIP_HEIGHT,0),
        },
        -- animbank = "ui_cookpot_1x4",
        -- animbuild = "ui_cookpot_1x4",
        pos = Vector3(300, 0, 0),
        side_align_tip = 100,
        buttoninfo =
        {
            text = STRINGS.ACTIONS.COOK,
            position = Vector3(0, -330, 0),
            fn = function(inst,doer)
                if inst.components.container ~= nil then
                    BufferedAction(doer, inst, ACTIONS.COOK):Do()
                elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                    SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.COOK.code, inst, ACTIONS.COOK.mod_name)
                end
            end,
            validfn = function(inst)
                if not inst.replica.container then 
                    return false
                end 
                local item_num = 0
                for k,v in pairs(inst.replica.container:GetItems()) do 
                    if v and v:IsValid() then 
                        item_num = item_num + 1
                    end
                end

                return item_num >= 4
            end,
        },

        is_tz_darkcookpot = true,
    },
    acceptsstacks = false,
    type = "cooker",

    itemtestfn = function(container, item, slot)
        if container.inst:HasTag("burnt") then 
            return false
        end 
        return cooking.IsCookingIngredient(item.prefab) 
            or cooking.GetRecipe(container.inst.prefab,item.prefab)
            or table.contains(TzDarkCookpotUtil.creatureTypeA,item.prefab) 
            or table.contains(TzDarkCookpotUtil.creatureTypeB,item.prefab)
            or item.replica.health ~= nil
            or item.prefab == "reviver"
            -- or table.contains(creatureTypeFish,item.prefab)
    end,
}

for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

-- local BarSlotPosThree = {Vector3(-72,0,0),Vector3(0,0,0),Vector3(72,0,0)}
-- local BarSlotPosFour = {Vector3(-108,0,0),Vector3(-36,0,0),Vector3(36,0,0),Vector3(108,0,0)}

local old_ContainerWidget_Open = ContainerWidget.Open
function ContainerWidget:Open(container, doer, ...)
    local ret = old_ContainerWidget_Open(self,container, doer, ...)

    local widget = container.replica.container:GetWidget()
    if widget.is_tz_darkcookpot then 
        self.TzDarkCookpotUI = self:AddChild(TzDarkCookpotUI(doer,container))
        self.TzDarkCookpotUI:SetPosition(0,7,0)
        self.TzDarkCookpotUI:SlideIn()
        self.TzDarkCookpotUI:MoveToBack()
        self.button:SetTextures("images/tzui/tz_darkcookpot_button.xml","tz_darkcookpot_button.tex", "tz_darkcookpot_button.tex", "tz_darkcookpot_button.tex", nil, nil, {1,1}, {0,0})
        
        
        -- self.button:SetImageNormalColour(1,1,1,1)
        -- self.button:SetImageFocusColour(1,1,1,1)
        -- self.button:SetImageSelectedColour(1,1,1,1)
        -- self.button:SetImageDisabledColour(0.5,0.5,0.5,1)
    end 

    return ret
end

local old_ContainerWidget_Close = ContainerWidget.Close
function ContainerWidget:Close(...)
    local ret = old_ContainerWidget_Close(self,...)

    if self.TzDarkCookpotUI then 
        -- self:RemoveChild(self.TzDarkCookpotUI)
        self.TzDarkCookpotUI:SlideOut()
        self.TzDarkCookpotUI = nil 
    end 

    return ret
end

local old_GetCandidateRecipes = GetCandidateRecipes
function GetCandidateRecipes(cooker, ingdata,...)
    if cooker == "tz_dark_cookpot" then 
        -- print("GetCandidateRecipes-tz_dark_cookpot:")
        -- names   
        --     monstermeat_cooked  4   
        -- tags    
        --     monster 4   
        --     meat    4   
        --     precook 4
        for k,v in pairs(ingdata) do 
            if k == "names" then 
                for name,num in pairs(v) do 
                    -- 含有A类食物 其当做1肉度
                    if table.contains(TzDarkCookpotUtil.creatureTypeA,name) then
                        ingdata.tags.meat = (ingdata.tags.meat or 0) + 1
                    end
                end
            end
        end

    end
    return old_GetCandidateRecipes(cooker, ingdata,...)
end

----------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/cook_pot.zip"),
    Asset("ANIM", "anim/cook_pot_food.zip"),
    Asset("ANIM", "anim/tz_dark_cookpot.zip"),
    Asset("ANIM", "anim/ui_cookpot_1x4.zip"),

    Asset("ANIM", "anim/tz_dark_cookpot_ui.zip"),
    Asset( "IMAGE", "images/inventoryimages/tz_dark_cookpot.tex" ),
    Asset( "ATLAS", "images/inventoryimages/tz_dark_cookpot.xml" ),
    Asset( "IMAGE", "images/tzui/tz_darkcookpot_button.tex" ),
    Asset( "ATLAS", "images/tzui/tz_darkcookpot_button.xml" ),
    
    Asset( "IMAGE", "images/tzui/tz_darkcookpot_button_no.tex" ),
    Asset( "ATLAS", "images/tzui/tz_darkcookpot_button_no.xml" ),
}

local prefabs =
{
    "collapse_small",
}

for k, v in pairs(cooking.recipes.cookpot) do
    table.insert(prefabs, v.name)

	if v.overridebuild then
        table.insert(assets, Asset("ANIM", "anim/"..v.overridebuild..".zip"))
	end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if not inst:HasTag("burnt") and inst.components.stewer.product ~= nil and inst.components.stewer:IsDone() then
        inst.components.stewer:Harvest()
    end
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        -- if inst.components.stewer:IsCooking() then
        --     inst.AnimState:PlayAnimation("hit_cooking")
        --     inst.AnimState:PushAnimation("cooking_loop", true)
        --     inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
        -- elseif inst.components.stewer:IsDone() then
        --     inst.AnimState:PlayAnimation("hit_full")
        --     inst.AnimState:PushAnimation("idle_full", false)
        -- else
        if inst.components.container ~= nil and inst.components.container:IsOpen() then
            inst.components.container:Close()
            --onclose will trigger sfx already
        else
            inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
        end
        -- inst.AnimState:PlayAnimation("hit_empty")
        -- inst.AnimState:PushAnimation("normal_loop", false)
        -- end
    end
end

--anim and sound callbacks

local function startcookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("work_pre")
        inst.AnimState:PushAnimation("work_loop", true)
        inst.SoundEmitter:KillSound("snd")
        -- inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/campfire", "snd")
        inst.SoundEmitter:SetParameter("snd", "intensity", 1.0)
        inst.Light:Enable(true)
    end
end

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("open_pre")
        inst.AnimState:PushAnimation("open_loop", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then 
        if not inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("open_pst")
            inst.AnimState:PushAnimation("normal_loop", true)
            inst.SoundEmitter:KillSound("snd")
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end

local function SetProductSymbol(inst, product, overridebuild)
    local recipe = cooking.GetRecipe(inst.prefab, product)
    local potlevel = recipe ~= nil and recipe.potlevel or nil
    local build = overridebuild or (recipe ~= nil and recipe.overridebuild) or "cook_pot_food"
    local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or product

    if potlevel == "high" then
        inst.AnimState:Show("swap_high")
        inst.AnimState:Hide("swap_mid")
        inst.AnimState:Hide("swap_low")
    elseif potlevel == "low" then
        inst.AnimState:Hide("swap_high")
        inst.AnimState:Hide("swap_mid")
        inst.AnimState:Show("swap_low")
    else
        inst.AnimState:Hide("swap_high")
        inst.AnimState:Show("swap_mid")
        inst.AnimState:Hide("swap_low")
    end

    inst.AnimState:OverrideSymbol("swap_cooked", build, overridesymbol)
end

local function spoilfn(inst)
    if not inst:HasTag("burnt") then
        inst.components.stewer.product = inst.components.stewer.spoiledproduct
        SetProductSymbol(inst, inst.components.stewer.product)
    end
end

local function ShowProduct(inst)
    if not inst:HasTag("burnt") then
        local product = inst.components.stewer.product
        SetProductSymbol(inst, product, IsModCookingProduct(inst.prefab, product) and product or nil)
    end
end

local function donecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("finash_pre")
        inst.AnimState:PushAnimation("finash_loop", true)
        ShowProduct(inst)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
        inst.Light:Enable(false)
    end
end

local function continuedonefn(inst)
    if not inst:HasTag("burnt") then 
        inst.AnimState:PlayAnimation("finash_loop", true)
        ShowProduct(inst)
    end
end

local function continuecookfn(inst)
    if not inst:HasTag("burnt") then 
        inst.AnimState:PlayAnimation("work_loop", true)
        inst.Light:Enable(true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
    end
end

local function harvestfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("normal_loop",true)
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end

local function getstatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
        or (inst.components.stewer:IsDone() and "DONE")
        or (not inst.components.stewer:IsCooking() and "EMPTY")
        or (inst.components.stewer:GetTimeToCook() > 15 and "COOKING_LONG")
        or "COOKING_SHORT"
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("set")
    inst.AnimState:PushAnimation("normal_loop", true)
    -- inst.SoundEmitter:PlaySound("dontstarve/common/cook_pot_craft")
    inst.SoundEmitter:PlaySound("dontstarve/common/together/dragonfly_furnace/place")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
        inst.Light:Enable(false)
    end   
end

local function onloadpostpass(inst, newents, data)
    if data and data.additems and inst.components.container then
        for i, itemname in ipairs(data.additems)do
            local ent = SpawnPrefab(itemname)
            inst.components.container:GiveItem( ent )
        end
    end
end

------------------------------------------------------------------------------------------------------




local function cookpot_common(inst)
    inst.up_slots = {1,2,3}
    inst.mid_slots = {4,5,6,7}
    inst.down_slots = {8,9,10}

    -- inst.nameoverride = "cookpot"
    inst.AnimState:SetBank("tz_dark_cookpot")
    inst.AnimState:SetBuild("tz_dark_cookpot")
    inst.AnimState:PlayAnimation("normal_loop",true)
    -- inst.MiniMapEntity:SetIcon("cookpot.png")    
end

local function dospoil(inst, self)
    self.task = nil
    self.targettime = nil
    self.spoiltime = nil

    if self.onspoil ~= nil then
        self.onspoil(inst)
    end
end

local function dostew(inst, self)
    self.task = nil
    self.targettime = nil
    self.spoiltime = nil
    
    if self.ondonecooking ~= nil then
        self.ondonecooking(inst)
    end

    if self.product == self.spoiledproduct then
        if self.onspoil ~= nil then
            self.onspoil(inst)
        end
    elseif self.product ~= nil then
        local recipe = cooking.GetRecipe(inst.prefab, self.product)
        local prep_perishtime = (recipe ~= nil and (recipe.cookpot_perishtime or recipe.perishtime)) or 0
        if prep_perishtime > 0 then
            local prod_spoil = self.product_spoilage or 1
            self.spoiltime = prep_perishtime * prod_spoil
            self.targettime =  GetTime() + self.spoiltime
            self.task = self.inst:DoTaskInTime(self.spoiltime, dospoil, self)
        end
    end

    self.done = true
end

local function cookpot_common_master(inst)
    inst:AddComponent("destroyable")
    inst.components.destroyable.ondestroy = function(inst)
        SpawnAt("statue_transition",inst).Transform:SetScale(1.3,1.3,1.3)
        SpawnAt("statue_transition_2",inst).Transform:SetScale(1.3,1.3,1.3)
        if not inst:HasTag("burnt") and inst.components.stewer.product ~= nil and inst.components.stewer:IsDone() then
            inst.components.stewer:Harvest()
        end
        inst.components.container:DropEverything()
    end

    inst.components.container:WidgetSetup("tz_dark_cookpot")        

    inst.components.stewer.CanCook = function(self)
        return self.inst.components.container and #self.inst.components.container:GetAllItems() >= 4
    end
    inst.components.stewer.StartCooking = function(self,doer, ... )
        if self.targettime == nil and self.inst.components.container ~= nil then
            self.chef_id = (doer ~= nil and doer.player_classified ~= nil) and doer.userid
            self.ingredient_prefabs = {}

            self.done = nil
            self.spoiltime = nil

            if self.onstartcooking ~= nil then
                self.onstartcooking(self.inst)
            end

            for k, v in pairs (self.inst.components.container.slots) do
                table.insert(self.ingredient_prefabs, v.prefab)
            end

            local cooktime = 1
            -- self.product, cooktime = cooking.CalculateRecipe(self.inst.prefab, self.ingredient_prefabs)
            self.product, cooktime = TzDarkCookpotUtil.DarkotCalculateRecipe(self.inst,true)
            local productperishtime = cooking.GetRecipe(self.inst.prefab, self.product).perishtime or 0

            if productperishtime > 0 then
                local spoilage_total = 0
                local spoilage_n = 0
                for k, v in pairs(self.inst.components.container.slots) do
                    if v.components.perishable ~= nil then
                        spoilage_n = spoilage_n + 1
                        spoilage_total = spoilage_total + v.components.perishable:GetPercent()
                    end
                end
                self.product_spoilage =
                    (spoilage_n <= 0 and 1) or
                    (self.keepspoilage and spoilage_total / spoilage_n) or
                    1 - (1 - spoilage_total / spoilage_n) * .5
            else
                self.product_spoilage = nil
            end

            cooktime = cooktime * self.cooktimemult
            self.targettime = GetTime() + cooktime
            if self.task ~= nil then
                self.task:Cancel()
            end
            self.task = self.inst:DoTaskInTime(cooktime, dostew, self)

            self.inst.components.container:Close()
            self.inst.components.container:DestroyContents()
            self.inst.components.container.canbeopened = false
        end
    end
end


local function MakeCookPot(name, common_postinit, master_postinit, assets, prefabs)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddLight()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, .5)

        inst.Light:Enable(false)
        inst.Light:SetRadius(.6)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.5)
        inst.Light:SetColour(235/255,62/255,12/255)
        --inst.Light:SetColour(1,0,0)

        inst.DynamicShadow:SetSize(4,2.5)

        inst:AddTag("structure")

        --stewer (from stewer component) added to pristine state for optimization
        inst:AddTag("stewer")

        if common_postinit ~= nil then
            common_postinit(inst)
        end

        MakeSnowCoveredPristine(inst)

        -- inst.AnimState:SetHaunted(true)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stewer")
        inst.components.stewer.onstartcooking = startcookfn
        inst.components.stewer.oncontinuecooking = continuecookfn
        inst.components.stewer.oncontinuedone = continuedonefn
        inst.components.stewer.ondonecooking = donecookfn
        inst.components.stewer.onharvest = harvestfn
        inst.components.stewer.onspoil = spoilfn


        inst:AddComponent("container")
        --inst.components.container:WidgetSetup("cookpot")
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = getstatus

        inst:AddComponent("lootdropper")
        
        -- inst:AddComponent("workable")
        -- inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        -- inst.components.workable:SetWorkLeft(4)
        -- inst.components.workable:SetOnFinishCallback(onhammered)
        -- inst.components.workable:SetOnWorkCallback(onhit)

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
        --inst.components.hauntable:SetOnHauntFn(OnHaunt)

        MakeSnowCovered(inst)
        inst:ListenForEvent("onbuilt", onbuilt)

        -- MakeMediumBurnable(inst, nil, nil, true)
        -- MakeSmallPropagator(inst)

        inst.OnSave = onsave 
        inst.OnLoad = onload
        inst.OnLoadPostPass = onloadpostpass

        if master_postinit ~= nil then
            master_postinit(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end 

return MakeCookPot("tz_dark_cookpot", cookpot_common, cookpot_common_master, assets, prefabs),
    MakePlacer("tz_dark_cookpot_placer", "tz_dark_cookpot", "tz_dark_cookpot", "normal_loop")
