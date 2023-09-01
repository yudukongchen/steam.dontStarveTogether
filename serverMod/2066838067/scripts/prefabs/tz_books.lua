
local prefabs =
{
    "tz_tentacle",
    "splash_ocean",
}

local book_defs =
{
    {
        name = "tz_kjbook",  --在恐惧上
		build = "tz_books",
		bank = "tz_books",
		idle = "tz_kjbook",
        uses = 5,
        fn = function(inst, reader)
            local pt = reader:GetPosition()
            local numtentacles = 3
			local renshu = TheSim:FindEntities(pt.x, 0, pt.z, 16, nil, { "INLIMBO", "FX", "playerghost" },{"player","tz_image"})
			if #renshu < 1 then return false end
			for i, v in ipairs(renshu) do
				if v and v.components.sanity then
					v.components.sanity:DoDelta(-50/#renshu)
				end
			end
			if inst.components.finiteuses then	
				inst.components.finiteuses:Use(1)
			end
            reader:StartThread(function()
                for k = 1, numtentacles do
                    local theta = math.random() * 2 * PI
                    local radius = math.random(4, 8)
                    local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
                        local pos = pt + offset
                        return #TheSim:FindEntities(pos.x, 0, pos.z, 1, nil, { "INLIMBO", "FX" }) <= 0
                            and TheWorld.Map:IsDeployPointClear(pos, nil, 1)
                    end)
                    if result_offset ~= nil then
                        local x, z = pt.x + result_offset.x, pt.z + result_offset.z
                        local tentacle = SpawnPrefab("tz_tentacle")
                        tentacle.Transform:SetPosition(x, 0, z)
                        tentacle.sg:GoToState("attack_pre")
                        SpawnPrefab("splash_ocean").Transform:SetPosition(x, 0, z)
                        ShakeAllCameras(CAMERASHAKE.FULL, .2, .02, .25, reader, 40)
                    end
                    Sleep(.33)
                end
            end)
            return true
        end,
    },
    {
        name = "tz_deathbook",
		build = "tz_deathbook",
		bank = "tz_deathbook",
		idle = "idle",
        uses = 2,
        fn = function(inst, reader)
            if not reader.components.tzpetshadow then
                return false
            end
            local pt = reader:GetPosition()
			if reader.components.sanity then
				reader.components.sanity:DoDelta(-100)
			end
			if reader.components.tzsama then
				reader.components.tzsama:AddsamaModifier_Additive("TZ_DEATHBOOK", 12, 2400)
			end
			if reader.components.leader then
				for k,v in pairs(reader.components.leader.followers) do
					if k and  k:IsValid()  and k:HasTag("tzlostday") and not k._qianghua == true then
						if k.sg then
							k.sg:GoToState("jiasi",reader)
						end
                    --change 2019-05-16
					elseif k and  k:IsValid()  and k:HasTag("tzxiaoyingguai") and k.components.health.maxhealth < 260 then
                        
                        k:DoTaskInTime(0.2,function(inst) 
                        local x, y, z = inst.Transform:GetWorldPosition()
                        local mini = (inst.prefab == "tz_nightmare2" ) and "tz_creature2" or "tz_creature1"
                        inst:Remove()  
                        SpawnPrefab("shadow_despawn").Transform:SetPosition(x, y, z)
                        SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
                        local new = reader.components.tzpetshadow:SpawnPetAt(x, y, z, mini)
                        if new then new.Transform:SetScale(0.54,0.54,0.54) else print (mini) end
                        end)

                    elseif k and  k:IsValid()  and k:HasTag("tz_ml_pet") and k.components.health.maxhealth < 260 and reader.components.fh_ml_pet then
                        k:DoTaskInTime(0.2,function(inst) 
                            local x, y, z = inst.Transform:GetWorldPosition()
                            local mini = (inst.prefab == "tz_nightmare3" ) and "tz_creature3" or nil
                            inst:Remove()  
                            if mini then
                                SpawnPrefab("shadow_despawn").Transform:SetPosition(x, y, z)
                                SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
                                local new = reader.components.fh_ml_pet:SpawnPetAt(x, y, z, mini)
                                if new then 
                                    new.Transform:SetScale(0.54,0.54,0.54) 
                                else
                                end
                            end    
                        end)                      
                    end
                    --change
                    -----------------------------------------------------------------------------------
					if k and k:HasTag("nuyi") then
						k["tz_xin_sjz"](1)
					end
				end
			end
			if inst.components.finiteuses then	
				inst.components.finiteuses:Use(1)
			end
            return true
        end,
    },
}

local function MakeBook(def)
	local assets =
	{
		Asset("ANIM", "anim/tz_books.zip"),
		Asset("ANIM", "anim/tz_deathbook.zip"),
		Asset("ATLAS", "images/inventoryimages/"..def.name..".xml"),
	}
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(def.bank)
        inst.AnimState:SetBuild(def.build)
        inst.AnimState:PlayAnimation(def.idle,true)
		--inst.AnimState:SetMultColour(1,1,1,0.5)

        inst.entity:SetPristine()
        MakeInventoryFloatable(inst, "med", 0.2, {1.1, 0.5, 1.1})
        if not TheWorld.ismastersim then
            return inst
        end
        -----------------------------------

        inst:AddComponent("inspectable")
        inst:AddComponent("tzbook")
        inst.components.tzbook.onread = def.fn

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..def.name..".xml"

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(def.uses)
        inst.components.finiteuses:SetUses(def.uses)
        inst.components.finiteuses:SetOnFinished(inst.Remove)

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL

        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(def.name, fn, assets, prefabs)
end

local books = {}
for i, v in ipairs(book_defs) do
    table.insert(books, MakeBook(v))
end
book_defs = nil
return unpack(books)
