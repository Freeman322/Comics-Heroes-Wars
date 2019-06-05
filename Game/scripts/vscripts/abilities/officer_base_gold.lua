officer_base_gold = class({})

local MAX_GOLD_COUNT = 100

function officer_base_gold:OnSpellStart( )
     if IsServer() then
          EmitSoundOn("DOTA_Item.Hand_Of_Midas", self:GetCaster())

          self:GetCaster().i_Hero:ModifyGold(MAX_GOLD_COUNT, true, 0)
     end
end
