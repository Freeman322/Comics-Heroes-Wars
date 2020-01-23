if gorr_butch == nil then gorr_butch = class({}) end

LinkLuaModifier( "modifier_gorr_butch", "abilities/gorr_butch.lua", LUA_MODIFIER_MOTION_NONE )

function gorr_butch:OnSpellStart()
    local radius = self:GetSpecialValueFor(  "radius" )
    local duration = self:GetSpecialValueFor(  "duration" )
    local damage = self:GetSpecialValueFor(  "damage_ptc" )

    local caster = self:GetCaster()

    if caster:HasTalent("special_bonus_unique_gorr_1") then duration = duration + caster:FindTalentValue("special_bonus_unique_gorr_1") end
    if caster:HasTalent("special_bonus_unique_gorr_3") then radius = radius + caster:FindTalentValue("special_bonus_unique_gorr_3") end
    if caster:HasTalent("special_bonus_unique_gorr_2") then damage = damage + caster:FindTalentValue("special_bonus_unique_gorr_2") end

    local mod = caster:AddNewModifier(caster, self, "modifier_gorr_butch", {duration = duration})
    mod:SetStackCount(1)

    local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, 0, 0, false )
    if #units > 0 then
        for _, unit in pairs(units) do
            if not unit:IsHero() and not unit:IsBuilding() and not unit:IsAncient() and not unit:IsConsideredHero() then
                local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_ti8_immortal_arms/doom_ti8_immortal_devour.vpcf", PATTACH_CUSTOMORIGIN, nil );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex( nFXIndex );

                mod:SetStackCount(mod:GetStackCount() + (unit:GetHealth() * (damage / 100)))
                unit:Kill(self, caster)
            end
        end
    end

    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/witch_doctor/wd_ti8_immortal_head/wd_ti8_immortal_maledict_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetOrigin() )
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, 0) )
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    EmitSoundOn( "Hero_Nightstalker.Void.Nihility", caster )
end

if not modifier_gorr_butch then modifier_gorr_butch = class({}) end

function modifier_gorr_butch:IsPurgable() return false end
function modifier_gorr_butch:IsHidden() return true end

function modifier_gorr_butch:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_gorr_butch:GetStatusEffectName()
    return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_gorr_butch:StatusEffectPriority()
    return 2000
end

function modifier_gorr_butch:GetEffectName()
    return "particles/status_fx/status_effect_obsidian_matter_debuff.vpcf"
end

function modifier_gorr_butch:GetModifierPreAttack_BonusDamage( params )
    return self:GetStackCount()
end
