loki_invis = class({})

LinkLuaModifier( "modifier_loki_invis", "abilities/loki_invis.lua" ,LUA_MODIFIER_MOTION_NONE )

function loki_invis:OnSpellStart()
  local caster = self:GetCaster()
  EmitSoundOn("Hero_Weaver.Shukuchi", caster)
  local duration = self:GetSpecialValueFor("duration")
  caster:AddNewModifier(caster, self, "modifier_loki_invis", {duration = duration})
  caster:AddNewModifier(caster, self, "modifier_invisible", {duration = duration})
end

modifier_loki_invis = class({})

function modifier_loki_invis:OnCreated()
    self.speed = self:GetAbility():GetSpecialValueFor("speed")
    if IsServer() then
  		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_weaver/weaver_shukuchi.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
      ParticleManager:SetParticleControl( nFXIndex, 1, Vector(50, 50, 0))
      self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_loki_invis:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
    }

    return funcs
end
function modifier_loki_invis:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_MUTED] = true,
  [MODIFIER_STATE_SILENCED] = true,
	}

	return state
end
function modifier_loki_invis:GetModifierMoveSpeed_Max( params )
    return self.speed
end

function modifier_loki_invis:GetModifierMoveSpeed_Limit( params )
    return self.speed
end

function modifier_loki_invis:GetModifierMoveSpeed_Absolute( params )
    return self.speed
end

function modifier_loki_invis:IsHidden()
    return true
end

function loki_invis:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

