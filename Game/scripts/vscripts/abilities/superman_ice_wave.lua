LinkLuaModifier( "modifier_superman_ice_wave", "abilities/superman_ice_wave.lua", LUA_MODIFIER_MOTION_NONE )

superman_ice_wave = class({})

function superman_ice_wave:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()

	self.wave_speed = self:GetSpecialValueFor( "wave_speed" )
	self.wave_width = self:GetSpecialValueFor( "wave_width" )
	self.vision_aoe = self:GetSpecialValueFor( "vision_aoe" )
	self.vision_duration = self:GetSpecialValueFor( "vision_duration" )
	self.tooltip_duration = self:GetSpecialValueFor( "tooltip_duration" )
	self.wave_damage = self:GetSpecialValueFor( "wave_damage" )

	local info = {
		EffectName = "particles/hero_superman/superman_projectile_stout.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.wave_width,
		fEndRadius = self.wave_width,
		vVelocity = vDirection * self.wave_speed,
		fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = self.vision_aoe,
	}

	self.flVisionTimer = self.wave_width / self.wave_speed
	self.flLastThinkTime = GameRules:GetGameTime()
    self.nProjID = ProjectileManager:CreateLinearProjectile( info )

	EmitSoundOn( "Hero_Crystal.CrystalNova.Yulsaria" , self:GetCaster() )
end

--------------------------------------------------------------------------------

function superman_ice_wave:OnProjectileThink( vLocation )
	self.flVisionTimer = self.flVisionTimer - ( GameRules:GetGameTime() - self.flLastThinkTime )

	if self.flVisionTimer <= 0.0 then
		local vVelocity = ProjectileManager:GetLinearProjectileVelocity( self.nProjID )
		AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation + vVelocity * ( self.wave_width / self.wave_speed ), self.vision_aoe, self.vision_duration, false )
		self.flVisionTimer = self.wave_width / self.wave_speed
	end
end


--------------------------------------------------------------------------------

function superman_ice_wave:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_frostbite.vpcf", PATTACH_ABSORIGIN_FOLLOW, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetOrigin() + Vector(0, 96, 0) )
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        EmitSoundOn("hero_Crystal.frostbite", hTarget)
        
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_superman_ice_wave", { duration = self:GetSpecialValueFor("duration") } )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = self:GetAbilityDamageType(),
			ability = self,
		}

        ApplyDamage( damage )
	end

	return false
end


if not modifier_superman_ice_wave then modifier_superman_ice_wave = class({}) end 

function modifier_superman_ice_wave:IsDebuff()
	return true
end


function modifier_superman_ice_wave:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end


function modifier_superman_ice_wave:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_superman_ice_wave:CheckState()
	local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true
	}

	return state
end

function modifier_superman_ice_wave:OnCreated(params)
    if IsServer() then 
        self:StartIntervalThink(0.1)
    end 
end

function modifier_superman_ice_wave:OnIntervalThink()
	if IsServer() then
		local m_damage = self:GetAbility():GetSpecialValueFor("damage")
		if self:GetCaster():HasTalent("special_bonus_unique_superman_3") then m_damage = m_damage + self:GetCaster():FindTalentValue("special_bonus_unique_superman_3") end 

        local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = m_damage / (self:GetAbility():GetSpecialValueFor("duration") * 10),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
		}

        ApplyDamage( damage )
    end 
end
