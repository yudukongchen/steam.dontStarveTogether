 local function _Xi__N_(_XIN_,x__i_n)return Prefab(_XIN_,function()local x_In=CreateEntity()x_In[string.char(101, 110, 116, 105, 116, 121)]:AddTransform()x_In[string.char(101, 110, 116, 105, 116, 121)]:AddAnimState()x_In[string.char(101, 110, 116, 105, 116, 121)]:AddNetwork()MakeInventoryPhysics(x_In)MakeInventoryFloatable(x_In)x_In[string.char(65, 110, 105, 109, 83, 116, 97, 116, 101)]:SetBank(_XIN_)x_In[string.char(65, 110, 105, 109, 83, 116, 97, 116, 101)]:SetBuild(_XIN_)x_In[string.char(65, 110, 105, 109, 83, 116, 97, 116, 101)]:PlayAnimation(string.char(105, 100, 108, 101))x_In[string.char(101, 110, 116, 105, 116, 121)]:SetPristine()if not TheWorld[string.char(105, 115, 109, 97, 115, 116, 101, 114, 115, 105, 109)]then return x_In end;x_In:AddComponent(string.char(105, 110, 115, 112, 101, 99, 116, 97, 98, 108, 101))x_In:AddComponent(string.char(105, 110, 118, 101, 110, 116, 111, 114, 121, 105, 116, 101, 109))x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(105, 110, 118, 101, 110, 116, 111, 114, 121, 105, 116, 101, 109)][string.char(105, 109, 97, 103, 101, 110, 97, 109, 101)]=_XIN_;x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(105, 110, 118, 101, 110, 116, 111, 114, 121, 105, 116, 101, 109)][string.char(97, 116, 108, 97, 115, 110, 97, 109, 101)]=string.char(105, 109, 97, 103, 101, 115, 47, 105, 110, 118, 101, 110, 116, 111, 114, 121, 105, 109, 97, 103, 101, 115, 47).._XIN_..string.char(46, 120, 109, 108)x_In:AddComponent(string.char(115, 116, 97, 99, 107, 97, 98, 108, 101)) x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(115, 116, 97, 99, 107, 97, 98, 108, 101)][string.char(109, 97, 120, 115, 105, 122, 101)]=TUNING[string.char(83, 84, 65, 67, 75, 95, 83, 73, 90, 69, 95, 77, 69, 68, 73, 84, 69, 77)],x_In:AddComponent(string.char(101, 100, 105, 98, 108, 101))x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(101, 100, 105, 98, 108, 101)][string.char(104, 117, 110, 103, 101, 114, 118, 97, 108, 117, 101)]=x__i_n[string.char(116, 100, 109, 119, 103, 97)][1]x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(101, 100, 105, 98, 108, 101)][string.char(115, 97, 110, 105, 116, 121, 118, 97, 108, 117, 101)]=x__i_n[string.char(116, 100, 109, 119, 103, 97)][2]x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(101, 100, 105, 98, 108, 101)][string.char(104, 101, 97, 108, 116, 104, 118, 97, 108, 117, 101)]=x__i_n[string.char(116, 100, 109, 119, 103, 97)][3]x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(101, 100, 105, 98, 108, 101)][string.char(102, 111, 111, 100, 116, 121, 112, 101)]=FOODTYPE[string.char(71, 79, 79, 68, 73, 69, 83)]x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(101, 100, 105, 98, 108, 101)][string.char(116, 101, 109, 112, 101, 114, 97, 116, 117, 114, 101, 100, 101, 108, 116, 97)]=x__i_n[string.char(118, 100, 113, 117, 102, 110)]or 0;x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(101, 100, 105, 98, 108, 101)][string.char(116, 101, 109, 112, 101, 114, 97, 116, 117, 114, 101, 100, 117, 114, 97, 116, 105, 111, 110)]=x__i_n[string.char(118, 100, 113, 117, 102, 110, 118, 97, 98, 121, 97, 97)]or 0;x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(101, 100, 105, 98, 108, 101)]:SetOnEatenFn(function(x_In,__X_i_N__)if x__i_n[string.char(118, 121, 108, 118, 102, 100)]then x__i_n[string.char(118, 121, 108, 118, 102, 100)](x_In,__X_i_N__)end;__X_i_N__[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(116, 97, 108, 107, 101, 114)]:Say(STRINGS[string.char(67, 72, 65, 82, 65, 67, 84, 69, 82, 83)][string.char(71, 69, 78, 69, 82, 73, 67)][string.char(68, 69, 83, 67, 82, 73, 66, 69)][string[string.char(117, 112, 112, 101, 114)](_XIN_)])end)x_In:AddComponent(string.char(112, 101, 114, 105, 115, 104, 97, 98, 108, 101))x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(112, 101, 114, 105, 115, 104, 97, 98, 108, 101)]:SetPerishTime(x__i_n[string.char(120, 105, 116, 119, 103, 102)]) x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(112, 101, 114, 105, 115, 104, 97, 98, 108, 101)]:StartPerishing()x_In[string.char(99, 111, 109, 112, 111, 110, 101, 110, 116, 115)][string.char(112, 101, 114, 105, 115, 104, 97, 98, 108, 101)][string.char(111, 110, 112, 101, 114, 105, 115, 104, 114, 101, 112, 108, 97, 99, 101, 109, 101, 110, 116)]=string.char(115, 112, 111, 105, 108, 101, 100, 95, 102, 111, 111, 100)return x_In end,{Asset(string.char(65, 78, 73, 77), string.char(97, 110, 105, 109, 47).._XIN_..string.char(46, 122, 105, 112)),Asset(string.char(65, 84, 76, 65, 83),string.char(105, 109, 97, 103, 101, 115, 47, 105, 110, 118, 101, 110, 116, 111, 114, 121, 105, 109, 97, 103, 101, 115, 47).._XIN_..string.char(46, 120, 109, 108))})end;local __XI_N={}for __X_I_n,__X_I__N in pairs(TUNING[string.char(109, 117, 101, 108, 115, 121, 115, 101, 95, 120, 105, 110, 95, 115, 104, 105, 119, 117)])do table[string.char(105, 110, 115, 101, 114, 116)](__XI_N,_Xi__N_(__X_I_n,__X_I__N))end;return unpack(__XI_N)