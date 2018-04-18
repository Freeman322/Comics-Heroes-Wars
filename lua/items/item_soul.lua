if item_soul == nil then
	item_soul = class({})
end

LinkLuaModifier("modifier_item_soul", "items/item_soul.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_soul_transition", "items/item_soul.lua", LUA_MODIFIER_MOTION_NONE)

function item_soul:GetIntrinsicModifierName()
	return "modifier_item_soul"
end

function item_soul:CastFilterResultTarget( hTarget )
	if IsServer() then
		if hTarget:HasModifier("modifier_item_soul_transition") or hTarget:HasModifier("modifier_spawn_soul_trick") or hTarget:HasModifier("modifier_celebrimbor_overseer") then
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

function item_soul:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target ~= nil then
		local drain = self:GetSpecialValueFor("tooltip_brain_sap_heal_amt")
		caster:Heal(drain, caster)
		target:ModifyHealth(target:GetHealth() - drain, self, true, 0)

		local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"	
		local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, target )

		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

		-- Show the particle target-> caster
		local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"	
		local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )

		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

		EmitSoundOn("Hero_Terrorblade.Sunder.Cast", target)
		EmitSoundOn("Hero_Terrorblade.Sunder.Target", caster)
		if target:GetHealth() > 0 then
			target:AddNewModifier(caster, self, "modifier_item_soul_transition", {duration = self:GetSpecialValueFor("soul_reverse_duration")})
		end
	end
end

if modifier_item_soul == nil then
    modifier_item_soul = class ( {})
end

function modifier_item_soul:IsHidden ()
    return true
end

function modifier_item_soul:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_item_soul:GetModifierPhysicalArmorBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("armor")
end
function modifier_item_soul:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("stats")
end
function modifier_item_soul:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("stats")
end
function modifier_item_soul:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("stats")
end


if modifier_item_soul_transition == nil then modifier_item_soul_transition = class({}) end

function modifier_item_soul_transition:IsPurgable()
    return false
end

function modifier_item_soul_transition:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_soul_transition:StatusEffectPriority()
	return 1000
end

--------------------------------------------------------------------------------

function modifier_item_soul_transition:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_soul_transition:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_item_soul_transition:GetModifierAura()
	return "modifier_sven_gods_strength_child_lua"
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
    end
end


function modifier_item_soul_transition:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_REFLECT_SPELL
    }

    return funcs
end

function modifier_item_soul_transition:OnDestroy()
    if IsServer() then
		local caster = self:GetParent()

		caster:SetTeam(self.original_team)
	end
end
function item_soul:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

