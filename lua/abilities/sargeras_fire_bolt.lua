sargeras_fire_bolt = class({})
LinkLuaModifier( "modifier_sargeras_fire_bolt", "abilities/sargeras_fire_bolt.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sargeras_fire_bolt:OnSpellStart()
	local info = {
			EffectName = "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf",
			Ability = self,
			iMoveSpeed = 4000,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Ability.GushCast", self:GetCaster() )
end

--------------------------------------------------------------------------------

function sargeras_fire_bolt:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Ability.GushImpact", hTarget )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetSpecialValueFor("damage_tooltip"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_sargeras_fire_bolt", { duration = self:GetSpecialValueFor("duration_tooltip") } )
	end

	return true
end

if modifier_sargeras_fire_bolt == nil then modifier_sargeras_fire_bolt = class({}) end

function modifier_sargeras_fire_bolt:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_sargeras_fire_bolt:IsHidden()
	return false
end

function modifier_sargeras_fire_bolt:IsPurgable()
	return false
end

function modifier_sargeras_fire_bolt:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local iDamage = hAbility:GetSpecialValueFor( "damage_interval" )

		local damage = {
			victim = self:GetParent(),
			attacker = hAbility:GetCaster(),
			damage = iDamage/10,
			damage_type = DAMAGE_TYPE_PURE,
			ability = hAbility
		}
		ApplyDamage( damage )
	end
end

function modifier_sargeras_fire_bolt:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_sargeras_fire_bolt:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_sargeras_fire_bolt:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_sargeras_fire_bolt:GetModifierPhysicalArmorBonus (params)
    return self:GetAbility():GetSpecialValueFor("armor_bonus")
end

function modifier_sargeras_fire_bolt:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("movement_speed")
end

function sargeras_fire_bolt:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

