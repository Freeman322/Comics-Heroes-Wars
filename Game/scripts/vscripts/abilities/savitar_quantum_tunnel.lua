LinkLuaModifier( "modifier_savitar_quantum_tunnel_aura", "abilities/savitar_quantum_tunnel.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_savitar_quantum_tunnel", "abilities/savitar_quantum_tunnel.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
savitar_quantum_tunnel = class ( {})

function savitar_quantum_tunnel:IsStealable()
    return false
end

function savitar_quantum_tunnel:IsRefreshable()
    return false
end

function savitar_quantum_tunnel:OnSpellStart()
    if IsServer() then 
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_savitar_quantum_tunnel_aura", { duration = self:GetSpecialValueFor("duration") } )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_stampede_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn( "Hero_Terrorblade.Metamorphosis", self:GetCaster() )
    end 
end

if modifier_savitar_quantum_tunnel_aura == nil then modifier_savitar_quantum_tunnel_aura = class({}) end

function modifier_savitar_quantum_tunnel_aura:IsAura()
	return true
end

function modifier_savitar_quantum_tunnel_aura:IsHidden()
	return true
end

function modifier_savitar_quantum_tunnel_aura:IsPurgable()
	return false
end

function modifier_savitar_quantum_tunnel_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_savitar_quantum_tunnel_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_savitar_quantum_tunnel_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_savitar_quantum_tunnel_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_savitar_quantum_tunnel_aura:GetModifierAura()
	return "modifier_savitar_quantum_tunnel"
end

if modifier_savitar_quantum_tunnel == nil then modifier_savitar_quantum_tunnel = class({}) end

function modifier_savitar_quantum_tunnel:GetEffectName()
	return "particles/units/heroes/hero_vengeful/vengeful_venge_aura_cast.vpcf"
end

function modifier_savitar_quantum_tunnel:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_savitar_quantum_tunnel:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_AVOID_DAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_savitar_quantum_tunnel:GetModifierAvoidDamage(params)
    return 1
end

function modifier_savitar_quantum_tunnel:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_savitar_quantum_tunnel:IsHidden()
	return true
end

function modifier_savitar_quantum_tunnel:IsPurgable()
	return false
end