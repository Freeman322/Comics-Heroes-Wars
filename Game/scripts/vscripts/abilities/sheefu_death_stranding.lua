sheefu_death_stranding = class ( {})

LinkLuaModifier ("modifier_sheefu_death_stranding", "abilities/sheefu_death_stranding.lua", LUA_MODIFIER_MOTION_NONE)

local MICRO_BASH_DURATION = 0.35

function sheefu_death_stranding:CastFilterResultTarget (hTarget)
    if IsServer () then
        local nResult = UnitFilter (hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end

function sheefu_death_stranding:GetAbilityDamageType()
    return DAMAGE_TYPE_MAGICAL
end

function sheefu_death_stranding:GetCooldown (nLevel)
    if self:GetCaster ():HasScepter () then
        return 40
    end

    return self.BaseClass.GetCooldown (self, nLevel)
end
--------------------------------------------------------------------------------

function sheefu_death_stranding:GetCastRange (vLocation, hTarget)
    return self.BaseClass.GetCastRange (self, vLocation, hTarget)
end

function sheefu_death_stranding:OnSpellStart ()
     if IsServer() then 
          local hTarget = self:GetCursorTarget ()
          if hTarget ~= nil then
               if ( not hTarget:TriggerSpellAbsorb (self) ) then
                    EmitSoundOn ("Hero_AbyssalUnderlord.DarkRift.Complete", self:GetCaster () )

                    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abbysal_underlord_darkrift_ambient_end.vpcf", PATTACH_CUSTOMORIGIN, hTarget );
                    ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetOrigin());
                    ParticleManager:SetParticleControl( nFXIndex, 2, hTarget:GetOrigin());
                    ParticleManager:SetParticleControl( nFXIndex, 5, hTarget:GetOrigin());
                    ParticleManager:ReleaseParticleIndex( nFXIndex );

                    hTarget:Stop()
                    hTarget:Interrupt()
                    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = MICRO_BASH_DURATION } )

                    hTarget:AddNewModifier( self:GetCaster(), self, "modifier_sheefu_death_stranding", { duration = self:GetSpecialValueFor("duration") } )
               end
          end
     end
end


modifier_sheefu_death_stranding = class ( {})

function modifier_sheefu_death_stranding:IsHidden()
    return false
end

function modifier_sheefu_death_stranding:IsBuff()
    return false
end

function modifier_sheefu_death_stranding:IsPurgable()
    return false
end

function modifier_sheefu_death_stranding:GetPriority()
  return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_sheefu_death_stranding:GetStatusEffectName()
    return "particles/status_fx/status_effect_phantom_lancer_illusion.vpcf"
end

function modifier_sheefu_death_stranding:StatusEffectPriority()
    return 1000
end

function modifier_sheefu_death_stranding:GetEffectName()
     return "particles/econ/items/warlock/warlock_ti9/warlock_ti9_shadow_word_debuff.vpcf"
end

function modifier_sheefu_death_stranding:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_sheefu_death_stranding:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE, MODIFIER_PROPERTY_MOVESPEED_MAX} end

function modifier_sheefu_death_stranding:OnTakeDamage (params)
     if IsServer() then
          if params.attacker == self:GetCaster() and params.attacker:IsRealHero() and not params.attacker:IsSilenced() then
               if params.unit:IsHero() and params.damage_type == DAMAGE_TYPE_PHYSICAL then
                    local damage = self:GetParent():GetMana() * (self:GetAbility():GetSpecialValueFor("mana_burn_pct") / 100)
                    self:GetParent():SpendMana(damage, self:GetAbility())

                    ApplyDamage( {
                         victim = self:GetParent(),
                         attacker = self:GetAbility():GetCaster(),
                         damage = damage,
                         damage_type = DAMAGE_TYPE_MAGICAL,
                         ability = self:GetAbility()
                     })
               end
          end
     end
end

function modifier_sheefu_death_stranding:GetModifierMoveSpeedOverride (params)
     return 100
end

function modifier_sheefu_death_stranding:GetModifierMoveSpeed_Max (params)
     return 100
end

function modifier_sheefu_death_stranding:GetModifierMoveSpeed_Absolute (params)
     return 100
end

function modifier_sheefu_death_stranding:CheckState()
	local state = {
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true
	}

	return state
end
