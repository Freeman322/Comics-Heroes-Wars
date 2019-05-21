if thor_storm_bolt == nil then thor_storm_bolt = class({}) end

function thor_storm_bolt:GetAOERadius()
	return self:GetSpecialValueFor( "bolt_aoe" )
end

function thor_storm_bolt:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_thor_sulfuras") then
		return "custom/thor_stun_sulfuras"
	end
	return "custom/thor_stun"
end


function thor_storm_bolt:OnAbilityPhaseStart()
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_storm_bolt_lightning.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_sword", self:GetCaster():GetOrigin(), true )

	local vLightningOffset = self:GetCaster():GetOrigin() + Vector( 0, 0, 1600 )
	ParticleManager:SetParticleControl( nFXIndex, 1, vLightningOffset )

	ParticleManager:ReleaseParticleIndex( nFXIndex )

	return true
end

--------------------------------------------------------------------------------

function thor_storm_bolt:OnSpellStart()
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	local bolt_speed = self:GetSpecialValueFor( "bolt_speed" )
	local ntfx = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf"
	if self:GetCaster():HasModifier("modifier_thor_sulfuras") then
		ntfx = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast.vpcf"
	end
	local info = {
			EffectName = ntfx,
			Ability = self,
			iMoveSpeed = bolt_speed,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			bDodgeable = true,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = vision_radius,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_Sven.StormBolt", self:GetCaster() )
end

--------------------------------------------------------------------------------

function thor_storm_bolt:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then
		EmitSoundOn( "Hero_Sven.StormBoltImpact", hTarget )
		local bolt_aoe = self:GetSpecialValueFor( "bolt_aoe" )
		local bolt_damage = self:GetAbilityDamage()
		local bolt_stun_duration = self:GetSpecialValueFor( "bolt_stun_duration" )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), hTarget, bolt_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = bolt_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
					
					enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = bolt_stun_duration } )

					ApplyDamage( damage )
				end
			end
		end
	end

	return true
end

function thor_storm_bolt:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

