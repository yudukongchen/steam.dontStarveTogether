local TzPythonSummonRocket = Class(function(self,inst)
    self.inst = inst 
    self.on_launch = nil 

    inst:AddTag("tz_python_summon_rocket")
end)

function TzPythonSummonRocket:SetOnLaunch(fn)
    self.on_launch = fn 
end

function TzPythonSummonRocket:Launch()
    if self.on_launch then 
        self.on_launch(self.inst)
    end 
end

return TzPythonSummonRocket