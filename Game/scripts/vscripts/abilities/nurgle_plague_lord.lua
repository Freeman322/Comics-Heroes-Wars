LinkLuaModifier("modifier_nurgle_plague_lord_debuff", "abilities/nurgle_plague_lord.lua", 0)

nurgle_plague_lord = class({})

function nurgle_plague_lord:OnOwnerDied()
  if self:GetCaster():PassivesDisabled() then return end
  EmitSoundOn("Hero_Alchemist.UnstableConcoction.Stun", self:GetCaster())

  local nFXIndex = ParticleManager:CreateParticle( "particles/frostivus_gameplay/wraith_king_hellfire_eruption_explosion.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
  ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin())

  local nFXIndex = ParticleManager:CreateParticle( "particles/items_fx/ethereal_blade_explosion.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
  ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl( nFXIndex, 2, Vector(200, 200, 1))

  local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
  for _, target in pairs(units) do
    target:AddNewModifier(self:GetCaster(), self, "modifier_nurgle_plague_lord_debuff", {duration = self:GetSpecialValueFor("duration")})
    EmitSoundOn("Hero_Alchemist.AcidSpray.Damage", target)
    ApplyDamage({victim = target, attacker = self:GetCaster(), damage = self:GetSpecialValueFor("near_damage"), damage_type = self:GetAbilityDamageType(), ability = self})
  end
end

modifier_nurgle_plague_lord_debuff = class({})

function modifier_nurgle_plague_lord_debuff:IsPurgable() return true end

function modifier_nurgle_plague_lord_debuff:OnCreated()
    if IsServer() then
        self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_rate"))

        local particle1 = ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_ti6_immortal/pudge_rot_body_maggots.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        local particle3 = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

        self:AddParticle(particle1, false, false, -1, false, false)
        self:AddParticle(particle2, false, false, -1, false, false)
        self:AddParticle(particle3, false, false, -1, false, false)
    end
end

function modifier_nurgle_plague_lord_debuff:OnIntervalThink() 
    if IsServer() then
        ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()}) 
    end 
end
