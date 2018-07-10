if nightking_frost_embrace == nil then nightking_frost_embrace = class({}) end
LinkLuaModifier( "modifier_nightking_necromastery_undead", "abilities/nightking_necromastery.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_nightking_frost_embrace", "abilities/nightking_frost_embrace", LUA_MODIFIER_MOTION_NONE)

function nightking_frost_embrace:GetIntrinsicModifierName()
  return "modifier_nightking_frost_embrace"
end

if modifier_nightking_frost_embrace == nil then modifier_nightking_frost_embrace = class({}) end

function modifier_nightking_frost_embrace:IsHidden()
  return false
end

function modifier_nightking_frost_embrace:IsPurgable()
  return false
end

function modifier_nightking_frost_embrace:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED,
  }

  return funcs
end

function modifier_nightking_frost_embrace:OnAttackLanded( params )
  if IsServer() then
    if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
      if self:GetParent():PassivesDisabled() then
        return 0
      end
      local target = params.target
      if target ~= nil and target:IsBuilding() == false and not target:IsHero() and not target:IsAncient() and not target:IsConsideredHero() then
        ApplyDamage({
            attacker = self:GetParent(),
            victim = target, 
            ability = self:GetAbility(), 
            damage = self:GetAbility():GetSpecialValueFor("bonus_damage"), 
            damage_type = self:GetAbility():GetAbilityDamageType()
        })

        if RollPercentage(self:GetAbility():GetSpecialValueFor("transform_chance")) then
            target:Kill(self:GetAbility(), self:GetParent()) 
            local model_name = target:GetModelName()
            if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "ancient_relic") == true then
              model_name = "models/items/undying/idol_of_ruination/ruin_wight_minion_gold.vmdl"
            end
            Util:CreateCreep(target:GetUnitName(), model_name, self:GetCaster(), {duration = nil}, {"modifier_nightking_necromastery_undead"})
        end
      end
    end
  end

  return 0
end
