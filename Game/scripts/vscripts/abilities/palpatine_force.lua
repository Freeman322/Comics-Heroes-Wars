palpatine_force = class({})

LinkLuaModifier( "modifier_charges", "modifiers/modifier_charges.lua", LUA_MODIFIER_MOTION_NONE )

function palpatine_force:OnUpgrade()
    if IsServer() then
        if not self:GetCaster():HasModifier("modifier_charges") then
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_charges", nil)
        end
    end
end

function palpatine_force:OnSpellStart ()
    if IsServer() then
        self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_item_forcestaff_active", { duration = 1.5, push_length = self:GetSpecialValueFor("push_length") } )

        EmitSoundOn ("DOTA_Item.ForceStaff.Activate",self:GetCaster ())
    end
end
