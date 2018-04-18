LinkLuaModifier ("modifier_item_ritual_rapier", "items/item_ritual_rapier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_ritual_rapier_active", "items/item_ritual_rapier.lua", LUA_MODIFIER_MOTION_NONE)

if item_ritual_rapier == nil then
    item_ritual_rapier = class({})
end

function item_ritual_rapier:GetIntrinsicModifierName ()
    return "modifier_item_ritual_rapier"
end

function item_ritual_rapier:OnSpellStart()
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_satanic_unholy", {duration = self:GetSpecialValueFor("unholy_duration")} )
end

if modifier_item_ritual_rapier == nil then
    modifier_item_ritual_rapier = class ( {})
end

function modifier_item_ritual_rapier:IsHidden ()
    return true
end

function modifier_item_ritual_rapier:IsPurgable()
    return false
end

function modifier_item_ritual_rapier:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_ritual_rapier:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_ritual_rapier:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_ritual_rapier:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_ritual_rapier:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_ritual_rapier:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_ritual_rapier:GetModifierEvasion_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_evasion")
end

function modifier_item_ritual_rapier:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            if target:IsAncient() or target:IsBuilding() then
                return nil
            end
            self:GetParent():Heal(self:GetParent():GetAverageTrueAttackDamage(target)*(self:GetAbility():GetSpecialValueFor("feast_dmg")/100), self:GetAbility())
            local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
            local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent ())
            ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent ():GetAbsOrigin())
        end
    end

    return 0
end

function item_ritual_rapier:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

