palpatine_force = class({})

LinkLuaModifier( "modifier_generic_charges", "modifiers/modifier_generic_charges.lua", LUA_MODIFIER_MOTION_NONE )

-- Passive Modifier
function palpatine_force:GetIntrinsicModifierName()
    return "modifier_generic_charges"
end

function palpatine_force:OnSpellStart ()
    if IsServer() then
        self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_item_forcestaff_active", { duration = 1.5, push_length = self:GetSpecialValueFor("push_length") } )

        EmitSoundOn ("DOTA_Item.ForceStaff.Activate",self:GetCaster ())
    end
end
