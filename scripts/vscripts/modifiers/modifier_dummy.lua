if modifier_dummy == nil then modifier_dummy = class({}) end 

function modifier_dummy:IsHidden()
    return true
end

function modifier_dummy:IsPurgable()
    return false
end

function modifier_dummy:RemoveOnDeath()
    return false
end
