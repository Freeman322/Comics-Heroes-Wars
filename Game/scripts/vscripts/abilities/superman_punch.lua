LinkLuaModifier("modifier_superman_punch", "abilities/superman_punch.lua", 0)
LinkLuaModifier("modifier_superman_punch_slow", "abilities/superman_punch.lua", 0)

superman_punch = class ({GetIntrinsicModifierName = function() return "modifier_superman_punch" end})

modifier_superman_punch = class({
	IsHidden = function() return true end,
	IsPurgable = function() return true end,
	DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ORDER, MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE} end
})

function modifier_superman_punch:OnCreated() self.punch = false end

function modifier_superman_punch:OnAttackLanded(params)
	if not IsServer() then return end
	if params.attacker == self:GetParent() and params.attacker:IsRealHero() and self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() and (self:GetAbility():GetAutoCastState() or self.punch) and not (self:GetParent():HasModifier("modifier_superman_laser") or params.target:IsBuilding() or params.target:IsOther() or params.target:GetTeam() == self:GetParent():GetTeam()) then
		local hTarget = params.target

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		hTarget:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", {should_stun = 1, knockback_height = 500, knockback_duration = self:GetAbility():GetSpecialValueFor("fly_duration"), duration = self:GetAbility():GetSpecialValueFor("fly_duration")})
		hTarget:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_superman_punch_slow", {duration = self:GetAbility():GetSpecialValueFor("slow_duration")})

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_walruspunch_txt_ult.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(particle, 2, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 175))
		ParticleManager:ReleaseParticleIndex(particle)

		EmitSoundOn("Hero_Tusk.WalrusPunch.Cast", self:GetParent())
        EmitSoundOn("Hero_Tusk.WalrusPunch.Target", params.target)
        
		self:GetAbility():UseResources(true, false, true)
		self.punch = false
	end
end

function modifier_superman_punch:GetModifierPreAttack_CriticalStrike(params)
	if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() and params.attacker:IsRealHero() and (self:GetAbility():GetAutoCastState() or self.punch) and not (self:GetParent():HasModifier("modifier_superman_laser") or params.target:IsBuilding() or params.target:IsOther() or params.target:GetTeam() == self:GetParent():GetTeam()) then
		return self:GetAbility():GetSpecialValueFor("crit_multiplier") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_superman_1") or 0)
	end
end

function modifier_superman_punch:OnOrder(params)
	if params.unit == self:GetParent() then
		if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and params.ability:GetName() == self:GetAbility():GetName() then
			self.punch = true
		else
			self.punch = false
		end
	end
end
modifier_superman_punch_slow = class({
	DeclareFunctions = function() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
	GetStatusEffectName = function() return "particles/units/heroes/hero_tusk/tusk_walruspunch_status.vpcf" end
})
function modifier_superman_punch_slow:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("slow_pct") * -1 end
