LinkLuaModifier("modifier_katana_soul_stole", "abilities/katana_soul_stole.lua" , 0)
LinkLuaModifier("modifier_corruption", "abilities/katana_soul_stole.lua" , 0)

katana_soul_stole = class({})

function katana_soul_stole:GetIntrinsicModifierName() return "modifier_katana_soul_stole" end

modifier_katana_soul_stole = class({})

function modifier_katana_soul_stole:IsPurgable()	return false end
function modifier_katana_soul_stole:IsHidden()	return false end
function modifier_katana_soul_stole:RemoveOnDeath() return false end
function modifier_katana_soul_stole:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_EVENT_ON_HERO_KILLED,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_katana_soul_stole:OnAttackLanded (params)
	if params.attacker == self:GetParent() then
		local hTarget = params.target
		hTarget:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_corruption", {duration = 7})
	end
end

if modifier_corruption == nil then modifier_corruption = class({}) end

function modifier_corruption:IsHidden()
    return false
end

function modifier_corruption:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_corruption:GetModifierPhysicalArmorBonus( params )
    return self:GetAbility():GetSpecialValueFor("corruption_armor")
end

function modifier_katana_soul_stole:GetModifierBaseAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_base_damage") end
function modifier_katana_soul_stole:GetModifierBonusStats_Agility() return self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("bonus_agility") or 1) end
function modifier_katana_soul_stole:GetModifierPreAttack_BonusDamage() return self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("bonus_damage") or 1) end
function modifier_katana_soul_stole:OnHeroKilled(params) 
	if params.target:GetTeam() ~= self:GetParent():GetTeam() then
		if params.attacker == self:GetParent() then
			self:SetStackCount(self:GetStackCount() + 1)
		end
	end
end
