if item_burning_fiend == nil then
	item_burning_fiend = class({})
end
LinkLuaModifier( "item_burning_fiend_modifier", "items/item_burning_fiend.lua", LUA_MODIFIER_MOTION_NONE )

function item_burning_fiend:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
	return behav
end

function item_burning_fiend:GetIntrinsicModifierName()
	return "item_burning_fiend_modifier"
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
if item_burning_fiend_modifier == nil then
	item_burning_fiend_modifier = class({})
end

function item_burning_fiend_modifier:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
	return funcs
end

function item_burning_fiend_modifier:OnCreated()
	if IsServer() then
		self:StartIntervalThink( 1 )
	end
end

function item_burning_fiend_modifier:IsHidden()
	return true
end

function item_burning_fiend_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_burning_fiend_modifier:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
	   return self:GetAbility():GetSpecialValueFor("bonus_damage")
	else
	   return 0
	end
end

function item_burning_fiend_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "all" )
end

function item_burning_fiend_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "all" )
end
function item_burning_fiend_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "all" )
end

function item_burning_fiend_modifier:OnIntervalThink()
	if IsServer() then
		if not self:GetParent():IsAlive() then return end
    local caster = self:GetParent()
    local mult = self:GetAbility():GetSpecialValueFor("aura_damage")/100
    local radius = self:GetAbility():GetSpecialValueFor("aura_radius")
    local burnings = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
    for i = 1, #burnings do
        local vic = burnings[i]
        local particle = "particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death_bonus.vpcf"
        local fx_burn = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, vic)
        ParticleManager:SetParticleControl(fx_burn, 0, vic:GetAbsOrigin())
        local damage = vic:GetMaxHealth()*mult
        ApplyDamage({victim = vic, attacker = caster, damage = damage + 35, damage_type = DAMAGE_TYPE_PURE})
    end
  end
end

function item_burning_fiend:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

