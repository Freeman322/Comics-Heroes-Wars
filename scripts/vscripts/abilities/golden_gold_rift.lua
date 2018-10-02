golden_gold_rift = class({})

function golden_gold_rift:OnSpellStart()
	local caster = self:GetCaster()

  caster:SetAbsOrigin(caster:GetAbsOrigin() + caster:GetForwardVector() * self:GetSpecialValueFor("range"))
  EmitSoundOn("Hero_Dark_Seer.Surge", caster)

	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
end

function golden_gold_rift:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

