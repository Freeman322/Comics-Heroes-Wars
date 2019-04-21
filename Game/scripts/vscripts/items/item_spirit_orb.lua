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
 	return 800
end

function modifier_item_spirit_orb_active:GetModifierManaBonus( params )
 	return 800
end

function modifier_item_spirit_orb_active:GetModifierConstantHealthRegen( params )
 	return 7 + (0.25 * self:GetStackCount())
end

function modifier_item_spirit_orb_active:GetModifierConstantManaRegen( params )
 	return 2 + (0.06 * self:GetStackCount())
end

function modifier_item_spirit_orb_active:OnAbilityExecuted( params )
 	if IsServer() then 
 		local unit = params.unit 
 		if unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and params.ability ~= nil then
 			if params.ability:GetCooldown(params.ability:GetLevel()) > 0 then  
	 			if (unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= 21215 then self:IncrementStackCount() 
	 				local nFXIndex = ParticleManager:CreateParticle( "particles/items_fx/arcane_boots_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
					ParticleManager:ReleaseParticleIndex(nFXIndex)
	 			end 
	 		end
 		end 
 	end 
end
