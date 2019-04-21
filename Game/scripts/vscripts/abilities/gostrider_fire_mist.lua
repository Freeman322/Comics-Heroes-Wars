LinkLuaModifier ("modifier_gostrider_fire_mist", 				"abilities/gostrider_fire_mist.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_gostrider_fire_mist_passive", "abilities/gostrider_fire_mist.lua", LUA_MODIFIER_MOTION_NONE)

if gostrider_fire_mist == nil then gostrider_fire_mist = class({}) end

function gostrider_fire_mist:GetIntrinsicModifierName()
	return "modifier_gostrider_fire_mist"
end

if modifier_gostrider_fire_mist == nil then modifier_gostrider_fire_mist = class({}) end

function modifier_gostrider_fire_mist:IsAura()
	return true
end

function modifier_gostrider_fire_mist:IsHidden()
	return true
end

function modifier_gostrider_fire_mist:IsPurgable()
	return true
end

function modifier_gostrider_fire_mist:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_gostrider_fire_mist:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_gostrider_fire_mist:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_gostrider_fire_mist:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_gostrider_fire_mist:GetModifierAura()
	return "modifier_gostrider_fire_mist_passive"
end

function modifier_gostrider_fire_mist:GetEffectName()
    return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_gostrider_fire_mist:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

if modifier_gostrider_fire_mist_passive == nil then modifier_gostrider_fire_mist_passive = class({}) end

function modifier_gostrider_fire_mist_passive:GetEffectName()
    return "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf"
end

function modifier_gostrider_fire_mist_passive:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_gostrider_fire_mist_passive:OnCreated(htable)
    if IsServer() then
        self._iMultiplier = 1
		self:StartIntervalThink(1)
	end
end


function modifier_gostrider_fire_mist_passive:OnDestroy()
    if IsServer() then
        self._iMultiplier = 1
	end
end

function modifier_gostrider_fire_mist_passive:OnIntervalThink()
    if IsServer() then 
        self._iMultiplier = self._iMultiplier + 1
        if not self:GetParent():IsAncient() then 
            local damage = {
                victim = self:GetParent(),
                attacker = self:GetCaster(),
                damage =  self:GetAbility():GetSpecialValueFor("aura_damage") * self._iMultiplier,
                damage_type = self:GetAbility():GetAbilityDamageType(),
                ability = self
            }
            ApplyDamage( damage ) 
        end
    end
end

function modifier_gostrider_fire_mist_passive:IsPurgable(  )
    return false
end
