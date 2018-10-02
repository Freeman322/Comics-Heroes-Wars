hela_kinetic_field = class({})
LinkLuaModifier( "modifier_hela_kinetic_field", "abilities/hela_kinetic_field.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function hela_kinetic_field:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function hela_kinetic_field:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function hela_kinetic_field:GetChannelTime()
	return self:GetSpecialValueFor("duration")
end


--------------------------------------------------------------------------------

function hela_kinetic_field:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hela_kinetic_field", { duration = self:GetChannelTime() } ) 
	end
end


function hela_kinetic_field:OnChannelFinish( bInterrupted )
	if IsServer() then 
		self:GetCaster():RemoveModifierByName( "modifier_hela_kinetic_field" )
	end
end

if modifier_hela_kinetic_field == nil then modifier_hela_kinetic_field = class({}) end

function modifier_hela_kinetic_field:IsDebuff()
	return false
end

function modifier_hela_kinetic_field:IsHidden()
	return true
end

function modifier_hela_kinetic_field:IsPurgable()
	return false
end

function modifier_hela_kinetic_field:OnCreated( kv )
	if IsServer() then
        local bhParticle1 = ParticleManager:CreateParticle ("particles/units/heroes/hero_arc_warden/arc_warden_magnetic.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(bhParticle1, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(bhParticle1, 1, Vector (self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 0))
        self:AddParticle(bhParticle1, false, false, -1, false, false)

        EmitSoundOn("Hero_ArcWarden.MagneticField.Cast", self:GetParent())
        EmitSoundOn("Hero_ArcWarden.MagneticField", self:GetParent())
	end
end

function modifier_hela_kinetic_field:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

function modifier_hela_kinetic_field:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}

	return state
end

function modifier_hela_kinetic_field:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_hela_kinetic_field:GetOverrideAnimation( params )
	return ACT_DOTA_CHANNEL_ABILITY_2
end

function modifier_hela_kinetic_field:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

