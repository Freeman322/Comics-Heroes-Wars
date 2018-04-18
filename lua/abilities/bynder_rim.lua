bynder_rim = class ( {})
LinkLuaModifier ("modifier_bynder_rim","abilities/bynder_rim.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_bynder_rim_scepter","abilities/bynder_rim.lua", LUA_MODIFIER_MOTION_NONE)

function bynder_rim:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end

function bynder_rim:GetManaCost (hTarget)
    return self.BaseClass.GetManaCost (self, hTarget)
end

function bynder_rim:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/byonder_outer_rim_arcana"
	end
	return "custom/bynder_astral"
end


function bynder_rim:GetCastPoint()
    if self:GetCaster():HasScepter() then
        return 0
    end
    return 0.3
end

function bynder_rim:OnSpellStart ()
    local hCaster = self:GetCaster()

    local duration = self:GetSpecialValueFor ("duration")

    if self:GetCaster():HasTalent("special_bonus_unique_byonder") then
        duration = duration + 1
    end
    if self:GetCaster():HasScepter() then
      duration = duration + 1
      hCaster:AddNewModifier (self:GetCaster (), self, "modifier_bynder_rim_scepter", { duration = duration } )
    end

    hCaster:AddNewModifier (self:GetCaster (), self, "modifier_bynder_rim", { duration = duration } )
end

modifier_bynder_rim = class ( {})

function modifier_bynder_rim:IsBuff()
    return true
end

function modifier_bynder_rim:IsHidden()
    return true
end

function modifier_bynder_rim:IsPurgable()
    return false
end

function modifier_bynder_rim:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_bynder_rim:OnTakeDamage(params)
    if self:GetParent () == params.unit then
        self:GetParent ():SetHealth(self:GetParent():GetHealth() + params.damage)
        self:SetStackCount(self:GetStackCount() + params.damage)

        local RemovePositiveBuffs = false
        local RemoveDebuffs = true
        local BuffsCreatedThisFrameOnly = false
        local RemoveStuns = true
        local RemoveExceptions = true
        self:GetParent():Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
    end
end

function modifier_bynder_rim:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bynder_rim:GetStatusEffectName()
    return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf"
end

function modifier_bynder_rim:StatusEffectPriority()
    return 1000
end

function modifier_bynder_rim:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf"
end

function modifier_bynder_rim:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_bynder_rim:GetModifierPreAttack_BonusDamage( params )
    return self:GetStackCount()
end

function bynder_rim:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end


if modifier_bynder_rim_scepter == nil then modifier_bynder_rim_scepter = class({}) end

function modifier_bynder_rim_scepter:IsHidden()
	return true
end

function modifier_bynder_rim_scepter:IsPurgable()
	return false
end

function modifier_bynder_rim_scepter:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function modifier_bynder_rim_scepter:GetModifierIncomingDamage_Percentage(params)
	return self:GetAbility():GetSpecialValueFor("scepter_incoming_damage")
end
