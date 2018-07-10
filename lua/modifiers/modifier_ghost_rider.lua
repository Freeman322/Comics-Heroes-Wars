if modifier_ghost_rider == nil then modifier_ghost_rider = class({}) end


function modifier_ghost_rider:IsHidden()
	return true
end

function modifier_ghost_rider:IsPurgable()
	return false
end

function modifier_ghost_rider:RemoveOnDeath()
	return false
end

function modifier_ghost_rider:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_ghost_rider:GetAttackSound( params )
    return "Hero_Sniper.MKG_attack"
end
