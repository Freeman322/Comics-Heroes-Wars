apocalypse_revalation = class({})
LinkLuaModifier( "modifier_apocalypse_revalation", "abilities/apocalypse_revalation.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_apocalypse_revalation_target", "abilities/apocalypse_revalation.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function apocalypse_revalation:OnSpellStart()
	local info = {
			EffectName = "particles/units/heroes/hero_oracle/oracle_fortune_prj.vpcf",
			Ability = self,
			iMoveSpeed = 1200,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_Oracle.FortunesEnd.Target", self:GetCaster() )
end

--------------------------------------------------------------------------------

function apocalypse_revalation:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_Oracle.FatesEdict", hTarget )
		local dur = self:GetSpecialValueFor("intelligence_stole_dur")
		local bonus = 0

		if self:GetCaster():HasModifier("modifier_apocalypse_essence_shift_caster") then
			local buff = self:GetCaster():FindModifierByName("modifier_apocalypse_essence_shift_caster")
			bonus = buff:GetStackCount()
		end

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_apocalypse_revalation_target", { duration = dur } )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_apocalypse_revalation", { duration = dur } )
		
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage() + bonus + self:GetCaster():GetIntellect(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return true
end

if modifier_apocalypse_revalation == nil then modifier_apocalypse_revalation = class({}) end

function modifier_apocalypse_revalation:IsPurgable()
	return false
end

function modifier_apocalypse_revalation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function modifier_apocalypse_revalation:GetModifierBonusStats_Intellect( params )
	return self:GetAbility():GetSpecialValueFor("intelligence_stole")
end

if modifier_apocalypse_revalation_target == nil then modifier_apocalypse_revalation_target = class({}) end

function modifier_apocalypse_revalation_target:IsPurgable()
	return false
end

function modifier_apocalypse_revalation_target:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function modifier_apocalypse_revalation_target:GetModifierBonusStats_Intellect( params )
	return self:GetAbility():GetSpecialValueFor("intelligence_stole")*(-1)
end

function apocalypse_revalation:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

