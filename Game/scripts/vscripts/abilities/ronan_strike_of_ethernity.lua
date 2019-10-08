ronan_strike_of_ethernity = class({})

function ronan_strike_of_ethernity:CastFilterResultTarget( hTarget )
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function ronan_strike_of_ethernity:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_ronan_hammer") then
		return "custom/ronan_strike_of_ethernity_eternal"
	end
	return self.BaseClass.GetAbilityTextureName(self)
end

function ronan_strike_of_ethernity:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end

function ronan_strike_of_ethernity:OnSpellStart( )
	if IsServer() then
	    local caster = self:GetCaster()
	    local target = self:GetCursorTarget()
	    local ability = self
	    local damage_cof = ability:GetSpecialValueFor( "damage" )
	    local chance_scepter = ability:GetSpecialValueFor( "chance_scepter"  )
	    local particle_kill = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
	    local sound_success	= "Hero_Axe.Culling_Blade_Success"
	    local target_location = target:GetAbsOrigin()
	    local stats = caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()
		local culling_kill_particle = ParticleManager:CreateParticle(particle_kill, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
		ParticleManager:ReleaseParticleIndex(culling_kill_particle)

		local strike = ParticleManager:CreateParticle("particles/ronan_strike.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(strike, 0, target_location)
		ParticleManager:SetParticleControl(strike, 1, Vector(1, 0, 0))

		caster:EmitSound(sound_success)

		caster:EmitSound("Hero_EarthShaker.EchoSlam")
		caster:EmitSound("Hero_EarthShaker.EchoSlamEcho")
		caster:EmitSound("Hero_EarthShaker.EchoSlamSmall")

		if self:GetCaster():HasTalent("special_bonus_unique_ronan_2") then damage_cof = damage_cof + self:GetCaster():FindTalentValue("special_bonus_unique_ronan_2") end
		
		local iDamage = damage_cof*stats
	    ApplyDamage({victim = target, attacker = caster, damage = iDamage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NONE})

	    if target:GetHealthPercent() <= 15 then
	        local explosion5 = ParticleManager:CreateParticle("particles/one_punch.vpcf", PATTACH_WORLDORIGIN, target)
	        ParticleManager:SetParticleControl(explosion5, 0, target:GetAbsOrigin() + Vector(0, 0, 1))
	        ParticleManager:SetParticleControl(explosion5, 1, Vector(1, 1, 1))
	        ParticleManager:SetParticleControl(explosion5, 2, Vector(255, 255, 255))
	        ParticleManager:SetParticleControl(explosion5, 3, target:GetAbsOrigin())
	        ParticleManager:SetParticleControl(explosion5, 5, Vector(200, 200, 0))

	        local explosion9 = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_WORLDORIGIN, caster)
	        ParticleManager:SetParticleControl(explosion9, 0, caster:GetAbsOrigin())
	        ParticleManager:SetParticleControl(explosion9, 1, target:GetAbsOrigin()+ target:GetForwardVector()*1200)
	        ParticleManager:SetParticleControl(explosion9, 3, target:GetAbsOrigin() + target:GetForwardVector()*1200)
	        ParticleManager:SetParticleControl(explosion9, 11, target:GetAbsOrigin()+ target:GetForwardVector()*1200)
	        ParticleManager:SetParticleControl(explosion9, 12, caster:GetAbsOrigin())


	        local explosion13 = ParticleManager:CreateParticle("particles/hero_zoom/time_crystal_activate.vpcf", PATTACH_WORLDORIGIN, target)
	        ParticleManager:SetParticleControl(explosion13 , 0, target:GetAbsOrigin())

	        local explosion10 = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_WORLDORIGIN, caster)
	        ParticleManager:SetParticleControl(explosion10, 0, caster:GetAbsOrigin())
	        ParticleManager:SetParticleControl(explosion10, 1, target:GetAbsOrigin() - target:GetForwardVector()*1200)
	        ParticleManager:SetParticleControl(explosion10, 3, target:GetAbsOrigin() - target:GetForwardVector()*1200)
	        ParticleManager:SetParticleControl(explosion10, 11, target:GetAbsOrigin() - target:GetForwardVector()*1200)
	        ParticleManager:SetParticleControl(explosion10, 12, caster:GetAbsOrigin())

	        local explosion12 = ParticleManager:CreateParticle("particles/punch_cracks.vpcf", PATTACH_WORLDORIGIN, target)
	        ParticleManager:SetParticleControl(explosion12, 0, caster:GetAbsOrigin())
	        ParticleManager:SetParticleControl(explosion12, 1,  Vector(200, 200, 0))
	        ParticleManager:SetParticleControl(explosion12, 3,  caster:GetAbsOrigin())
	        ParticleManager:SetParticleControl(explosion12, 11,  caster:GetAbsOrigin())
	        ParticleManager:SetParticleControl(explosion12, 12,  caster:GetAbsOrigin())
			
			target:Kill(self, caster)
	        
			if self:GetCaster():HasTalent("special_bonus_unique_ronan_3") then self:EndCooldown() self:StartCooldown(self:GetCaster():FindTalentValue("special_bonus_unique_ronan_3")) end
		end
	end
end
