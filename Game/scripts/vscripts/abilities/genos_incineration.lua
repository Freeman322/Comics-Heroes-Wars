--1 скилл

genos_incineration = class ({})

LinkLuaModifier("modifier_genos_incineration_slow", "abilities/genos/genos_incineration.lua", LUA_MODIFIER_MOTION_NONE)

function genos_incineration:GetAOERadius() return self:GetSpecialValueFor("radius") end

function genos_incineration:OnSpellStart()
  local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
  for _,target in pairs(enemies) do

    ApplyDamage({
        victim = target,
        attacker = self:GetCaster(),
        damage = self:GetSpecialValueFor("damage"),
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self
    })
    target:AddNewModifier(self:GetCaster(), self, "modifier_genos_incineration_slow", {duration = self:GetSpecialValueFor("slow_duration")})
  end

  EmitSoundOn("Hero_Techies.Suicide", self:GetCaster())

  local pop_pfx = ParticleManager:CreateParticle("particles/econ/courier/courier_cluckles/courier_cluckles_ambient_rocket_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(pop_pfx, 0, self:GetCaster():GetCursorPosition())
  ParticleManager:SetParticleControl(pop_pfx, 3, self:GetCaster():GetCursorPosition())
  ParticleManager:ReleaseParticleIndex(pop_pfx)
end

modifier_genos_incineration_slow = class({})

function modifier_genos_incineration_slow:IsHidden() return false end
function modifier_genos_incineration_slow:IsDebuff() return true end
function modifier_genos_incineration_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_genos_incineration_slow:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("slow_pct") * -1 end
