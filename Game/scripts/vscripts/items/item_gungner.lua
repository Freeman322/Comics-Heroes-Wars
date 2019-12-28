LinkLuaModifier ("modifier_item_gungner", "items/item_gungner.lua", LUA_MODIFIER_MOTION_NONE)

if item_gungner == nil then
	item_gungner = class({})
end

function item_gungner:GetIntrinsicModifierName()
	return "modifier_item_gungner"
end

function item_gungner:OnSpellStart() 
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			local primary = self:GetCaster():GetPrimaryAttribute() ----Атрибут берется не из воздуха или вакуума, а у кастера
			local attrMult = 0 ----пока 0
			---ну а дальше простейший логический бранч
			
			if primary == 0 then
				attrMult = self:GetCaster():GetStrength()
			elseif primary == 1 then
				attrMult = self:GetCaster():GetAgility()
			elseif primary == 2 then
				attrMult = self:GetCaster():GetIntellect()
			end			
			----attrMult теперь содержит колличество основного аттрибута. Ничего сложного 
			
			local flDamage = self:GetSpecialValueFor("ability_damage") + attrMult * 3.5 
			
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = flDamage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}
			
			ApplyDamage( damage )
			
			EmitSoundOn( "Hero_Abaddon.DeathCoil.Cast", self:GetCaster() )
			EmitSoundOn( "Hero_Abaddon.DeathCoil.Target", hTarget )
			
	   	    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
			ParticleManager:ReleaseParticleIndex( nFXIndex );
			hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("ability_stun_duration")})
		end
	end
end

if modifier_item_gungner == nil then
	modifier_item_gungner = class({})
end

function modifier_item_gungner:IsHidden()
	return true
end

function modifier_item_gungner:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

	return funcs
end

function modifier_item_gungner:CheckState()
	local state = {
	[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end

function modifier_item_gungner:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_gungner:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_gungner:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_gungner:GetModifierAttackRangeBonus( params )
    local hAbility = self:GetAbility()
    if self:GetParent():IsRangedAttacker() then
 	    return hAbility:GetSpecialValueFor( "bonus_attack_range" )
 	else
 		return 0
 	end
end

function modifier_item_gungner:GetModifierAttackSpeedBonus_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_attack_speed" )
end
function item_gungner:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  
    end 

