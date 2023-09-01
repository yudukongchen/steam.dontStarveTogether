local HungerMaker = Class(function(self, inst)
    self.inst = inst
end)

function HungerMaker:MakeHunger(doer)
	if doer and doer.components.hunger and  doer.components.sanity  then
			if doer.components.sanity.current >= 15 then
				doer.components.sanity:DoDelta(-20)
				doer.components.hunger:DoDelta(20)
			end
		--return  true
	end
end
return HungerMaker
