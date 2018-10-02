if daredevil_paunce == nil then daredevil_paunce = class({}) end

LinkLuaModifier( "modifier_daredevil_paunce_leap", "abilities/daredevil_paunce.lua", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------
function daredevil_paunce:OnAbilityPhaseStart()
    if IsServer() then
        self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START)
    end
    return true
end
function daredevil_paunce:OnSpellStart()
    if IsServer() then
        local vLocation = self:GetCursorPosition()
        local kv =
        {
            vLocX = vLocation.x,
            vLocY = vLocation.y,
            vLocZ = vLocation.z
        }
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_daredevil_paunce_leap", kv )
        EmitSoundOn( "Hero_MonkeyKing.TreeJump.Cast", self:GetCaster() )

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_cast.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        --ParticleManager:SetParticleControl( nFXIndex, 1, Vector( hAbility:GetSpecialValueFor( "aftershock_range" ), 1, 1 ) )
        --ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 500, 1, 1 ) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
    end
end

if modifier_daredevil_paunce_leap == nil then modifier_daredevil_paunce_leap = class({}) end

--------------------------------------------------------------------------------

local TECHIES_MINIMUM_HEIGHT_ABOVE_LOWEST = 800
local TECHIES_MINIMUM_HEIGHT_ABOVE_HIGHEST = 400
local TECHIES_ACCELERATION_Z = 4000
local TECHIES_MAX_HORIZONTAL_ACCELERATION = 3000

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:IsStunDebuff()
    return true
end

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:IsHidden()
    return true
end

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:RemoveOnDeath()
    return false
end

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:OnCreated( kv )
    if IsServer() then
        self.bHorizontalMotionInterrupted = false
        self.bDamageApplied = false
        self.bTargetTeleported = false

        if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then
            self:Destroy()
            return
        end

        self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START)

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
    end
end

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveHorizontalMotionController( self )
        self:GetParent():RemoveVerticalMotionController( self )
    end
end

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:DeclareFunctions()
    local funcs =
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:CheckState()
    local state =
    {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:UpdateHorizontalMotion( me, dt )
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

function modifier_daredevil_paunce_leap:UpdateVerticalMotion( me, dt )
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
               --- self:GetAbility():BlowUp()
            end

            self:GetParent():RemoveHorizontalMotionController( self )
            self:GetParent():RemoveVerticalMotionController( self )

            self:SetDuration( 0.15, false)
        end
    end
end

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:OnHorizontalMotionInterrupted()
    if IsServer() then
        self.bHorizontalMotionInterrupted = true
    end
end

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:OnVerticalMotionInterrupted()
    if IsServer() then
        self:GetParent():RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
        self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
        self:Destroy()
    end
end

--------------------------------------------------------------------------------

function modifier_daredevil_paunce_leap:GetOverrideAnimation( params )
    return ACT_DOTA_CAST_ABILITY_2
end

function daredevil_paunce:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

