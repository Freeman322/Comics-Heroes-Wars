LinkLuaModifier( "modifier_item_oathbreaker", "items/item_oathbreaker.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_oathbreaker_active", "items/item_oathbreaker.lua", LUA_MODIFIER_MOTION_NONE )

if item_oathbreaker == nil then
	item_oathbreaker = class({})
end

function item_oathbreaker:GetIntrinsicModifierName()
	return "modifier_item_oathbreaker"
end


function item_oathbreaker:CastFilterResultTarget( hTarget )
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

function item_oathbreaker:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

function item_oathbreaker:OnSpellStart()
	local hTarget = self:GetCursorTarget()
    local hCaster = self:GetCaster()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
             local info = {
                EffectName = "particles/items_fx/ethereal_blade.vpcf",
                Ability = self,
                iMoveSpeed = 1200,
                Source = hCaster,
                Target = hTarget,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
          }
            EmitSoundOn( "DOTA_Item.EtherealBlade.Activate", self:GetCaster() )
                      
            ProjectileManager:CreateTrackingProjectile( info )  
            hTarget:AddNewModifier( hCaster, self, "modifier_stunned", {duration = 0.3} )
       end
    end
end

--------------------------------------------------------------------------------

function item_oathbreaker:OnProjectileHit( hTarget, vLocation )
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
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_item_oathbreaker_active", { duration = ghost_duration } )
	end

	return true
end

if modifier_item_oathbreaker == nil then
	modifier_item_oathbreaker = class({})
end

function modifier_item_oathbreaker:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_oathbreaker:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_EVASION_CONSTANT
}

return funcs
end

function modifier_item_oathbreaker:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_strength" )
end

function modifier_item_oathbreaker:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_intellect" )
end
function modifier_item_oathbreaker:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_agility" )
end

function modifier_item_oathbreaker:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end

function modifier_item_oathbreaker:GetModifierEvasion_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_evasion" )
end

if modifier_item_oathbreaker_active == nil then 
	modifier_item_oathbreaker_active = class({})
end

function modifier_item_oathbreaker_active:IsHidden() 
	return false
end

function modifier_item_oathbreaker_active:IsBuff ()
    return false
end

function modifier_item_oathbreaker_active:GetStatusEffectName ()
    return "particles/status_fx/status_effect_ghost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_oathbreaker_active:StatusEffectPriority ()
    return 1000
end

--------------------------------------------------------------------------------

function modifier_item_oathbreaker_active:GetEffectName ()
    return "particles/items_fx/ghost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_oathbreaker_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_oathbreaker_active:GetTexture ()
    return "item_oathbreaker"
end

function modifier_item_oathbreaker_active:IsPurgable ()
    return false
end

function modifier_item_oathbreaker_active:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS

    }

    return funcs
end

function modifier_item_oathbreaker_active:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end


function modifier_item_oathbreaker_active:GetModifierMoveSpeedBonus_Percentage (params)
    return self:GetAbility():GetSpecialValueFor("blast_movement_slow") 
end

function modifier_item_oathbreaker_active:GetAbsoluteNoDamagePhysical (params)
    return 1
end

function modifier_item_oathbreaker_active:GetModifierMagicalResistanceBonus (params)
    return -40
end
function item_oathbreaker:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

