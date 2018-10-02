LinkLuaModifier ("modifier_po_smoke_strike_thinker", "abilities/po_smoke_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_po_smoke_strike", "abilities/po_smoke_strike.lua", LUA_MODIFIER_MOTION_NONE)

po_smoke_strike = class({})

function po_smoke_strike:GetAOERadius ()
    return self:GetSpecialValueFor("radius")
end

function po_smoke_strike:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
end

function po_smoke_strike:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = self:GetCursorPosition ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor("duration")
    self.thinker = CreateModifierThinker (caster, self, "modifier_po_smoke_strike_thinker", {duration = duration }, point, team_id, false)
    GridNav:DestroyTreesAroundPoint (point, 500, false)

    EmitSoundOn("Hero_Riki.TricksOfTheTrade.Cast", thinker)
end

modifier_po_smoke_strike_thinker = class({})

function modifier_po_smoke_strike_thinker:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor ("radius")
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_riki/riki_smokebomb.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn("Hero_Riki.Smoke_Screen.ti8", thinker)
    end
end

function modifier_po_smoke_strike_thinker:CheckState()
   return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_po_smoke_strike_thinker:IsAura()
    return true
end

function modifier_po_smoke_strike_thinker:IsHidden()
    return true
end

function modifier_po_smoke_strike_thinker:IsPurgable()
    return false
end

function modifier_po_smoke_strike_thinker:GetAuraRadius()
    return self.radius
end

function modifier_po_smoke_strike_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_po_smoke_strike_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_po_smoke_strike_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_po_smoke_strike_thinker:GetModifierAura()
    return "modifier_persistent_invisibility"
end
