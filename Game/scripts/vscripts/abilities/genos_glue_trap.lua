LinkLuaModifier("modifier_genos_glue_trap_thinker", "abilities/genos_glue_trap.lua", LUA_MODIFIER_MOTION_NONE)

genos_glue_trap = class ({})

function genos_glue_trap:OnSpellStart()
    if IsServer() then
        local point = self:GetCursorPosition()
        
        local team_id = self:GetCaster():GetTeamNumber()
        local thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_genos_glue_trap_thinker", {duration = self:GetSpecialValueFor("thinker_duration")}, point, team_id, false)
    end
end

function genos_glue_trap:GetAOERadius()
    return self:GetSpecialValueFor("thinker_radius")
end

modifier_genos_glue_trap_thinker = class ({})

function modifier_genos_glue_trap_thinker:OnCreated(event)
    if IsServer() then
        local target = self:GetAbility():GetCaster():GetCursorPosition()
        local radius = self:GetAbility():GetSpecialValueFor("thinker_radius")

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_broodmother/broodmother_web.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, 0, radius))
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn("Hero_Broodmother.SpinWebCast", self:GetParent())
    end
end

function modifier_genos_glue_trap_thinker:IsAura() return true end
function modifier_genos_glue_trap_thinker:IsHidden() return true end
function modifier_genos_glue_trap_thinker:IsPurgable()	return true end
function modifier_genos_glue_trap_thinker:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("thinker_radius") end
function modifier_genos_glue_trap_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_genos_glue_trap_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_genos_glue_trap_thinker:GetAuraSearchFlags()	return 0 end
function modifier_genos_glue_trap_thinker:GetModifierAura() return "modifier_rooted" end

function modifier_genos_glue_trap_thinker:OnDestroy()
    StopSoundOn("Hero_Alchemist.AcidSpray", self:GetParent())
end
