if gambit_magic_card == nil then gambit_magic_card = class({}) end

LinkLuaModifier( "modifier_gambit_magic_card", "abilities/gambit_magic_card.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gambit_magic_card:OnSpellStart()
	local info = {
			EffectName = "particles/hero_gambit/magic_card_projectile.vpcf",
			Ability = self,
			iMoveSpeed = 1000,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_VengefulSpirit.MagicMissile", self:GetCaster() )
end

--------------------------------------------------------------------------------

function gambit_magic_card:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_StormSpirit.Overload", hTarget )
		EmitSoundOn( "Hero_StormSpirit.Overload", hTarget )

		
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, hTarget, PATTACH_POINT_FOLLOW, "attach_head", hTarget:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local enemy = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), self:GetCaster(), self:GetSpecialValueFor("bolt_aoe"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemy > 0 then
			for _,target in pairs(enemy) do
				target:AddNewModifier( self:GetCaster(), self, "modifier_gambit_magic_card", { duration = self:GetSpecialValueFor( "slow_duration" ) } )
				target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor( "stun_duration" ) } )
			end
		end
		
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return true
end

if modifier_gambit_magic_card == nil then modifier_gambit_magic_card = class({}) end

function modifier_gambit_magic_card:GetStatusEffectName()
    return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end

function modifier_gambit_magic_card:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }

    return funcs
end

function modifier_gambit_magic_card:GetModifierMoveSpeedBonus_Percentage( event )
    return self:GetAbility():GetSpecialValueFor("slow_pct")
end

function modifier_gambit_magic_card:IsHidden()
    return true
end

function modifier_gambit_magic_card:IsDebuff()
    return true
end

function modifier_gambit_magic_card:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function gambit_magic_card:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

