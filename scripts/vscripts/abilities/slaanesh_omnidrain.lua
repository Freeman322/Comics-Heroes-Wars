slaanesh_omnidrain = class({})

LinkLuaModifier( "modifier_slaanesh_omnidrain_thinker", "abilities/slaanesh_omnidrain.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slaanesh_omnidrain", "abilities/slaanesh_omnidrain.lua", LUA_MODIFIER_MOTION_NONE)

function slaanesh_omnidrain:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function slaanesh_omnidrain:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_voland_custom") then return "custom/voland_ulti" end  
    return self.BaseClass.GetAbilityTextureName(self)  
end

function slaanesh_omnidrain:GetCooldown (nLevel)
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor("cooldown_scepter")
    end

    return self.BaseClass.GetCooldown (self, nLevel)
end

function slaanesh_omnidrain:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

function slaanesh_omnidrain:GetChannelTime()
	if IsServer() then
		if self:GetCaster():HasTalent("special_bonus_unique_slaanesh_3") then return self:GetCaster():FindTalentValue("special_bonus_unique_slaanesh_3") + self:GetSpecialValueFor("duration_tooltip") end 
	end

	return self:GetSpecialValueFor("duration_tooltip")
end


function slaanesh_omnidrain:OnAbilityPhaseStart()
	return true
end

function slaanesh_omnidrain:OnSpellStart()
    if IsServer() then 
        self._hThinker = CreateModifierThinker(self:GetCaster(), self, "modifier_slaanesh_omnidrain_thinker", {duration = self:GetChannelTime()}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
        
        EmitSoundOn("Hero_Pugna.LifeDrain.Cast", self:GetCaster())
    end 
end

function slaanesh_omnidrain:OnChannelFinish( bInterrupted )
	if not self._hThinker:IsNull() and self._hThinker ~= nil then
		self._hThinker:Destroy()
	end
end

if not modifier_slaanesh_omnidrain_thinker then modifier_slaanesh_omnidrain_thinker = class({}) end 

function modifier_slaanesh_omnidrain_thinker:OnCreated(event)
    if IsServer() then 
        local particle = ParticleManager:CreateParticle ("particles/hero_jaina/jaina_overvoid_aoe_ring.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 0))
        ParticleManager:SetParticleControl(particle, 2, Vector(self:GetAbility():GetChannelTime(), 0, 0))
        self:AddParticle( particle, false, false, -1, false, true )

        EmitSoundOn("Hero_Viper.NetherToxin.TI8", self:GetParent())
    end 
end

function modifier_slaanesh_omnidrain_thinker:OnIntervalThink()

end

function modifier_slaanesh_omnidrain_thinker:OnDestroy()

end

function modifier_slaanesh_omnidrain_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_slaanesh_omnidrain_thinker:IsAura()
    return true
end

function modifier_slaanesh_omnidrain_thinker:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_slaanesh_omnidrain_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_slaanesh_omnidrain_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_slaanesh_omnidrain_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_slaanesh_omnidrain_thinker:GetModifierAura()
    return "modifier_slaanesh_omnidrain"
end

modifier_slaanesh_omnidrain = class({})

function modifier_slaanesh_omnidrain:GetEffectName(  )
    return "particles/units/heroes/hero_arc_warden/arc_warden_tempest_buff.vpcf"
end

function modifier_slaanesh_omnidrain:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_slaanesh_omnidrain:IsPurgable()
    return false
end

function modifier_slaanesh_omnidrain:OnCreated(htable)
    if IsServer() then
        self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_rate"))
        local particle = "particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf"
        
        if self:GetCaster():HasModifier("modifier_voland_custom") then particle = "particles/units/heroes/hero_pugna/pugna_life_drain_beam_give.vpcf" end  

        local nFXIndex = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        StartSoundEvent("Hero_Pugna.LifeDrain.Loop", self:GetParent())
    end
end

function modifier_slaanesh_omnidrain:OnDestroy()
    if IsServer() then
        StopSoundEvent("Hero_Pugna.LifeDrain.Loop", self:GetParent())
    end
end

function modifier_slaanesh_omnidrain:OnIntervalThink()
    if IsServer() then
        local damage = self:GetAbility():GetSpecialValueFor("health_drain")
        if self:GetCaster():HasTalent("special_bonus_unique_slaanesh_2") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_slaanesh_2") end 
        
        damage = damage * self:GetAbility():GetSpecialValueFor("tick_rate")

        local damage_table = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility()
        }
        ApplyDamage( damage_table )

        self:GetCaster():Heal(damage, self:GetAbility())
	end
end