thor_shield = class ( {})

LinkLuaModifier ("modifier_thor_shield", "abilities/thor_shield.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_thor_shield_target", "abilities/thor_shield.lua", LUA_MODIFIER_MOTION_NONE)

function thor_shield:GetBehavior()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function thor_shield:GetIntrinsicModifierName()
    return "modifier_thor_shield"
end

modifier_thor_shield = class ( {})

function modifier_thor_shield:IsHidden()
    return true

end

function modifier_thor_shield:IsPurgable()
    return false
end

function modifier_thor_shield:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_thor_shield:OnAttackLanded (params)
    if self:GetParent() == params.attacker then
        local hAbility = self:GetAbility()
        if RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
            local hTarget = params.target
            EmitSoundOn ("Item_Desolator.Target", hTarget)
            hTarget:AddNewModifier(hAbility:GetCaster(), hAbility, "modifier_thor_shield_target", { duration = 4 })
        end
    end
end

function modifier_thor_shield:GetModifierMagicalResistanceBonus (params)
  return self:GetAbility():GetSpecialValueFor("magical_armor")
end

modifier_thor_shield_target = class ( {})

function modifier_thor_shield_target:GetEffectName ()
    return "particles/items_fx/diffusal_slow.vpcf"
end

function modifier_thor_shield_target:OnCreated(event)
    if IsServer() then
        ApplyDamage ({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function modifier_thor_shield_target:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_thor_shield_target:GetModifierMoveSpeedBonus_Percentage(params)
  return self:GetAbility():GetSpecialValueFor("slowing")
end

function thor_shield:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

