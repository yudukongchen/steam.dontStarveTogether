local Are7xU=require"widgets/screen"local yxjl=require"widgets/widget"local ZG=require"widgets/text"local Vu0cCAf=require"widgets/textedit"local q=require"widgets/menu"local kP7O5=require"widgets/uianim"local lqT=require"widgets/imagebutton"local mP3mlD=require"widgets/textbutton"local PrPyxMK=require("emoji_items")local function tczrIB(N9L,hDc_M,qW0lRiD1)if not qW0lRiD1.isopen then return end;local iD1IUx=qW0lRiD1:GetText()local JLCOx_ak=iD1IUx:match("^%s*(.-%S)%s*$")or""if iD1IUx~=JLCOx_ak or#iD1IUx<=0 then qW0lRiD1.edit_text:SetString(JLCOx_ak)qW0lRiD1.edit_text:SetEditing(true)return end;SendModRPCToServer(MOD_RPC["huahouse_name"]["rename"],iD1IUx)if qW0lRiD1.config.acceptbtn.cb~=nil then qW0lRiD1.config.acceptbtn.cb(N9L,hDc_M,qW0lRiD1)end;hDc_M.HUD:CloseHusHouseWriteableWidget()end;local function a(hPQ,R1FIoQI,NsoTwDs)if not NsoTwDs.isopen then return end;NsoTwDs.config.middlebtn.cb(hPQ,R1FIoQI,NsoTwDs)NsoTwDs.edit_text:SetEditing(true)end;local function wqU76o(HGli,iy,m6SCS0)if not m6SCS0.isopen then return end;if m6SCS0.config.cancelbtn.cb~=nil then m6SCS0.config.cancelbtn.cb(HGli,iy,m6SCS0)end;iy.HUD:CloseHusHouseWriteableWidget()end local LB1Z=Class(Are7xU,function(NUhYw6R4,Hv,Ch,urkh)Are7xU._ctor(NUhYw6R4,"huahouse_Writer")NUhYw6R4.owner=Hv;NUhYw6R4.writeable=Ch;NUhYw6R4.config=urkh;NUhYw6R4.isopen=false;NUhYw6R4._scrnw,NUhYw6R4._scrnh=TheSim:GetScreenSize()NUhYw6R4:SetScaleMode(SCALEMODE_PROPORTIONAL)NUhYw6R4:SetMaxPropUpscale(MAX_HUD_SCALE)NUhYw6R4:SetPosition(0,0,0)NUhYw6R4:SetVAnchor(ANCHOR_MIDDLE)NUhYw6R4:SetHAnchor(ANCHOR_MIDDLE) NUhYw6R4.scalingroot=NUhYw6R4:AddChild(yxjl("huahouse_WriteableWidgetscalingroot"))NUhYw6R4.scalingroot:SetScale(TheFrontEnd:GetHUDScale())NUhYw6R4.inst:ListenForEvent("continuefrompause",function()if NUhYw6R4.isopen then NUhYw6R4.scalingroot:SetScale(TheFrontEnd:GetHUDScale())end end,TheWorld)NUhYw6R4.inst:ListenForEvent("refreshhudsize",function(t5jzEd9,JZAU2)if NUhYw6R4.isopen then NUhYw6R4.scalingroot:SetScale(JZAU2)end end,Hv.HUD.inst)NUhYw6R4.root=NUhYw6R4.scalingroot:AddChild(yxjl("huahouse_WriteableWidgetroot"))NUhYw6R4.root:SetScale(.6,.6,.6)NUhYw6R4.black=NUhYw6R4.root:AddChild(Image("images/global.xml","square.tex"))NUhYw6R4.black:SetVRegPoint(ANCHOR_MIDDLE)NUhYw6R4.black:SetHRegPoint(ANCHOR_MIDDLE)NUhYw6R4.black:SetVAnchor(ANCHOR_MIDDLE)NUhYw6R4.black:SetHAnchor(ANCHOR_MIDDLE)NUhYw6R4.black:SetScaleMode(SCALEMODE_FILLSCREEN)NUhYw6R4.black:SetTint(0,0,0,0)NUhYw6R4.black.OnMouseButton=function()wqU76o(NUhYw6R4.writeable,NUhYw6R4.owner,NUhYw6R4)end;NUhYw6R4.bganim=NUhYw6R4.root:AddChild(kP7O5())NUhYw6R4.bganim:SetScale(1,1,1)NUhYw6R4.bgimage=NUhYw6R4.root:AddChild(Image())NUhYw6R4.bganim:SetScale(1,1,1)NUhYw6R4.edit_text=NUhYw6R4.root:AddChild(Vu0cCAf(BUTTONFONT,50,""))NUhYw6R4.edit_text:SetColour(0,0,0,1)NUhYw6R4.edit_text:SetForceEdit(true)NUhYw6R4.edit_text:SetPosition(0,10,0)NUhYw6R4.edit_text:SetRegionSize(320,120) NUhYw6R4.edit_text:SetHAlign(ANCHOR_LEFT)NUhYw6R4.edit_text:SetVAlign(ANCHOR_TOP)NUhYw6R4.edit_text:SetTextLengthLimit(MAX_WRITEABLE_LENGTH)NUhYw6R4.edit_text:EnableWordWrap(true)NUhYw6R4.edit_text:EnableWhitespaceWrap(true)NUhYw6R4.edit_text:EnableRegionSizeLimit(true)NUhYw6R4.edit_text:EnableScrollEditWindow(false)NUhYw6R4.buttons={}table.insert(NUhYw6R4.buttons,{text=urkh.cancelbtn.text,cb=function()wqU76o(NUhYw6R4.writeable,NUhYw6R4.owner,NUhYw6R4)end,control=urkh.cancelbtn.control})if urkh.middlebtn~=nil then table.insert(NUhYw6R4.buttons,{text=urkh.middlebtn.text,cb=function()a(NUhYw6R4.writeable,NUhYw6R4.owner,NUhYw6R4)end,control=urkh.middlebtn.control})end;table.insert(NUhYw6R4.buttons,{text=urkh.acceptbtn.text,cb=function()tczrIB(NUhYw6R4.writeable,NUhYw6R4.owner,NUhYw6R4)end,control=urkh.acceptbtn.control})for zPXTTg,seMLr in ipairs(NUhYw6R4.buttons)do if seMLr.control~=nil then NUhYw6R4.edit_text:SetPassControlToScreen(seMLr.control,true)end end;local zhzpBSx=urkh.menuoffset or Vector3(0,0,0)if TheInput:ControllerAttached()then local qX=195;NUhYw6R4.menu=NUhYw6R4.root:AddChild(q(NUhYw6R4.buttons,qX,true,"none"))NUhYw6R4.menu:SetTextSize(40)local h_8=NUhYw6R4.menu:AutoSpaceByText(15) NUhYw6R4.menu:SetPosition(zhzpBSx.x-.5*h_8,zhzpBSx.y+10,zhzpBSx.z)else local xL7OTb=155;NUhYw6R4.menu=NUhYw6R4.root:AddChild(q(NUhYw6R4.buttons,xL7OTb,true,"small"))NUhYw6R4.menu:SetTextSize(35)NUhYw6R4.menu:SetPosition(zhzpBSx.x-.5*xL7OTb* (#NUhYw6R4.buttons-1),zhzpBSx.y+10,zhzpBSx.z)end;local rHSjalVy=""if NUhYw6R4.config.defaulttext~=nil then if type(NUhYw6R4.config.defaulttext)=="string"then rHSjalVy=NUhYw6R4.config.defaulttext elseif type(NUhYw6R4.config.defaulttext)=="function"then rHSjalVy=NUhYw6R4.config.defaulttext(NUhYw6R4.writeable,NUhYw6R4.owner)end end;NUhYw6R4:OverrideText(rHSjalVy)NUhYw6R4.edit_text:OnControl(CONTROL_ACCEPT,false)NUhYw6R4.edit_text.OnTextEntered=function()NUhYw6R4:OnControl(CONTROL_ACCEPT,false)end;NUhYw6R4.edit_text:SetHelpTextApply("")NUhYw6R4.edit_text:SetHelpTextCancel("")NUhYw6R4.edit_text:SetHelpTextEdit("")NUhYw6R4.default_focus=NUhYw6R4.edit_text;if urkh.bgatlas~=nil and urkh.bgimage~=nil then NUhYw6R4.bgimage:SetTexture(urkh.bgatlas,urkh.bgimage)end;if urkh.animbank~=nil then NUhYw6R4.bganim:GetAnimState():SetBank(urkh.animbank)end;if urkh.animbuild~=nil then NUhYw6R4.bganim:GetAnimState():SetBuild(urkh.animbuild)end;if urkh.pos~=nil then NUhYw6R4.root:SetPosition(urkh.pos)else NUhYw6R4.root:SetPosition(0,150,0)end;NUhYw6R4.emoji={}local TjhsnP=1;for w8T3f,K in pairs(EMOJI_ITEMS)do local qL=math.floor(TjhsnP/10)local vfIyB=TjhsnP- (qL-1)*10;NUhYw6R4.emoji[w8T3f]=NUhYw6R4.menu:AddChild(mP3mlD())NUhYw6R4.emoji[w8T3f]:SetTextSize(42)NUhYw6R4.emoji[w8T3f]:SetText(EMOJI_ITEMS[w8T3f].data.utf8_str)NUhYw6R4.emoji[w8T3f]:SetPosition(zhzpBSx.x+46* (vfIyB-1)-545,zhzpBSx.y-qL*42+10,0)NUhYw6R4.emoji[w8T3f]:SetOnClick(function()NUhYw6R4:AddOverrideText(EMOJI_ITEMS[w8T3f].data.utf8_str)end)TjhsnP=TjhsnP+1 end;NUhYw6R4.bganim:SetPosition(0,-140,0)NUhYw6R4.isopen=true;NUhYw6R4:Show()if NUhYw6R4.bgimage.texture then NUhYw6R4.bgimage:Show()else NUhYw6R4.bganim:GetAnimState():PlayAnimation("open")end end)function LB1Z:OnBecomeActive()self._base.OnBecomeActive(self)self.edit_text:SetFocus()self.edit_text:SetEditing(true)end;function LB1Z:Close()if self.isopen then self.writeable=nil;if self.bgimage.texture then self.bgimage:Hide()else self.bganim:GetAnimState():PlayAnimation("close")end;self.black:Kill()self.edit_text:SetEditing(false)self.edit_text:Kill()self.menu:Kill()self.isopen=false;self.inst:DoTaskInTime(.3,function()TheFrontEnd:PopScreen(self)end)end end;function LB1Z:OverrideText(quNsijN)self.edit_text:SetString(quNsijN)self.edit_text:SetFocus()end;function LB1Z:AddOverrideText(QUh2tc)local qboV=self:GetText()or""qboV=qboV..QUh2tc;self.edit_text:SetString(qboV)self.edit_text:SetFocus()self.edit_text:SetEditing(true)end;function LB1Z:GetText()return self.edit_text:GetString()end;function LB1Z:SetValidChars(nSBOx7)self.edit_text:SetCharacterFilter(nSBOx7)end;function LB1Z:OnControl(u,K)if LB1Z._base.OnControl(self,u,K)then return true end;if not K then for i1,zz1QI in ipairs(self.buttons)do if u==zz1QI.control and zz1QI.cb~=nil then zz1QI.cb()return true end end;if u==CONTROL_OPEN_DEBUG_CONSOLE then return true end end end;return LB1Z