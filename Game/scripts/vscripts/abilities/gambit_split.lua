if gambit_split == nil then gambit_split = class({}) end

LinkLuaModifier( "modifier_gambit_split", "abilities/gambit_split.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gambit_split:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function gambit_split:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function gambit_split:GetChannelTime()
	return 4
end

--------------------------------------------------------------------------------

function gambit_split:OnAbilityPhaseStart()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/hero_gambit/cards_is_folden.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
	    ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetCaster():GetAbsOrigin());
	    ParticleManager:SetParticleControl(self.nFXIndex, 1, self:GetCaster():GetAbsOrigin());
	    ParticleManager:SetParticleControl(self.nFXIndex, 3, self:GetCaster():GetAbsOrigin());
	    ParticleManager:SetParticleControl(self.nFXIndex, 4, self:GetCaster():GetAbsOrigin());
	    ParticleManager:SetParticleControl(self.nFXIndex, 5, self:GetCaster():GetAbsOrigin());
		ParticleManager:ReleaseParticleIndex( self.nFXIndex );

	    EmitSoundOn("Hero_MonkeyKing.FurArmy.Channel", self:GetCaster())
	end

	return true
end

--------------------------------------------------------------------------------

function gambit_split:OnSpellStart()
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_gambit_split", { duration = self:GetChannelTime() } )
end


--------------------------------------------------------------------------------

function gambit_split:OnChannelFinish( bInterrupted )
	if self:GetCaster():HasModifier("modifier_gambit_split") then
		self:GetCaster():RemoveModifierByName( "modifier_gambit_split" )
	end
end

function gambit_split:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and not hTarget:IsMagicImmune() then
		EmitSoundOn( "Hero_StormSpirit.Overload", hTarget )
		EmitSoundOn( "Hero_StormSpirit.Overload", hTarget )

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor( "stun_duration" ) } )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		ApplyDamage(damage)
	end

	return true
end

if modifier_gambit_split == nil then modifier_gambit_split = class({}) end

function modifier_gambit_split:IsPurgable()
	return false
end

function modifier_gambit_split:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_gambit_split:GetEffectName()
	return "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror_recipient.vpcf"
end

--------------------------------------------------------------------------------

function modifier_gambit_split:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_gambit_split:OnCreated( kv )
	if IsServer() then
		local sword = ParticleManager:CreateParticle( "particles/hero_gambit/cards_is_folden_weapon.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( sword, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon" , self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( sword, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon" , self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControl( sword, 6, Vector(100, 100, 0))
		ParticleManager:SetParticleControl( sword, 7, Vector(100, 100, 0))
		self:AddParticle( sword, false, false, -1, false, true )

		local ambient = ParticleManager:CreateParticle( "particles/hero_gambit/cards_is_folden_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( ambient, 0, self:GetParent():GetOrigin() )
		self:AddParticle( ambient, false, false, -1, false, true )

		self:StartIntervalThink(0.3)

		EmitSoundOn("Hero_MonkeyKing.FurArmy", self:GetParent())
	end
end

function modifier_gambit_split:OnIntervalThink()
	if IsServer() then
		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #units > 0 then
			for _,target in pairs(units) do
				local info = {
					EffectName = "particles/hero_gambit/magic_card_projectile.vpcf",
					Ability = self:GetAbility(),
					iMoveSpeed = 1000,
					Source = self:GetCaster(),
					Target = target,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
				}

				ProjectileManager:CreateTrackingProjectile( info )
				EmitSoundOn( "Hero_MonkeyKing.IronCudgel", self:GetCaster() )
			end
		end
	end
end

function modifier_gambit_split:OnDestroy()
	if IsServer() then
		StopSoundOn("Hero_MonkeyKing.FurArmy", self:GetParent())
		EmitSoundOn("Hero_MonkeyKing.FurArmy.End", self:GetParent())
	end
end

function gambit_split:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

