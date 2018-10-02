thor_eye_of_thunder = class({})
LinkLuaModifier( "modifier_thor_eye_of_thunder", "abilities/thor_eye_of_thunder.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_thor_eye_of_thunder_aura", "abilities/thor_eye_of_thunder.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_thor_eye_of_thunder_aura_stats", "abilities/thor_eye_of_thunder.lua" ,LUA_MODIFIER_MOTION_NONE )

function thor_eye_of_thunder:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function thor_eye_of_thunder:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function thor_eye_of_thunder:GetChannelTime()
		return 5
end

--------------------------------------------------------------------------------


function thor_eye_of_thunder:GetBehavior()
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

--------------------------------------------------------------------------------

function thor_eye_of_thunder:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function thor_eye_of_thunder:OnSpellStart()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_thor_eye_of_thunder", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
		local point = self:GetCaster():GetAbsOrigin()
		local caster = self:GetCaster()
		local team_id = caster:GetTeamNumber()
		local duration = self:GetChannelTime()
		local thinker = CreateModifierThinker(caster, self, "modifier_thor_eye_of_thunder_aura", {["duration"] = duration}, point, team_id, false)
	end
end



--------------------------------------------------------------------------------

function thor_eye_of_thunder:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_thor_eye_of_thunder" )
	end
end

modifier_thor_eye_of_thunder_aura = class({})

function modifier_thor_eye_of_thunder_aura:OnCreated(event)
	local thinker = self:GetParent()
	local ability = self:GetAbility()
	self.team_number = thinker:GetTeamNumber()
	self.radius = ability:GetSpecialValueFor("radius")

end

function modifier_thor_eye_of_thunder_aura:IsAura()
	return true
end

function modifier_thor_eye_of_thunder_aura:GetAuraRadius()
	return self.radius
end

function modifier_thor_eye_of_thunder_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_thor_eye_of_thunder_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_HERO
end

function modifier_thor_eye_of_thunder_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_thor_eye_of_thunder_aura:GetModifierAura()
	return "modifier_thor_eye_of_thunder_aura_stats"
end


modifier_thor_eye_of_thunder_aura_stats = class({})

function modifier_thor_eye_of_thunder_aura_stats:IsBuff()
	return true
end

function modifier_thor_eye_of_thunder_aura_stats:OnCreated( event )
	local ability = self:GetAbility()
	self.evasion = ability:GetSpecialValueFor("evasion")
	self.as = ability:GetSpecialValueFor("bonus_attack_speed")
end

function modifier_thor_eye_of_thunder_aura_stats:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_EVASION_CONSTANT}
end

function modifier_thor_eye_of_thunder_aura_stats:GetModifierEvasion_Constant()
	return self.evasion
end

function modifier_thor_eye_of_thunder_aura_stats:GetModifierAttackSpeedBonus_Constant()
	return self.as
end

------------------------------------------------------------------------------------

modifier_thor_eye_of_thunder = class({})

--------------------------------------------------------------------------------

function modifier_thor_eye_of_thunder:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_thor_eye_of_thunder:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_thor_eye_of_thunder:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )/100
	self.tick_rate = 0.1

	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
end

--------------------------------------------------------------------------------

function modifier_thor_eye_of_thunder:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

--------------------------------------------------------------------------------

function modifier_thor_eye_of_thunder:OnIntervalThink()
	if IsServer() then
		local flDamage = (self.damage*self:GetCaster():GetMaxHealth())/10

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
    local hTarget = self:GetParent()
		ApplyDamage( damage )
		EmitSoundOn( "Hero_Zuus.StaticField", self:GetParent() )
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );
	end
end

--------------------------------------------------------------------------------

function modifier_thor_eye_of_thunder:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_thor_eye_of_thunder:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_thor_eye_of_thunder:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function thor_eye_of_thunder:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

