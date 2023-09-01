local characteristics={
    --正面
    {
        {
            name =  STRINGS.KILLER_WHALEC.XUNJIE,
            func = function (inst)
                inst.components.locomotor:SetExternalSpeedMultiplier(inst, "killer_whale_xunjie", 1.2)
            end,
            conflict = {STRINGS.KILLER_WHALEC.CANQI},
            per = .5,
        },
        {
            name = STRINGS.KILLER_WHALEC.QIANGZHUANG,
            func = function (inst)
                local health = inst.components.health.maxhealth
                local atk = inst.components.combat.defaultdamage
                inst.components.combat:SetDefaultDamage(atk * 1.2)
                inst.components.health:SetMaxHealth(health * 1.2)
            end,
            conflict = {STRINGS.KILLER_WHALEC.TIRUO,STRINGS.KILLER_WHALEC.LINGHUO},
        },
        {
            name = STRINGS.KILLER_WHALEC.KEAI,
            func = function (inst)
                inst:AddComponent("sanityaura")
                inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL
            end,
            conflict = {STRINGS.KILLER_WHALEC.BAOZAO,STRINGS.KILLER_WHALEC.XIEE}
        },
        {
            name = STRINGS.KILLER_WHALEC.JIANREN,
            func = function (inst)
                inst.components.combat.externaldamagetakenmultipliers:SetModifier("kc", .7,"killer_whale_jianren")
            end,
            conflict = {STRINGS.KILLER_WHALEC.CUIRUO}
        },
        {
            name = STRINGS.KILLER_WHALEC.LINGHUO,
            func = function (inst)
                local Old_GA = inst.components.combat.GetAttacked
                local function New_GA(self, attacker, damage, weapon, stimuli)
                    if math.random() <.25 then
                        return true
                    end
                    return Old_GA(self, attacker, damage, weapon, stimuli)
                end
                inst.components.combat.GetAttacked = New_GA
            end,
            conflict = {STRINGS.KILLER_WHALEC.CANQI,STRINGS.KILLER_WHALEC.TIRUO,STRINGS.KILLER_WHALEC.QIANGZHUANG}
        },
        {
            name = STRINGS.KILLER_WHALEC.BUQU,
            func = function (inst)
                local function OnHealthDelta(inst, data)
                    if data.newpercent == nil then
                        return
                    end
                    inst.components.combat.externaldamagemultipliers:SetModifier("kc", 2.0-data.newpercent,"killer_whale_buqu")
                end
                inst:ListenForEvent("healthdelta", OnHealthDelta)
            end,
        }
    },
    --有利有弊
    {
        {
            name = STRINGS.KILLER_WHALEC.TANCHI,
            tags = {"killer_whale_tanchi"},
            func = function (inst)
                inst.components.hunger.burnratemodifiers:SetModifier("kc", 1.75,"killer_whale_tanchi")
                local function Oneat(inst, food)
                    if food.components.edible.hungervalue then
                        inst.components.health:DoDelta(math.abs(food.components.edible.hungervalue) * 2)
                    end
                end
                inst.components.eater:SetOnEatFn(Oneat)
            end
        },
        {
            name = STRINGS.KILLER_WHALEC.SHIMIAN,
            func = function (inst)
                inst:RemoveComponent("sleeper")
            end,
            conflict = {STRINGS.KILLER_WHALEC.SHISHUI}
        },
        {
            name = STRINGS.KILLER_WHALEC.SHISHUI,
            tags = {"killer_whale_shishui"},
            func = function (inst)
                local function Oneat(inst, food)
                    if inst.components.sleeper then
                        inst.components.sleeper:GoToSleep(5)
                    end
                end
                inst.components.eater:SetOnEatFn(Oneat)
                inst.components.hunger.burnratemodifiers:SetModifier("kc", .5,"killer_whale_shishui")
            end,
            conflict = {STRINGS.KILLER_WHALEC.SHIMIAN}
        },
        {
            name = STRINGS.KILLER_WHALEC.TIAOPI,
            tags = {"killer_whale_naughty"},
            func = function (inst)
                inst.components.locomotor:SetExternalSpeedMultiplier(inst, "killer_whale_tiaopi", 1.05)
            end,
        },
        {
            name = STRINGS.KILLER_WHALEC.LAOSHI,
            func = function (inst)
                local function Retarget(inst)
                    return nil
                end
                inst.components.combat:SetRetargetFunction(1, Retarget)
            end,
            conflict = {STRINGS.KILLER_WHALEC.BAOZAO}
        },
    },
    --负面
    {
        {
            name =  STRINGS.KILLER_WHALEC.CANQI,
            func = function (inst)
                inst.components.locomotor:SetExternalSpeedMultiplier(inst, "killer_whale_canji", .7)
            end,
            conflict = {STRINGS.KILLER_WHALEC.XUNJIE,STRINGS.KILLER_WHALEC.LINGHUO}
        },
        {
            name = STRINGS.KILLER_WHALEC.DANXIAO,
            tags = {"killer_whale_danxiao"},
            func = function (inst)
                inst.components.combat.externaldamagemultipliers:SetModifier("kc", .75,"DANXIAO")
            end,
        },
        {
            name = STRINGS.KILLER_WHALEC.TIRUO,
            func = function (inst)
                local health = inst.components.health.maxhealth
                local atk = inst.components.combat.defaultdamage
                inst.components.combat:SetDefaultDamage(atk * .7)
                inst.components.health:SetMaxHealth(health * .7)
                inst.components.health:StartRegen(TUNING.BEEFALO_HEALTH_REGEN  * inst.Transform:GetScale(), TUNING.BEEFALO_HEALTH_REGEN_PERIOD)
            end,
            conflict = {STRINGS.KILLER_WHALEC.QIANGZHUANG,STRINGS.KILLER_WHALEC.LINGHUO}
        },
        {
            name = STRINGS.KILLER_WHALEC.BAOZAO,
            func = function (inst)
                local function Retarget(inst)
                    return FindEntity(
                                inst,
                                15,
                                function(guy)
                                    local x,y,z = guy.Transform:GetWorldPosition()
                                    if not guy:HasTag("killer_whale") and not inst.components.timer:TimerExists("calmtime") and not TheWorld.Map:IsVisualGroundAtPoint(x,y,z) 
                                    and not guy:HasTag("player") and not guy:HasTag("wall") then
                                        return inst.components.combat:CanTarget(guy)
                                    end
                                end
                            )
                        or nil
                end
                inst.components.combat:SetRetargetFunction(1, Retarget)
            end,
            conflict = {STRINGS.KILLER_WHALEC.KEAI,STRINGS.KILLER_WHALEC.LAOSHI}
        },
        {
            name = STRINGS.KILLER_WHALEC.XIEE,
            func = function (inst)
                inst:AddComponent("sanityaura")
                inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL * 2
            end,
            conflict = {STRINGS.KILLER_WHALEC.KEAI}
        },
        {
            name = STRINGS.KILLER_WHALEC.CUIRUO,
            func = function (inst)
                inst.components.combat.externaldamagetakenmultipliers:SetModifier("kc", 1.3,"killer_whale_cuiruo")
            end,
            conflict = {STRINGS.KILLER_WHALEC.JIANREN}
        },
    }
}
local num_c = {#characteristics[1],#characteristics[2],#characteristics[3]}
local base_per = {0.4,0.4,0.4}

--特殊
local special ={
    {
        name = STRINGS.KILLER_WHALEC.TOULING,
        type = 1,
        tags = {"killer_whale_leader"},
        func = function(inst)
            local function LeaderOnDeath(self)
                for k, v in pairs(self.followers) do
                    if not (k.components.follower ~= nil and k.components.follower.keepdeadleader) then
                        self:RemoveFollower(k)
                        if k:HasTag("killer_whale") then
                            k.leave_event = k:DoPeriodicTask(1.0,function()
                                if not k.components.health:IsDead() and not k.sg:HasStateTag("busy") then
                                    k.leave_event:Cancel()
                                    k.sg:GoToState("leave")
                                end
                            end)
                        end
                    end
                end
            end

            inst.components.leader.RemoveAllFollowersOnDeath = LeaderOnDeath
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "killer_whale_leader", 1.05)
            local health = inst.components.health.maxhealth
            local atk = inst.components.combat.defaultdamage
            inst.components.combat:SetDefaultDamage(atk * 1.05)
            inst.components.health:SetMaxHealth(health * 1.05)
        end,
    },
}
local tot_c,tot_name_map = {},{}
local count = 0
for _,v in ipairs(characteristics) do
    for __,k in ipairs(v) do
        count = count + 1
        tot_c[count] = k
        tot_name_map[k.name] = count
    end
