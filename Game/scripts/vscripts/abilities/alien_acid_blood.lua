LinkLuaModifier("modifier_acid_blood", "abilities/alien_acid_blood.lua", 0)
LinkLuaModifier("modifier_acid_blood_thinker", "abilities/alien_acid_blood.lua", 0)
LinkLuaModifier("modifier_acid_blood_debuff", "abilities/alien_acid_blood.lua", 0)

alien_acid_blood = class({GetIntrinsicModifierName = function() return "modifier_acid_blood" end})
modifier_acid_blood = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
})

function modifier_acid_blood:OnTakeDamage(params)
    if not IsServer() then return end
    if params.unit == self:GetParent() then
        if self:GetAbility():IsCooldownReady() and self:GetParent():IsRealHero() and params.attacker:IsRealHero()  then
            CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_acid_blood_thinker", {duration = self:GetAbility():GetSpecialValueFor("duration")}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeam(), false)
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
        end
    end
end

modifier_acid_blood_thinker = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    IsAura = function() return true end,
    GetModifierAura = function() return "modifier_acid_blood_debuff" end,
    GetAuraDuration = function() return 1 end
})

function modifier_acid_blood_thinker:OnCreated()
    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
    ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl( particle, 1, Vector(self:GetAbility():GetSpecialValueFor("blood_radius"), self:GetAbility():GetSpecialValueFor("blood_radius"), 0))
    self:AddParticle(particle, false, false, -1, false, true)
end

function modifier_acid_blood_thinker:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("blood_radius") end
function modifier_acid_blood_thinker:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function modifier_acid_blood_thinker:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function modifier_acid_blood_thinker:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end

modifier_acid_blood_debuff = class({
    IsHidden = function() return false end,
    IsPurgable = function() return true end,
    GetEffectName = function() return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
})

function modifier_acid_blood_debuff:OnCreated()
    if IsServer() then
        self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_interval"))
        self:SetStackCount(0)
    end
end
function modifier_acid_blood_debuff:OnIntervalThink()
    if IsServer() then
        self:IncrementStackCount()
        local hp_damage = 0.01 * self:GetParent():GetMaxHealth() * self:GetAbility():GetSpecialValueFor("hp_damage")
        local damage = (hp_damage + self:GetAbility():GetSpecialValueFor("base_damage")) * self:GetAbility():GetSpecialValueFor("tick_interval")
        if self:GetParent():GetPhysicalArmorValue(false) < 0 then
            damage = damage + damage * ((self:GetParent():GetPhysicalArmorValue(false) * -1) * 0.1)
        end
        ApplyDamage({
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            ability = self:GetAbility(),
            damage = damage,
            damage_type = self:GetAbility():GetAbilityDamageType()
        })
    end
end
function modifier_acid_blood_debuff:GetModifierPhysicalArmorBonus()
    local armor_red = self:GetAbility():GetSpecialValueFor("armor_red_per_tick") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_alien_acid_blood_armor_red") or 0)
    return (armor_red * -1) * self:GetStackCount()
end
