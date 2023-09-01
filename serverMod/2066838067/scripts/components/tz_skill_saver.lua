
-- TzSkillSaver component should add to Taizhen

local TzSkillSaver = Class(function(self,inst)
    self.inst = inst 

    self.skill_data = {
        -- skill_name is defined by Hua-Hua
        -- slot is the skill equip slot in left-down UI
        -- skill_class is 1 or 2,means initiative or passive skill
        -- skill_index is skill num 
        -- Save skills like that:
        -- {"skill_name",(slot,skill_class,skill_index),(slot,skill_class,skill_index),(slot,skill_class,skill_index),....},
    }
end)

-- ThePlayer.components.tz_skill_saver:SaveCurrentSkill("mama") --保存当前的技能组 
--ThePlayer.components.tz_skill_saver:Transform_Skill("01")

-- ThePlayer.components.tz_skill_saver:LoadSkill("mama",true) --重载保存了的技能组 第二个参数死是否遗忘旧的

--那你干嘛不保存的时候也加一个 遗忘 和学习新的呢？


-- dumptable(ThePlayer.components.tz_skill_saver.skill_data)
function TzSkillSaver:SaveCurrentSkill(skill_name)
    local data = {skill_name}

    for slot,skill_index in pairs(self.inst.qmsktbl[1]) do
        table.insert(data,slot)
        table.insert(data,1)
        table.insert(data,skill_index)
    end

    for slot,skill_index in pairs(self.inst.qmsktbl[2]) do
        table.insert(data,slot)
        table.insert(data,2)
        table.insert(data,skill_index)
    end

    self:SaveSkill(unpack(data))
end

function TzSkillSaver:Transform_Skill(name) --变身切换技能
    self:SaveCurrentSkill(name)
    --for k = 9 ,12 do
    for k = 9 ,12 do
        self.inst:SetQMSk(k-8,k,false)
    end
end

function TzSkillSaver:Get_Skill(name)
    return self.skill_data[name]
end

function TzSkillSaver:SaveSkill(skill_name,...)
    local data = {skill_name,...}

    for k, v in pairs(self.skill_data) do
        if v[1] == skill_name then
            table.remove(self.skill_data, k)
            break 
        end
    end

    table.insert(self.skill_data,data)
end

function TzSkillSaver:LoadSkill(skill_name,remove_data)
    for k, v in pairs(self.skill_data) do
        if v[1] == skill_name then
            -- Set skill here 
            for i = 2,#v,3 do
                local slot,skill_class,skill_index = v[i],v[i+1],v[i+2]

                assert(slot ~= nil and skill_class ~= nil and skill_index ~= nil)

                self.inst:SetQMSk(slot,skill_index,skill_class == 2)
            end

            if remove_data == true or remove_data == nil then
                table.remove(self.skill_data, k)
            end
            break 
        end
    end
end

function TzSkillSaver:OnSave()
    return {
        skill_data = self.skill_data
    }
end

function TzSkillSaver:OnLoad(data)
    if data ~= nil then
        if data.skill_data ~= nil then
            self.skill_data = data.skill_data
        end
    end
    -- print("TzSkillSaver:OnLoad:")
    -- dumptable(self.skill_data)
end


return TzSkillSaver