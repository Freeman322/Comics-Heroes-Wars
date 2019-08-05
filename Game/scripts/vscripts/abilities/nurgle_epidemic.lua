if nurgle_epidemic == nil then nurgle_epidemic = class({}) end

LinkLuaModifier( "modifier_nurgle_epidemic", "abilities/nurgle_epidemic.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function nurgle_epidemic:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetOrigin(),
		fStartRadius = self:GetSpecialValueFor("radius"),
		fEndRadius = self:GetSpecialValueFor("radius"),
		vVelocity = vDirection * self:GetSpecialValueFor("speed"),
		fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
	}

	self.nProjID = ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_Venomancer.VenomousGale" , self:GetCaster() )
end

----------------------------------------------------------------

function nurgle_epidemic:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		EmitSoundOn( "Hero_Venomancer.VenomousGaleImpact" , self:GetCaster() )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_nurgle_epidemic", { duration = self:GetSpecialValueFor("duration") } )
		
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetSpecialValueFor("strike_damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}

		ApplyDamage( damage )
	end

	return false
end

if modifier_nurgle_epidemic == nil then modifier_nurgle_epidemic = class({}) end

function modifier_nurgle_epidemic:IsDebuff()
	return true
end

function modifier_nurgle_epidemic:IsPurgeException()
	return true
end

function modifier_nurgle_epidemic:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_nurgle_epidemic:OnCreated( kv )
	if IsServer() then 
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.slow = self:GetAbility():GetSpecialValueFor( "movement_slow" )
		self.damage = self:GetAbility():GetSpecialValueFor( "tick_damage" ) + self:GetParent():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("tick_damage_per")/100)
		self.tick = 0.25

		EmitSoundOn( "Hero_Pudge.Rot", self:GetParent() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 1, self.radius ) )
		self:AddParticle( nFXIndex, false, false, -1, false, false )
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		self:AddParticle( nFXIndex, false, false, -1, false, false )

		self:StartIntervalThink( self.tick )
		self:OnIntervalThink()
	end 
end


function modifier_nurgle_epidemic:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Pudge.Rot", self:GetParent() )
	end
end


function modifier_nurgle_epidemic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function modifier_nurgle_epidemic:GetModifierMoveSpeedBonus_Percentage( params )
	return self.slow
end


function modifier_nurgle_epidemic:OnIntervalThink()
	if IsServer() then
		local flDamagePerTick = self.tick * self.damage
		local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #units > 0 then
			for _,unit in pairs(units) do
				local damage = {
					victim = self:GetParent(),
					attacker = self:GetCaster(),
					damage = flDamagePerTick,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility()
				}
		
				if not unit == self:GetParent() then
					unit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_nurgle_epidemic", { duration = self:GetAbility():GetSpecialValueFor( "duration" ) } )
				end
				
				ApplyDamage( damage )
			end
	  	end
	end	
end

function modifier_nurgle_epidemic:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

  
function nurgle_epidemic:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

