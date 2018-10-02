ursa_battle_trance = class({})
LinkLuaModifier( "ursa_battle_trance_modifier", "abilities/ursa_battle_trance.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function ursa_battle_trance:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 12
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end
--------------------------------------------------------------------------------

function ursa_battle_trance:IsHiddenWhenStolen()
    return true
end
function ursa_battle_trance:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function ursa_battle_trance:OnSpellStart()
    local duration = self:GetSpecialValueFor( "duration" )
    if self:GetCaster():HasScepter() then
        duration = self:GetSpecialValueFor( "duration_scepter" )
    end
    local caster = self:GetCaster()
    caster:AddNewModifier( self:GetCaster(), self, "modifier_oracle_false_promise", { duration = duration } )
    caster:AddNewModifier( self:GetCaster(), self, "modifier_oracle_false_promise_timer", { duration = duration } )
    caster:AddNewModifier( self:GetCaster(), self, "ursa_battle_trance_modifier", { duration = duration } )
    EmitSoundOn("Hero_Ursa.Enrage", self:GetCaster() )
end

--------------------------------------------------------------------------------

ursa_battle_trance_modifier = class({})

function ursa_battle_trance_modifier:GetStatusEffectName()
    return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function ursa_battle_trance_modifier:IsHidden()
    return true
end

function ursa_battle_trance_modifier:IsBuff()
    return true
end

function ursa_battle_trance_modifier:IsPurgable()
    return false
end

function ursa_battle_trance:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

