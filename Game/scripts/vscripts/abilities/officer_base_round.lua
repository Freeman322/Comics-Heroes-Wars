LinkLuaModifier("modifier_counter", "modifiers/modifier_counter.lua", 0)

officer_base_round = class({})

function officer_base_round:GetIntrinsicModifierName()
	return "modifier_counter"
end

local MAX_ROUNDS_COUNT = 15

function officer_base_round:OnSpellStart( )
     if IsServer() then
          if self:GetCaster().i_mRounds < MAX_ROUNDS_COUNT or self:GetCaster().m_hOwner:HasTalent("special_bonus_unique_officer_4") then
               self:GetCaster().i_mRounds = self:GetCaster().i_mRounds + 1

               self:GetCaster():FindModifierByName("modifier_counter"):SetStackCount(self:GetCaster().i_mRounds)
          end 
     end
end
