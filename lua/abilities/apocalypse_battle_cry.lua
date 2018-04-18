apocalypse_battle_cry = class({})
LinkLuaModifier( "modifier_apocalypse_battle_cry", "abilities/apocalypse_battle_cry.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function apocalypse_battle_cry:OnSpellStart()
	local radius = 99999
	local duration = self:GetSpecialValueFor(  "duration_tooltip" )

	local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #allies > 0 then
		for _,ally in pairs(allies) do
			ally:AddNewModifier( self:GetCaster(), self, "modifier_apocalypse_battle_cry", { duration = duration } )
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

function apocalypse_battle_cry:GetAbilityTextureName()
	return "custom/apocalypse_battle_cry"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if modifier_apocalypse_battle_cry == nil then modifier_apocalypse_battle_cry = class({}) end

--------------------------------------------------------------------------------

function modifier_apocalypse_battle_cry:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end


function modifier_apocalypse_battle_cry:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_apocalypse_battle_cry:GetModifierMagicalResistanceBonus( params )
	return self:GetAbility():GetSpecialValueFor("magical_armor")
end

function modifier_apocalypse_battle_cry:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("speed_bonus")
end

--------------------------------------------------------------------------------

function modifier_apocalypse_battle_cry:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end

--------------------------------------------------------------------------------

function modifier_apocalypse_battle_cry:GetModifierConstantHealthRegen( params )
	return self:GetAbility():GetSpecialValueFor("self_regen")
end

function apocalypse_battle_cry:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

