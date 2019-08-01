LinkLuaModifier ("modifier_doomsday_orb", "abilities/doomsday_orb.lua", LUA_MODIFIER_MOTION_NONE)

doomsday_orb = class({})

function doomsday_orb:GetIntrinsicModifierName() return "modifier_doomsday_orb" end

modifier_doomsday_orb = class({})

function modifier_doomsday_orb:IsHidden()	return true end
function modifier_doomsday_orb:IsPurgable()	return false end
function modifier_doomsday_orb:DeclareFunctions() return {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL} end

function modifier_doomsday_orb:GetModifierProcAttack_BonusDamage_Physical(params)
	if params.attacker == self:GetParent() and params.attacker:IsRealHero() and params.target:IsBuilding() == false then
		return params.attacker:GetHealth() * self:GetAbility():GetSpecialValueFor("damage_pct_fake") / 100
	end
end
