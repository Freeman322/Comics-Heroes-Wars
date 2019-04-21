LinkLuaModifier("modifier_item_mind_gem", "items/item_mind_gem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mind_gem_active", "items/item_mind_gem.lua", LUA_MODIFIER_MOTION_NONE)

item_mind_gem = class({})

function item_mind_gem:GetIntrinsicModifierName()
	return "modifier_item_mind_gem"
end

function item_mind_gem:CastFilterResultTarget( hTarget )
	if IsServer() then
		if hTarget:HasModifier("modifier_item_mind_gem_active") or hTarget:HasModifier("modifier_spawn_soul_trick") or hTarget:HasModifier("modifier_celebrimbor_overseer") then
			return UF_FAIL_DOMINATED
		end

		if self:GetCaster() == hTarget then
			return UF_FAIL_CUSTOM
		end

		if self:GetCaster():HasModifier("modifier_storm_spirit_ball_lightning") then
			return UF_FAIL_CUSTOM
		end

		if hTarget ~= nil and hTarget:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function item_mind_gem:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	if self:GetCaster():HasModifier("modifier_storm_spirit_ball_lightning") then
		return "#dota_hud_error_cant_cast_in_ball_lightning"
	end

	return ""
end

function item_mind_gem:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target ~= nil then
		local particleName = "particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf"
		local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

		EmitSoundOn("Hero_Terrorblade.Sunder.Cast", target)
		EmitSoundOn("Hero_Terrorblade.Sunder.Target", caster)

		if target:GetHealth() > 0 then
			target:AddNewModifier(caster, self, "modifier_item_mind_gem_active", {duration = self:GetSpecialValueFor("duration")})
		end
	end
end

modifier_item_mind_gem = class({})

function modifier_item_mind_gem:IsHidden() return true end
function modifier_item_mind_gem:IsPurgable() return false end
function modifier_item_mind_gem:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
	}
end

function modifier_item_mind_gem:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_item_mind_gem:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agility") end
function modifier_item_mind_gem:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_item_mind_gem:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
function modifier_item_mind_gem:GetModifierPercentageManacost() return self:GetAbility():GetSpecialValueFor("bonus_mana_cost") end
function modifier_item_mind_gem:GetModifierPercentageCasttime() return self:GetAbility():GetSpecialValueFor("bonus_casttime") end
modifier_item_mind_gem_active = class({})

function modifier_item_mind_gem_active:IsPurgable() return false end

function modifier_item_mind_gem_active:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_item_mind_gem_active:StatusEffectPriority()
	return 1000
end

function modifier_item_mind_gem_active:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

function modifier_item_mind_gem_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
--------------------------------------------------------------------------------

function modifier_item_mind_gem_active:GetModifierAura()
	return "modifier_sven_gods_strength_child_lua"
end


function modifier_item_mind_gem_active:OnCreated()
    if IsServer() then
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())
		local caster = self:GetParent()
		self.original_team = caster:GetTeamNumber()
		if caster:GetTeamNumber() == 2 then
			self.target_team = 3
		else
			self.target_team = 2
		end
		caster:SetTeam(self.target_team)
    end
end


function modifier_item_mind_gem_active:CheckState()
	return {
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true
	}
end

function modifier_item_mind_gem_active:OnDestroy()
    if IsServer() then
		local caster = self:GetParent()

		caster:SetTeam(self.original_team)
	end
end
