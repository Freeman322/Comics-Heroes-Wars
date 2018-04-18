LinkLuaModifier ("modifier_item_battle_rage", "items/item_battle_rage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_battle_rage_echoe", "items/item_battle_rage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_battle_rage_slow", "items/item_battle_rage.lua", LUA_MODIFIER_MOTION_NONE)

if item_battle_rage == nil then
    item_battle_rage = class ( {})
end
function item_battle_rage:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end
function item_battle_rage:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
    return behav
end
function item_battle_rage:GetAOERadius()
    return 320
end
function item_battle_rage:GetIntrinsicModifierName ()
    return "modifier_item_battle_rage"
end

function item_battle_rage:OnSpellStart(  )
    if IsServer() then
        GridNav:DestroyTreesAroundPoint( self:GetCursorPosition(), 320, true )
        -- Destroy all trees in the area(vPosition, flRadius, bFullCollision
    end
end

if modifier_item_battle_rage == nil then
    modifier_item_battle_rage = class ( {})
end

function modifier_item_battle_rage:IsHidden()
    return true
end

function modifier_item_battle_rage:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end
function modifier_item_battle_rage:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end
function modifier_item_battle_rage:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_battle_rage:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_battle_rage:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_battle_rage:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_battle_rage:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_battle_rage:GetModifierPercentageManaRegen(params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end
function modifier_item_battle_rage:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
            if self:GetParent():PassivesDisabled() then
                return 0
            end
            local target = params.target
            EmitSoundOn( "DOTA_Item.BattleFury", target )
            if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                local cleaveDamage = ( self:GetAbility():GetSpecialValueFor( "cleave_damage_percent" ) * params.damage ) / 100.0
                DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, 280, 280, 280, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
            end

            local hAbility = self:GetAbility ()
            if hAbility:IsCooldownReady () and not self:GetParent ():IsRangedAttacker(  ) then
                EmitSoundOn( "DOTA_Item.Maim", target )
                self:GetParent ():AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_battle_rage_echoe", nil)
                params.target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_battle_rage_slow", {duration = 0.6})
                hAbility:StartCooldown (hAbility:GetCooldown (hAbility:GetLevel ()))
                return 0
             end
         end
    end
    return 0
end

if modifier_item_battle_rage_echoe == nil then
    modifier_item_battle_rage_echoe = class ( {})
end

function modifier_item_battle_rage_echoe:IsHidden ()
    return true
end

function modifier_item_battle_rage_echoe:RemoveOnDeath ()
    return true
end

function modifier_item_battle_rage_echoe:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_battle_rage_echoe:GetModifierAttackSpeedBonus_Constant (params)
    return 1500
end

function modifier_item_battle_rage_echoe:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() then
            if self:GetParent ():HasModifier ("modifier_item_battle_rage_echoe") then
                self:Destroy()
            end
        end
    end

    return 0
end

if modifier_item_battle_rage_slow == nil then
    modifier_item_battle_rage_slow = class({})
end

function modifier_item_battle_rage_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_item_battle_rage_slow:GetModifierAttackSpeedBonus_Constant( params )
	return -100
end

--------------------------------------------------------------------------------

function modifier_item_battle_rage_slow:GetModifierMoveSpeedBonus_Percentage( params )
	return -100
end

function item_battle_rage:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

