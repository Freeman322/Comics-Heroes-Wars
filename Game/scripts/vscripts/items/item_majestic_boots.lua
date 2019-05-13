if not item_majestic_boots then item_majestic_boots = class({}) end 

LinkLuaModifier ("modifier_item_majestic_staff_active", "items/item_majestic_staff.lua", LUA_MODIFIER_MOTION_NONE)

function item_majestic_boots:GetAOERadius() return self:GetSpecialValueFor( "active_radius" ) end
function item_majestic_boots:GetIntrinsicModifierName() return "modifier_item_guardian_greaves" end
--------------------------------------------------------------------------------

function item_majestic_boots:OnSpellStart()
    if IsServer() then 
        local radius = self:GetSpecialValueFor("active_radius") 
        local duration = self:GetSpecialValueFor("duration")
        local target = self:GetCursorPosition()

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target, self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, 0, false )
        if #units > 0 then
            for _, unit in pairs(units) do
                unit:AddNewModifier( self:GetCaster(), self, "modifier_item_majestic_staff_active", { duration = duration } )
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_marker.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl(nFXIndex, 0, target)
        ParticleManager:SetParticleControl(nFXIndex, 2, Vector(radius, radius, 0))
        ParticleManager:SetParticleControl(nFXIndex, 4, target)
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Item.Majestic_staff.Cast", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    end 
end
