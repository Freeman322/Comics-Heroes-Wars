if item_eclipsed_blade == nil then item_eclipsed_blade = class({}) end

LinkLuaModifier( "modifier_item_eclipsed_blade_active", "items/item_eclipsed_blade.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_eclipsed_blade", "items/item_eclipsed_blade.lua", LUA_MODIFIER_MOTION_NONE )


function item_eclipsed_blade:GetIntrinsicModifierName()
	return "modifier_item_eclipsed_blade"
end

function item_eclipsed_blade:OnSpellStart()
    local duration = self:GetSpecialValueFor("windwalk_duration")
    local caster = self:GetCaster()
    EmitSoundOn("DOTA_Item.ShadowAmulet.Activate", caster)
    caster:AddNewModifier(caster, self, "modifier_item_eclipsed_blade_active", {duration = duration})
    caster:AddNewModifier(caster, self, "modifier_invisible", {duration = duration})
end

if modifier_item_eclipsed_blade_active == nil then modifier_item_eclipsed_blade_active = class({}) end

function modifier_item_eclipsed_blade_active:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_eclipsed_blade_active:IsPurgable()
	return false
end

function modifier_item_eclipsed_blade_active:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_item_eclipsed_blade_active:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "windwalk_bonus_damage_pre_attack" )
end


function modifier_item_eclipsed_blade_active:OnAbilityExecuted( params )
	 if params.unit == self:GetParent() then
        self:Destroy()
     end
end

function modifier_item_eclipsed_blade_active:OnCreated(table)
     if IsServer() then
        self.IsActive = true
     end
end

function modifier_item_eclipsed_blade_active:CheckState()
	local state = {
	    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	return state
end

function modifier_item_eclipsed_blade_active:GetModifierMoveSpeedBonus_Constant()
     return self:GetAbility():GetSpecialValueFor("windwalk_movement_speed")
end

function modifier_item_eclipsed_blade_active:GetModifierPreAttack_CriticalStrike( params )
    if self.IsActive then
        return self:GetAbility():GetSpecialValueFor("windwalk_bonus_damage")
    else
        return
    end
end

function modifier_item_eclipsed_blade_active:OnAttackLanded( params )
    if params.attacker == self:GetParent() then
        local target = params.target
        if target then 
            target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_silver_edge_debuff", {duration = 10})
        end
        self.IsActive = false
    	self:Destroy()
    end
end

if modifier_item_eclipsed_blade == nil then
    modifier_item_eclipsed_blade = class({})
end
function modifier_item_eclipsed_blade:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_eclipsed_blade:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

return funcs
end

function modifier_item_eclipsed_blade:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_eclipsed_blade:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_eclipsed_blade:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_eclipsed_blade:GetModifierAttackSpeedBonus_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_attack_speed" )
end

function modifier_item_eclipsed_blade:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end

function item_eclipsed_blade:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

