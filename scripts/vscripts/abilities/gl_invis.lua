gl_invis = class({})

LinkLuaModifier( "modifier_gl_invis", "abilities/gl_invis.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gl_invis_aura_reject", "abilities/gl_invis.lua", LUA_MODIFIER_MOTION_NONE )

function gl_invis:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	local loc = self:GetCaster():GetCursorPosition()
  PrecacheUnitByNameAsync("npc_dota_gl_healing_ward", function()
      local unit = CreateUnitByName( "npc_dota_gl_healing_ward", loc, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
      unit:AddNewModifier(unit, self, "modifier_gl_invis", {duration = duration})
      unit:AddNewModifier(unit, self, "modifier_kill", {duration = duration})

			FindClearSpaceForUnit(unit, loc, true)
  end)
	EmitSoundOn( "Hero_Sven.GodsStrength", self:GetCaster() )
end

if modifier_gl_invis == nil then modifier_gl_invis = class({}) end

function modifier_gl_invis:IsHidden()
	return true
end

function modifier_gl_invis:IsPurgable()
	return false
end

function modifier_gl_invis:IsAura()
	return true
end

function modifier_gl_invis:GetModifierAura()
	return "modifier_gl_invis_aura_reject"
end

function modifier_gl_invis:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_gl_invis:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_gl_invis:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_gl_invis:GetAuraRadius()
	return 800
end

function modifier_gl_invis:OnCreated( kv )
	if IsServer() then
  end
end

if modifier_gl_invis_aura_reject == nil then modifier_gl_invis_aura_reject = class({}) end

function modifier_gl_invis_aura_reject:IsHidden()
	return true
end

function modifier_gl_invis_aura_reject:IsPurgable()
	return false
end

function modifier_gl_invis_aura_reject:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }

    return funcs
end

function modifier_gl_invis_aura_reject:GetModifierBaseDamageOutgoing_Percentage (params)
    if self:GetParent():GetUnitName() == "npc_dota_gl_turret" then
      return self:GetAbility():GetSpecialValueFor("tower_damage")
    end
    return
end

function modifier_gl_invis_aura_reject:GetModifierConstantManaRegen (params)
    if self:GetParent() == self:GetAbility():GetCaster() then
      return self:GetParent():GetMaxMana () * (self:GetAbility():GetSpecialValueFor ("mana_regen")/100)
    end
    return
end

function gl_invis:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

