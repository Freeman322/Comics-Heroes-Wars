aqua_man_waveform = class({})
LinkLuaModifier( "modifier_aqua_man_waveform", "abilities/aqua_man_waveform.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aqua_man_waveform_debuff", "abilities/aqua_man_waveform.lua", LUA_MODIFIER_MOTION_NONE )


function aqua_man_waveform:OnSpellStart(  )
    if IsServer() then
        local caster = self:GetCaster()
        local absorigin = caster:GetAbsOrigin()
        local target_origin = caster:GetCursorPosition()

        local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
        vDirection = vDirection:Normalized()
        local fDistance = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Length2D()

        local prj = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"

        local info = {
            EffectName = prj,
            Ability = self,
            vSpawnOrigin = self:GetCaster():GetOrigin(),
            fStartRadius = 200,
            fEndRadius = 200,
            iMoveSpeed = 1250,
            vVelocity = vDirection * 1000,
            fDistance = fDistance,
            Source = self:GetCaster(),
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            bProvidesVision = true,
            iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
            iVisionRadius = 150,
        }
        local duration = (fDistance/1000)
        EmitSoundOn( "Hero_Morphling.Waveform" , self:GetCaster() )
        caster:AddNewModifier( caster, self, "modifier_aqua_man_waveform", {duration = duration} )
        self.nProjID = ProjectileManager:CreateLinearProjectile( info )
    end
end

function aqua_man_waveform:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil then   
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self,
            
        }

        if self:GetCaster():HasTalent("special_bonus_unique_aqua_man") then 
            self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true) 
        end

        EmitSoundOn( "Hero_Morphling.AdaptiveStrikeAgi.Target" , hTarget)
      		       
        ApplyDamage( damage )
	end

	return false
end

modifier_aqua_man_waveform = class({})
function modifier_aqua_man_waveform:IsHidden()
    return true
end

function modifier_aqua_man_waveform:OnCreated( kv )
    if IsServer() then
        self:GetParent():AddNoDraw()
        local nFXIndex = ParticleManager:CreateParticle( "", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 5, Vector(200, 200, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        self.destroy_pos = self:GetAbility():GetCaster():GetCursorPosition()
    end
end
function modifier_aqua_man_waveform:OnDestroy(  )
     if IsServer() then
        self:GetParent():RemoveNoDraw()
        self:GetParent():SetAbsOrigin( self.destroy_pos )
        FindClearSpaceForUnit( self:GetParent(), self.destroy_pos, false )
        -- Place a unit somewhere not already occupied.
    end
end

function modifier_aqua_man_waveform:CheckState()
	local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end
