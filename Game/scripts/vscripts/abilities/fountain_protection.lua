LinkLuaModifier("modifier_fountain_protection", "abilities/fountain_protection.lua", 0)
LinkLuaModifier("modifier_fountain_protection_aura", "abilities/fountain_protection.lua", 0)
LinkLuaModifier("modifier_fountain_death_delay", "abilities/fountain_protection.lua", 0)

local CONST_DAMAGE_OUTGOING_PTC = -100
local CONST_DELAY = 0.17
local CONST_DELAY_STOP = -1
local CONST_DAMAGE = 5.0
local CONST_BASE_DAMAGE = 250

fountain_protection = class({
    GetIntrinsicModifierName = function() return "modifier_fountain_protection" end
})

function fountain_protection:OnProjectileHit(hTarget, vLocation)
    if IsServer() then
        if hTarget and not hTarget:IsNull() then
            EmitSoundOn("Item_Desolator.Target", hTarget)

            local ptc = ((hTarget:GetMaxHealth() * CONST_DAMAGE) / 100) + CONST_BASE_DAMAGE

            hTarget:ModifyHealth(hTarget:GetHealth() - ptc, self, true, 0)
        end
    end
end

modifier_fountain_protection = class({
    IsHidden = function() return true end,
    IsAura = function() return true end,
    IsPurgable = function() return false end,
    GetAuraSearchTeam = function() return DOTA_UNIT_TARGET_TEAM_BOTH end,
    GetAuraSearchType = function() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
    GetAuraSearchFlags = function() return 16 + 64 + 262144 end,
    GetModifierAura = function() return "modifier_fountain_protection_aura" end
})

function modifier_fountain_protection:GetAuraRadius() if self:GetParent():GetTeam() == DOTA_TEAM_BADGUYS then return 1350 end return 1200 end

modifier_fountain_protection_aura = class({
    DeclareFunctions = function() return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end,
    GetEffectName = function() return "particles/econ/events/ti5/radiant_fountain_regen_lvl2_ti5.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end
})

function modifier_fountain_protection_aura:OnCreated() 
    if IsServer() and not self:GetParent():IsFriendly(self:GetCaster()) then
        self:StartIntervalThink(CONST_DELAY)
        self:OnIntervalThink()
    end 
end

function modifier_fountain_protection_aura:GetModifierIncomingDamage_Percentage() return CONST_DAMAGE_OUTGOING_PTC end
function modifier_fountain_protection_aura:GetModifierTotalDamageOutgoing_Percentage() return CONST_DAMAGE_OUTGOING_PTC end

function modifier_fountain_protection_aura:OnIntervalThink() 
    if IsServer() then
        local info = 
        {
            Target = self:GetParent(),
            Source = self:GetCaster(),
            Ability = self:GetCaster():GetAbilityByIndex(0),	
            EffectName = "particles/items_fx/desolator_projectile.vpcf",
            iMoveSpeed = 1400,
            vSourceLoc= self:GetCaster():GetAbsOrigin(),                -- Optional (HOW)
            bDrawsOnMinimap = false,                          -- Optional
            bDodgeable = true,                                -- Optional
            bIsAttack = false,                                -- Optional
            bVisibleToEnemies = true,                         -- Optional
            bReplaceExisting = false,                         -- Optional
            flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
            bProvidesVision = true,                           -- Optional
            iVisionRadius = 400,                              -- Optional
            iVisionTeamNumber = self:GetCaster():GetTeamNumber()        -- Optional
        }

        ProjectileManager:CreateTrackingProjectile(info)
    end
end

