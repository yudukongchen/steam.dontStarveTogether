local function Q(_IQQ,XpkjA) for pVRj,fuZ3z86 in pairs(XpkjA)do if _IQQ==fuZ3z86 then return false end end return true end local ZA=Class(function(er,DFb100j) er["\105\110\115\116"]=DFb100j er["\114\97\110\103\101"]=nil er["\115\112\101\101\100"]=0x17 er["\114\97\100\97\114"]=2.5 er["\98\117\108\107\105\110\103"]=nil er["\112\101\110\101\116\114\97\116\101"]=false er["\99\104\105\109\101\114\97\98\117\102\102"]=false er["\109\117\108\116\105\112\108\101"]=nil er["\119\101\97\112\111\110"]=nil er["\110\97\118\105\103\97\116\105\111\110"]=false er["\111\110\116\104\114\111\119\110"]=nil er["\111\110\104\105\116"]=nil er["\111\110\109\105\115\115"]=nil er["\98\108\97\99\107\108\105\115\116"]={}end)ZA["\83\101\116\79\110\84\104\114\111\119\110\70\110"] = function(self,XL_)self["\111\110\116\104\114\111\119\110"]=XL_ end ZA["\83\101\116\79\110\72\105\116\70\110"] = function(self,WYdR) self["\111\110\104\105\116"]=WYdR end ZA["\83\101\116\79\110\77\105\115\115\70\110"] = function(self,QKKks_zt)self["\111\110\109\105\115\115"]=QKKks_zt end ZA["\82\111\116\97\116\101\84\111\84\97\114\103\101\116"] = function(self,Are7xU) local yxjl=(Are7xU-self["\105\110\115\116"]:GetPosition()):GetNormalized() local ZG=math["\97\99\111\115"](yxjl:Dot(Vector3(0x1,0,0x0)))/DEGREES self["\105\110\115\116"]["\84\114\97\110\115\102\111\114\109"]:SetRotation(ZG) self["\105\110\115\116"]:FacePoint(Are7xU)end ZA["\84\104\114\111\119"] = function(self,Vu0cCAf,q,kP7O5,lqT)self["\97\116\116\97\99\107\101\114"]=Vu0cCAf self["\115\116\97\114\116"]=q local mP3mlD,PrPyxMK,tczrIB=q:Get() local a,wqU76o,LB1Z=kP7O5:Get() self["\114\97\110\103\101"]=lqT or math["\115\113\114\116"](math["\112\111\119"](mP3mlD-a,0x2)+math["\112\111\119"](tczrIB-LB1Z,0x2))+0x2 self:RotateToTarget(kP7O5) self["\105\110\115\116"]["\80\104\121\115\105\99\115"]:SetMotorVel(self["\115\112\101\101\100"],0x1,0)self["\105\110\115\116"]:StartUpdatingComponent(self) if not self["\110\97\118\105\103\97\116\105\111\110"] then self["\105\110\115\116"]:DoTaskInTime(.14,function(N9L,hDc_M)hDc_M["\110\97\118\105\103\97\116\105\111\110"]=true hDc_M["\105\110\115\116"]:DoTaskInTime(0x9,function(N9L,hDc_M) hDc_M:Stop()end,hDc_M)end,self)end self["\105\110\115\116"]:PushEvent("\111\110\116\104\114\111\119\110",{thrower=Vu0cCAf}) if self["\111\110\116\104\114\111\119\110"]~=nil then self["\111\110\116\104\114\111\119\110"](self["\105\110\115\116"],Vu0cCAf)end end ZA["\83\116\111\112"] = function(self,qW0lRiD1)self["\105\110\115\116"]["\80\104\121\115\105\99\115"]:Stop() self["\105\110\115\116"]:StopUpdatingComponent(self)local iD1IUx=SpawnPrefab("\97\109\105\121\97\95\98\111\109\98") local JLCOx_ak= (self["\112\101\110\101\116\114\97\116\101"] and"\120")or(self["\99\104\105\109\101\114\97\98\117\102\102"] and"\114")or"\97" if not self["\112\101\110\101\116\114\97\116\101"] then iD1IUx["\99\111\109\112\111\110\101\110\116\115"]["\97\109\105\121\97\109\97\103\105\99"]["\97\116\116\97\99\107\101\114"]=self["\97\116\116\97\99\107\101\114"] iD1IUx["\99\111\109\112\111\110\101\110\116\115"]["\97\109\105\121\97\109\97\103\105\99"]["\119\101\97\112\111\110"]=self["\119\101\97\112\111\110"] iD1IUx["\99\111\109\112\111\110\101\110\116\115"]["\97\109\105\121\97\109\97\103\105\99"]["\99\104\105\109\101\114\97\98\117\102\102"]=self["\99\104\105\109\101\114\97\98\117\102\102"] iD1IUx["\84\114\97\110\115\102\111\114\109"]:SetPosition(self["\105\110\115\116"]["\84\114\97\110\115\102\111\114\109"]:GetWorldPosition()) iD1IUx["\99\111\109\112\111\110\101\110\116\115"]["\97\109\105\121\97\109\97\103\105\99"]:Explosive(qW0lRiD1)else iD1IUx["\84\114\97\110\115\102\111\114\109"]:SetPosition(self["\105\110\115\116"]["\84\114\97\110\115\102\111\114\109"]:GetWorldPosition())iD1IUx:ListenForEvent("\97\110\105\109\111\118\101\114",iD1IUx["\82\101\109\111\118\101"])end if JLCOx_ak=="\114"then iD1IUx["\83\111\117\110\100\69\109\105\116\116\101\114"]:PlaySound("\97\109\105\121\97\95\99\118\47\97\109\105\121\97\67\86\47\109\105\110\103\122\104\111\110\103")end iD1IUx["\65\110\105\109\83\116\97\116\101"]:PlayAnimation("\98\111\109\98\95"..JLCOx_ak)self["\105\110\115\116"]:Remove()end ZA["\77\105\115\115"] = function(self)if self["\111\110\109\105\115\115"]~=nil then self["\111\110\109\105\115\115"](self["\105\110\115\116"],self["\97\116\116\97\99\107\101\114"])end self:Stop()end ZA["\72\105\116"] = function(self,hPQ) if self["\112\101\110\101\116\114\97\116\101"] then if hPQ and hPQ["\99\111\109\112\111\110\101\110\116\115"]["\99\111\109\98\97\116"]~=nil then hPQ["\99\111\109\112\111\110\101\110\116\115"]["\99\111\109\98\97\116"]:GetAttacked(self["\97\116\116\97\99\107\101\114"],self["\97\116\116\97\99\107\101\114"]["\99\111\109\112\111\110\101\110\116\115"]["\99\111\109\98\97\116"]:CalcDamage(hPQ,self["\119\101\97\112\111\110"],self["\109\117\108\116\105\112\108\101"]),self["\119\101\97\112\111\110"], self["\99\104\105\109\101\114\97\98\117\102\102"] and"\97\109\105\121\97\95\99\104\105\109\101\114\97\98\117\102\102"or nil)local R1FIoQI=SpawnPrefab("\97\109\105\121\97\95\98\111\109\98") R1FIoQI["\65\110\105\109\83\116\97\116\101"]:PlayAnimation("\98\111\109\98\95\120") R1FIoQI["\84\114\97\110\115\102\111\114\109"]:SetPosition(self["\105\110\115\116"]["\84\114\97\110\115\102\111\114\109"]:GetWorldPosition()) R1FIoQI:ListenForEvent("\97\110\105\109\111\118\101\114",R1FIoQI["\82\101\109\111\118\101"])end else self:Stop(hPQ)end end ZA["\69\120\112\108\111\115\105\118\101"] = function(self,NsoTwDs) if NsoTwDs==nil or not self["\105\110\115\116"]:IsNear(NsoTwDs,self["\114\97\100\97\114"])then local HGli,iy,m6SCS0=self["\105\110\115\116"]["\84\114\97\110\115\102\111\114\109"]:GetWorldPosition() for NUhYw6R4,Hv in pairs(TheSim:FindEntities(HGli,iy,m6SCS0,self["\114\97\100\97\114"],{"\95\104\101\97\108\116\104","\95\99\111\109\98\97\116"},TUNING["\65\77\73\89\65\95\78\79\95\84\65\71\83"]))do if Hv["\101\110\116\105\116\121"]:IsValid()and Hv["\101\110\116\105\116\121"]:IsVisible()and Hv~= self["\97\116\116\97\99\107\101\114"] and not Hv["\99\111\109\112\111\110\101\110\116\115"]["\104\101\97\108\116\104"]:IsDead()then NsoTwDs=Hv break end end end if NsoTwDs~=nil then NsoTwDs["\99\111\109\112\111\110\101\110\116\115"]["\99\111\109\98\97\116"]:GetAttacked(self["\97\116\116\97\99\107\101\114"],self["\97\116\116\97\99\107\101\114"]["\99\111\109\112\111\110\101\110\116\115"]["\99\111\109\98\97\116"]:CalcDamage(NsoTwDs,self["\119\101\97\112\111\110"]),self["\119\101\97\112\111\110"], self["\99\104\105\109\101\114\97\98\117\102\102"] and"\97\109\105\121\97\95\99\104\105\109\101\114\97\98\117\102\102"or nil)if self["\111\110\104\105\116"]~=nil then self["\111\110\104\105\116"](self["\105\110\115\116"],self["\97\116\116\97\99\107\101\114"],NsoTwDs,self["\99\104\105\109\101\114\97\98\117\102\102"])end end self["\105\110\115\116"]:ListenForEvent("\97\110\105\109\111\118\101\114",self["\105\110\115\116"]["\82\101\109\111\118\101"])end ZA["\67\114\117\105\115\101\77\105\115\115\105\108\101"] = function(self,Ch) local urkh,zhzpBSx,rHSjalVy=self["\105\110\115\116"]:GetPosition():Get() local TjhsnP=TheSim:FindEntities(urkh,zhzpBSx,rHSjalVy,Ch,{"\95\104\101\97\108\116\104","\95\99\111\109\98\97\116"},TUNING["\65\77\73\89\65\95\78\79\95\84\65\71\83"]) for t5jzEd9,JZAU2 in pairs(TjhsnP)do if Q(JZAU2,self["\98\108\97\99\107\108\105\115\116"])and JZAU2["\101\110\116\105\116\121"]:IsValid()and JZAU2["\101\110\116\105\116\121"]:IsVisible()and JZAU2 ~= self["\97\116\116\97\99\107\101\114"] and not JZAU2["\99\111\109\112\111\110\101\110\116\115"]["\104\101\97\108\116\104"]:IsDead()then local zPXTTg=JZAU2:GetPhysicsRadius(self["\98\117\108\107\105\110\103"] or 0x0)+Ch local seMLr=distsq(self["\105\110\115\116"]:GetPosition(),JZAU2:GetPosition()) if zPXTTg>seMLr then self:Hit(JZAU2)if self["\112\101\110\101\116\114\97\116\101"] then table["\105\110\115\101\114\116"](self["\98\108\97\99\107\108\105\115\116"],JZAU2)else break end end end end end ZA["\79\110\85\112\100\97\116\101"] = function(self,qX) if self["\110\97\118\105\103\97\116\105\111\110"] and self["\105\110\115\116"]["\101\110\116\105\116\121"]:IsVisible()then local h_8=self["\105\110\115\116"]:GetPosition()if self["\114\97\110\103\101"]~=nil and distsq(self["\115\116\97\114\116"],h_8)>self["\114\97\110\103\101"]*self["\114\97\110\103\101"] then self:Miss()else self:CruiseMissile(self["\114\97\100\97\114"]-.5)end end end return ZA
