LinkLuaModifier ("modifier_tribunal_immortal_judje", "abilities/tribunal_immortal_judje.lua", LUA_MODIFIER_MOTION_NONE)

tribunal_immortal_judje = class({})

function tribunal_immortal_judje:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tribunal_immortal_judje", {duration = self:GetSpecialValueFor("duration")})
        self:GetCaster():EmitSound("Hero_Omniknight.GuardianAngel.Cast")
    end
end

modifier_tribunal_immortal_judje = class({})

function modifier_tribunal_immortal_judje:IsPurgable() return false end
function modifier_tribunal_immortal_judje:DeclareFunctions() return {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL} end
function modifier_tribunal_immortal_judje:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_tribunal_immortal_judje:GetEffectName() return "particles/econ/items/omniknight/omni_ti8_head/omniknight_repel_buff_ti8.vpcf" end
function modifier_tribunal_immortal_judje:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_tribunal_immortal_judje:GetStatusEffectName()	return "particles/status_fx/status_effect_repel.vpcf" end
function modifier_tribunal_immortal_judje:StatusEffectPriority() return 1000 end
