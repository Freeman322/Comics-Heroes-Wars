if draks_unholy_strength == nil then draks_unholy_strength = class({}) end 
LinkLuaModifier("modifier_draks_unholy_strength", "abilities/draks_unholy_strength.lua", LUA_MODIFIER_MOTION_NONE)

function draks_unholy_strength:GetIntrinsicModifierName()
    return "modifier_draks_unholy_strength"
end

if modifier_draks_unholy_strength == nil then modifier_draks_unholy_strength = class({}) end 

function modifier_draks_unholy_strength:IsHidden()
    return true
end

function modifier_draks_unholy_strength:IsPurgable()
    return false
end

function modifier_draks_unholy_strength:OnCreated(htable)
    if IsServer() then 
         self.healing = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
         self.str = self:GetAbility():GetSpecialValueFor("bonus_strength")
         if self:GetCaster():HasTalent("special_bonus_unique_drax") then
            self.str = self.str * 2
            self.healing = self.healing * 2
        end
    end
end

function modifier_draks_unholy_strength:OnRefresh(htable)
    if IsServer() then 
         self.healing = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
         self.str = self:GetAbility():GetSpecialValueFor("bonus_strength")
         if self:GetCaster():HasTalent("special_bonus_unique_drax") then
            self.str = self.str * 2
            self.healing = self.healing * 2
        end
    end
end

function modifier_draks_unholy_strength:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }

    return funcs
end

function modifier_draks_unholy_strength:GetModifierConstantHealthRegen ( params )
    if self:GetParent():HasScepter() then 
        return (self.healing + math.floor( GameRules:GetGameTime() / 60 ))
    end 
    return self.healing
end

function modifier_draks_unholy_strength:GetModifierBonusStats_Strength ( params )
    return self.str
end

function draks_unholy_strength:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

