require "prefabutil"

local cooking = require("cooking")

local assets =
{
    Asset("ANIM", "anim/tz_dragonpot.zip"),
    Asset("ANIM", "anim/cook_pot_food.zip"),
    Asset("ANIM", "anim/ui_cookpot_1x4.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tz_dragonpot.tex"), 
	Asset("ATLAS", "images/inventoryimages/tz_dragonpot.xml"), 
	
	
}

local prefabs =
{
    "collapse_small",
}
for k, v in pairs(cooking.recipes.cookpot) do
    table.insert(prefabs, v.name)
end

local cookpot_recipes = cooking.recipes["cookpot"]

local portablecookpot_recipes = cooking.recipes["portablecookpot"]
for k,recipe in pairs (cookpot_recipes) do
	AddCookerRecipe("tz_dragonpot", recipe, cooking.IsModCookerFood(k)) 
end  
for k,recipe in pairs (portablecookpot_recipes) do 
	AddCookerRecipe("tz_dragonpot", recipe, cooking.IsModCookerFood(k)) 
end  

local old_CalculateRecipe = cooking.CalculateRecipe
function cooking.CalculateRecipe(cooker, names,...)
	local product,cooktime = old_CalculateRecipe(cooker, names,...)
	if cooker == "tz_dragonpot" then 
		cooktime = 10 / TUNING.BASE_COOK_TIME 
	end
	return product,cooktime
end 

local old_GetRecipe = cooking.GetRecipe 
function cooking.GetRecipe(cooker, product,...)
	local ret = old_GetRecipe(cooker, product,...)

    if ret == nil then
        return ret
    end
    
	local ret_copy = deepcopy(ret)
	if cooker == "tz_dragonpot" then 
		ret_copy.perishtime = nil  
	end 
	
	return ret_copy
end 

local containers = require "containers"
local params = containers.params
params.tz_dragonpot =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 64 + 32 + 8 + 4, 0), 
            Vector3(0, 32 + 4, 0),
            Vector3(0, -(32 + 4), 0), 
            Vector3(0, -(64 + 32 + 8 + 4), 0),
        },
        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        pos = Vector3(200, 0, 0),
        side_align_tip = 100,
        buttoninfo =
        {
            text = STRINGS.ACTIONS.COOK,
            position = Vector3(0, -165, 0),
        }
    },
    acceptsstacks = false,
    type = "cooker",
}

function params.tz_dragonpot.itemtestfn(container, item, slot)
    return cooking.IsCookingIngredient(item.prefab) and not container.inst:HasTag("burnt")
end

function params.tz_dragonpot.widget.buttoninfo.fn(inst,doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.COOK):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.COOK.code, inst, ACTIONS.COOK.mod_name)
    end
end

function params.tz_dragonpot.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and inst.replica.container:IsFull()
end

for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

---------------------------------

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
        if inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("destroy")
            inst.AnimState:PushAnimation("cook", true)
            inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
        elseif inst.components.stewer:IsDone() then
            inst.AnimState:PlayAnimation("destroy")
            inst.AnimState:PushAnimation("finsh_loop", false)
			inst.components.stewer:Harvest()
        else
            if inst.components.container ~= nil and inst.components.container:IsOpen() then
                inst.components.container:Close()
                --onclose will trigger sfx already
            else
                inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
            end
            inst.AnimState:PlayAnimation("destroy")
            inst.AnimState:PushAnimation("loop", false)
        end
    end
end

--anim and sound callbacks

local function startcookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cook", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
        inst.Light:Enable(true)
    end
end

local function onopen(inst)
    if not inst:HasTag("burnt") then
        --inst.AnimState:PlayAnimation("open")
		inst.AnimState:PlayAnimation("open_loop")
		
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then 
        if not inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("loop")
            inst.SoundEmitter:KillSound("snd")
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end

local function SetProductSymbol(inst, product, overridebuild)
    local recipe = cooking.GetRecipe(inst.prefab, product)
    local potlevel = recipe ~= nil and recipe.potlevel or nil
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
    inst.AnimState:OverrideSymbol("swap_cooked", overridebuild or "cook_pot_food", product)
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
        SetProductSymbol(inst, product, IsModCookingProduct("cookpot", product) and product or nil)
    end
end

local function donecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("finsh_open")
		inst.AnimState:PushAnimation("food", false)
        inst.AnimState:PushAnimation("finsh_loop", true)
        ShowProduct(inst)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.Light:Enable(false)
		
		if inst.lightfx and inst.lightfx:IsValid() then
			inst.lightfx:Remove()
			inst.lightfx = nil 
		end
		inst.lightfx = inst:SpawnChild("nightstickfire")
    end
end

