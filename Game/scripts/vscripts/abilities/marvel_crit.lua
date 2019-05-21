if marvel_crit == nil then marvel_crit = class({}) end

LinkLuaModifier("modifier_marvel_crit", "abilities/marvel_crit.lua", LUA_MODIFIER_MOTION_NONE)

function marvel_crit:GetIntrinsicModifierName()
	return "modifier_marvel_crit"
end

modifier_marvel_crit = class({})

function modifier_marvel_crit:IsHidden()
	return true
end

function modifier_marvel_crit:IsPurgable()
	return false
end

function modifier_marvel_crit:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_marvel_crit:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            if not target:IsBuilding() then
				if target:GetUnitName() == "npc_dota_warlock_golem_1" then
					return nil
				end
				if target:GetUnitName() == "npc_dota_boss_thanos" then
					return nil
				end
             	if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
					ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_POINT_FOLLOW, victim)
					EmitSoundOn( "Hero_Oracle.FalsePromise.Damaged", victim )
					
					ApplyDamage({attacker = params.attacker, victim = target, ability = self:GetAbility(), damage = target:GetHealth()*(self:GetAbility():GetSpecialValueFor("crit_bonus")/100), damage_type = DAMAGE_TYPE_PURE})
             	end
            end
        end
    end

    return 0
end

function marvel_crit:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

