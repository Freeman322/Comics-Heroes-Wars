LinkLuaModifier ("modifier_item_rapier_ethereal", "items/item_rapier_ethereal.lua", LUA_MODIFIER_MOTION_NONE)

if item_rapier_ethereal == nil then
	item_rapier_ethereal = class({})
end

function item_rapier_ethereal:OnOwnerDied()
	if IsServer() then
		local itemName = tostring(self:GetAbilityName())
		if self:GetCaster():IsHero() or self:GetCaster():HasInventory() then
			if not self:GetCaster():IsReincarnating() then
				local newItem = CreateItem(itemName, nil, nil)
				CreateItemOnPositionSync(self:GetCaster():GetOrigin(), newItem)
				self:GetCaster():RemoveItem(self)
			end
		end
	end
end

function item_rapier_ethereal:GetIntrinsicModifierName()
	return "modifier_item_rapier_ethereal"
end

if modifier_item_rapier_ethereal == nil then
	modifier_item_rapier_ethereal = class({})
end

function modifier_item_rapier_ethereal:IsHidden() return true end
function modifier_item_rapier_ethereal:IsPurgable() return false end

function modifier_item_rapier_ethereal:GetEffectName()
	return "particles/hw_fx/cursed_rapier.vpcf"
end

function modifier_item_rapier_ethereal:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_rapier_ethereal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE
	}
	return funcs
end

function modifier_item_rapier_ethereal:GetModifierSpellAmplify_PercentageUnique()
	if self:GetParent():GetUnitName() == "npc_dota_hero_oracle" or self:GetParent():GetUnitName() == "npc_dota_hero_zuus" then return 0 end
	return 100
end

function modifier_item_rapier_ethereal:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end


function item_rapier_ethereal:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

