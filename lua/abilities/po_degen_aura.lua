LinkLuaModifier ("modifier_po_degen_aura", "abilities/po_degen_aura.lua", LUA_MODIFIER_MOTION_NONE)

if po_degen_aura == nil then po_degen_aura = class({}) end

function po_degen_aura:GetIntrinsicModifierName()
	return "modifier_po_degen_aura"
end

if modifier_po_degen_aura == nil then modifier_po_degen_aura = class({}) end

function modifier_po_degen_aura:OnCreated(htable)
    if IsServer() then
		   self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("cooldown"))
	  end
end

function modifier_po_degen_aura:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetParent()
	  local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #units > 0 then
	  		for _,vic in pairs(units) do
	  			if RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
	          EmitSoundOn ("DOTA_Item.SoulRing.Activate", vic)
	          ApplyDamage({victim = vic, attacker = caster, damage = vic:GetHealth()*(self:GetAbility():GetSpecialValueFor("hp_remove")/100), damage_type = DAMAGE_TYPE_PURE})
	        end
	  		end
		end
	end
end

function modifier_po_degen_aura:IsPurgable()
    return false
end

function modifier_po_degen_aura:IsHidden()
    return true
end

function po_degen_aura:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

