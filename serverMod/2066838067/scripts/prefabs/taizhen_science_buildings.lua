require "prefabutil"
local TechTree = require("techtree")
local SCALE = 1

local function Default_PlayAnimation(inst, anim, loop)
    inst.AnimState:PlayAnimation(anim, loop)
end

local function Default_PushAnimation(inst, anim, loop)
    inst.AnimState:PushAnimation(anim, loop)
end

local function isgifting(inst)
    for k, v in pairs(inst.components.prototyper.doers) do
        if k.components.giftreceiver ~= nil and
            k.components.giftreceiver:HasGift() and
            k.components.giftreceiver.giftmachine == inst then
            return true
        end
    end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst)
    if not inst:HasTag("burnt") then	
        inst:_PlayAnimation("pohuai")
        if inst.components.prototyper.on then
            inst:_PushAnimation(isgifting(inst) and "zhizuo" or "piaofu_baochi", true)
        else
            inst:_PushAnimation("zhanli", false)
        end
    end
end

local function doonact(inst, soundprefix)
    if inst._activecount > 1 then
        inst._activecount = inst._activecount - 1
    else
        inst._activecount = 0
        inst.SoundEmitter:KillSound("sound")
    end
   -- inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_ding")
end

local function onturnoff(inst)
    if inst._activetask == nil and not inst:HasTag("burnt") then
        inst:_PushAnimation("piaofu_jieshu", false)
        inst.SoundEmitter:KillSound("idlesound")
        inst.SoundEmitter:KillSound("loop")
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

--local function createmachine(level, name, soundprefix, techtree, giftsound,scale)
local function createmachine(level, name, soundprefix,giftsound,scale)
	scale = scale or 1
    local assets =
    {
        Asset("ANIM", "anim/taizhen_researchlab.zip"),
		Asset("SOUND", "sound/TZ_MOD.fsb"),--fsb
	    Asset("SOUNDPACKAGE", "sound/TZ_MOD.fev"),--fev
		Asset("IMAGE","images/inventoryimages/change_researchlab2.tex"),
		Asset("ATLAS","images/inventoryimages/change_researchlab2.xml"),
    }

    local prefabs =
    {
        "collapse_small",
    }

    local function onturnon(inst)
        if inst._activetask == nil and not inst:HasTag("burnt") then
            if isgifting(inst) then			
                if inst.AnimState:IsCurrentAnimation("piaofu_baochi") or
                    inst.AnimState:IsCurrentAnimation("zhizuo") then
                    --NOTE: push again even if already playing, in case an idle was also pushed
				
                    inst:_PushAnimation("piaofu_baochi", true)
                else
				    inst:_PlayAnimation("piaofu_zhunbei")
                    inst:_PushAnimation("piaofu_baochi", true)
                end
				
                if not inst.SoundEmitter:PlayingSound("loop") then				   
                    inst.SoundEmitter:KillSound("idlesound")
                   -- inst.SoundEmitter:PlaySound("dontstarve/common/research_machine_gift_active_LP", "loop")
                end
            else
                if inst.AnimState:IsCurrentAnimation("piaofu_baochi") or
                    inst.AnimState:IsCurrentAnimation("zhizuo") then
                    --NOTE: push again even if already playing, in case an idle was also pushed
                    inst:_PushAnimation("piaofu_baochi", true)
                else
                    inst:_PlayAnimation("piaofu_zhunbei")
                    inst:_PushAnimation("piaofu_baochi", true)
                end
                if not inst.SoundEmitter:PlayingSound("idlesound") then
                    inst.SoundEmitter:KillSound("loop")
                   -- inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_idle_LP", "idlesound")
                end
            end
        end
    end

    local function refreshonstate(inst)
        --V2C: if "burnt" tag, prototyper cmp should've been removed *see standardcomponents*
        if not inst:HasTag("burnt") and inst.components.prototyper.on then
            onturnon(inst)
        end
    end

    local function doneact(inst)
        inst._activetask = nil
        if not inst:HasTag("burnt") then
            if inst.components.prototyper.on then
                onturnon(inst)
            else
                onturnoff(inst)
            end
        end
    end


    local function onactivate(inst)
        if not inst:HasTag("burnt") then		 
		 inst:_PlayAnimation("zhizuo")
         inst:_PushAnimation("zhanli", false)
            if not inst.SoundEmitter:PlaySound("TZ_MOD/TZKJ/zhizuo") then
                inst.SoundEmitter:PlaySound("TZ_MOD/TZKJ/zhizuo")
            end
            inst._activecount = inst._activecount + 1
            inst:DoTaskInTime(1.5, doonact, soundprefix)
            if inst._activetask ~= nil then
                inst._activetask:Cancel()
            end
            inst._activetask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + 2 * FRAMES, doneact)
        end
    end

    local function ongiftopened(inst)
        if not inst:HasTag("burnt") then
            inst:_PlayAnimation("zhizuo")
            inst:_PushAnimation("zhanli", false)
            inst.SoundEmitter:PlaySound("TZ_MOD/TZKJ/zhizuo")
            if inst._activetask ~= nil then
                inst._activetask:Cancel()
            end
            inst._activetask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + 2 * FRAMES, doneact)
        end
    end
