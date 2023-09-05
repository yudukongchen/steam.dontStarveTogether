local assets =
{
    Asset("ANIM", "anim/taiyangta.zip"),
	Asset("IMAGE", "images/inventoryimages/taiyangta.tex"),
	Asset("ATLAS", "images/inventoryimages/taiyangta.xml"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()
	inst.Light:SetRadius(10)
	inst.Light:SetFalloff(0.85)
	inst.Light:SetIntensity(.85)
	inst.Light:SetColour(255/255, 255/255, 255/255)
	inst.Light:Enable(true)
	
	MakeObstaclePhysics(inst, 1.5)
	
	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon( "taiyangta.tex" )

    inst.AnimState:SetBank("taiyangta")
    inst.AnimState:SetBuild("taiyangta")
    inst.AnimState:PlayAnimation("idle",true)
	
	inst:AddTag("structure")
	inst:AddTag("wall")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
    
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("heater")
    inst.components.heater.heat = 115
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(2000) 
    inst.components.health:StartRegen(50, 1)
	
	inst:DoPeriodicTask(3, function()
	local pos = Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 15)
    for k,v in pairs(ents) do
        if not v:HasTag("player") and v.components.health and not v:HasTag("wall") and not v:HasTag("chester") and not v:HasTag("abigail") and not v:HasTag("glommer") and not v:HasTag("hutch") and not v:HasTag("boat") then
		v.components.health:DoDelta(-50)
        end
		end
	end)		
	inst:ListenForEvent("death", function()
        SpawnPrefab("dragon_scales").Transform:SetPosition(inst.Transform:GetWorldPosition())
		SpawnPrefab("deerclops_eyeball").Transform:SetPosition(inst.Transform:GetWorldPosition())	
    end )
	
	inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(50)
    inst.components.combat.playerdamagepercent = 0
	
    return inst
end

return Prefab("taiyangta", fn, assets),
       MakePlacer("taiyangta_placer", "taiyangta", "taiyangta", "idle")

