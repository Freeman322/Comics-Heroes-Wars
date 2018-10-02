if modifier_sargeras_arcana == nil then modifier_sargeras_arcana = class({}) end


function modifier_sargeras_arcana:IsHidden()
	return true
end

function modifier_sargeras_arcana:IsPurgable()
	return false
end

function modifier_sargeras_arcana:RemoveOnDeath()
	return false
end

function modifier_sargeras_arcana:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_sargeras_arcana:GetAttackSound( params )
    return "Hero_AbyssalUnderlord.Attack"
end
