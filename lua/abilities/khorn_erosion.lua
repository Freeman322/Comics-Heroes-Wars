LinkLuaModifier( "khorn_erosion_aura", 			"abilities/khorn_erosion.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_khorn_erosion",  "abilities/khorn_erosion.lua", LUA_MODIFIER_MOTION_NONE )

khorn_erosion = class({})

function khorn_erosion:GetIntrinsicModifierName()
	return "khorn_erosion_aura"
end

khorn_erosion_aura = class({})

function khorn_erosion_aura:IsAura()
	return true
end

function khorn_erosion_aura:IsHidden()
	return true
end

function khorn_erosion_aura:IsPurgable()
	return false
end

function khorn_erosion_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function khorn_erosion_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function khorn_erosion_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function khorn_erosion_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function khorn_erosion_aura:GetModifierAura()
	return "modifier_khorn_erosion"
end

modifier_khorn_erosion = class({})

function modifier_khorn_erosion:IsBuff()
	return false
end

function modifier_khorn_erosion:IsPurgable()
	return false
end

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
        ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
        self.ElapsedDistance = target:GetAbsOrigin()
    end
end

function modifier_khorn_erosion:OnDestroy()
    self.ElapsedDistance = nil
end

function modifier_khorn_erosion:GetEffectName()
    return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_khorn_erosion:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function khorn_erosion:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

