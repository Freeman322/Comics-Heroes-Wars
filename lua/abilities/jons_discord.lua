if jons_discord == nil then jons_discord = class({}) end
LinkLuaModifier("modifier_jons_discord", "abilities/jons_discord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jons_discord_bonus_damage", "abilities/jons_discord", LUA_MODIFIER_MOTION_NONE)

function jons_discord:GetIntrinsicModifierName()
   return "modifier_jons_discord"
end

if modifier_jons_discord == nil then modifier_jons_discord = class({}) end

function modifier_jons_discord:IsHidden()
	return true
end

function modifier_jons_discord:IsPurgable()
	return false
end

function modifier_jons_discord:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_ORDER
	}

	return funcs
end

function modifier_jons_discord:OnOrder(args)
  if args.order_type and args.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
    if IsServer() then
			if args.unit == self:GetParent() then 
				if self:GetAbility():IsCooldownReady() and ((args.target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()) <= self:GetAbility():GetSpecialValueFor("max_distance") then
					local victim_angle = args.target:GetAnglesAsVector()
					local victim_forward_vector = args.target:GetForwardVector()
					local victim_angle_rad = victim_angle.y*math.pi/180
					local victim_position = args.target:GetAbsOrigin()
					local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start_sparkles.vpcf", PATTACH_CUSTOMORIGIN, nil );
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
					ParticleManager:ReleaseParticleIndex( nFXIndex );
					EmitSoundOn("Hero_Spectre.Reality", self:GetCaster())

					self:GetCaster():SetAbsOrigin(attacker_new)
					FindClearSpaceForUnit(self:GetCaster(), attacker_new, true)
					self:GetCaster():SetForwardVector(victim_forward_vector)

					self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
					self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_jons_discord_bonus_damage", {duration = 1.5})

					EmitSoundOn("Hero_Kunkka.Tidebringer.Attack", args.target)
					local cleaveDamage = ( self:GetAbility():GetSpecialValueFor("splash") * self:GetCaster():GetAverageTrueAttackDamage(args.target) ) / 100.0
					DoCleaveAttack( self:GetParent(), args.target, self:GetAbility(), cleaveDamage, self:GetAbility():GetSpecialValueFor("splash_radius"), self:GetAbility():GetSpecialValueFor("splash_radius"), self:GetAbility():GetSpecialValueFor("splash_radius"), "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_weapon/kunkka_spell_tidebringer_fxset.vpcf" )
				end
			end
    end
  end
end

if modifier_jons_discord_bonus_damage == nil then modifier_jons_discord_bonus_damage = class({}) end

function modifier_jons_discord_bonus_damage:IsHidden()
	return false
end

function modifier_jons_discord_bonus_damage:IsPurgable()
	return false
end

function modifier_jons_discord_bonus_damage:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}

	return funcs
end

function modifier_jons_discord_bonus_damage:GetModifierPreAttack_BonusDamage(args)
  return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function jons_discord:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

