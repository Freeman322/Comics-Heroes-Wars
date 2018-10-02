draks_flesh_heap = class({})
LinkLuaModifier( "modifier_draks_flesh_heap", "abilities/draks_flesh_heap.lua" , LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function draks_flesh_heap:GetIntrinsicModifierName()
	return "modifier_draks_flesh_heap"
end

modifier_draks_flesh_heap = class({})


function modifier_draks_flesh_heap:IsPurgable()
	return false
end

function modifier_draks_flesh_heap:IsHidden()
	return false
end

function modifier_draks_flesh_heap:RemoveOnDeath()
	return false
end


function modifier_draks_flesh_heap:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_HERO_KILLED
	}

	return funcs
end


function modifier_draks_flesh_heap:GetModifierBonusStats_Strength( params )
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("strength_buff_amount")
end

function modifier_draks_flesh_heap:GetModifierConstantHealthRegen( params )
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("health_regen")
end

function modifier_draks_flesh_heap:OnHeroKilled(params)
	if params.target:GetTeam() ~= self:GetParent():GetTeam() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end

function draks_flesh_heap:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

