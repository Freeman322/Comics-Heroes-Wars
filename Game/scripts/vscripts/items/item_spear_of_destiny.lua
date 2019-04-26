item_spear_of_destiny = class({})
LinkLuaModifier( "modifier_item_spear_of_destiny_active", "items/item_spear_of_destiny.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_spear_of_destiny", "items/item_spear_of_destiny.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_spear_of_destiny_aura", "items/item_spear_of_destiny.lua", LUA_MODIFIER_MOTION_NONE )

function item_spear_of_destiny:ProcsMagicStick()
	return false
end

function item_spear_of_destiny:GetIntrinsicModifierName()
	return "modifier_item_spear_of_destiny"
end

function item_spear_of_destiny:OnSpellStart()
    if IsServer() then 
        EmitSoundOn("DOTA_Item.GhostScepter.Activate", self:GetCaster())
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_spear_of_destiny_active", {duration = self:GetSpecialValueFor("duration")} )
    end
end

if modifier_item_spear_of_destiny == nil then
    modifier_item_spear_of_destiny = class({})
end
function modifier_item_spear_of_destiny:IsHidden()
    return true
end
function modifier_item_spear_of_destiny:IsPurgable()
    return false
end
function modifier_item_spear_of_destiny:DeclareFunctions()
local funcs = {
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end
function modifier_item_spear_of_destiny:CheckState()
	local state = {
        [MODIFIER_STATE_CANNOT_MISS] = true
	}

	return state
end
function modifier_item_spear_of_destiny:GetModifierPreAttack_BonusDamage (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_damage")
end
function modifier_item_spear_of_destiny:GetModifierBonusStats_Strength (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_spear_of_destiny:GetModifierBonusStats_Intellect (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_spear_of_destiny:GetModifierBonusStats_Agility (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_spear_of_destiny:GetModifierAttackSpeedBonus_Constant (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_spear_of_destiny:OnAttackLanded (params)
    if params.attacker == self:GetParent() then
        if params.target ~= nil and params.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
            if RollPercentage(self:GetAbility():GetSpecialValueFor("bonus_chance")) then 
                if not params.target:IsBuilding() and self:GetParent():IsRealHero() then 
                    local DamageTable = {
                        victim = params.target,
                        attacker = self:GetCaster(),
                        ability = self:GetAbility(),
                        damage = self:GetAbility():GetSpecialValueFor("bonus_chance_damage"),
                        damage_type = DAMAGE_TYPE_PURE
                    }
                    ApplyDamage(DamageTable)
                    EmitSoundOn( "DOTA_Item.MKB.Minibash", params.target )
                end
            end
        end
    end
end
function modifier_item_spear_of_destiny:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_item_spear_of_destiny:GetBonusNightVision( params )
    return self:GetAbility():GetSpecialValueFor("aura_radius")
end
function modifier_item_spear_of_destiny:GetBonusDayVision( params )
    return self:GetAbility():GetSpecialValueFor("aura_radius")
end
function modifier_item_spear_of_destiny:IsAura()
  return true
end
function modifier_item_spear_of_destiny:GetAuraRadius()
  return 700
end
function modifier_item_spear_of_destiny:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_item_spear_of_destiny:GetAuraSearchType()
  return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_item_spear_of_destiny:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_item_spear_of_destiny:GetModifierAura()
  return "modifier_item_spear_of_destiny_aura"
end

if modifier_item_spear_of_destiny_aura == nil then modifier_item_spear_of_destiny_aura = class({}) end


function modifier_item_spear_of_destiny_aura:IsHidden()
    return true
end

function modifier_item_spear_of_destiny_aura:IsPurgable()
    return false
end

function modifier_item_spear_of_destiny_aura:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA	
end

function modifier_item_spear_of_destiny_aura:GetEffectName()
    return "particles/econ/events/ti6/radiance_owner_ti6.vpcf"
end

function modifier_item_spear_of_destiny_aura:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_spear_of_destiny_aura:OnCreated(table)
    if IsServer() then
        if self:GetParent():IsBuilding() then 
            return
        end
        
        self:StartIntervalThink(1)
    end
end

function modifier_item_spear_of_destiny_aura:OnIntervalThink()
    if IsServer() then
        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("bonus_aura_damage"), damage_type = DAMAGE_TYPE_PURE})
    end
end

if modifier_item_spear_of_destiny_active == nil then modifier_item_spear_of_destiny_active = class({}) end

function modifier_item_spear_of_destiny_active:IsHidden()
    return true
end

function modifier_item_spear_of_destiny_active:IsPurgable()
    return false
end

function modifier_item_spear_of_destiny_active:GetEffectName()
    return "particles/items_fx/ghost.vpcf"
end

function modifier_item_spear_of_destiny_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_spear_of_destiny_active:StatusEffectPriority()
    return 1000
end

function modifier_item_spear_of_destiny_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_ghost.vpcf"
end


function modifier_item_spear_of_destiny_active:DeclareFunctions()
local funcs = {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
    }

    return funcs
end

function modifier_item_spear_of_destiny_active:CheckState ()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_SILENCED] = true
    }

    return state
end


function modifier_item_spear_of_destiny_active:GetAbsoluteNoDamagePhysical( params )
    return 1
end

function modifier_item_spear_of_destiny_active:GetAbsoluteNoDamageMagical( params )
    return 1
end

function modifier_item_spear_of_destiny_active:GetAbsoluteNoDamagePure( params )
    return 1
end
