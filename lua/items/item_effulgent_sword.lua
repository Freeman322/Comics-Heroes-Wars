LinkLuaModifier ("modifier_item_effulgent_sword", "items/item_effulgent_sword.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_effulgent_sword_target", "items/item_effulgent_sword.lua", LUA_MODIFIER_MOTION_NONE)
if item_effulgent_sword == nil then
	item_effulgent_sword = class({})
end

function item_effulgent_sword:GetIntrinsicModifierName() 
	return "modifier_item_effulgent_sword"
end

function item_effulgent_sword:CastFilterResultTarget( hTarget )
	if IsServer() then

		if hTarget ~= nil and hTarget:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end


function item_effulgent_sword:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			local duration = self:GetSpecialValueFor( "duration" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_bloodthorn_debuff", { duration = duration } )
			EmitSoundOn( "DOTA_Item.InfusedRaindrop", hTarget )
		end
	end
end

if modifier_item_effulgent_sword_target == nil then 
	modifier_item_effulgent_sword_target = class({})
end

function modifier_item_effulgent_sword_target:IsHidden()
	return false
end

function modifier_item_effulgent_sword_target:GetEffectName()
	return "particles/items2_fx/orchid.vpcf"
end

function modifier_item_effulgent_sword_target:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_effulgent_sword_target:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_TARGET_CRITICALSTRIKE,
	}

	return funcs
end

function modifier_item_effulgent_sword_target:GetModifierPreAttack_Target_CriticalStrike( params )
	return math.random(175, 200)
end

function modifier_item_effulgent_sword_target:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_BLIND] = true,
	}

	return state
end

if modifier_item_effulgent_sword == nil then
	modifier_item_effulgent_sword = class({})
end

function modifier_item_effulgent_sword:IsHidden()
	return true
end

function modifier_item_effulgent_sword:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_item_effulgent_sword:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_effulgent_sword:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_effulgent_sword:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_effulgent_sword:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_effulgent_sword:GetModifierEvasion_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_evasion")
end

function modifier_item_effulgent_sword:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function item_effulgent_sword:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

