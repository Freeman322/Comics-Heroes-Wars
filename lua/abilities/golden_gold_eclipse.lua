golden_gold_eclipse = class({})
LinkLuaModifier ("modifier_golden_gold_eclipse", "abilities/golden_gold_eclipse.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function golden_gold_eclipse:CastFilterResultTarget( hTarget )
	if IsServer() then

		if hTarget ~= nil and hTarget:IsMagicImmune() and ( not self:GetCaster():HasScepter() ) then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function golden_gold_eclipse:GetCastRange( vLocation, hTarget )
	if self:GetCaster():HasScepter() then
		return 1200
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function golden_gold_eclipse:GetAbilityDamageType()
	if self:GetCaster():HasScepter() then
		return 4
	end

	return 2
end

function golden_gold_eclipse:GetManaCost( hTarget )
	if 	self:GetCaster():HasScepter() then
			return 0
	else
			return self.BaseClass.GetManaCost( self, hTarget )
	end
end
--------------------------------------------------------------------------------

function golden_gold_eclipse:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then 
			local damage_delay = self:GetSpecialValueFor( "damage_delay" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_golden_gold_eclipse", { duration = damage_delay } )
			EmitSoundOn( "chw.golden_god_ulti", hTarget )
		end
		if self:GetCaster():HasModifier("modifier_arcana") then
			local nFXIndex = ParticleManager:CreateParticle( "particles/goldengod/hypernova/arcana_hypernova.vpcf", PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
			ParticleManager:SetParticleControl(nFXIndex, 2, Vector(1, 0, 0));
			ParticleManager:SetParticleControl(nFXIndex, 3, self:GetCaster():GetOrigin());
			ParticleManager:SetParticleControl(nFXIndex, 4, self:GetCaster():GetOrigin());
			ParticleManager:ReleaseParticleIndex( nFXIndex );
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/golden_gold_hypernova_discharge.vpcf", PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
			ParticleManager:SetParticleControl(nFXIndex, 2, self:GetCaster():GetOrigin());
			ParticleManager:SetParticleControl(nFXIndex, 3, Vector(1, 0, 0));
			ParticleManager:SetParticleControl(nFXIndex, 4, self:GetCaster():GetOrigin());
			ParticleManager:ReleaseParticleIndex( nFXIndex );
		end

		EmitSoundOn( "chw.golden_god_ulti", self:GetCaster() )
	end
	self:EndCooldown()
	if self:GetCaster():HasScepter() then 
		self:StartCooldown(self:GetSpecialValueFor("cooldown_scepter"))
	else
		self:StartCooldown(self:GetSpecialValueFor("cooldown"))
	end
end

modifier_golden_gold_eclipse = class ({})

--------------------------------------------------------------------------------

function modifier_golden_gold_eclipse:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_golden_gold_eclipse:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_golden_gold_eclipse:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_golden_gold_eclipse:OnDestroy()
	if IsServer() then
		local damage_mult = self:GetAbility():GetSpecialValueFor("damage_mult")
		local nCaster_damage = self:GetCaster():GetHealth()
		local nDamageType = DAMAGE_TYPE_MAGICAL
		if self:GetCaster():HasScepter() then
			damage_mult = self:GetAbility():GetSpecialValueFor("damage_mult")
			nCaster_damage = self:GetCaster():GetMaxHealth()
			nDamageType = DAMAGE_TYPE_PURE
		end

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = nCaster_damage*damage_mult,
			damage_type = nDamageType,
			damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
			ability = self:GetAbility()
		}
		ApplyDamage( damage )
		local caster = self:GetCaster()
		local target = self:GetParent()
		local explosion = ParticleManager:CreateParticle("particles/golden_god_reborn.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(explosion, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(explosion, 1, Vector(1, 1, 1))
		ParticleManager:SetParticleControl(explosion, 3, target:GetAbsOrigin())
		caster:SetAbsOrigin(target:GetAbsOrigin())
		caster:SetHealth(caster:GetMaxHealth())
		caster:SetMana(caster:GetMaxMana())
		local point = self:GetParent():GetAbsOrigin()
		FindClearSpaceForUnit( caster, point, false )

		for i=0, 2, 1 do  --The maximum number of abilities a unit can have is currently 16.
		local current_ability = caster:GetAbilityByIndex(i)
			if current_ability ~= nil then
				current_ability:EndCooldown()
			end
		end
	end
end

function golden_gold_eclipse:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/goldengod_hypernova_arcana"
	end
	return self.BaseClass.GetAbilityTextureName(self)
end