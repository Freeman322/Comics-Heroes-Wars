function BladeActive (keys)
	local caster = keys.caster
	local target = keys.caster
	local ability = keys.ability
	local modifier_as = keys.modifier_as
	local modifier_count = target:GetModifierStackCount (modifier_as, target)
	caster:SetModifierStackCount (modifier_as, ability, modifier_count + 1)
	ability:ApplyDataDrivenModifier (caster, target, modifier_as, {})
	if modifier_count >= 4 then
		caster:SetModifierStackCount (modifier_as, ability, modifier_count)
		return nil
	else
		target:EmitSound ("Item.MoonShard.Consume")
		caster:RemoveItem (ability)
	end
end


function item_ethernal_radiance_blade:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

