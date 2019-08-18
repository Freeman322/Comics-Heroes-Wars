item_aether_staff = class({})

LinkLuaModifier("modifier_item_aether_staff", "items/item_aether_staff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_aether_staff_active", "items/item_aether_staff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_aether_staff_active_debuff", "items/item_aether_staff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_butcher_meat_hook", "abilities/butcher_meat_hook.lua", LUA_MODIFIER_MOTION_BOTH)
function item_aether_staff:GetIntrinsicModifierName()
	return "modifier_item_aether_staff"
end

modifier_item_aether_staff = class({})

function modifier_item_aether_staff:IsHidden() return true end
function modifier_item_aether_staff:IsPurgable() return false end
function modifier_item_aether_staff:IsDebuff() return false end
function modifier_item_aether_staff:RemoveOnDeath() return false end
function modifier_item_aether_staff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_aether_staff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_item_aether_staff:GetModifierConstantManaRegen()	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
function modifier_item_aether_staff:GetModifierConstantHealthRegen()  return self:GetAbility():GetSpecialValueFor("bonus_hp_reg") end
function modifier_item_aether_staff:GetModifierPhysicalArmorBonus()  return self:GetAbility():GetSpecialValueFor("bonus_armor") end
function modifier_item_aether_staff:GetModifierBonusStats_Strength()  return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_item_aether_staff:GetModifierMagicalResistanceBonus()  return self:GetAbility():GetSpecialValueFor("bonus_magical_armor") end
function modifier_item_aether_staff:GetModifierBonusStats_Agility()	return self:GetAbility():GetSpecialValueFor("bonus_agility") end
function modifier_item_aether_staff:GetModifierBonusStats_Intellect()	return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_item_aether_staff:GetModifierMoveSpeedBonus_Constant()	return self:GetAbility():GetSpecialValueFor("bonus_movement") end

function item_aether_staff:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if caster:GetTeamNumber() ~= target:GetTeamNumber() then
		target:Purge(true, false, false, false, false)
		target:AddNewModifier(caster, self, "modifier_item_aether_staff_active_debuff", {duration = self:GetSpecialValueFor("duration")})
	else
		caster:Purge(false, true, false, false, false)
		target:AddNewModifier(caster, self, "modifier_item_aether_staff_active", {duration = self:GetSpecialValueFor("duration")})
	end
end

modifier_item_aether_staff_active = class({})

function modifier_item_aether_staff_active:IsDebuff() return false end
function modifier_item_aether_staff_active:IsHidden() return false end
function modifier_item_aether_staff_active:IsPurgable() return true end
function modifier_item_aether_staff_active:IsStunDebuff() return true end
function modifier_item_aether_staff_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_item_aether_staff_active:OnCreated()
	EmitSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())

	if IsServer() then
		self.angle = self:GetParent():GetAngles()
		self.abs = self:GetParent():GetAbsOrigin()
		self.cyc_pos = self:GetParent():GetAbsOrigin()

		self.pfx_name = "particles/econ/events/ti7/cyclone_ti7.vpcf"
		self.pfx = ParticleManager:CreateParticle(self.pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self.abs)		

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_item_aether_staff_active:OnIntervalThink()
	if not IsServer() then return end
	local angle = self:GetParent():GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0,20,0))
	self:GetParent():SetAngles(new_angle[1], new_angle[2], new_angle[3])
	if self:GetElapsedTime() <= 0.3 then
		self.cyc_pos.z = self.cyc_pos.z + 50
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	elseif self:GetDuration() - self:GetElapsedTime() < 0.3 then
		self.step = self.step or (self.cyc_pos.z - self.abs.z) / ((self:GetDuration() - self:GetElapsedTime()) / FrameTime())
		self.cyc_pos.z = self.cyc_pos.z - self.step
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	end
end

function modifier_item_aether_staff_active:OnDestroy()
	StopSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)

	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	self:GetParent():SetAbsOrigin(self.abs)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	self:GetParent():SetAngles(self.angle[1], self.angle[2], self.angle[3])
end

function modifier_item_aether_staff_active:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end

function modifier_item_aether_staff_active:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end

modifier_item_aether_staff_active_debuff = class({})

function modifier_item_aether_staff_active_debuff:IsDebuff() return true end
function modifier_item_aether_staff_active_debuff:IsHidden() return false end
function modifier_item_aether_staff_active_debuff:IsPurgable() return true end
function modifier_item_aether_staff_active_debuff:IsStunDebuff() return true end
function modifier_item_aether_staff_active_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_item_aether_staff_active_debuff:OnCreated()
	EmitSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())

	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_FLAIL)
		self.angle = self:GetParent():GetAngles()
		self.abs = self:GetParent():GetAbsOrigin()
		self.cyc_pos = self:GetParent():GetAbsOrigin()

		self.pfx_name = "particles/econ/events/ti7/cyclone_ti7.vpcf"
		self.pfx = ParticleManager:CreateParticle(self.pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self.abs)

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_item_aether_staff_active_debuff:OnIntervalThink()
	if not IsServer() then return end
	local angle = self:GetParent():GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0,20,0))
	self:GetParent():SetAngles(new_angle[1], new_angle[2], new_angle[3])
	if self:GetElapsedTime() <= 0.3 then
		self.cyc_pos.z = self.cyc_pos.z + 50
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	elseif self:GetDuration() - self:GetElapsedTime() < 0.3 then
		self.step = self.step or (self.cyc_pos.z - self.abs.z) / ((self:GetDuration() - self:GetElapsedTime()) / FrameTime())
		self.cyc_pos.z = self.cyc_pos.z - self.step
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	end
end

function modifier_item_aether_staff_active_debuff:OnDestroy()
	StopSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)

	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	self:GetParent():SetAbsOrigin(self.abs)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	self:GetParent():SetAngles(self.angle[1], self.angle[2], self.angle[3])

	local damageTable = {victim = self:GetParent(),
						attacker = self:GetCaster(),
						damage = self:GetAbility():GetSpecialValueFor("tooltip_drop_damage"),
						damage_type = DAMAGE_TYPE_PURE,
						ability = self:GetAbility()}
	ApplyDamage(damageTable)
end

function modifier_item_aether_staff_active_debuff:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end

function modifier_item_aether_staff_active_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end

