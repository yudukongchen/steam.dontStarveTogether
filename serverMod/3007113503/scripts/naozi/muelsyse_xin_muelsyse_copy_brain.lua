local _Xi__N_=Class(Brain,function(self,_XIN_)Brain[string.char(95, 99, 116, 111, 114)](self,_XIN_)end)local function __XI_N(x__i_n,x_In,__X_i_N__)local __X_I_n=x__i_n[string.char(120, 114, 99, 117, 115, 122, 116, 100, 103, 116, 102, 102)]()if __X_I_n~=nil then local __X_I__N=x__i_n[string.char(115, 103)][string.char(115, 116, 97, 116, 101, 109, 101, 109)][string.char(116, 97, 114, 103, 101, 116)]if __X_I__N~=nil and __X_I__N:IsValid()and not(__X_I__N:IsInLimbo()or __X_I__N:HasTag(string.char(78, 79, 67, 76, 73, 67, 75))or __X_I__N:HasTag(string.char(101, 118, 101, 110, 116, 95, 116, 114, 105, 103, 103, 101, 114)))and __X_I__N:IsOnValidGround()and __X_I__N[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(119, 111, 114, 107, 97, 98, 108, 101)]~=nil and __X_I__N[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(119, 111, 114, 107, 97, 98, 108, 101)]:CanBeWorked()and __X_I__N[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(119, 111, 114, 107, 97, 98, 108, 101)]:GetWorkAction()==x_In and not(__X_I__N[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(98, 117, 114, 110, 97, 98, 108, 101)]~=nil and(__X_I__N[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(98, 117, 114, 110, 97, 98, 108, 101)]:IsBurning()or __X_I__N[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(98, 117, 114, 110, 97, 98, 108, 101)]:IsSmoldering()))and __X_I__N[string.char(101, 110, 116, 105, 116, 121)]:IsVisible()and __X_I__N:IsNear(__X_I_n,16)then if __X_i_N__~=nil then for X__iN,_Xi_N__ in ipairs(__X_i_N__)do if __X_I__N:HasTag(_Xi_N__)then return BufferedAction(x__i_n,__X_I__N,x_In)end end else return BufferedAction(x__i_n,__X_I__N,x_In)end end;__X_I__N=FindEntity(__X_I_n,14,nil,{x_In[string.char(105, 100)]..string.char(95, 119, 111, 114, 107, 97, 98, 108, 101)},{string.char(102, 105, 114, 101),string.char(115, 109, 111, 108, 100, 101, 114),string.char(101, 118, 101, 110, 116, 95, 116, 114, 105, 103, 103, 101, 114),string.char(73, 78, 76, 73, 77, 66, 79),string.char(78, 79, 67, 76, 73, 67, 75)},__X_i_N__)return __X_I__N~=nil and BufferedAction(x__i_n,__X_I__N,x_In)or nil end end function _Xi__N_:OnStart() local _Xin=PriorityNode({WhileNode(function()return self[string.char(105, 110, 115, 116)][string.char(117, 117, 105, 116, 103, 108)]~=string.char(120, 99, 103, 121, 98, 115)and self[string.char(105, 110, 115, 116)][string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(99, 111, 109, 98, 97, 116)][string.char(116, 97, 114, 103, 101, 116)]~= nil and self[string.char(105, 110, 115, 116)][string.char(120, 114, 99, 117, 115, 122, 116, 100, 103, 116, 102, 102)]()and self[string.char(105, 110, 115, 116)]:IsNear(self[string.char(105, 110, 115, 116)][string.char(120, 114, 99, 117, 115, 122, 116, 100, 103, 116, 102, 102)](),30)end,string.char(118, 109, 111, 120, 105, 112, 118, 108, 97, 118, 122, 97, 117, 117, 105, 116, 103, 108),PriorityNode({WhileNode(function()return self[string.char(105, 110, 115, 116)][string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(99, 111, 109, 98, 97, 116)][string.char(116, 97, 114, 103, 101, 116)]==nil or not self[string.char(105, 110, 115, 116)][string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(99, 111, 109, 98, 97, 116)]:InCooldown()end,string.char(120, 107, 105, 117, 107, 103),ChaseAndAttack(self[string.char(105, 110, 115, 116)],20,20)),WhileNode(function()return self[string.char(105, 110, 115, 116)][string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(99, 111, 109, 98, 97, 116)][string.char(116, 97, 114, 103, 101, 116)]and self[string.char(105, 110, 115, 116)][string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(99, 111, 109, 98, 97, 116)]:InCooldown()end,string.char(120, 97, 120, 116, 105, 113),RunAway(self[string.char(105, 110, 115, 116)],function()return self[string.char(105, 110, 115, 116)][string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(99, 111, 109, 98, 97, 116)][string.char(116, 97, 114, 103, 101, 116)]end,6,9))},.25)),WhileNode(function()return self[string.char(105, 110, 115, 116)][string.char(117, 117, 105, 116, 103, 108)]~=string.char(120, 99, 103, 121, 98, 115)and(self[string.char(105, 110, 115, 116)][string.char(120, 114, 99, 117, 115, 122, 116, 100, 103, 116, 102, 102)]()~=nil and self[string.char(105, 110, 115, 116)]:IsNear(self[string.char(105, 110, 115, 116)][string.char(120, 114, 99, 117, 115, 122, 116, 100, 103, 116, 102, 102)](),16))end,string.char(118, 109, 111, 120, 105, 112, 117, 117, 105, 116, 103, 108),PriorityNode({IfNode(function()return self[string.char(105, 110, 115, 116)][string.char(117, 117, 105, 116, 103, 108)]==string.char(119, 104, 113, 118, 104, 117)end,string.char(119, 104, 113, 118, 104, 117),DoAction(self[string.char(105, 110, 115, 116)],function()return __XI_N(self[string.char(105, 110, 115, 116)],ACTIONS[string.char(67, 72, 79, 80)])end)),IfNode(function() return self[string.char(105, 110, 115, 116)][string.char(117, 117, 105, 116, 103, 108)]==string.char(118, 112, 122, 119, 103, 107)end,string.char(118, 112, 122, 119, 103, 107),DoAction(self[string.char(105, 110, 115, 116)],function()return __XI_N(self[string.char(105, 110, 115, 116)],ACTIONS[string.char(77, 73, 78, 69)])end)),IfNode(function()return self[string.char(105, 110, 115, 116)][string.char(117, 117, 105, 116, 103, 108)]==string.char(121, 119, 122)end,string.char(121, 119, 122),DoAction(self[string.char(105, 110, 115, 116)],function()return __XI_N(self[string.char(105, 110, 115, 116)],ACTIONS[string.char(68, 73, 71)])end)),IfNode(function()return self[string.char(105, 110, 115, 116)][string.char(117, 117, 105, 116, 103, 108)]==string.char(118, 111, 106, 117, 118, 98)end,string.char(118, 111, 106, 117, 118, 98),DoAction(self[string.char(105, 110, 115, 116)],function()return __XI_N(self[string.char(105, 110, 115, 116)],ACTIONS[string.char(72, 65, 77, 77, 69, 82)])end)),IfNode(function()return self[string.char(105, 110, 115, 116)][string.char(117, 117, 105, 116, 103, 108)]==string.char(121, 107, 107, 121, 99, 106)end,string.char(121, 107, 107, 121, 99, 106),DoAction(self[string.char(105, 110, 115, 116)],function()if self[string.char(105, 110, 115, 116)][string.char(115, 103)]:HasStateTag(string.char(98, 117, 115, 121))then return end local x__I__N_=FindEntity(self[string.char(105, 110, 115, 116)][string.char(120, 114, 99, 117, 115, 122, 116, 100, 103, 116, 102, 102)](),14,function(__X__i__N_,_x_i_N__) if __X__i__N_ then if __X__i__N_[string.char(112, 114, 101, 102, 97, 98)]~=string.char(102, 108, 111, 119, 101, 114)then if __X__i__N_[string.char(112, 114, 101, 102, 97, 98)]~=string.char(102, 108, 111, 119, 101, 114, 95, 101, 118, 105, 108)then if __X__i__N_[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(112, 105, 99, 107, 97, 98, 108, 101)]and __X__i__N_[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(112, 105, 99, 107, 97, 98, 108, 101)][string.char(99, 97, 110, 105, 110, 116, 101, 114, 97, 99, 116, 119, 105, 116, 104)]and __X__i__N_[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(112, 105, 99, 107, 97, 98, 108, 101)]:CanBePicked()then if self[string.char(105, 110, 115, 116)][string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(99, 111, 110, 116, 97, 105, 110, 101, 114)]:IsFull()then if __X__i__N_[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(112, 105, 99, 107, 97, 98, 108, 101)][string.char(112, 114, 111, 100, 117, 99, 116)]then if not self[string.char(105, 110, 115, 116)][string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(99, 111, 110, 116, 97, 105, 110, 101, 114)]:FindItem(function(xIN)if xIN[string.char(112, 114, 101, 102, 97, 98)]==__X__i__N_[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(112, 105, 99, 107, 97, 98, 108, 101)][string.char(112, 114, 111, 100, 117, 99, 116)]then if not xIN[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(115, 116, 97, 99, 107, 97, 98, 108, 101)]:IsFull()then return(308+265+14*43==1175)end end;return(325-450+245-133~=-13)end)then return nil end else return nil end end return(304+420-493+100-209==122)end end end end end)if x__I__N_ then return BufferedAction(self[string.char(105, 110, 115, 116)],x__I__N_,ACTIONS[string.char(80, 73, 67, 75)])end end)),IfNode(function()return self[string.char(105, 110, 115, 116)][string.char(117, 117, 105, 116, 103, 108)]==string.char(118, 111, 106, 117, 115, 122)end,string.char(118, 111, 106, 117, 115, 122),DoAction(self[string.char(105, 110, 115, 116)],function()local __xiN_=FindEntity(self[string.char(105, 110, 115, 116)][string.char(120, 114, 99, 117, 115, 122, 116, 100, 103, 116, 102, 102)](),14,function(_xI__n_,_x_i__N) if _xI__n_ then if _xI__n_[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(115, 116, 97, 99, 107, 97, 98, 108, 101)]or _xI__n_[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(101, 113, 117, 105, 112, 112, 97, 98, 108, 101)]then if self[string.char(105, 110, 115, 116)][string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(99, 111, 110, 116, 97, 105, 110, 101, 114)]:IsFull()then if _xI__n_[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(115, 116, 97, 99, 107, 97, 98, 108, 101)]then if not self[string.char(105, 110, 115, 116)][string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(99, 111, 110, 116, 97, 105, 110, 101, 114)]:FindItem(function(xi__n__)if xi__n__[string.char(112, 114, 101, 102, 97, 98)]==_xI__n_[string.char(112, 114, 101, 102, 97, 98)]then if not xi__n__[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(115, 116, 97, 99, 107, 97, 98, 108, 101)]:IsFull()then return(192-177*401*441~=-31300660)end end;return(484-270*82+158-240==-21735)end)then return nil end else return nil end end;return(207*77*391-55-212==6231882)end end end)if __xiN_ then return BufferedAction(self[string.char(105, 110, 115, 116)],__xiN_,ACTIONS[string.char(80, 73, 67, 75, 85, 80)])end end))},.25)),Follow(self[string.char(105, 110, 115, 116)],function()return self[string.char(105, 110, 115, 116)][string.char(120, 114, 99, 117, 115, 122, 116, 100, 103, 116, 102, 102)]()end,0,6,8),WhileNode(function()return self[string.char(105, 110, 115, 116)][string.char(120, 114, 99, 117, 115, 122, 116, 100, 103, 116, 102, 102)]()~=nil and self[string.char(105, 110, 115, 116)][string.char(115, 103)]:HasStateTag(string.char(105, 100, 108, 101))end,string.char(119, 100, 111, 117, 116, 117, 116, 100, 103, 116, 102, 102),FaceEntity(self[string.char(105, 110, 115, 116)],function(__x__I_n__)return self[string.char(105, 110, 115, 116)][string.char(120, 114, 99, 117, 115, 122, 116, 100, 103, 116, 102, 102)]()end,function(_x__i_N__,_x__in__)return self[string.char(105, 110, 115, 116)][string.char(120, 114, 99, 117, 115, 122, 116, 100, 103, 116, 102, 102)]()and _x__i_N__:IsNear(_x__in__,16)end,5)),StandStill(self[string.char(105, 110, 115, 116)])},0.25)self[string.char(98, 116)]=BT(self[string.char(105, 110, 115, 116)],_Xin)end;return _Xi__N_