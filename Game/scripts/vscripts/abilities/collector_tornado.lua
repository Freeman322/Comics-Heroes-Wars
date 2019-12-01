collector_tornado = class({})
LinkLuaModifier ("modifier_collector_tornado", "abilities/collector_tornado.lua" , LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

function collector_tornado:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function collector_tornado:IsStealable()
	return false
end

--------------------------------------------------------------------------------

function collector_tornado:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end


function collector_tornado:OnSpellStart()
    if IsServer() then 
        self._iDistance = self:GetOrbSpecialValueFor( "travel_distance", "w" )

        if self:GetCaster():HasTalent("special_bonus_unique_collector_2") then 
            self._iDistance = self._iDistance + 27850
        end 

        self._iSpeed = self:GetSpecialValueFor( "travel_speed" )
        self._iWidth = self:GetSpecialValueFor( "radius_end" )
        self.vision_aoe = self:GetSpecialValueFor( "radius_start" )
        self.vision_duration = self:GetSpecialValueFor( "end_vision_duration" )

        self.fly_duration = self:GetOrbSpecialValueFor( "knockback_duration", "q" )
        self.wave_damage = self:GetOrbSpecialValueFor( "damage","w" )
        self.disarm_duration = self:GetOrbSpecialValueFor( "disarm_duration", "q" )

        local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()

        local vDirection = ( vDirection:Normalized() ) * self._iDistance
        
        local particle_cast = "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6.vpcf"

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alma") then
            particle_cast = "particles/collector/alma_tornado.vpcf"
        end

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "strange_artifact") then
            particle_cast = "particles/stygian/invoker_kid_tornado_ti6.vpcf"
        end
        
        local info = {
            EffectName = particle_cast,
            Ability = self,
            vSpawnOrigin = self:GetCaster():GetOrigin(), 
            fStartRadius = self._iWidth,
            fEndRadius = self._iWidth,
            vVelocity = vDirection:Normalized() * self._iSpeed,
            fDistance = self._iDistance,
            Source = self:GetCaster(),
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            bProvidesVision = true,
            iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
            iVisionRadius = self.vision_aoe,
        }

        self.flVisionTimer = self._iWidth / self._iSpeed
        self.flLastThinkTime = GameRules:GetGameTime()
        self.nProjID = ProjectileManager:CreateLinearProjectile( info )

        EmitSoundOn( "Hero_Invoker.Tornado.Cast.Immortal" , self:GetCaster() )
        
        EmitSoundOn( "invoker_invo_ability_tornado_01" , self:GetCaster() )
    end
end

--------------------------------------------------------------------------------

function collector_tornado:OnProjectileThink( vLocation )
	self.flVisionTimer = self.flVisionTimer - ( GameRules:GetGameTime() - self.flLastThinkTime )

	if self.flVisionTimer <= 0.0 then
		local vVelocity = ProjectileManager:GetLinearProjectileVelocity( self.nProjID )
		AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation + vVelocity * ( self._iWidth / self._iSpeed ), self.vision_aoe, self.vision_duration, false )
		self.flVisionTimer = self._iWidth / self._iSpeed
	end
end


--------------------------------------------------------------------------------

function collector_tornado:OnProjectileHit( hTarget, vLocation )
    if IsServer() then 
        if hTarget ~= nil then
            if hTarget:IsIllusion() then hTarget:ForceKill(false) return end
            
            local damage = {
                victim = hTarget,
                attacker = self:GetCaster(),
                damage = self.wave_damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self,
            }

            ApplyDamage( damage )

            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_collector_tornado", { duration = self.disarm_duration } )
            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_invoker_tornado", { duration = self.fly_duration } )
        end
    end

	return false
end

if not modifier_collector_tornado then modifier_collector_tornado = class({}) end 


function modifier_collector_tornado:IsHidden()
	return false
end

function modifier_collector_tornado:IsPurgable()
    return false
end

function modifier_collector_tornado:GetEffectName()
    return "particles/items2_fx/heavens_halberd_debuff_disarm.vpcf"
end

function modifier_collector_tornado:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_collector_tornado:CheckState()
local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = false
	}
    return state
end
