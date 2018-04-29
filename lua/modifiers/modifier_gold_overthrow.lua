if modifier_gold_overthrow == nil then
    modifier_gold_overthrow = class({})
end

function modifier_gold_overthrow:IsHidden()
    return false
end

function modifier_gold_overthrow:IsPurgable()
    return false
end

function modifier_gold_overthrow:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(1) 
    end
end

function modifier_gold_overthrow:OnIntervalThink()
    if IsServer() then 
        self:GetParent():AddExperience(10, DOTA_ModifyXP_Unspecified, false, true)
    end
end

function modifier_gold_overthrow:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_EXP_RATE_BOOST
    }

    return funcs
end

function modifier_gold_overthrow:GetModifierPercentageExpRateBoost( params )
    return 250
end
