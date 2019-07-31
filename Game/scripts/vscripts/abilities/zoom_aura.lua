LinkLuaModifier ("modifier_zoom_aura", "abilities/zoom_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_zoom_aura_passive", "abilities/zoom_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_reverse_movespeed_steal", "abilities/zoom_aura.lua", LUA_MODIFIER_MOTION_NONE)
 
zoom_aura = class({})
 
function zoom_aura:GetIntrinsicModifierName()
    return "modifier_zoom_aura"
end
 
modifier_zoom_aura = class({})
function modifier_zoom_aura:IsAura() return true end
function modifier_zoom_aura:IsHidden() return true end
function modifier_zoom_aura:IsPurgable() return true end
function modifier_zoom_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_zoom_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_zoom_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_zoom_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_zoom_aura:GetModifierAura() return "modifier_zoom_aura_passive" end
 
modifier_zoom_aura_passive = class({})
function modifier_zoom_aura_passive:IsPurgable() return false end
function modifier_zoom_aura_passive:IsHidden() return true end
 
modifier_zoom_aura_passive.m_hMod = nil
 
function modifier_zoom_aura_passive:OnCreated(params)
    if IsServer() then
        if self:GetParent():IsRealHero() then
            self.m_hMod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_reverse_movespeed_steal", {attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed_bonus"), speed = self:GetParent():GetIdealSpeed() * (self:GetAbility():GetSpecialValueFor("speed_bonus") / 100)})
        end
    end
end
 
function modifier_zoom_aura_passive:OnDestroy()
    if IsServer() then
        if self.m_hMod and not self.m_hMod:IsNull() then
            self.m_hMod:Destroy()
        end
    end
end
 
 
function modifier_zoom_aura_passive:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end
 
function modifier_zoom_aura_passive:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("attack_speed_bonus") * -1
end
 
function modifier_zoom_aura_passive:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("speed_bonus") * -1
end
 
function zoom_aura:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_doomsday_clock") then return "custom/reverse_speed_passive" end
    return self.BaseClass.GetAbilityTextureName(self)
end
 
modifier_reverse_movespeed_steal = class({})
 
function modifier_reverse_movespeed_steal:IsHidden()
    return true
end
 
function modifier_reverse_movespeed_steal:IsPurgable()
    return false
end
 
function modifier_reverse_movespeed_steal:RemoveOnDeath()
    return true
end
 
function modifier_reverse_movespeed_steal:OnCreated(params)
    self.m_iMovespeed = params.speed
    self.m_iAttackSpeed = params.attack_speed
end
 
 
function modifier_reverse_movespeed_steal:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
 
    return funcs
end
 
function modifier_reverse_movespeed_steal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
 
function modifier_reverse_movespeed_steal:GetModifierMoveSpeedBonus_Constant(params)
    return self.m_iMovespeed
end

function modifier_reverse_movespeed_steal:GetModifierAttackSpeedBonus_Constant(params)
    return self.m_iAttackSpeed
end