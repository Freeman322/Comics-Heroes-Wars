item_avernos_mist = class({})
LinkLuaModifier( "modifier_item_avernos_mist", "items/item_avernos_mist.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_avernos_mist_aura_self", "items/item_avernos_mist.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_avernos_mist_aura_radius", "items/item_avernos_mist.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_avernos_mist_active", "items/item_avernos_mist.lua", LUA_MODIFIER_MOTION_NONE )

function item_avernos_mist:ProcsMagicStick()
	return false
end

function item_avernos_mist:GetIntrinsicModifierName()
	return "modifier_item_avernos_mist"
end

function item_avernos_mist:OnSpellStart()
    if IsServer() then 
        EmitSoundOn ("Item.CrimsonGuard.Cast", self:GetCaster () )

        local nearby_allied_units = FindUnitsInRadius (self:GetCaster ():GetTeam (), self:GetCaster ():GetAbsOrigin (), nil, self:GetSpecialValueFor("aura_radius"),
        DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)    
        
        for i, nearby_ally in ipairs (nearby_allied_units) do  
            nearby_ally:AddNewModifier (self:GetCaster (), self, "modifier_item_avernos_mist_active", { duration = self:GetSpecialValueFor ("active_duration") })
        end
    end 
end

if modifier_item_avernos_mist == nil then
    modifier_item_avernos_mist = class ( {})
end

function modifier_item_avernos_mist:IsHidden ()
    return true
end

if modifier_item_avernos_mist_active == nil then modifier_item_avernos_mist_active = class({}) end

function modifier_item_avernos_mist_active:IsHidden()
    return false
end

function modifier_item_avernos_mist_active:IsPurgable()
    return false
end

function modifier_item_avernos_mist_active:OnCreated(params)
    if IsServer() then
        self:GetParent():Purge(false, true, false, true, false) 
    end 
end


function modifier_item_avernos_mist_active:GetEffectName()
    return "particles/items_fx/avernos_mist.vpcf"
end

function modifier_item_avernos_mist_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_avernos_mist_active:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE 
    }

    return funcs
end

function modifier_item_avernos_mist_active:GetModifierIncomingDamage_Percentage (params)
    return self:GetAbility():GetSpecialValueFor ("status_resistance") * (-1)
end

function modifier_item_avernos_mist_active:GetModifierHealthRegenPercentage (params)
    return self:GetAbility():GetSpecialValueFor ("active_hp_regen")
end

function modifier_item_avernos_mist_active:GetModifierTotalPercentageManaRegen (params)
    return self:GetAbility():GetSpecialValueFor ("active_mana_regen")
end

function item_avernos_mist:GetIntrinsicModifierName()
	return "modifier_item_avernos_mist_aura_self"
end

if modifier_item_avernos_mist_aura_self == nil then modifier_item_avernos_mist_aura_self = class({}) end

function modifier_item_avernos_mist_aura_self:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }

    return funcs
end

function modifier_item_avernos_mist_aura_self:GetModifierHealthBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health")
end
function modifier_item_avernos_mist_aura_self:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_avernos_mist_aura_self:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_avernos_mist_aura_self:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_avernos_mist_aura_self:GetModifierPhysicalArmorBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_armor")
end
function modifier_item_avernos_mist_aura_self:GetModifierMagicalResistanceBonus(params)
    return self:GetAbility():GetSpecialValueFor("bonus_magical_armor")
end
function modifier_item_avernos_mist_aura_self:GetModifierMoveSpeedBonus_Percentage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("movement_speed_percent_bonus")
end
function modifier_item_avernos_mist_aura_self:GetModifierManaBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana")
end

function modifier_item_avernos_mist_aura_self:IsAura()
	return true
end

function modifier_item_avernos_mist_aura_self:IsHidden()
	return true
end

function modifier_item_avernos_mist_aura_self:IsPurgable()
	return false
end

function modifier_item_avernos_mist_aura_self:GetAuraRadius()
	return 1000
end

function modifier_item_avernos_mist_aura_self:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_avernos_mist_aura_self:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_item_avernos_mist_aura_self:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_avernos_mist_aura_self:GetModifierAura()
	return "modifier_item_avernos_mist_aura_radius"
end

if modifier_item_avernos_mist_aura_radius == nil then modifier_item_avernos_mist_aura_radius = class({}) end

function modifier_item_avernos_mist_aura_radius:IsPurgable(  )
    return false
end

function modifier_item_avernos_mist_aura_radius:OnCreated(table)
end

function modifier_item_avernos_mist_aura_radius:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }

    return funcs
end

function modifier_item_avernos_mist_aura_radius:GetModifierPhysicalArmorBonus( params )
    local abil = self:GetAbility()
if abil  then
    if self:GetCaster():GetHealthPercent() <= 30 then
        return abil:GetSpecialValueFor("aura_armor") * 2
    end
  return abil:GetSpecialValueFor("aura_armor")
end
return 0
end

function modifier_item_avernos_mist_aura_radius:GetModifierConstantHealthRegen( params )
    local abil = self:GetAbility()
if abil  then
    if self:GetCaster():GetHealthPercent() <= 30 then
        return abil:GetSpecialValueFor("aura_health_regen") * 2
    end
  return abil:GetSpecialValueFor("aura_health_regen")
end
return 0
end

function modifier_item_avernos_mist_aura_radius:GetModifierMagicalResistanceBonus( params )
    local abil = self:GetAbility()
if abil  then
  return abil:GetSpecialValueFor("aura_bonus_magical_armor")
end
return 0
end

function item_avernos_mist:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
