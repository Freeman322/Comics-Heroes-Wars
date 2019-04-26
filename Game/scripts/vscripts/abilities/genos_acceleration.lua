--2 скилл

genos_acceleration = class ({})

LinkLuaModifier("modifier_genos_acceleration", "abilities/genos/genos_acceleration.lua", LUA_MODIFIER_MOTION_NONE)

function genos_acceleration:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_genos_acceleration", { duration = self:GetSpecialValueFor("duration") } )
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_dark_seer_surge", {duration = self:GetSpecialValueFor("duration")})
        EmitSoundOn("Hero_Dark_Seer.Surge", self:GetCaster())
    end
end

modifier_genos_acceleration = class ({})

function modifier_genos_acceleration:IsHidden() return false end
function modifier_genos_acceleration:IsDebuff() return false end

function modifier_genos_acceleration:DeclareFunctions()
    local funcs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
    return funcs
end

function modifier_genos_acceleration:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_genos_acceleration:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_movespeed_pct")
end
