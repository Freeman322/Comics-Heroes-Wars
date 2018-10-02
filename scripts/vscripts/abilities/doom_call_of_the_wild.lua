doom_call_of_the_wild = class({})
LinkLuaModifier( "modifier_doom_call_of_the_wild_leap", "abilities/doom_call_of_the_wild", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_doom_call_of_the_wild_buff", "abilities/doom_call_of_the_wild", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------

function doom_call_of_the_wild:OnAbilityPhaseStart()
	if IsServer() then
		---self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_doom_call_of_the_wild_leap", { duration = 3 } )
	end

	return true
end

--------------------------------------------------------------------------------

function doom_call_of_the_wild:OnAbilityPhaseInterrupted()
	if IsServer() then
		---self:GetCaster():RemoveModifierByName( "modifier_doom_call_of_the_wild_leap" )
	end
end

--------------------------------------------------------------------------------

function doom_call_of_the_wild:OnSpellStart()
	if IsServer() then
		local vLocation = self:GetCursorPosition()
		local kv =
		{
			vLocX = vLocation.x,
			vLocY = vLocation.y,
			vLocZ = vLocation.z
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_doom_call_of_the_wild_leap", kv )

		EmitSoundOn( "Hero_EarthShaker.Totem.Immortal", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function doom_call_of_the_wild:BlowUp()
	if IsServer() then
	
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_cast.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_EarthShaker.Gravelmaw", self:GetCaster() )
		EmitSoundOn( "Hero_EarthShaker.Gravelmaw.Cast", self:GetCaster() )
		EmitSoundOn( "Hero_EarthShaker.Totem.TI6.Layer", self:GetCaster() )

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_doom_call_of_the_wild_buff", { duration = self:GetSpecialValueFor("duration") } )
	end
end


modifier_doom_call_of_the_wild_leap = class({})

--------------------------------------------------------------------------------

local TECHIES_MINIMUM_HEIGHT_ABOVE_LOWEST = 500
local TECHIES_MINIMUM_HEIGHT_ABOVE_HIGHEST = 100
local TECHIES_ACCELERATION_Z = 4000
local TECHIES_MAX_HORIZONTAL_ACCELERATION = 3000

--------------------------------------------------------------------------------

function modifier_doom_call_of_the_wild_leap:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_doom_call_of_the_wild_leap:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_doom_call_of_the_wild_leap:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_doom_call_of_the_wild_leap:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_doom_call_of_the_wild_leap:OnCreated( kv )
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

		local duration = 0.0
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
	end
end

--------------------------------------------------------------------------------

function modifier_doom_call_of_the_wild_leap:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_doom_call_of_the_wild_leap:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_doom_call_of_the_wild_leap:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_doom_call_of_the_wild_leap:UpdateHorizontalMotion( me, dt )
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

function modifier_doom_call_of_the_wild_leap:UpdateVerticalMotion( me, dt )
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

function modifier_doom_call_of_the_wild_leap:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.bHorizontalMotionInterrupted = true
	end
end

--------------------------------------------------------------------------------

function modifier_doom_call_of_the_wild_leap:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_doom_call_of_the_wild_leap:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

function modifier_doom_call_of_the_wild_leap:OnDestroy()
	if IsServer() then 

	end	
end

modifier_doom_call_of_the_wild_buff = class({})

function modifier_doom_call_of_the_wild_buff:OnCreated (event)
    if IsServer() then

    end
end

function modifier_doom_call_of_the_wild_buff:DeclareFunctions()
	local funcs = {
    	MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    	MODIFIER_EVENT_ON_ATTACK_LANDED
    }
	return funcs
end

function modifier_doom_call_of_the_wild_buff:IsHidden()
	return true
end

function modifier_doom_call_of_the_wild_buff:IsPurgable()
	return false
end

function modifier_doom_call_of_the_wild_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("damage_buff")
end

function modifier_doom_call_of_the_wild_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_phoenix_burning.vpcf"
end

function modifier_doom_call_of_the_wild_buff:StatusEffectPriority()
	return 1000
end

function modifier_doom_call_of_the_wild_buff:GetEffectName()
	return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end

function modifier_doom_call_of_the_wild_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_doom_call_of_the_wild_buff:OnAttackLanded (params)
	if IsServer() then
	    if params.attacker == self:GetParent() then
	      	local target = params.target
	      	target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 1.5})
	      	self:Destroy()
		end
	end
end