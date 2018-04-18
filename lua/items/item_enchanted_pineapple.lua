if item_enchanted_pineapple == nil then
	item_enchanted_pineapple = class({})
end
function item_enchanted_pineapple:OnSpellStart()
	local caster = self:GetCursorTarget()
  local duration = self:GetSpecialValueFor("duration")
  local hp_restore = self:GetSpecialValueFor("hp_restore")
  local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"

  local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(lifesteal_fx, 0, caster:GetAbsOrigin())
  caster:AddNewModifier(caster, self, "modifier_black_king_bar_immune", {duration = duration})
  EmitSoundOn("DOTA_Item.Mango.Activate", caster)
  caster:Heal(hp_restore, self)
  self:RemoveSelf()
end

function item_enchanted_pineapple:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

