LinkLuaModifier("modifier_blackzoom_time_shift", "abilities/blackzoom_time_shift.lua", LUA_MODIFIER_MOTION_NONE)

if blackzoom_time_shift == nil then blackzoom_time_shift = class({}) end

function blackzoom_time_shift:CastFilterResultTarget( hTarget )
    if IsServer() then

        if hTarget ~= nil and hTarget:IsMagicImmune() and ( not self:GetCaster():HasScepter() ) then
            return UF_FAIL_MAGIC_IMMUNE_ENEMY
        end

        local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
        return nResult
    end

    return UF_SUCCESS
end

function blackzoom_time_shift:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_zoom_arcana") then
        return "custom/bh_time_shift"
    end
    return "custom/blackzoom_time_shift"
end

function blackzoom_time_shift:OnSpellStart()
    local hTarget = self:GetCursorTarget()
    if hTarget ~= nil then
        local duration = self:GetSpecialValueFor("duration")
        if ( not hTarget:TriggerSpellAbsorb( self ) ) then
            local nFXIndex = ParticleManager:CreateParticle( "particles/hero_zoom/blackzoom_time_shift.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            if self:GetCaster():GetModelName() == "models/heroes/hero_zoom/speed_wraith/blackflash.vmdl" then
                EmitSoundOn( "Hero_Spectre.Haun", hTarget )
                EmitSoundOn( "Hero_Nevermore.ROS_Cast_Flames", hTarget )
                EmitSoundOn( "Hero_Nevermore.ROS.Arcana", hTarget )
                EmitSoundOn( "Hero_Nevermore.Shadowraze.Arcana", hTarget )
            else
                EmitSoundOn( "Hero_Winter_Wyvern.WintersCurse.Cast", hTarget)
                EmitSoundOn( "Hero_Clinkz.DeathPact.Cast", hTarget )
            end

            AddNewModifier_pcall(hTarget, self:GetCaster(), self, "modifier_blackzoom_time_shift", { duration = duration })
        end
    end
end

if modifier_blackzoom_time_shift == nil then modifier_blackzoom_time_shift = class({}) end

function modifier_blackzoom_time_shift:IsHidden()
    return false
end

function modifier_blackzoom_time_shift:IsPurgable()
    return false
end

function modifier_blackzoom_time_shift:GetStatusEffectName()
    return "particles/hero_zoom/status_effect_time_shift.vpcf"
end

function modifier_blackzoom_time_shift:StatusEffectPriority()
    return 1000
end

function modifier_blackzoom_time_shift:OnCreated(htable)
    if IsServer() then
        ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), damage = self:GetParent():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("damage")/100), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})

        if self:GetCaster():HasScepter() then
            local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("aoe_radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
            if #units > 0 then
                for _,target in pairs(units) do
                    EmitSoundOn( "Hero_Winter_Wyvern.WintersCurse.Cast", target)

                    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_zoom/blackzoom_time_shift.vpcf", PATTACH_CUSTOMORIGIN, nil );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 0,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                    ParticleManager:ReleaseParticleIndex( nFXIndex );

                    AddNewModifier_pcall( target, self:GetCaster(), self:GetAbility(), "modifier_blackzoom_time_shift", { duration = self:GetAbility():GetSpecialValueFor("duration") } )
                end
            end
        end
    end
end

function modifier_blackzoom_time_shift:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_HEALING
    }

    return funcs
end

function modifier_blackzoom_time_shift:GetDisableHealing(params)
    return 1
end
