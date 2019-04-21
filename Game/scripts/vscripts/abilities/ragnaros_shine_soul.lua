LinkLuaModifier( "modifier_ragnaros_shine_soul", "abilities/ragnaros_shine_soul.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_ragnaros_shine_soul_passive", "abilities/ragnaros_shine_soul.lua", LUA_MODIFIER_MOTION_NONE)

ragnaros_shine_soul = class({})

function ragnaros_shine_soul:GetIntrinsicModifierName() return "modifier_ragnaros_shine_soul" end

modifier_ragnaros_shine_soul = class({})

function modifier_ragnaros_shine_soul:IsHidden() return true end
function modifier_ragnaros_shine_soul:IsAura() return true end
function modifier_ragnaros_shine_soul:IsPurgable() return false end
function modifier_ragnaros_shine_soul:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_ragnaros_shine_soul:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_ragnaros_shine_soul:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_ragnaros_shine_soul:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_ragnaros_shine_soul:GetModifierAura() return "modifier_ragnaros_shine_soul_passive" end

modifier_ragnaros_shine_soul_passive = class({})

function modifier_ragnaros_shine_soul_passive:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_ragnaros_shine_soul_passive:OnIntervalThink()
    local damage = self:GetAbility():GetSpecialValueFor("aura_damage")

    if self:GetCaster():HasTalent("special_bonus_unique_ragnaros") then
        damage = self:GetCaster():FindTalentValue("special_bonus_unique_ragnaros") + damage
    end

    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    })

    self:GetCaster():Heal(damage * (self:GetAbility():GetSpecialValueFor("bonus_vampirism") / 100), self:GetAbility())

    local lifesteal_fx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(lifesteal_fx)
end

function modifier_ragnaros_shine_soul_passive:IsPurgable() return false end

function modifier_ragnaros_shine_soul_passive:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_ragnaros_shine_soul_passive:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("aura_slowing") end
function modifier_ragnaros_shine_soul_passive:GetEffectName() return "particles/items2_fx/radiance.vpcf" end
function modifier_ragnaros_shine_soul_passive:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
