if apocalypse_essence_shift == nil then apocalypse_essence_shift = class({}) end

LinkLuaModifier ("modifier_apocalypse_essence_shift", "abilities/apocalypse_essence_shift.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier ("modifier_apocalypse_essence_shift_target", "abilities/apocalypse_essence_shift.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier ("modifier_apocalypse_essence_shift_caster", "abilities/apocalypse_essence_shift.lua", LUA_MODIFIER_MOTION_NONE )

function apocalypse_essence_shift:GetIntrinsicModifierName ()
    return "modifier_apocalypse_essence_shift"
end

function apocalypse_essence_shift:GetAbilityTextureName()
	return "custom/apocalypse_essence_shift"
end

if modifier_apocalypse_essence_shift == nil then
    modifier_apocalypse_essence_shift = class ( {})
end

function modifier_apocalypse_essence_shift:IsHidden ()
    return true
end

function modifier_apocalypse_essence_shift:IsPurgable()
    return false
end

function modifier_apocalypse_essence_shift:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_apocalypse_essence_shift:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_apocalypse_essence_shift:OnAttackLanded(params)
    if IsServer () then
        if params.attacker == self:GetParent() then
          if params.target:IsRealHero() then
                local hAbility = self:GetAbility ()
                local agi_gain = hAbility:GetSpecialValueFor ("agi_gain")
                local duration = self:GetAbility():GetSpecialValueFor("duration")
                if self:GetCaster():HasTalent("special_bonus_apocalypse_1") then
                    duration = 6000
                end

                if self:GetParent():HasTalent("special_bonus_unique_apocalypse") then
                    agi_gain = agi_gain + 4
                end
                if self:GetParent():HasModifier("modifier_apocalypse_essence_shift_caster") then
                    local buff = self:GetParent():FindModifierByName("modifier_apocalypse_essence_shift_caster")
                    buff:SetStackCount(buff:GetStackCount() + agi_gain)
                else
                    self:GetParent():AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_apocalypse_essence_shift_caster", {duration = duration})
                end

                if params.target:HasModifier("modifier_apocalypse_essence_shift_target") then
                    local debuff = params.target:FindModifierByName("modifier_apocalypse_essence_shift_target")
                    debuff:SetStackCount(debuff:GetStackCount() + agi_gain)
                else
                    params.target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_apocalypse_essence_shift_target", {duration = duration})
                end
                params.target:CalculateStatBonus()
                self:GetParent():CalculateStatBonus()
            end
        end
    end

    return 0
end


if modifier_apocalypse_essence_shift_target == nil then
    modifier_apocalypse_essence_shift_target = class ( {})
end


function modifier_apocalypse_essence_shift_target:IsHidden ()
    return false
end

function modifier_apocalypse_essence_shift_target:RemoveOnDeath ()
    return true
end

function modifier_apocalypse_essence_shift_target:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }

    return funcs
end

function modifier_apocalypse_essence_shift_target:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("stat_loss")*self:GetStackCount()
end

function modifier_apocalypse_essence_shift_target:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("stat_loss")*self:GetStackCount()
end

function modifier_apocalypse_essence_shift_target:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("stat_loss")*self:GetStackCount()
end

function modifier_apocalypse_essence_shift_target:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

if modifier_apocalypse_essence_shift_caster == nil then modifier_apocalypse_essence_shift_caster = class({}) end

function modifier_apocalypse_essence_shift_caster:IsHidden ()
    return false
end

function modifier_apocalypse_essence_shift_caster:IsPurgable()
    return false
end

function modifier_apocalypse_essence_shift_caster:RemoveOnDeath ()
    return true
end

function modifier_apocalypse_essence_shift_caster:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return funcs
end

function modifier_apocalypse_essence_shift_caster:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("agi_gain")*self:GetStackCount()
end

function modifier_apocalypse_essence_shift_caster:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function apocalypse_essence_shift:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

