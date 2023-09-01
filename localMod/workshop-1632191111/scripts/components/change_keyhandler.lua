local function ignore( self )
	self.ignore_ = not self.ignore_
end

local function IsHUDScreen(inst) 
	local defaultscreen = false 
	if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name  and type(TheFrontEnd:GetActiveScreen().name) == "string"  and TheFrontEnd:GetActiveScreen().name == "HUD" then 
		defaultscreen = true 
	end 
	return defaultscreen and not inst:HasTag("time_stopped")
end  

local ChangeKeyHandler = Class(function(self, inst)
	self.inst = inst
	self.paused = false
	self.ignore_ = false
	self.ticktime = 0
	self.ignore_event = net_event(self.inst.GUID, "ignore")
	self.handler = TheInput:AddKeyHandler(function(key, down) self:OnRawKey(key, down) end )
	
	self.inst:ListenForEvent( "gamepaused", function(inst, paused) self.paused = paused end )
	self.inst:ListenForEvent( "ignore", function(inst)
		ignore( inst.components.change_keyhandler )
	end)
end)

local function check(my)
	local com = "否\n"
	local isdead = "否\n"
	local pghost = "否\n"
	local ghost = "否\n"
	if my.components.health ~= nil then 
		com = "是\n"
	end
	if my.components.health ~= nil and my.components.health:IsDead() then
		isdead = "是\n"
	end
	if my:HasTag("playerghost") then 
		pghost = "是\n"
	end
	if my:HasTag("ghost") then 
		ghost = "是\n"
	end
	local str = "人物:  "..my.prefab.."  玩家名字:  "..my.name.."\n是否有health组件:  "..com.."是否isdead():  "..isdead.."是否有playerghost标签:  "..pghost.."是否有ghost标签:  "..ghost
	print(str)
	return str
end 

function ChangeKeyHandler:StartIgnoring()
	self.ignore_event:push()
end

function ChangeKeyHandler:StopIgnoring()
	self.ignore_event:push()
end

function ChangeKeyHandler:SetTickTime(time)
	self.ticktime = time or self.ticktime or 0 
end 

function ChangeKeyHandler:OnRawKey(key, down)
	local player = ThePlayer
	if player ~= nil then
  		if (key and not down) and not self.paused and not self.ignore_ then
      			player:PushEvent("keyup", {inst = self.inst, player = player, key = key})
		elseif key and down and not self.paused and not self.ignore_ then
      			player:PushEvent("keydown", {inst = self.inst, player = player, key = key})
		end
  	end
end

function ChangeKeyHandler:RpcAndMaster(Rpc,clientfn)
	local x,y,z = ( TheInput:GetWorldPosition() or Vector3(0,0,0) ):Get()
	local entity = TheInput:GetWorldEntityUnderMouse()
	local Namespace = Rpc.Namespace
	local Action = Rpc.Action
	if clientfn then 
		clientfn(self.inst,x,y,z,entity)
	end 
	if TheWorld.ismastersim then
		local masterfn = MOD_RPC_HANDLERS[Namespace][MOD_RPC[Namespace][Action].id]
		masterfn(self.inst,x,y,z,entity)
	else
		SendModRPCToServer( MOD_RPC[Namespace][Action], x,y,z,entity)
	end
end 

function ChangeKeyHandler:StartTrackingWhileDown(Rpc,keepfn)
	--self:StopTrackingWhileDown()
	--print("ChangeKeyHandler:StartTracking")
	if not self.inst.ChangeKeyHandlerTickTask then 
		self.inst.ChangeKeyHandlerTickTask = self.inst:DoTaskInTime(self.ticktime,function()
			self:RpcAndMaster(Rpc,keepfn)
			self:StopTrackingWhileDown()
			self:StartTrackingWhileDown(Rpc,keepfn)
			--print("ChangeKeyHandler:Tracking")
		end )
	end 
	--[[self.inst.ChangeKeyHandlerTickTask = self.inst:DoPeriodicTask(self.ticktime,function()
		self:RpcAndMaster(Rpc)
		--self:StartTrackingWhileDown(Rpc)
		--print("ChangeKeyHandler:Tracking")
	end )--]]
end 

function ChangeKeyHandler:StopTrackingWhileDown(Rpc,outfn)
	if self.inst.ChangeKeyHandlerTickTask then 
		self.inst.ChangeKeyHandlerTickTask:Cancel()
	end 
	self.inst.ChangeKeyHandlerTickTask = nil 
	if Rpc then 
		self:RpcAndMaster(Rpc,outfn)
		--print("ChangeKeyHandler:StopTracking")
	end 
end 




function ChangeKeyHandler:AddActionListenerWhileDown(Key,EnterRpc,KeepRpc,OutRpc,TickTime,clientfns)
	self:SetTickTime(TickTime)
	local enterfn = clientfns and clientfns.enterfn or nil 
	local keepfn = clientfns and clientfns.keepfn or nil 
	local outfn = clientfns and clientfns.outfn or nil 
	self.inst:ListenForEvent("keydown", function(inst, data)
		if data.inst == ThePlayer then
			if data.key == Key then
					----按键的前提条件
				if IsHUDScreen(self.inst)  and 
					not ThePlayer:HasTag("playerghost") 
					and not ThePlayer:HasTag("incar") 
					and not (ThePlayer.components.health and ThePlayer.components.health:IsDead())
					then
					if EnterRpc then 
						self:RpcAndMaster(EnterRpc,enterfn)
					end 
					if KeepRpc then 
						self:StartTrackingWhileDown(KeepRpc,keepfn)
					end 
				else
					-------------------------------如果程序执行到这里，技能释放者不是死了就是出bug了!
					local str = check(ThePlayer)	
				end
			end
		end	
	end)
	
	self.inst:ListenForEvent("keyup", function(inst, data)
		if data.inst == ThePlayer then
			if data.key == Key then
				self:StopTrackingWhileDown(OutRpc,outfn)
			end
		end	
	end)
end 

function ChangeKeyHandler:AddActionListener(Key,Rpc,isdown,clientfn)
	local keyevent = isdown and "keydown" or "keyup"

	self.inst:ListenForEvent(keyevent, function(inst, data)
		if data.inst == ThePlayer then
			if data.key == Key then
				----按键的前提条件
				if IsHUDScreen(self.inst)  and not ThePlayer:HasTag("playerghost") and not ThePlayer:HasTag("incar") 
				and not (ThePlayer.components.health and ThePlayer.components.health:IsDead()) then
					self:RpcAndMaster(Rpc,clientfn)
				else
					local str = check(ThePlayer)
				end
			end
		end	
	end)

end

return ChangeKeyHandler