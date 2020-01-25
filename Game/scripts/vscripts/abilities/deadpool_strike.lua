LinkLuaModifier ("modifier_deadpool_strike", "abilities/deadpool_strike.lua", LUA_MODIFIER_MOTION_NONE)

if deadpool_strike == nil then
    deadpool_strike = class ( {})
end

function deadpool_strike:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function deadpool_strike:GetIntrinsicModifierName ()
    return "modifier_deadpool_strike"
end

if modifier_deadpool_strike == nil then
    modifier_deadpool_strike = class ( {})
end

function modifier_deadpool_strike:IsHidden()
    return true
end

function modifier_deadpool_strike:IsPurgable()
    return false
end

function modifier_deadpool_strike:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }

    return funcs
end

function modifier_deadpool_strike:OnCreated(table)
	if IsServer() then
        self.stacks = 0
        if self:GetCaster():HasModifier("modifier_deadpool") then
            local mod = self:GetCaster():FindModifierByName("modifier_deadpool")
            self.stacks = mod:GetStackCount()
        end
    end
end

function modifier_deadpool_strike:GetModifierPreAttack_CriticalStrike(params)
	if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
		return self:GetAbility():GetSpecialValueFor("crit_damage") + (self.stacks*5)
	end

	return
end

function deadpool_strike:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_neo_noir") then return "custom/the_old_facion_crit" end
    return self.BaseClass.GetAbilityTextureName(self) 
end
  