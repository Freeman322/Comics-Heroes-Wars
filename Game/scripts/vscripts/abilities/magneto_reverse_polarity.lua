magneto_reverse_polarity = class({})

-------------------------------------------------------------------------------
function magneto_reverse_polarity:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 60
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function magneto_reverse_polarity:OnAbilityPhaseStart()
    self.hTarget = self:GetCaster():GetAbsOrigin()
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControl(nFXIndex, 0, Vector(400, 400, 0))
    ParticleManager:SetParticleControl(nFXIndex, 1, Vector(400, 400, 0))
    ParticleManager:SetParticleControl(nFXIndex, 2, Vector(2, 1, 0))
    ParticleManager:SetParticleControl(nFXIndex, 3, self.hTarget)

    EmitSoundOn( "Hero_Magnataur.ReversePolarity.Anim", self:GetCaster() )
    return true
end

--------------------------------------------------------------------------------

function magneto_reverse_polarity:OnSpellStart()
    self.hTarget = self:GetCaster():GetAbsOrigin()
    EmitSoundOn( "Hero_Magnataur.ReversePolarity.Cast", self:GetCaster() )
    local radius = self:GetSpecialValueFor("pull_radius")
    local damage = self:GetSpecialValueFor("polarity_damage")
    local hero_stun_duration = self:GetSpecialValueFor("hero_stun_duration")
    local creep_stun_duration = self:GetSpecialValueFor("creep_stun_duration")
    if self:GetCaster():HasScepter() then
        damage = self:GetSpecialValueFor("polarity_damage") + (self:GetCaster():GetIntellect()*self:GetSpecialValueFor("intellect_mult_scepter"))
    end
    local rp = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for i = 1, #rp do
        local target = rp[i]
      
        EmitSoundOn( "Hero_Magnataur.ReversePolarity.Stun", target )
       
        target:SetAbsOrigin(self:GetCaster():GetAbsOrigin() + Vector(150, 50, 0))
       
        FindClearSpaceForUnit(target, self.hTarget, true)
        FindClearSpaceForUnit(self:GetCaster(), self.hTarget, true)
             
        if target:IsRealHero() then
            target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = hero_stun_duration } )
        else
            target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = creep_stun_duration } )
        end
        
        ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE})
    end
end

function magneto_reverse_polarity:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

