if not tribunal_immortal_judje then tribunal_immortal_judje = class({}) end
function tribunal_immortal_judje:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
LinkLuaModifier ("modifier_tribunal_immortal_judje", "abilities/tribunal_immortal_judje.lua", LUA_MODIFIER_MOTION_NONE)

function tribunal_immortal_judje:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tribunal_immortal_judje", {duration = self:GetSpecialValueFor("duration")})
    end
end

if not modifier_tribunal_immortal_judje then modifier_tribunal_immortal_judje = class({}) end

function modifier_tribunal_immortal_judje:IsPurgable()
    return false
end


function modifier_tribunal_immortal_judje:CheckState()
	local state = {
    	[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}
	return state
end

function modifier_tribunal_immortal_judje:GetStatusEffectName()
	return "particles/status_fx/status_effect_guardian_angel.vpcf"
end

function modifier_tribunal_immortal_judje:StatusEffectPriority()
	return 1000
end
