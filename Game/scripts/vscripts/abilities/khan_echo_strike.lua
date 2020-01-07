LinkLuaModifier("modifier_khan_echo_strike_armor", "abilities/khan_echo_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_khan_echo_strike", "abilities/khan_echo_strike.lua", LUA_MODIFIER_MOTION_NONE)

khan_echo_strike = class({})

function khan_echo_strike:GetAbilityTextureName()
  if self:GetCaster():HasModifier("modifier_khan") then return "custom/khan_manifold" end
  if self:GetCaster():HasModifier("modifier_nemesis") then return "custom/nemesis_custom_ult" end
  return self.BaseClass.GetAbilityTextureName(self)
end


function khan_echo_strike:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()
	local vDistance = vDirection:Length2D()
	self.damage = self:GetAbilityDamage()
	local particle = "particles/hero_khan/khan_echo_strike_projectile.vpcf"

	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "khan_manifold_paradox") then
		particle = "particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger.vpcf"

		EmitSoundOn( "Khan.Paradox.Cast" , self:GetCaster() )
	elseif Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "nemesis_custom") then
		particle = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_projectile.vpcf"
		EmitSoundOn( "Khan.Nemesis.Cast" , self:GetCaster() )
	else
		EmitSoundOn( "Ability.Powershot" , self:GetCaster() )
		EmitSoundOn( "Ability.Windrun" , self:GetCaster() )
	end 

	local info = {
		EffectName = particle,
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fStartRadius = 300,
		fEndRadius = 300,
		vVelocity = vDirection * 2000,
		fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = 100,
	}
	self.nProjID = ProjectileManager:CreateLinearProjectile( info )
	local duration = vDistance/2000
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_khan_echo_strike", {duration = duration})
end

--------------------------------------------------------------------------------

function khan_echo_strike:OnProjectileThink( vLocation )
	self:GetCaster():SetAbsOrigin(vLocation)
	GridNav:DestroyTreesAroundPoint(vLocation, 150, false)
	FindClearSpaceForUnit(self:GetCaster(), vLocation, false)
end

function khan_echo_strike:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self,
		}
	
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_khan_echo_strike_armor", { duration = self:GetSpecialValueFor("reduction_duration") } )
		
		self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true)
		self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true)
		
		-----self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true)
	
		if hTarget and not hTarget:IsNull() then
			EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace.Arcana", hTarget)
			EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace.Arcana", hTarget)
			
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )

			local particle = "particles/hero_khan/khan_echo_strike_jump.vpcf"

			if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "khan_manifold_paradox") then
				particle = "particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_path_owner_impact.vpcf"
				EmitSoundOn( "Khan.Paradox.Damage" , hTarget )
			elseif Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "nemesis_custom") then
				EmitSoundOn( "Khan.Nemesis.Target" , self:GetCaster() )
				particle = "particles/hero_khan/khan_nemesis_target.vpcf"
			else 
				EmitSoundOn( "Hero_PhantomAssassin.CoupDeGrace" , hTarget )
				EmitSoundOn( "Hero_Juggernaut.OmniSlash.Damage" , hTarget )	
			end 

			local nFXIndex1 = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControl( nFXIndex1, 0, hTarget:GetOrigin())
			ParticleManager:SetParticleControl( nFXIndex1, 1, hTarget:GetOrigin())
			ParticleManager:SetParticleControl( nFXIndex1, 3, hTarget:GetOrigin())

			ScreenShake(hTarget:GetAbsOrigin(), 500, 500, 0.25, 2000, 0, true)

			ApplyDamage( damage )
		end
	end

	return false
end

modifier_khan_echo_strike = class({})


function modifier_khan_echo_strike:IsHidden()
  return true
end

function modifier_khan_echo_strike:IsPurgable()
	return false
end

function modifier_khan_echo_strike:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end

function modifier_khan_echo_strike:StatusEffectPriority()
	return 1000
end

function modifier_khan_echo_strike:GetHeroEffectName()
	return "particles/frostivus_herofx/juggernaut_fs_omnislash_slashers.vpcf"
end

function modifier_khan_echo_strike:HeroEffectPriority()
	return 100
end

function modifier_khan_echo_strike:CheckState()
	local state = {
	  [MODIFIER_STATE_INVULNERABLE] = true,
	  [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
 	  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
 	  [MODIFIER_STATE_OUT_OF_GAME] = true,
	}

	return state
end

modifier_khan_echo_strike_armor = class({})


function modifier_khan_echo_strike_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_khan_echo_strike_armor:IsHidden()
	return true
end

function modifier_khan_echo_strike_armor:GetModifierPhysicalArmorBonus( params )
	return self:GetAbility():GetSpecialValueFor("armor_reduction")
end

