LinkLuaModifier ("modifier_item_sea_blade", "items/item_sea_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_sea_blade_echoe", "items/item_sea_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_sea_blade_slow", "items/item_sea_blade.lua", LUA_MODIFIER_MOTION_NONE)

if item_sea_blade == nil then
    item_sea_blade = class ( {})
end

function item_sea_blade:GetIntrinsicModifierName ()
    return "modifier_item_sea_blade"
end

if modifier_item_sea_blade == nil then
    modifier_item_sea_blade = class ( {})
end

function modifier_item_sea_blade:IsHidden()
    return true
end

function modifier_item_sea_blade:IsPurgable()
    return false
end

function modifier_item_sea_blade:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_sea_blade:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_sea_blade:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_strength")
end

function modifier_item_sea_blade:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_intellect")
end

function modifier_item_sea_blade:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end

function modifier_item_sea_blade:GetModifierConstantManaRegen(params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end

function modifier_item_sea_blade:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
            if self:GetParent():PassivesDisabled() then
                return 0
            end
            local target = params.target
            local hAbility = self:GetAbility ()
            if hAbility:IsCooldownReady () and not self:GetParent ():IsRangedAttacker(  ) then
                EmitSoundOn( "DOTA_Item.Maim", target )
                EmitSoundOn( "DOTA_Item.BattleFury", target )
                if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                    local cleaveDamage = params.damage
                    DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, self:GetAbility():GetSpecialValueFor("aoe_attack"), self:GetAbility():GetSpecialValueFor("aoe_attack"), self:GetAbility():GetSpecialValueFor("aoe_attack"), "particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf" )
                end
                self:GetParent ():AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_sea_blade_echoe", nil)
                params.target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_sea_blade_slow", {duration = 0.6})
                hAbility:StartCooldown (hAbility:GetCooldown (hAbility:GetLevel ()))
                return 0
             end
         end
    end
    return 0
end

if modifier_item_sea_blade_echoe == nil then
    modifier_item_sea_blade_echoe = class ( {})
end

function modifier_item_sea_blade_echoe:IsHidden ()
    return true
end

function modifier_item_sea_blade_echoe:RemoveOnDeath ()
    return true
end

function modifier_item_sea_blade_echoe:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_sea_blade_echoe:GetModifierAttackSpeedBonus_Constant (params)
    return 1500
end

function modifier_item_sea_blade_echoe:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() then
            if self:GetParent ():HasModifier ("modifier_item_sea_blade_echoe") then
                self:Destroy()
            end
        end
    end

    return 0
end

if modifier_item_sea_blade_slow == nil then
    modifier_item_sea_blade_slow = class({})
end

function modifier_item_sea_blade_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_item_sea_blade_slow:GetModifierAttackSpeedBonus_Constant( params )
	return -100
end

function modifier_item_sea_blade_slow:GetModifierMoveSpeedBonus_Percentage( params )
	return -100
end

function item_sea_blade:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

