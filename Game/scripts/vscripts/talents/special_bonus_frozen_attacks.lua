LinkLuaModifier ("special_bonus_frozen_attacks", "talents/special_bonus_frozen_attacks.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_special_bonus_frozen_attacks", "talents/special_bonus_frozen_attacks.lua", LUA_MODIFIER_MOTION_NONE)

if special_bonus_frozen_attacks == nil then special_bonus_frozen_attacks = class({}) end

function special_bonus_frozen_attacks:IsHidden () return true end
function special_bonus_frozen_attacks:IsPurgable() return false end
function special_bonus_frozen_attacks:RemoveOnDeath() return false end
function special_bonus_frozen_attacks:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }

    return funcs
end

function special_bonus_frozen_attacks:OnCreated(params)
    if IsServer() then 
        if self:GetParent():IsRangedAttacker() then self:GetParent():SetRangedProjectileName("particles/items2_fx/skadi_projectile.vpcf") end 
    end 
end

function special_bonus_frozen_attacks:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            params.target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_special_bonus_frozen_attacks", { duration = 6 })

            EmitSoundOn ("Hero_Ancient_Apparition.Attack", params.target)
        end
    end
    return 0
end


if modifier_special_bonus_frozen_attacks == nil then modifier_special_bonus_frozen_attacks = class ( {}) end
function modifier_special_bonus_frozen_attacks:IsBuff() return false end
function modifier_special_bonus_frozen_attacks:GetTexture () return "item_skadi" end
function modifier_special_bonus_frozen_attacks:GetStatusEffectName () return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_special_bonus_frozen_attacks:StatusEffectPriority () return 1000 end
function modifier_special_bonus_frozen_attacks:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_special_bonus_frozen_attacks:GetModifierMoveSpeedBonus_Percentage (params)
    return -60
end

function modifier_special_bonus_frozen_attacks:GetModifierAttackSpeedBonus_Constant (params)
    return -60
end
