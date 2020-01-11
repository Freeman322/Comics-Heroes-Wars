if ares_terrorize == nil then ares_terrorize = class({}) end

LinkLuaModifier( "modifier_ares_terrorize", "abilities/ares_terrorize.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ares_terrorize_deni", "abilities/ares_terrorize.lua", LUA_MODIFIER_MOTION_NONE )

function ares_terrorize:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function ares_terrorize:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_izanagi") then return "custom/ares_terrorize_izanagi" end
	return self.BaseClass.GetAbilityTextureName(self)
end

function ares_terrorize:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function ares_terrorize:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

function ares_terrorize:OnSpellStart()
	if IsServer() then
		local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vDirection = vDirection:Normalized()
		local fDistance = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Length2D()
		------------------------------ Skin Effect ------------------------------------
		local customSkinProjectile = "particles/neutral_fx/satyr_hellcaller.vpcf"

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "izanagi") then
			customSkinProjectile = "particles/ares_izanagi/terrorize_projectile.vpcf"
		end
		local info = {
			EffectName = customSkinProjectile,
			------------------------------ Skin Effect ------------------------------------
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
			fStartRadius = self:GetSpecialValueFor("radius"),
			fEndRadius = self:GetSpecialValueFor("radius"),
			vVelocity = vDirection * 1500,
			fDistance = fDistance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = 400,
		}
		self.nProjID = ProjectileManager:CreateLinearProjectile( info )

		EmitSoundOn( "Hero_DarkWillow.Shadow_Realm" , self:GetCaster() )
		EmitSoundOn( "Hero_DarkWillow.Shadow_Realm.Attack" , self:GetCaster() )
	end
end

function ares_terrorize:OnProjectileHit_ExtraData( hTarget, vLocation, table )
	if hTarget == nil then
		local hCaster = self:GetCaster()

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "izanagi") then
			------------------------------ Skin Effect ------------------------------------
			local nFXIndex = ParticleManager:CreateParticle( "particles/ares_izanagi/terrorize_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControl( nFXIndex, 0, vLocation);
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 0));
			ParticleManager:ReleaseParticleIndex( nFXIndex );
			------------------------------ Skin Effect ------------------------------------

			EmitSoundOn( "Ares.Anime.Cast4", hCaster )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell.vpcf", PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControl( nFXIndex, 0, vLocation);
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 0));
			ParticleManager:ReleaseParticleIndex( nFXIndex );
		end


		EmitSoundOnLocationWithCaster(vLocation, "Hero_DarkWillow.Ley.Cast", hCaster)
		EmitSoundOnLocationWithCaster(vLocation, "Hero_DarkWillow.Ley.Target", hCaster)

		local units = FindUnitsInRadius(hCaster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

		for i, target in ipairs(units) do
			target:EmitSound("Hero_DarkWillow.Fear.Location")

			target:AddNewModifier(self:GetCaster(), self, "modifier_ares_terrorize_deni", {duration = self:GetSpecialValueFor("duration")})
			target:AddNewModifier(self:GetCaster(), self, "modifier_ares_terrorize", {duration = self:GetSpecialValueFor("duration")})
		end

		AddFOWViewer(self:GetCaster():GetTeamNumber(), vLocation, 400, 5, true)

		return nil
	end
end

if modifier_ares_terrorize == nil then modifier_ares_terrorize = class({}) end

function modifier_ares_terrorize:IsHidden()
	return true
end

function modifier_ares_terrorize:IsPurgable()
	return false
end

function modifier_ares_terrorize:RemoveOnDeath()
	return true
end

function modifier_ares_terrorize:OnCreated(htable)
	if IsServer() then
		self.target = nil
		EmitSoundOn("Hero_DarkWillow.Fear.Target", self:GetParent())

		local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false )
		for _,unit in pairs(units) do
			if unit:HasModifier("modifier_ares_terrorize") and unit ~= self:GetParent() then
				self.target = unit
				break
			end
		end
		if not self.target then
			self.target = self:GetParent()
		end
		local order =
		{
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			TargetIndex = self.target:entindex()
		}

		ExecuteOrderFromTable(order)
		self:GetParent():SetForceAttackTargetAlly(self.target)
		self:StartIntervalThink(0.05)
	end
end

function modifier_ares_terrorize:OnIntervalThink()
	if IsServer() then
		if self.target:IsAlive() == false then
			self:Destroy()
		end
	end
end

function modifier_ares_terrorize:OnDestroy()
	if IsServer() then
		self:GetParent():Interrupt()
		self:GetParent():SetForceAttackTargetAlly(nil)
		self:GetParent():SetForceAttackTargetAlly(nil)
	end
end

function modifier_ares_terrorize:GetStatusEffectName()
	--return "particles/status_fx/status_effect_dark_willow_wisp_fear.vpcf"
	------------------------------ Skin Effect ------------------------------------
	return "particles/ares_izanagi/status_effect_dark_willow_wisp_fear.vpcf"
	------------------------------ Skin Effect ------------------------------------
end

function modifier_ares_terrorize:StatusEffectPriority()
	return 1000
end

function modifier_ares_terrorize:GetEffectName()
	return "particles/hero_ebony/ebonymaw_hazard_debuff.vpcf"
end

function modifier_ares_terrorize:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ares_terrorize:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_FAKE_ALLY] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

function modifier_ares_terrorize:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_ares_terrorize:DeclareFunctions ()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function modifier_ares_terrorize:GetModifierIncomingDamage_Percentage (params)
	return self:GetAbility():GetSpecialValueFor("incoming_damage")
end

if modifier_ares_terrorize_deni == nil then modifier_ares_terrorize_deni = class({}) end

function modifier_ares_terrorize_deni:IsHidden()
	return true
end

function modifier_ares_terrorize_deni:IsPurgable()
	return false
end

function modifier_ares_terrorize_deni:RemoveOnDeath()
	return true
end

function modifier_ares_terrorize_deni:CheckState()
	local state = {
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true
	}

	return state
end
