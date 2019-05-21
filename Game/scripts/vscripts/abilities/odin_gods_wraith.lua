odin_gods_wraith = class({})

LinkLuaModifier( "modifier_odin_gods_wraith",       "abilities/odin_gods_wraith.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_odin_gods_wraith_timer", "abilities/odin_gods_wraith.lua",LUA_MODIFIER_MOTION_NONE )

function odin_gods_wraith:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_odin_gods_wraith_timer", { duration = 1 } )
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn( "Ability.LagunaBladeImpact", self:GetCaster() )
	end
end

modifier_odin_gods_wraith_timer = class({})

--------------------------------------------------------------------------------

function modifier_odin_gods_wraith_timer:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_odin_gods_wraith_timer:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_odin_gods_wraith_timer:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_odin_gods_wraith_timer:OnDestroy()
	if IsServer() then
		local nDamageType = DAMAGE_TYPE_MAGICAL
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetAbility():GetAbilityDamage(),
			damage_type = nDamageType,
			ability = self:GetAbility()
		}

		local nFXIndex = ParticleManager:CreateParticle( "particles/odin/gods_wraith.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 1, 1 ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, self:GetParent():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		EmitSoundOn("PudgeWarsClassic.echo_slam", self:GetParent() )
		
		-- Play named sound on Entity
		self:GetParent():AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetAbility():GetSpecialValueFor( "duration" )} )

		ApplyDamage( damage )
	end
end

function odin_gods_wraith:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

