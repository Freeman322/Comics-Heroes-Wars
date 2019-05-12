---@class misterio_mystic_arena 
---@author Freeman
LinkLuaModifier( "modifier_misterio_mystic_arena_thinker",	"abilities/misterio_mystic_arena.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_misterio_mystic_arena_debuff",	"abilities/misterio_mystic_arena.lua", LUA_MODIFIER_MOTION_NONE )

misterio_mystic_arena = class({})

misterio_mystic_arena.m_vCenter = nil

function misterio_mystic_arena:IsStealable() return false end

function misterio_mystic_arena:OnSpellStart()
    if IsServer() then
        self.m_vCenter = self:GetCursorPosition()

        CreateModifierThinker(self:GetCaster(), self, "modifier_misterio_mystic_arena_thinker", {duration = self:GetSpecialValueFor("duration")}, self.m_vCenter, self:GetCaster():GetTeamNumber(), false)
    end 
end

---@class modifier_misterio_mystic_arena_thinker 

modifier_misterio_mystic_arena_thinker = class({}) 

function modifier_misterio_mystic_arena_thinker:OnCreated(params)
    if IsServer() then
        AddFOWViewer( self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("duration"), false)
        GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), false)
    end
end

function modifier_misterio_mystic_arena_thinker:OnDestroy()
end

function modifier_misterio_mystic_arena_thinker:CheckState()
     return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_misterio_mystic_arena_thinker:IsAura() return true end
function modifier_misterio_mystic_arena_thinker:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_misterio_mystic_arena_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_misterio_mystic_arena_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC end
function modifier_misterio_mystic_arena_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS end

function modifier_misterio_mystic_arena_thinker:GetModifierAura()
    return "modifier_misterio_mystic_arena_debuff"
end

---@class modifier_misterio_mystic_arena_debuff

modifier_misterio_mystic_arena_debuff = class({})

local DAMAGE_INTERVAL = 1

function modifier_misterio_mystic_arena_debuff:IsHidden() return false end
function modifier_misterio_mystic_arena_debuff:IsPurgable() return false end
function modifier_misterio_mystic_arena_debuff:IsDebuff() return true end

function modifier_misterio_mystic_arena_debuff:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(DAMAGE_INTERVAL)
    end 
end

function modifier_misterio_mystic_arena_debuff:OnIntervalThink()
    if IsServer() then

    end 
end

function modifier_misterio_mystic_arena_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end

function modifier_misterio_mystic_arena_debuff:GetModifierMoveSpeed_Absolute(params)
    if IsServer() then 
        if self.GetAbility().m_vCenter then 
            local distToUnit = (self:GetParent():GetAbsOrigin() - self.GetAbility().m_vCenter):Length2D()
            local circleRadius = self:GetAbility():GetSpecialValueFor("radius") 

            if distToUnit >= (circleRadius / 2) and self:GetParent():GetForwardVector():Dot((self:GetParent():GetAbsOrigin() - self.GetAbility().m_vCenter):Length()) > 0 then return 0 end
        end 
    end 

    return 150
end

function modifier_misterio_mystic_arena_debuff:GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetSpecialValueFor("damage_increase")
end

function modifier_misterio_mystic_arena_debuff:GetAbsoluteNoDamagePhysical()
    return 1 
end