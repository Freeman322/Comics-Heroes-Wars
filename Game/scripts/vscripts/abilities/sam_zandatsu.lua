LinkLuaModifier("modifier_sam_zandatsu", "abilities/sam_zandatsu.lua", LUA_MODIFIER_MOTION_NONE)

sam_zandatsu = class({})

function sam_zandatsu:GetIntrinsicModifierName() return "modifier_sam_zandatsu" end

modifier_sam_zandatsu = class({})

function modifier_sam_zandatsu:IsHidden() return true end
function modifier_sam_zandatsu:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end
function modifier_sam_zandatsu:RemoveOnDeath() return false end
function modifier_sam_zandatsu:IsPurgable() return false end

function modifier_sam_zandatsu:OnDeath(params)
  if params.attacker == self:GetParent() and params.attacker:IsRealHero() and params.attacker:PassivesDisabled() == false and params.unit ~= params.attacker and params.unit:IsBuilding() == false then
    if params.unit:IsRealHero() then
      self:GetParent():Heal(self:GetParent():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("hero_heal") / 100), self:GetParent())
      self:GetParent():GiveMana(self:GetParent():GetMaxMana() * (self:GetAbility():GetSpecialValueFor("hero_heal") / 100))

    else
      self:GetParent():Heal(self:GetParent():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("creep_heal") / 100), self:GetParent())
      self:GetParent():GiveMana(self:GetParent():GetMaxMana() * (self:GetAbility():GetSpecialValueFor("creep_heal") / 100))

    end
    ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/sam/sam_zandatsu.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker), 0, params.attacker:GetAbsOrigin())
  end
end
