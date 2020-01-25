aqua_man_wave = class({})

--------------------------------------------------------------------------------

function aqua_man_wave:OnSpellStart()
    if IsServer() then
        self.aqua_man_wave_speed = self:GetSpecialValueFor( "wave_speed" )
        self.aqua_man_wave_width_initial = self:GetSpecialValueFor( "wave_width_initial" )
        self.aqua_man_wave_width_end = self:GetSpecialValueFor( "wave_width_end" )
        self.aqua_man_wave_distance = self:GetSpecialValueFor( "wave_distance" )
        local agility = self:GetCaster():GetAgility() * self:GetSpecialValueFor("bonus_damage_agi")
        self.aqua_man_wave_damage = self:GetSpecialValueFor( "wave_damage" ) + agility

        EmitSoundOn( "Hero_NagaSiren.Riptide.Cast", self:GetCaster() )

        local vPos = nil
        if self:GetCursorTarget() then
            vPos = self:GetCursorTarget():GetOrigin()
        else
            vPos = self:GetCursorPosition()
        end

        local vDirection = vPos - self:GetCaster():GetOrigin()
        vDirection.z = 0.0
        vDirection = vDirection:Normalized()

        self.aqua_man_wave_speed = self.aqua_man_wave_speed * ( self.aqua_man_wave_distance / ( self.aqua_man_wave_distance - self.aqua_man_wave_width_initial ) )

        local info = {
            EffectName = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf",
            Ability = self,
            vSpawnOrigin = self:GetCaster():GetOrigin(), 
            fStartRadius = self.aqua_man_wave_width_initial,
            fEndRadius = self.aqua_man_wave_width_end,
            vVelocity = vDirection * self.aqua_man_wave_speed,
            fDistance = self.aqua_man_wave_distance,
            Source = self:GetCaster(),
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        }

        ProjectileManager:CreateLinearProjectile( info )
        EmitSoundOn( "Hero_Tidehunter.Gush.AghsProjectile", self:GetCaster() )
    end
end

--------------------------------------------------------------------------------

function aqua_man_wave:OnProjectileHit( hTarget, vLocation )
    if IsServer() then
        if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
            local damage = {
                victim = hTarget,
                attacker = self:GetCaster(),
                damage = self.aqua_man_wave_damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self
            }
            EmitSoundOn( "Ability.GushImpact" , hTarget)

            ApplyDamage( damage )

            local vDirection = vLocation - self:GetCaster():GetOrigin()
            vDirection.z = 0.0
            vDirection = vDirection:Normalized()
            
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_tidehunter/tidehunter_gush_splash_water3.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
            ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
            ParticleManager:ReleaseParticleIndex( nFXIndex )

            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_tidehunter_gush", {duration = 2.5})
        end
    end

	return false
end
