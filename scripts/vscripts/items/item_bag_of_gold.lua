if item_bag_of_gold == nil then item_bag_of_gold = class({}) end

function item_bag_of_gold:OnSpellStart ()
    self:GetCaster():ModifyGold (300, true, 0)  
    
    EmitSoundOn("DOTA_Item.Hand_Of_Midas",self:GetCaster())

    local midas_particle = ParticleManager:CreateParticle ("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt (midas_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin (), false)
end
function item_bag_of_gold:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

