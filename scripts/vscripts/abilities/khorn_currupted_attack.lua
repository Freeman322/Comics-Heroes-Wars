LinkLuaModifier ("modifier_khorn_currupted_attack", "abilities/khorn_currupted_attack.lua", LUA_MODIFIER_MOTION_NONE)

if khorn_currupted_attack == nil then
    khorn_currupted_attack = class ( {})
end

function khorn_currupted_attack:GetIntrinsicModifierName ()
    return "modifier_khorn_currupted_attack"
end

if modifier_khorn_currupted_attack == nil then
    modifier_khorn_currupted_attack = class ( {})
end

function modifier_khorn_currupted_attack:IsHidden()
    return true
end

function modifier_khorn_currupted_attack:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }

    return funcs
end

function modifier_khorn_currupted_attack:GetModifierPreAttack_CriticalStrike(params)
	if RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
	return
end
function modifier_khorn_currupted_attack:GetModifierTotalDamageOutgoing_Percentage(params)
	return self:GetAbility():GetSpecialValueFor("bonus_magical_damage")
end

function khorn_currupted_attack:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

