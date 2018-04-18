LinkLuaModifier( "item_glove_of_the_creator_modifier", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_glove_of_the_creator_modifier_cast", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )
if item_glove_of_the_creator == nil then
	item_glove_of_the_creator = class({})
end
function item_glove_of_the_creator:GetIntrinsicModifierName()
	return "item_glove_of_the_creator_modifier"
end

function item_glove_of_the_creator:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_NO_TARGET
	return behav
end

function item_glove_of_the_creator:OnSpellStart()
	if IsServer() then
        local caster = self:GetCaster()
        EmitSoundOn("Item.GuardianGreaves.Activate", caster)
        EmitSoundOn("Item.GuardianGreaves.Target", caster)
        local duration = self:GetSpecialValueFor("duration")
        caster:AddNewModifier( self:GetCaster(), self, "item_glove_of_the_creator_modifier_cast", { duration = duration } )
        caster:AddNewModifier( self:GetCaster(), self, "modifier_invulnerable", { duration = duration } )
    end
end
--------------------------------------------------------------------------------
if item_glove_of_the_creator_modifier == nil then
    item_glove_of_the_creator_modifier = class({})
end

function item_glove_of_the_creator_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_glove_of_the_creator_modifier:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_MOVESPEED_MAX,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE

}

return funcs
end

function item_glove_of_the_creator_modifier:GetModifierHealAmplify_Percentage( params )
	return 2
end

function item_glove_of_the_creator_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_glove_of_the_creator_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function item_glove_of_the_creator_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_glove_of_the_creator_modifier:GetModifierMoveSpeedBonus_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_speed" )
end

function item_glove_of_the_creator_modifier:GetModifierMoveSpeedBonus_Percentage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_speed_pers" )
end

function item_glove_of_the_creator_modifier:GetModifierPercentageManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_regen" )
end

function item_glove_of_the_creator_modifier:GetModifierMoveSpeed_Limit( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "speed_border" )
end

function item_glove_of_the_creator_modifier:GetModifierMoveSpeed_Max( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "speed_border" )
end

if item_glove_of_the_creator_modifier_cast == nil then item_glove_of_the_creator_modifier_cast = class({}) end

function item_glove_of_the_creator_modifier_cast:IsHidden()
	return true
end

function item_glove_of_the_creator_modifier_cast:IsPurgable()
	return false
end

function item_glove_of_the_creator_modifier_cast:OnCreated(table)
	if IsServer() then
		local caster = self:GetParent()
		local glove = ParticleManager:CreateParticle("particles/effects/glove.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(glove, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(glove, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(glove, 2, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(glove, 3, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(glove, 4, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(glove, 5, caster:GetAbsOrigin())
		self:AddParticle(glove, false, false, -1, false, false)
	end
end

function item_glove_of_the_creator_modifier_cast:DeclareFunctions() --we want to use these functions in this item
	local funcs = {
	    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_EVENT_ON_ORDER

	}

	return funcs
end
function item_glove_of_the_creator_modifier_cast:OnOrder(args)
  if args.order_type and args.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
        if IsServer() then
            if args.unit == self:GetParent() then 
                local victim_angle = args.target:GetAnglesAsVector()
                local victim_forward_vector = args.target:GetForwardVector()
                local victim_angle_rad = victim_angle.y*math.pi/180
                local victim_position = args.target:GetAbsOrigin()
                local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)

                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start_sparkles.vpcf", PATTACH_CUSTOMORIGIN, nil );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex( nFXIndex );

                self:GetCaster():SetAbsOrigin(attacker_new)
                FindClearSpaceForUnit(self:GetCaster(), attacker_new, true)
                self:GetCaster():SetForwardVector(victim_forward_vector)
            end
        end
    end
end
function item_glove_of_the_creator_modifier_cast:GetAbsoluteNoDamagePhysical( params )
    return 1
end

function item_glove_of_the_creator_modifier_cast:GetModifierMoveSpeed_Absolute()
    return 99999
end

function item_glove_of_the_creator_modifier_cast:GetAbsoluteNoDamageMagical( params )
    return 1
end
function item_glove_of_the_creator_modifier_cast:GetAbsoluteNoDamagePure( params )
    return 1
end

function item_glove_of_the_creator_modifier_cast:GetModifierAttackSpeedBonus_Constant( params )
    return 5000
end

function item_glove_of_the_creator_modifier_cast:GetModifierDamageOutgoing_Percentage( params )
    return 250
end
function item_glove_of_the_creator_modifier_cast:GetModifierMoveSpeed_Limit( params )
    return 99999
end
function item_glove_of_the_creator_modifier_cast:GetModifierMoveSpeed_Max( params )
    return 99999
end

function item_glove_of_the_creator_modifier_cast:CheckState()
	local state = {
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	return state
end

function item_glove_of_the_creator_modifier_cast:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function item_glove_of_the_creator:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

