modifier_spell_amp= class({})

function modifier_spell_amp:IsPurgable() return false end
function modifier_spell_amp:IsHidden()	return true end
function modifier_spell_amp:RemoveOnDeath() return false end

function modifier_spell_amp:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end


function modifier_spell_amp:GetModifierSpellAmplify_Percentage() return self:GetStackCount() * 0.3 end

function modifier_spell_amp:OnTakeDamage(params)
     if IsServer() then
          if params.attacker == self:GetParent() and params.inflictor ~= nil and params.inflictor:IsItem() == false then
			self:SetStackCount(self:GetStackCount() + 1)
		end
     end 
end
