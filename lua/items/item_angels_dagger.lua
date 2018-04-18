item_angels_dagger = class({})
LinkLuaModifier( "modifier_item_angels_dagger_active", "items/item_angels_dagger.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_angels_dagger_inactive", "items/item_angels_dagger.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_angels_dagger", "items/item_angels_dagger.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_angels_dagger_avoids", "items/item_angels_dagger.lua", LUA_MODIFIER_MOTION_NONE )

function item_angels_dagger:ProcsMagicStick()
	return false
end

function item_angels_dagger:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_item_angels_dagger_active") then
		return "custom/angels_dagger_active"
	else
    return "custom/angels_dagger"
  end
end

function item_angels_dagger:GetIntrinsicModifierName()
	return "modifier_item_angels_dagger"
end

function item_angels_dagger:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_angels_dagger_active", nil )
    local hRotBuff = self:GetCaster():FindModifierByName( "modifier_item_angels_dagger_inactive" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	else
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_angels_dagger_inactive", nil )
    local hRotBuff = self:GetCaster():FindModifierByName( "modifier_item_angels_dagger_active" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end

if modifier_item_angels_dagger == nil then
    modifier_item_angels_dagger = class({})
end

function modifier_item_angels_dagger:IsHidden()
    return true
end

function modifier_item_angels_dagger:IsPurgable()
    return false
end

function modifier_item_angels_dagger:DeclareFunctions()
local funcs = {
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_FIXED_DAY_VISION,
    MODIFIER_PROPERTY_FIXED_NIGHT_VISION
}

return funcs
end
function modifier_item_angels_dagger:GetFixedNightVision( params )
    return self:GetAbility():GetSpecialValueFor("bonus_vision")
end
function modifier_item_angels_dagger:GetFixedDayVision( params )
    return self:GetAbility():GetSpecialValueFor("bonus_vision")
end
function modifier_item_angels_dagger:GetModifierPreAttack_BonusDamage( params )
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end
function modifier_item_angels_dagger:GetModifierBonusStats_Strength( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_strength" )
end

function modifier_item_angels_dagger:GetModifierAttackSpeedBonus_Constant( params )
    return self:GetAbility():GetSpecialValueFor( "attack_speed" )
end

function modifier_item_angels_dagger:GetModifierPhysicalArmorBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

function modifier_item_angels_dagger:IsAura()
  return true
end

function modifier_item_angels_dagger:GetAuraRadius()
  return 900
end

function modifier_item_angels_dagger:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_angels_dagger:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO
end

function modifier_item_angels_dagger:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_angels_dagger:GetModifierAura()
  return "modifier_truesight"
end

if modifier_item_angels_dagger_active == nil then modifier_item_angels_dagger_active = class({}) end


function modifier_item_angels_dagger_active:IsHidden()
    return true
end

function modifier_item_angels_dagger_active:IsPurgable()
    return false
end

function modifier_item_angels_dagger_active:GetEffectName()
    return "particles/items2_fx/radiance.vpcf"
end

function modifier_item_angels_dagger_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_angels_dagger_active:OnCreated(table)
    if IsServer() then
        self:StartIntervalThink(0.1)
        self:OnIntervalThink()
    end
end

function modifier_item_angels_dagger_active:OnIntervalThink()
    if IsServer() then
        local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("true_sight_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
      	if #enemies > 0 then
      		for _,target in pairs(enemies) do
            ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = target, ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("aura_damage")/10, damage_type = DAMAGE_TYPE_MAGICAL})
      		end
      	end
    end
end

function modifier_item_angels_dagger_active:IsAura()
  return true
end

function modifier_item_angels_dagger_active:GetAuraRadius()
  return 900
end

function modifier_item_angels_dagger_active:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_angels_dagger_active:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO
end

function modifier_item_angels_dagger_active:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_angels_dagger_active:GetModifierAura()
  return "modifier_item_angels_dagger_avoids"
end

if modifier_item_angels_dagger_inactive == nil then modifier_item_angels_dagger_inactive = class({}) end

function modifier_item_angels_dagger_inactive:IsHidden()
    return true
end

function modifier_item_angels_dagger_inactive:IsPurgable()
    return false
end

function modifier_item_angels_dagger_inactive:IsAura()
  return true
end

function modifier_item_angels_dagger_inactive:GetAuraRadius()
  return 900
end

function modifier_item_angels_dagger_inactive:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_angels_dagger_inactive:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO
end

function modifier_item_angels_dagger_inactive:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_angels_dagger_inactive:GetModifierAura()
  return "modifier_item_angels_dagger_avoids"
end

if modifier_item_angels_dagger_avoids == nil then modifier_item_angels_dagger_avoids = class({}) end

function modifier_item_angels_dagger_avoids:IsHidden()
    return true
end

function modifier_item_angels_dagger_avoids:IsPurgable()
    return false
end

function modifier_item_angels_dagger_avoids:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }

    return funcs
end

function modifier_item_angels_dagger_avoids:GetModifierEvasion_Constant (params)
    return self:GetAbility():GetSpecialValueFor ("blind_pct")
end

function item_angels_dagger:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

