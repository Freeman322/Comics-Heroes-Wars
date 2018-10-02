gl_hex = class({})

LinkLuaModifier( "modifier_gl_hex", "abilities/gl_hex.lua", LUA_MODIFIER_MOTION_NONE )



function gl_hex:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	local loc = self:GetCaster():GetCursorPosition()
  PrecacheUnitByNameAsync("npc_dota_gl_turret", function()
      local unit = CreateUnitByName( "npc_dota_gl_turret", loc, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
      unit:AddNewModifier(unit, self, "modifier_gl_hex", {duration = duration})
      unit:AddNewModifier(unit, self, "modifier_kill", {duration = duration})

			FindClearSpaceForUnit(unit, loc, true)
  end)
	EmitSoundOn( "Hero_Sven.StormBolt", self:GetCaster() )
end

if modifier_gl_hex == nil then modifier_gl_hex = class({}) end


function modifier_gl_hex:IsHidden()
	return true
end

function modifier_gl_hex:IsPurgable()
	return false
end


function modifier_gl_hex:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_gl_hex:GetModifierExtraHealthBonus( params )
	return self:GetAbility():GetSpecialValueFor("health")
end

function modifier_gl_hex:GetModifierBaseAttack_BonusDamage( params )
	return self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_gl_hex:GetModifierBaseAttack_BonusDamage( params )
	return self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_gl_hex:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end

function gl_hex:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

