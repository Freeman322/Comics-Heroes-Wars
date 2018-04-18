venom_posion_damage = class({})

function venom_posion_damage:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function venom_posion_damage:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end
--------------------------------------------------------------------------------

function venom_posion_damage:OnSpellStart()
    local caster = self:GetCaster()
    caster:EmitSound("Hero_Bristleback.ViscousGoo.Cast")
    caster:EmitSound("Hero_Abaddon.DeathCoil.Cast")
    local info = {
        EffectName = "particles/venom_goo.vpcf",
        Ability = self,
        iMoveSpeed = self:GetSpecialValueFor( "goo_speed" ),
        Source = self:GetCaster(),
        Target = self:GetCursorTarget(),
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
    }

    ProjectileManager:CreateTrackingProjectile( info )
end

function venom_posion_damage:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
        local stats = self:GetSpecialValueFor( "stats" )
        local caster = self:GetCaster()
        local damage = self:GetSpecialValueFor( "damage" )
        if self:GetCaster():HasTalent("special_bonus_unique_venom") then
            damage = self:GetCaster():FindTalentValue("special_bonus_unique_venom") + self:GetSpecialValueFor( "damage" )
        end
        local kill_bourder = self:GetSpecialValueFor( "bourder" )
        hTarget:EmitSound("Hero_Bristleback.ViscousGoo.Target")

        local damage = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        }
        ApplyDamage( damage )
        if hTarget:GetHealthPercent() <= kill_bourder then
            hTarget:Kill(self, caster)
        end
        if not hTarget:IsAlive() and hTarget:IsRealHero() then
            caster:SetBaseStrength(caster:GetBaseStrength() + stats)
            caster:CalculateStatBonus()
        end
    end

    return true
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function venom_posion_damage:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

