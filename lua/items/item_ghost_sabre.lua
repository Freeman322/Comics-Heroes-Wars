LinkLuaModifier( "modifier_item_ghost_sabre", "items/item_ghost_sabre.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ghost_sabre_active", "items/item_ghost_sabre.lua", LUA_MODIFIER_MOTION_NONE )

if item_ghost_sabre == nil then
	item_ghost_sabre = class({})
end

function item_ghost_sabre:GetIntrinsicModifierName()
	return "modifier_item_ghost_sabre"
end


function item_ghost_sabre:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function item_ghost_sabre:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end


function item_ghost_sabre:OnSpellStart()
	local info = {
			EffectName = "particles/items_fx/ethereal_blade.vpcf",
			Ability = self,
			iMoveSpeed = 1200,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "DOTA_Item.EtherealBlade.Activate", self:GetCaster() )
end

--------------------------------------------------------------------------------

function item_ghost_sabre:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "DOTA_Item.EtherealBlade.Target", hTarget )
		local ghost_duration = self:GetSpecialValueFor( "duration" )
		local damage = self:GetSpecialValueFor( "blast_stats_multiplier" )*(self:GetCaster():GetAgility() + self:GetCaster():GetStrength() + self:GetCaster():GetIntellect())

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
		self:GetCaster():PerformAttack(hTarget, true, true, true, true, true, false, true) 
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_item_ghost_sabre_active", { duration = ghost_duration } )
		self:GetCaster():SetAbsOrigin(hTarget:GetAbsOrigin())
		FindClearSpaceForUnit(self:GetCaster(), hTarget:GetAbsOrigin(), true) 
	end

	return true
end

if modifier_item_ghost_sabre == nil then
	modifier_item_ghost_sabre = class({})
end

function modifier_item_ghost_sabre:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_ghost_sabre:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

return funcs
end

function modifier_item_ghost_sabre:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_ghost_sabre:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_ghost_sabre:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_ghost_sabre:GetModifierMoveSpeedBonus_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_movement_speed" )
end

function modifier_item_ghost_sabre:GetModifierAttackSpeedBonus_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_attack_speed" )
end

if modifier_item_ghost_sabre_active == nil then 
	modifier_item_ghost_sabre_active = class({})
end

function modifier_item_ghost_sabre_active:IsHidden() 
	return false
end

function modifier_item_ghost_sabre_active:IsBuff ()
    return false
end

function modifier_item_ghost_sabre_active:GetStatusEffectName ()
    return "particles/status_fx/status_effect_ghost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_ghost_sabre_active:StatusEffectPriority ()
    return 1000
end

--------------------------------------------------------------------------------

function modifier_item_ghost_sabre_active:GetEffectName ()
    return "particles/items_fx/ghost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_ghost_sabre_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_ghost_sabre_active:GetTexture ()
    return "item_ghost_sabre"
end

function modifier_item_ghost_sabre_active:IsPurgable ()
    return false
end

function modifier_item_ghost_sabre_active:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS

    }

    return funcs
end

function modifier_item_ghost_sabre_active:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

function modifier_item_ghost_sabre_active:GetModifierMoveSpeedBonus_Percentage (params)
    return self:GetAbility():GetSpecialValueFor("blast_movement_slow") 
end

function modifier_item_ghost_sabre_active:GetAbsoluteNoDamagePhysical (params)
    return 1
end

function modifier_item_ghost_sabre_active:GetModifierMagicalResistanceBonus (params)
    return -40
end
function item_ghost_sabre:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

