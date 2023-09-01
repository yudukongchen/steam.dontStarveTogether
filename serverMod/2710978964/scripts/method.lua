local function spawnAtGround(name, x,y,z)
    if TheWorld.Map:IsPassableAtPoint(x, y, z) then
        local item = SpawnPrefab(name)
        if item then
            item.Transform:SetPosition(x, y, z)
            return item
        end
    end
end

-- 圆心x, 圆心y, 半径, 几等分, 对象表, 将要执行的方法
function circular(target,r,num,lsit,fn)
	if target == nil or lsit == nil or #lsit <= 0 then return end 
	local x,y,z = target.Transform:GetWorldPosition()
    for k=1,num do
        local angle = k * 2 * PI / num
        local item = spawnAtGround(lsit[math.random(#lsit)], r*math.cos(angle)+x, 0, r*math.sin(angle)+z)
        if item ~= nil and fn ~= nil and type(fn) == "function" then 
        	fn(item, target, k) 
        end
    end	
end