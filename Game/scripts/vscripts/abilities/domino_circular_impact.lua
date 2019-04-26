domino_circular_impact = class ({})

function domino_circular_impact:OnSpellStart()
  local enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
  for _, target in pairs(enemies) do
    local damage = {
        victim = target,
        attacker = self:GetCaster(),
        damage = RandomInt(self:GetSpecialValueFor("min_damage"), self:GetSpecialValueFor("max_damage")),
        damage_type = DAMAGE_TYPE_PURE,
        ability = self
    }
    ApplyDamage(damage)
    target:AddNewModifier(self:GetCaster(),self,"modifier_stunned",{duration = math.random(self:GetSpecialValueFor("min_stun"), self:GetSpecialValueFor("max_stun"))})
  end
  local particle = ParticleManager:CreateParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser_b.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
  ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex (particle)
  self:GetCaster():EmitSound("Hero_Axe.CounterHelix")
end
