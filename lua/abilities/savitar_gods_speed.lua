if savitar_gods_speed == nil then savitar_gods_speed = class({}) end
LinkLuaModifier( "modifier_savitar_gods_speed",	"abilities/savitar_gods_speed.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function savitar_gods_speed:GetIntrinsicModifierName()
  return "modifier_savitar_gods_speed"
end

function savitar_gods_speed:OnSpellStart()
	if IsServer() then
		EmitSoundOn("Savitar.Jump", self:GetCaster())

		local vPoint = self:GetCursorPosition()

		ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, self:GetCaster()))

		self:GetCaster():SetAbsOrigin(vPoint)
		FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), false)

		ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, self:GetCaster()))
	end
end

if modifier_savitar_gods_speed == nil then
	modifier_savitar_gods_speed = class ( {})
end

function modifier_savitar_gods_speed:IsHidden ()
  return true
end

function modifier_savitar_gods_speed:IsPurgable()
  return false
end

function modifier_savitar_gods_speed:DeclareFunctions ()
  local funcs = {
    MODIFIER_EVENT_ON_ORDER
  }

  return funcs
end

function modifier_savitar_gods_speed:OnOrder (params)
  if IsServer () then
    if params.unit == self:GetParent() and (params.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or params.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET) then
      if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
		self:GetAbility():PayManaCost()
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))

		EmitSoundOn("Savitar.Jump", self:GetParent())
		local vPoint = params.new_pos

		ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, self:GetParent()))

		self:GetParent():SetAbsOrigin(vPoint)

		FindClearSpaceForUnit(self:GetParent(), vPoint, true)
		ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, self:GetParent()))
      end
    end
  end

  return 0
end