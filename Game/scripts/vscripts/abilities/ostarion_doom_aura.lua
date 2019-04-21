LinkLuaModifier ("modifier_ostarion_doom_aura", 				"abilities/ostarion_doom_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_ostarion_doom_aura_passive", "abilities/ostarion_doom_aura.lua", LUA_MODIFIER_MOTION_NONE)

if ostarion_doom_aura == nil then ostarion_doom_aura = class({}) end

function ostarion_doom_aura:GetIntrinsicModifierName()
	return "modifier_ostarion_doom_aura"
end

if modifier_ostarion_doom_aura == nil then modifier_ostarion_doom_aura = class({}) end

function modifier_ostarion_doom_aura:IsAura()
	return true
end

function modifier_ostarion_doom_aura:IsHidden()
	return true
end

function modifier_ostarion_doom_aura:IsPurgable()
	return false
end

function modifier_ostarion_doom_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_ostarion_doom_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ostarion_doom_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ostarion_doom_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_ostarion_doom_aura:GetModifierAura()
	return "modifier_ostarion_doom_aura_passive"
end

if modifier_ostarion_doom_aura_passive == nil then modifier_ostarion_doom_aura_passive = class({}) end

function modifier_ostarion_doom_aura_passive:OnCreated(htable)
    if IsServer() then
        self.flElapsedTime = 0

		self:StartIntervalThink(0.1)
	end
end

function modifier_ostarion_doom_aura_passive:OnIntervalThink()
    if IsServer() then
        self.flElapsedTime = self.flElapsedTime + 0.1
    end 
end

function modifier_ostarion_doom_aura_passive:IsPurgable(  )
    return false
end

function modifier_ostarion_doom_aura_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_TARGET_CRITICALSTRIKE,
    }

    return funcs
end

function modifier_ostarion_doom_aura_passive:GetModifierPreAttack_Target_CriticalStrike( params )
    if IsServer() then 
        if (self.flElapsedTime >= self:GetAbility():GetSpecialValueFor("duration")) then

            local crit_bonus = self:GetAbility():GetSpecialValueFor("critical_bonus")

            if self:GetCaster():HasTalent("special_bonus_unique_ostarion_4") then
                crit_bonus = crit_bonus + (self:GetCaster():FindTalentValue("special_bonus_unique_ostarion_4") or 0)
            end

            return crit_bonus
        end
    end

    return
end