local function continuedonefn(inst)
    if not inst:HasTag("burnt") then 
        inst.AnimState:PlayAnimation("finsh_loop",true)
        ShowProduct(inst)
    end
end

local function continuecookfn(inst)
    if not inst:HasTag("burnt") then 
        inst.AnimState:PlayAnimation("cook", true)
        inst.Light:Enable(true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
    end
end

local function harvestfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("loop")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
	if inst.lightfx and inst.lightfx:IsValid() then
		inst.lightfx:Remove()
		inst.lightfx = nil 
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
	inst:SpawnChild("tz_dragonpot_firstlight")
	--inst:SpawnChild("tz_dragonpot_secondlight")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("loop", false)
	
	inst:DoTaskInTime(4.5,function()
		inst.SoundEmitter:PlaySound("dontstarve/common/cook_pot_craft")
	end)
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

--V2C: Don't do this anymore, spoiltime and product_spoilage aren't updated properly
--     when switching to "wetgoop". Switching while "jellybean" is cooking will even
--     cause a crash when harvested later, since it has no perishtime.
--[[local function OnHaunt(inst, haunter)
    local ret = false
    --#HAUNTFIX
    --if math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
        --if inst.components.workable then
            --inst.components.workable:WorkedBy(haunter, 1)
            --inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
            --ret = true
        --end
    --end
    if inst.components.stewer ~= nil and
        inst.components.stewer.product ~= "wetgoop" and
        math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        if inst.components.stewer:IsCooking() then
            inst.components.stewer.product = "wetgoop"
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
            ret = true
        elseif inst.components.stewer:IsDone() then
            inst.components.stewer.product = "wetgoop"
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
            continuedonefn(inst)
            ret = true
        end
    end
    return ret
end]]

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .65)

	inst.MiniMapEntity:SetIcon("tz_dragonpot_mapicon.tex")  
	
	inst.Transform:SetScale(1.7,1.7,1.7)
	
    inst.Light:Enable(false)
    inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,62/255,12/255)
    --inst.Light:SetColour(1,0,0)

    inst:AddTag("structure")

    --stewer (from stewer component) added to pristine state for optimization
    inst:AddTag("stewer")

    inst.AnimState:SetBank("tz_dragonpot")
    inst.AnimState:SetBuild("tz_dragonpot")
    inst.AnimState:PlayAnimation("loop")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("cookpot") 
		end
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
    inst.components.container:WidgetSetup("cookpot")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    --inst.components.hauntable:SetOnHauntFn(OnHaunt)

    MakeSnowCovered(inst)
    inst:ListenForEvent("onbuilt", onbuilt)
	
	--inst.shadow = inst:SpawnChild("tz_dragonpot_shadow")

    inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end

local function FinalOffset1(inst)
    inst.AnimState:SetFinalOffset(1)
end

local function FinalOffset2(inst)
    inst.AnimState:SetFinalOffset(2)
end

local function FinalOffset3(inst)
    inst.AnimState:SetFinalOffset(3)
end

local function CreateFx(prefabname,bank,build,anim,loop,forever,extrafn)
	local function fxfn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter() 
		inst.entity:AddNetwork()

		
		inst.AnimState:SetBank(bank)
		inst.AnimState:SetBuild(build)
		
		if anim then 
			inst.AnimState:PlayAnimation(anim,loop)
		end 
		
		inst.entity:SetPristine()
		if not TheWorld.ismastersim then
			return inst
		end
		
		if forever then 
			
		else
			inst.persists = false 
			inst:ListenForEvent("animover",inst.Remove)
		end 
		
		if extrafn then 
			extrafn(inst)
		end 
		
		return inst
	end 
	
	return Prefab(prefabname, fxfn, assets,prefabs)
end 

STRINGS.NAMES.TZ_DRAGONPOT = "中华龙腾锅"
STRINGS.RECIPE_DESC.TZ_DRAGONPOT = "金龙环绕，高速烹饪料理的厨具"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_DRAGONPOT = "来自东方大陆的金厨具！"

return Prefab("tz_dragonpot", fn, assets, prefabs),
    MakePlacer("tz_dragonpot_placer", "tz_dragonpot", "tz_dragonpot", "loop",nil,nil,nil,1.7),
	CreateFx("tz_dragonpot_firstlight","tz_dragonpot","tz_dragonpot","set_firstlight",nil,nil,FinalOffset1),
	CreateFx("tz_dragonpot_secondlight","tz_dragonpot","tz_dragonpot","set_secondlight",nil,nil,FinalOffset2),
	CreateFx("tz_dragonpot_shadow","tz_dragonpot","tz_dragonpot","shadow",true,true,FinalOffset1)
