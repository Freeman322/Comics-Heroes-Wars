samurai_great_cleave = class({})
LinkLuaModifier( "modifier_samurai_great_cleave", "abilities/samurai_great_cleave.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function samurai_great_cleave:GetIntrinsicModifierName()
	return "modifier_samurai_great_cleave"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_samurai_great_cleave = class({})

--------------------------------------------------------------------------------

function modifier_samurai_great_cleave:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_samurai_great_cleave:OnCreated( kv )
	self.great_cleave_damage = self:GetAbility():GetSpecialValueFor( "great_cleave_damage" )
	self.great_cleave_radius = self:GetAbility():GetSpecialValueFor( "great_cleave_radius" )
end

--------------------------------------------------------------------------------

function modifier_samurai_great_cleave:OnRefresh( kv )
	self.great_cleave_damage = self:GetAbility():GetSpecialValueFor( "great_cleave_damage" )
	self.great_cleave_radius = self:GetAbility():GetSpecialValueFor( "great_cleave_radius" )
end

--------------------------------------------------------------------------------

function modifier_samurai_great_cleave:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_samurai_great_cleave:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local cleaveDamage = ( self.great_cleave_damage * params.damage ) / 100.0
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, self.great_cleave_radius, self.great_cleave_radius, self.great_cleave_radius, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
			end
		end
	end

	return 0
end

function samurai_great_cleave:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

