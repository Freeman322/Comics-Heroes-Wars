if not thanos_decimation then thanos_decimation = class({}) end
LinkLuaModifier( "modifier_thanos_decimation", "abilities/thanos_decimation.lua", LUA_MODIFIER_MOTION_NONE )

function thanos_decimation:OnSpellStart()
	if IsServer() then
		local duration = self:GetDuration()

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_thanos_decimation", { duration = self:GetDuration() } )

		EmitSoundOn( "Thanos.Decimation.Cast", self:GetCaster() )
	end
end

function thanos_decimation:OnAbilityPhaseStart()
	EmitSoundOn( "Thanos.Decimation.Phase", self:GetCaster() )

	return true
end


if modifier_thanos_decimation == nil then modifier_thanos_decimation = class({}) end

function modifier_thanos_decimation:IsDebuff() return false end
function modifier_thanos_decimation:IsHidden() return true end
function modifier_thanos_decimation:IsPurgable() return false end

function modifier_thanos_decimation:OnCreated( kv )
	if IsServer() then
		self.nDamage = 0
	end
end

function modifier_thanos_decimation:OnDestroy()
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_7)

		local radius = self:GetAbility():GetSpecialValueFor("radius")

		local punch_particle = ParticleManager:CreateParticle("particles/hero_thanos/thanos_decimation.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(punch_particle, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(punch_particle, 1, Vector(radius, radius, 1))
		ParticleManager:SetParticleControl(punch_particle, 2, Vector(255, 255, 255))
		ParticleManager:SetParticleControl(punch_particle, 3, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(punch_particle)

		if self:GetAbility():GetCaster():IsHasSuperStatus() then self.nDamage = self.nDamage * 2 end 

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
					enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 2 } )

					local DamageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						ability = self:GetAbility(),
						damage = self.nDamage / #enemies,
						damage_type = DAMAGE_TYPE_PURE,
					}

					ApplyDamage( DamageInfo )
				end
			end
		end

		EmitSoundOn("Hero_ElderTitan.EchoStomp", self:GetCaster())
	end
end

function modifier_thanos_decimation:GetEffectName() return "particles/hero_doctor_fate/fatebind_buff_f.vpcf" end
function modifier_thanos_decimation:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_thanos_decimation:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

function modifier_thanos_decimation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_thanos_decimation:GetOverrideAnimation( params )
	return ACT_DOTA_CHANNEL_ABILITY_6
end

function modifier_thanos_decimation:GetModifierIncomingDamage_Percentage()
    return -100
end

function modifier_thanos_decimation:OnTakeDamage(params)
    if IsServer() then 
        if params.unit == self:GetParent() then
			self.nDamage = (self.nDamage or 0) + params.original_damage
           
            local nFXIndex = ParticleManager:CreateParticle ("thanos_decimation_damage", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex( nFXIndex );  
		end
	end
end

