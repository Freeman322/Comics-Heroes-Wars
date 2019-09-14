LinkLuaModifier ("modifier_item_high_frequency_blade", "items/item_high_frequency_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_high_frequency_blade_echoe", "items/item_high_frequency_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_high_frequency_blade_crit", "items/item_high_frequency_blade.lua", LUA_MODIFIER_MOTION_NONE)

if item_high_frequency_blade == nil then
    item_high_frequency_blade = class ( {})
end

function item_high_frequency_blade:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function item_high_frequency_blade:GetIntrinsicModifierName ()
    return "modifier_item_high_frequency_blade"
end

if modifier_item_high_frequency_blade == nil then
    modifier_item_high_frequency_blade = class ( {})
end

function modifier_item_high_frequency_blade:IsHidden()
    return true
end



function modifier_item_high_frequency_blade:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_high_frequency_blade:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_high_frequency_blade:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_strength")
end
function modifier_item_high_frequency_blade:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_int")
end
function modifier_item_high_frequency_blade:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_agility")
end
function modifier_item_high_frequency_blade:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_high_frequency_blade:GetModifierConstantManaRegen(params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end
function modifier_item_high_frequency_blade:GetModifierEvasion_Constant(params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_evasion")
end
function modifier_item_high_frequency_blade:OnAttackStart ( params )
    
    if IsServer() then
        if params.attacker == self:GetParent() then
            local hAbility = self:GetAbility ()
            local chance = hAbility:GetSpecialValueFor ("crit_chance")
            local random = math.random (100)
            if random <= chance and not self:GetParent():IsRangedAttacker() then
                self:GetParent ():AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_high_frequency_blade_crit", nil)
            end
        end
    end

    return 0
end

function modifier_item_high_frequency_blade:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local hAbility = self:GetAbility ()
            if hAbility:IsCooldownReady () and not self:GetParent ():IsRangedAttacker(  ) then
                self:GetParent ():AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_high_frequency_blade_echoe", nil)
                hAbility:StartCooldown (hAbility:GetCooldown (hAbility:GetLevel ()))
                return 0
            end
        end
    end

    return 0
end

if modifier_item_high_frequency_blade_echoe == nil then
    modifier_item_high_frequency_blade_echoe = class ( {})
end

function modifier_item_high_frequency_blade_echoe:IsHidden ()
    return true
end


function modifier_item_high_frequency_blade_echoe:RemoveOnDeath ()
    return true
end


function modifier_item_high_frequency_blade_echoe:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_high_frequency_blade_echoe:GetModifierPreAttack_CriticalStrike (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("crit_damage")
end

function modifier_item_high_frequency_blade_echoe:GetModifierAttackSpeedBonus_Constant (params)
    return 1200
end

function modifier_item_high_frequency_blade_echoe:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() then
            if self:GetParent ():HasModifier ("modifier_item_high_frequency_blade_echoe") then
                self:Destroy()
            end
        end
    end

    return 0
end

if modifier_item_high_frequency_blade_crit == nil then
    modifier_item_high_frequency_blade_crit = class({})
end


function modifier_item_high_frequency_blade_crit:IsHidden ()
    return true
end


function modifier_item_high_frequency_blade_crit:RemoveOnDeath ()
    return true
end


function modifier_item_high_frequency_blade_crit:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_high_frequency_blade_crit:GetModifierPreAttack_CriticalStrike (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("crit_damage")
end


function modifier_item_high_frequency_blade_crit:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            if self:GetParent ():HasModifier ("modifier_item_high_frequency_blade_crit") then
                self:Destroy ()
            end
        end
    end

    return 0
end
function item_high_frequency_blade:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

