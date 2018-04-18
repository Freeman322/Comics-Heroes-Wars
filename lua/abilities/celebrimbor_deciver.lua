if celebrimbor_deciver == nil then celebrimbor_deciver = class({}) end

LinkLuaModifier ("modifier_celebrimbor_deciver", "abilities/celebrimbor_deciver.lua" , LUA_MODIFIER_MOTION_NONE)

function celebrimbor_deciver:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function celebrimbor_deciver:OnSpellStart()
  local hTarget = self:GetCaster():GetCursorPosition()

  local nFXIndex = ParticleManager:CreateParticle( "particles/celembribor/deciver_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
  ParticleManager:SetParticleControl( nFXIndex, 0, hTarget );
  ParticleManager:SetParticleControl( nFXIndex, 1, hTarget );
  ParticleManager:SetParticleControl( nFXIndex, 2, hTarget );
  ParticleManager:SetParticleControl( nFXIndex, 3, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 0) );
  ParticleManager:ReleaseParticleIndex( nFXIndex );

  EmitSoundOn( "Hero_DarkWillow.Ley.Cast", self:GetCaster() )

  local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget, self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false )
	if #units > 0 then
		for _,target in pairs(units) do
			if target:GetUnitName() ~= "npc_dota_roshan" then
				local unit = CreateUnitByName( target:GetUnitName(), target:GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
		        unit:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)
		        unit:AddNewModifier( self:GetCaster(), self, "modifier_celebrimbor_deciver", nil )

				local nFXIndex = ParticleManager:CreateParticle( "particles/celembribor/overseer.vpcf", PATTACH_CUSTOMORIGIN, unit );
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
				ParticleManager:SetParticleControlEnt( nFXIndex, 3, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
				ParticleManager:ReleaseParticleIndex( nFXIndex );

				EmitSoundOn( "Hero_DarkWillow.Ley.Target", unit)

				target:Kill(self, self:GetCaster())
			end
		end
	end
end

if modifier_celebrimbor_deciver == nil then
    modifier_celebrimbor_deciver = class ( {})
end

function modifier_celebrimbor_deciver:IsHidden ()
    return true
end

function modifier_celebrimbor_deciver:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

--------------------------------------------------------------------------------

function modifier_celebrimbor_deciver:StatusEffectPriority()
	return 900
end


function modifier_celebrimbor_deciver:GetHeroEffectName()
	return "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_trigger_hero_effect.vpcf"
end

function modifier_celebrimbor_deciver:GetEffectName()
	return "pparticles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf"
end

function modifier_celebrimbor_deciver:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_celebrimbor_deciver:HeroEffectPriority()
	return 90
end

function modifier_celebrimbor_deciver:OnCreated()
	if IsServer() then 

	end
end

function modifier_celebrimbor_deciver:CheckState()
	local state = {
	[MODIFIER_STATE_DOMINATED] = true,
	}

	return state
end

function modifier_celebrimbor_deciver:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_celebrimbor_deciver:GetModifierExtraHealthBonus( params )
	return self:GetAbility():GetSpecialValueFor("creature_bonus_health")
end

--------------------------------------------------------------------------------

function modifier_celebrimbor_deciver:GetModifierBaseAttack_BonusDamage( params )
	return self:GetAbility():GetSpecialValueFor("creature_bonus_damage")
end

function celebrimbor_deciver:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 
