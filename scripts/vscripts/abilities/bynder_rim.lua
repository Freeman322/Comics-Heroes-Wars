bynder_rim = class({})
LinkLuaModifier("modifier_bynder_rim", "abilities/bynder_rim.lua", LUA_MODIFIER_MOTION_NONE)

function bynder_rim:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/byonder_outer_rim_arcana"
	end
	return "custom/bynder_astral"
end

function bynder_rim:OnSpellStart ()
  local duration
  if self:GetCaster():HasScepter() then
    duration = self:GetSpecialValueFor("scepter_duration")
  else
    duration = self:GetSpecialValueFor("duration")
  end

  if self:GetCaster():HasTalent("special_bonus_unique_byonder") then
    duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_byonder")
  end

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bynder_rim", {duration = duration})
end

modifier_bynder_rim = class({})

function modifier_bynder_rim:IsBuff() return true end
function modifier_bynder_rim:IsHidden() return true end
function modifier_bynder_rim:IsPurgable() return false end

function modifier_bynder_rim:DeclareFunctions ()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
end

function modifier_bynder_rim:OnTakeDamage( params )
    if self:GetParent () == params.unit then
        self:GetParent ():SetHealth(self:GetParent():GetHealth() + params.damage)

        if not params.attacker:IsBuilding() then
            self:SetStackCount(self:GetStackCount() + params.damage)
        end

        local RemovePositiveBuffs = false
        local RemoveDebuffs = true
        local BuffsCreatedThisFrameOnly = false
        local RemoveStuns = true
        local RemoveExceptions = true
        self:GetParent():Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
    end
end

function modifier_bynder_rim:GetModifierIncomingDamage_Percentage()
  if self:GetCaster():HasScepter() then
    return self:GetAbility():GetSpecialValueFor("scepter_incoming_damage")
  else
    return 0
  end
end

function modifier_bynder_rim:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bynder_rim:GetStatusEffectName()
    return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf"
end

function modifier_bynder_rim:StatusEffectPriority() return 1000 end

function modifier_bynder_rim:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf"
end

function modifier_bynder_rim:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_bynder_rim:GetModifierPreAttack_BonusDamage( params )
    return self:GetStackCount()
end
