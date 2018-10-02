LinkLuaModifier ("modifier_item_demon_shard", "items/item_demon_shard.lua", LUA_MODIFIER_MOTION_NONE)

if item_demon_shard == nil then
    item_demon_shard = class ( {})
end

function item_demon_shard:GetIntrinsicModifierName ()
    return "modifier_item_demon_shard"
end

function item_demon_shard:OnSpellStart(  )
    if IsServer() then
        local hTaget = self:GetCursorTarget()
        hTaget:CutDown(self:GetCaster():GetTeamNumber())
    end
end

if modifier_item_demon_shard == nil then
    modifier_item_demon_shard = class ( {})
end

function modifier_item_demon_shard:IsHidden()
    return true
end

function modifier_item_demon_shard:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_demon_shard:GetModifierPreAttack_BonusDamage (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_damage")
end

function modifier_item_demon_shard:GetModifierBonusStats_Strength (params)
    return self:GetAbility ():GetSpecialValueFor ("all_stats")
end

function modifier_item_demon_shard:GetModifierBonusStats_Intellect (params)
    return self:GetAbility ():GetSpecialValueFor ("all_stats")
end

function modifier_item_demon_shard:GetModifierBonusStats_Agility (params)
    return self:GetAbility ():GetSpecialValueFor ("all_stats")
end

function modifier_item_demon_shard:GetModifierAttackSpeedBonus_Constant (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_attack_speed")
end

function modifier_item_demon_shard:GetModifierPreAttack_CriticalStrike(params)
	if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
		IsHasCrit = true
		return self:GetAbility():GetSpecialValueFor("crit_bonus")
	end
	IsHasCrit = false
	return
end

function modifier_item_demon_shard:OnAttackLanded (params)
    if params.attacker == self:GetParent() then
    	if IsHasCrit and not params.target:IsBuilding() then
        local hTarget = params.target
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        EmitSoundOn("Hero_Bane.Nightmare.End", hTarget)
        ScreenShake(hTarget:GetOrigin(), 100, 0.1, 0.3, 500, 0, true)
    	end
    end
end

function modifier_item_demon_shard:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_demon_shard:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

