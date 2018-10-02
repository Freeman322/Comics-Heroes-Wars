if modifier_goldengod == nil then modifier_goldengod = class({}) end


function modifier_goldengod:IsHidden()
	return true
end

function modifier_goldengod:IsPurgable()
	return false
end

function modifier_goldengod:RemoveOnDeath()
	return false
end

function modifier_goldengod:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_goldengod:GetAttackSound( params )
    return "Hero_Invoker.Attack"
end
