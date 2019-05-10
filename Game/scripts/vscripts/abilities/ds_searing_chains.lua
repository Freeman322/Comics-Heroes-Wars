LinkLuaModifier ("modifier_ds_searing_chains", "abilities/ds_searing_chains.lua", LUA_MODIFIER_MOTION_NONE)

ds_searing_chains = class({})

function ds_searing_chains:OnSpellStart()
  if not self:GetCursorTarget():TriggerSpellAbsorb(self) then
    EmitSoundOn ("Hero_EmberSpirit.SearingChains.Cast", self:GetCaster())
    self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_ds_searing_chains", {duration = self:GetSpecialValueFor("duration")})
    EmitSoundOn ("Hero_EmberSpirit.SearingChains.Target", self:GetCursorTarget())
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, self:GetCursorTarget():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
  end
end

modifier_ds_searing_chains = class({})

function modifier_ds_searing_chains:OnCreated() self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_interval")) end
function modifier_ds_searing_chains:OnIntervalThink() ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self:GetAbility():GetSpecialValueFor("total_damage") / self:GetAbility():GetSpecialValueFor("duration") * self:GetAbility():GetSpecialValueFor("tick_interval"), damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()}) end
function modifier_ds_searing_chains:CheckState() return {[MODIFIER_STATE_ROOTED] = true} end
function modifier_ds_searing_chains:GetEffectName() return "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf" end
function modifier_ds_searing_chains:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
