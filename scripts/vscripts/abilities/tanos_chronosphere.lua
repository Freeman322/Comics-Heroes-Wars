LinkLuaModifier ("tanos_chronosphere_thinker", "abilities/tanos_chronosphere.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("tanos_chronosphere_modifier", "abilities/tanos_chronosphere.lua", LUA_MODIFIER_MOTION_NONE)

tanos_chronosphere = class({})

function tanos_chronosphere:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function tanos_chronosphere:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_thanos_golden_timebreaker") then
		return "arc_warden_magnetic_field"
	end
	return "custom/chrono2"
end


function tanos_chronosphere:OnSpellStart ()
    local point = self:GetCursorPosition ()
    local caster = self:GetCaster ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor ("duration")
    local thinker = CreateModifierThinker (caster, self, "tanos_chronosphere_thinker", {duration = duration }, point, team_id, false)

    local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, self:GetSpecialValueFor ("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    for i = 1, #units do
        local vic = units[i]
        vic:AddNewModifier(caster, self, "modifier_truesight", {duration = duration})
    end
end

function tanos_chronosphere:GetAOERadius ()
    return self:GetSpecialValueFor ("radius")
end

tanos_chronosphere_thinker = class ( {})

function tanos_chronosphere_thinker:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor ("radius")
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local caster = ability:GetCaster()
        self.target = self:GetCaster():GetCursorPosition()
        self.duration = ability:GetSpecialValueFor ("duration")
        local thinker_pos = thinker:GetAbsOrigin()
        if self:GetCaster():HasModifier("modifier_thanos_golden_timebreaker") then
          EmitSoundOn("Hero_FacelessVoid.Chronosphere.MaceOfAeons", thinker)
          EmitSoundOn("Hero_ArcWarden.MagneticField", thinker)
          local bhParticle1 = ParticleManager:CreateParticle ("particles/units/heroes/hero_arc_warden/arc_warden_magnetic.vpcf", PATTACH_WORLDORIGIN, thinker)
          ParticleManager:SetParticleControl(bhParticle1, 0, thinker_pos)
          ParticleManager:SetParticleControl(bhParticle1, 1, Vector (self.radius, self.radius, 0))
          self:AddParticle( bhParticle1, false, false, -1, false, true )
        else
          EmitSoundOn("Hero_FacelessVoid.Chronosphere", thinker)
          local bhParticle1 = ParticleManager:CreateParticle ("particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf", PATTACH_WORLDORIGIN, thinker)
          ParticleManager:SetParticleControl(bhParticle1, 0, thinker_pos)
          ParticleManager:SetParticleControl(bhParticle1, 1, Vector (self.radius, self.radius, 0))
          ParticleManager:SetParticleControl(bhParticle1, 6, thinker_pos)
          ParticleManager:SetParticleControl(bhParticle1, 10, thinker_pos)
          self:AddParticle( bhParticle1, false, false, -1, false, true )
        end
    end
end

function tanos_chronosphere_thinker:IsAura ()
    return true
end

function tanos_chronosphere_thinker:GetAuraRadius ()
    return self.radius
end

function tanos_chronosphere_thinker:GetAuraSearchTeam ()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function tanos_chronosphere_thinker:GetAuraSearchType ()
    return DOTA_UNIT_TARGET_ALL
end

function tanos_chronosphere_thinker:GetAuraSearchFlags ()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function tanos_chronosphere_thinker:GetModifierAura ()
    return "tanos_chronosphere_modifier"
end


tanos_chronosphere_modifier = class ( {})

function tanos_chronosphere_modifier:IsBuff ()
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return true
    else
        return false
    end
end


function tanos_chronosphere_modifier:DeclareFunctions ()
    return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}
end

function tanos_chronosphere_modifier:GetModifierMoveSpeedBonus_Constant (params)
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return 1200
    else
        return 0
    end
end

function tanos_chronosphere_modifier:GetModifierAttackSpeedBonus_Constant (params)
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return 200
    else
        return 0
    end
end


function tanos_chronosphere_modifier:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_FROZEN] = true}
    local state2 = {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_INVULNERABLE] = true}
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return state2
    else
      return state
    end
end

function tanos_chronosphere:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

