LinkLuaModifier ("modifier_wolverine_passive_rage", "abilities/wolverine_passive_rage.lua", LUA_MODIFIER_MOTION_NONE)

wolverine_passive_rage = class ( {})

function wolverine_passive_rage:GetIntrinsicModifierName(  )
    return "modifier_wolverine_passive_rage"
end

modifier_wolverine_passive_rage = class({})

function modifier_wolverine_passive_rage:IsPurgable(  )
  return false
end

function modifier_wolverine_passive_rage:IsHidden()
  return false
end


function modifier_wolverine_passive_rage:RemoveOnDeath()
  return false
end

function modifier_wolverine_passive_rage:OnCreated( kv )
	if IsServer() then
	    local regen = (self:GetAbility():GetSpecialValueFor( "regen" )/100)*self:GetParent():GetMaxHealth()
	  	local regen_2 = self:GetAbility():GetSpecialValueFor( "regen_per_damage" )*self:GetStackCount()
	  	self.regen = regen_2 + regen
	end
end

--------------------------------------------------------------------------------

function modifier_wolverine_passive_rage:OnRefresh( kv )
	if IsServer() then
		local regen = (self:GetAbility():GetSpecialValueFor( "regen" )/100)*self:GetParent():GetMaxHealth()
	  	local regen_2 = self:GetAbility():GetSpecialValueFor( "regen_per_damage" )*self:GetStackCount()
	  	self.regen = regen_2 + regen
	end
end

--------------------------------------------------------------------------------

function modifier_wolverine_passive_rage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_HERO_KILLED,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_wolverine_passive_rage:GetModifierPhysicalArmorBonus( params )
	return self:GetAbility():GetSpecialValueFor("armor")
end

function modifier_wolverine_passive_rage:GetModifierConstantHealthRegen( params )
	return self.regen
end


function modifier_wolverine_passive_rage:OnHeroKilled(params)
    if IsServer () then
		if self:GetParent() == params.attacker then
			local target = params.target
			self:SetStackCount(self:GetStackCount() + 1)
			self:ForceRefresh()
		end
    end

    return 0
end

function wolverine_passive_rage:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

