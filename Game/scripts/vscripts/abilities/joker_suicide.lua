joker_suicide = class({})

function joker_suicide:GetCooldown(nLevel)
    if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("cooldown_scepter") end
    return self.BaseClass.GetCooldown(self, nLevel)
end
function joker_suicide:GetManaCost() return self:GetCaster():GetMaxMana() * 0.01 * self:GetSpecialValueFor("mana_cost") end

function joker_suicide:OnSpellStart()
    if not IsServer() then return end
    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "joker_custom") then
        local explosion2 = ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(explosion2, 0, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 1))
        ParticleManager:SetParticleControl(explosion2, 1, Vector(600, 600, 0))
        ParticleManager:SetParticleControl(explosion2, 2, Vector(0, 255, 17))
    else
        local explosion1 = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_call_down_explosion_impact_a.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(explosion1, 0, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 1))
        ParticleManager:SetParticleControl(explosion1, 1, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 1))
        ParticleManager:SetParticleControl(explosion1, 2, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 1))
        ParticleManager:SetParticleControl(explosion1, 3, Vector(300, 300, 1))
        local explosion2 = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(explosion2, 0, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 1))
        ParticleManager:SetParticleControl(explosion2, 3, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 1))
        ParticleManager:SetParticleControl(explosion2, 5, Vector(600, 600, 1))
    end

    ScreenShake( self:GetCaster():GetOrigin(), 100, 100, 6, 9999, 0, true)
    GridNav:DestroyTreesAroundPoint(self:GetCaster():GetAbsOrigin(), self:GetSpecialValueFor("radius") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_joker_1") or 0), false)
    local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_joker_1") or 0), self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
    for _, target in pairs(targets) do
        ApplyDamage({
            victim = target,
            attacker = self:GetCaster(),
            ability = self,
            damage = self:GetCaster():GetMaxMana() * 0.01 * (self:GetCaster():HasScepter() and self:GetSpecialValueFor("damage_scepter") or self:GetSpecialValueFor("damage")),
            damage_type = self:GetAbilityDamageType()})
        target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
    end
    self:GetCaster():ModifyHealth(self:GetCaster():GetHealth() - self:GetCaster():GetHealth(), self, true, 0)
    EmitSoundOn("Hero_EarthShaker.EchoSlam", self:GetCaster())
    EmitSoundOn("Hero_EarthShaker.EchoSlamEcho", self:GetCaster())
    EmitSoundOn("Hero_EarthShaker.EchoSlamSmall", self:GetCaster())
    EmitSoundOn("PudgeWarsClassic.echo_slam", self:GetCaster())
end
