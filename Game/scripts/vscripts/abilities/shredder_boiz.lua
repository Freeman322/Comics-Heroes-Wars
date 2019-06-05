LinkLuaModifier ("modifier_shredder_boiz", "abilities/shredder_boiz.lua", LUA_MODIFIER_MOTION_NONE)

if shredder_boiz == nil then shredder_boiz = class({}) end

shredder_boiz.m_iLastLevel = 0

function shredder_boiz:GetBehavior() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
function shredder_boiz:GetIntrinsicModifierName() return "modifier_shredder_boiz" end

function shredder_boiz:GetGoldCost(level) return self:GetSpecialValueFor("price") end 
function shredder_boiz:GetGoldCostForUpgrade(level) return self:GetSpecialValueFor("price") end 

function shredder_boiz:OnUpgrade() 
    if IsServer() then
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

if modifier_shredder_boiz == nil then modifier_shredder_boiz = class ( {}) end

function modifier_shredder_boiz:IsHidden() return true end
function modifier_shredder_boiz:IsPurgable() return false end

function modifier_shredder_boiz:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE 
    }

    return funcs
end

function modifier_shredder_boiz:GetModifierTotalPercentageManaRegen(params) return self:GetAbility():GetSpecialValueFor ("mana_regen") end
function modifier_shredder_boiz:GetModifierPhysicalArmorBonus(params) return self:GetAbility():GetSpecialValueFor ("armor") end
function modifier_shredder_boiz:GetModifierHealthRegenPercentage(params) return self:GetAbility():GetSpecialValueFor ("hp_regen") end
function modifier_shredder_boiz:GetModifierSpellAmplify_Percentage(params) return self:GetAbility():GetSpecialValueFor ("spell_amp") end
function modifier_shredder_boiz:GetModifierExtraHealthPercentage(params) return self:GetAbility():GetSpecialValueFor ("bonus_hp") end
