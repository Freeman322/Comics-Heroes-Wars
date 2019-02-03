
item_glimmerdark_shield = class({})
LinkLuaModifier( "modifier_item_glimmerdark_shield",  "items/item_glimmerdark_shield.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_item_glimmerdark_shield_prism",  "items/item_glimmerdark_shield.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function item_glimmerdark_shield:OnSpellStart()
	self.prism_duration = self:GetSpecialValueFor( "prism_duration" )

	if IsServer() then
		local hCaster = self:GetCaster()
		hCaster:AddNewModifier( hCaster, self, "modifier_item_glimmerdark_shield_prism", { duration = self.prism_duration } )

		EmitSoundOn( "DOTA_Item.ComboBreaker", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function item_glimmerdark_shield:GetIntrinsicModifierName()
	return "modifier_item_glimmerdark_shield"
end

--------------------------------------------------------------------------------

function item_glimmerdark_shield:Spawn()
	
end


modifier_item_glimmerdark_shield = class({})

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:OnCreated( kv )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "all_stats" )
	self.bonus_agility = self:GetAbility():GetSpecialValueFor( "all_stats" )
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor( "all_stats" )
	self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.bonus_heal = self:GetAbility():GetSpecialValueFor( "bonus_heal" )
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE 
	}
	return funcs
end

--------------------------------------------------------------------------------


function modifier_item_glimmerdark_shield:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end 

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:GetModifierBonusStats_Agility( params )
	return self.bonus_agility
end 

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:GetModifierBonusStats_Intellect( params )
	return self.bonus_intellect
end 

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end 

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:GetModifierHealthBonus( params )
	return self.bonus_health
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:GetModifierHPRegenAmplify_Percentage( params )
	return self.bonus_heal
end


modifier_item_glimmerdark_shield_prism = class({})

--------------------------------------------------------------------------------
function modifier_item_glimmerdark_shield_prism:IsPurgable()
	return false
end

function modifier_item_glimmerdark_shield_prism:GetEffectName()
	return "particles/units/heroes/hero_centaur/centaur_return_buff.vpcf"
end

function modifier_item_glimmerdark_shield_prism:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_glimmerdark_shield_prism:IsPurgable()
	return false
end


function modifier_item_glimmerdark_shield_prism:OnCreated(params)
	if IsServer() then 
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_item_glimmerdark_shield_prism:OnIntervalThink()
	if IsServer() then 
		self:GetParent():Purge(false, true, false, true, true)
	end
end

function modifier_item_glimmerdark_shield_prism:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATUS_RESISTANCE
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield_prism:GetModifierStatusResistance( params )
	return self:GetAbility():GetSpecialValueFor("prism_status_resist")
end
