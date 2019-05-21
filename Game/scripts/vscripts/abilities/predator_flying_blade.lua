if predator_flying_blade == nil then predator_flying_blade = class({}) end

LinkLuaModifier( "modifier_predator_flying_blade", "abilities/predator_flying_blade.lua", LUA_MODIFIER_MOTION_NONE )


function predator_flying_blade:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()

	local effect = "particles/hero_predator/predator_flying_blade.vpcf"

	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "beerus") then
		effect = "particles/econ/items/shadow_demon/sd_ti7_shadow_poison/sd_ti7_shadow_poison_proj.vpcf"
	end 
	
	local info = {
		EffectName = effect,
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fStartRadius = 100,
		fEndRadius = 100,
		vVelocity = vDirection * 1200,
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
	EmitSoundOn( "Hero_BountyHunter.Shuriken" , self:GetCaster() )
end


function predator_flying_blade:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration") } )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_predator_flying_blade", { duration = self:GetSpecialValueFor("rapture_duration") } )

		EmitSoundOn("Hero_BountyHunter.Shuriken", hTarget)
		EmitSoundOn("Hero_BountyHunter.Jinada", hTarget)

		ApplyDamage( damage )
	end

	return false
end

if modifier_predator_flying_blade == nil then modifier_predator_flying_blade = class({}) end

function modifier_predator_flying_blade:GetEffectName()
    return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_predator_flying_blade:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_predator_flying_blade:OnCreated(event)
    if IsServer() then
        EmitSoundOn( "Hero_Bloodseeker.Rupture", self:GetParent() )
        self.ElapsedDistance = self:GetParent():GetAbsOrigin()
        self:StartIntervalThink(0.1)
    end
end

function modifier_predator_flying_blade:OnIntervalThink()
    local target = self:GetParent()
    local dmg_pers = 0.25
    if target:GetAbsOrigin() ~= self.ElapsedDistance then
        local targetDistance = (target:GetAbsOrigin() - self.ElapsedDistance):Length2D()
        ApplyDamage({victim = target, attacker = self:GetAbility():GetCaster(), damage = targetDistance*dmg_pers, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
        self.ElapsedDistance = target:GetAbsOrigin()
    end
    ApplyDamage({victim = target, attacker = self:GetAbility():GetCaster(), damage = self:GetAbility():GetSpecialValueFor("damage_per_second")/10, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
end

function modifier_predator_flying_blade:OnDestroy()
    self.ElapsedDistance = nil
end
function modifier_predator_flying_blade:IsHidden()
    return false
end

function modifier_predator_flying_blade:IsDebuff()
    return true
end

function modifier_predator_flying_blade:IsPurgeException()
    return true
end

function predator_flying_blade:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

