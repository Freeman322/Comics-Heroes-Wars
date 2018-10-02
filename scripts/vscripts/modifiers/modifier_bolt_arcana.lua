if modifier_bolt_arcana == nil then modifier_bolt_arcana = class({}) end

function modifier_bolt_arcana:IsAura()
	return false
end

function modifier_bolt_arcana:IsHidden()
	return true
end

function modifier_bolt_arcana:IsPurgable()
	return false
end

function modifier_bolt_arcana:RemoveOnDeath()
	return false
end

function modifier_bolt_arcana:GetAuraRadius()
	return 700
end

function modifier_bolt_arcana:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_bolt_arcana:GetAttackSound( params )
    return "Hero_EarthSpirit.Attack.Impact"
end
