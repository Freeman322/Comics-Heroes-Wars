if roket_agil == nil then roket_agil = class({}) end

LinkLuaModifier("modifier_roket_agil", "abilities/roket_agil.lua", LUA_MODIFIER_MOTION_NONE) --- PATH WERY IMPORTANT

function roket_agil:GetIntrinsicModifierName() return "modifier_roket_agil" end

if modifier_roket_agil == nil then modifier_roket_agil = class({}) end

function modifier_roket_agil:IsHidden() return true end
function modifier_roket_agil:IsPurgable() return false end
function modifier_roket_agil:RemoveOnDeath() return false end

function modifier_roket_agil:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
	return funcs
end

function modifier_roket_agil:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_roket_agil:GetModifierBonusStats_Agility( params ) return self:GetAbility():GetSpecialValueFor( "agility" ) end
