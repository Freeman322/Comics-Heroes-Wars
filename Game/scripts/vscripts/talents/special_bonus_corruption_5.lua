LinkLuaModifier ("special_bonus_corruption_5", "talents/special_bonus_corruption_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_special_bonus_corruption_5", "talents/special_bonus_corruption_5.lua", LUA_MODIFIER_MOTION_NONE)

if special_bonus_corruption_5 == nil then special_bonus_corruption_5 = class({}) end

function special_bonus_corruption_5:IsHidden () return true end
function special_bonus_corruption_5:IsPurgable() return false end
function special_bonus_corruption_5:RemoveOnDeath() return false end
function special_bonus_corruption_5:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
    }

    return funcs
end

function special_bonus_corruption_5:OnAttackStart (params)
    if IsServer () then
        if params.attacker == self:GetParent() and self:GetParent():IsRealHero() then
            params.target:AddNewModifier (self:GetCaster(), self:GetAbility(), "modifier_special_bonus_corruption_5", {duration = 18})
        end
    end

    return 0
end


if modifier_special_bonus_corruption_5 == nil then modifier_special_bonus_corruption_5 = class ( {}) end
function modifier_special_bonus_corruption_5:IsBuff() return false end
function modifier_special_bonus_corruption_5:GetTexture () return "item_desolator" end
function modifier_special_bonus_corruption_5:GetStatusEffectName () return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_special_bonus_corruption_5:StatusEffectPriority () return 1000 end
function modifier_special_bonus_corruption_5:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_special_bonus_corruption_5:GetModifierPhysicalArmorBonus (params)
    return -15
end

