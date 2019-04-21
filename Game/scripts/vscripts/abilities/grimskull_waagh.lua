LinkLuaModifier ("modifier_grimskull_waagh", "abilities/grimskull_waagh.lua", LUA_MODIFIER_MOTION_NONE)

if grimskull_waagh == nil then grimskull_waagh = class({}) end

grimskull_waagh.m_iLastLevel = 0

function grimskull_waagh:GetBehavior() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
function grimskull_waagh:GetIntrinsicModifierName() return "modifier_grimskull_waagh" end

function grimskull_waagh:GetGoldCost(level) return self:GetSpecialValueFor("price") end
function grimskull_waagh:GetGoldCostForUpgrade(level) return self:GetSpecialValueFor("price") end

function grimskull_waagh:OnUpgrade()
    if IsServer() then
      if not self:GetCaster():IsIllusion() then
        if (self:GetLevel() > self.m_iLastLevel) then
            if (self:GetGoldCost(self:GetLevel()) <= self:GetCaster():GetGold()) then
                self:GetCaster():SpendGold(self:GetGoldCost(self:GetLevel()), DOTA_ModifyGold_AbilityCost)

                self.m_iLastLevel = self:GetLevel()
            else
                self:SetLevel(self.m_iLastLevel)
                self:GetCaster():SetAbilityPoints(self:GetCaster():GetAbilityPoints() + 1)
            end
        end
      end
    end
end

if modifier_grimskull_waagh == nil then modifier_grimskull_waagh = class ( {}) end

function modifier_grimskull_waagh:IsHidden() return true end
function modifier_grimskull_waagh:IsPurgable() return false end

function modifier_grimskull_waagh:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }

    return funcs
end

function modifier_grimskull_waagh:GetModifierHealthBonus(params) return self:GetAbility():GetSpecialValueFor ("health") end
function modifier_grimskull_waagh:GetModifierPhysicalArmorBonus(params) return self:GetAbility():GetSpecialValueFor ("armor") end
function modifier_grimskull_waagh:GetModifierConstantHealthRegen(params) return self:GetAbility():GetSpecialValueFor ("hp_regen") end
function modifier_grimskull_waagh:GetModifierBonusStats_Strength(params) return self:GetAbility():GetSpecialValueFor ("str") end
function modifier_grimskull_waagh:GetModifierDamageOutgoing_Percentage(params) return self:GetAbility():GetSpecialValueFor ("damage") end
