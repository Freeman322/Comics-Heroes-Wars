LinkLuaModifier( "item_sunshines_aromor_passive_modifier", "items/item_sunshines_aromor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_sunshines_aromor_reduce_modifier", "items/item_sunshines_aromor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_sunshines_aromor_passive_modifier_aura", "items/item_sunshines_aromor.lua", LUA_MODIFIER_MOTION_NONE )


if item_sunshines_aromor == nil then
	item_sunshines_aromor = class({})
end
function item_sunshines_aromor:GetIntrinsicModifierName()
	return "item_sunshines_aromor_passive_modifier"
end

function item_sunshines_aromor:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_NO_TARGET
	return behav
end

function item_sunshines_aromor:OnSpellStart()
	if IsServer() then
    self:GetCaster():Purge(false, true, false, true, false)
    self:CreateWave()
	end
end

function item_sunshines_aromor:CreateWave()
  if IsServer() then
    local shivas_guard_particle = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(shivas_guard_particle, 1, Vector(900, 900 / 350, 350))

    EmitSoundOn("DOTA_Item.ShivasGuard.Activate", self:GetCaster())
    self._iCurrent_blast_radius = 0

    Timers:CreateTimer({ ---КАСТЫЛЬ, А ЧТО ДЕЛАТЬ?
      endTime = .03,
      callback = function()
      self:CreateVisibilityNode(self:GetCaster():GetAbsOrigin(), 800, 2)  

      self._iCurrent_blast_radius = self._iCurrent_blast_radius + (350 * .03)

      local units = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, self._iCurrent_blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

      for i, unit in pairs(units) do
        print(unit)
        if not unit:HasModifier("item_sunshines_aromor_reduce_modifier") then
          ApplyDamage({victim = unit, attacker = self:GetCaster(), damage = self:GetSpecialValueFor("blast_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})

          local shivas_guard_impact_particle = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
          local target_point = unit:GetAbsOrigin()
          local caster_point = self:GetCaster():GetAbsOrigin()
          ParticleManager:SetParticleControl(shivas_guard_impact_particle, 1, target_point + (target_point - caster_point) * 30)

          unit:AddNewModifier(self:GetCaster(), self, "item_sunshines_aromor_reduce_modifier", {duration = self:GetSpecialValueFor("blast_debuff_duration")})
        end
      end

      if self._iCurrent_blast_radius < 900 then return .03 else self._iCurrent_blast_radius = 0 return nil end
    end})
  end
end

--------------------------------------------------------------------------------
if item_sunshines_aromor_passive_modifier == nil then item_sunshines_aromor_passive_modifier = class({}) end
function item_sunshines_aromor_passive_modifier:IsHidden() return true end
function item_sunshines_aromor_passive_modifier:IsPurgable() return false end
function item_sunshines_aromor_passive_modifier:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_HEALTH_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_EVENT_ON_TAKEDAMAGE
}

  return funcs
end

function item_sunshines_aromor_passive_modifier:GetModifierPhysical_ConstantBlock( params ) return self:GetParent():GetStrength() / 4 end

function item_sunshines_aromor_passive_modifier:OnTakeDamage( params )
  if IsServer() then
    if params.unit == self:GetParent() then
      if self:GetParent():IsIllusion() then return end
      self._iDamage = params.damage + (self._iDamage or 0)

      if self._iDamage >= self:GetAbility():GetSpecialValueFor("blast_trigger_damage") then
        self:GetAbility():CreateWave()
        self._iDamage = 0
      end
    end
  end
end

function item_sunshines_aromor_passive_modifier:GetModifierBonusStats_Strength( params ) return self:GetAbility():GetSpecialValueFor( "bonus_strength" ) end
function item_sunshines_aromor_passive_modifier:GetModifierBonusStats_Intellect( params ) return self:GetAbility():GetSpecialValueFor( "bonus_intellect" ) end
function item_sunshines_aromor_passive_modifier:GetModifierPhysicalArmorBonus( params ) return self:GetAbility():GetSpecialValueFor( "bonus_armor" ) end
function item_sunshines_aromor_passive_modifier:GetModifierHealthBonus( params ) return self:GetAbility():GetSpecialValueFor( "bonus_health" ) end
function item_sunshines_aromor_passive_modifier:GetModifierMagicalResistanceBonus( params ) return self:GetAbility():GetSpecialValueFor( "bonus_magical_armor" ) end
function item_sunshines_aromor_passive_modifier:GetModifierHealthRegenPercentage( params ) return 1 end
function item_sunshines_aromor_passive_modifier:IsAura() return true end
function item_sunshines_aromor_passive_modifier:GetAuraRadius() return 900 end
function item_sunshines_aromor_passive_modifier:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function item_sunshines_aromor_passive_modifier:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function item_sunshines_aromor_passive_modifier:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function item_sunshines_aromor_passive_modifier:GetModifierAura() return "item_sunshines_aromor_passive_modifier_aura" end
if item_sunshines_aromor_reduce_modifier == nil then item_sunshines_aromor_reduce_modifier = class({}) end
function item_sunshines_aromor_reduce_modifier:IsPurgable() return false end
function item_sunshines_aromor_reduce_modifier:DeclareFunctions() return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function item_sunshines_aromor_reduce_modifier:GetModifierMoveSpeedBonus_Percentage( params ) return -40 end
function item_sunshines_aromor_reduce_modifier:GetModifierAttackSpeedBonus_Constant( params ) return -60 end
if item_sunshines_aromor_passive_modifier_aura == nil then item_sunshines_aromor_passive_modifier_aura = class({}) end
function item_sunshines_aromor_passive_modifier_aura:IsPurgable() return false end
function item_sunshines_aromor_passive_modifier_aura:DeclareFunctions() return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function item_sunshines_aromor_passive_modifier_aura:IsDebuff() return self:GetParent():GetTeamNumber() ~= self:GetAbility():GetCaster():GetTeamNumber() end
function item_sunshines_aromor_passive_modifier_aura:GetModifierPhysicalArmorBonus( params ) if self:GetParent():GetTeamNumber() ~= self:GetAbility():GetCaster():GetTeamNumber() then return -10 end return 20 end
function item_sunshines_aromor_passive_modifier_aura:GetModifierAttackSpeedBonus_Constant( params ) if self:GetParent():GetTeamNumber() ~= self:GetAbility():GetCaster():GetTeamNumber() then  return -50 end return 50 end

