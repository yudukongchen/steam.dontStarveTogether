local Q=Class(function(_IQQ,XpkjA)_IQQ["\105\110\115\116"]=XpkjA end) local function ZA(pVRj,fuZ3z86)for er,DFb100j in pairs(fuZ3z86)do if pVRj==DFb100j["\107\101\121"] then return true,DFb100j["\97\99\116"] end end return false end Q["\65\100\100\65\99\116\105\111\110\76\105\115\116\101\110\101\114"] = function(self,XL_,WYdR) self["\105\110\115\116"]:ListenForEvent(XL_.."\107\101\121",function(QKKks_zt,Are7xU) if Are7xU["\105\110\115\116"]==ThePlayer then if ThePlayer["\114\101\112\108\105\99\97"]["\104\101\97\108\116\104"]:IsDead()or ThePlayer["\99\111\109\112\111\110\101\110\116\115"]["\112\108\97\121\101\114\99\111\110\116\114\111\108\108\101\114"]==nil or ThePlayer["\99\111\109\112\111\110\101\110\116\115"]["\112\108\97\121\101\114\99\111\110\116\114\111\108\108\101\114"]:IsBusy()then return end local yxjl,ZG=ZA(Are7xU["\107\101\121"],WYdR) if yxjl then local Vu0cCAf,q,kP7O5=(TheInput:GetWorldPosition()or Vector3(0x0,0,0x0)):Get() if TheWorld["\105\115\109\97\115\116\101\114\115\105\109"] then ThePlayer:PushEvent(XL_.."\95\107\101\121\97\99\116\105\111\110",{Name=XL_,Fn=MOD_RPC_HANDLERS[XL_][MOD_RPC[XL_][XL_]["\105\100"]],act=ZG,x=Vu0cCAf,y=q,z=kP7O5})else SendModRPCToServer(MOD_RPC[XL_][XL_],ZG,Vu0cCAf,q,kP7O5)end end end end) if TheWorld["\105\115\109\97\115\116\101\114\115\105\109"] then self["\105\110\115\116"]:ListenForEvent(XL_.."\95\107\101\121\97\99\116\105\111\110",function(lqT,mP3mlD)if not mP3mlD["\78\97\109\101"]==XL_ then return end mP3mlD["\70\110"](lqT,mP3mlD["\97\99\116"],mP3mlD["\120"],mP3mlD["\121"],mP3mlD["\122"])end)end end return Q
