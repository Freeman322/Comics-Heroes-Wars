LinkLuaModifier("modifier_flash_speedforce_lightning", "abilities/flash_speedforce_lightning.lua", 0)

flash_speedforce_lightning = class({
    GetIntrinsicModifierName = function() return "modifier_flash_speedforce_lightning" end
})

function flash_speedforce_lightning:OnSpellStart()
    if IsServer() then
        if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end
        self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
        ApplyDamage({victim = self:GetCursorTarget(), attacker = self:GetCaster(), damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetIdealSpeed() * self:GetSpecialValueFor("speed_to_damage_pct") / 100, damage_type = self:GetAbilityDamageType(), ability = self})
        modifier_flash_speedforce_lightning.distance = 0

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(particle, 0, Vector(self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, self:GetCaster():GetAbsOrigin().z + 96))
        ParticleManager:SetParticleControl(particle, 1, Vector(self:GetCursorTarget():GetAbsOrigin().x, self:GetCursorTarget():GetAbsOrigin().y, self:GetCursorTarget():GetAbsOrigin().z + 96))
        ParticleManager:SetParticleControl(particle, 2, self:GetCursorTarget():GetAbsOrigin())
        EmitSoundOn("Ability.LagunaBladeImpact", self:GetCursorTarget())
    end
end

modifier_flash_speedforce_lightning = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_UNIT_MOVED} end
})

function modifier_flash_speedforce_lightning:OnCreated() if IsServer() then modifier_flash_speedforce_lightning.distance = 0 self:StartIntervalThink(FrameTime()) modifier_flash_speedforce_lightning.pos = self:GetParent():GetAbsOrigin() self:SetStackCount(0) end end
function modifier_flash_speedforce_lightning:OnIntervalThink()
    if IsServer() then
        if modifier_flash_speedforce_lightning.distance < self:GetAbility():GetSpecialValueFor("distance_to_activate") then
            self:GetAbility():SetActivated(false)
        elseif modifier_flash_speedforce_lightning.distance >= self:GetAbility():GetSpecialValueFor("distance_to_activate") then
            self:GetAbility():SetActivated(true)
        end
        if modifier_flash_speedforce_lightning.distance > self:GetAbility():GetSpecialValueFor("distance_to_activate") then
            modifier_flash_speedforce_lightning.distance = self:GetAbility():GetSpecialValueFor("distance_to_activate")
        end
        self:SetStackCount(math.floor(modifier_flash_speedforce_lightning.distance / self:GetAbility():GetSpecialValueFor("distance_to_activate") * 100))
    end
end

function modifier_flash_speedforce_lightning:OnUnitMoved()
    if IsServer() then
        if self.position then
            local range = (self.position - self:GetParent():GetAbsOrigin()):Length2D()
            if range > 0 and range <= self:GetAbility():GetSpecialValueFor("max_move_range") then
                modifier_flash_speedforce_lightning.distance = modifier_flash_speedforce_lightning.distance + range
            end
        end
        self.position = self:GetParent():GetAbsOrigin()
    end
end
