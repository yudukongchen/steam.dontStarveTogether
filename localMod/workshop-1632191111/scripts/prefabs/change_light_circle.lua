local assets =---���Ԥ��������Ĳ����ļ�����������ͼ�ȵȣ�
{
Asset("ANIM", "anim/change_light_circle.zip"),

}




local function fn()
	local inst = CreateEntity()--���������䶼��Ĭ��Ҫ��ӵģ�����Ͳ�������ô����
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	anim:SetBank("change_light_circle")-----ǰ��������ָ��icey_kill_fx��ͼƬ�߽�Ͳ��ʣ�����Ч�����ò���ֻ�Ǳ�д��
	anim:SetBuild("change_light_circle")
	--anim:PlayAnimation("pre")
	--anim:PushAnimation("loop",true)
	
	anim:SetOrientation(ANIM_ORIENTATION.OnGround)
	
    anim:SetLayer(LAYER_WORLD_BACKGROUND)
    anim:SetSortOrder(3)
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false 
	
	inst:AddComponent("spawnfader")
	
	inst.FadeIn = function(self)
		self.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
		self.components.spawnfader:FadeIn()
		self.AnimState:PlayAnimation("fadein")
		self.AnimState:PushAnimation("idle",true)
		self:StartCircles()
	end
	
	inst.FadeOut = function(self)
		self.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
		self.AnimState:PlayAnimation("fadeout")
		self:ListenForEvent("animover",self.Remove)
	end
	
	inst.StartCircles = function(self)
		self:StopCircles()
		self.CirclesTask = self:DoPeriodicTask(0,function()
			local roa = inst:GetRotation()
			inst.Transform:SetRotation(roa+1)
		end)
	end 
	
	inst.StopCircles = function(self)
		if self.CirclesTask then 
			self.CirclesTask:Cancel()
			self.CirclesTask = nil 
		end
	end


	return inst
end

return Prefab("change_light_circle", fn, assets)

