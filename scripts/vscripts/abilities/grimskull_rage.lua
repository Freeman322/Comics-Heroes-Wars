grimskull_rage = class({})

LinkLuaModifier( "modifier_grimskull_rage",         "abilities/grimskull_rage.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier ("modifier_grimskull_rage_passive", "abilities/grimskull_rage.lua", LUA_MODIFIER_MOTION_NONE)

function grimskull_rage:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
	return behav
end

function grimskull_rage:GetIntrinsicModifierName()
	return "modifier_grimskull_rage"
end

modifier_grimskull_rage = class({})

function modifier_grimskull_rage:IsHidden()
	return true
end

function modifier_grimskull_rage:IsAura()
    return true
end

function modifier_grimskull_rage:IsPurgable()
    return false
end

function modifier_grimskull_rage:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_grimskull_rage:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_grimskull_rage:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_grimskull_rage:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_grimskull_rage:GetModifierAura()
    return "modifier_grimskull_rage_passive"
end

if modifier_grimskull_rage_passive == nil then modifier_grimskull_rage_passive = class({}) end

function modifier_grimskull_rage_passive:OnCreated(htable)
    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
    end
end

function modifier_grimskull_rage_passive:OnIntervalThink()
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local damage = self:GetAbility():GetSpecialValueFor("aura_damage")

    local damage = {
        victim = parent,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    }

    ApplyDamage( damage )
end

function modifier_grimskull_rage_passive:IsPurgable(  )
    return false
end

function modifier_grimskull_rage_passive:GetEffectName()
    return "particles/items2_fx/radiance.vpcf"
end

function modifier_grimskull_rage_passive:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

