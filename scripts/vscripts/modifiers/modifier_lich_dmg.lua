modifier_lich_dmg = class({})

function modifier_lich_dmg:IsPurgable()
    return false
end

function modifier_lich_dmg:RemoveOnDeath()
    return false
end

function modifier_lich_dmg:IsHidden()
    return false
end
