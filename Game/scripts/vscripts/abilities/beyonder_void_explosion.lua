LinkLuaModifier("modifier_beyonder_void_explosion", "abilities/beyonder_void_explosion.lua", 0)

beyonder_void_explosion = class({})

function beyonder_void_explosion:OnOwnerDied()
  if self:GetCaster():PassivesDisabled() then return end
  EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse.TI8", self:GetCaster())

  local nFXIndex = ParticleManager:CreateParticle( "particles/galactus/galactus_seed_of_ambition_eternal_item.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
  ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin())

  local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
  for _, target in pairs(units) do
    ApplyDamage({victim = target, attacker = self:GetCaster(), damage = self:GetSpecialValueFor("near_damage"), damage_type = self:GetAbilityDamageType(), ability = self})
  end
end


  

