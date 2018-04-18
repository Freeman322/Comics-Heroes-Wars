if god_emperor_menthal_spear == nil then god_emperor_menthal_spear = class({}) end

LinkLuaModifier( "modifier_god_emperor_menthal_spear", "abilities/god_emperor_menthal_spear.lua", LUA_MODIFIER_MOTION_NONE )
fvPointOrigin = 0
function god_emperor_menthal_spear:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end
local vPoint
--------------------------------------------------------------------------------

function god_emperor_menthal_spear:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function god_emperor_menthal_spear:GetChannelTime()
	return 1
end

--------------------------------------------------------------------------------

function god_emperor_menthal_spear:OnAbilityPhaseStart()
	if IsServer() then
		self.vPoint = self:GetCursorPosition()
	end

	return true
end

--------------------------------------------------------------------------------

function god_emperor_menthal_spear:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_god_emperor_menthal_spear", { duration = self:GetChannelTime() } )
    end
end


--------------------------------------------------------------------------------

function god_emperor_menthal_spear:OnChannelFinish( bInterrupted )
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
            vVelocity = vDirection * (self:GetSpecialValueFor("arrow_speed") + 2000),
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

        self.nParticleFXIndex = ParticleManager:CreateParticle( "particles/hero_god_emperor/god_emperor_menthal_spear_base.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleAlwaysSimulate( self.nParticleFXIndex )

        EmitSoundOn( "Ability.Powershot.Alt" , self:GetCaster() )
        EmitSoundOn( "Hero_Windrunner.Powershot.FalconBow" , self:GetCaster() )
        EmitSoundOn( "Ability.Powershot" , self:GetCaster() )
        EmitSoundOn( "Hero_AbyssalUnderlord.Pit.TargetHero" , self:GetCaster() )
    else
        if self:GetCaster():HasModifier("modifier_god_emperor_menthal_spear") then
            self:GetCaster():RemoveModifierByName("modifier_god_emperor_menthal_spear")
        end
    end
end

function god_emperor_menthal_spear:OnProjectileHit_ExtraData( hTarget, vLocation, table )
    if hTarget == nil then
        local hCaster = self:GetCaster()
        local nFXIndex = ParticleManager:CreateParticle( "particles/thanos/thanos_supernova_explode_a.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControl( nFXIndex, 0, vLocation);
        ParticleManager:SetParticleControl( nFXIndex, 1, vLocation);
        ParticleManager:SetParticleControl( nFXIndex, 3, vLocation);
        ParticleManager:SetParticleControl( nFXIndex, 5, Vector(350, 350, 0));
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOnLocationWithCaster(vLocation, "Hero_EarthShaker.EchoSlam", hCaster)
        EmitSoundOnLocationWithCaster(vLocation, "Hero_EarthShaker.EchoSlamSmall", hCaster)
        EmitSoundOnLocationWithCaster(vLocation, "PudgeWarsClassic.echo_slam", hCaster)

        ParticleManager:DestroyParticle(self.nParticleFXIndex, true)
        EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse", self:GetCaster() )
        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_god_emperor/god_emperor_menthal_spear_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl(nFXIndex, 0, vLocation)
        ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self:GetSpecialValueFor("arrow_width"), self:GetSpecialValueFor("arrow_width"), 0))
        ParticleManager:SetParticleControl(nFXIndex, 2, vLocation)
        ParticleManager:SetParticleControl(nFXIndex, 3, vLocation)
        ParticleManager:ReleaseParticleIndex(nFXIndex)
        local units = FindUnitsInRadius(hCaster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("arrow_width"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

        for i, target in ipairs(units) do  --Restore health and play a particle effect for every found ally.
            target:EmitSound("Hero_ObsidianDestroyer.EssenceAura")
            local damage = {
                victim = target,
                attacker = hCaster,
                damage = self:GetAbilityDamage(),
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self,
            }

            ApplyDamage( damage )
        end
        AddFOWViewer(self:GetCaster():GetTeamNumber(), vLocation, 400, 5, true)
        return nil
    end
end
--------------------------------------------------------------------------------

function god_emperor_menthal_spear:OnProjectileThink( vLocation )
    if self.traveled < self.distance/2 then
		-- Go up
		-- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
		self.leap_z = self.leap_z + (self.speed/2)
		-- Set the new location to the current ground location + the memorized z point
        ParticleManager:SetParticleControl( self.nParticleFXIndex, 0, vLocation + Vector(0, 0, self.leap_z))
        ParticleManager:SetParticleControl( self.nParticleFXIndex, 1, vLocation + Vector(0, 0, self.leap_z))
        ParticleManager:SetParticleControl( self.nParticleFXIndex, 2, vLocation + Vector(0, 0, self.leap_z))
        ParticleManager:SetParticleControl( self.nParticleFXIndex, 3, vLocation + Vector(0, 0, self.leap_z))
        ParticleManager:SetParticleControl( self.nParticleFXIndex, 4, vLocation + Vector(0, 0, self.leap_z))
	else
		-- Go down
		self.leap_z = self.leap_z - (self.speed/2)
		ParticleManager:SetParticleControl( self.nParticleFXIndex, 0, vLocation + Vector(0, 0, self.leap_z))
        ParticleManager:SetParticleControl( self.nParticleFXIndex, 1, vLocation + Vector(0, 0, self.leap_z))
        ParticleManager:SetParticleControl( self.nParticleFXIndex, 2, vLocation + Vector(0, 0, self.leap_z))
        ParticleManager:SetParticleControl( self.nParticleFXIndex, 3, vLocation + Vector(0, 0, self.leap_z))
        ParticleManager:SetParticleControl( self.nParticleFXIndex, 4, vLocation + Vector(0, 0, self.leap_z))
	end
    self.traveled = (vLocation - self.start_pos):Length2D()
end


if modifier_god_emperor_menthal_spear == nil then modifier_god_emperor_menthal_spear = class({}) end

function modifier_god_emperor_menthal_spear:OnCreated( kv )
    if IsServer() then
       local nFXIndex = ParticleManager:CreateParticle( "particles/hero_god_emperor/god_emperor_menthal_spear_load.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	   ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_book", self:GetParent():GetOrigin(), true )
	   ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_book", self:GetParent():GetOrigin(), true )
	   self:AddParticle( nFXIndex, false, false, -1, false, true )

	   EmitSoundOn("Ability.PowershotPull.Lyralei", self:GetParent())
       EmitSoundOn("Ability.PowershotPull.Sparrowhawk", self:GetParent())
       EmitSoundOn("Ability.PowershotPull.Stinger", self:GetParent())
    end
end

function modifier_god_emperor_menthal_spear:OnDestroy()
   if IsServer() then

   end
end

function modifier_god_emperor_menthal_spear:IsPurgable()
	return false
end

function modifier_god_emperor_menthal_spear:IsHidden()
	return true
end

function god_emperor_menthal_spear:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

