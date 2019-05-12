---@class misterio_mirror_remnant
LinkLuaModifier( "modifier_misterio_mirror_remnant", "abilities/modifier_misterio_mirror_remnant.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_misterio_mirror_remnant_invis", "abilities/modifier_misterio_mirror_remnant.lua", LUA_MODIFIER_MOTION_NONE )

misterio_mirror_remnant = class({}) 

misterio_mirror_remnant.m_duration = 0
misterio_mirror_remnant.m_vector = nil
misterio_mirror_remnant.m_hUnit = nil

function misterio_mirror_remnant:OnSpellStart()
    if IsServer() then
        self.m_duration = self:GetSpecialValueFor("duration")
        self.m_vector = Vector(RandomInt(GetWorldMinX(), GetWorldMaxX()), RandomInt(GetWorldMinY(), GetWorldMaxY()))

        PrecacheUnitByNameAsync("npc_dota_unit_misterio_remnant", function()
            self.m_hUnit = CreateUnitByName("npc_dota_unit_misterio_remnant", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
            self.m_hUnit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
            self.m_hUnit:SetUnitCanRespawn(false)

            self.m_hUnit:AddParticles()

            self.m_hUnit:AddNewModifier(self:GetCaster(), self, "modifier_misterio_mirror_remnant", nil)

            self.m_hUnit:MoveToPosition(self.m_vector)
        end)

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_misterio_mirror_remnant_invis", {duration = self.m_duration})
    end 
end

---@class modifier_misterio_mirror_remnant
modifier_misterio_mirror_remnant = class({})

modifier_misterio_mirror_remnant.m_flDamage = 0

function modifier_misterio_mirror_remnant:IsHidden() return true end
function modifier_misterio_mirror_remnant:IsPurgable() return false end
function modifier_misterio_mirror_remnant:RemoveOnDeath() return false end

function modifier_misterio_mirror_remnant:OnCreated(params)
    if IsServer() then 
        self.m_flDamage = (self:GetParent():GetMaxHealth() / 100) * self:GetAbility():GetSpecialValueFor("damage_ptc")
    end 
end

function modifier_misterio_mirror_remnant:DeclareFunctions ()
    return { MODIFIER_EVENT_ON_HERO_KILLED }
end

function modifier_misterio_mirror_remnant:OnHeroKilled(params)
    if IsServer() then
        if params.target == self:GetParent() then
            local target = prams.attacker
            
            ApplyDamage({
                attaker = self:GetCaster(),
                victim = target,
                ability = self:GetAbility(),
                damage_type = self:GetAbility():GetAbilityDamageType(),
                damage = self.m_flDamage
            })
		end
    end 
end

---@class modifier_misterio_mirror_remnant_invis

modifier_misterio_mirror_remnant_invis = class({})

local MOVESPEED = 525
local INVISIBILITY_LEVEL = 1
local CHECK_TIME = 0.1

function modifier_misterio_mirror_remnant_invis:IsHidden() return false end
function modifier_misterio_mirror_remnant_invis:IsPurgable() return false end
function modifier_misterio_mirror_remnant_invis:RemoveOnDeath() return true end

function modifier_misterio_mirror_remnant_invis:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(CHECK_TIME)
    end 
end

function modifier_misterio_mirror_remnant_invis:OnIntervalThink()
    if IsServer() then
        if not self:GetAbility().m_hUnit then self:Destroy() end 
    end 
end

function modifier_misterio_mirror_remnant_invis:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
    }

    return funcs
end

function modifier_misterio_mirror_remnant_invis:GetModifierPersistentInvisibility(args)
    return INVISIBILITY_LEVEL
end

function modifier_misterio_mirror_remnant_invis:GetModifierMoveSpeed_Absolute(args)
    return MOVESPEED
end

function modifier_misterio_mirror_remnant_invis:GetModifierInvisibilityLevel(args)
    return INVISIBILITY_LEVEL
end

function modifier_misterio_mirror_remnant_invis:CheckState()
	local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}

	return state
end