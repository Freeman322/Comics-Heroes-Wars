LinkLuaModifier("modifier_manhattan_energy_surge", "abilities/manhattan_energy_surge.lua", 0)

manhattan_energy_surge = class({})

function manhattan_energy_surge:OnSpellStart()
    if IsServer() then
        local target = self:GetCursorTarget()

        if ( not target:TriggerSpellAbsorb (self) ) then
            target:AddNewModifier(self:GetCaster(), self, "modifier_knockback", {
                center_x = target:GetAbsOrigin(),
                center_y = target:GetAbsOrigin(),
                center_z = target:GetAbsOrigin(),
                duration = self:GetSpecialValueFor("stun_duration"),
                knockback_duration = self:GetSpecialValueFor("stun_duration"),
                knockback_height = 100
            })
            target:AddNewModifier(self:GetCaster(), self, "modifier_manhattan_energy_surge", {duration = self:GetSpecialValueFor("stun_duration")})
        end
    end

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "uganda") then
        EmitSoundOn("Uganda.Cast3", self:GetCaster())
    end
end

modifier_manhattan_energy_surge = class({
    IsHidden = function() return true end,
    IsPurgable = function() return true end
})

function modifier_manhattan_energy_surge:OnCreated()
    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("stun_duration"))

    local particle = ParticleManager:CreateParticle("particles/manhattan_energy_surge_1.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(128, 128, 128))
end

function modifier_manhattan_energy_surge:OnIntervalThink()
    if IsServer() then
        self:StartIntervalThink(-1)

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())

        local int_mult = self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor("int_mult")
        local mana_spend = int_mult + self:GetCaster():GetMana() / 100 * self:GetAbility():GetSpecialValueFor("mana_to_damage")

        self:GetParent():SpendMana(mana_spend, self:GetAbility())

        ApplyDamage({
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = mana_spend + self:GetAbility():GetSpecialValueFor("base_damage"),
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility()
        })
    end
end
