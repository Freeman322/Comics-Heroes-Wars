modifier_death_dress = class({})

function modifier_death_dress:IsPurgable()
    return false
end

function modifier_death_dress:RemoveOnDeath()
    return false
end

function modifier_death_dress:IsHidden()
    return true
end
