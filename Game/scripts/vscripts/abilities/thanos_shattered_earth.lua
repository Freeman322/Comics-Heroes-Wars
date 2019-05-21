---@class thanos_shattered_earth
---@author Freeman
LinkLuaModifier( "modifier_thanos_shattered_earth", "abilities/thanos_shattered_earth.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_thanos_shattered_earth_caster", "abilities/thanos_shattered_earth.lua", LUA_MODIFIER_MOTION_NONE )

thanos_shattered_earth = class({})

thanos_shattered_earth.m_iChannelTime = 1.0

function thanos_shattered_earth:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function thanos_shattered_earth:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end
function thanos_shattered_earth:GetChannelTime() return self.m_iChannelTime end
function thanos_shattered_earth:OnAbilityPhaseStart() return true end

function thanos_shattered_earth:OnChannelFinish( bInterrupted )
	if not bInterrupted then          
          self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)

          local radius = self:GetSpecialValueFor("epicenter_radius")
          local damage = self:GetSpecialValueFor("damage")

          if self:GetCaster():HasTalent("special_bonus_unique_thanos_1") then radius = radius + self:GetCaster():FindTalentValue("special_bonus_unique_thanos_1") end 
          if self:GetCaster():HasTalent("special_bonus_unique_thanos_2") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_thanos_2") end 

		local punch_particle = ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_magical.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(punch_particle, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(punch_particle, 1, Vector(radius, radius, 1))
		ParticleManager:ReleaseParticleIndex(punch_particle)

          EmitSoundOn("Thanos_EG.ShatteredEarth.Cast", self:GetCaster())
          
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
          if #enemies > 0 then       

			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
                         enemy:AddNewModifier(self:GetCaster(), self, "modifier_thanos_shattered_earth", {damage = damage, duration = self:GetSpecialValueFor("fade_duration")})
				end
			end
          end

          self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_thanos_shattered_earth_caster", {duration = self:GetSpecialValueFor("fade_duration")})
          
          Timers:CreateTimer(self:GetSpecialValueFor("fade_duration"), function()
               self:Explode(radius)
          end)
	end
end

function thanos_shattered_earth:Explode(radius)
     if IsServer() then
          local punch_particle = ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(punch_particle, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(punch_particle, 1, Vector(radius, radius, 1))
		ParticleManager:ReleaseParticleIndex(punch_particle)

          EmitSoundOn("Hero_ElderTitan.EchoStomp", self:GetCaster())
     end 
end

---@class modifier_thanos_shattered_earth
---

modifier_thanos_shattered_earth = class({})

local VISUAL_Z_DELTA = 150

modifier_thanos_shattered_earth.m_iDamage = 1

function modifier_thanos_shattered_earth:IsHidden() return false end
function modifier_thanos_shattered_earth:IsPurgable() return false end
function modifier_thanos_shattered_earth:RemoveOnDeath() return false end
function modifier_thanos_shattered_earth:IsDebuff() return true end
function modifier_thanos_shattered_earth:IsStunDebuff() return true end

function modifier_thanos_shattered_earth:OnCreated(params)
    if IsServer() then
		self.m_iDamage = params.damage
     end 
end

function modifier_thanos_shattered_earth:OnDestroy()
    if IsServer() then
          EmitSoundOn( "Hero_Rubick.Telekinesis.Target.Land", self.m_hTarget )
          
          local kv =
          {
               center_x = self:GetParent():GetAbsOrigin().x,
               center_y = self:GetParent():GetAbsOrigin().y,
               center_z = self:GetParent():GetAbsOrigin().z,
               should_stun = true, 
               duration = self:GetAbility():GetSpecialValueFor("stun_duration"),
               knockback_duration = 1,
               knockback_distance = self:GetAbility():GetSpecialValueFor("epicenter_radius"),
               knockback_height = VISUAL_Z_DELTA,
          }

          self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", kv )

          local DamageInfo =
          {
               victim = self:GetParent(),
               attacker = self:GetCaster(),
               ability = self:GetAbility(),
               damage = ((self.m_iDamage / 100) * self:GetParent():GetMaxHealth()) + self:GetAbility():GetAbilityDamage(),
               damage_type = DAMAGE_TYPE_PURE,
               damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION  + DOTA_DAMAGE_FLAG_HPLOSS 
          }

          ApplyDamage( DamageInfo )
    end 
end

function modifier_thanos_shattered_earth:GetEffectName()
	return "particles/units/heroes/hero_rubick/rubick_telekinesis.vpcf"
end

function modifier_thanos_shattered_earth:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_thanos_shattered_earth:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}

	return funcs
end

function modifier_thanos_shattered_earth:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

function modifier_thanos_shattered_earth:GetVisualZDelta(params)
	return VISUAL_Z_DELTA
end

function modifier_thanos_shattered_earth:CheckState()
	local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

modifier_thanos_shattered_earth_caster = class({})
function modifier_thanos_shattered_earth_caster:IsHidden() return true end
function modifier_thanos_shattered_earth_caster:IsPurgable() return false end
function modifier_thanos_shattered_earth_caster:RemoveOnDeath() return true end

function modifier_thanos_shattered_earth_caster:CheckState()
	local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end
