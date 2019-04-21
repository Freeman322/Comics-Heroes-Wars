if item_ultimate_scepter == nil then
	item_ultimate_scepter = class({})
end

LinkLuaModifier( "modifier_ability_layout_bonus", "items/modifier_ability_layout_bonus.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_aghanim", "modifiers/modifier_aghanim.lua", LUA_MODIFIER_MOTION_NONE)

function item_ultimate_scepter:CastFilterResultTarget( hTarget )

	if hTarget:HasModifier("modifier_item_ultimate_scepter_consumed") then
		return UF_FAIL_CUSTOM
	end

	if hTarget:GetUnitName() == "npc_dota_hero_razor" then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function item_ultimate_scepter:GetCustomCastErrorTarget( hTarget )
	if hTarget:HasModifier("modifier_item_ultimate_scepter_consumed") then
		return "#dota_hud_error_cant_cast_scepter_buff"
	end

	if hTarget:GetUnitName() == "npc_dota_hero_razor" then
		return "#dota_hud_error_cant_cast_on_zoom"
	end

	return ""
end


function item_ultimate_scepter:GetBehavior()
	if self:GetCaster():GetUnitName() == "npc_dota_hero_alchemist" then
			behav = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	else
		  behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return behav
end

function item_ultimate_scepter:GetIntrinsicModifierName()
	return "modifier_item_ultimate_scepter"
end

function item_ultimate_scepter:OnSpellStart()
	local target = self:GetCursorTarget()
  	target:AddNewModifier( self:GetCaster(), self, "modifier_aghanim", nil )
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    EmitSoundOn( "Hero_Alchemist.Scepter.Cast", self:GetCaster() )
	self:RemoveSelf()
end

function item_ultimate_scepter:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

