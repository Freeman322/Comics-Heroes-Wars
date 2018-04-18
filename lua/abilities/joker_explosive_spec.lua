joker_explosive_spec = class({})

function joker_explosive_spec:GetIntrinsicModifierName()
	return "modifier_item_aether_lens"
end

function joker_explosive_spec:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

