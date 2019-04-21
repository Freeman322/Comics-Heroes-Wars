LinkLuaModifier( "modifier_green_lantern_lantern_aura", "abilities/green_lantern_lantern.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_green_lantern_lantern_aura_effect", "abilities/green_lantern_lantern.lua", LUA_MODIFIER_MOTION_NONE )

green_lantern_lantern = class({})

function green_lantern_lantern:OnSpellStart()
  local unit = CreateUnitByName( "npc_dota_gl_lantern", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeam())
  unit:AddNewModifier(self:GetCaster(), self, "modifier_green_lantern_lantern_aura", { duration = self:GetSpecialValueFor("duration") })
  unit:AddNewModifier(self:GetCaster(), self, "modifier_kill", { duration = self:GetSpecialValueFor("duration") })
	FindClearSpaceForUnit(unit, self:GetCursorPosition(), true)
	EmitSoundOn( "Hero_Sven.GodsStrength", self:GetCaster() )
end

modifier_green_lantern_lantern_aura = class({})

function modifier_green_lantern_lantern_aura:IsHidden()	return true end
function modifier_green_lantern_lantern_aura:IsPurgable()	return false end
function modifier_green_lantern_lantern_aura:IsAura()	return true end
function modifier_green_lantern_lantern_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_green_lantern_lantern_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_ALL end
function modifier_green_lantern_lantern_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_green_lantern_lantern_aura:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("buff_radius") end
function modifier_green_lantern_lantern_aura:GetModifierAura()	return "modifier_green_lantern_lantern_aura_effect" end

modifier_green_lantern_lantern_aura_effect = class({})
function modifier_green_lantern_lantern_aura_effect:IsHidden()	return true end
function modifier_green_lantern_lantern_aura_effect:IsPurgable()	return false end
function modifier_green_lantern_lantern_aura_effect:DeclareFunctions ()	return { MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE , MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE } end

function modifier_green_lantern_lantern_aura_effect:GetModifierBaseDamageOutgoing_Percentage()
    if self:GetParent():GetUnitName() == "npc_dota_gl_turret" then
      return self:GetAbility():GetSpecialValueFor("damage_amp_pct")
    end
    if IsServer() then
      if self:GetCaster():HasTalent("special_bonus_unique_gl_lantern") then
        return self:GetAbility():GetSpecialValueFor("damage_amp_pct") + self:GetCaster():FindTalentValue("special_bonus_unique_gl_lantern")
      end
    end
    return
end

function modifier_green_lantern_lantern_aura_effect:GetModifierTotalPercentageManaRegen()
    if self:GetParent() == self:GetCaster() then
      return self:GetAbility():GetSpecialValueFor ("mana_regen_pct")
    end
    return 0
end
