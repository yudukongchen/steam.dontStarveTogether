local transmit = Class(function(self,inst)
    self.inst=inst
    self.inst:AddTag("transmit")

    --只是挂个名字。。。似乎也没必要写啥了。。。
    --不会撤销。。。析构函数就懒得写了。。。
end)

local function NearestPlayer(inst)--看你放的位置。。。送入diting的inst。。。能调用就成
    if #AllPlayers == 0 then return nil end
    local x,y,z=inst:GetPosition()
    local mindisq = nil
    local index = nil
    for i,v in ipairs(AllPlayers) do
        if v and v:HasTag("playerghost") then
           local pos = v:GetPosition()
            return pos
        end
        if v ~= inst then   --diting自己就不判了。。。
            local dissq = v:GetDistanceSqToPoint(x,y,z)
            if mindisq == nil or dissq < mindisq then
                mindisq = dissq
                index = i
            end
        end
    end
    if index and AllPlayers[index] then
        local pos = AllPlayers[index]:GetPosition()
        return pos
    end
    return nil
end
    
local function NearestFirepit(inst)
    if #ALLFIREPITS == 0 then return nil end
    local x,y,z=inst:GetPosition():Get()
    local mindisq = ALLFIREPITS[1]:GetDistanceSqToPoint(x,y,z)
    local index = 1
    for i,v in ipairs(ALLFIREPITS) do
        local dissq = v:GetDistanceSqToPoint(x,y,z)
        if dissq < mindisq then
            mindisq = dissq
            index = i
        end
    end
    if ALLFIREPITS[index] then
        local pos = ALLFIREPITS[index]:GetPosition()
        return pos
    end
    return nil
end

 --[[local function NearestFirepit(inst)
    for k,v in ipairs(ALLFIREPITS) do
        if v then
          local pos=Vector3()
          local pos = v:GetPosition()
         return pos
        end
    end
    return nil 
 end]]

 local function SetBlueFire(fx_fx,doer,v)
    if doer and doer._csplayer:value() == true then
        local   new_position = NearestPlayer(doer)
            if new_position == nil then
                return
            else fx_fx.Transform:SetPosition(new_position.x+2,new_position.y,new_position.z+2) 
              --  doer.components.talker:Say("调试")
                 v:DoTaskInTime(4.5,function(v) 
                    if v and v.components.inventoryitem ~= nil then
                        v.components.inventoryitem:DoDropPhysics(new_position.x+2,new_position.y+3,new_position.z+2, true, 1)  --用这个掉落代替直接传送。
                    end
                    end)
            end
    elseif doer and doer._csfirepit:value() == true then 
        local   new_position = NearestFirepit(doer)
            if new_position == nil then
              return
            else fx_fx.Transform:SetPosition(new_position.x+2,new_position.y,new_position.z+2)
               -- doer.components.talker:Say("调试2")
              v:DoTaskInTime(4.5,function(v) 
                if v and v.components.inventoryitem ~= nil then
                       v.components.inventoryitem:DoDropPhysics(new_position.x+2,new_position.y+3,new_position.z+2, true, 1)  --用这个掉落代替直接传送。
                end
                end)
            end
    end
end

function transmit:trans(inst,pos, doer)   --此为在点燃处产生火焰的判定。
    local ORANGE_PICKUP_MUST_TAGS = { "_inventoryitem" }  --暂用懒人护符
    local ORANGE_PICKUP_CANT_TAGS = { "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "fire", "minesprung", "mineactive","animal" } --禁止烧动物
    local ents=TheSim:FindEntities(pos.x,pos.y,pos.z, 2,  ORANGE_PICKUP_MUST_TAGS, ORANGE_PICKUP_CANT_TAGS)--emm，单元这个pos能这样用。。
    for _,v in ipairs(ents) do
        if v.components.inventoryitem ~= nil and
            v.components.inventoryitem.canbepickedup and
            v.components.inventoryitem.cangoincontainer then 
                 local ex, ey, ez = v.Transform:GetWorldPosition()--应该就是获取当前的位置。。。这里是指船的吗？
                local fx = SpawnPrefab("transmitfire") 
                     fx.Transform:SetPosition(ex, ey, ez)
                local fx_fx = SpawnPrefab("transmitbluefire")
                        fx_fx:DoTaskInTime(3,SetBlueFire,doer,v)
            end
    end
    if  doer and not doer:HasTag("playerghost") then
           if #ents~=0 then 
               doer.components.talker:Say("烧起来了！！")
               doer.cdtimetime = true
               doer:DoTaskInTime(10,function(doer) if doer then doer.cdtimetime = nil end end)
               if inst and inst.components.fueled then
                inst.components.fueled:DoDelta(-40, doer) --一根“火柴”大概能用两次
                if doer._showbuttom:value() == false then
                   doer._showbuttom:set(true)
                else
                    doer._showbuttom:set(false)
                end
               end
           elseif doer:HasTag("diting") then
               doer.components.talker:Say("就不能治好我的职业病吗？")
           else
               doer.components.talker:Say("我傻了。")   --修复
                    if doer._showbuttom:value() == true then
                       doer._showbuttom:set(false)
                    else
                       doer._showbuttom:set(true)
                     end
            end
    end
end

return transmit