
--逃跑待定。功能待定。

local assets =
{
    Asset("ANIM", "anim/qiongqibao.zip"),
    Asset("ATLAS", "images/inventoryimages/qiongqibao.xml")
}

local function OnSave(inst, data)
    if inst.highTemp ~= nil then
        data.highTemp = math.ceil(inst.highTemp)
    elseif inst.lowTemp ~= nil then
        data.lowTemp = math.floor(inst.lowTemp)
    end
end

local function OnLoad(inst, data)
    if data ~= nil then
        if data.highTemp ~= nil then
            inst.highTemp = data.highTemp
            inst.lowTemp = nil
        elseif data.lowTemp ~= nil then
            inst.lowTemp = data.lowTemp
            inst.highTemp = nil
        end
    end
end

local function OnRemove(inst)
    inst._light:Remove()
end

-- These represent the boundaries between the ranges (relative to ambient, so ambient is always "0")
local relative_temperature_thresholds = { -30, -10, 10, 30 }        --暖石颜色的界限

local function fakerange(range)
    if range>=5 then return 1 end
    return 2
end

local function GetRangeForTemperature(temp, ambient)                --简单的getrange
    local range = 1
    for i,v in ipairs(relative_temperature_thresholds) do
        if temp > ambient + v then
            range = range + 1
        end
    end
    return range
end

-- Heatrock emits constant temperatures depending on the temperature range it's in          --emit是发出的意思
local emitted_temperatures = { -10, 10, 25, 40, 60 }

local function HeatFn(inst, observer)           --
    local range = GetRangeForTemperature(inst.components.temperature:GetCurrent(), TheWorld.state.temperature)
    if range <= 2 then
        inst.components.heater:SetThermics(false, true)     --吸热
    elseif range >= 4 then
        inst.components.heater:SetThermics(true, false)     --放热
    else
        inst.components.heater:SetThermics(false, false)    --不吸热也不放热
    end
    return emitted_temperatures[range]
end

local function GetStatus(inst)
    if inst.currentTempRange == 1 then
        return "FROZEN"
    elseif inst.currentTempRange == 2 then
        return "COLD"
    elseif inst.currentTempRange == 4 then
        return "WARM"
    elseif inst.currentTempRange == 5 then
        return "HOT"
    end
end

local function UpdateImages(inst, range)
    inst.currentTempRange = range

    --动画改编是这的话就直接改这。。。不然就另写。。。
    inst.AnimState:PlayAnimation("idle_"..(fakerange(range)), true)
    local skinname = inst:GetSkinName()

    --只有一层皮的话。。。直接放在外面跑一遍完事吧。。。
    --inst.components.inventoryitem:ChangeImageName((skinname or "heat_rock")..tostring(range)) --应该只是小图标。
    if range == 5 then
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh") --我不知道是啥  --阴影特效。
        inst._light.Light:Enable(true)
    else
        inst.AnimState:ClearBloomEffectHandle()
        inst._light.Light:Enable(false)
    end
end

local function AdjustLighting(inst, range, ambient)
    if range == 5 then
        local relativetemp = inst.components.temperature:GetCurrent() - ambient
        local baseline = relativetemp - relative_temperature_thresholds[4]
        local brightline = relative_temperature_thresholds[4] + 20
        inst._light.Light:SetIntensity( math.clamp(0.5 * baseline/brightline, 0, 0.5 ) )
    else
        inst._light.Light:SetIntensity(0)       --intensity 强度
    end
end

local function TemperatureChange(inst, data)        --温度变化。。。
    local ambient_temp = TheWorld.state.temperature
    local cur_temp = inst.components.temperature:GetCurrent()
    local range = GetRangeForTemperature(cur_temp, ambient_temp)

    AdjustLighting(inst, range, ambient_temp)

    if range <= 1 then                          --这调整是为了适应mod吗？
        if inst.lowTemp == nil or inst.lowTemp > cur_temp then
            inst.lowTemp = math.floor(cur_temp) --floor，返回不大于x的最大整数，向上取整，即[]操作
        end
        inst.highTemp = nil
    elseif range >= 5 then
        if inst.highTemp == nil or inst.highTemp < cur_temp then
            inst.highTemp = math.ceil(cur_temp)
        end
        inst.lowTemp = nil
    elseif inst.lowTemp ~= nil then         --中间去掉最低温度。。。上面两个是处理越界吗？emm，此处代码功能存疑
        if GetRangeForTemperature(inst.lowTemp, ambient_temp) >= 3 then
            inst.lowTemp = nil
        end
    elseif inst.highTemp ~= nil and GetRangeForTemperature(inst.highTemp, ambient_temp) <= 3 then
        inst.highTemp = nil
    end

    if range ~= inst.currentTempRange then
        UpdateImages(inst, range)

        if (inst.lowTemp ~= nil and range >= 3) or
            (inst.highTemp ~= nil and range <= 3) then
            inst.lowTemp = nil
            inst.highTemp = nil
        end
    end
