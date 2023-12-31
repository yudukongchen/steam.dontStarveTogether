local function a(b)
return b[1]or 0,b[2]or 0,b[3]or 0,0 
end;


local c=Class(function(self,d)self.inst=d;
self.current_colour={0,0,0,0}self.target_colour={0,0,0,0}self.callback=nil;
self.time=nil;
self.timepassed=0 end)

function c:EndFade()self.inst:StopUpdatingComponent(self)self.current_colour=self.target_colour;
self.inst.AnimState:SetAddColour(a(self.target_colour))
self.time=nil;
if self.callback then 
self.callback(self.inst)end end;

function c:StartFade(e,f,g)self.callback=g;self.target_colour=e;self.time=f;self.timepassed=0;
if self.time>0 then 
self.inst:StartUpdatingComponent(self)
else self:EndFade()end end;
function c:SetCurrentFade(e)self.current_colour=e end;
function c:OnUpdate(h)self.timepassed=self.timepassed+h;
local f=self.timepassed/self.time;
if f>1 then f=1 end;

local b={}
for i=1,3 do table.insert(b,Lerp(self.current_colour[i],self.target_colour[i],f))end;
self.inst.AnimState:SetAddColour(a(b))
if self.timepassed>=self.time then 
self:EndFade()end end;

return c

