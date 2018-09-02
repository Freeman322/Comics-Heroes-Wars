LinkLuaModifier ("modifier_item_overpower_bow","items/item_overpower_bow.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_overpower_bow_active","items/item_overpower_bow.lua",LUA_MODIFIER_MOTION_NONE)

if item_overpower_bow == nil then item_overpower_bow = class({}) end

function item_overpower_bow:GetIntrinsicModifierName() 	return "modifier_item_overpower_bow" end

function item_overpower_bow:OnSpellStart()
	local duration = self:GetSpecialValueFor ("active_attack_speed_duration")
	EmitSoundOn("DOTA_Item.Butterfly", self:GetCaster()) 
	EmitSoundOn("Item.CrimsonGuard.Cast", self:GetCaster())
	local particle = "particles/units/heroes/hero_lone_druid/lone_druid_rabid_buff_speed.vpcf"
	local fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(fx, 0, self:GetCaster():GetAbsOrigin())
    self:GetCaster():AddNewModifier (self:GetCaster(), self, "modifier_item_overpower_bow_active", { duration = duration } )
end

if modifier_item_overpower_bow == nil then modifier_item_overpower_bow = class ({}) end

function modifier_item_overpower_bow:IsHidden() return true end

function modifier_item_overpower_bow:DeclareFunctions ()
	local stats = 
		{
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_PROPERTY_EVASION_CONSTANT,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
		}
	return stats
end

function modifier_item_overpower_bow:GetModifierPreAttack_BonusDamage()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_overpower_bow:GetModifierBonusStats_Strength()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_overpower_bow:GetModifierBonusStats_Agility()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_overpower_bow:GetModifierBonusStats_Intellect()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_overpower_bow:GetModifierAttackSpeedBonus_Constant()
	local hAbility = self:GetAbility()
	return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_overpower_bow:GetModifierConstantHealthRegen()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_health_regen")
end
function modifier_item_overpower_bow:GetModifierConstantManaRegen()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end
function modifier_item_overpower_bow:GetModifierEvasion_Constant()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_evasion")
end
function modifier_item_overpower_bow:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor ("bonus_attack_range")
	else
		return 0
	end
end

if modifier_item_overpower_bow_active == nil then modifier_item_overpower_bow_active = class ({}) end

function modifier_item_overpower_bow_active:IsBuff()
	return true
end
function modifier_item_overpower_bow_active:IsPurgable()
	return true
end

function modifier_item_overpower_bow_active:DeclareFunctions()
	local stats1 = 
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
		}
	return stats1
end

function modifier_item_overpower_bow_active:GetModifierAttackSpeedBonus_Constant()
	return 50000
end

function modifier_item_overpower_bow_active:GetModifierBaseAttackTimeConstant(params)
    return 0.6
end

function modifier_item_overpower_bow_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_enigma_blackhole_tgt.vpcf"
end


function modifier_item_overpower_bow_active:StatusEffectPriority()
    return 1
end


function modifier_item_overpower_bow_active:GetEffectName()
    return "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf"
end


function modifier_item_overpower_bow_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
