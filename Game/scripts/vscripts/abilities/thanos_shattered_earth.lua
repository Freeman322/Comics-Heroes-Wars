---@class thanos_shattered_earth
---@author Freeman
LinkLuaModifier( "modifier_thanos_shattered_earth", "abilities/thanos_shattered_earth.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_thanos_shattered_earth_aura", "abilities/thanos_shattered_earth.lua", LUA_MODIFIER_MOTION_NONE )

thanos_shattered_earth = class({})

thanos_shattered_earth.m_iChannelTime = 1.0

function thanos_shattered_earth:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function thanos_shattered_earth:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end
function thanos_shattered_earth:GetChannelTime() return self.m_iChannelTime end
function thanos_shattered_earth:OnAbilityPhaseStart() return true end

function thanos_shattered_earth:OnChannelFinish( bInterrupted )
	if not bInterrupted then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_thanos_shattered_earth", {duration = self:GetSpecialValueFor("fade_duration")})
	end
end
