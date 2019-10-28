if hela_bullet_rain == nil then hela_bullet_rain = class({}) end

LinkLuaModifier( "modifier_hela_bullet_rain", "abilities/hela_bullet_rain.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function hela_bullet_rain:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function hela_bullet_rain:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function hela_bullet_rain:GetChannelTime()
	return 5
end

--------------------------------------------------------------------------------

function hela_bullet_rain:OnAbilityPhaseStart()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/death/mk_arcana_spring_cast_outer_death_pnt.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
	    ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetCaster():GetAbsOrigin());
	    ParticleManager:SetParticleControl(self.nFXIndex, 4, self:GetCaster():GetAbsOrigin());
		ParticleManager:ReleaseParticleIndex( self.nFXIndex );

	    EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace.Arcana", self:GetCaster())
	end

	return true
end

--------------------------------------------------------------------------------

function hela_bullet_rain:OnSpellStart()
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hela_bullet_rain", { duration = self:GetChannelTime() } )
end


--------------------------------------------------------------------------------

function hela_bullet_rain:OnChannelFinish( bInterrupted )
	if self:GetCaster():HasModifier("modifier_hela_bullet_rain") then
		self:GetCaster():RemoveModifierByName( "modifier_hela_bullet_rain" )
	end
end

function hela_bullet_rain:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		EmitSoundOn( "Hero_PhantomAssassin.Dagger.Target", hTarget )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		
		self:GetCaster():PerformAttack(hTarget, true, true, true, true, true, false, true)

		if self:GetCaster():HasScepter() then 
			self:GetCaster():PerformAttack(hTarget, true, true, true, true, true, false, true)
		end

		ApplyDamage(damage)
	end

	return true
end

if modifier_hela_bullet_rain == nil then modifier_hela_bullet_rain = class({}) end

function modifier_hela_bullet_rain:IsPurgable()
	return false
end

function modifier_hela_bullet_rain:IsHidden()
	return true
end

function modifier_hela_bullet_rain:GetEffectName()
	return "particles/econ/items/monkey_king/arcana/monkey_king_arcana_death.vpcf"
end

function modifier_hela_bullet_rain:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_hela_bullet_rain:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink(0.4)

		EmitSoundOn("Hero_MonkeyKing.FurArmy", self:GetParent())
	end
end

function modifier_hela_bullet_rain:OnIntervalThink()
	if IsServer() then
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		if self:GetCaster():HasTalent("special_bonus_unique_hela") then radius  = radius  + (self:GetCaster():FindTalentValue("special_bonus_unique_hela") or 1) end

		local projectile = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf"
		if Util:PlayerEquipedItem(self:GetParent():GetPlayerOwnerID(), "fate_of_asgard") == true then rojectile = "particles/econ/items/queen_of_pain/qop_ti8_immortal/qop_ti8_base_attack.vpcf" end 
		if Util:PlayerEquipedItem(self:GetParent():GetPlayerOwnerID(), "golden_fate_of_asgard") == true then projectile = "particles/econ/items/queen_of_pain/qop_ti8_immortal/queen_ti8_golden_shadow_strike.vpcf" end 
		
		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #units > 0 then
			for _,target in pairs(units) do
				local info = {
					EffectName = projectile,
					Ability = self:GetAbility(),
					iMoveSpeed = 1200,
					Source = self:GetCaster(),
					Target = target,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
				}

				ProjectileManager:CreateTrackingProjectile( info )
				
				EmitSoundOn( "Hero_PhantomAssassin.Dagger.Cast", self:GetCaster() )
			end
		end
	end
end

function modifier_hela_bullet_rain:OnDestroy()
	if IsServer() then
		StopSoundOn("Hero_MonkeyKing.FurArmy", self:GetParent())
		EmitSoundOn("Hero_MonkeyKing.FurArmy.End", self:GetParent())
	end
end

function hela_bullet_rain:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

