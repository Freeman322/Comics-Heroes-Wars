LinkLuaModifier( "modifier_nightbringer_void", "abilities/nightbringer_void.lua", LUA_MODIFIER_MOTION_NONE )

nightbringer_void = class({})

function nightbringer_void:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_VengefulSpirit.MagicMissileImpact", hTarget )

		local movespeed_slow = self:GetSpecialValueFor( "movespeed_slow" )
		local attackspeed_slow = self:GetSpecialValueFor( "attackspeed_slow" )
		local duration = self:GetSpecialValueFor( "duration" )
		local damage = self:GetSpecialValueFor( "damage" )

		local vPos2 = hTarget:GetOrigin()
		GridNav:DestroyTreesAroundPoint( vPos2, 300, false)

		local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
		ParticleManager:SetParticleControlEnt( nCasterFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
		ParticleManager:ReleaseParticleIndex( nCasterFX )

		local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
		ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
		ParticleManager:ReleaseParticleIndex( nTargetFX )

		EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hCaster )
		EmitSoundOn( "Hero_Nightstalker.Void.Nihility", hTarget )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self
		}


		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_nightbringer_void", { duration = duration } )
		
		ApplyDamage( damage )
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_nightbringer_void = class({})
--------------------------------------------------------------------------------

function modifier_nightbringer_void:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end
-------------------------------------------------------------------------------
function modifier_nightbringer_void:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_nightbringer_void:GetStatusEffectName()
	return "particles/units/heroes/hero_night_stalker/nightstalker_void.vpcf"
end

--------------------------------------------------------------------------------

function modifier_nightbringer_void:StatusEffectPriority()
	return 1000
end

--------------------------------------------------------------------------------

function modifier_nightbringer_void:GetHeroEffectName()
	return "particles/units/heroes/hero_night_stalker/nightstalker_void.vpcf"
end

--------------------------------------------------------------------------------

function modifier_nightbringer_void:HeroEffectPriority()
	return 100
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function modifier_nightbringer_void:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
end

--------------------------------------------------------------------------------

function modifier_nightbringer_void:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor( "attackspeed_slow" )
end

function nightbringer_void:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

