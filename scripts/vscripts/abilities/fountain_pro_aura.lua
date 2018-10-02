LinkLuaModifier ("modifier_fountain_pro_aura", 				"abilities/fountain_pro_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_fountain_pro_aura_passive", "abilities/fountain_pro_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_fountain_pro_aura_trigger", "abilities/fountain_pro_aura.lua", LUA_MODIFIER_MOTION_NONE)

if fountain_pro_aura == nil then fountain_pro_aura = class({}) end

function fountain_pro_aura:GetIntrinsicModifierName()
	return "modifier_fountain_pro_aura"
end

if modifier_fountain_pro_aura == nil then modifier_fountain_pro_aura = class({}) end

function modifier_fountain_pro_aura:IsAura()
	return true
end

function modifier_fountain_pro_aura:IsHidden()
	return true
end

function modifier_fountain_pro_aura:IsPurgable()
	return true
end

function modifier_fountain_pro_aura:GetAuraRadius()
	return 900
end

function modifier_fountain_pro_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_fountain_pro_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_fountain_pro_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_fountain_pro_aura:GetModifierAura()
	return "modifier_fountain_pro_aura_passive"
end


function modifier_fountain_pro_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_fountain_pro_aura:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		params.target:ModifyHealth(params.target:GetHealth() - params.target:GetMaxHealth() * 0.03, self:GetAbility(), false, 0)
		params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_fountain_pro_aura_trigger", {duration = 2}) 
	end
end

if modifier_fountain_pro_aura_passive == nil then modifier_fountain_pro_aura_passive = class({}) end

function modifier_fountain_pro_aura_passive:GetEffectName(  )
    return "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf"
end

function modifier_fountain_pro_aura_passive:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_fountain_pro_aura_passive:IsPurgable()
    return false
end

function modifier_fountain_pro_aura_passive:IsHidden()
    return true
end

function modifier_fountain_pro_aura_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE 
	}

	return funcs
end

function modifier_fountain_pro_aura_passive:GetModifierHealthRegenPercentage( params )
  return 25
end

function modifier_fountain_pro_aura_passive:GetModifierPhysicalArmorBonusUnique( params )
  return 250
end

if modifier_fountain_pro_aura_trigger == nil then modifier_fountain_pro_aura_trigger = class({}) end

function modifier_fountain_pro_aura_trigger:IsPurgable()
    return false
end

function modifier_fountain_pro_aura_trigger:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_fountain_pro_aura_trigger:IsHidden()
    return true
end

function modifier_fountain_pro_aura_trigger:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_HEALING
    }
    return funcs
end


function modifier_fountain_pro_aura_trigger:GetDisableHealing(params)
    return 1
end

function modifier_fountain_pro_aura_trigger:CheckState ()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_EVADE_DISABLED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true
    }

    return state
end

function modifier_fountain_pro_aura_trigger:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end