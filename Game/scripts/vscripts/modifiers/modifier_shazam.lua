LinkLuaModifier( "modifier_shazam_debuff", "modifiers/modifier_shazam.lua", LUA_MODIFIER_MOTION_NONE )

modifier_shazam = class({}) 

local UPDATE_TIME = 0.1
local RADIUS = 230
local UPDATE_TIME_SEARCH = 0.3333
local SLOW_DUR = 3.5

local STATE = {}
STATE.HAS_ENEMIES = 1
STATE.CLEAR = 0

local PEROPERTIES = {}
PEROPERTIES.DAMAGE = -99
PEROPERTIES.HEALTH = -0.99
PEROPERTIES.SLOWING = -25

modifier_shazam.m_arrayAbils = {}

function modifier_shazam:RemoveOnDeath() return false end
function modifier_shazam:IsPurgable() return false end
function modifier_shazam:IsHidden() return true end

function modifier_shazam:OnCreated(params)
     if IsServer() then
          for i = 0, 2 do
               table.insert( self.m_arrayAbils, self:GetParent():GetAbilityByIndex(i) )
          end

          self:StartIntervalThink(UPDATE_TIME)

          self:GetParent():SetContextThink("Update", function()
               return self:OnEntityThink()
          end, UPDATE_TIME_SEARCH)
     end 
end

function modifier_shazam:IsInShazamForm()
     return self:GetParent():HasModifier("modifier_shazam_shazam")
end

function modifier_shazam:IsInFear()
     return self:GetStackCount() == STATE.HAS_ENEMIES
end

function modifier_shazam:OnIntervalThink()
     if IsServer() then
          for _, abil in pairs(self.m_arrayAbils) do
               abil:SetActivated(self:IsInShazamForm())
          end
     end 
end

function modifier_shazam:OnEntityThink()
     if IsServer() then
          local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
          if #units > 0 then
               self:SetStackCount(STATE.HAS_ENEMIES) return UPDATE_TIME_SEARCH
          end

          self:SetStackCount(STATE.CLEAR)
     end 

     return UPDATE_TIME_SEARCH
end

function modifier_shazam:DeclareFunctions ()
     local funcs = {
         MODIFIER_EVENT_ON_ATTACK_LANDED,
         MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
         MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
     }
 
     return funcs
 end
 
 function modifier_shazam:OnAttackLanded(params)
     if IsServer() then
          if params.attacker == self:GetParent() and not self:IsInShazamForm() then
               params.target:AddNewModifier(self:GetParent(), nil, "modifier_shazam_debuff", {duration = SLOW_DUR})
          end 
     end 
end
 
--------------------------------------------------------------------------------

function modifier_shazam:CheckState()
     if self:IsInFear() and not self:IsInShazamForm() then
	     return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_UNSELECTABLE] = true, [MODIFIER_STATE_OUT_OF_GAME] = true}
     end 

	return 
end

function modifier_shazam:GetModifierExtraHealthPercentage(params) if self:IsInFear() and not self:IsInShazamForm() then return PEROPERTIES.HEALTH end return end
function modifier_shazam:GetModifierTotalDamageOutgoing_Percentage(params) if self:IsInFear() and not self:IsInShazamForm() then return PEROPERTIES.DAMAGE end return end


modifier_shazam_debuff = class({}) 

function modifier_shazam_debuff:IsBuff() return false end
function modifier_shazam_debuff:GetTexture () return "item_skadi" end
function modifier_shazam_debuff:GetStatusEffectName () return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_shazam_debuff:StatusEffectPriority () return 1000 end
function modifier_shazam_debuff:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_shazam_debuff:OnCreated( params )
     if IsServer() then
          local fx = ParticleManager:CreateParticleForPlayer("particles/shazam/snow/snow_indicator.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetParent():GetOwner())
          self:AddParticle(fx, false, false, -1, false, false)
     end 
end

function modifier_shazam_debuff:GetModifierMoveSpeedBonus_Percentage (params) return PEROPERTIES.SLOWING end
function modifier_shazam_debuff:GetModifierAttackSpeedBonus_Constant (params)  return PEROPERTIES.SLOWING end
function modifier_shazam_debuff:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_shazam_debuff:GetEffectName()
     return "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_frost_arrow_debuff.vpcf"
end

function modifier_shazam_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end