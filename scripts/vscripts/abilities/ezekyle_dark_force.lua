ezekyle_dark_force = class({})

LinkLuaModifier("modifier_ezekyle_dark_force", "abilities/ezekyle_dark_force.lua", LUA_MODIFIER_MOTION_NONE)

function ezekyle_dark_force:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function ezekyle_dark_force:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end
function ezekyle_dark_force:GetChannelTime() return self:GetSpecialValueFor("duration") end
function ezekyle_dark_force:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

function ezekyle_dark_force:OnSpellStart()
	if self.hVictim == nil then return end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
        self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_ezekyle_dark_force", { duration = self:GetChannelTime() } )
        EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Cast", self.hVictim )
        EmitSoundOn("doom_bringer_doom_level_01", self:GetCaster())
		self.hVictim:Interrupt()
	end
end

function ezekyle_dark_force:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_ezekyle_dark_force" )
	end
end

if not modifier_ezekyle_dark_force then modifier_ezekyle_dark_force = class({}) end 

function modifier_ezekyle_dark_force:IsDebuff() return true end
function modifier_ezekyle_dark_force:IsStunDebuff() return true end
function modifier_ezekyle_dark_force:RemoveOnDeath() return false end

function modifier_ezekyle_dark_force:OnCreated( kv )
	if IsServer() then
        self:StartIntervalThink(0.03)
        
		if not self:GetParent():IsAlive() then
			self:GetCaster():Interrupt() self:Destroy() 
        end
        
        
    	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_gaze_head.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster() );
		self:AddParticle(nFXIndex, false, false, -1, false, false)
	end
end

function modifier_ezekyle_dark_force:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_ezekyle_dark_force:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

function modifier_ezekyle_dark_force:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

function modifier_ezekyle_dark_force:GetStatusEffectName()
    return "particles/status_fx/status_effect_pudge_dismember_ethereal.vpcf"
end

function modifier_ezekyle_dark_force:StatusEffectPriority()
    return 1000
end

function modifier_ezekyle_dark_force:GetEffectName()
    return "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd_debuff.vpcf"
end

function modifier_ezekyle_dark_force:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ezekyle_dark_force:OnIntervalThink()
	if IsServer() then
        local target_point = self:GetCaster():GetAbsOrigin()
        local caster_location = self:GetParent():GetAbsOrigin()

        local distance = (target_point - caster_location):Length2D()
        local direction = (target_point - caster_location):Normalized()
        
        if distance >= 128 then
      		self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + direction * (45 * FrameTime()))
        end
        
        local damage = self:GetAbility():GetSpecialValueFor( "damage_tick" )
        if self:GetCaster():HasTalent("special_bonus_unique_ezekyle_4") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_ezekyle_4") end

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage * FrameTime(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

        ApplyDamage( damage )
	end
end


function modifier_ezekyle_dark_force:OnDestroy( )
    if IsServer() then 
    	FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetAbsOrigin(), true )
        EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Complete", self:GetParent())
    end 
end


