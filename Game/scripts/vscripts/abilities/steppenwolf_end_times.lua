steppenwolf_end_times = class({})
LinkLuaModifier( "modifier_steppenwolf_end_times_leap", "abilities/steppenwolf_end_times", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------

function steppenwolf_end_times:OnAbilityPhaseStart()
	if IsServer() then
		local radius = self:GetSpecialValueFor( "radius" )

		self.nPreviewFXIndex = ParticleManager:CreateParticle( "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nPreviewFXIndex, 0, self:GetCursorPosition() )
		ParticleManager:SetParticleControl( self.nPreviewFXIndex, 1, Vector( radius, -radius, -radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFXIndex, 2, Vector( 0.8, 0, 0 ) );
		ParticleManager:ReleaseParticleIndex( self.nPreviewFXIndex )
	end

	return true
end


function steppenwolf_end_times:OnSpellStart()
	if IsServer() then
		local vLocation = self:GetCursorPosition()
		local kv =
		{
			vLocX = vLocation.x,
			vLocY = vLocation.y,
			vLocZ = vLocation.z
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_steppenwolf_end_times_leap", kv )
		EmitSoundOn( "Hero_Techies.BlastOff.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function steppenwolf_end_times:BlowUp()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFXIndex, true )

		local radius = self:GetSpecialValueFor( "radius" )
		local damage = self:GetSpecialValueFor( "damage" )
		local stun_duration = self:GetSpecialValueFor( "stun_duration" )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
					enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun_duration } )

					local DamageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						ability = self,
						damage = damage,
						damage_type = DAMAGE_TYPE_PURE,
					}
					ApplyDamage( DamageInfo )

					self:GetCaster():PerformAttack(enemy, true, true, true, true, true, true, true)
				end
			end
		end

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "nike") == true then
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 0) )
			ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 10, Vector(5, 0, 0) )
			ParticleManager:SetParticleControl( nFXIndex, 11, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 0) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else 
			local nFXIndex = ParticleManager:CreateParticle( "particles/steppenwolf/steppenwolf_end_times_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, 0.0, 1.0 ) )
			ParticleManager:SetParticleControl( nFXIndex, 5, Vector( radius, 0.0, 1.0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end 

		EmitSoundOn( "Hero_Techies.Suicide", self:GetCaster() )
		EmitSoundOn( "Hero_EarthShaker.Gravelmaw", self:GetCaster() )
		EmitSoundOn( "Hero_EarthShaker.Gravelmaw.Cast", self:GetCaster() )
		EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", self:GetCaster() )
		EmitSoundOn( "Hero_EarthShaker.EchoSlam", self:GetCaster() )

		GridNav:DestroyTreesAroundPoint( self:GetCaster():GetOrigin(), radius, false )
	end
end


modifier_steppenwolf_end_times_leap = class({})

--------------------------------------------------------------------------------

local TECHIES_MINIMUM_HEIGHT_ABOVE_LOWEST = 500
local TECHIES_MINIMUM_HEIGHT_ABOVE_HIGHEST = 100
local TECHIES_ACCELERATION_Z = 4000
local TECHIES_MAX_HORIZONTAL_ACCELERATION = 3000

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:OnCreated( kv )
	if IsServer() then
		self.bHorizontalMotionInterrupted = false
		self.bDamageApplied = false
		self.bTargetTeleported = false

		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.vLastKnownTargetPos = self.vLoc

		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		local flDesiredHeight = TECHIES_MINIMUM_HEIGHT_ABOVE_LOWEST * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + TECHIES_MINIMUM_HEIGHT_ABOVE_HIGHEST )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * TECHIES_ACCELERATION_Z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * TECHIES_ACCELERATION_Z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / TECHIES_ACCELERATION_Z, ( self.flInitialVelocityZ - flSqrtDet) / TECHIES_ACCELERATION_Z )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false )

		self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_6)
	end
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeHoriz = math.min( self.flCurrentTimeHoriz + dt, self.flPredictedTotalTime )
		local t = self.flCurrentTimeHoriz / self.flPredictedTotalTime
		local vStartToTarget = self.vLastKnownTargetPos - self.vStartPosition
		local vDesiredPos = self.vStartPosition + t * vStartToTarget

		local vOldPos = me:GetOrigin()
		local vToDesired = vDesiredPos - vOldPos
		vToDesired.z = 0.0
		local vDesiredVel = vToDesired / dt
		local vVelDif = vDesiredVel - self.vHorizontalVelocity
		local flVelDif = vVelDif:Length2D()
		vVelDif = vVelDif:Normalized()
		local flVelDelta = math.min( flVelDif, TECHIES_MAX_HORIZONTAL_ACCELERATION )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:UpdateVerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -TECHIES_ACCELERATION_Z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0
		
		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * TECHIES_ACCELERATION_Z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			if self.bHorizontalMotionInterrupted == false then
				self:GetAbility():BlowUp()
			end

			self:GetParent():RemoveHorizontalMotionController( self )
			self:GetParent():RemoveVerticalMotionController( self )

			self:SetDuration( 0.15, false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.bHorizontalMotionInterrupted = true
	end
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_steppenwolf_end_times_leap:GetOverrideAnimation( params )
	return ACT_DOTA_CAST_ABILITY_6
end

function modifier_steppenwolf_end_times_leap:OnDestroy()
	if IsServer() then 
		self:GetParent():RemoveGesture(ACT_DOTA_CAST_ABILITY_6)
	end	
end

function modifier_steppenwolf_end_times_leap:GetEffectName()
	if self:GetParent():HasModifier("modifier_nike") then   return "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_leap.vpcf" end 
	return 
end