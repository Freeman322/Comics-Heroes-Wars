LinkLuaModifier( "modifier_dimm_ancient_contract_ally", "abilities/dimm_ancient_contract.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dimm_ancient_contract_enemy", "abilities/dimm_ancient_contract.lua", LUA_MODIFIER_MOTION_NONE )

dimm_ancient_contract = class({})

function dimm_ancient_contract:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function dimm_ancient_contract:GetCooldown( nLevel )
    if self:GetCaster():HasModifier("modifier_special_bonus_unique_gaunter_odimm") then
        return 15
    end

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
	if hTarget ~= nil then
		local duration = self:GetSpecialValueFor( "duration" )
		if hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_dimm_ancient_contract_ally", { duration = duration } )
		else
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_dimm_ancient_contract_enemy", { duration = duration } )
		end
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

function modifier_dimm_ancient_contract_enemy:OnCreated()
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/dimm/dimm_ancient_contract.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 8, Vector(1, 0, 0))
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_dimm_ancient_contract_enemy:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_dimm_ancient_contract_enemy:OnAttackLanded (params)
    if IsServer () then
		if self:GetParent() == params.attacker then
			local target = params.target
			if target:GetHealth() <= params.damage then
				self:GetParent():Kill(self:GetAbility(), self:GetCaster())
				local particle_lifesteal = "particles/units/heroes/hero_oracle/oracle_purifyingflames_flash.vpcf"
				local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent():GetAbsOrigin())
				ParticleManager:SetParticleControl(lifesteal_fx, 1, self:GetParent():GetAbsOrigin())
				EmitSoundOn("Hero_Oracle.PurifyingFlames.Damage", self:GetParent())
				EmitSoundOn("DOTA_Item.Bloodthorn.Activate", self:GetParent())

				if self:GetCaster():HasModifier("modifier_dimm_demons_power") then
					local mod = self:GetCaster():FindModifierByName("modifier_dimm_demons_power")
           			mod:SetStackCount(mod:GetStackCount() + self:GetAbility():GetSpecialValueFor("modifier_buff"))
				end
				if target:IsAlive() then
					target:Kill(self:GetAbility(), self:GetParent())
				end
			end
		end
    end

    return 0
end

if modifier_dimm_ancient_contract_ally == nil then modifier_dimm_ancient_contract_ally = class({}) end

function modifier_dimm_ancient_contract_ally:IsHidden()
	return false
	-- body
end

function modifier_dimm_ancient_contract_ally:IsPurgable()
	return false
	-- body
end

function modifier_dimm_ancient_contract_ally:OnCreated(table)
	if IsServer() then
		self.hp = self:GetCaster():GetMaxHealth()
	end
end

function modifier_dimm_ancient_contract_ally:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	}

	return funcs
end

function modifier_dimm_ancient_contract_ally:GetModifierExtraHealthBonus( params )
	return self.hp/2
end

function modifier_dimm_ancient_contract_ally:OnDestroy()
    if IsServer () then
		self:GetParent():Kill(self:GetAbility(), self:GetCaster())
		local particle_lifesteal = "particles/units/heroes/hero_oracle/oracle_purifyingflames_flash.vpcf"
		local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(lifesteal_fx, 1, self:GetParent():GetAbsOrigin())
		EmitSoundOn("Hero_Oracle.PurifyingFlames.Damage", self:GetParent())
		EmitSoundOn("DOTA_Item.Bloodthorn.Activate", self:GetParent())

		if self:GetCaster():HasModifier("modifier_dimm_demons_power") then
			local mod = self:GetCaster():FindModifierByName("modifier_dimm_demons_power")
			mod:SetStackCount(mod:GetStackCount() + self:GetAbility():GetSpecialValueFor("modifier_buff"))
		end
    end
end

function dimm_ancient_contract:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

