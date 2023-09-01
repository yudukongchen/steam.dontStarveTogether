local assets = {
	Asset( "ANIM", "anim/zan2.zip" ),
}

local prefabs = 
{
	"asa_blade2_item",
}

local function builder_onbuilt(inst, builder)

	if builder and builder.asa_blade2 and builder.asa_blade2:value() == false then
		builder.asa_blade2:set(true)
		builder.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
		builder.AnimState:OverrideSymbol("zan", "zan2", "zan2") --替换刀光
		local w = SpawnPrefab("asa_blade2_item")
		builder.components.inventory:Equip(w)
		builder.sg:GoToState("asa_disarm")
	end
    inst:Remove()
end

local function MakeBuilder(prefab)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()

        inst:AddTag("CLASSIFIED")

        inst.persists = false

        inst:DoTaskInTime(0, inst.Remove)

        if not TheWorld.ismastersim then
            return inst
        end
        inst.OnBuiltFn = builder_onbuilt

        return inst
    end

    return Prefab(prefab, fn)
end

return  MakeBuilder("asa_blade2")
