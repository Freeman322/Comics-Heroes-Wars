LinkLuaModifier( "modifier_katana_coup_de_grace", "abilities/katana_coup_de_grace.lua", LUA_MODIFIER_MOTION_NONE )
local IsHasCrit = false

katana_coup_de_grace = class({})

function katana_coup_de_grace:GetIntrinsicModifierName()
	return "modifier_katana_coup_de_grace"
end

modifier_katana_coup_de_grace = class({})
function modifier_katana_coup_de_grace:IsHidden()	return true end
function modifier_katana_coup_de_grace:IsPurgable()	return false end
function modifier_katana_coup_de_grace:RemoveOnDeath()	return false end
function modifier_katana_coup_de_grace:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
				MODIFIER_EVENT_ON_HERO_KILLED
    }
end

function modifier_katana_coup_de_grace:GetModifierPreAttack_CriticalStrike()
	if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
		IsHasCrit = true
		if IsServer() then
			if self:GetCaster():HasTalent("special_bonus_unique_katana") then
				return self:GetAbility():GetSpecialValueFor("crit_bonus") + self:GetCaster():FindTalentValue("special_bonus_unique_katana")
			end
			return self:GetAbility():GetSpecialValueFor("crit_bonus")
		end
	end
	IsHasCrit = false
end

function modifier_katana_coup_de_grace:OnAttackLanded (params)
  if params.attacker == self:GetParent() then
  	if self:GetParent():HasScepter() and not params.target:IsBuilding() and params.target:GetUnitName() ~= "npc_dota_creature_yaz" then
  		if RollPercentage(self:GetAbility():GetSpecialValueFor("scepter_kill_chance_pct")) then
				params.target:Kill(self:GetAbility(), self:GetParent())
				EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", params.target)
				EmitSoundOn("Hero_Clinkz.DeathPact", params.target)

				local particleName = "particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf"
				local particle = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, params.target)

				ParticleManager:SetParticleControlEnt(particle, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)

				-- Show the particle target-> caster
				local particleName = "particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf"
				local particle = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, self:GetParent())

				ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
			end
  	end

  	if IsHasCrit and not params.target:IsBuilding() then
  		local hTarget = params.target
  		local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf" , PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
  		EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", hTarget)
  		ScreenShake(hTarget:GetOrigin(), 100, 0.1, 0.3, 500, 0, true)
  	end


  end
end

function modifier_katana_coup_de_grace:OnHeroKilled(params)
	if params.target:GetTeam() ~= self:GetParent():GetTeam() then
		if params.attacker == self:GetParent() then
			self:IncrementStackCount()
		end
	end
end

function modifier_katana_coup_de_grace:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_katana_coup_de_grace:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
