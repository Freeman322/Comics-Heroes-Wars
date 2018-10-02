LinkLuaModifier ("modifier_out_coil", "abilities/out_coil.lua", LUA_MODIFIER_MOTION_NONE)
out_coil = class({})

function out_coil:OnSpellStart()
	local caster = self:GetCaster()

	EmitSoundOn("DOTA_Item.GhostScepter.Activate", caster)
	local duration = self:GetSpecialValueFor("duration") --[[Returns:table
	No Description Set
	]]
	caster:AddNewModifier(caster, self, "modifier_out_coil", {duration = 4})
end

modifier_out_coil = class({})

function modifier_out_coil:IsHidden()
	return false
end

function modifier_out_coil:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_out_coil:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_out_coil:StatusEffectPriority()
	return 1000
end

--------------------------------------------------------------------------------

function modifier_out_coil:GetEffectName()
	return "particles/items_fx/ghost.vpcf"
end

function modifier_out_coil:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_out_coil:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon" , self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_out_coil:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_out_coil:GetModifierConstantManaRegen()
	return self:GetParent():GetMaxMana()*(12/100)
end

function modifier_out_coil:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_out_coil:GetAbsoluteNoDamageMagical()
	return 1
end

function out_coil:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

