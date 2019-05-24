sargeras_fire_bolt = class({})
LinkLuaModifier( "modifier_sargeras_fire_bolt", "abilities/sargeras_fire_bolt.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sargeras_fire_bolt:OnSpellStart()
	if IsServer() then
		local particle = "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf"
		local sound = "Ability.GushCast"

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "sargeras_devourer_of_words") then
			particle = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf"
			sound = "Sargeras.WD.CastGush"
		end

		local info = {
				EffectName = particle,
				Ability = self,
				iMoveSpeed = 4000,
				Source = self:GetCaster(),
				Target = self:GetCursorTarget(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
			}

		ProjectileManager:CreateTrackingProjectile( info )
		EmitSoundOn( sound, self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function sargeras_fire_bolt:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		local sound = "Ability.GushImpact"

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "sargeras_devourer_of_words") then
			sound = "Sargeras.WD.CastGush"
		end

		EmitSoundOn( sound, hTarget )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetSpecialValueFor("damage_tooltip"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_sargeras_fire_bolt", { duration = self:GetSpecialValueFor("duration_tooltip") } )

		ApplyDamage( damage )
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

		if self:GetParent():IsMagicImmune() then self:Destroy() end 
	end
end

function modifier_sargeras_fire_bolt:GetEffectName()	
	if self:GetCaster():HasModifier("modifier_sargeras_s7_custom") then return "particles/hero_sargeras/sargeras_arcana_target.vpcf" end 
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

function sargeras_fire_bolt:GetAbilityTextureName() if self:GetCaster():HasModifier("modifier_sargeras_s7_custom") then return "custom/sargeras_fire_bolt_custom" end return self.BaseClass.GetAbilityTextureName(self)  end 

