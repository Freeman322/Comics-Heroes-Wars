if item_bfury_lg == nil then item_bfury_lg = class({}) end

LinkLuaModifier("modifier_item_bfury_lg", "items/item_bfury_lg.lua", LUA_MODIFIER_MOTION_NONE)

function item_bfury_lg:OnOwnerDied()
 if IsServer() then
  	local itemName = tostring(self:GetAbilityName())
  	if self:GetCaster():IsHero() or self:GetCaster():HasInventory() then
      local newItem = CreateItem(itemName, nil, nil)
      CreateItemOnPositionSync(self:GetCaster():GetOrigin(), newItem)
      self:GetCaster():RemoveItem(self)
    end
  end
end

function item_bfury_lg:GetIntrinsicModifierName()
   return "modifier_item_bfury_lg"
end

if modifier_item_bfury_lg == nil then modifier_item_bfury_lg = class({}) end


function modifier_item_bfury_lg:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_EVENT_ON_ATTACK_LANDED
    }
	return funcs
end

function modifier_item_bfury_lg:IsHidden()
	return true
end

function modifier_item_bfury_lg:IsPurgable()
	return false
end

function modifier_item_bfury_lg:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_bfury_lg:GetModifierPreAttack_BonusDamage()
	return 500
end

function modifier_item_bfury_lg:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end
      if self:GetParent():IsRangedAttacker() then
				return 0
			end
			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local cleaveDamage = ( self:GetAbility():GetSpecialValueFor("cleave") * params.damage ) / 100.0
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, 250, 250, 250, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
			end
		end
	end

	return 0
end

function item_bfury_lg:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