end
for _,v in ipairs(special) do
    count = count + 1
    tot_c[count] = v
    tot_name_map[v.name] = count
end


local Killer_whalecharacteristics = Class(function(self, inst)
    self.inst = inst
    self.characteristics = {}
    self.conflict = {}
    self.needspawncharacteristics = true

    self.inst:DoTaskInTime(0,function ()
        if self.needspawncharacteristics == true then
            self:SpawnCharacteristics()
        end
        self.inst.components.killer_whalecharacteristics:Refresh()
    end)
end,
nil,
{

})

function Killer_whalecharacteristics:OnSave()
    local data = {
        characteristics = self.characteristics,
        conflict = self.conflict,
        needspawncharacteristics = self.needspawncharacteristics
    }
    return data
end

function Killer_whalecharacteristics:OnLoad(data)
    self.characteristics = data.characteristics
    self.conflict = data.conflict
    self.needspawncharacteristics = data.needspawncharacteristics
end

function Killer_whalecharacteristics:Refresh()
    if self.inst.components.health and self.inst.components.health:IsDead() then
        return
    end
    local name = ""
    for _,k in pairs (self.characteristics) do
        local v = tot_c[k]
        if v.func then
            v.func(self.inst)
        end
        if v.tags then
            for _,q in pairs(v.tags) do
                self.inst:AddTag(q)
            end
        end
        if v.name == nil then
            assert(false,"v.name is nil")
        end
        name = name..v.name.." "
    end
    if self.inst.components.named then
        self.inst.components.named:SetName(name..STRINGS.NAMES.KILLER_WHALE)
    end
