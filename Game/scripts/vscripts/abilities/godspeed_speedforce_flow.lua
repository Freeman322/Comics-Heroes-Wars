if not godspeed_speedforce_flow then godspeed_speedforce_flow = class({}) end

function godspeed_speedforce_flow:GetCooldown(nLevel)
    return self.BaseClass.GetCooldown(self, nLevel)
end

function godspeed_speedforce_flow:Flow()
    local abil = self:GetCaster():FindAbilityByName("godspeed_bend_time")

    if abil then
        abil:ResetSpeed()
    end
end

function godspeed_speedforce_flow:GetManaCost() return self:GetCaster():GetIdealSpeed() end

function godspeed_speedforce_flow:OnSpellStart()
    if not IsServer() then return end

    local range = self:GetSpecialValueFor("radius")
    local base_damage = self:GetSpecialValueFor("damage")

    local explosion2 = ParticleManager:CreateParticle("particles/econ/items/axe/axe_ti9_immortal/axe_ti9_gold_call.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(explosion2, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(explosion2, 2, Vector(range, range, 0))
    ParticleManager:SetParticleControl(explosion2, 5, self:GetCaster():GetAbsOrigin())

    ScreenShake( self:GetCaster():GetOrigin(), 100, 100, 1, 9999, 0, true)
    GridNav:DestroyTreesAroundPoint(self:GetCaster():GetAbsOrigin(), range, false)

    local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false)

    for _, target in pairs(targets) do
        ApplyDamage({
            victim = target,
            attacker = self:GetCaster(),
            ability = self,
            damage = self:GetCaster():GetIdealSpeed() + base_damage,
            damage_type = self:GetAbilityDamageType()
        })

        target:AddNewModifier(self:GetCaster(), self, "modifier_frostivus2018_huskar_inner_fire_disarm", {duration = self:GetSpecialValueFor("disarm_duration")})
    end

    self:Flow()

    EmitSoundOn("Hero_Huskar.Inner_Fire.Cast", self:GetCaster())
end
