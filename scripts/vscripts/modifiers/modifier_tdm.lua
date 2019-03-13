if modifier_tdm == nil then
    modifier_tdm = class({})
end

function modifier_tdm:IsHidden()
    return false
end

function modifier_tdm:IsPurgable()
    return false
end

function modifier_tdm:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(1) 
    end
end

function modifier_tdm:OnIntervalThink()
    if IsServer() then 
        self:GetParent():AddExperience(10, DOTA_ModifyXP_Unspecified, false, true)
    end
end

function modifier_tdm:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_EXP_RATE_BOOST
    }

    return funcs
end

function modifier_tdm:GetModifierPercentageExpRateBoost( params )
    return 250
end
