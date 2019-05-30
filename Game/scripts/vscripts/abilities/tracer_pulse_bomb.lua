LinkLuaModifier("modifier_tracer_pulse_bomb", "abilities/tracer_pulse_bomb.lua", 0)
LinkLuaModifier("modifier_tracer_pulse_bomb_thinker", "abilities/tracer_pulse_bomb.lua", 0)
LinkLuaModifier("modifier_tracer_pulse_bomb_enemy", "abilities/tracer_pulse_bomb.lua", 0)

tracer_pulse_bomb = class({
    GetIntrinsicModifierName = function() return "modifier_tracer_pulse_bomb" end
})

function tracer_pulse_bomb:GetAOERadius() return self:GetSpecialValueFor("explosion_radius") end
function tracer_pulse_bomb:OnSpellStart()
  self.proj = ProjectileManager:CreateLinearProjectile({
    EffectName = "particles/econ/items/puck/puck_alliance_set/puck_illusory_orb_aproset.vpcf",
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
    iVisionRadius = self:GetSpecialValueFor("bind_radius") * 2,
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
modifier_tracer_pulse_bomb = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_IGNORE_CAST_ANGLE} end,
    GetModifierIgnoreCastAngle = function() return 1 end
})

function modifier_tracer_pulse_bomb:OnAttackLanded(params)
    if params.attacker == self:GetParent() and self:GetStackCount() < 100 and params.attacker:IsRealHero() then
        if params.target:IsRealHero() then
            self:SetStackCount(self:GetStackCount() + math.random(self:GetAbility():GetSpecialValueFor("charge_per_attack") - 1, self:GetAbility():GetSpecialValueFor("charge_per_attack") + 1))
        end
    end
end

function modifier_tracer_pulse_bomb:OnCreated() if IsServer() then self:SetStackCount(0) self:StartIntervalThink(FrameTime()) self:GetAbility():SetActivated(false) end end
function modifier_tracer_pulse_bomb:OnIntervalThink()
  if self:GetStackCount() > 100 then self:SetStackCount(100) end
  if self:GetStackCount() == 100 then self:GetAbility():SetActivated(true) end
  if self:GetStackCount() < 100 then self:GetAbility():SetActivated(false) end
end

modifier_tracer_pulse_bomb_thinker = class({
    IsHidden = function() return true end
})

function modifier_tracer_pulse_bomb_thinker:OnDestroy()
  if IsServer() then
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("explosion_radius"), self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), 0, false)
    for _, target in pairs(enemies) do
      if not target:IsMagicImmune() then
        target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", {center_x = self:GetParent():GetAbsOrigin().x, center_y = self:GetParent():GetAbsOrigin().y, center_z = self:GetParent():GetAbsOrigin().z, duration = self:GetCaster():GetLevel() * 0.05, knockback_duration = self:GetCaster():GetLevel() * 0.05, knockback_distance = 350, knockback_height = 300})
        ApplyDamage({victim = target, attacker = self:GetCaster(), damage = self:GetCaster():GetLevel() * (self:GetAbility():GetSpecialValueFor("damage_per_level") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_tracer_pulse_bomb") or 0)), damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
      end
      EmitSoundOn("Hero_Techies.Suicide", self:GetParent())

    end
    local particle = ParticleManager:CreateParticle("particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 3, Vector(self:GetAbility():GetSpecialValueFor("explosion_radius"), self:GetAbility():GetSpecialValueFor("explosion_radius"), 0))
    ParticleManager:ReleaseParticleIndex(particle)
  end
end

modifier_tracer_pulse_bomb_enemy = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end
})

function modifier_tracer_pulse_bomb_enemy:OnDestroy()
  if IsServer() then
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("explosion_radius"), self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), 0, false)
    for _, target in pairs(enemies) do
      if not target:IsMagicImmune() then
        target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", {center_x = self:GetParent():GetAbsOrigin().x, center_y = self:GetParent():GetAbsOrigin().y, center_z = self:GetParent():GetAbsOrigin().z, duration = 0.5, knockback_duration = 0.5, knockback_distance = 350, knockback_height = 200})
        local damage = self:GetCaster():GetLevel() * (self:GetAbility():GetSpecialValueFor("damage_per_level") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_tracer_pulse_bomb") or 0))
        if target == self:GetParent() then damage = damage * 1.5 end
        ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
      end
    end
    EmitSoundOn("Hero_Techies.Suicide", self:GetParent())
    local particle = ParticleManager:CreateParticle("particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 3, Vector(self:GetAbility():GetSpecialValueFor("explosion_radius"), self:GetAbility():GetSpecialValueFor("explosion_radius"), 0))
    ParticleManager:ReleaseParticleIndex(particle)
  end
end
