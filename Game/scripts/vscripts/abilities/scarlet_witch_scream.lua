scarlet_witch_scream = class({})

function scarlet_witch_scream:OnSpellStart()
	local radius = self:GetSpecialValueFor( "area_of_effect" )
	local pfx = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf"
	if self:GetCaster():HasModifier("modifier_arcana") then
		pfx = "particles/units/heroes/hero_bane/bane_projectile.vpcf"
	end
	EmitSoundOn("Hero_QueenOfPain.ScreamOfPain", self:GetCaster())

	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	self.targets = #units
	if #units > 0 then
		for _,target in pairs(units) do
			local info = {
				EffectName = pfx,
				Ability = self,
				iMoveSpeed = 900,
				Source = self:GetCaster(),
				Target = target,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
			}

			ProjectileManager:CreateTrackingProjectile( info )
			if self:GetCaster():HasModifier("modifier_arcana") then
				EmitSoundOn( "Hero_Winter_Wyvern.WintersCurse.Cast", Target )
			end
			EmitSoundOn( "Hero_ArcWarden.Flux.Cast", Target )
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin())
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

function scarlet_witch_scream:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_ArcWarden.Flux.Target", hTarget )
   	   	ApplyDamage({attacker = self:GetCaster(), victim = hTarget, damage = self:GetSpecialValueFor("damage_per_unit")*self.targets + (self:GetAbilityDamage()), ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
	end

	return true
end

function scarlet_witch_scream:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/shazam_blink"
	end
	return self.BaseClass.GetAbilityTextureName(self)
end