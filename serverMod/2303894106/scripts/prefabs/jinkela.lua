local assets =
{
    Asset("ANIM", "anim/jinkela.zip"),
    Asset("IMAGE", "images/inventoryimages/jinkela.tex"),
    Asset("ATLAS", "images/inventoryimages/jinkela.xml"),
}

TUNING.JINKELA_USES = 6
local soil_length = 2    --一个地块的长宽=4

local function GetFertilizerKey(inst)
    return inst.prefab
end

local function fertilizerresearchfn(inst)
    return inst:GetFertilizerKey()
end

local function onapplied(inst, final_use, doer, target)
    local tilecenter = {
        x = 0, y = 0, z = 0
    }
    local pos = {
        x = 0, y = 0, z = 0
    }
    --print("执行applied")
    --获取地块中心点
    pos.x,  pos.y,  pos.z = doer.Transform:GetWorldPosition()
    local tilex, tiley = TheWorld.Map:GetTileCoordsAtPoint(pos.x, pos.y, pos.z)

    if target then
        tilecenter.x, tilecenter.y, tilecenter.z = target.Transform:GetWorldPosition()
    else
        tilecenter = Point(TheWorld.Map:GetTileCenterPoint(tilex, tiley))
    end
    --print("遍历开始")
    for k, v in ipairs(TheSim:FindEntities(tilecenter.x, 0, tilecenter.z, 3.5)) do
        -- if v.components.crop then   --旧作物使用该组件
        --     local fertilizer = SpawnPrefab("jinkela")
        --     v.components.crop.Fertilize(v.components.crop, fertilizer, data.doer)
        --     fertilizer:Remove()
        -- end
        local x,y,z = v.Transform:GetWorldPosition()
        if x < tilecenter.x+soil_length and x > tilecenter.x-soil_length and z < tilecenter.z+soil_length and z > tilecenter.z-soil_length then
            
            if v.components.growable then
                local stg_now = v.components.growable:GetStage()
                if v.components.growable.stages[stg_now + 1] and not(v.components.growable.stages[stg_now + 1].name == "rotten") then
                    v.components.growable:DoGrowth()
                end
                -- if v.components.growable.stages[stg_now + 2] and v.components.growable.stages[stg_now + 2].name == "rotten" then
                --     v.components.growable:SetStage(stg_now + 1)
                -- elseif not(v.components.growable.stages[stg_now].name == "rotten" 
                -- or (v.components.growable.stages[stg_now + 1] and v.components.growable.stages[stg_now + 1].name == "rotten")) then
                --     v.components.growable:SetStage(stg_now + 2)
                -- end
            end
        end
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("jinkela")
    inst.AnimState:SetBuild("jinkela")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "small", 0.2, 0.95)

    inst:AddTag("fertilizerresearchable")
    inst.GetFertilizerKey = GetFertilizerKey

    if TUNING.IS_NEW_AGRICULTURE then
        MakeDeployableFertilizerPristine(inst)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/jinkela.xml" --物品贴图

    ----------------------
    if TUNING.IS_NEW_AGRICULTURE then
        inst:AddComponent("fertilizerresearchable")
        inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)
    end
    ----------------------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.JINKELA_USES)
    inst.components.finiteuses:SetUses(TUNING.JINKELA_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    ----------------------
    inst:AddComponent("fertilizer")
    inst.components.fertilizer:SetHealingAmount(TUNING.POOP_FERTILIZE_HEALTH)

    if _G.CONFIGS_EA.ENABLEDMODS.legion then
        inst.components.fertilizer.fertilizervalue = TUNING.POOP_FERTILIZE*50
    else
        inst.components.fertilizer.fertilizervalue = TUNING.POOP_FERTILIZE*10
    end

    inst.components.fertilizer.soil_cycles = TUNING.POOP_SOILCYCLES
    inst.components.fertilizer.withered_cycles = TUNING.POOP_WITHEREDCYCLES
    if inst.components.fertilizer.SetNutrients then
        inst.components.fertilizer:SetNutrients(8, 8, 8)
    end
    inst.components.fertilizer.onappliedfn = onapplied

    ----------------------

    inst:AddComponent("smotherer")
    if TUNING.IS_NEW_AGRICULTURE then
        MakeDeployableFertilizer(inst)
    end

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("jinkela", fn, assets)