--建造
    local function onbuilt(inst, data)
        inst:_PlayAnimation("fangzhi")
		inst.SoundEmitter:PlaySound("TZ_MOD/TZKJ/jianzao")
		inst:_PushAnimation("set")
		inst:_PlayAnimation("zhizuo")
        inst:_PushAnimation("zhanli", false)	
        --inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_"..soundprefix.."_place")
        
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        --inst.MiniMapEntity:SetIcon("change_researchlab2.png")
        MakeObstaclePhysics(inst, .4)

        inst.MiniMapEntity:SetIcon("change_researchlab2.tex")
		
        inst.AnimState:SetBank("taizhen_researchlab")
        inst.AnimState:SetBuild("taizhen_researchlab")
        inst.AnimState:PlayAnimation(name,true)
		
		inst.Transform:SetScale(scale,scale,scale)

        inst:AddTag("giftmachine")
        inst:AddTag("structure")
		inst:AddTag("taipanduanjuli")
        inst:AddTag("level"..level)

        --prototyper (from prototyper component) added to pristine state for optimization
        inst:AddTag("prototyper")

        MakeSnowCoveredPristine(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst._activecount = 0
        inst._activetask = nil

        inst:AddComponent("inspectable")--可被检查组建
		
        inst:AddComponent("prototyper")--科技台
        inst.components.prototyper.onturnon = onturnon--靠近的科技时候
        inst.components.prototyper.onturnoff = onturnoff--远离科技的时候
        --inst.components.prototyper.trees = techtree--科技树
        inst.components.prototyper.onactivate = onactivate--制作物品的时候
		inst.components.prototyper.trees = TechTree.Create({
                SCIENCE = 5,
                MAGIC = 5,
            })

        inst:AddComponent("wardrobe")
        inst.components.wardrobe:SetCanUseAction(false) --also means NO wardrobe tag!
        inst.components.wardrobe:SetCanBeShared(true)
        inst.components.wardrobe:SetRange(TUNING.RESEARCH_MACHINE_DIST + .1)

        inst:ListenForEvent("onbuilt", onbuilt)

        inst:AddComponent("lootdropper")
		--建筑
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)--工作的动作
        inst.components.workable:SetWorkLeft(4)--能锤几次
        inst.components.workable:SetOnFinishCallback(onhammered)--锤烂了怎么样
        inst.components.workable:SetOnWorkCallback(onhit)--被锤了怎么样
        MakeSnowCovered(inst)

       -- inst.components.builder.EvaluateTechTrees(evaluateTechTrees)
        --MakeLargeBurnable(inst, nil, nil, true)
        MakeLargePropagator(inst)

        inst.OnSave = onsave
        inst.OnLoad = onload

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        inst:ListenForEvent("ms_addgiftreceiver", refreshonstate)
        inst:ListenForEvent("ms_removegiftreceiver", refreshonstate)
        inst:ListenForEvent("ms_giftopened", ongiftopened)

        inst._PlayAnimation = Default_PlayAnimation
        inst._PushAnimation = Default_PushAnimation

        return inst
    end
    return Prefab(name, fn, assets, prefabs)
end

--Using old prefab names
return 
	createmachine(2, "zhanli", "lvl2","alchemy",SCALE),
    MakePlacer("zhanli_placer", "taizhen_researchlab", "taizhen_researchlab", "zhanli",nil,nil,nil,SCALE)
	-- TUNING.PROTOTYPER_TREES.ALCHEMYMACHINE      科技二本
	-- TUNING.PROTOTYPER_TREES.SHADOWMANIPULATOR   魔法二本
	
