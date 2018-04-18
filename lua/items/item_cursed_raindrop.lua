LinkLuaModifier( "modifier_item_cursed_raindrop", "items/item_cursed_raindrop.lua", LUA_MODIFIER_MOTION_NONE )
if item_cursed_raindrop == nil then
	item_cursed_raindrop = class({})
end

function item_cursed_raindrop:GetIntrinsicModifierName() 
	return "modifier_item_cursed_raindrop"
end

if modifier_item_cursed_raindrop == nil then
	modifier_item_cursed_raindrop = class({})
end

function modifier_item_cursed_raindrop:IsHidden()
	return true
end

function modifier_item_cursed_raindrop:DeclareFunctions() --we want to use these functions in this item
	local funcs = {
	    MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_item_cursed_raindrop:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
            local damage_type = params.damage_type
            if self:GetAbility():IsCooldownReady() then
	           	if damage_type == 2 then
	           		self:GetParent():Heal(150, self:GetParent()) 
	           		self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() - 1) 
	           		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel())) 
	           		local particle = "particles/items3_fx/mango_active.vpcf"
					local fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
					ParticleManager:SetParticleControl(fx, 0, self:GetParent():GetAbsOrigin())
	           		if self:GetAbility():GetCurrentCharges() == 0 then
	           			self:GetAbility():RemoveSelf() 
	           		end
	          	end
	        end
        end
    end
end

function item_cursed_raindrop:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

