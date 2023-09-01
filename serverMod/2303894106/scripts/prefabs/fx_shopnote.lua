local assets =
{
    Asset("ANIM", "anim/fx_shopnote.zip"),
}

local function onhammered(inst, worker)
    inst:Remove()
end

local function onsave(inst,data)
    if inst.shop then
        data.shop = true
    else data.shop = false
    end
end

local function onload(inst,data)
    if data and data.shop then
        --print("SHOP值为true")
        local x, y, z = inst.Transform:GetWorldPosition()
        --print("NOTE.x:"..x.."z:"..z)
        for k,v in pairs(TheSim:FindEntities(x, y, z, 0.5)) do
            print(v.prefab)
            if v.prefab == "shop" then
                inst.shop = v
                v.note = inst
                --print("绑定SHOP成功")
            end
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("fx_shopnote")
    inst.AnimState:SetBuild("fx_shopnote")
    inst.AnimState:PlayAnimation("build")
    inst.AnimState:PushAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst.shop = nil

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("fx_shopnote", fn, assets)