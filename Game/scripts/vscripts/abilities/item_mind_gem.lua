if item_mind_gem == nil then
	item_mind_gem = class({})
end

LinkLuaModifier("modifier_item_mind_gem", "items/item_mind_gem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mind_gem_active", "items/item_mind_gem.lua", LUA_MODIFIER_MOTION_NONE)

function item_mind_gem:GetIntrinsicModifierName()
	return "modifier_item_mind_gem"
end

function item_mind_gem:CastFilterResultTarget( hTarget )
	if IsServer() then
		if hTarget:HasModifier("modifier_item_mind_gem_active") or hTarget:HasModifier("modifier_spawn_soul_trick") or hTarget:HasModifier("modifier_celebrimbor_overseer") then
			return UF_FAIL_DOMINATED
		end

		if hTarget ~= nil and hTarget:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function item_mind_gem:OnSpellStart()
	if IsServer() then 
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

			print(self:GetSpecialValueFor("duration"))

			target:AddNewModifier(caster, self, "modifier_item_mind_gem_active", {duration = self:GetSpecialValueFor("duration")})
		end
	end
end

if modifier_item_mind_gem == nil then
    modifier_item_mind_gem = class ( {})
end

function modifier_item_mind_gem:IsHidden ()
    return true
end

function modifier_item_mind_gem:IsPurgable()
    return false
end

function modifier_item_mind_gem:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE 
    }

    return funcs
end

function modifier_item_mind_gem:GetModifierBonusStats_Intellect (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_intellect")
end

function modifier_item_mind_gem:GetModifierConstantManaRegen (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_mana_regen")
end

function modifier_item_mind_gem:GetModifierPercentageManacost (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_mana_cost")
end

function modifier_item_mind_gem:GetModifierPercentageCasttime (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_casttime")
end

if modifier_item_soul_transition == nil then modifier_item_soul_transition = class({}) end

function modifier_item_soul_transition:IsPurgable()
    return false
end

function modifier_item_soul_transition:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end


function modifier_item_soul_transition:StatusEffectPriority()
	return 1000
end

function modifier_item_soul_transition:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

function modifier_item_soul_transition:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_item_soul_transition:OnCreated( params )
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

		print("created")
    end
end


function modifier_item_soul_transition:OnDestroy()
    if IsServer() then
		local caster = self:GetParent()

		caster:SetTeam(self.original_team)
	end
end


function modifier_item_soul_transition:CheckState()
	local state = {
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end
