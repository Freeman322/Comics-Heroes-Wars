item_star_boots = class({}) 

LinkLuaModifier ("modifier_item_star_boots", "items/item_star_boots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_star_boots_phase", "items/item_star_boots.lua", LUA_MODIFIER_MOTION_NONE)

function item_star_boots:GetIntrinsicModifierName()
    return "modifier_item_star_boots"
end

function item_star_boots:OnSpellStart()
    if IsServer() then
        EmitSoundOn ("Khan.Paradox.Cast", self:GetCaster ())
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_star_boots_phase", {duration = self:GetSpecialValueFor("phase_duration")})
    end
end

modifier_item_star_boots = class({}) 

function modifier_item_star_boots:IsPurgable()
    return false
end

function modifier_item_star_boots:IsHidden()
    return true
end

function modifier_item_star_boots:RemoveOnDeath()
    return false
end

function modifier_item_star_boots:DeclareFunctions()
    local func = { 
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_EVASION_CONSTANT 
    }

    return func
end

function modifier_item_star_boots:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_star_boots:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_star_boots:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_star_boots:GetModifierEvasion_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_evasion")
end

function modifier_item_star_boots:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_movespeed_pct") 
end

function modifier_item_star_boots:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") 
end

modifier_item_star_boots_phase = class({}) 

function modifier_item_star_boots_phase:GetEffectName()
    return "particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_path_owner_impact.vpcf"
end

function modifier_item_star_boots_phase:IsHidden()
	return false
end

function modifier_item_star_boots_phase:IsPurgable()
	return true
end

function modifier_item_star_boots_phase:DeclareFunctions()
    local func = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return func
end

function modifier_item_star_boots_phase:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("phase_movespeed")
end

function modifier_item_star_boots_phase:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("phase_bonus_damage") * self:GetCaster():GetIdealSpeed() / 100
end

function modifier_item_star_boots_phase:CheckState ()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }

    return state
end
