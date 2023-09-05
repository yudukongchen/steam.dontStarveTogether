local modname = KnownModIndex:GetModActualName("新护甲")
local ARMOR_QH_BLOCK_VALUE = GetModConfigData("ARMOR_QH_BLOCK_VALUE", modname)
local assets =
{
    Asset("ANIM", "anim/yifu.zip"),  --对应在anim里面的文件 加载动画文件
	Asset("ATLAS", "images/inventoryimages/yifubn.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/yifubn.tex"),
}

local function OnBlocked(owner, data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner) --装备
	owner.AnimState:OverrideSymbol("swap_body", "armor_stone", "armor_my_folder")
						 --三个参数分别是替换的贴图是swap_body  使用的动画是yifu  第三个这个注意 这个swap_body是你的动画里装图片的文件夹的名字
   
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner)  --脱下
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_stone") --动画 --SP软件里面动画的总名字
    inst.AnimState:SetBuild("armor_stone") --smcl文件的名字
    inst.AnimState:PlayAnimation("anim")	--丢地上的动画 

    inst:AddTag("wood")

    inst.foleysound = "dontstarve/movement/foley/logarmour"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable") --可悲检查组件

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/yifubn.xml"  --加载物品栏贴图 mod物品必须有
    
	
	inst:AddComponent("fuel")--燃料 组件
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME) --燃烧有关
    MakeSmallPropagator(inst)

    inst:AddComponent("armor")--护甲组件
    inst.components.armor:InitCondition(1575,ARMOR_QH_BLOCK_VALUE) --耐久度和减伤（90%）
    inst.components.armor:AddWeakness("beaver", TUNING.BEAVER_WOOD_DAMAGE)

    inst:AddComponent("equippable") --装备组件
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY --装备的部位是身体
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    --inst.components.equippable.walkspeedmult = 1.25 --移速增加

    --inst:AddComponent("waterproofer")
    --inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL) --防雨

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)  --保暖

    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL  --精神 TUNING.DAPPERNESS_LARGE +6 TUNING.DAPPERNESS_SMALL +1.8 TUNING.DAPPERNESS_MED+3

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("yifubn", fn, assets) --生成这个预设物  代码为 yifu
