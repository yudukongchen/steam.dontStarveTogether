local TzUtil = require("tz_util")
local TzWeaponSkillUtil = require("tz_weaponskill_util")

local assets = {
	Asset("ANIM", "anim/tz_killknife.zip"),
	Asset("ANIM", "anim/swap_tz_killknife.zip"),
		
	Asset("IMAGE","images/inventoryimages/tz_killknife.tex"),
	Asset("ATLAS","images/inventoryimages/tz_killknife.xml"),
	
	Asset( "SOUND" , "sound/tz_killknife_fx.fsb" ),
	Asset( "SOUNDPACKAGE" , "sound/tz_killknife_fx.fev" ),
}

local function ClientFn(inst)
	TzWeaponSkillUtil.AddAoetargetingClient(inst,"point",{"tz_killknife","key_castable_aoeweapon"},8,function()
		inst.components.aoetargeting:SetAlwaysValid(true)
		inst.components.aoetargeting.reticule.reticuleprefab = ""
		inst.components.aoetargeting.reticule.pingprefab = ""
	end)
	
	MakeInventoryFloatable(inst, "small", 0.2)
end 

local function OnAttack(inst,attacker,target)
	local self = inst.components.rechargeable
	if not self.isready then 
		local add_per_frame = 180 * FRAMES / (self.rechargetime * (self.pickup and 1 or self:GetCoolDownRate()))
		local add_per_second =  add_per_frame / FRAMES
		self.recharge = self.recharge + add_per_second
		self.inst:PushEvent("rechargechange", { percent = self.recharge and self.recharge / 180, overtime = false })
	end 
	
	SpawnAt("tz_killknife_fx",target:GetPosition()+Vector3(0,1,0)).Transform:SetScale(2,2,2)
end 

local function OnSpell(inst,attacker,pos)
	local weapon = attacker.components.combat:GetWeapon()
	local damage = weapon and weapon.components.weapon.damage or 10
			
	local newnums = 10 --math.random(4,6)
	local newdamage = 51
	local roa_little = math.random()*2*math.pi
			
	local sleeptime = 0.15 --math.min(0.1,0.4/newnums)
	local rad = 4.5
	
	attacker.Transform:SetPosition(pos:Get())
	attacker:StartThread(function()
		--[[for roa = roa_little,2*math.pi + roa_little,2*math.pi/newnums  do
			local offset = Vector3(math.cos(roa)*rad,0,math.sin(roa)*rad)
			local shadow = SpawnAt("tz_shadow_killknife",pos+offset)
			shadow:ForceFacePoint(pos:Get())
			shadow:SetDamage(newdamage)
			shadow:Init(attacker,nil,nil,nil,true)
			shadow:StartShadows()
			Sleep(sleeptime)
		end--]]
		for i = 1,newnums do 
			local roa = math.random()*2*math.pi
			local offset = Vector3(math.cos(roa)*rad,0,math.sin(roa)*rad)
			local shadow = SpawnAt("tz_shadow_killknife",pos+offset)
			shadow:ForceFacePoint(pos:Get())
			shadow:SetDamage(newdamage)
			shadow:Init(attacker,nil,nil,nil,true)
			shadow:StartShadows()
			Sleep(sleeptime)
		end
	end)
	
	inst.components.rechargeable:StartRecharge()
end 

local function ServerFn(inst)
	TzWeaponSkillUtil.AddAoetargetingServer(inst,OnSpell,nil,25,function()
		
	end)
	inst.components.weapon:SetOnAttack(OnAttack)
end

STRINGS.NAMES.TZ_KILLKNIFE = "刺杀匕首"
STRINGS.RECIPE_DESC.TZ_KILLKNIFE = "只有疼痛才能让你忘记悲伤"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TZ_KILLKNIFE = "爱之绝杀！"
STRINGS.ACTIONS.CASTAOE.TZ_KILLKNIFE = "分身斩"

return TzUtil.CreateWeapon("tz_killknife",assets,nil,"tz_killknife","tz_killknife","idle",nil,
51,nil,500,ClientFn,ServerFn),
TzUtil.CreateFx("tz_killknife_fx",nil,nil,nil,nil,nil,nil,function(inst)
	inst.AnimState:PlayAnimation("hit"..math.random(0,2))
end)