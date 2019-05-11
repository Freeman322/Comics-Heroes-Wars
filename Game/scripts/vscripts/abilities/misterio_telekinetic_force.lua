---@class misterio_telekinetic_force
LinkLuaModifier( "modifier_misterio_telekinetic_force", "abilities/misterio_telekinetic_force.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_misterio_telekinetic_force_push", "abilities/misterio_telekinetic_force.lua", LUA_MODIFIER_MOTION_NONE )

---DONT USE ON Illusions!

misterio_telekinetic_force = class({})

misterio_telekinetic_force.m_iRadius = 0
misterio_telekinetic_force.m_hTarget = nil

function misterio_telekinetic_force:IsRefreshable() return false end 

function misterio_telekinetic_force:OnSpellStart() 
    if IsServer() then
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            self.m_iRadius = self:GetSpecialValueFor("radius")

            local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.m_iRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
            if units ~= nil then
                if #units > 0 then
                    for _, unit in pairs(units) do
                        unit:AddNewModifier(self:GetCaster(), self, "modifier_misterio_telekinetic_force", {duration = self:GetSpecialValueFor("lift_duration"),
                        target = hTarget:entindex()})
                    end
                end
            end
        end

        self.m_hTarget = hTarget
    end 
end 

function misterio_telekinetic_force:OnTargetLanded(unit, pos)
    if IsServer() and self.m_hTarget then
        local damage_per_target = self:GetSpecialValueFor("damage")
        local stun_dur = self:GetSpecialValueFor("stun")

        FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)

        ApplyDamage({
            attaker = self:GetCaster(),
            victim = self.m_hTarget,
            ability = self,
            damage_type = self:GetAbilityDamageType(),
            damage = damage_per_target
        })

        self.m_hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_dur})

        if not unit:IsFriendly(self:GetCaster()) then
            unit:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_dur})
            
            ApplyDamage({
                attaker = self:GetCaster(),
                victim = unit,
                ability = self,
                damage_type = self:GetAbilityDamageType(),
                damage = damage_per_target
            })
        end
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
    end 
end

function modifier_misterio_telekinetic_force:OnDestroy()
    if IsServer() then
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_misterio_telekinetic_force_push", {
            target = self.m_hTarget
        })
    end 
end

function modifier_misterio_telekinetic_force:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_misterio_telekinetic_force:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
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

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/blast_off_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false )
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