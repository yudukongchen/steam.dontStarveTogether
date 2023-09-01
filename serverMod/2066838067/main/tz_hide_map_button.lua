
-- TheWorld:DoTaskInTime(0,function() print(TheInput:GetHUDEntityUnderMouse()) end)

-- local function ModifiedToHide(ui)
--     local old_OnShow = ui.OnShow or function()end

--     ui.OnShow = function(self,...)
--         local old_ret = old_OnShow(self,...)
--         self.inst:DoTaskInTime(FRAMES,function ()
--             self:Hide()
--         end)
--         return old_ret
--     end
-- end
-- AddClassPostConstruct("widgets/controls", function(self)
--     ModifiedToHide(self.mapcontrols.minimapBtn)
--     ModifiedToHide(self.mapcontrols.pauseBtn)
--     ModifiedToHide(self.mapcontrols.rotleft)
--     ModifiedToHide(self.mapcontrols.rotright)

--     self.inst:DoTaskInTime(FRAMES,function ()
--         self.mapcontrols.minimapBtn:Hide()
--         self.mapcontrols.pauseBtn:Hide()
--         self.mapcontrols.rotleft:Hide()
--         self.mapcontrols.rotright:Hide()
--     end)
    
-- end)