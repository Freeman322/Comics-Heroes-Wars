LinkLuaModifier("modifier_draks_flesh_heap", "abilities/draks_flesh_heap.lua" , 0)

draks_flesh_heap = class({})

function draks_flesh_heap:GetIntrinsicModifierName() return "modifier_draks_flesh_heap" end

modifier_draks_flesh_heap = class({})

function modifier_draks_flesh_heap:IsPurgable()	return false end
function modifier_draks_flesh_heap:IsHidden()	return false end
function modifier_draks_flesh_heap:RemoveOnDeath() return false end
function modifier_draks_flesh_heap:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_HERO_KILLED
	}
end


function modifier_draks_flesh_heap:GetModifierBonusStats_Strength()	return self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("strength_buff_amount") * (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_draks_flesh_heap") or 1)) end
function modifier_draks_flesh_heap:GetModifierConstantHealthRegen()	return self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("health_regen") * (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_draks_flesh_heap") or 1)) end
function modifier_draks_flesh_heap:OnHeroKilled(params)
	if IsServer() then
		if params.target:GetTeam() ~= self:GetCaster():GetTeam() then 
			self:SetStackCount(self:GetStackCount() + 1)
		end
	end
end
