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
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
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
		IsHasCrit = true
		return self:GetAbility():GetSpecialValueFor("crit_damage") + (self.stacks*5)
	end
	IsHasCrit = false
	return
end

function modifier_deadpool_strike:OnAttackLanded (params)
    if params.attacker == self:GetParent() then
    	if IsHasCrit and not params.target:IsBuilding() then
    		local hTarget = params.target
    		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
    		EmitSoundOn("Hero_Winter_Wyvern.WintersCurse.Target", hTarget)
    		ScreenShake(hTarget:GetOrigin(), 100, 0.1, 0.3, 500, 0, true)
    	end
    end
end

function deadpool_strike:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_neo_noir") then return GetAbilityTextureNameFor("weapon", self:GetCaster():GetUnitName(), "the_old_facion", 3, self.BaseClass.GetAbilityTextureName(self) ) end
    return self.BaseClass.GetAbilityTextureName(self) 
end
  