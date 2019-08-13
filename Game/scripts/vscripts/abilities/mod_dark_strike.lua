mod_dark_strike = class({})
LinkLuaModifier( "modifier_mod_dark_strike",   "abilities/mod_dark_strike.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function mod_dark_strike:OnAbilityPhaseStart()
	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/lifestealer/lifestealer_immortal_backbone_gold/lifestealer_immortal_backbone_gold_rage_cast_flashnoise.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
     ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
     ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
     ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )

	local vLightningOffset = self:GetCaster():GetOrigin() + Vector( 0, 0, 1600 )
	ParticleManager:SetParticleControl( nFXIndex, 1, vLightningOffset )

	ParticleManager:ReleaseParticleIndex( nFXIndex )

	return true
end

--------------------------------------------------------------------------------

function mod_dark_strike:OnSpellStart()
     if IsServer() then
          local info = {
                    EffectName = "particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf",
                    Ability = self,
                    iMoveSpeed = 1600,
                    Source = self:GetCaster(),
                    Target = self:GetCursorTarget(),
                    bDodgeable = true,
                    bProvidesVision = true,
                    iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
                    iVisionRadius = 100,
                    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2, 
               }
     
          ProjectileManager:CreateTrackingProjectile( info )

          EmitSoundOn( "Hero_Terrorblade.Metamorphosis.Fear", self:GetCaster() )
     end 
end

--------------------------------------------------------------------------------

function mod_dark_strike:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then
		EmitSoundOn( "Hero_Terrorblade_Morphed.projectileImpact", hTarget )
          
          local duration = self:GetSpecialValueFor( "duration" )

          if self:GetCaster():HasTalent("special_bonus_unique_mod_3") then
               duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_mod_3")
          end

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_mod_dark_strike", { duration = duration } )
	end

	return true
end

modifier_mod_dark_strike = class({})

local EF_MAX_REDUCTION = -60

function modifier_mod_dark_strike:IsHidden()
    return false
end

function modifier_mod_dark_strike:GetEffectName()
	return "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
end

function modifier_mod_dark_strike:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_mod_dark_strike:OnCreated(params)
     if IsServer() then
          self.m_iDamageIncr = self:GetAbility():GetSpecialValueFor("damage_incomin_per_second")

          if self:GetCaster():HasTalent("special_bonus_unique_mod_4") then
               self.m_iDamageIncr = self.m_iDamageIncr + self:GetCaster():FindTalentValue("special_bonus_unique_mod_4")
          end

          self:StartIntervalThink(1)
          self:SetStackCount(1)
          self:OnIntervalThink()
     end 
end

function modifier_mod_dark_strike:IsPurgable()
    return false
end

function modifier_mod_dark_strike:OnIntervalThink()
     if IsServer() then
          self:IncrementStackCount()
          ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage =self:GetAbility():GetSpecialValueFor("damage_per_second"), damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE})
     end
end

function modifier_mod_dark_strike:DeclareFunctions() 
    local funcs = {
          MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
          MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
    return funcs
end

function modifier_mod_dark_strike:GetModifierIncomingDamage_Percentage( params )
     if IsServer() then
          return self.m_iDamageIncr * self:GetStackCount()
     end 
end

function modifier_mod_dark_strike:GetModifierMoveSpeedBonus_Percentage( params )
     return self:GetAbility():GetSpecialValueFor("move_speed_slow_pct") * (-1)
end