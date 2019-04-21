LinkLuaModifier ("modifier_item_echoe_sabre_marvel", "items/item_echoe_sabre_marvel.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_echoe_sabre_marvel_echoe", "items/item_echoe_sabre_marvel.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_echoe_sabre_marvel_slow", "items/item_echoe_sabre_marvel.lua", LUA_MODIFIER_MOTION_NONE)

if item_echoe_sabre_marvel == nil then
    item_echoe_sabre_marvel = class ( {})
end

function item_echoe_sabre_marvel:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function item_echoe_sabre_marvel:GetIntrinsicModifierName ()
    return "modifier_item_echoe_sabre_marvel"
end

if modifier_item_echoe_sabre_marvel == nil then
    modifier_item_echoe_sabre_marvel = class ( {})
end

function modifier_item_echoe_sabre_marvel:IsHidden()
    return true
end

function modifier_item_echoe_sabre_marvel:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_echoe_sabre_marvel:GetModifierPreAttack_BonusDamage (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_damage")
end
function modifier_item_echoe_sabre_marvel:GetModifierBonusStats_Strength (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_strength")
end
function modifier_item_echoe_sabre_marvel:GetModifierBonusStats_Intellect (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_intellect")
end

function modifier_item_echoe_sabre_marvel:GetModifierAttackSpeedBonus_Constant (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_echoe_sabre_marvel:GetModifierPercentageManaRegen(params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_mana_regen")
end

function modifier_item_echoe_sabre_marvel:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local hAbility = self:GetAbility ()
            if hAbility:IsCooldownReady () and not self:GetParent ():IsRangedAttacker(  ) then
                self:GetParent ():AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_echoe_sabre_marvel_echoe", nil)
                params.target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_echoe_sabre_marvel_slow", {duration = 0.6})
                hAbility:StartCooldown (hAbility:GetCooldown (hAbility:GetLevel ()))
                EmitSoundOn( "DOTA_Item.Maim", params.target )
                -- Play named sound on Entity
                return 0
            end
        end
    end

    return 0
end

if modifier_item_echoe_sabre_marvel_echoe == nil then
    modifier_item_echoe_sabre_marvel_echoe = class ( {})
end

function modifier_item_echoe_sabre_marvel_echoe:IsHidden ()
    return true
end

function modifier_item_echoe_sabre_marvel_echoe:RemoveOnDeath ()
    return true
end

function modifier_item_echoe_sabre_marvel_echoe:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_echoe_sabre_marvel_echoe:GetModifierAttackSpeedBonus_Constant (params)
    return 600
end

function modifier_item_echoe_sabre_marvel_echoe:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() then
            if self:GetParent ():HasModifier ("modifier_item_echoe_sabre_marvel_echoe") then
                self:Destroy()
            end
        end
    end

    return 0
end

if modifier_item_echoe_sabre_marvel_slow == nil then
    modifier_item_echoe_sabre_marvel_slow = class({})
end

function modifier_item_echoe_sabre_marvel_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_item_echoe_sabre_marvel_slow:GetModifierAttackSpeedBonus_Constant( params )
	return -100
end

--------------------------------------------------------------------------------

function modifier_item_echoe_sabre_marvel_slow:GetModifierMoveSpeedBonus_Percentage( params )
	return -100
end

function item_echoe_sabre_marvel:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

