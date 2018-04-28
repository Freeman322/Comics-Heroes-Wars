marvel_challange_call = class({})

LinkLuaModifier( "modifier_marvel_challange_call", "abilities/marvel_challange_call.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marvel_duel_damage", "abilities/marvel_challange_call.lua", LUA_MODIFIER_MOTION_NONE )

function marvel_challange_call:GetIntrinsicModifierName()
	return "modifier_marvel_duel_damage"
end

function marvel_challange_call:CastFilterResultTarget( hTarget )
	if hTarget:IsIllusion() then
		return UF_FAIL_ILLUSION
	end

	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function marvel_challange_call:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

function marvel_challange_call:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hCaster == nil or hTarget == nil or hTarget:TriggerSpellAbsorb( this ) then
		return
	end

	hTarget:Interrupt()

	local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControlEnt( nCasterFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nCasterFX )

	local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nTargetFX )

	EmitSoundOn( "Hero_LegionCommander.Duel.Cast", hCaster )
	EmitSoundOn( "Hero_LegionCommander.Duel.Cast", hTarget )

	local duration = self:GetSpecialValueFor("duration")
	local damage = self:GetSpecialValueFor("reward_damage")

	if (hCaster:HasTalent("special_bonus_unique_marvel")) then 
		duration = duration + hCaster:FindTalentValue("special_bonus_unique_marvel")
	end

	if (hCaster:HasTalent("special_bonus_unique_marvel_1")) then 
		damage = damage + hCaster:FindTalentValue("special_bonus_unique_marvel_1")
	end

	hTarget:AddNewModifier(hCaster, self, "modifier_marvel_challange_call", {duration = duration, target = hCaster:entindex(), damage = damage})
	hCaster:AddNewModifier(hCaster, self, "modifier_marvel_challange_call", {duration = duration, target = hTarget:entindex(), damage = damage})
end

if modifier_marvel_challange_call == nil then modifier_marvel_challange_call = class({}) end 


function modifier_marvel_challange_call:IsHidden()
	return true
end

function modifier_marvel_challange_call:IsPurgable()
	return false
end

function modifier_marvel_challange_call:RemoveOnDeath()
	return true
end

function modifier_marvel_challange_call:OnCreated(table)
	if IsServer() then
		local caster = self:GetParent()
		self.target = EntIndexToHScript(table.target)
		self.damage = table.damage

		EmitSoundOn("Hero_LegionCommander.Duel", caster)

		local particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_cast_arcana_fire.vpcf", PATTACH_ABSORIGIN, caster)
		local center_point = self.target:GetAbsOrigin() + ((caster:GetAbsOrigin() - self.target:GetAbsOrigin()) / 2)
		ParticleManager:SetParticleControl(particle, 0, center_point) 
		ParticleManager:SetParticleControl(particle, 3, center_point)  
		ParticleManager:SetParticleControl(particle, 4, center_point) 
		ParticleManager:SetParticleControl(particle, 5, center_point)  
		self:AddParticle(particle, false, false, -1, false, false)

		local order =
		{
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self.target:entindex()
		}

		self.target:Stop()
		ExecuteOrderFromTable(order)

		self:GetParent():SetForceAttackTarget(self.target)

		self:StartIntervalThink(0.05)
	end
end

function modifier_marvel_challange_call:OnIntervalThink()
	if IsServer() then
		if self.target:IsAlive() == false then 
			self:Destroy()
		end
	end
end

function modifier_marvel_challange_call:OnDestroy()
	if IsServer() then
		if self.target:IsAlive() == false then 
			local buff = self:GetParent():FindModifierByName("modifier_marvel_duel_damage")
			if buff then for i = 1, self.damage do buff:IncrementStackCount() end else buff = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_marvel_duel_damage", nil) for i = 1, self.damage do buff:IncrementStackCount() end end
		end
		self:GetParent():Stop()
		self:GetParent():SetForceAttackTarget(nil)
		self:GetParent():SetForceAttackTarget(nil)
	end
end

function modifier_marvel_challange_call:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_marvel_challange_call:StatusEffectPriority()
	return 1000
end

function modifier_marvel_challange_call:GetEffectName()
	return "particles/marvel/duel_buff.vpcf"
end

function modifier_marvel_challange_call:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_marvel_challange_call:CheckState()
	local state = {
  		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

if modifier_marvel_duel_damage == nil then modifier_marvel_duel_damage = class({}) end 

function modifier_marvel_duel_damage:IsPurgable()
    return false
end

function modifier_marvel_duel_damage:RemoveOnDeath()
    return false
end

function modifier_marvel_duel_damage:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_marvel_duel_damage:GetModifierPreAttack_BonusDamage (params)
    return self:GetStackCount()
end
