local assets =
{
    Asset("ANIM", "anim/freezeocean.zip"),
}

local function recfgphysics(inst,iswinter)  
    local phys=inst.Physics or inst.entity:AddPhysics()
    if iswinter then
        phys:ClearCollisionMask()                                               
        phys:CollidesWith((TheWorld.has_ocean and COLLISION.GROUND) or COLLISION.WORLD)
        phys:CollidesWith(COLLISION.OBSTACLES)
        phys:CollidesWith(COLLISION.SMALLOBSTACLES)
        phys:CollidesWith(COLLISION.CHARACTERS)
        phys:CollidesWith(COLLISION.GIANTS)
    else
        phys:ClearCollisionMask()
        phys:CollidesWith(COLLISION.WORLD)
        phys:CollidesWith(COLLISION.OBSTACLES)
        phys:CollidesWith(COLLISION.SMALLOBSTACLES)
        phys:CollidesWith(COLLISION.CHARACTERS)
        phys:CollidesWith(COLLISION.GIANTS)
    end
end

local function setplayeronBuff(inst)
    inst.playersonBuff={}
    local x,y,z=inst.Transform:GetWorldPosition()
    for i,v in ipairs(AllPlayers) do
        if v.components.health then
        if not (v:HasTag("diting") or v.components.health:IsDead() or v:HasTag("playerghost")) then
            if v:GetDistanceSqToPoint(x,y,z) < 6 then
                v.seawalkBufflevel=(v.seawalkBufflevel or 0) + 1    --修正Buff层数
                table.insert(inst.playersonBuff,v)          --加入队伍，周期距离判断出队
                recfgphysics(v,true)                        --虽然有点浪费，反复改套件。。。但是方便啊  --就这样吧，弃船BUG也是这里出现的，周期性可以改回来。
                if v.components.drownable.enabled ~= false then
                    v.components.drownable.enabled = false
                end
            end
        end
       end
    end
end

local function checkplayersonBuff(inst)
    local x,y,z=inst.Transform:GetWorldPosition()   
    inst.clearLine={}
    for i,v in ipairs(inst.playersonBuff) do
        if v.components.health then
            if not (v:HasTag("diting") or v.components.health:IsDead() or v:HasTag("playerghost")) then   --个体依旧有效吧。。。emm
                v.seawalkBufflevel=(v.seawalkBufflevel or 1)-1 --队列中的player一定有这个吗？ 啊，此处全员减一。。。下面全员加一。。。还在船上的就相当于不变了。。。
                if v:GetDistanceSqToPoint(x,y,z)>6 then --反过来。。。出圈了这和y无关的。。。
                    table.insert(inst.clearLine,v)   --有可能会移除seawalk的玩家们                     而新来的。。。无论如何都一定是从set开始的，即有1
                end
            end
        end
    end
end

local function dealclearLine(inst)
    for i,v in ipairs(inst.clearLine) do --clearLine中，是曾经在船上的后来不在船上的家伙。。。
        if not v.seawalkBufflevel or v.seawalkBufflevel==0 then   --检测这些下台的家伙是不是该处理掉了
            v.components.talker:Say("我要掉下去了！")  --有BUG再微调
            if v.components.drownable.enabled == false then
                v.components.drownable.enabled = true
            end
            recfgphysics(v,false)
            v.seawalkBufflevel=nil     --感觉上应该保留这家伙
        end
    end
end

local function MyOnAnimOver(inst)
    if inst.AnimState:IsCurrentAnimation("over_"..tostring(inst.variation)) then
        --物品销毁前。。。也处理一波。。。
        local x,y,z=inst.Transform:GetWorldPosition()
        for i,v in ipairs(AllPlayers) do
            if v.components.health then
                if not (v:HasTag("diting") or v.components.health:IsDead() or v:HasTag("playerghost")) then
                    if v:GetDistanceSqToPoint(x,y,z) < 6 then
                        v.seawalkBufflevel=(v.seawalkBufflevel or 1)-1
                        if v:GetDistanceSqToPoint(x,y,z) < 4 then
                            v.components.talker:Say("冰快要融化了！")
                        end
                        if v.seawalkBufflevel==0 then
                            recfgphysics(v,false)
                            if v.components.drownable.enabled == false then
                                v.components.drownable.enabled = true
                            end
                        end
                     end
                 end
            end
        end
        inst:Remove()
    else
        local x, y, z = inst.Transform:GetWorldPosition() --是当前物体的坐标？
        for i, v in ipairs(AllPlayers) do
            if v:HasTag("diting") and v.seatask and
                not (v.components.health:IsDead() or v:HasTag("playerghost")) and
                v.entity:IsVisible() and
                v:GetDistanceSqToPoint(x, y, z) < 4 then 
                inst.AnimState:PlayAnimation("idle_"..tostring(inst.variation))
                return
            end
        end
        inst:DoTaskInTime(5,function(inst) 
            inst.AnimState:PlayAnimation("over_"..tostring(inst.variation))
               end)
    end
end

local function SetVariation(inst, variation)
      if inst.variation ~= variation then
         inst.variation = variation
         inst.AnimState:PlayAnimation("start_"..tostring(variation))
            if math.random(0,100) < 40 then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/fx/ice_circle_LP" ,"loop")
                inst:DoTaskInTime(1,function(inst) 
                inst.SoundEmitter:KillSound("loop")
                    end)
            end
      end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("freezeocean")
	 
    inst.AnimState:SetBuild("freezeocean")
    inst.AnimState:SetBank("freezeocean")
    inst.AnimState:PlayAnimation("start_1")

    inst.entity:AddSoundEmitter()

    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)

    inst.entity:SetPristine()

    inst.playersonBuff={}
    inst.clearLine={}

    setplayeronBuff(inst)   --players on Buff 预载     --是不是应该写在主机那里。
    inst:DoPeriodicTask(0.5,function()   --！！！
        --先处理队列中的人物              --很好写，销毁处也有emm好不安。。。测试一波
        checkplayersonBuff(inst)
        --处理了队列，再加载一波。。。出队了的家伙不会进来的。。。啊。。。这里得确保不会反复加bufflevel啊。。。
        setplayeronBuff(inst)
        --处理可能要移除seawalk的玩家
        dealclearLine(inst)
    end)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.variation = 1
    inst.SetVariation = SetVariation
    inst:ListenForEvent("animover", MyOnAnimOver)
    inst.persists = false

    return inst
end

return Prefab("freezeocean", fn, assets)