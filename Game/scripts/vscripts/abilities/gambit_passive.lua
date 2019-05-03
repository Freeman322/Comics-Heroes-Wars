LinkLuaModifier ("modifier_gambit_passive", "abilities/gambit_passive.lua", LUA_MODIFIER_MOTION_NONE)

gambit_passive = class({})

function gambit_passive:GetIntrinsicModifierName() return "modifier_gambit_passive" end

modifier_gambit_passive = class({})

function modifier_gambit_passive:IsHidden() return true end
function modifier_gambit_passive:IsPurgable() return false end
function modifier_gambit_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_gambit_passive:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("damage") end
