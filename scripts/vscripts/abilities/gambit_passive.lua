LinkLuaModifier ("modifier_gambit_passive", "abilities/gambit_passive.lua", LUA_MODIFIER_MOTION_NONE)

if gambit_passive == nil then
    gambit_passive = class ( {})
end

function gambit_passive:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function gambit_passive:GetIntrinsicModifierName ()
    return "modifier_gambit_passive"
end

if modifier_gambit_passive == nil then
    modifier_gambit_passive = class ( {})
end

function modifier_gambit_passive:IsHidden()
    return true
end

function modifier_gambit_passive:IsPurgable()
    return false
end

function modifier_gambit_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
    }

    return funcs
end

function modifier_gambit_passive:GetModifierProcAttack_BonusDamage_Physical(htable)
	return self:GetAbility():GetSpecialValueFor("damage")
end

function gambit_passive:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

