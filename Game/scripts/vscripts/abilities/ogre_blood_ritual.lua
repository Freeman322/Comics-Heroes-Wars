LinkLuaModifier("modifier_ogre_blood_ritual", "abilities/ogre_blood_ritual.lua" , 0)

ogre_blood_ritual = class({})

function ogre_blood_ritual:GetIntrinsicModifierName() return "modifier_ogre_blood_ritual" end

modifier_ogre_blood_ritual= class({})

function modifier_ogre_blood_ritual:IsPurgable()	return false end
function modifier_ogre_blood_ritual:IsHidden()	return false end
function modifier_ogre_blood_ritual:RemoveOnDeath() return false end
function modifier_ogre_blood_ritual:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_HERO_KILLED
	}
end


function modifier_ogre_blood_ritual:GetModifierSpellAmplify_Percentage() return self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("amp") or 1) end
function modifier_ogre_blood_ritual:OnHeroKilled(params)
	if params.target:GetTeam() ~= self:GetParent():GetTeam() then
		if params.attacker == self:GetParent() then
			self:SetStackCount(self:GetStackCount() + 1)
		end
	end
end
