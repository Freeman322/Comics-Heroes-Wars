LinkLuaModifier("modifier_dimm_primal_fear", "abilities/dimm_primal_fear.lua", LUA_MODIFIER_MOTION_NONE)
dimm_primal_fear = class({})

function dimm_primal_fear:CastFilterResultTarget( hTarget )
	if IsServer() then

		if hTarget == self:GetCaster() then
			return UF_FAIL_FRIENDLY
		end

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function dimm_primal_fear:OnAbilityPhaseStart()
	if IsServer() then
		local hVictim = self:GetCursorTarget()
		local caster = self:GetCaster()
		self:StartCooldown(self:GetCooldown(self:GetLevel()))
		if hVictim:IsCreep() then
			dimm_primal_fear:OnCreepTarget(hVictim, caster, self)
			return true
		elseif hVictim:IsRealHero() then
			dimm_primal_fear:OnHeroTarget(hVictim, caster, self)
			return true
		else
			return false
		end
	end
end

function dimm_primal_fear:OnCreepTarget(hVictim, caster, ability)
	if IsServer() then
	    local nFXIndex = ParticleManager:CreateParticle ("particles/items3_fx/iron_talon_active.vpcf", PATTACH_CUSTOMORIGIN, nil);
        ParticleManager:SetParticleControlEnt (nFXIndex, 0, hVictim, PATTACH_POINT_FOLLOW, "attach_attack1", hVictim:GetOrigin (), true);
        ParticleManager:SetParticleControl(nFXIndex, 1, hVictim:GetOrigin ());
        ParticleManager:SetParticleControl(nFXIndex, 3, hVictim:GetOrigin ());
        ParticleManager:SetParticleControl(nFXIndex, 4, hVictim:GetOrigin ());
        ParticleManager:ReleaseParticleIndex (nFXIndex);

        EmitSoundOn("Hero_DoomBringer.LvlDeath", hVictim)
        caster:ModifyGold(ability:GetSpecialValueFor("bonus_gold"), true, 0)  --Give the player a flat amount of reliable gold.
		caster:AddExperience(hVictim:GetDeathXP(), false, false)  --Give the player some XP.

		hVictim:SetDeathXP(0)
		hVictim:SetMinimumGoldBounty(0)
		hVictim:SetMaximumGoldBounty(0)
		hVictim:Kill(ability, caster) --Kill the creep.  This increments the caster's last hit counter.

		caster:AddNewModifier(hVictim, ability, "modifier_dimm_primal_fear", {duration = ability:GetSpecialValueFor("buff_second"), health = hVictim:GetMaxHealth()*(ability:GetSpecialValueFor("damage_buff")/100)})
    end
end

function dimm_primal_fear:OnHeroTarget(hVictim, caster, ability)
	if IsServer() then
	    local nFXIndex = ParticleManager:CreateParticle ("particles/items3_fx/iron_talon_active.vpcf", PATTACH_CUSTOMORIGIN, nil);
        ParticleManager:SetParticleControlEnt (nFXIndex, 0, hVictim, PATTACH_POINT_FOLLOW, "attach_attack1", hVictim:GetOrigin (), true);
        ParticleManager:SetParticleControl(nFXIndex, 1, hVictim:GetOrigin ());
        ParticleManager:SetParticleControl(nFXIndex, 3, hVictim:GetOrigin ());
        ParticleManager:SetParticleControl(nFXIndex, 4, hVictim:GetOrigin ());
        ParticleManager:ReleaseParticleIndex (nFXIndex);

        EmitSoundOn("Hero_DoomBringer.LvlDeath", hVictim)
        local DamageTable = {attacker = caster, victim = hVictim, ability = self, damage = ability:GetAbilityDamage(), damage_type = ability:GetAbilityDamageType()}
        ApplyDamage(DamageTable)
	end
end

modifier_dimm_primal_fear = class({})

function modifier_dimm_primal_fear:OnCreated(keys)
	self.health = keys.health
end

function modifier_dimm_primal_fear:IsHidden()
	return false
end

function modifier_dimm_primal_fear:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_dimm_primal_fear:GetModifierHealthBonus( params )
	return self.health
end

function dimm_primal_fear:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

