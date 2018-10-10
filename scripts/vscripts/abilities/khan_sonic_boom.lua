khan_sonic_boom = class({})

function khan_sonic_boom:OnSpellStart ()
    self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_item_forcestaff_active", { duration = 1.5, push_length = self:GetSpecialValueFor("push_length") } )
    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "nemesis_custom") then
		EmitSoundOn( "Khan.Nemesis.Rush" , self:GetCaster() )
	else 
		EmitSoundOn ("DOTA_Item.ForceStaff.Activate",self:GetCaster ())
	end 
end

function khan_sonic_boom:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

