if modifier_daredevil == nil then modifier_daredevil = class({}) end

function modifier_daredevil:IsAura()
	return false
end

function modifier_daredevil:IsHidden()
	return true
end

function modifier_daredevil:IsPurgable()
	return false
end

function modifier_daredevil:RemoveOnDeath()
	return false
end

function modifier_daredevil:GetAuraRadius()
	return 700
end

function modifier_daredevil:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_daredevil:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_daredevil:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_daredevil:GetModifierAura()
	return "modifier_truesight"
end

function modifier_daredevil:OnCreated(htable)
	self.sound = "Hero_MonkeyKing.Attack"
end

function modifier_daredevil:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_daredevil:GetBonusDayVision( params )
    return 700
end

function modifier_daredevil:GetBonusNightVision( params )
    return 700
end

function modifier_daredevil:GetAttackSound( params )
    return self.sound
end
