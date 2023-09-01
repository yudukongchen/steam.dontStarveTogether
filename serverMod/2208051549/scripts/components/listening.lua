
local listening = Class(function(self, inst)
	self.inst = inst
	self.pos = nil
end)

function listening:getposition()
	local tinst
	local SoundIndex
	while #LISTENFLAG > 0 do
		local index = math.random(#LISTENFLAG)
		local realindex = LISTENFLAG[index]
		print(realindex)
		if DITINGINDICATORS[realindex] and DITINGINDICATORS[realindex][1] ~= nil then
			print(DITINGINDICATORS[realindex][1])
			tinst = DITINGINDICATORS[realindex][math.random(#DITINGINDICATORS[realindex])]
			SoundIndex = realindex
			table.remove(LISTENFLAG,index)
			break;
		end
		table.remove(LISTENFLAG,index)
	end
	if tinst then
		print(LISTENSOUND[SoundIndex])
		self.inst.SoundEmitter:PlaySound(LISTENSOUND[SoundIndex])
		--ThePlayer.SoundEmitter:PlaySound("turnoftides/creatures/together/fruit_dragon/hit") --调试
	--	LISTENFLAG[PretoStr(tinst)] = true
		self.pos = tinst:GetPosition()
	end
end
function listening:trans(doer)
	if self.pos and doer then
		doer.Transform:SetPosition(self.pos.x, self.pos.y, self.pos.z)
		SpawnPrefab("sand_puff_large_back").Transform:SetPosition(self.pos.x, self.pos.y, self.pos.z)
		if doer.components.hunger and doer.components.sanity then
			doer.components.hunger:DoDelta(-65)
			doer.components.sanity:DoDelta(-20)
		end
	end
end

return listening