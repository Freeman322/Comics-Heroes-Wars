if not darkrider_dark_madness then darkrider_dark_madness = class({}) end

local MAX_SLOPH_DISTANCE = 128
local FALL_SPEED = 600

LinkLuaModifier( "modifier_darkrider_dark_madness_debuff", "abilities/darkrider_dark_madness.lua", LUA_MODIFIER_MOTION_NONE )

function darkrider_dark_madness:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function darkrider_dark_madness:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end

function darkrider_dark_madness:OnSpellStart()
    if IsServer() then
        local radius = self:GetSpecialValueFor("radius")

        print(radius)

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _, unit in pairs(units) do
                local info = {
                    EffectName = "particles/econ/items/templar_assassin/templar_assassin_butterfly/templar_assassin_meld_attack_butterfly.vpcf",
                    Ability = self,
                    iMoveSpeed = 1200,
                    Source = self:GetCaster(),
                    Target = self:GetCursorTarget(),
                    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
                }
                ProjectileManager:CreateTrackingProjectile( info )
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_crimson_ti8_immortal_cursed_crownmarker.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() );
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(radius, radius, 0) );
        ParticleManager:SetParticleControl( nFXIndex, 4, self:GetCaster():GetAbsOrigin());
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOn("Hero_AbyssalUnderlord.PitOfMalice.TI8", self:GetCaster())
    end
end

function darkrider_dark_madness:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
        EmitSoundOn("Hero_AbyssalUnderlord.Death", self:GetCaster())

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9_crimson_impact_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true);
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(300, 300, 0) );
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_darkrider_dark_madness_debuff", nil)
    end

    return true
end

if modifier_darkrider_dark_madness_debuff == nil then modifier_darkrider_dark_madness_debuff = class({}) end

function modifier_darkrider_dark_madness_debuff:IsHidden() return true end
function modifier_darkrider_dark_madness_debuff:IsPurgable() return false end

function modifier_darkrider_dark_madness_debuff:OnCreated(table)
    if IsServer() then
        self._vLoc = self:GetCaster():GetAbsOrigin()

        local damage_table = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = self:GetAbility():GetAbilityDamage(),
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility()
        }

        ApplyDamage (damage_table)

        self:StartIntervalThink(FrameTime())
    end
end

function modifier_darkrider_dark_madness_debuff:OnIntervalThink()
    if IsServer() then
        local distance = (self._vLoc - self:GetParent():GetAbsOrigin()):Length2D()

        if distance > MAX_SLOPH_DISTANCE then
            local direction = (self._vLoc - self:GetParent():GetAbsOrigin()):Normalized()

            self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + direction * (FALL_SPEED * FrameTime()))
        else
            self:Destroy()
        end
    end
end

function modifier_darkrider_dark_madness_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_sylph_wisp_fear.vpcf"
end

function modifier_darkrider_dark_madness_debuff:StatusEffectPriority()
    return 1000
end

function modifier_darkrider_dark_madness_debuff:GetEffectName()
    return "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd_debuff.vpcf"
end

function modifier_darkrider_dark_madness_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_darkrider_dark_madness_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_darkrider_dark_madness_debuff:GetOverrideAnimation( params ) return ACT_DOTA_FLAIL end
function modifier_darkrider_dark_madness_debuff:CheckState() return {[MODIFIER_STATE_COMMAND_RESTRICTED] = true, [MODIFIER_STATE_STUNNED] = true} end
