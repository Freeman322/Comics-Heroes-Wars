LinkLuaModifier("modifier_oblivion_ult", "abilities/oblivion_ult.lua", 0)

oblivion_ult = class({})

function oblivion_ult:GetAbilityTextureName() if self:GetCaster():HasModifier("modifier_arcana") then return "custom/oblivion_ult_immortal" else return "custom/eternity_2" end end
function oblivion_ult:GetCooldown(nLevel) if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("cooldown_scepter") else return self.BaseClass.GetCooldown(self, nLevel) end end

function oblivion_ult:OnSpellStart()
    local duration = self:GetSpecialValueFor("tooltip_duration")
    if self:GetCaster():HasScepter() then duration = self:GetSpecialValueFor("duration_scepter") end

    for _, target in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)) do
        if target:IsMagicImmune() == false then
            target:AddNewModifier(self:GetCaster(), self, "modifier_oblivion_ult", {duration = duration})
            EmitSoundOn("Hero_Oracle.FalsePromise.Cast", target)

            if self:GetCaster():HasModifier("modifier_arcana") then
                EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", target)
            end
        end
    end

    EmitSoundOn("Hero_Silencer.GlobalSilence.Cast", self:GetCaster())

    if self:GetCaster():HasModifier("modifier_arcana") then
        EmitSoundOn("Hero_Zuus.Cloud.Cast", self:GetCaster())
        EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", self:GetCaster())

        local particle_start = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(particle_start, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_start, 1, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_start, 2, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle_start)
    end

    self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
end

modifier_oblivion_ult = class({
    IsDebuff = function() return true end,
    IsPurgable = function() return true end,
    GetEffectName = function() return "particles/units/heroes/hero_oracle/oracle_false_promise.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
})

function modifier_oblivion_ult:OnCreated()
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/bane/slumbering_terror/bane_slumber_nightmare.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle(nFXIndex, false, false, -1, false, false)

        EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", self:GetParent())
        EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", self:GetParent())

        local particle = ParticleManager:CreateParticle("particles/hero_zuus/zeus_immortal_thundergod.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(particle, 0, Vector(self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, 2000 ))
        ParticleManager:SetParticleControl(particle, 1, Vector(self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, self:GetParent():GetAbsOrigin().z + self:GetParent():GetBoundingMaxs().z))
        ParticleManager:SetParticleControl(particle, 2, Vector(self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, self:GetParent():GetAbsOrigin().z + self:GetParent():GetBoundingMaxs().z))
    end
end

function modifier_oblivion_ult:GetModifierMagicalResistanceBonus() return self:GetAbility():GetSpecialValueFor("magical_armor_bonus") * -1 end
function modifier_oblivion_ult:CheckState() return {[MODIFIER_STATE_SILENCED] = true, [MODIFIER_STATE_DISARMED] = self:GetCaster():HasScepter()} end
