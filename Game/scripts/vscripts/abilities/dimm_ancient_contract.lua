LinkLuaModifier( "modifier_dimm_ancient_contract_enemy", "abilities/dimm_ancient_contract.lua", LUA_MODIFIER_MOTION_NONE )

dimm_ancient_contract = class({})

function dimm_ancient_contract:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function dimm_ancient_contract:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

--------------------------------------------------------------------------------

function dimm_ancient_contract:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end

function dimm_ancient_contract:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil and not hTarget:TriggerSpellAbsorb (self) then
		local duration = self:GetSpecialValueFor( "duration" )
		if self:GetCaster():HasTalent("special_bonus_unique_dimm") then 
			duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_dimm")
		end
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_dimm_ancient_contract_enemy", { duration = duration } )
		EmitSoundOn( "Hero_DoomBringer.DevourCast", hTarget )
	end
end

modifier_dimm_ancient_contract_enemy = class({})

function modifier_dimm_ancient_contract_enemy:IsHidden()
	return false
end

function modifier_dimm_ancient_contract_enemy:IsBuff()
	return false
end

function modifier_dimm_ancient_contract_enemy:IsPurgable()
	return false
end

function modifier_dimm_ancient_contract_enemy:GetEffectName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf"
end

function modifier_dimm_ancient_contract_enemy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_dimm_ancient_contract_enemy:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

function modifier_dimm_ancient_contract_enemy:StatusEffectPriority()
	return 1000
end

function modifier_dimm_ancient_contract_enemy:OnCreated()
	if IsServer() then

	end
end

function modifier_dimm_ancient_contract_enemy:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_dimm_ancient_contract_enemy:OnTakeDamage (params)
    if IsServer () then
		if self:GetParent() == params.attacker then
			local target = params.unit
			if target:IsAlive() == false then
				self:GetParent():Kill(self:GetAbility(), self:GetCaster())

				if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alma") then
					local nFXIndex = ParticleManager:CreateParticle( "particles/collector/alma_sonic_boom.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
					ParticleManager:SetParticleControl(nFXIndex, 0, self:GetParent():GetAbsOrigin())
					ParticleManager:SetParticleControl(nFXIndex, 1, Vector (450, 450, 0))
					ParticleManager:SetParticleControl(nFXIndex, 2, Vector(255, 0, 0))
					ParticleManager:SetParticleControl(nFXIndex, 3, self:GetParent():GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex( nFXIndex )
			  
					EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Alma.SonicBoom.Cast", self:GetParent() )
			  
				   	return 0
				end

				local particle_lifesteal = "particles/units/heroes/hero_oracle/oracle_purifyingflames_flash.vpcf"
				local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent():GetAbsOrigin())
				ParticleManager:SetParticleControl(lifesteal_fx, 1, self:GetParent():GetAbsOrigin())
				EmitSoundOn("Hero_Oracle.PurifyingFlames.Damage", self:GetParent())
				EmitSoundOn("DOTA_Item.Bloodthorn.Activate", self:GetParent())
			end
		end
    end

    return 0
end
