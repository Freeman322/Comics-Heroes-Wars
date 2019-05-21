---@class misterio_telekinetic_force
LinkLuaModifier( "modifier_misterio_telekinetic_force", "abilities/misterio_telekinetic_force.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_misterio_telekinetic_force_push", "abilities/misterio_telekinetic_force.lua", LUA_MODIFIER_MOTION_BOTH )

---DONT USE ON Illusions!

misterio_telekinetic_force = class({})

misterio_telekinetic_force.m_iRadius = 0
misterio_telekinetic_force.m_hTarget = nil
misterio_telekinetic_force.m_iCount = 1

function misterio_telekinetic_force:IsRefreshable() return false end 

function misterio_telekinetic_force:OnSpellStart() 
    	if IsServer() then
		local hTarget = self:GetCursorTarget()
		if hTarget ~= nil then
            	self.m_iRadius = self:GetSpecialValueFor("radius")

			local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), self:GetCaster(), self.m_iRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
			if units ~= nil then
				if #units > 0 then
					self.m_iCount = #units

					for _, unit in pairs(units) do
						if unit ~= self:GetCaster() then
							unit:AddNewModifier(self:GetCaster(), self, "modifier_misterio_telekinetic_force", {duration = self:GetSpecialValueFor("duration"),
							target = hTarget:entindex(),
							count = #units})
						end
					end
				end
			end
		end
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/death/monkey_king_spring_death_base.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.m_iRadius, self.m_iRadius, 0) )
		ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_Rubick.SpellSteal.Cast.Arcana", self:GetCaster() )

        	self.m_hTarget = hTarget
    	end 
end 

function misterio_telekinetic_force:OnTargetLanded(unit, pos)
    if IsServer() and self.m_hTarget then
	  	local damage_per_target = self:GetSpecialValueFor("bonus_damage")

		if self:GetCaster():HasTalent("special_bonus_unique_misterio_4") then 
			damage_per_target = damage_per_target + self:GetCaster():FindTalentValue("special_bonus_unique_misterio_4")
		end 

        	local stun_dur = self:GetSpecialValueFor("stun")

       	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
		
       	ApplyDamage({
			attacker = self:GetCaster(),
			victim = self.m_hTarget,
			ability = self,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage = damage_per_target
		})
		
		self.m_hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_dur})

		if not unit:IsFriendly(self:GetCaster()) then
			unit:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_dur})

			ApplyDamage({
				attacker = self:GetCaster(),
				victim = unit,
				ability = self,
				damage_type = self:GetAbilityDamageType(),
				damage = damage_per_target * self.m_iCount
			})
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_land_force.vpcf", PATTACH_CUSTOMORIGIN, self.m_hTarget )
		ParticleManager:SetParticleControl( nFXIndex, 0, self.m_hTarget:GetOrigin())
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_Rubick.Telekinesis.Target.Land", self.m_hTarget )
	end
end


---@class modifier_misterio_telekinetic_force

modifier_misterio_telekinetic_force = class({})

local VISUAL_Z_DELTA = 150

modifier_misterio_telekinetic_force.m_hTarget = nil

function modifier_misterio_telekinetic_force:IsHidden() return false end
function modifier_misterio_telekinetic_force:IsPurgable() return false end
function modifier_misterio_telekinetic_force:RemoveOnDeath() return false end
function modifier_misterio_telekinetic_force:IsDebuff() return true end
function modifier_misterio_telekinetic_force:IsStunDebuff() return true end

function modifier_misterio_telekinetic_force:OnCreated(params)
    if IsServer() then
		self.m_hTarget = params.target
		
		EmitSoundOn("Hero_Rubick.Telekinesis.Target", self:GetParent())
    end 
end

function modifier_misterio_telekinetic_force:OnDestroy()
    if IsServer() then
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_misterio_telekinetic_force_push", {
            target = self.m_hTarget
		})
		
		EmitSoundOn("Hero_Rubick.Telekinesis.Cast", self:GetParent())
    end 
end

function modifier_misterio_telekinetic_force:GetEffectName()
	return "particles/misterio/telekinesis_puppet.vpcf"
end

function modifier_misterio_telekinetic_force:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_misterio_telekinetic_force:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}

	return funcs
end

function modifier_misterio_telekinetic_force:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

function modifier_misterio_telekinetic_force:GetVisualZDelta(params)
	return VISUAL_Z_DELTA
end

function modifier_misterio_telekinetic_force:CheckState()
	local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

---@class modifier_misterio_telekinetic_force_push 

modifier_misterio_telekinetic_force_push = class({})

local MINIMUM_HEIGHT_ABOVE_LOWEST = 500
local MINIMUM_HEIGHT_ABOVE_HIGHEST = 100
local ACCELERATION_Z = 4000
local MAX_HORIZONTAL_ACCELERATION = 3000

--------------------------------------------------------------------------------
---
function modifier_misterio_telekinetic_force_push:IsStunDebuff() return true end
function modifier_misterio_telekinetic_force_push:IsHidden() return true end
function modifier_misterio_telekinetic_force_push:IsPurgable() return false end
function modifier_misterio_telekinetic_force_push:RemoveOnDeath() return false end

--------------------------------------------------------------------------------

function modifier_misterio_telekinetic_force_push:OnCreated( kv )
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

        local target = EntIndexToHScript(kv.target)

		self.vLoc = target:GetAbsOrigin()
		self.vLastKnownTargetPos = self.vLoc

		local duration = 0.0
		local flDesiredHeight = MINIMUM_HEIGHT_ABOVE_LOWEST * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + MINIMUM_HEIGHT_ABOVE_HIGHEST )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * ACCELERATION_Z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * ACCELERATION_Z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / ACCELERATION_Z, ( self.flInitialVelocityZ - flSqrtDet) / ACCELERATION_Z )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0
	end
end

--------------------------------------------------------------------------------

function modifier_misterio_telekinetic_force_push:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_misterio_telekinetic_force_push:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_misterio_telekinetic_force_push:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_misterio_telekinetic_force_push:UpdateHorizontalMotion( me, dt )
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
		local flVelDelta = math.min( flVelDif, MAX_HORIZONTAL_ACCELERATION )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

--------------------------------------------------------------------------------

function modifier_misterio_telekinetic_force_push:UpdateVerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -ACCELERATION_Z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0
		
		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * ACCELERATION_Z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			if self.bHorizontalMotionInterrupted == false then
				self:GetAbility():OnTargetLanded(self:GetParent(), self:GetParent():GetAbsOrigin())
			end

			self:GetParent():RemoveHorizontalMotionController( self )
			self:GetParent():RemoveVerticalMotionController( self )

			self:SetDuration( 0.15, false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_misterio_telekinetic_force_push:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.bHorizontalMotionInterrupted = true
	end
end

--------------------------------------------------------------------------------

function modifier_misterio_telekinetic_force_push:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_misterio_telekinetic_force_push:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

function modifier_misterio_telekinetic_force_push:OnDestroy()
	if IsServer() then 

	end	
end