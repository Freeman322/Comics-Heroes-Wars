ostarion_mortal_strike = class({})
LinkLuaModifier( "modifier_ostarion_mortal_strike", "abilities/ostarion_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ostarion_mortal_strike_devour", "abilities/ostarion_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )

function ostarion_mortal_strike:GetIntrinsicModifierName()
     return "modifier_ostarion_mortal_strike"
end

function ostarion_mortal_strike:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function ostarion_mortal_strike:OnSpellStart()
    if IsServer() then
      local hTarget = self:GetCursorTarget()
      if hTarget ~= nil then
        self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true)
      end
    end
end

if modifier_ostarion_mortal_strike == nil then modifier_ostarion_mortal_strike = class({}) end

function modifier_ostarion_mortal_strike:IsHidden()
    return false
end

function modifier_ostarion_mortal_strike:IsPurgable()
    return false
end

function modifier_ostarion_mortal_strike:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_ostarion_mortal_strike:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() then
                if not params.target:IsBuilding() and not params.target:IsAncient() then
                    if self:GetCaster():HasTalent("special_bonus_unique_ostarion_5") then
                        params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ostarion_mortal_strike_devour", {duration = self:GetAbility():GetSpecialValueFor("devour_duration")})
                    end

                    self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))

                    local flDamage = params.target:GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("heal_drain_ptc") / 100)

                    self:GetCaster():Heal(flDamage, self:GetAbility())
                    
                    local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal_old.vpcf", PATTACH_CUSTOMORIGIN, nil );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetOrigin(), true );
                    ParticleManager:ReleaseParticleIndex( nFXIndex );

                    EmitSoundOn("Hero_LifeStealer.Assimilate.Destroy", params.target)

                    ApplyDamage ( {
                        victim = params.target,
                        attacker = self:GetCaster(),
                        damage = flDamage,
                        damage_type = self:GetAbility():GetAbilityDamageType(),
                        ability = self:GetAbility(),
                        damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                    })
                end
            end
        end
    end
    return 0
end


if modifier_ostarion_mortal_strike_devour == nil then modifier_ostarion_mortal_strike_devour = class ( {}) end

function modifier_ostarion_mortal_strike_devour:GetEffectName ()
    return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_ostarion_mortal_strike_devour:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ostarion_mortal_strike_devour:OnCreated(event)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            self:GetParent():Kill(self:GetAbility(), self:GetCaster())
        end
    end
end

function modifier_ostarion_mortal_strike_devour:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_DISABLE_HEALING
	}
	return funcs
end


function modifier_ostarion_mortal_strike_devour:GetDisableHealing( params )
	return 1 
end