if item_perseus_boots == nil then
    item_perseus_boots = class({})
end
LinkLuaModifier("modifier_item_perseus_boots", "items/item_perseus_boots.lua", LUA_MODIFIER_MOTION_NONE)

function item_perseus_boots:GetIntrinsicModifierName()
    return "modifier_item_perseus_boots"
end

function item_perseus_boots:OnSpellStart()
    local hCaster = self:GetCaster()
    if hCaster:GetUnitName() == "npc_dota_hero_dazzle" then 
        return 
    end
    local hTarget = self:GetCaster():GetCursorPosition()
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hCaster)
    hCaster:EmitSound("DOTA_Item.BlinkDagger.Activate")
    self:GetCaster():SetAbsOrigin (hTarget)
    FindClearSpaceForUnit (self:GetCaster(), hTarget, true)
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if modifier_item_perseus_boots == nil then
    modifier_item_perseus_boots = class ( {})
end

function modifier_item_perseus_boots:IsHidden()
    return true
end

function modifier_item_perseus_boots:IsPurgable()
    return true
end

function modifier_item_perseus_boots:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end
function modifier_item_perseus_boots:OnTakeDamage( event )
    local attacker_name = event.attacker:GetName()
    if event.unit == self:GetParent() then
      if event.damage > 0 and (attacker_name == "npc_dota_roshan" or event.attacker:IsControllableByAnyPlayer()) then
          self:GetAbility():StartCooldown(15)
      end
    end
end

function modifier_item_perseus_boots:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_perseus_boots:GetModifierMoveSpeedBonus_Special_Boots (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_movement")
end
function modifier_item_perseus_boots:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_perseus_boots:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_perseus_boots:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_perseus_boots:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end
function modifier_item_perseus_boots:GetModifierMoveSpeed_Limit (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("speed_border")
end
function modifier_item_perseus_boots:GetModifierMoveSpeed_Max (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("speed_border")
end



function item_perseus_boots:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
