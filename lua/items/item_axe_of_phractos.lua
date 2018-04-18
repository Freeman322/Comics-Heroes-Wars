if item_axe_of_phractos == nil then
	item_axe_of_phractos = class({})
end
LinkLuaModifier( "item_axe_of_phractos_modifier", "items/item_axe_of_phractos.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_axe_of_phractos_modifier_aura", "items/item_axe_of_phractos.lua", LUA_MODIFIER_MOTION_NONE )

function item_axe_of_phractos:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
	return behav
end

function item_axe_of_phractos:GetIntrinsicModifierName()
	return "item_axe_of_phractos_modifier"
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
if item_axe_of_phractos_modifier == nil then
	item_axe_of_phractos_modifier = class({})
end

function item_axe_of_phractos_modifier:GetEffectName()
    return "particles/items2_fx/radiance_owner.vpcf"
end

function item_axe_of_phractos_modifier:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function item_axe_of_phractos_modifier:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_ATTACK_LANDED
    }
	return funcs
end

function item_axe_of_phractos_modifier:IsHidden()
	return true
end

function item_axe_of_phractos_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_axe_of_phractos_modifier:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function item_axe_of_phractos_modifier:GetModifierAttackSpeedBonus_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_attack_speed" )
end

function item_axe_of_phractos_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "all" )
end

function item_axe_of_phractos_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "all" )
end
function item_axe_of_phractos_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "all" )
end

function item_axe_of_phractos_modifier:OnAttackLanded( params )
    if params.attacker == self:GetParent() then
        if RollPercentage(self:GetAbility():GetSpecialValueFor("bash_chance")) then
						if not params.target:IsTower() then
	            params.target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.1})
	            ApplyDamage({attacker = self:GetParent(), victim = params.target, ability = self:GetAbility(), damage = 100, damage_type = DAMAGE_TYPE_PURE})
						end
        end
    end
end

function item_axe_of_phractos_modifier:CheckState()
    local state = {
    [MODIFIER_STATE_CANNOT_MISS] = true,
    }

    return state
end

function item_axe_of_phractos_modifier:IsAura()
    if self:GetCaster() == self:GetParent() then
        return true
    end

    return false
end


function item_axe_of_phractos_modifier:GetAuraRadius()
    return 900
end

function item_axe_of_phractos_modifier:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function item_axe_of_phractos_modifier:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function item_axe_of_phractos_modifier:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function item_axe_of_phractos_modifier:GetModifierAura()
    return "item_axe_of_phractos_modifier_aura"
end

if item_axe_of_phractos_modifier_aura == nil then
    item_axe_of_phractos_modifier_aura = class({})
end

function item_axe_of_phractos_modifier_aura:IsHidden()
    return false
end

function item_axe_of_phractos_modifier_aura:GetEffectName()
    return "particles/items2_fx/radiance.vpcf"
end


function item_axe_of_phractos_modifier_aura:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function item_axe_of_phractos_modifier_aura:OnCreated(table)
    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
    end
end

function item_axe_of_phractos_modifier_aura:OnIntervalThink()
    if IsServer() then
        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = (self:GetParent():GetMaxHealth()*(self:GetAbility():GetSpecialValueFor("burn_damage")/100)+25), damage_type = DAMAGE_TYPE_PURE})
    end
end

function item_axe_of_phractos:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

