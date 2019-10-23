LinkLuaModifier ("modifier_katana_cairn_of_souls_thinker", "abilities/katana_cairn_of_souls.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_katana_cairn_of_souls", "abilities/katana_cairn_of_souls.lua", LUA_MODIFIER_MOTION_NONE)
katana_cairn_of_souls = class({})


function katana_cairn_of_souls:GetAOERadius ()
    return self:GetSpecialValueFor("radius")
end

function katana_cairn_of_souls:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
end

function katana_cairn_of_souls:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = self:GetCursorPosition ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor("pit_duration")
    local thinker = CreateModifierThinker (caster, self, "modifier_katana_cairn_of_souls_thinker", {duration = duration }, point, team_id, false)
    AddFOWViewer (caster:GetTeam (), point, 450, duration, false)
    GridNav:DestroyTreesAroundPoint (point, 500, false)
end

modifier_katana_cairn_of_souls_thinker = class({})

function modifier_katana_cairn_of_souls_thinker:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor ("radius")
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_katana/katana_pit_of_souls.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(2000, self.radius, 4))
        ParticleManager:SetParticleControl( nFXIndex, 2, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 8, Vector(1, 1, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        EmitSoundOn("Hero_Silencer.Curse.Cast", thinker)
    end
end

function modifier_katana_cairn_of_souls_thinker:IsAura ()
    return true
end

function modifier_katana_cairn_of_souls_thinker:GetAuraRadius ()
    return self.radius
end

function modifier_katana_cairn_of_souls_thinker:GetAuraSearchTeam ()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_katana_cairn_of_souls_thinker:GetAuraSearchType ()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_katana_cairn_of_souls_thinker:GetAuraSearchFlags ()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_katana_cairn_of_souls_thinker:GetModifierAura ()
    return "modifier_katana_cairn_of_souls"
end


modifier_katana_cairn_of_souls = class({})

function modifier_katana_cairn_of_souls:IsBuff ()
    return false
end

function modifier_katana_cairn_of_souls:OnCreated (event)
    local ability = self:GetAbility()
    self:StartIntervalThink( 1 )
    self:OnIntervalThink()

    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bane/bane_fiends_grip.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1, 0, 0))
        ParticleManager:SetParticleControl( nFXIndex, 2, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 5, self:GetParent():GetAbsOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end


function modifier_katana_cairn_of_souls:OnIntervalThink(  )
    if IsServer() then
        ApplyDamage( {attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("pit_damage"), damage_type = DAMAGE_TYPE_MAGICAL} )
    end
end

function modifier_katana_cairn_of_souls:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end


function modifier_katana_cairn_of_souls:GetModifierMoveSpeedBonus_Percentage( params )
    return self:GetAbility():GetSpecialValueFor("slowing")
end

function katana_cairn_of_souls:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

