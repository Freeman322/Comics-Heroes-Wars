medivh_deafening_blast = class({})
LinkLuaModifier( "modifier_medivh_dummy", "abilities/medivh_deafening_blast.lua", LUA_MODIFIER_MOTION_NONE )
function  medivh_deafening_blast:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/quicksilver_blast_custom"
	end
	return self.BaseClass.GetAbilityTextureName(self)
end

function medivh_deafening_blast:GetBehavior()
	if IsServer() then
		local ultimate = self:GetCaster():FindAbilityByName("medivh_dark_rift"):GetLevel()
	end
    if ultimate == 3 then
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
    end
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end
function medivh_deafening_blast:OnSpellStart()
	self.origin = self:GetCaster():GetAbsOrigin()
	local effect = "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6.vpcf"
	local sound = "Hero_Invoker.DeafeningBlast.Immortal"
	if self:GetCaster():HasModifier("modifier_arcana") then
		effect = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf" 
	    sound = "Quicksilver.CustomItem.Cast" end
	local ultimate = self:GetCaster():FindAbilityByName("medivh_dark_rift"):GetLevel()
	if ultimate == 3 then
		-- Get the forward vector of the entity.
		local info1 = {
			EffectName = effect,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fStartRadius = 175,
			fEndRadius = 225,
			vVelocity = ((self:GetCaster():GetAbsOrigin() + Vector(1, 1, 0)) - self:GetCaster():GetAbsOrigin()):Normalized() * 1000,
			fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = 225,
		}

		self.nProjID1 = ProjectileManager:CreateLinearProjectile( info1 )
		EmitSoundOn( sound , self:GetCaster() )

			local info2 = {
			EffectName = effect,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fStartRadius = 175,
			fEndRadius = 225,
			vVelocity = ((self:GetCaster():GetAbsOrigin() + Vector(1, 0, 0)) - self:GetCaster():GetAbsOrigin()):Normalized() * 1000,
			fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = 225,
		}
		EmitSoundOn( sound, self:GetCaster() )
		self.nProjID2 = ProjectileManager:CreateLinearProjectile( info2 )

			local info3 = {
			EffectName = effect,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fStartRadius = 175,
			fEndRadius = 225,
			vVelocity = ((self:GetCaster():GetAbsOrigin() + Vector(1, -1, 0)) - self:GetCaster():GetAbsOrigin()):Normalized() * 1000,
			fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = 225,
		}
		EmitSoundOn( sound , self:GetCaster() )
		self.nProjID3 = ProjectileManager:CreateLinearProjectile( info3 )

			local info4 = {
			EffectName = effect,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fStartRadius = 175,
			fEndRadius = 225,
			vVelocity = ((self:GetCaster():GetAbsOrigin() + Vector(0, -1, 0)) - self:GetCaster():GetAbsOrigin()):Normalized() * 1000,
			fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = 225,
		}
		EmitSoundOn( sound, self:GetCaster() )
		self.nProjID4 = ProjectileManager:CreateLinearProjectile( info4 )

			local info5 = {
			EffectName = effect,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fStartRadius = 175,
			fEndRadius = 225,
			vVelocity = ((self:GetCaster():GetAbsOrigin() + Vector(-1, -1, 0)) - self:GetCaster():GetAbsOrigin()):Normalized() * 1000,
			fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = 225,
		}
		EmitSoundOn( sound, self:GetCaster() )
		self.nProjID5 = ProjectileManager:CreateLinearProjectile( info5 )

			local info6 = {
			EffectName = effect,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fStartRadius = 175,
			fEndRadius = 225,
			vVelocity = ((self:GetCaster():GetAbsOrigin() + Vector(-1, 0, 0)) - self:GetCaster():GetAbsOrigin()):Normalized() * 1000,
			fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = 225,
		}
		EmitSoundOn( sound, self:GetCaster() )
		self.nProjID6 = ProjectileManager:CreateLinearProjectile( info6 )

			local info7 = {
			EffectName = effect,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fStartRadius = 175,
			fEndRadius = 225,
			vVelocity = ((self:GetCaster():GetAbsOrigin() + Vector(-1, 1, 0)) - self:GetCaster():GetAbsOrigin()):Normalized() * 1000,
			fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = 225,
		}
		EmitSoundOn( sound, self:GetCaster() )
		self.nProjID7 = ProjectileManager:CreateLinearProjectile( info7 )

			local info8 = {
			EffectName = effect,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fStartRadius = 175,
			fEndRadius = 225,
			vVelocity = ((self:GetCaster():GetAbsOrigin() + Vector(0, 1, 0)) - self:GetCaster():GetAbsOrigin()):Normalized() * 1000,
			fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = 225,
		}
		EmitSoundOn( sound, self:GetCaster() )
		self.nProjID8 = ProjectileManager:CreateLinearProjectile( info8 )
	else
		local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vDirection = vDirection:Normalized()
		local info = {
			EffectName = effect,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fStartRadius = 175,
			fEndRadius = 225,
			vVelocity = vDirection * 1000,
			fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = 225,
		}

		self.nProjID = ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( sound, self:GetCaster() )
	end
end

function medivh_deafening_blast:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and hTarget:HasModifier("modifier_medivh_dummy") == false then 
		EmitSoundOn( "DOTA_Item.SkullBasher" , self:GetCaster() )
		
		local iDamage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():GetIntellect()
		
		if self:GetCaster():HasTalent("special_bonus_unique_medivh") then
	        iDamage = iDamage + self:GetCaster():FindTalentValue("special_bonus_unique_medivh")
		end

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = iDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}
		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "elder_warlock") == true then
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_cast2_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn("Quicksilver.CustomItem.Cast", hTarget)
		end
		
		local knockbackProperties =
		{
			center_x = self.origin.x,
			center_y = self.origin.y,
			center_z = self.origin.z,
			duration = self:GetSpecialValueFor( "knockback_duration" ),
			knockback_duration = self:GetSpecialValueFor( "knockback_duration" ),
			knockback_distance = 350,
			knockback_height = 0
		}
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_medivh_dummy", {duration = 0.5} )

		ApplyDamage( damage )
	end

	return false
end

function medivh_deafening_blast:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

if modifier_medivh_dummy == nil then modifier_medivh_dummy = class({}) end 

function modifier_medivh_dummy:IsHidden()
    return true
end

function modifier_medivh_dummy:IsPurgable()
    return false
end 
