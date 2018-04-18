if modifier_deadpool == nil then modifier_deadpool = class({}) end

function modifier_deadpool:IsHidden()
	return false
end

function modifier_deadpool:IsPurgable()
	return false
end

function modifier_deadpool:RemoveOnDeath()
	return false
end

function modifier_deadpool:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_deadpool:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_HERO_KILLED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end

function modifier_deadpool:OnHeroKilled(params)
	if params.target:GetTeam() ~= self:GetParent():GetTeam() then
		if params.attacker == self:GetParent() then
			self:SetStackCount(self:GetStackCount() + 1)
		end
	end
end
function modifier_deadpool:GetAttackSound( params )
    return "Hero_EmberSpirit.Attack"
end
