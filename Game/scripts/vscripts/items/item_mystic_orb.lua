if item_mystic_orb == nil then item_mystic_orb = class({}) end
LinkLuaModifier ("modifier_item_mystic_orb_active", "items/item_mystic_orb.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_mystic_orb", "items/item_mystic_orb.lua", LUA_MODIFIER_MOTION_NONE)

function item_mystic_orb:GetIntrinsicModifierName ()
    return "modifier_item_mystic_orb"
end

function item_mystic_orb:OnSpellStart ()
    local duration = self:GetSpecialValueFor ("duration")
    local caster = self:GetCaster ()

    caster:AddNewModifier(caster, self, "modifier_item_mystic_orb_active", {duration = duration})
end


if modifier_item_mystic_orb_active == nil then
    modifier_item_mystic_orb_active = class({})
end

function modifier_item_mystic_orb_active:IsPurgable()
    return false
end

function modifier_item_mystic_orb_active:OnCreated( params )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetAbsOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        EmitSoundOn ("Hero_Omniknight.Purification.Wingfall", self:GetParent())
    end
end


function modifier_item_mystic_orb_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end

function modifier_item_mystic_orb_active:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_item_mystic_orb_active:GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetSpecialValueFor("active_bonus_resist")
end


if modifier_item_mystic_orb == nil then
    modifier_item_mystic_orb = class({})
end

function modifier_item_mystic_orb:OnCreated(args)
    self.void_shield = 0
    if IsServer() then
      self:StartIntervalThink(1)
    end
end


function modifier_item_mystic_orb:OnIntervalThink()
    if self.void_shield ~= 0 then
      self.void_shield = self.void_shield - 1
      if self.void_shield <= 0 then
        self.void_shield = 0
      end
    end
end

function modifier_item_mystic_orb:IsHidden()
    return true
end

function modifier_item_mystic_orb:IsPurgable()
    return false
end

function modifier_item_mystic_orb:RemoveOnDeath()
    return false
end

function modifier_item_mystic_orb:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSORB_SPELL,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  	    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
  	    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
  	    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }

    return funcs
end

function modifier_item_mystic_orb:GetAbsorbSpell(keys)
	if self.void_shield == 0  then
        if self.stored ~= nil then
            self.stored:RemoveSelf() --we make sure to remove previous spell.
        end

        local hCaster = self:GetParent()

        EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm.Target", self:GetParent( ))
        EmitSoundOn( "Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent( ))
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Start", self:GetParent())
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())

        if keys.ability:GetAbilityName() == "loki_spell_steal" then
            return nil
        end

        local hAbility = hCaster:AddAbility(keys.ability:GetAbilityName())

        hAbility:SetStolen(true) --just to be safe with some interactions.
        hAbility:SetHidden(true) --hide the ability.
        hAbility:SetLevel(keys.ability:GetLevel()) --same level of ability as the origin.
        hCaster:SetCursorCastTarget(keys.ability:GetCaster()) --lets send this spell back.
        hAbility:OnSpellStart() --cast the spell.
        self.stored = hAbility --store the spell reference for future use.

        ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
        ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
  	    self.void_shield = self:GetAbility():GetSpecialValueFor("void_shield_cd")
        return 1
	end
	return false
end

function modifier_item_mystic_orb:GetModifierPhysicalArmorBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_armor" )
end

function modifier_item_mystic_orb:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_mystic_orb:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_mystic_orb:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_mystic_orb:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end

function modifier_item_mystic_orb:GetModifierPercentageManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_regen" )
end

function modifier_item_mystic_orb:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end

function item_mystic_orb:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

