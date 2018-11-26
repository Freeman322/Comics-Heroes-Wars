cap_warcry = class({})
LinkLuaModifier( "modifier_cap_warcry", "abilities/cap_warcry.lua",LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function cap_warcry:OnSpellStart()
    local warcry_duration = self:GetSpecialValueFor(  "warcry_duration" )
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_cap_warcry", { duration = warcry_duration } )

    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alisa") == true then
        EmitSoundOn( "Alisa.Third.Cast", self:GetCaster() )
    else 
        EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )
    end 

    self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_cap_warcry = class({})
--------------------------------------------------------------------------------

function modifier_cap_warcry:OnCreated( kv )
    self.warcry_armor = self:GetAbility():GetSpecialValueFor( "warcry_armor" )
    self.warcry_movespeed = self:GetAbility():GetSpecialValueFor( "warcry_movespeed" )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

--------------------------------------------------------------------------------

function modifier_cap_warcry:OnRefresh( kv )
    self.warcry_armor = self:GetAbility():GetSpecialValueFor( "warcry_armor" )
    self.warcry_movespeed = self:GetAbility():GetSpecialValueFor( "warcry_movespeed" )
end

--------------------------------------------------------------------------------

function modifier_cap_warcry:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_cap_warcry:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function modifier_cap_warcry:StatusEffectPriority()
    return 1000
end

--------------------------------------------------------------------------------

function modifier_cap_warcry:GetHeroEffectName()
    return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

--------------------------------------------------------------------------------

function modifier_cap_warcry:HeroEffectPriority()
    return 100
end

function modifier_cap_warcry:GetActivityTranslationModifiers( params )
    if self:GetParent() == self:GetCaster() then
        return "sven_warcry"
    end

    return 0
end

--------------------------------------------------------------------------------
function modifier_cap_warcry:GetModifierTotalDamageOutgoing_Percentage()
    return self.warcry_movespeed
end
--------------------------------------------------------------------------------

function modifier_cap_warcry:GetModifierAttackSpeedBonus_Constant( params )
    return self.warcry_armor
end

function modifier_cap_warcry:GetModifierDamageOutgoing_Percentage( params )
    return self:GetAbility():GetSpecialValueFor("warcry_damage")
end

function modifier_cap_warcry:GetAttackSound( params )
    if self:GetParent():HasModifier("modifier_alisa") then 
        return "Alisa.Attack"
    end 
end


--------------------------------------------------------------------------------

function cap_warcry:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