end

function Killer_whalecharacteristics:Add(name)
    if self.conflict[tot_name_map[name]] then
        return
    end
    print("Add "..name)
    if tot_c[tot_name_map[name]] then
        table.insert(self.characteristics,tot_name_map[name])
        if tot_c[tot_name_map[name]].conflict then
            for _,v in pairs (tot_c[tot_name_map[name]].conflict) do
                self.conflict[tot_name_map[v]] = true
            end
        end
        if self.inst.components.named then
            local now_name = self.inst.components.named.name or STRINGS.NAMES.KILLER_WHALE
            if tot_c[tot_name_map[name]].func then
                tot_c[tot_name_map[name]].func(self.inst)
            end
            if tot_c[tot_name_map[name]].tags then
                for _,q in pairs(tot_c[tot_name_map[name]].tags) do
                    self.inst:AddTag(q)
                end
            end
            if tot_c[tot_name_map[name]].name == nil then
                assert(false,"name is nil")
            end
            now_name = name.." "..now_name
            self.inst.components.named:SetName(now_name)
        end
        return
    end
end

function Killer_whalecharacteristics:SpawnCharacteristics()
    local order = {}
    for i=1,3,1 do
        order[i] = i
    end
    local cnt = 3
    while cnt > 0 do
        local label = math.random(1,cnt)
        order[label],order[cnt] = order[cnt],order[label]
        cnt = cnt - 1
    end

    local tmp = {}
    local tmp_conflict = {}
    local res = {num_c[1],num_c[2],num_c[3]}
    local f = {{},{},{}}

    for i=1,3,1 do
        for j=1,res[i],1 do
            f[i][j] = j
        end
        f[i][res[i]+1] = 1
    end

    local function Findf(index,fa)
        if (fa==f[index][fa]) then
            return fa
        end
        local nowfa = Findf(index,f[index][fa])
        f[index][fa] = nowfa
        return nowfa
    end

    for i=1,3,1 do
        local index,max = order[i],2
        local base = base_per[index]
        while res[index] >0 and max > 0 and math.random() < base do
            local randi = math.random(1,num_c[index]);
            randi = Findf(index,randi)
            f[index][randi] = f[index][randi+1]
            res[index] = res[index] - 1

            table.insert(tmp,tot_name_map[characteristics[index][randi].name])
            tmp_conflict[tot_name_map[characteristics[index][randi].name]] = true
            -- print("加入特性:"..characteristics[index][randi].name)
            if characteristics[index][randi].conflict then
                for _,v in pairs (characteristics[index][randi].conflict) do
                    tmp_conflict[tot_name_map[v]] = true
                    local id,pos = tot_name_map[v],1
                    for __=1,3,1 do
                        if id > num_c[__] then
                            id = id - num_c[__]
                            pos = pos + 1
                        else
                            break
                        end
                    end
                    -- print(pos,id,characteristics[pos][id].name,"位置,id和名字")
                    if f[pos][id] == id then
                        f[pos][id] = f[pos][id+1]
                        res[pos] = res[pos] - 1
                    end
                end
            end
            max = max - 1
            base = base * base
        end
    end
    self.conflict = tmp_conflict
    self.characteristics = tmp
    self.needspawncharacteristics = false
end

return Killer_whalecharacteristics