end

local function OnOwnerChange(inst)
    local newowners = {}
    local owner = inst
    while owner.components.inventoryitem ~= nil do
        newowners[owner] = true

        if inst._owners[owner] then
            inst._owners[owner] = nil
        else
            inst:ListenForEvent("onputininventory", inst._onownerchange, owner)
            inst:ListenForEvent("ondropped", inst._onownerchange, owner)
        end

        local nextowner = owner.components.inventoryitem.owner
        if nextowner == nil then
            break
        end

        owner = nextowner
    end

    inst._light.entity:SetParent(owner.entity)

    for k, v in pairs(inst._owners) do
        if k:IsValid() then
            inst:RemoveEventCallback("onputininventory", inst._onownerchange, k)
            inst:RemoveEventCallback("ondropped", inst._onownerchange, k)
        end
    end

    inst._owners = newowners
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("qiongqibao")
    inst.AnimState:SetBuild("qiongqibao")

    inst:AddTag("qiongqibao")

    inst:AddTag("bait")  --猫会拿?
    inst:AddTag("molebait")  --鼹鼠会拿?

    --HASHEATER (from heater component) added to pristine state for optimization
    inst:AddTag("HASHEATER")        --heater!!!

    MakeInventoryFloatable(inst, "small", 0.2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")            --可视。。。或者可检查？
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("inventoryitem")          --可检查
    inst.components.inventoryitem.atlasname = "images/inventoryimages/qiongqibao.xml"
    inst:ListenForEvent("onputininventory",function(inst,owner) 
        if owner and owner:HasTag("diting") and inst then
          if owner.components.freezebody then
            owner.components.freezebody:BodyOff(inst)
            owner.components.talker:Say("我可以拜访先生了！")
                 owner:ListenForEvent("donnothaveqiongqibao",function(owner)
                    if owner and owner:HasTag("diting") then
                        owner.components.talker:Say("寒气又回来了！")
                        if owner.components.freezebody then
                          owner.components.freezebody:BodyOn(inst)
                        end
                      end
                 end)
          end
        end
    end)
    --[[inst:ListenForEvent("donnothaveqiongqibao",function(inst,owner) 
        if owner and owner:HasTag("diting") and inst then
          if owner.components.freezebody then
            owner.components.freezebody:BodyOn(inst)
          end
        end
    end)]]

    inst:AddComponent("tradable")               --可交易的
    inst.components.tradable.rocktribute = 6    --价值

    inst:AddComponent("temperature")            --嚯呀
    inst.components.temperature.current = TheWorld.state.temperature        --划重点
    inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED  --固有绝缘（隔热）介质。。。
    inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_MED    --固有夏天隔热介质。。。
    inst.components.temperature:IgnoreTags("heatrock")                      --不影响其他暖石吗？

    inst:AddComponent("heater")
    inst.components.heater.heatfn = HeatFn
    inst.components.heater.carriedheatfn = HeatFn
    inst.components.heater.carriedheatmultiplier = TUNING.HEAT_ROCK_CARRIED_BONUS_HEAT_FACTOR       --倍数
    inst.components.heater:SetThermics(false, false)        --不吸热也不放热

    inst:ListenForEvent("temperaturedelta", TemperatureChange)  --这个event。。。emm
    inst.currentTempRange = 0
    
    --Create light                                                  --发光吧。。。  --照用就好。
    inst._light = SpawnPrefab("heatrocklight")
    inst._owners = {}
    inst._onownerchange = function() OnOwnerChange(inst) end
    --

    UpdateImages(inst, 1)
    OnOwnerChange(inst)

    MakeHauntableLaunchAndSmash(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnRemoveEntity = OnRemove

    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetRadius(.6)        --光半径
    inst.Light:SetFalloff(1)        --脱落
    inst.Light:SetIntensity(.5)     --强度
    inst.Light:SetColour(235 / 255, 165 / 255, 12 / 255)    --颜色
    inst.Light:Enable(false)        --不可用？

    inst.entity:SetPristine()       --初始化

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false           --？
    return inst
end

return Prefab("qiongqibao", fn, assets),
    Prefab("heatrocklight", lightfn)
