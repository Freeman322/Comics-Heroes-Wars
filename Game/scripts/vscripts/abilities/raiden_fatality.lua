if raiden_fatality == nil then raiden_fatality = class({}) end

LinkLuaModifier( "modifier_raiden_fatality", "abilities/raiden_fatality.lua", LUA_MODIFIER_MOTION_NONE )

function raiden_fatality:GetChannelTime() return self:GetSpecialValueFor("channel_time") end

--------------------------------------------------------------------------------

function raiden_fatality:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function raiden_fatality:OnSpellStart()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_raiden_fatality", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end


--------------------------------------------------------------------------------

function raiden_fatality:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_raiden_fatality" )
	end
end

modifier_raiden_fatality = class({})

function modifier_raiden_fatality:IsHidden() return true end
function modifier_raiden_fatality:IsPurgable() return false end
--------------------------------------------------------------------------------

function modifier_raiden_fatality:OnCreated( kv )
	if IsServer() then
        self:GetParent():InterruptChannel()

		self:OnIntervalThink()
		self:StartIntervalThink( 0.25 )
	end
end

function modifier_raiden_fatality:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

function modifier_raiden_fatality:OnIntervalThink()
	if IsServer() then
		ApplyDamage({
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			ability = self:GetAbility(),
			damage = self:GetAbility():GetAbilityDamage() * 0.25,
			damage_type = DAMAGE_TYPE_MAGICAL,
		})
		
		if self:GetCaster():HasScepter() then
			self:GetCaster():PerformAttack(self:GetParent(), true, false, false, false, false, false, false)
		end

		EmitSoundOn("Hero_Zuus.LightningBolt.Cloud", self:GetParent())

	   	local nTargetFX = ParticleManager:CreateParticle( "particles/econ/items/storm_spirit/strom_spirit_ti8/gold_storm_spirit_ti8_overload_active_h.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nTargetFX, 0, self:GetParent():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nTargetFX )

		ApplyDamage( damage )
	end
end


function modifier_raiden_fatality:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end


function modifier_raiden_fatality:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_raiden_fatality:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_raiden_fatality:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
