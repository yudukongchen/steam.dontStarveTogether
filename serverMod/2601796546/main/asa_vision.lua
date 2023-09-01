--感谢花花和风铃草各位大佬！
local upvaluehelper = require "components/asa_upvaluehelper"
local easing = require("easing")

AddComponentPostInit("colourcube",function(self, inst)
	self.inst:ListenForEvent("playeractivated",function(inst, player)
		local OnSanityDelta = upvaluehelper.GetEventHandle(self.inst,"sanitydelta","components/colourcube")
		-- if OnSanityDelta and player:HasTag("asakiri") then
			local oldOnSanityDelta = OnSanityDelta
			local function newOnSanityDelta(player, data)
				if player.replica.sanity.mode ~= SANITY_MODE_LUNACY then
					if player:HasTag("asakiri") then
						if player._zanvision:value() ~= 0 or player.maxskill:value() ~= 0 then
							PostProcessor:SetLunacyIntensity(10) --月岛模糊，好像大于1没区别
							PostProcessor:SetZoomBlurEnabled(true) --模糊本体
							PostProcessor:SetOverlayBlend(1) --总特效强度
							PostProcessor:SetColourCubeLerp(1, 0) --San滤镜（1是类型，强度为0）
							PostProcessor:SetColourCubeLerp(2, 0) --月岛滤镜（2是类型，强度为0）
							--distortion是旋转幻影，不明为何是反色，不建议加
							return
						end
					else
						if player.scanvision and player.scanvision:value() ~= 0 then
							PostProcessor:SetLunacyIntensity(10) --月岛模糊，好像大于1没区别
							PostProcessor:SetZoomBlurEnabled(true) --模糊本体
							PostProcessor:SetOverlayBlend(1) --总特效强度
							PostProcessor:SetColourCubeLerp(1, 0) --San滤镜（1是类型，强度为0）
							PostProcessor:SetColourCubeLerp(2, 0) --月岛滤镜（2是类型，强度为0）
							--distortion是旋转幻影，不明为何是反色，不建议加
							return
						end
					end
				end
				oldOnSanityDelta(player, data)
			end
		
		self.inst:RemoveEventCallback("sanitydelta",OnSanityDelta, player)
		self.inst:ListenForEvent("sanitydelta",newOnSanityDelta, player)
		if self.inst:HasTag("asakiri") then
			self.inst:ListenForEvent("asa_zanning",newOnSanityDelta, player) --切换状态滤镜更新一次
			self.inst:ListenForEvent("MaxSkill",newOnSanityDelta, player) --同上，不过是大招
		else
			self.inst:ListenForEvent("ScanVision",newOnSanityDelta, player) --切换状态滤镜更新一次
		end
		-- end
	end,
	_world)
end)



