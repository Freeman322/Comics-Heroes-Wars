kratos_axe_twrow = class({})

LinkLuaModifier( "modifier_kratos_axe_twrow", "abilities/kratos_axe_twrow.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
local SPEED = 1200
local WIDTH = 200

kratos_axe_twrow.nDamage = 0
kratos_axe_twrow.nDamagePerHit = 0

function kratos_axe_twrow:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()

	local info = {
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fStartRadius = WIDTH,
		fEndRadius = WIDTH,
		vVelocity = vDirection * SPEED,
		fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = WIDTH,
    }

     ProjectileManager:CreateTrackingProjectile({
        EffectName = "particles/units/heroes/hero_beastmaster/beastmaster_wildaxe_copy.vpcf",
        Ability = self,
        iMoveSpeed = SPEED,
        Source = self:GetCaster(),
        Target = self:GetCursorTarget(),
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
    })

    self.nDamage = self:GetSpecialValueFor("axe_damage")

    self.nDamagePerHit = self:GetSpecialValueFor("damage_amp")

    if self:GetCaster():HasTalent("special_bonus_unique_kratos") then
        self.nDamagePerHit = self.nDamagePerHit + (self:GetCaster():FindTalentValue("special_bonus_unique_kratos") or 0)
    end

    self.nProjID = ProjectileManager:CreateLinearProjectile( info )

	EmitSoundOn( "Hero_Beastmaster.Wild_Axes" , self:GetCaster() )
end
--------------------------------------------------------------------------------

function kratos_axe_twrow:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil then
		self.nDamage = self.nDamage + self.nDamagePerHit

			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.nDamage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self
			}

			ApplyDamage( damage )

		EmitSoundOn("Hero_Beastmaster.Attack", hTarget)

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("duration") } )

		self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true)
	end

	return false
end
