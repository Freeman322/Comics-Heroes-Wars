pudge_decay = class({})

LinkLuaModifier( "modifier_pudge_decay", "abilities/pudge_decay.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function pudge_decay:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function pudge_decay:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_pudge_decay", nil )

		if not self:GetCaster():IsChanneling() then
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_ROT )
		end
	else
		local hRotBuff = self:GetCaster():FindModifierByName( "modifier_pudge_decay" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end

modifier_pudge_decay = class({})
--------------------------------------------------------------------------------

function modifier_pudge_decay:IsDebuff()
	return true
end


function modifier_pudge_decay:IsPurgable(  )
	return false
end
--------------------------------------------------------------------------------

function modifier_pudge_decay:IsAura()
	if self:GetCaster() == self:GetParent() then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

function modifier_pudge_decay:GetModifierAura()
	return "modifier_pudge_decay"
end

--------------------------------------------------------------------------------

function modifier_pudge_decay:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_pudge_decay:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifier_pudge_decay:GetAuraRadius()
	return self.rot_radius
end

--------------------------------------------------------------------------------

function modifier_pudge_decay:OnCreated( kv )
	self.rot_radius = self:GetAbility():GetSpecialValueFor( "decay_radius" )
	self.rot_slow = self:GetAbility():GetSpecialValueFor( "decay_slow" )
	self.rot_damage = self:GetAbility():GetSpecialValueFor( "decay_damage" )/100
	self.rot_tick = self:GetAbility():GetSpecialValueFor( "decay_tick" )

	if IsServer() then
		local particle = "particles/units/heroes/hero_pudge/pudge_rot.vpcf"
		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "champion_of_nurgle") == true then particle = "particles/econ/items/pudge/pudge_immortal_arm/pudge_immortal_arm_rot.vpcf" end 
		if self:GetParent() == self:GetCaster() then
			EmitSoundOn( "Hero_Pudge.Rot", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.rot_radius, 1, self.rot_radius ) )
			self:AddParticle( nFXIndex, false, false, -1, false, false )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			self:AddParticle( nFXIndex, false, false, -1, false, false )
		end

		self:StartIntervalThink( self.rot_tick )
		self:OnIntervalThink()
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_decay:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Pudge.Rot", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_decay:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_pudge_decay:GetModifierMoveSpeedBonus_Percentage( params )
	if self:GetParent() == self:GetCaster() then
		return 0
	end

	return self.rot_slow
end

--------------------------------------------------------------------------------

function modifier_pudge_decay:OnIntervalThink()
	if IsServer() then
		local flDamagePerTick = self.rot_tick * (self.rot_damage*self:GetCaster():GetMaxHealth())
		local flDamagePerTick = flDamagePerTick + (self:GetAbility():GetSpecialValueFor("damage")/10)
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

function pudge_decay:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

