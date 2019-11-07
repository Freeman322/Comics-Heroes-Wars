if chaos_king_static_shield == nil then chaos_king_static_shield = class({}) end

LinkLuaModifier ("modifier_chaos_king_static_shield", "abilities/chaos_king_static_shield.lua", LUA_MODIFIER_MOTION_NONE )

function chaos_king_static_shield:GetIntrinsicModifierName ()
    return "modifier_chaos_king_static_shield"
end

if modifier_chaos_king_static_shield == nil then modifier_chaos_king_static_shield = class({}) end

function modifier_chaos_king_static_shield:IsPurgable() return false end
function modifier_chaos_king_static_shield:IsHidden() return true end


function modifier_chaos_king_static_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_chaos_king_static_shield:GetModifierEvasion_Constant( params )
    if IsServer() then
        if self:GetAbility():IsCooldownReady() and self:GetParent() == params.target then
            self:GetAbility():UseResources(false, false, true)

            EmitSoundOn( "Hero_Invoker.ColdSnap.Cast", params.attacker )
            EmitSoundOn( "Hero_Invoker.ColdSnap", params.attacker )
            
            params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = 0.75})
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_clinkz_strafe", {duration = self:GetAbility():GetSpecialValueFor("duration")})

            if self:GetCaster():HasTalent("special_bonus_unique_chaos_king_4") then
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_spell_immunity", {duration = self:GetAbility():GetSpecialValueFor("duration")})
            end 
            
            return 100
        end 
    end 

    return 0
end
