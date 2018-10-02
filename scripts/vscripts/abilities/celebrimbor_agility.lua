if celebrimbor_agility == nil then celebrimbor_agility = class({}) end 

LinkLuaModifier ("modifier_celebrimbor_agility", "abilities/celebrimbor_agility.lua" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_celebrimbor_agility_aura", "abilities/celebrimbor_agility.lua" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_celebrimbor_agility_active", "abilities/celebrimbor_agility.lua" , LUA_MODIFIER_MOTION_NONE)

function celebrimbor_agility:GetIntrinsicModifierName ()
    return "modifier_celebrimbor_agility_aura"
end

function celebrimbor_agility:OnSpellStart ()
    if IsServer() then
      local caster = self:GetCaster ()
      local duration = self:GetDuration()

      caster:AddNewModifier (caster, self, "modifier_celebrimbor_agility_active", {duration = duration})

      EmitSoundOn ("Hero_DarkWillow.Brambles.Cast", caster)
    end
end

if modifier_celebrimbor_agility_aura == nil then modifier_celebrimbor_agility_aura = class({}) end

function modifier_celebrimbor_agility_aura:IsAura()
	return true
end

function modifier_celebrimbor_agility_aura:IsHidden()
	return true
end

function modifier_celebrimbor_agility_aura:IsPurgable()
	return true
end

function modifier_celebrimbor_agility_aura:GetAuraRadius()
	return 400
end

function modifier_celebrimbor_agility_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_celebrimbor_agility_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_celebrimbor_agility_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_celebrimbor_agility_aura:GetModifierAura()
	return "modifier_celebrimbor_agility"
end

if modifier_celebrimbor_agility == nil then
    modifier_celebrimbor_agility = class ( {})
end

function modifier_celebrimbor_agility:IsHidden ()
    return false
end

function modifier_celebrimbor_agility:GetStatusEffectName()
	return "particles/status_fx/status_effect_siren_song.vpcf"
end

--------------------------------------------------------------------------------

function modifier_celebrimbor_agility:StatusEffectPriority()
	return 1000
end

--------------------------------------------------------------------------------

function modifier_celebrimbor_agility:GetHeroEffectName()
	return "particles/status_fx/status_effect_wyvern_curse_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_celebrimbor_agility:HeroEffectPriority()
	return 100
end

function modifier_celebrimbor_agility:IsPurgable()
    return false
end

function modifier_celebrimbor_agility:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }

    return funcs
end

function modifier_celebrimbor_agility:GetModifierEvasion_Constant(params)
    return self:GetAbility():GetSpecialValueFor( "aura_avoid" )
end

function celebrimbor_agility:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

modifier_celebrimbor_agility_active = class({})
--------------------------------------------------------------------------------

function modifier_celebrimbor_agility_active:OnCreated( kv )
	self.bonus_attackspeed = self:GetAbility():GetSpecialValueFor( "bonus_attackspeed" )
	self.bonus_speed = self:GetAbility():GetSpecialValueFor( "bonus_speed" )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_warcry_ti5/sven_shield_ambient_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end


function modifier_celebrimbor_agility_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_celebrimbor_agility_active:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_speed
end


function modifier_celebrimbor_agility_active:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attackspeed
end