
local FRIEND_PICKUP = AddAction("FRIEND_PICKUP", "pick", function(act)
    if act.doer~=nil and act.doer.prefab=="nanashi_mumei_friend" and act.target~=nil and not act.target:HasTag("INLIMBO")  then
        if act.target.components.pickable and act.target.components.pickable.product and act.target.components.pickable:CanBePicked() then
            act.target.components.pickable:Pick(act.doer)
            local berry = GLOBAL.SpawnPrefab(act.target.components.pickable.product)
            if berry.components.stackable then
                berry.components.stackable:SetStackSize(act.target.components.pickable.numtoharvest)
            end
            act.doer.components.container:GiveItem(berry, nil, act.target:GetPosition())
        elseif not act.target.components.pickable then
            act.doer.components.container:GiveItem(act.target, nil, act.target:GetPosition())
        end
        return true
    end
end)

AddComponentAction("SCENE", "pickable", function(inst, doer, actions, right)
    if doer~=nil  and doer.prefab=="nanashi_mumei_friend" and inst~=nil and not inst:HasTag("INLIMBO") then
        FRIEND_PICKUP.priority = 1
        table.insert(actions, FRIEND_PICKUP)
	end
end)
AddStategraphActionHandler("nanashi_mumei_friend", GLOBAL.ActionHandler(FRIEND_PICKUP, "action"))