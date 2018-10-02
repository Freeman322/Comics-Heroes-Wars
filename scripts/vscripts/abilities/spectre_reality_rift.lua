spectre_reality_rift = class({})

function spectre_reality_rift:CastFilterResultTarget( hTarget )
	if IsServer() then
    local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function spectre_reality_rift:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function spectre_reality_rift:OnAbilityPhaseStart()
   if IsServer() then
    local caster = self:GetCaster()
  	local target = self:GetCursorTarget()

  	local caster_location = caster:GetAbsOrigin()
  	local target_location = target:GetAbsOrigin()

  	-- Ability variables
  	local min_range = 0.3

  	-- Position calculation
  	local distance = (target_location - caster_location):Length2D()
  	local direction = (target_location - caster_location):Normalized()
  	local target_point = RandomFloat(min_range, min_range) * distance
  	local target_point_vector = caster_location + direction * target_point

  	-- Particle
  	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf", PATTACH_CUSTOMORIGIN, target)
  	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster_location, true)
  	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
  	ParticleManager:SetParticleControl(particle, 2, target_point_vector)
  	ParticleManager:SetParticleControlOrientation(particle, 2, direction, Vector(0,1,0), Vector(1,0,0))
  	ParticleManager:ReleaseParticleIndex(particle)

    EmitSoundOn("Hero_ChaosKnight.RealityRift", caster)
   end
   return true
end

function spectre_reality_rift:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
      hTarget:SetAbsOrigin(self:GetCaster():GetAbsOrigin())
      FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), true)
			FindClearSpaceForUnit(hTarget, self:GetCaster():GetAbsOrigin(), true)
  		EmitSoundOn( "Hero_ChaosKnight.RealityRift.Target", self:GetCaster() )
		end
	end
end

function spectre_reality_rift:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

