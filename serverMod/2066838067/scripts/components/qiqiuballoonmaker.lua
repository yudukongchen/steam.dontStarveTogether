local QiqiuBalloonMaker = Class(function(self, inst)
    self.inst = inst
end)

function QiqiuBalloonMaker:MakeBalloon(x,y,z,doer)
		local balloon = SpawnPrefab("pangbaixiong")
	    if balloon then 
		    balloon.Transform:SetPosition(x,y,z)
		end
	if self.inst.components.finiteuses then
	self.inst.components.finiteuses:Use(1)
	end
end
return QiqiuBalloonMaker
