LinkLuaModifier("modifier_tracer_pulse_bomb", "abilities/tracer_pulse_bomb.lua", 0)
LinkLuaModifier("modifier_tracer_pulse_bomb_thinker", "abilities/tracer_pulse_bomb.lua", 0)
LinkLuaModifier("modifier_tracer_pulse_bomb_enemy", "abilities/tracer_pulse_bomb.lua", 0)

tracer_pulse_bomb = class({})

function tracer_pulse_bomb:GetIntrinsicModifierName() return "modifier_tracer_pulse_bomb" end

function tracer_pulse_bomb:GetAOERadius() return self:GetSpecialValueFor("explosion_radius") end
function tracer_pulse_bomb:OnSpellStart()

  self.proj = ProjectileManager:CreateLinearProjectile({
    EffectName = "particles/units/heroes/hero_batrider/batrider_flamebreak.vpcf",
    Ability = self,
    vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
    fStartRadius = self:GetSpecialValueFor("bind_radius"),
    fEndRadius = self:GetSpecialValueFor("bind_radius"),
    vVelocity = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Normalized() * 1500,
    fDistance = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Length2D(),
    Source = self:GetCaster(),
    iUnitTargetTeam = self:GetAbilityTargetTeam(),
    iUnitTargetType = self:GetAbilityTargetType(),
    iUnitTargetFlags = self:GetAbilityTargetFlags(),
    bProvidesVision = true,
    iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    iVisionRadius = self:GetSpecialValueFor("bind_radius"),
  })
  self:GetCaster():FindModifierByName("modifier_tracer_pulse_bomb"):SetStackCount(0)
end

function tracer_pulse_bomb:OnProjectileHit(hTarget, vLocation)
  if hTarget ~= nil then --При попадании во врага
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_tracer_pulse_bomb_enemy", {duration = self:GetSpecialValueFor("explosion_delay")})
    ProjectileManager:DestroyLinearProjectile(self.proj)
  elseif hTarget == nil then --При промахе по врагу
    CreateModifierThinker(self:GetCaster(), self, "modifier_tracer_pulse_bomb_thinker", {duration = self:GetSpecialValueFor("explosion_delay")}, vLocation, self:GetCaster():GetTeam(), false)
  end
end
modifier_tracer_pulse_bomb = class({})

function modifier_tracer_pulse_bomb:IsHidden() return false end
function modifier_tracer_pulse_bomb:IsPurgable() return false end
function modifier_tracer_pulse_bomb:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_IGNORE_CAST_ANGLE} end
function modifier_tracer_pulse_bomb:GetModifierIgnoreCastAngle() return 1 end

function modifier_tracer_pulse_bomb:OnAttackLanded(params)
  if params.attacker == self:GetParent() and self:GetStackCount() < 100 and params.attacker:IsRealHero() then
    if params.target:IsRealHero() then
      self:SetStackCount(self:GetStackCount() + math.random(1, 3))
    --else
    --  self:IncrementStackCount()
    end
  end
end

function modifier_tracer_pulse_bomb:OnCreated() if IsServer() then self:SetStackCount(0) self:StartIntervalThink(FrameTime()) self:GetAbility():SetActivated(false) end end
function modifier_tracer_pulse_bomb:OnIntervalThink()
  if self:GetStackCount() > 100 then
    self:SetStackCount(100)
  end
  if self:GetStackCount() == 100 then
    self:GetAbility():SetActivated(true)
  end
  if self:GetStackCount() < 100 then
    self:GetAbility():SetActivated(false)
  end
end

modifier_tracer_pulse_bomb_thinker = class({})

function modifier_tracer_pulse_bomb_thinker:OnCreated()
  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_wraith_ring.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
  ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControl(particle, 1, Vector(self:GetAbility():GetSpecialValueFor("explosion_radius"), self:GetAbility():GetSpecialValueFor("explosion_radius"),
  f))
  ParticleManager:SetParticleControl(particle, 3, self:GetParent():GetAbsOrigin())
  self:AddParticle(particle, false, false, -1, false, false)
end
function modifier_tracer_pulse_bomb_thinker:IsHidden() return true end
function modifier_tracer_pulse_bomb_thinker:OnDestroy()
  if IsServer() then
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("explosion_radius"), self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), 0, false)
    for _, target in pairs(enemies) do
      if not target:IsMagicImmune() then
        target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", {center_x = self:GetParent():GetAbsOrigin().x, center_y = self:GetParent():GetAbsOrigin().y, center_z = self:GetParent():GetAbsOrigin().z, duration = 0.5, knockback_duration = 0.5, knockback_distance = 350, knockback_height = 200})
        ApplyDamage({victim = target, attacker = self:GetCaster(), damage = self:GetCaster():GetLevel() * self:GetAbility():GetSpecialValueFor("damage_per_level"), damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
      end
      EmitSoundOn("Hero_Techies.Suicide", self:GetParent())

    end
    local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_cluckles/courier_cluckles_ambient_rocket_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(particle, 3, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
  end
end

modifier_tracer_pulse_bomb_enemy = class({})

function modifier_tracer_pulse_bomb_enemy:OnCreated()
  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_wraith_ring.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
  ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil,  self:GetParent():GetAbsOrigin(), true)
  ParticleManager:SetParticleControl(particle, 1, Vector(self:GetAbility():GetSpecialValueFor("explosion_radius"), self:GetAbility():GetSpecialValueFor("explosion_radius"), 0))
  ParticleManager:SetParticleControl(particle, 3, self:GetParent():GetAbsOrigin())
  self:AddParticle(particle, false, false, -1, false, false)
end
function modifier_tracer_pulse_bomb_enemy:IsHidden() return false end
function modifier_tracer_pulse_bomb_enemy:IsPurgable() return false end
function modifier_tracer_pulse_bomb_enemy:OnDestroy()
  if IsServer() then
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("explosion_radius"), self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), 0, false)
    for _, target in pairs(enemies) do
      if not target:IsMagicImmune() then
        target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", {center_x = self:GetParent():GetAbsOrigin().x, center_y = self:GetParent():GetAbsOrigin().y, center_z = self:GetParent():GetAbsOrigin().z, duration = 0.5, knockback_duration = 0.5, knockback_distance = 350, knockback_height = 200})
        local damage = self:GetCaster():GetLevel() * self:GetAbility():GetSpecialValueFor("damage_per_level")
        if target == self:GetParent() then damage = damage * 1.5 end
        ApplyDamage({victim = target, attacker = self:GetCaster(), damage = self:GetCaster():GetLevel() * self:GetAbility():GetSpecialValueFor("damage_per_level"), damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
      end
    end
    EmitSoundOn("Hero_Techies.Suicide", self:GetParent())
    local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_cluckles/courier_cluckles_ambient_rocket_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(particle, 3, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
  end
end
