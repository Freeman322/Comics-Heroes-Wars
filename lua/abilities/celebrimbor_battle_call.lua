if celebrimbor_battle_call == nil then celebrimbor_battle_call = class({}) end 

LinkLuaModifier ("modifier_celebrimbor_battle_call", "abilities/celebrimbor_battle_call.lua" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_celebrimbor_battle_call_aura", "abilities/celebrimbor_battle_call.lua" , LUA_MODIFIER_MOTION_NONE)

function celebrimbor_battle_call:GetIntrinsicModifierName ()
    return "modifier_celebrimbor_battle_call_aura"
end

if modifier_celebrimbor_battle_call_aura == nil then modifier_celebrimbor_battle_call_aura = class({}) end

function modifier_celebrimbor_battle_call_aura:IsAura()
	return true
end

function modifier_celebrimbor_battle_call_aura:IsHidden()
	return true
end

function modifier_celebrimbor_battle_call_aura:IsPurgable()
	return true
end

function modifier_celebrimbor_battle_call_aura:GetAuraRadius()
	return 400
end

function modifier_celebrimbor_battle_call_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_celebrimbor_battle_call_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_celebrimbor_battle_call_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_celebrimbor_battle_call_aura:GetModifierAura()
	return "modifier_celebrimbor_battle_call"
end

if modifier_celebrimbor_battle_call == nil then
    modifier_celebrimbor_battle_call = class ( {})
end

function modifier_celebrimbor_battle_call:IsHidden ()
    return false
end

function modifier_celebrimbor_battle_call:GetEffectName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_debuff.vpcf"
end

function modifier_celebrimbor_battle_call:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_celebrimbor_battle_call:OnCreated()
   	self.value = self:GetAbility():GetSpecialValueFor("bonus_magical_armor")

   	if self:GetParent():GetTeamNumber() ~= self:GetAbility():GetCaster():GetTeamNumber() then 
		self.value = self.value * (-1)
	end		
end


function modifier_celebrimbor_battle_call:IsHidden ()
    return false
end


function modifier_celebrimbor_battle_call:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }

    return funcs
end

function modifier_celebrimbor_battle_call:GetModifierMagicalResistanceBonus(params)
    return self.value
end

function celebrimbor_battle_call:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 
