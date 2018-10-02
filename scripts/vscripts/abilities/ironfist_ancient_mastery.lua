if ironfist_ancient_mastery == nil then ironfist_ancient_mastery = class({}) end 

LinkLuaModifier ("modifier_ironfist_ancient_mastery", "abilities/ironfist_ancient_mastery.lua", LUA_MODIFIER_MOTION_NONE)

function ironfist_ancient_mastery:GetIntrinsicModifierName ()
    return "modifier_ironfist_ancient_mastery"
end

if modifier_ironfist_ancient_mastery == nil then modifier_ironfist_ancient_mastery = class({}) end

function modifier_ironfist_ancient_mastery:IsHidden ()
    return false
end

function modifier_ironfist_ancient_mastery:AllowIllusionDuplicate()
    return false
end

function modifier_ironfist_ancient_mastery:IsPurgable()
    return false
end

function modifier_ironfist_ancient_mastery:RemoveOnDeath ()
    return false
end

function modifier_ironfist_ancient_mastery:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_HERO_KILLED,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_ironfist_ancient_mastery:GetModifierPreAttack_BonusDamage( params )
    return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("damage")
end
function modifier_ironfist_ancient_mastery:GetModifierSpellAmplify_Percentage( params )
    return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("spell_damage")
end

function modifier_ironfist_ancient_mastery:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_ironfist_ancient_mastery:OnHeroKilled(params)
	if params.target:GetTeam() ~= self:GetParent():GetTeam() then
		if params.attacker == self:GetParent() then
			self:SetStackCount(self:GetStackCount() + 1)
		end
	end
end

function modifier_ironfist_ancient_mastery:OnDeath(params)
    if params.unit == self:GetParent() then
        self:SetStackCount(self:GetStackCount() + 1)
    end
end
function ironfist_ancient_mastery:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

