if item_dragon_heart == nil then
    item_dragon_heart = class({})
end

LinkLuaModifier ("modifier_item_dragon_heart", "items/item_dragon_heart.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_dragon_heart_aura", "items/item_dragon_heart.lua", LUA_MODIFIER_MOTION_NONE )

function item_dragon_heart:GetIntrinsicModifierName ()
    return "modifier_item_dragon_heart"
end

function item_dragon_heart:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function item_dragon_heart:GetCooldown(nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end


if modifier_item_dragon_heart == nil then
    modifier_item_dragon_heart = class({})
end

function modifier_item_dragon_heart:DeclareFunctions ()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE, 
             MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
             MODIFIER_PROPERTY_HEALTH_BONUS,
             MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
             MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
             MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
 }
end

function modifier_item_dragon_heart:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_strength") 
end

function modifier_item_dragon_heart:GetModifierHPRegenAmplify_Percentage( params )
	return  self:GetAbility():GetSpecialValueFor("heal_amp")
end
function modifier_item_dragon_heart:GetModifierPreAttack_BonusDamage (params)
    return  self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_dragon_heart:GetModifierHealthBonus() 
    return self:GetAbility():GetSpecialValueFor("bonus_health") 
end

function modifier_item_dragon_heart:OnTakeDamage (event)
    if event.unit == self:GetParent() and not self:GetParent() ~= event.attacker then
        if event.attacker:IsHero() then
            self:GetAbility():StartCooldown(5)
        end
    end
end

function modifier_item_dragon_heart:IsHidden()
    return true
end

function modifier_item_dragon_heart:GetModifierConstantHealthRegen ()
    if IsServer() then
        local regen = self:GetParent():GetMaxHealth () * 7 / 100

        if self:GetAbility():IsCooldownReady() then
            return regen
        end

        return 0
    end
end

function modifier_item_dragon_heart:IsAura()
    if self:GetCaster() == self:GetParent() then
        return true
    end

    return false
end

function modifier_item_dragon_heart:GetEffectName()
    if self:GetParent():HasModifier("modifier_freeza") then
        return "particles/econ/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf"
    end
    
    return "particles/econ/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf"
end

function modifier_item_dragon_heart:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_dragon_heart:GetAuraRadius()
    return 700
end

function modifier_item_dragon_heart:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_dragon_heart:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_item_dragon_heart:GetModifierAura()
    return "modifier_item_dragon_heart_aura"
end

if modifier_item_dragon_heart_aura == nil then
    modifier_item_dragon_heart_aura = class({})
end

function modifier_item_dragon_heart_aura:IsHidden()
    return false
end

function modifier_item_dragon_heart_aura:GetEffectName()
    return "particles/items2_fx/radiance.vpcf"
end


function modifier_item_dragon_heart_aura:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_item_dragon_heart_aura:OnCreated(table)
    if IsServer() then
        self:StartIntervalThink(0.1)
        self:OnIntervalThink()
    end
end

function modifier_item_dragon_heart_aura:OnIntervalThink()
    if IsServer() then
        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = (self:GetCaster():GetMaxHealth()*(self:GetAbility():GetSpecialValueFor("burn_damage")/100)+60)/10, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS})
    end
end

function item_dragon_heart:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

