LinkLuaModifier ("modifier_nightcrawler_soul_exhaustion", "abilities/nightcrawler_soul_exhaustion.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_nightcrawler_soul_exhaustion_slow", "abilities/nightcrawler_soul_exhaustion.lua", LUA_MODIFIER_MOTION_NONE)

if nightcrawler_soul_exhaustion == nil then nightcrawler_soul_exhaustion = class({})  end

function nightcrawler_soul_exhaustion:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function nightcrawler_soul_exhaustion:GetIntrinsicModifierName ()
    return "modifier_nightcrawler_soul_exhaustion"
end

if modifier_nightcrawler_soul_exhaustion == nil then modifier_nightcrawler_soul_exhaustion = class({}) end

function modifier_nightcrawler_soul_exhaustion:IsHidden()
    return true
end

function modifier_nightcrawler_soul_exhaustion:IsPurgable()
	return false
end

function modifier_nightcrawler_soul_exhaustion:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_nightcrawler_soul_exhaustion:GetModifierPreAttack_BonusDamage (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_damage")
end


function modifier_nightcrawler_soul_exhaustion:GetModifierPreAttack_CriticalStrike(params)
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
    if self:GetCaster():HasTalent("special_bonus_unique_nightcrawler") then
        local value = self:GetCaster():FindTalentValue("special_bonus_unique_nightcrawler") + self:GetAbility():GetSpecialValueFor("chance")
	end
	if RollPercentage(self.chance) then
		return self:GetAbility():GetSpecialValueFor("crit_damage")
	end
	return
end

function modifier_nightcrawler_soul_exhaustion:OnAttackLanded (params)
    if params.attacker == self:GetParent() then
		local hTarget = params.target
		local hAbility = self:GetAbility()
		if hAbility:IsCooldownReady() then
			hTarget:AddNewModifier(self:GetCaster(), hAbility, "modifier_nightcrawler_soul_exhaustion_slow", {duration = hAbility:GetSpecialValueFor("duration")})
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = hAbility:GetAbilityDamage(),
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = hAbility
			}

			if IsServer() then
				if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "octavia") then
					ParticleManager:CreateParticle( "particles/octavia_skin/octavia_proc_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
				end
			end
			
			ApplyDamage( damage )

			hAbility:PayManaCost()
			hAbility:StartCooldown(hAbility:GetCooldown(hAbility:GetLevel()))
		end
    end
end

if modifier_nightcrawler_soul_exhaustion_slow == nil then modifier_nightcrawler_soul_exhaustion_slow = class({}) end

function modifier_nightcrawler_soul_exhaustion_slow:IsPurgeException()
	return true
end

--------------------------------------------------------------------------------

function modifier_nightcrawler_soul_exhaustion_slow:GetStatusEffectName()
	return "particles/units/heroes/hero_visage/status_effect_visage_chill_slow.vpcf"
end

--------------------------------------------------------------------------------

function modifier_nightcrawler_soul_exhaustion_slow:StatusEffectPriority()
	return 1000
end

--------------------------------------------------------------------------------

function modifier_nightcrawler_soul_exhaustion_slow:GetEffectName()
	return "particles/items_fx/diffusal_slow.vpcf"
end

--------------------------------------------------------------------------------

function modifier_nightcrawler_soul_exhaustion_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_nightcrawler_soul_exhaustion_slow:OnCreated( kv )
	if IsServer() then
		self:GetParent():Purge(true, false, false, false, false)
	end
end

--------------------------------------------------------------------------------

function modifier_nightcrawler_soul_exhaustion_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_nightcrawler_soul_exhaustion_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slowing")
end

function nightcrawler_soul_exhaustion:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

