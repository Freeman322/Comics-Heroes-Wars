if gorr_seduction == nil then gorr_seduction = class({}) end

function gorr_seduction:OnSpellStart()
    local radius = self:GetSpecialValueFor( "radius" )
    local duration = self:GetSpecialValueFor(  "stun_duration" )
    local deal_damage = self:GetCaster():HasTalent("special_bonus_unique_gorr_5")
    local damage = self:GetSpecialValueFor(  "stomp_damage" )

    if self:GetCaster():HasTalent("special_bonus_unique_gorr_4") then duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_gorr_4") end

    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
    if #units > 0 then
        for _,target in pairs(units) do
            target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )

            local bonus_damage = 0

            if deal_damage then
                bonus_damage = self:GetCaster():GetAverageTrueAttackDamage(target)
            end

            EmitSoundOn("Hero_VoidSpirit.AetherRemnant.Triggered", target)
            EmitSoundOn("Hero_VoidSpirit.AetherRemnant.Target", target)

            ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage + bonus_damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
        end
    end

    local nFXIndex = ParticleManager:CreateParticle( "particles/gorr/gorr_scream.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    EmitSoundOn( "Hero_VoidSpirit.AetherRemnant.Cast", self:GetCaster() )

    self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

function gorr_seduction:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

