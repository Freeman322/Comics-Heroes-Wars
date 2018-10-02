if item_enchanted_raspberries == nil then
  item_enchanted_raspberries = class({})
end

LinkLuaModifier ("modifier_item_enchanted_raspberries", "items/item_enchanted_raspberries.lua", LUA_MODIFIER_MOTION_NONE)

function item_enchanted_raspberries:GetIntrinsicModifierName() 
  return "modifier_item_enchanted_raspberries"
end

function item_enchanted_raspberries:OnSpellStart()
  local caster = self:GetCaster()
  local mana_restore = self:GetSpecialValueFor("mana_restore")
  local hp_restore = self:GetSpecialValueFor("hp_restore")
  local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"

  local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, caster)
  ParticleManager:SetParticleControl(lifesteal_fx, 0, caster:GetAbsOrigin())

  local particle = "particles/items3_fx/mango_active.vpcf"
  local fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
  ParticleManager:SetParticleControl(fx, 0, caster:GetAbsOrigin())

  EmitSoundOn("DOTA_Item.Mango.Activate", caster)
  EmitSoundOn("DOTA_Item.Maim", caster)
  caster:Heal(hp_restore, self)
  caster:SetMana(caster:GetMana() + mana_restore)
  caster:RemoveItem(self)
end

if modifier_item_enchanted_raspberries == nil then
  modifier_item_enchanted_raspberries = class({})
end

function modifier_item_enchanted_raspberries:IsHidden()
  return true
end

function modifier_item_enchanted_raspberries:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_item_enchanted_raspberries:GetModifierPreAttack_BonusDamage (params)
    return 6
end

function modifier_item_enchanted_raspberries:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_enchanted_raspberries:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

