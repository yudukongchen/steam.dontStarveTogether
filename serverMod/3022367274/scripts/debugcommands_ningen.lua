--绝交指令
function ningen_resetfriend(uid)
    for k, v in ipairs(AllPlayers) do
        if uid == v.userid then
            if v:HasTag('ningen') and v.components.killerwhalefriend.follower ~= nil then
                v.components.killerwhalefriend:breakoff(v.components.killerwhalefriend.follower)
            end
        end
    end
end
