local assets =
{
    Asset("ANIM", "anim/python_fountain.zip"),     
	Asset("ANIM", "anim/change_fountain.zip"),     
	
	Asset( "IMAGE", "images/inventoryimages/change_fountain.tex" ),
	Asset( "ATLAS", "images/inventoryimages/change_fountain.xml" ),
	 
}

local prefabs =
{

}

local SCALE = 0.7

local function OnHammerer(inst)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end 

local function OverRides(inst)
	inst.AnimState:OverrideSymbol("bowl01", "change_fountain", "bowl01")
	inst.AnimState:OverrideSymbol("water01", "change_fountain", "water01")
end 

local function postinit_fn(inst)
	OverRides(inst)
end 

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    
    anim:SetBank("fountain")
	anim:SetBuild("python_fountain")    
    anim:PlayAnimation("flow_loop", true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/fountain_LP", "burble")
    
    MakeObstaclePhysics(inst, 1.5)
	
	inst.Transform:SetScale(SCALE,SCALE,SCALE)

    --local minimap = inst.entity:AddMiniMapEntity()
    --minimap:SetIcon("pig_ruins_well.png")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    --inst.components.inspectable:RecordViews()
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(OnHammerer)
    inst.components.workable:SetWorkLeft(4)
	
	OverRides(inst)

    return inst
end

return Prefab("change_fountain", fn, assets, prefabs),
MakePlacer( "change_fountain_placer", "fountain", "python_fountain", "flow_loop",nil,nil,nil,SCALE,nil,nil,postinit_fn) 


