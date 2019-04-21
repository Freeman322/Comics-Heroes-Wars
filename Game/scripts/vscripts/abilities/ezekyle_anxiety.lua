LinkLuaModifier( "modifier_ezekyle_anxiety", "abilities/ezekyle_anxiety.lua", LUA_MODIFIER_MOTION_NONE )

ezekyle_anxiety = class({})

function ezekyle_anxiety:IsRefreshable() return true end

function ezekyle_anxiety:OnSpellStart()
    if IsServer() then
        local duration = self:GetSpecialValueFor(  "tooltip_duration" )
        local mark_ability = self:GetCaster():FindAbilityByName("ezekyle_chaos_mark")

        if self:GetCaster():HasTalent("special_bonus_unique_ezekyle_1") then duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_ezekyle_1") end

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_riki/riki_tricks_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                unit:AddNewModifier( self:GetCaster(), self, "modifier_ezekyle_anxiety", { duration = duration } )

                EmitSoundOn("Hero_AbyssalUnderlord.PitOfMalice.Start", unit)

                if self:GetCaster():HasScepter() then
                    unit:AddNewModifier( self:GetCaster(), mark_ability, "modifier_ezekyle_chaos_mark", { duration = mark_ability:GetSpecialValueFor("duration") / 2 } )
                end
            end
        end

        EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Complete", self:GetCaster())
        EmitSoundOn("Abaddon.Ult.Cast", self:GetCaster())
    end
end

modifier_ezekyle_anxiety = class({})


function modifier_ezekyle_anxiety:IsPurgable() return false end
function modifier_ezekyle_anxiety:IsHidden() return true end
function modifier_ezekyle_anxiety:RemoveOnDeath() return true end
function modifier_ezekyle_anxiety:GetStatusEffectName() return "particles/status_fx/status_effect_grimstroke_dark_artistry.vpcf" end
function modifier_ezekyle_anxiety:StatusEffectPriority() return 1000 end
function modifier_ezekyle_anxiety:GetEffectName() return "particles/plus/pugalo_ambient.vpcf" end
function modifier_ezekyle_anxiety:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_ezekyle_anxiety:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
    }
end


function modifier_ezekyle_anxiety:CheckState()
	return {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_PROVIDES_VISION] = true,
        [MODIFIER_STATE_MUTED] = true
	}
end


function modifier_ezekyle_anxiety:GetBonusVisionPercentage ( params ) return -100 end
function modifier_ezekyle_anxiety:GetModifierStatusResistance ( params ) return -100 end
function modifier_ezekyle_anxiety:GetModifierMoveSpeed_Absolute ( params ) return 175 end
function modifier_ezekyle_anxiety:GetModifierIncomingPhysicalDamage_Percentage ( params ) return self:GetAbility():GetSpecialValueFor("incoming_damage") end
