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
    local caster = self:GetCaster()
    caster:EmitSound("DOTA_Item.Mekansm.Activate")
    local hp_remove = self:GetSpecialValueFor( "hp_remove" )/100
  	ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

  	local nearby_allied_units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

  	for i, nearby_ally in ipairs(nearby_allied_units) do  --Restore health and play a particle effect for every found ally.
      local HealAmount = (nearby_ally:GetMaxHealth()*0.1) + 400
      local ManaAmount = nearby_ally:GetMaxMana()*hp_remove
  		nearby_ally:Heal(HealAmount, caster)
      nearby_ally:SetMana(nearby_ally:GetMana() + ManaAmount)
      EmitSoundOn("DOTA_Item.Mekansm.Target", nearby_ally)
  		ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, nearby_ally)
  	end
    local waves = 4
    Timers:CreateTimer(0, function()
      waves = waves - 1
      if waves == 0 then
        return nil
      end
      EmitSoundOn("DOTA_Item.ShivasGuard.Activate", caster)
      local nFXIndex = ParticleManager:CreateParticle( "particles/hero_arthas/snow_rise_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
      ParticleManager:SetParticleControl(nFXIndex, 0, caster:GetAbsOrigin())
      ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self:GetSpecialValueFor("range"), 5, 0))
      ParticleManager:SetParticleControl(nFXIndex, 2, caster:GetAbsOrigin())
      ParticleManager:SetParticleControl(nFXIndex, 3, Vector(1, 0, 0))
      local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

      for i, target in ipairs(targets) do  --Restore health and play a particle effect for every found ally.
        target:AddNewModifier(caster, self, "item_sunshines_aromor_reduce_modifier", {duration = 4})
        ApplyDamage({attacker = caster, victim = target, damage = 200, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
        EmitSoundOn("DOTA_Item.DiffusalBlade.Target", caster)
      end
      return 1
    end)
	end
end
--------------------------------------------------------------------------------
if item_sunshines_aromor_passive_modifier == nil then
    item_sunshines_aromor_passive_modifier = class({})
end

function item_sunshines_aromor_passive_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_sunshines_aromor_passive_modifier:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_HEALTH_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    ----MODIFIER_EVENT_ON_TAKEDAMAGE
}

return funcs
end

function item_sunshines_aromor_passive_modifier:GetModifierPhysical_ConstantBlock( params )
    return self:GetParent():GetStrength() / 4
end

--[[function item_sunshines_aromor_passive_modifier:OnTakeDamage( params )
    if params.unit == self:GetParent() then
				if self:GetParent():IsIllusion() then
					return nil
				end
        if not self.damage then
          self.damage = 0
        end
        self.damage = self.damage + params.damage
        if self.damage >= 1500 then
             self.damage = 0
            if IsServer() then
                self:GetParent():Purge(false, true, false, true, false)
                local caster = self:GetParent()
                EmitSoundOn("Item.GuardianGreaves.Target", self:GetParent())
                EmitSoundOn("DOTA_Item.ShivasGuard.Activate", caster)
                local nFXIndex = ParticleManager:CreateParticle( "particles/hero_arthas/snow_rise_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
                ParticleManager:SetParticleControl(nFXIndex, 0, caster:GetAbsOrigin())
                ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("range"), 5, 0))
                ParticleManager:SetParticleControl(nFXIndex, 2, caster:GetAbsOrigin())
                ParticleManager:SetParticleControl(nFXIndex, 3, Vector(1, 0, 0))
                local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

                for i, target in ipairs(targets) do
                    target:AddNewModifier(caster, self:GetAbility(), "item_shine_of_sea_modifier_reduce_modifier", {duration = 4})
                    ApplyDamage({attacker = caster, victim = target, damage = 200, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
                    EmitSoundOn("DOTA_Item.DiffusalBlade.Target", caster)
                end
            end
        end
    end
end]]--

function item_sunshines_aromor_passive_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_strength" )
end

function item_sunshines_aromor_passive_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_intellect" )
end
function item_sunshines_aromor_passive_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_agility" )
end

function item_sunshines_aromor_passive_modifier:GetModifierPhysicalArmorBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_armor" )
end

function item_sunshines_aromor_passive_modifier:GetModifierHealthBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health" )
end

function item_sunshines_aromor_passive_modifier:GetModifierMagicalResistanceBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_magical_armor" )
end

function item_sunshines_aromor_passive_modifier:GetModifierConstantHealthRegen( params )
    return self:GetParent():GetMaxHealth() * 0.01
end

function item_sunshines_aromor_passive_modifier:IsAura()
  return true
end

function item_sunshines_aromor_passive_modifier:GetAuraRadius()
  return 900
end

function item_sunshines_aromor_passive_modifier:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_BOTH
end

function item_sunshines_aromor_passive_modifier:GetAuraSearchType()
  return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function item_sunshines_aromor_passive_modifier:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NONE
end

function item_sunshines_aromor_passive_modifier:GetModifierAura()
  return "item_sunshines_aromor_passive_modifier_aura"
end

if item_sunshines_aromor_reduce_modifier == nil then item_sunshines_aromor_reduce_modifier = class({}) end

function item_sunshines_aromor_reduce_modifier:IsPurgable()
    return false
end

function item_sunshines_aromor_reduce_modifier:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }

  return funcs
end

function item_sunshines_aromor_reduce_modifier:GetModifierMoveSpeedBonus_Percentage( params )
  return -40
end

function item_sunshines_aromor_reduce_modifier:GetModifierAttackSpeedBonus_Constant( params )
  return -60
end

if item_sunshines_aromor_passive_modifier_aura == nil then item_sunshines_aromor_passive_modifier_aura = class({}) end

function item_sunshines_aromor_passive_modifier_aura:IsPurgable()
  return false
end

function item_sunshines_aromor_passive_modifier_aura:DeclareFunctions() --we want to use these functions in this item
local funcs = {

    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

return funcs
end

function item_sunshines_aromor_passive_modifier_aura:IsBuff()
    if self:GetParent():GetTeamNumber() ~= self:GetAbility():GetCaster():GetTeamNumber() then
      return false
    else
      return true
    end
end

function item_sunshines_aromor_passive_modifier_aura:GetModifierPhysicalArmorBonus( params )
    if self:GetParent():GetTeamNumber() ~= self:GetAbility():GetCaster():GetTeamNumber() then
      return -10
    else
      return 20
    end
end

function item_sunshines_aromor_passive_modifier_aura:GetModifierAttackSpeedBonus_Constant( params )
    if self:GetParent():GetTeamNumber() ~= self:GetAbility():GetCaster():GetTeamNumber() then
      return -50
    else
      return 50
    end
end

function item_sunshines_aromor:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
