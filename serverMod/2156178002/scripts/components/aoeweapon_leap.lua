local a=Class(function(self,b)self.inst=b;self.range=4;self.damage=nil;self.stimuli=nil;self.onleap=nil end)
function a:SetRange(c)self.range=c end;
function a:SetStimuli(d)self.stimuli=d end;
function a:SetOnLeapFn(e)self.onleap=e end;
function a:DoLeap(f,g,h)
local i={}
local j,k,l=h:Get()
local m=TheSim:FindEntities(j,k,l,self.range,nil,{"player","companion"})
for n,o in ipairs(m)do 
if f~=nil and o~=f and(f.components.combat:IsValidTarget(o)and o.components.health or o.entity:IsValid()and o.components.workable and o.components.workable:CanBeWorked()and o.components.workable:GetWorkAction())then 
table.insert(i,o)end end;
if self.inst.components.weapon and self.inst.components.weapon:HasAltAttack()then
 self.inst.components.weapon:DoAltAttack(f,i,nil,self.stimuli)end;
 if self.onleap then 
 self.onleap(self.inst,f,g,h)end end;
 return a