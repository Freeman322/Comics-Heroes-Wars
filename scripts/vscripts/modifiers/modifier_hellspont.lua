if modifier_hellspont == nil then
    modifier_hellspont = class ( {})
end

function modifier_hellspont:IsHidden()
    return true
end

function modifier_hellspont:IsPurgable()
    return false
end

function modifier_hellspont:RemoveOnDeath()
    return false
end

function modifier_hellspont:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_hellspont:OnAttackLanded (params)
    if IsServer() then 
        if params.attacker == self:GetParent() then
            self:GetParent():StartGesture(ACT_DOTA_ATTACK_EVENT_BASH)       
        end
    end 
end

function modifier_hellspont:GetAttackSound( params )
    return "Hero_Omniknight.Attack"
end