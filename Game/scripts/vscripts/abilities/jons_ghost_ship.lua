if jons_ghost_ship == nil then jons_ghost_ship = class({}) end

function jons_ghost_ship:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/units/heroes/hero_kunkka/kunkka_ghost_ship.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fStartRadius = 250,
		fEndRadius = 450,
		vVelocity = vDirection * 600,
		fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_NONE,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = 350,
	}

	self.flVisionTimer = 250 / 600
	self.flLastThinkTime = GameRules:GetGameTime()
	self.nProjID = ProjectileManager:CreateLinearProjectile( info )

	EmitSoundOn( "Ability.Ghostship" , self:GetCaster() )
  EmitSoundOn("Ability.Ghostship.bell", self:GetCaster())
end

function jons_ghost_ship:OnProjectileThink( vLocation )
	self.flVisionTimer = self.flVisionTimer - ( GameRules:GetGameTime() - self.flLastThinkTime )

	if self.flVisionTimer <= 0.0 then
		local vVelocity = ProjectileManager:GetLinearProjectileVelocity( self.nProjID )
		AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation + vVelocity * ( 250 / 600 ), 250, 2, false )
		self.flVisionTimer = 250 / 600
	end
end

function jons_ghost_ship:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
    local knockbackProperties =
    {
        center_x = vLocation.x,
        center_y = vLocation.y,
        center_z = vLocation.z,
        duration = self:GetSpecialValueFor("tooltip_delay"),
        knockback_duration = self:GetSpecialValueFor("tooltip_delay"),
        knockback_distance = 380,
        knockback_height = 0
    }

    hTarget:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
  else
    local units = FindUnitsInRadius(self:GetCaster():GetTeam(), vLocation, nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

    for i, target in ipairs(units) do  --Restore health and play a particle effect for every found ally.
        target:EmitSound("Ability.Ghostship.crash")
        local damage = {
            victim = target,
            attacker = self:GetCaster(),
            damage = self:GetAbilityDamage(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self,
        }

        local knockbackProperties =
        {
            center_x = vLocation.x,
            center_y = vLocation.y,
            center_z = vLocation.z,
            duration = self:GetSpecialValueFor("tooltip_delay"),
            knockback_duration = self:GetSpecialValueFor("tooltip_delay"),
            knockback_distance = 380,
            knockback_height = 0
        }
        
        target:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )

        ApplyDamage( damage )
    end
    AddFOWViewer(self:GetCaster():GetTeamNumber(), vLocation, 400, 5, true)
  end

	return false
end

function jons_ghost_ship:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

