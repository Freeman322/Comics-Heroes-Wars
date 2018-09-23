if modifier_khan == nil then modifier_khan = class({}) end

function modifier_khan:RemoveOnDeath()
   return false
end

function modifier_khan:IsPurgable()
   return false
end

function modifier_khan:IsHidden()
   return true
end

function modifier_khan:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_khan:GetAttackSound( params )
    return "Khan.Paradox.Attack"
end
