local Q=Class(function(_IQQ,XpkjA)_IQQ["\105\110\115\116"]=XpkjA _IQQ["\111\119\110\101\114"]=nil _IQQ["\115\116\97\114\116"]=nil _IQQ["\100\101\115\116"]=nil _IQQ["\115\112\101\101\100"]=nil _IQQ["\111\110\116\104\114\111\119\110"]=nil _IQQ["\104\105\116\100\105\115\116"]=1.5 _IQQ["\114\97\110\103\101"]=nil _IQQ["\111\110\104\105\116"]=nil _IQQ["\111\110\109\105\115\115"]=nil _IQQ["\99\97\110\104\105\116"]=nil _IQQ["\108\97\117\110\99\104\111\102\102\115\101\116"]=Vector3(.5,0,0x0) _IQQ["\110\111\116\97\103\115"]=deepcopy(TUNING["\89\85\65\78\90\73\95\78\79\84\65\71\83"])if _IQQ["\110\111\116\97\103\115"]~=nil then table["\105\110\115\101\114\116"](_IQQ["\110\111\116\97\103\115"],"\115\109\97\115\104\97\98\108\101")end end) local function ZA(pVRj,fuZ3z86)local er=pVRj["\120"]-fuZ3z86["\120"] local DFb100j=pVRj["\121"]-fuZ3z86["\121"] local XL_=pVRj["\122"]- fuZ3z86["\122"] return math["\115\113\114\116"](er*er+DFb100j*DFb100j+XL_*XL_)end Q["\83\101\116\83\112\101\101\100"] = function(self,WYdR)self["\115\112\101\101\100"]=WYdR end Q["\83\101\116\82\97\110\103\101"] = function(self,QKKks_zt)self["\114\97\110\103\101"]=QKKks_zt end Q["\83\101\116\79\110\84\104\114\111\119\110\70\110"] = function(self,Are7xU)self["\111\110\116\104\114\111\119\110"]=Are7xU end Q["\83\101\116\72\105\116\68\105\115\116"] = function(self,yxjl) self["\104\105\116\100\105\115\116"]=yxjl end Q["\83\101\116\79\110\72\105\116\70\110"] = function(self,ZG)self["\111\110\104\105\116"]=ZG end Q["\83\101\116\79\110\77\105\115\115\70\110"] = function(self,Vu0cCAf) self["\111\110\109\105\115\115"]=Vu0cCAf end Q["\83\101\116\76\97\117\110\99\104\79\102\102\115\101\116"] = function(self,q)self["\108\97\117\110\99\104\111\102\102\115\101\116"]=q end Q["\83\101\116\67\97\110\72\105\116"] = function(self,kP7O5)self["\99\97\110\104\105\116"]=kP7O5 end Q["\84\104\114\111\119"] = function(self,lqT,mP3mlD,PrPyxMK)self["\111\119\110\101\114"]=lqT self["\100\101\115\116"]=mP3mlD self["\115\116\97\114\116"]=Vector3(lqT["\84\114\97\110\115\102\111\114\109"]:GetWorldPosition())local tczrIB=self["\108\97\117\110\99\104\111\102\102\115\101\116"] local a,wqU76o,LB1Z=self["\105\110\115\116"]["\84\114\97\110\115\102\111\114\109"]:GetWorldPosition() local N9L=lqT["\84\114\97\110\115\102\111\114\109"]:GetRotation()*DEGREES self["\105\110\115\116"]["\84\114\97\110\115\102\111\114\109"]:SetPosition(a+ self["\108\97\117\110\99\104\111\102\102\115\101\116"]["\120"]*math["\99\111\115"](N9L),wqU76o+self["\108\97\117\110\99\104\111\102\102\115\101\116"]["\121"],LB1Z- self["\108\97\117\110\99\104\111\102\102\115\101\116"]["\120"]*math["\115\105\110"](N9L))if PrPyxMK then PrPyxMK(self["\105\110\115\116"])end self:RotateToTarget(self["\100\101\115\116"]) local hDc_M=math["\97\98\115"]((wqU76o+self["\108\97\117\110\99\104\111\102\102\115\101\116"]["\121"])-self["\100\101\115\116"]["\121"]) local qW0lRiD1=math["\97\98\115"]( (a+self["\108\97\117\110\99\104\111\102\102\115\101\116"]["\120"]*math["\99\111\115"](N9L))-self["\100\101\115\116"]["\120"]) self["\105\110\115\116"]["\80\104\121\115\105\99\115"]:SetMotorVel(self["\115\112\101\101\100"],-hDc_M*self["\115\112\101\101\100"]/qW0lRiD1,0x0)self["\105\110\115\116"]:PushEvent("\111\110\116\104\114\111\119\110",{thrower=lqT}) if self["\111\110\116\104\114\111\119\110"]~=nil then self["\111\110\116\104\114\111\119\110"](self["\105\110\115\116"],lqT)end self["\105\110\115\116"]:StartUpdatingComponent(self)end Q["\77\105\115\115"] = function(self) if self["\111\110\109\105\115\115"] then self["\111\110\109\105\115\115"](self["\105\110\115\116"],self["\111\119\110\101\114"])end self:Stop()end Q["\83\116\111\112"] = function(self) self["\105\110\115\116"]:StopUpdatingComponent(self)self["\105\110\115\116"]["\80\104\121\115\105\99\115"]:Stop() self["\105\110\115\116"]:Remove()end Q["\72\105\116"] = function(self,iD1IUx,JLCOx_ak) if iD1IUx~=nil then local hPQ=self["\100\97\109\97\103\101"] or JLCOx_ak["\99\111\109\112\111\110\101\110\116\115"]["\99\111\109\98\97\116"]:CalcDamage(iD1IUx,self["\105\110\115\116"]) iD1IUx["\99\111\109\112\111\110\101\110\116\115"]["\99\111\109\98\97\116"]:GetAttacked(JLCOx_ak,hPQ,self["\105\110\115\116"]) iD1IUx["\99\111\109\112\111\110\101\110\116\115"]["\99\111\109\98\97\116"]:SuggestTarget(JLCOx_ak) if self["\111\110\104\105\116"] then self["\111\110\104\105\116"](self["\105\110\115\116"],JLCOx_ak,iD1IUx)end end self:Stop()end Q["\79\110\85\112\100\97\116\101"] = function(self,R1FIoQI) if self["\105\110\115\116"]["\101\110\116\105\116\121"]:IsVisible()then local NsoTwDs,HGli,iy=self["\105\110\115\116"]["\84\114\97\110\115\102\111\114\109"]:GetWorldPosition() local m6SCS0=TheSim:FindEntities(NsoTwDs,0x0,iy,self["\104\105\116\100\105\115\116"],{"\95\99\111\109\98\97\116","\95\104\101\97\108\116\104"},self["\110\111\116\97\103\115"]) local NUhYw6R4=Vector3(self["\105\110\115\116"]["\84\114\97\110\115\102\111\114\109"]:GetWorldPosition())local Hv=distsq(self["\115\116\97\114\116"],NUhYw6R4) if self["\114\97\110\103\101"] and Hv> self["\114\97\110\103\101"]*self["\114\97\110\103\101"] then self:Miss()else for Ch,urkh in pairs(m6SCS0)do if urkh~=nil and urkh:IsValid()and not urkh:IsInLimbo()and urkh["\101\110\116\105\116\121"]:IsValid()and urkh["\101\110\116\105\116\121"]:IsVisible()and urkh~=self["\111\119\110\101\114"] and urkh["\99\111\109\112\111\110\101\110\116\115"]["\104\101\97\108\116\104"]~=nil and urkh["\99\111\109\112\111\110\101\110\116\115"]["\99\111\109\98\97\116"]~=nil and not urkh["\99\111\109\112\111\110\101\110\116\115"]["\104\101\97\108\116\104"]:IsDead()and ZA(urkh:GetPosition(),self["\105\110\115\116"]:GetPosition())< self["\104\105\116\100\105\115\116"]+ (urkh["\80\104\121\115\105\99\115"] and urkh["\80\104\121\115\105\99\115"]:GetRadius()or 0x0)and (self["\99\97\110\104\105\116"]==nil or self["\99\97\110\104\105\116"](self["\105\110\115\116"],urkh))then self:Hit(urkh,self["\111\119\110\101\114"])break end end end end end Q["\82\111\116\97\116\101\84\111\84\97\114\103\101\116"] = function(self,zhzpBSx) local rHSjalVy=Vector3(self["\105\110\115\116"]["\84\114\97\110\115\102\111\114\109"]:GetWorldPosition()) local TjhsnP=(zhzpBSx-rHSjalVy):GetNormalized() local t5jzEd9=math["\97\99\111\115"](TjhsnP:Dot(Vector3(0x1,0,0x0)))/DEGREES self["\105\110\115\116"]["\84\114\97\110\115\102\111\114\109"]:SetRotation(t5jzEd9) self["\105\110\115\116"]:FacePoint(zhzpBSx)end return Q
