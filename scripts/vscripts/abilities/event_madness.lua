if event_madness == nil then event_madness = class({}) end

LinkLuaModifier( "modifier_event_madness", "abilities/event_madness.lua", LUA_MODIFIER_MOTION_NONE )

function event_madness:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_event_madness", { duration = duration }  )
	EmitSoundOn( "Hero_Centaur.Stampede.Cast", self:GetCaster() )
end

if modifier_event_madness == nil then modifier_event_madness = class({}) end

function modifier_event_madness:IsPurgable()
    return false
end

function modifier_event_madness:GetStatusEffectName()
	return "particles/status_fx/status_effect_alacrity.vpcf"
end

function modifier_event_madness:StatusEffectPriority()
	return 1000
end

function modifier_event_madness:OnCreated( kv )
  	if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
  	end
end

function modifier_event_madness:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_AVOID_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_event_madness:GetModifierAvoidDamage( params )
	return 1
end

function modifier_event_madness:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end
