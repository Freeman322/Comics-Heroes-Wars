if item_chaotic_axe == nil then 
	item_chaotic_axe = class({})
end
LinkLuaModifier( "modifier_item_chaotic_axe_caster", "items/item_chaotic_axe.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_chaotic_axe_target", "items/item_chaotic_axe.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_chaotic_axe", "items/item_chaotic_axe.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_chaotic_axe:CastFilterResultTarget( hTarget )
	if IsServer() then

		if hTarget ~= nil and hTarget:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function item_chaotic_axe:GetIntrinsicModifierName()
	return "modifier_item_chaotic_axe"
end

function item_chaotic_axe:OnSpellStart()
	self.hTarget = self:GetCursorTarget()
	if self.hTarget ~= nil then
		if ( not self.hTarget:TriggerSpellAbsorb( self ) ) then
			local duration = self:GetSpecialValueFor( "corruption_duration" )
			self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_chaotic_axe_caster", { duration = duration } )
			self.hTarget:AddNewModifier( self:GetCaster(), self, "modifier_item_chaotic_axe_target", { duration = duration } )
			EmitSoundOn( "Ability.static.start", self.hTarget )
		end
	end
end

function item_chaotic_axe:GetAbilityTarget()
	return self.hTarget
end

if modifier_item_chaotic_axe_caster == nil then
	modifier_item_chaotic_axe_caster = class({})
end

function modifier_item_chaotic_axe_caster:IsHidden()
	return true
end

function modifier_item_chaotic_axe_caster:OnCreated(table)
	if IsServer() then
		local hTarget = self:GetAbility():GetCursorTarget()
		self:StartIntervalThink(0.25)
		self:OnIntervalThink()
		local nFXIndex = ParticleManager:CreateParticle( "particles/chaotic_axe.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:SetParticleControl(nFXIndex, 6, Vector(4, 1, 1))
		self:AddParticle(nFXIndex, false, false, -1, false, false)
		self.duration = self:GetAbility():GetSpecialValueFor( "corruption_duration" )
		StartSoundEvent("Ability.static.loop", self:GetParent())
	end
end

function modifier_item_chaotic_axe_caster:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		StopSoundEvent("Ability.static.loop", caster)
		EmitSoundOn("Ability.static.end", caster)
	end
end

function modifier_item_chaotic_axe_caster:OnIntervalThink()
	if IsServer() then
		local hTarget = self:GetAbility():GetAbilityTarget()
		self:SetStackCount(self:GetStackCount() + 1)
		if hTarget:HasModifier("modifier_item_chaotic_axe_target") then
			hTarget:FindModifierByName("modifier_item_chaotic_axe_target"):SetStackCount(hTarget:FindModifierByName("modifier_item_chaotic_axe_target"):GetStackCount() + 1)
		end
	end
end

function modifier_item_chaotic_axe_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_item_chaotic_axe_caster:IsPurgable()
	return false
end

function modifier_item_chaotic_axe_caster:GetModifierMoveSpeedBonus_Constant( params )
	return 10*self:GetStackCount()
end

function modifier_item_chaotic_axe_caster:GetModifierAttackSpeedBonus_Constant( params )
	return 10*self:GetStackCount()
end

function modifier_item_chaotic_axe_caster:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

if modifier_item_chaotic_axe_target == nil then
	modifier_item_chaotic_axe_target = class({})
end

function modifier_item_chaotic_axe_target:IsPurgable()
	return false
end

function modifier_item_chaotic_axe_target:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_item_chaotic_axe_target:GetModifierMoveSpeedBonus_Constant( params )
	return -10*self:GetStackCount()
end

function modifier_item_chaotic_axe_target:GetModifierAttackSpeedBonus_Constant( params )
	return -10*self:GetStackCount()
end

if modifier_item_chaotic_axe == nil then
	modifier_item_chaotic_axe = class({})
end

function modifier_item_chaotic_axe:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_chaotic_axe:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}

return funcs
end

function modifier_item_chaotic_axe:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_chaotic_axe:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_chaotic_axe:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_chaotic_axe:GetModifierPhysicalArmorBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_armor" )
end

function modifier_item_chaotic_axe:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end

function modifier_item_chaotic_axe:OnAttackLanded( params )
    if params.attacker == self:GetParent() then
    	self:GetParent():Heal(params.damage*(self:GetAbility():GetSpecialValueFor("life_steal")/100), self:GetAbility())
    	local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
		local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent():GetAbsOrigin())
    end
end

function item_chaotic_axe:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

