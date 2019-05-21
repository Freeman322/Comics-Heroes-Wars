LinkLuaModifier ("modifier_po_degen_aura", "abilities/po_degen_aura.lua", LUA_MODIFIER_MOTION_NONE)

po_degen_aura = class({})

function po_degen_aura:GetIntrinsicModifierName()	return "modifier_po_degen_aura" end

modifier_po_degen_aura = class({})

function modifier_po_degen_aura:IsPurgable() return false end
function modifier_po_degen_aura:IsHidden() return true end

function modifier_po_degen_aura:OnCreated()
    if IsServer() then
		   self:StartIntervalThink(1)
	  end
end

function modifier_po_degen_aura:OnIntervalThink()
	if IsServer() then
	  local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #units > 0 then
			for _,victim in pairs(units) do
				if RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) and self:GetParent():IsAlive() then
					EmitSoundOn ("DOTA_Item.SoulRing.Activate", victim)
					ApplyDamage({victim = victim, attacker = self:GetCaster(), damage = victim:GetHealth() * self:GetAbility():GetSpecialValueFor("hp_remove") / 100, damage_type = DAMAGE_TYPE_PURE})
				end
	  		end
		end
	end
end
