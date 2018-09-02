if item_spirit_orb == nil then item_spirit_orb = class({}) end 

LinkLuaModifier ("modifier_item_spirit_orb", "items/item_spirit_orb.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_spirit_orb_active", "items/item_spirit_orb.lua", LUA_MODIFIER_MOTION_NONE)

function item_spirit_orb:GetIntrinsicModifierName()
	return "modifier_item_spirit_orb"
end

if modifier_item_spirit_orb == nil then
	modifier_item_spirit_orb = class({})
end

function modifier_item_spirit_orb:IsHidden()
	return true
end

function modifier_item_spirit_orb:OnCreated(htable)
    if IsServer() then 
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_spirit_orb_active", nil):IncrementStackCount()

        self:GetParent():RemoveItem(self:GetAbility())
    end
end

function modifier_item_spirit_orb:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

if modifier_item_spirit_orb_active == nil then
	modifier_item_spirit_orb_active = class({})
end

function modifier_item_spirit_orb_active:IsHidden()
	return false 
end

function modifier_item_spirit_orb_active:IsPurgable()
	return false 
end

function modifier_item_spirit_orb_active:RemoveOnDeath()
	return false 
end

function modifier_item_spirit_orb_active:OnCreated(htable)
	if IsServer() then 
		self._iHealthRegen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	    self._iManaRegen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")

	    self._iHealthRegen_Stack = self:GetAbility():GetSpecialValueFor("health_regen_per_stack")
	    self._iManaRegen_Stack = self:GetAbility():GetSpecialValueFor("mana_regen_per_stack")

	    self._iHealth = self:GetAbility():GetSpecialValueFor("bonus_health")
	    self._iMana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	end
end

function modifier_item_spirit_orb_active:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_item_spirit_orb_active:GetTexture()
	return "gem"
end

function modifier_item_spirit_orb_active:DeclareFunctions() 
local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }

	return funcs
end

function modifier_item_spirit_orb_active:GetModifierHealthBonus( params )
 	return self._iHealth or 800
end

function modifier_item_spirit_orb_active:GetModifierManaBonus( params )
 	return self._iMana or 800
end

function modifier_item_spirit_orb_active:GetModifierConstantHealthRegen( params )
 	return (self._iHealthRegen or 7) + ((self._iHealthRegen_Stack or 3.0) * self:GetStackCount())
end

function modifier_item_spirit_orb_active:GetModifierConstantManaRegen( params )
 	return (self._iManaRegen or 2) + ((self._iManaRegen_Stack or 0.5) * self:GetStackCount())
end

function modifier_item_spirit_orb_active:OnAbilityExecuted( params )
 	if IsServer() then 
 		local unit = params.unit 
 		if unit ~= self:GetParent() and params.ability ~= nil and params.ability:ProcsMagicStick() == false then 
 			if (unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= 900 then self:IncrementStackCount() 
 				local nFXIndex = ParticleManager:CreateParticle( "particles/items_fx/arcane_boots_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
				ParticleManager:ReleaseParticleIndex(nFXIndex)
 			end 
 		end 
 	end 
end
