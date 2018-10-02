LinkLuaModifier( "black_flash_speedforce_punishment_aura",              "abilities/black_flash_speedforce_punishment.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_black_flash_speedforce_punishment",          "abilities/black_flash_speedforce_punishment.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_black_flash_speedforce_punishment_precast",  "abilities/black_flash_speedforce_punishment.lua",LUA_MODIFIER_MOTION_NONE )

black_flash_speedforce_punishment = class({})

function black_flash_speedforce_punishment:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function black_flash_speedforce_punishment:GetIntrinsicModifierName()
	return "black_flash_speedforce_punishment_aura"
end

function black_flash_speedforce_punishment:IsStealable()
	return false
end

function black_flash_speedforce_punishment:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

function black_flash_speedforce_punishment:CastFilterResultTarget( hTarget )
	if IsServer() then

		if hTarget ~= nil and hTarget:IsMagicImmune() and ( not self:GetCaster():HasScepter() ) then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		if hTarget:IsIllusion() then
			return UF_FAIL_ILLUSION
		end

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
	return UF_SUCCESS
end

function black_flash_speedforce_punishment:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function black_flash_speedforce_punishment:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 90
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end


function black_flash_speedforce_punishment:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
		local nFXIndex = ParticleManager:CreateParticle( "particles/scarlet_witch_flux.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl(nFXIndex, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 1, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 2, Vector(400, 0, 0))
		ParticleManager:SetParticleControl(nFXIndex, 3, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( nFXIndex );
		self.hVictim:AddNewModifier(self:GetCaster(), self, "modifier_black_flash_speedforce_punishment_precast", {duration = self:GetCastPoint()})
		EmitSoundOn( "Hero_Necrolyte.ReapersScythe.Cast", self:GetCaster() )
	end

	return true
end

function black_flash_speedforce_punishment:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			local damage = self:GetSpecialValueFor("damage")/100
			local nFXIndex = ParticleManager:CreateParticle( "particles/black_flash/black_flash_speedforce_punishment_target.vpcf", PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControl(nFXIndex, 0, hTarget:GetAbsOrigin())
			ParticleManager:SetParticleControl(nFXIndex, 1, Vector(400, 400, 0))
			ParticleManager:SetParticleControl(nFXIndex, 3, hTarget:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex( nFXIndex );

			EmitSoundOn( "Hero_Necrolyte.DeathPulse", self:GetCaster() )

			local nFXIndex1 = ParticleManager:CreateParticle("particles/black_flash/black_flash_speedforce_punishment_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControlEnt( nFXIndex1, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
			ParticleManager:SetParticleControlEnt( nFXIndex1, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
			ParticleManager:SetParticleControl(nFXIndex1, 2, hTarget:GetOrigin())
			ParticleManager:SetParticleControl(nFXIndex1, 3, hTarget:GetOrigin())
			ParticleManager:SetParticleControl(nFXIndex1, 4, hTarget:GetOrigin())
			ParticleManager:ReleaseParticleIndex( nFXIndex );
			local DamageTable = {
				attacker = self:GetCaster(),
				victim = hTarget,
				ability = self,
				damage = damage*_G.speedforce_table[hTarget],
				damage_type = DAMAGE_TYPE_MAGICAL
			}
				ApplyDamage(DamageTable)
		end
	end
end

black_flash_speedforce_punishment_aura = class({})

function black_flash_speedforce_punishment_aura:IsAura()
	return true
end

function black_flash_speedforce_punishment_aura:IsHidden()
	return true
end

function black_flash_speedforce_punishment_aura:GetAuraRadius()
	return 99999
end

function black_flash_speedforce_punishment_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function black_flash_speedforce_punishment_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function black_flash_speedforce_punishment_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function black_flash_speedforce_punishment_aura:GetModifierAura()
	return "modifier_black_flash_speedforce_punishment"
end


modifier_black_flash_speedforce_punishment = class({})

function modifier_black_flash_speedforce_punishment:IsHidden()
	return true
end

function modifier_black_flash_speedforce_punishment:OnCreated( event )
	local ability = self:GetAbility()
	if IsServer() then
		self.distance = self:GetParent():GetAbsOrigin()
		_G.speedforce_table[self:GetParent()] = 0
	end
end

function modifier_black_flash_speedforce_punishment:DeclareFunctions()
	return {MODIFIER_EVENT_ON_UNIT_MOVED}
end

function modifier_black_flash_speedforce_punishment:OnUnitMoved(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			local origin = self:GetParent():GetAbsOrigin()
			local distance = (origin - self.distance):Length2D()
			_G.speedforce_table[self:GetParent()] = _G.speedforce_table[self:GetParent()] + distance;
			self.distance = self:GetParent():GetAbsOrigin()
		end
	end
end

modifier_black_flash_speedforce_punishment_precast = class({})

function modifier_black_flash_speedforce_punishment_precast:IsHidden()
	return true
end

function modifier_black_flash_speedforce_punishment_precast:OnCreated()
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/black_flash/black_flash_speedforce_punishment_lasso.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_black_flash_speedforce_punishment_precast:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function black_flash_speedforce_punishment:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

