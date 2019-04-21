vader_force_strangulation = class({})
LinkLuaModifier( "modifier_vader_force_strangulation", "abilities/vader_force_strangulation.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function vader_force_strangulation:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function vader_force_strangulation:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function vader_force_strangulation:GetChannelTime()
	return self:GetSpecialValueFor("channel_time")
end

--------------------------------------------------------------------------------

function vader_force_strangulation:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function vader_force_strangulation:OnSpellStart()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_vader_force_strangulation", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end


--------------------------------------------------------------------------------

function vader_force_strangulation:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_vader_force_strangulation" )
	end
end

modifier_vader_force_strangulation = class({})

--------------------------------------------------------------------------------

function modifier_vader_force_strangulation:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_vader_force_strangulation:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_vader_force_strangulation:OnCreated( kv )
	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( 1 )
	end
end

--------------------------------------------------------------------------------

function modifier_vader_force_strangulation:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

--------------------------------------------------------------------------------

function modifier_vader_force_strangulation:OnIntervalThink()
	if IsServer() then
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetAbility():GetSpecialValueFor("base_damage")+((self:GetAbility():GetSpecialValueFor("percent_damage")/100)*self:GetParent():GetMaxHealth()),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
		EmitSoundOn( "Hero_Pudge.Dismember", self:GetParent() )
		if self:GetParent():GetHealth() == 0 then
			if self:GetCaster():HasModifier("modifier_vader") then
				local mod = self:GetCaster():FindModifierByName("modifier_vader")
				local slowing = mod:GetStackCount()
				mod:SetStackCount(slowing + 1)
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_vader_force_strangulation:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_vader_force_strangulation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_vader_force_strangulation:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

function vader_force_strangulation:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

