local function pVRj(QKKks_zt,Are7xU) QKKks_zt["\105\110\115\116"]["\109\97\120\95\101\110\101\114\103\121"]:set(Are7xU)end local function fuZ3z86(yxjl,ZG) yxjl["\105\110\115\116"]["\99\117\114\114\101\110\116\95\101\110\101\114\103\121"]:set(ZG)end local function er(Vu0cCAf,q) Vu0cCAf["\105\110\115\116"]["\121\117\97\110\122\105\95\108\101\118\101\108"]:set(q)end local function DFb100j(kP7O5,lqT) kP7O5["\105\110\115\116"]["\99\117\114\114\101\110\116\95\108\101\118\101\108"]:set(lqT)end local XL_=Class(function(mP3mlD,PrPyxMK)mP3mlD["\105\110\115\116"]=PrPyxMK mP3mlD["\109\97\120\101\110\101\114\103\121"]=0x12C mP3mlD["\109\105\110\101\110\101\114\103\121"]=0x0 mP3mlD["\99\117\114\114\101\110\116\101\110\101\114\103\121"]=0x32 mP3mlD["\108\101\118\101\108"]=0x0 mP3mlD["\99\117\114\114\101\110\116\108\101\118\101\108"]=0x0 mP3mlD["\114\97\116\101"]=0x1 mP3mlD["\110\117\109"]=TUNING["\89\85\65\78\90\73\95\82\69\71\65\73\78\82\65\84\69"] end, nil,{maxenergy=pVRj,currentenergy=fuZ3z86,level=er,currentlevel=DFb100j}) XL_["\76\111\97\100\67\111\109\112\67\117\115\116\111\109\105\122\101"] = function(self)self["\105\110\115\116"]:OnYuanzitatus()end XL_["\71\101\116\80\101\114\99\101\110\116"] = function(self)return self["\99\117\114\114\101\110\116\101\110\101\114\103\121"]/self["\109\97\120\101\110\101\114\103\121"] end XL_["\71\101\116\67\117\114\114\101\110\116"] = function(self)return self["\99\117\114\114\101\110\116\101\110\101\114\103\121"] end XL_["\73\115\77\97\120"] = function(self)return self["\99\117\114\114\101\110\116\101\110\101\114\103\121"]>=self["\109\97\120\101\110\101\114\103\121"] end local function WYdR(tczrIB,a)a:DoDelta(a["\110\117\109"])end XL_["\83\116\97\114\116\67\111\110\115\117\109\105\110\103"] = function(self) self:StopConsuming()if self["\116\97\115\107"]==nil then self["\116\97\115\107"]=self["\105\110\115\116"]:DoPeriodicTask(self["\114\97\116\101"],WYdR,nil,self)end end XL_["\68\111\68\101\108\116\97"] = function(self,wqU76o) self["\99\117\114\114\101\110\116\101\110\101\114\103\121"]=math["\99\108\97\109\112"](self["\99\117\114\114\101\110\116\101\110\101\114\103\121"]+wqU76o,self["\109\105\110\101\110\101\114\103\121"],self["\109\97\120\101\110\101\114\103\121"])if self:IsMax()then self:StopConsuming()else if self["\116\97\115\107"]==nil then self:StartConsuming()end end self["\105\110\115\116"]:PushEvent("\101\110\101\114\103\121\100\101\108\116\97",{percent=self:GetPercent()})end XL_["\83\116\111\112\67\111\110\115\117\109\105\110\103"] = function(self) if self["\116\97\115\107"] then self["\116\97\115\107"]:Cancel()self["\116\97\115\107"]=nil end end XL_["\79\110\83\97\118\101"] = function(self)return {currentenergy=self["\99\117\114\114\101\110\116\101\110\101\114\103\121"],level=self["\108\101\118\101\108"],currentlevel=self["\99\117\114\114\101\110\116\108\101\118\101\108"]}end XL_["\79\110\76\111\97\100"] = function(self,LB1Z)for N9L,hDc_M in pairs(LB1Z)do self[N9L]=hDc_M end end return XL_
