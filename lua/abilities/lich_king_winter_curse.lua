LinkLuaModifier ("modifier_lich_king_winter_curse", "abilities/lich_king_winter_curse.lua", LUA_MODIFIER_MOTION_NONE)
lich_king_winter_curse = class({})

function lich_king_winter_curse:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function lich_king_winter_curse:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_lich_king_winter_curse", nil )

		if not self:GetCaster():IsChanneling() then
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_ROT )
		end
	else
		local hRotBuff = self:GetCaster():FindModifierByName( "modifier_lich_king_winter_curse" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end

modifier_lich_king_winter_curse = class({})
--------------------------------------------------------------------------------

function modifier_lich_king_winter_curse:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_lich_king_winter_curse:IsAura()
	if self:GetCaster() == self:GetParent() then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

function modifier_lich_king_winter_curse:GetModifierAura()
	return "modifier_lich_king_winter_curse"
end

--------------------------------------------------------------------------------

function modifier_lich_king_winter_curse:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_lich_king_winter_curse:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifier_lich_king_winter_curse:GetAuraRadius()
	return self.rot_radius
end

--------------------------------------------------------------------------------

function modifier_lich_king_winter_curse:OnCreated( kv )
	self.rot_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.rot_slow = self:GetAbility():GetSpecialValueFor( "rot_slow" )
	self.rot_damage = self:GetAbility():GetSpecialValueFor( "tooltip_damage" )
	self.rot_tick = 0.1

	if IsServer() then
		if self:GetParent() == self:GetCaster() then
			EmitSoundOn( "Hero_Crystal.FreezingField.Arcana", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.rot_radius, 1, self.rot_radius ) )
			ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin())
			self:AddParticle( nFXIndex, false, false, -1, false, false )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			self:AddParticle( nFXIndex, false, false, -1, false, false )
		end

		self:StartIntervalThink( self.rot_tick )
		self:OnIntervalThink()
		if self:GetCaster():HasScepter() then
			self.rot_radius = self.rot_radius + 100
		end
	end
end

--------------------------------------------------------------------------------

function modifier_lich_king_winter_curse:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Crystal.FreezingField.Arcana", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function modifier_lich_king_winter_curse:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_lich_king_winter_curse:GetModifierMoveSpeedBonus_Percentage( params )
	if self:GetParent() == self:GetCaster() then
		return 0
	end

	return self.rot_slow
end

--------------------------------------------------------------------------------

function modifier_lich_king_winter_curse:OnIntervalThink()
	if IsServer() then
		local flDamagePerTick = self.rot_tick * self.rot_damage

		if self:GetCaster():IsAlive() then
			local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = flDamagePerTick,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

			ApplyDamage( damage )
		end
	end
end

function lich_king_winter_curse:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

