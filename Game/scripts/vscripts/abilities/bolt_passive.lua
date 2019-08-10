LinkLuaModifier ("modifier_bolt_passive", "abilities/bolt_passive.lua", LUA_MODIFIER_MOTION_NONE)

bolt_passive = class({})

function bolt_passive:GetIntrinsicModifierName() return "modifier_bolt_passive" end

modifier_bolt_passive = class({})

function modifier_bolt_passive:IsHidden()	return true end
function modifier_bolt_passive:OnCreated() if IsServer() then self:StartIntervalThink(FrameTime()) end end

function modifier_bolt_passive:OnIntervalThink()
	if IsServer () then
		local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #units > 0 then
			for _,target in pairs(units) do
				if target:IsMagicImmune() == false and self:GetParent():IsAlive() and self:GetAbility():IsCooldownReady() and self:GetParent():IsRealHero() then
					target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetAbility():GetSpecialValueFor("duration") } )
					ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbility():GetSpecialValueFor("damage"), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL})
					
					self:GetAbility():UseResources(false, false, true)
				end
			end
		end
	end
end
