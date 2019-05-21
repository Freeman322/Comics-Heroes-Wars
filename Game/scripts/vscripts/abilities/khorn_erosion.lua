LinkLuaModifier("khorn_erosion_aura", "abilities/khorn_erosion.lua", 0)
LinkLuaModifier("modifier_khorn_erosion",  "abilities/khorn_erosion.lua", 0)

khorn_erosion = class({
	GetIntrinsicModifierName = function() return "khorn_erosion_aura" end
})


khorn_erosion_aura = class({
	IsAura = function() return true end,
	IsHidden = function() return true end,
	IsPurgable = function() return false end,
	GetModifierAura = function() return "modifier_khorn_erosion" end
})
function khorn_erosion_aura:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("aura_radius") end
function khorn_erosion_aura:GetAuraSearchTeam()	return self:GetAbility():GetAbilityTargetTeam() end
function khorn_erosion_aura:GetAuraSearchType()	return self:GetAbility():GetAbilityTargetType() end
function khorn_erosion_aura:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end


modifier_khorn_erosion = class({
	IsDebuff = function() return false end,
	IsPurgable = function() return false end,
	DeclareFunctions = function() return {MODIFIER_EVENT_ON_UNIT_MOVED} end
})
function modifier_khorn_erosion:OnUnitMoved()
	if IsServer() then
		if self.position then
			local range = (self.position - self:GetParent():GetAbsOrigin()):Length2D()
			if range > 0 and range <= self:GetAbility():GetSpecialValueFor("max_move_range") then
				ApplyDamage({
					victim = self:GetParent(),
					attacker = self:GetCaster(),
					damage = range * self:GetAbility():GetSpecialValueFor("aura_damage") / 100,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility()
				})
			end
		end
		self.position = self:GetParent():GetAbsOrigin()
	end
end
--[[
function modifier_khorn_erosion:OnCreated(event)
    if IsServer() then
        self.ElapsedDistance = self:GetParent():GetAbsOrigin()
        self:StartIntervalThink(0.05)
    end
end

function modifier_khorn_erosion:OnIntervalThink()
    local target = self:GetParent()
    local dmg_pers = self:GetAbility():GetSpecialValueFor("aura_damage")/100
    if target:GetAbsOrigin() ~= self.ElapsedDistance then
        local targetDistance = (target:GetAbsOrigin() - self.ElapsedDistance):Length2D()
        local damage = targetDistance*dmg_pers
       
        if self:GetCaster():HasTalent("special_bonus_unique_khorne") then
            damage = (self:GetCaster():FindTalentValue("special_bonus_unique_khorne")*dmg_pers) + damage
        end
       
        self.ElapsedDistance = target:GetAbsOrigin()
        
        ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
    end
end

function modifier_khorn_erosion:OnDestroy()
    self.ElapsedDistance = nil
end
]]
function modifier_khorn_erosion:GetEffectName() return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf" end
function modifier_khorn_erosion:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
