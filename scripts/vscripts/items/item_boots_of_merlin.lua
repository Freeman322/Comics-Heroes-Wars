LinkLuaModifier("modifier_boots_of_merlin", "items/item_boots_of_merlin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boots_of_merlin_aura", "items/item_boots_of_merlin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boots_of_merlin_buff", "items/item_boots_of_merlin", LUA_MODIFIER_MOTION_NONE)

item_boots_of_merlin = class ({})

function item_boots_of_merlin:GetIntrinsicModifierName()
    return "modifier_boots_of_merlin"
end

function item_boots_of_merlin:OnSpellStart()
    if IsServer() then
        EmitSoundOn("Item.GuardianGreaves.Activate", self:GetCaster())
	    ParticleManager:CreateParticle("particles/items_fx/arcane_boots.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

        local units = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("replenish_radius"),
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
        for i, nearby_ally in ipairs(units) do  --Restore health and play a particle effect for every found ally.
            nearby_ally:Heal(self:GetSpecialValueFor("replenish_health"), self:GetCaster())
            nearby_ally:GiveMana(self:GetSpecialValueFor("replenish_mana"))

            EmitSoundOn("Item.GuardianGreaves.Target", nearby_ally)

            ParticleManager:CreateParticle("particles/items_fx/arcane_boots_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, nearby_ally)
            
            nearby_ally:AddNewModifier(self:GetCaster(), self, "modifier_boots_of_merlin_buff", nil)
        end
    end
end

modifier_boots_of_merlin_buff = class({})

function modifier_boots_of_merlin_buff:IsHidden() return false end
function modifier_boots_of_merlin_buff:IsPurgable() return true end
function modifier_boots_of_merlin_buff:RemoveOnDeath() return true end
function modifier_boots_of_merlin_buff:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT, MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE} end
function modifier_boots_of_merlin_buff:GetEffectName() return "particles/generic_gameplay/rune_arcane_owner.vpcf" end
function modifier_boots_of_merlin_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_boots_of_merlin_buff:OnTakeDamageKillCredit( params )
    if IsServer() then
        if params.inflictor and params.attacker == self:GetParent() and params.damage_type > DAMAGE_TYPE_PHYSICAL then   
            local damage = (params.damage * (self:GetAbility():GetSpecialValueFor("replenish_damage_amp") / 100))
            local cooldown = params.inflictor:GetCooldown(params.inflictor:GetLevel())

            ApplyDamage ( {
                victim = params.target,
                attacker = self:GetParent(),
                damage = damage,
                damage_type = params.damage_type,
                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
            })

            self:Destroy()
        end 
    end 
end

function modifier_boots_of_merlin_buff:GetModifierPercentageCooldown( params )
    if IsServer() then
        if params.ability and not params.ability:IsUltimate() then
            return self:GetAbility():GetSpecialValueFor("replenish_cooldown_reduction") 
        end 
    end 
    return 0
end



modifier_boots_of_merlin = class ({})

function modifier_boots_of_merlin:IsAura() return true end
function modifier_boots_of_merlin:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_boots_of_merlin:GetAuraDuration() return 0.5 end
function modifier_boots_of_merlin:IsHidden() return true end
function modifier_boots_of_merlin:RemoveOnDeath() return false end 
function modifier_boots_of_merlin:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_boots_of_merlin:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_boots_of_merlin:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_boots_of_merlin:GetModifierAura() return "modifier_boots_of_merlin_aura" end

function modifier_boots_of_merlin:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
    return funcs
end

function modifier_boots_of_merlin:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_boots_of_merlin:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_boots_of_merlin:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_boots_of_merlin:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_boots_of_merlin:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_boots_of_merlin:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_boots_of_merlin:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_movement")
end

modifier_boots_of_merlin_aura = class ({})

function modifier_boots_of_merlin_aura:IsPurgable() return false end
function modifier_boots_of_merlin_aura:IsHidden() return false end
function modifier_boots_of_merlin_aura:RemoveOnDeath() return false end 
function modifier_boots_of_merlin_aura:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_EVENT_ON_HEAL_RECEIVED} end
function modifier_boots_of_merlin_aura:OnHealReceived(params)
    if IsServer() then
        if params.unit == self:GetParent() then
            local heal = params.gain * (self:GetAbility():GetSpecialValueFor("aura_heal_amp") / 100)

            self:GetParent():Heal_Engine(heal)
        end 
    end 
end
function modifier_boots_of_merlin_aura:GetModifierPhysicalArmorBonus(params)
    return self:GetAbility():GetSpecialValueFor("aura_armor")
end

