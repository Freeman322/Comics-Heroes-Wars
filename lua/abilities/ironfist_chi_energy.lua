ironfist_chi_energy = class({})

LinkLuaModifier( "modifier_ironfist_chi_energy",   "abilities/ironfist_chi_energy.lua", LUA_MODIFIER_MOTION_NONE)


function ironfist_chi_energy:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()


	local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/ironfist_chi_energy_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
    ParticleManager:SetParticleControl( nFXIndex, 18, Vector(1, 1, 1) );
    ParticleManager:ReleaseParticleIndex( nFXIndex );
	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hTarget )
  
    hTarget:AddNewModifier( hCaster, self, "modifier_ironfist_chi_energy", {duration = self:GetSpecialValueFor("duration")})
end

modifier_ironfist_chi_energy = class({})

function modifier_ironfist_chi_energy:GetEffectName(  )
    return "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf"
end

function modifier_ironfist_chi_energy:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ironfist_chi_energy:IsPurgable()
    return false
end

function modifier_ironfist_chi_energy:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}

	return funcs
end

function modifier_ironfist_chi_energy:GetModifierConstantHealthRegen( params )
  local regen = self:GetCaster():GetMaxHealth()*(self:GetAbility():GetSpecialValueFor("heal")/100)
  return regen
end
function ironfist_chi_energy:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

