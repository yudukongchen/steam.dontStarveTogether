GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

local function CheckPlayer(inst)
	local Has_player = false

    local x, y, z = inst.Transform:GetWorldPosition()
    local exclude_tags = {'FX', 'INLIMBO', 'playerghost'}
    local ents = TheSim:FindEntities(x, y, z, 5, { 'player' }, exclude_tags) 
    for k, v in ipairs(ents) do
        if v and v ~= inst then
        	Has_player = true
        end    
    end
    return Has_player
end

local function ChangeHealth(inst)
	local player = nil
	local player_percent = nil
	local stu_percent = inst.components.health:GetPercent() or 1

    local x, y, z = inst.Transform:GetWorldPosition()
    local exclude_tags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost'}
    local ents = TheSim:FindEntities(x, y, z, 5, { 'player' }, exclude_tags) 
    for k, v in ipairs(ents) do
        if v and v ~= inst and (player_percent == nil or player_percent > v.components.health:GetPercent()) then
        	player = v
            player_percent = v.components.health:GetPercent()
        end    
    end

    if player and not player.components.health:IsDead() and stu_percent ~= nil then
        player.components.health:SetPercent(stu_percent)
    end

    if player_percent ~= nil and not inst.components.health:IsDead() then	
        inst.components.health:SetPercent(player_percent)        
    end 	
end

local function Skill1(inst)
	inst:Skill1(true)
	ChangeHealth(inst)	

    local time = inst.skill1_level == 0 and 25 or 30
    print(time)	
    inst.components.timer:StartTimer("Stu_Skill1", time) 
end

local function STU_Skill1(inst, cd)
    if inst:HasTag("stu") then 
    	if cd == true then
    		--print("cd中")
    		inst.components.talker:Say("技能cd中。")
            return
    	end	

        if inst.sg and not inst:HasTag("skill1_cd") and CheckPlayer(inst) == true then
            inst:AddTag("skill1_cd")
            --inst.sg:GoToState("castspell")

            Skill1(inst)
            inst.SoundEmitter:PlaySound("stu_sound/stu_sound/skill") 

        elseif CheckPlayer(inst) == false then
            inst.components.talker:Say("范围内没有其他玩家。")              
        end      
    end
end

local function Skill2(inst)
	--print("技能2")
	inst:Skill2(true)	
    inst.SoundEmitter:PlaySound("stu_sound/stu_sound/skill") 
    local time = inst.skill2_level == 0 and 20 or 30
    --print(time) 
    inst.components.timer:StartTimer("Stu_Skill2", time) 
end

local function STU_Skill2(inst, cd)
    if inst:HasTag("stu") then 
    	if cd == true then
    		--print("cd中")
    		inst.components.talker:Say("技能cd中。")
            return
    	end	

        if inst.sg and not inst:HasTag("skill2_cd") then
            inst:AddTag("skill2_cd")
            --inst.sg:GoToState("castspell")

            Skill2(inst) 
            inst.SoundEmitter:PlaySound("stu_sound/stu_sound/skill")            
        end      
    end
end

local function Skill3(inst)
	--print("技能3")
	inst:Skill3(true)
    inst.SoundEmitter:PlaySound("stu_sound/stu_sound/skill") 	
    inst.components.timer:StartTimer("Stu_Skill3", 30) 
end

local function STU_Skill3(inst, cd)
    if inst:HasTag("stu") then 
    	if cd == true then
    		--print("cd中")
    		inst.components.talker:Say("技能cd中。")
            return
    	end	

        if inst.sg and not inst:HasTag("skill3_cd") then
            inst:AddTag("skill3_cd")
            --inst.sg:GoToState("castspell")

            Skill3(inst)            
        end      
    end
end

AddModRPCHandler("STU_Skill1", "STU_Skill1", STU_Skill1)
AddModRPCHandler("STU_Skill2", "STU_Skill2", STU_Skill2)
AddModRPCHandler("STU_Skill3", "STU_Skill3", STU_Skill3)

local KEY1 = _G["KEY_"..GetModConfigData("KEY_Z")]
TheInput:AddKeyDownHandler(KEY1, function()                            
    local player = ThePlayer
    local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
    local IsHUDActive = screen and screen.name == "HUD"
    local in_1_cd = player and player:HasTag("skill1_cd") or false

    if player and player:HasTag("stu") and player.replica.inventory and player.replica.inventory:EquipHasTag("stu_chainsaw") 
    and not player:HasTag("playerghost") and IsHUDActive then
        SendModRPCToServer(MOD_RPC["STU_Skill1"]["STU_Skill1"], in_1_cd)
    end 
end)

local KEY2 = _G["KEY_"..GetModConfigData("KEY_X")]
TheInput:AddKeyDownHandler(KEY2, function()                            
    local player = ThePlayer
    local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
    local IsHUDActive = screen and screen.name == "HUD"
    local in_2_cd = player and player:HasTag("skill2_cd") or false

    if player and player:HasTag("stu") and player._sp_level:value() and player._sp_level:value() >= 1
    and player.replica.inventory and player.replica.inventory:EquipHasTag("stu_chainsaw") 
    and not player:HasTag("playerghost") and IsHUDActive then
        SendModRPCToServer(MOD_RPC["STU_Skill2"]["STU_Skill2"], in_2_cd) 
    end 
end)

local KEY3 = _G["KEY_"..GetModConfigData("KEY_C")]
TheInput:AddKeyDownHandler(KEY3, function()                            
    local player = ThePlayer
    local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
    local IsHUDActive = screen and screen.name == "HUD"
    local in_3_cd = player and player:HasTag("skill3_cd") or false

    if player and player:HasTag("stu") and player._sp_level:value() and player._sp_level:value() >= 2
    and player.replica.inventory and player.replica.inventory:EquipHasTag("stu_chainsaw") 
    and not player:HasTag("playerghost") and IsHUDActive then
        SendModRPCToServer(MOD_RPC["STU_Skill3"]["STU_Skill3"], in_3_cd)
    end 
end)

