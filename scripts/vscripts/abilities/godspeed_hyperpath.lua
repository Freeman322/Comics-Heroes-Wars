if not godspeed_hyperpath then godspeed_hyperpath = class({}) end
function godspeed_hyperpath:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
LinkLuaModifier ("modifier_godspeed_hyperpath", "abilities/godspeed_hyperpath.lua", LUA_MODIFIER_MOTION_NONE)

function godspeed_hyperpath:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_godspeed_hyperpath", {duration = self:GetSpecialValueFor("duration")})
    end
end

if not modifier_godspeed_hyperpath then modifier_godspeed_hyperpath = class({}) end

function modifier_godspeed_hyperpath:IsPurgable()
    return false
end

function modifier_godspeed_hyperpath:OnCreated(kv)
    if IsServer() then
      EmitSoundOn("Hero_Silencer.LastWord.Target", self:GetParent())
    end
end


function modifier_godspeed_hyperpath:GetStatusEffectName()
	return "particles/status_fx/status_effect_guardian_angel.vpcf"
end

function modifier_godspeed_hyperpath:StatusEffectPriority()
	return 1000
end

function modifier_godspeed_hyperpath:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		 MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}
	return funcs
end

function modifier_godspeed_hyperpath:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("speed_bonus")
end

function modifier_godspeed_hyperpath:GetAbsoluteNoDamagePhysical( params )
    return 1
end

function modifier_godspeed_hyperpath:GetAbsoluteNoDamageMagical( params )
    return 1
end

function modifier_godspeed_hyperpath:GetAbsoluteNoDamagePure( params )
    return 1
end