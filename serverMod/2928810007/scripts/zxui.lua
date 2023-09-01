local ZxSkinPopupScreen = require "screens/zxskinscreen"--皮肤界面


AddClassPostConstruct("screens/playerhud",function(self, anim, owner)
	--添加皮肤界面
	self.ShowZxSkinScreen = function(_, attach)
		self.zxskinscreen = ZxSkinPopupScreen(self.owner)
        self:OpenScreenUnderPause(self.zxskinscreen)
        return self.zxskinscreen
	end

    self.CloseZxSkinScreen = function(_)
		if self.zxskinscreen ~= nil then
            if self.zxskinscreen.inst:IsValid() then
                TheFrontEnd:PopScreen(self.zxskinscreen)
            end
            self.zxskinscreen = nil
        end
	end
end)


AddPopup("ZXSKIN")
POPUPS.ZXSKIN.fn = function(inst, show)
    if inst.HUD then
        if not show then
            inst.HUD:CloseZxSkinScreen()
        elseif not inst.HUD:ShowZxSkinScreen() then
            POPUPS.ZXSKIN:Close(inst)
        end
    end
end




local skinentry = require("widgets/zxskinentry")
AddClassPostConstruct("widgets/controls", function(self)
	self.skinentry = self:AddChild(skinentry())
end)


