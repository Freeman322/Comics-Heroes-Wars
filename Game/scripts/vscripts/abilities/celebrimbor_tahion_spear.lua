if celebrimbor_tahion_spear == nil then celebrimbor_tahion_spear = class({}) end

LinkLuaModifier( "modifier_celebrimbor_tahion_spear", "abilities/celebrimbor_tahion_spear.lua", LUA_MODIFIER_MOTION_NONE )

fvPointOrigin = 0

function celebrimbor_tahion_spear:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end


function celebrimbor_tahion_spear:GetAOERadius()
    return 400
end

function celebrimbor_tahion_spear:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT+ DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end


local vPoint
--------------------------------------------------------------------------------

function celebrimbor_tahion_spear:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function celebrimbor_tahion_spear:GetChannelTime()
	return 1
end

--------------------------------------------------------------------------------

function celebrimbor_tahion_spear:OnAbilityPhaseStart()
	if IsServer() then
		self.vPoint = self:GetCursorPosition()
	end

	return true
end

--------------------------------------------------------------------------------

function celebrimbor_tahion_spear:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_celebrimbor_tahion_spear", { duration = self:GetChannelTime() } )
    end
end


--------------------------------------------------------------------------------

function celebrimbor_tahion_spear:OnChannelFinish( bInterrupted )
	if bInterrupted == false then
        local vDirection = self.vPoint - self:GetCaster():GetOrigin()
        vDirection = vDirection:Normalized()

        self.speed = 3000/25
        self.leap_z = 0
        self.traveled = 0
        self.start_pos = self:GetCaster():GetAbsOrigin()
        self.distance = (self.vPoint - self:GetCaster():GetOrigin()):Length2D()

        fvPointOrigin = self.vPoint
        self.info = {
            Ability = self,
            vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
            fStartRadius = 320,
            fEndRadius = 320,
            vVelocity = vDirection * 3000,
            fDistance = self.distance,
            Source = self:GetCaster(),
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            bProvidesVision = true,
            iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
            iVisionRadius = 400,
        }
        self.nProjID = ProjectileManager:CreateLinearProjectile( self.info )

        EmitSoundOn( "Ability.Powershot.Alt" , self:GetCaster() )
        EmitSoundOn( "Hero_Windrunner.Powershot.FalconBow" , self:GetCaster() )
        EmitSoundOn( "Ability.Powershot" , self:GetCaster() )
        EmitSoundOn( "Hero_AbyssalUnderlord.Pit.TargetHero" , self:GetCaster() )
    else
        if self:GetCaster():HasModifier("modifier_celebrimbor_tahion_spear") then
            self:GetCaster():RemoveModifierByName("modifier_celebrimbor_tahion_spear")
        end
    end
end

function celebrimbor_tahion_spear:OnProjectileHit_ExtraData( hTarget, vLocation, table )
    if hTarget == nil then
        local hCaster = self:GetCaster()
        local nFXIndex = ParticleManager:CreateParticle( "particles/celembribor/tahion_spear_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControl( nFXIndex, 0, vLocation);
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(350, 350, 0));
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOnLocationWithCaster(vLocation, "Hero_EarthShaker.EchoSlam", hCaster)
        EmitSoundOnLocationWithCaster(vLocation, "Hero_EarthShaker.EchoSlamSmall", hCaster)
        EmitSoundOnLocationWithCaster(vLocation, "PudgeWarsClassic.echo_slam", hCaster)
        EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse", self:GetCaster() )

        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_god_emperor/god_emperor_menthal_spear_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl(nFXIndex, 0, vLocation)
        ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self:GetSpecialValueFor("arrow_width"), self:GetSpecialValueFor("arrow_width"), 0))
        ParticleManager:SetParticleControl(nFXIndex, 2, vLocation)
        ParticleManager:SetParticleControl(nFXIndex, 3, vLocation)
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        local units = FindUnitsInRadius(hCaster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

        for i, target in ipairs(units) do 
            target:EmitSound("Hero_ObsidianDestroyer.EssenceAura")
            
            target:AddNewModifier (caster, self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration") })

            local damage = {
                victim = target,
                attacker = hCaster,
                damage = self:GetAbilityDamage(),
                damage_type = DAMAGE_TYPE_PURE,
                ability = self,
            }

            ApplyDamage( damage )
        end
        AddFOWViewer(self:GetCaster():GetTeamNumber(), vLocation, 400, 5, true)
        return nil
    end
end


if modifier_celebrimbor_tahion_spear == nil then modifier_celebrimbor_tahion_spear = class({}) end

function modifier_celebrimbor_tahion_spear:OnCreated( kv )
    if IsServer() then
       local nFXIndex = ParticleManager:CreateParticle( "particles/celembribor/tahion_spear_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	   ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_atack2", self:GetParent():GetOrigin(), true )
	   ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_atack2", self:GetParent():GetOrigin(), true )
	   self:AddParticle( nFXIndex, false, false, -1, false, true )

	   EmitSoundOn("Ability.PowershotPull.Lyralei", self:GetParent())
       EmitSoundOn("Ability.PowershotPull.Sparrowhawk", self:GetParent())
       EmitSoundOn("Ability.PowershotPull.Stinger", self:GetParent())
    end
end

function modifier_celebrimbor_tahion_spear:OnDestroy()
   if IsServer() then

   end
end

function modifier_celebrimbor_tahion_spear:IsPurgable()
	return false
end

function modifier_celebrimbor_tahion_spear:IsHidden()
	return true
end

function celebrimbor_tahion_spear:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

