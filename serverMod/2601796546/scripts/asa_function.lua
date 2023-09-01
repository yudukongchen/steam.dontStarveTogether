--幻影

----代码显示
--function AsaGetBuild(inst)
--	local debugstring = inst.entity:GetDebugString()
--	local bank,build,anim = debugstring:match("bank: (.+) build: (.+) anim: .+:(.+) Frame")
--	local asasg = inst.sg.currentstate.name
--	local mirage = {}
--	mirage[1] = bank
--	mirage[2] = build
--	mirage[3] = anim
--	mirage[4] = asasg
--
--	return mirage
--end

function Asa_Miraging(inst)
	for i = 1, 10, 1 do
		inst:DoTaskInTime(i/30,function()
			inst.AnimState:SetMultColour(1,1,1,1-i/10)
		end)
	end
end

function Asa_unMiraging(inst)
	for i = 1, 10, 1 do
		inst:DoTaskInTime(i/30,function()
			inst.AnimState:SetMultColour(1,1,1,i/10)
		end)
	end
end
