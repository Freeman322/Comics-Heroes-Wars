joker_suicide = class({})

--------------------------------------------------------------------------------
function joker_suicide:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor("cooldown_scepter")
    end
    return self.BaseClass.GetCooldown( self, nLevel )
end

function joker_suicide:GetManaCost()
  return (self:GetCaster():GetMana() * (self:GetSpecialValueFor("damage") / 100)) / 2
end
--------------------------------------------------------------------------------

function joker_suicide:OnSpellStart()
  if IsServer() then
    local caster = self:GetCaster()
    local damage_pers = self:GetSpecialValueFor("damage")
    local radius = self:GetSpecialValueFor("radius")
    local position = caster:GetAbsOrigin()

    if caster:HasScepter() then
      damage_pers = self:GetSpecialValueFor("damage_scepter")
    end
    if caster:HasTalent("special_bonus_unique_joker_1") then
      radius = radius + caster:FindTalentValue("special_bonus_unique_joker_1")
    end

    EmitSoundOn( "Hero_EarthShaker.EchoSlam", caster )
    EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", caster )
    EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", caster )
    EmitSoundOn( "PudgeWarsClassic.echo_slam", caster )
    local explosion1 = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_call_down_explosion_impact_a.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(explosion1, 0, caster:GetAbsOrigin() + Vector(0, 0, 1))
    ParticleManager:SetParticleControl(explosion1, 1, caster:GetAbsOrigin() + Vector(0, 0, 1))
    ParticleManager:SetParticleControl(explosion1, 2, caster:GetAbsOrigin() + Vector(0, 0, 1))
    ParticleManager:SetParticleControl(explosion1, 3, Vector(300, 300, 1))
    local explosion2 = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(explosion2, 0, caster:GetAbsOrigin() + Vector(0, 0, 1))
    ParticleManager:SetParticleControl(explosion2, 3, caster:GetAbsOrigin() + Vector(0, 0, 1))
    ParticleManager:SetParticleControl(explosion2, 5, Vector(600, 600, 1))
    ScreenShake( caster:GetOrigin(), 100, 100, 6, 9999, 0, true)
    GridNav:DestroyTreesAroundPoint( self:GetCaster():GetAbsOrigin(), 600, false)
    local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for i = 1, #targets do
        local target = targets[i]
        local damage = (damage_pers / 100) * self:GetCaster():GetMana()
      	ApplyDamage({victim = target, attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
        target:AddNewModifier(caster, self, "modifier_stunned", {duration = 2})
    end
    ApplyDamage({victim = caster, attacker = caster, ability = self, damage = (damage_pers / 100) * self:GetCaster():GetMana(), damage_type = DAMAGE_TYPE_MAGICAL})
  end
end

function joker_suicide:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

