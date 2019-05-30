if overvoid_infinite == nil then overvoid_infinite = class({}) end

LinkLuaModifier( "modifier_overvoid_infinite", "abilities/overvoid_infinite.lua", LUA_MODIFIER_MOTION_NONE )

function overvoid_infinite:GetChannelTime()
	return self:GetSpecialValueFor("channel_time") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(),"special_bonus_unique_overvoid") or 0)
end

--------------------------------------------------------------------------------

function overvoid_infinite:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function overvoid_infinite:OnSpellStart()
	if self.hVictim == nil then
		return
	end
	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_overvoid_infinite", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end


--------------------------------------------------------------------------------

function overvoid_infinite:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_overvoid_infinite" )
	end
end

modifier_overvoid_infinite = class({})


function modifier_overvoid_infinite:IsHidden()
	return true
end

function modifier_overvoid_infinite:IsPurgable()
	return false
end


--------------------------------------------------------------------------------

function modifier_overvoid_infinite:OnCreated( kv )
	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( 0.25 )
	end
end

function modifier_overvoid_infinite:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

function modifier_overvoid_infinite:OnIntervalThink()
	if IsServer() then
		self:GetCaster():PerformAttack(self:GetParent(), true, true, true, true, false, false, true)
	end
end


function modifier_overvoid_infinite:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end


function modifier_overvoid_infinite:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_overvoid_infinite:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function overvoid_infinite:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
