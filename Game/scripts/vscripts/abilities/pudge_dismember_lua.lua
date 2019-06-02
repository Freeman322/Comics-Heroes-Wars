pudge_dismember_lua = class({})
LinkLuaModifier( "modifier_pudge_dismember_lua", "abilities/pudge_dismember_lua.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function pudge_dismember_lua:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function pudge_dismember_lua:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function pudge_dismember_lua:GetChannelTime()
	return self:GetSpecialValueFor("channel_time") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_pudge_2") or 0)
end

--------------------------------------------------------------------------------

function pudge_dismember_lua:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function pudge_dismember_lua:OnSpellStart()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_pudge_dismember_lua", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end


--------------------------------------------------------------------------------

function pudge_dismember_lua:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_pudge_dismember_lua" )
	end
end

if modifier_pudge_dismember_lua == nil then modifier_pudge_dismember_lua = class({}) end

function modifier_pudge_dismember_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "dismember_damage" )
	self.tick_rate = 0.5
	self.health_damage = self:GetAbility():GetSpecialValueFor( "health_damage" )

    self.damage = self.dismember_damage

	if IsServer() then
		self:GetParent():InterruptChannel()

		if self:GetCaster():HasTalent("special_bonus_unique_pudge") then self.health_damage = self.health_damage + self:GetCaster():FindTalentValue("special_bonus_unique_pudge") end

		self.damage = self.damage + (self:GetCaster():GetHealth() * (self.health_damage / 100))

		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "pudge_vessels_of_eternity") then
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_default.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			self:AddParticle( nFXIndex, false, false, -1, false, true )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:OnIntervalThink()
	if IsServer() then
		self:GetCaster():Heal( self.damage, self:GetAbility() )

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage / 2,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility()
		}

		EmitSoundOn( "Hero_Pudge.Dismember", self:GetParent() )
		EmitSoundOn( "Hero_Pudge.DismemberSwings", self:GetParent() )
		
		ApplyDamage( damage )
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_pudge_dismember_lua:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function pudge_dismember_lua:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
