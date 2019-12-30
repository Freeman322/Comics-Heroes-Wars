if not darkrider_alter_reverse then darkrider_alter_reverse = class({}) end

local MAX_SLOPH_DISTANCE = 128
local FALL_SPEED = 60

LinkLuaModifier( "modifier_darkrider_alter_reverse", "abilities/darkrider_alter_reverse.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_darkrider_alter_reverse_aura_debuff", "abilities/darkrider_alter_reverse.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_darkrider_alter_reverse_aura", "abilities/darkrider_alter_reverse.lua", LUA_MODIFIER_MOTION_NONE )

darkrider_alter_reverse.bInterrupted = false

function darkrider_alter_reverse:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function darkrider_alter_reverse:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end
function darkrider_alter_reverse:GetChannelTime() return self:GetSpecialValueFor("channel") end
function darkrider_alter_reverse:OnSpellStart() if IsServer() then self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_darkrider_alter_reverse_aura", { duration = self:GetChannelTime() } ) end end

function darkrider_alter_reverse:OnChannelFinish( bInterrupted )
     if IsServer() then
          self.bInterrupted = bInterrupted

          if bInterrupted then self:GetCaster():RemoveModifierByName( "modifier_darkrider_alter_reverse_aura" ) end 
     end 
end

if modifier_darkrider_alter_reverse_aura_debuff == nil then modifier_darkrider_alter_reverse_aura_debuff = class({}) end

function modifier_darkrider_alter_reverse_aura_debuff:IsHidden() return true end
function modifier_darkrider_alter_reverse_aura_debuff:IsPurgable() return true end

function modifier_darkrider_alter_reverse_aura_debuff:OnCreated(table)
     if IsServer() then
          self._vLoc = self:GetCaster():GetAbsOrigin()

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_darkrider_alter_reverse_aura_debuff:OnDestroy()
     if IsServer() then
          if self:GetAbility().bInterrupted then return end 

          local damage = self:GetAbility():GetAbilityDamage()

          local kv =
          {
               center_x = self._vLoc.x,
               center_y = self._vLoc.y,
               center_z = self._vLoc.z,
               should_stun = true, 
               duration = self:GetAbility():GetSpecialValueFor("stun_duration"),
               knockback_duration = 0.35,
               knockback_distance = self:GetAbility():GetSpecialValueFor("radius"),
               knockback_height = 250,
          }

          self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", kv )
          
          local damageInfo =
          {
               victim = self:GetParent(),
               attacker = self:GetCaster(),
               damage = damage,
               damage_type = DAMAGE_TYPE_MAGICAL,
               ability = self:GetAbility(),
          }

          ApplyDamage( damageInfo )
	end
end

function modifier_darkrider_alter_reverse_aura_debuff:OnIntervalThink()
	if IsServer() then
          local distance = (self._vLoc - self:GetParent():GetAbsOrigin()):Length2D()

          if distance > MAX_SLOPH_DISTANCE then
               local direction = (self._vLoc - self:GetParent():GetAbsOrigin()):Normalized()

               self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + direction * (FALL_SPEED * FrameTime()))
          end
	end
end

function modifier_darkrider_alter_reverse_aura_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_sylph_wisp_fear.vpcf"
end

function modifier_darkrider_alter_reverse_aura_debuff:StatusEffectPriority()
	return 1000
end

function modifier_darkrider_alter_reverse_aura_debuff:GetEffectName()
	return "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd_debuff.vpcf"
end

function modifier_darkrider_alter_reverse_aura_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_darkrider_alter_reverse_aura_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_darkrider_alter_reverse_aura_debuff:GetOverrideAnimation( params ) return ACT_DOTA_FLAIL end
function modifier_darkrider_alter_reverse_aura_debuff:CheckState() return {[MODIFIER_STATE_COMMAND_RESTRICTED] = true, [MODIFIER_STATE_STUNNED] = true} end

if modifier_darkrider_alter_reverse_aura == nil then modifier_darkrider_alter_reverse_aura = class({}) end

function modifier_darkrider_alter_reverse_aura:IsAura() return true end
function modifier_darkrider_alter_reverse_aura:IsHidden() return true end
function modifier_darkrider_alter_reverse_aura:IsPurgable() return false end
function modifier_darkrider_alter_reverse_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_darkrider_alter_reverse_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_darkrider_alter_reverse_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_darkrider_alter_reverse_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_darkrider_alter_reverse_aura:GetModifierAura() return "modifier_darkrider_alter_reverse_aura_debuff" end

function modifier_darkrider_alter_reverse_aura:OnCreated(params )
     if IsServer() then
          local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/wisp/wisp_relocate_channel_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
          ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
          ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
          ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetOrigin() )
          self:AddParticle( nFXIndex, false, false, -1, false, true )
          
          EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Cast", self:GetCaster())
     end 
end

function modifier_darkrider_alter_reverse_aura:OnDestroy( )
     if IsServer() then
          EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Complete", self:GetParent())
     end 
end