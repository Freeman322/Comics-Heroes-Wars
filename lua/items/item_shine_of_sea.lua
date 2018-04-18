LinkLuaModifier( "item_shine_of_sea_modifier", "items/item_shine_of_sea.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_shine_of_sea_modifier_reduce_modifier", "items/item_shine_of_sea.lua", LUA_MODIFIER_MOTION_NONE )

if item_shine_of_sea == nil then
	item_shine_of_sea = class({})
end
function item_shine_of_sea:GetIntrinsicModifierName()
	return "item_shine_of_sea_modifier"
end

function item_shine_of_sea:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_NO_TARGET
	return behav
end

function item_shine_of_sea:OnSpellStart()
	if IsServer() then
        local caster = self:GetCaster()
        EmitSoundOn("Item.GuardianGreaves.Target", caster)
        EmitSoundOn("Item.GuardianGreaves.Activate", caster)
        local nearby_allied_units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, nearby_ally in ipairs(nearby_allied_units) do  --Restore health and play a particle effect for every found ally.
            EmitSoundOn("DOTA_Item.Mekansm.Target", nearby_ally)
            ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, nearby_ally)
            nearby_ally:Purge(false, true, false, true, false)
            ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, nearby_ally)
            nearby_ally:Heal(self:GetSpecialValueFor("heal") + (nearby_ally:GetMaxHealth() * 0.05), caster)
        end
    end
end

if item_shine_of_sea_modifier == nil then
    item_shine_of_sea_modifier = class({})
end

function item_shine_of_sea_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_shine_of_sea_modifier:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
    MODIFIER_PROPERTY_HEALTH_BONUS,
    ----MODIFIER_EVENT_ON_TAKEDAMAGE
}

return funcs
end

function item_shine_of_sea_modifier:GetModifierHealthBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_health" )
end

function item_shine_of_sea_modifier:GetModifierBonusStats_Strength( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end

function item_shine_of_sea_modifier:OnCreated(htable)
    self.damage = 0
end

function item_shine_of_sea_modifier:GetModifierBonusStats_Intellect( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end

function item_shine_of_sea_modifier:GetModifierBonusStats_Agility( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end

function item_shine_of_sea_modifier:GetModifierPhysicalArmorBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

function item_shine_of_sea_modifier:GetModifierPhysical_ConstantBlock( params )
    return self:GetAbility():GetSpecialValueFor( "damage_reduction" )
end

--[[function item_shine_of_sea_modifier:OnTakeDamage( params )
    if params.unit == self:GetParent() then
				if self:GetParent():IsIllusion() then
					return nil
				end
        self.damage = self.damage + params.damage
        if self.damage >= self:GetAbility():GetSpecialValueFor("damage_cleanse") then
             self.damage = 0
            if IsServer() then
                local caster = self:GetParent()
                self:GetParent():Purge(false, true, false, true, false)
                EmitSoundOn("Item.GuardianGreaves.Target", self:GetParent())
                EmitSoundOn("DOTA_Item.ShivasGuard.Activate", caster)
                local nFXIndex = ParticleManager:CreateParticle( "particles/hero_arthas/snow_rise_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
                ParticleManager:SetParticleControl(nFXIndex, 0, caster:GetAbsOrigin())
                ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("range"), 5, 0))
                ParticleManager:SetParticleControl(nFXIndex, 2, caster:GetAbsOrigin())
                ParticleManager:SetParticleControl(nFXIndex, 3, Vector(1, 0, 0))
                local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

                for i, target in ipairs(targets) do  --Restore health and play a particle effect for every found ally.
                    target:AddNewModifier(caster, self:GetAbility(), "item_shine_of_sea_modifier_reduce_modifier", {duration = 4})
                    ApplyDamage({attacker = caster, victim = target, damage = 200, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
                    EmitSoundOn("DOTA_Item.DiffusalBlade.Target", caster)
                    target:Stop()
                end
            end
        end
    end
end]]---

if item_shine_of_sea_modifier_reduce_modifier == nil then item_shine_of_sea_modifier_reduce_modifier = class({}) end

function item_shine_of_sea_modifier_reduce_modifier:IsPurgable()
    return false
end

function item_shine_of_sea_modifier_reduce_modifier:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }

  return funcs
end

function item_shine_of_sea_modifier_reduce_modifier:GetModifierMoveSpeedBonus_Percentage( params )
  return -40
end

function item_shine_of_sea_modifier_reduce_modifier:GetModifierAttackSpeedBonus_Constant( params )
  return -60
end

function item_shine_of_sea:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
