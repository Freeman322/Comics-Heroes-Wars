LinkLuaModifier ("modifier_item_cursed_helmet", "items/item_cursed_helmet.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_cursed_helmet_active", "items/item_cursed_helmet.lua", LUA_MODIFIER_MOTION_NONE)

item_cursed_helmet = class({})

function item_cursed_helmet:GetIntrinsicModifierName ()
    return "modifier_item_cursed_helmet"
end

function item_cursed_helmet:OnSpellStart()
    if IsServer () then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_cursed_helmet_active", { duration = self:GetSpecialValueFor ("unholy_duration") })
    end
end

modifier_item_cursed_helmet_active = class({})

function modifier_item_cursed_helmet_active:OnCreated( kv )
    if IsServer() then
        self._iLifeStealPrc = self:GetAbility():GetSpecialValueFor("unholy_lifesteal_percent")

        EmitSoundOn("DOTA_Item.SpiritVessel.Target.Enemy", self:GetCaster())
        EmitSoundOn("DOTA_Item.SpiritVessel.Target.Ally", self:GetCaster())

        self:AddParticle( ParticleManager:CreateParticle( "particles/cursed_helmet/cursed_helmet_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ), false, false, -1, false, true )
    end
end

function modifier_item_cursed_helmet_active:DeclareFunctions()
    return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_item_cursed_helmet_active:IsHidden()
    return false
end

function modifier_item_cursed_helmet_active:IsPurgable()
    return false
end

function modifier_item_cursed_helmet_active:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("unholy_attack_speed") or 0
end

function modifier_item_cursed_helmet_active:OnAttackLanded( params )
    if IsServer() then        
        if params.attacker == self:GetParent() then
            local damage = params.damage

            ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ))
            
            self:GetParent():Heal(damage * (self._iLifeStealPrc / 100), self:GetAbility())
        end
    end
end

function modifier_item_cursed_helmet_active:CheckState()
    local state = {
        [MODIFIER_STATE_CANNOT_MISS] = true,
    }

    return state
end

modifier_item_cursed_helmet = class({})

function modifier_item_cursed_helmet:IsHidden()
    return true
end

function modifier_item_cursed_helmet:IsPurgable()
    return false
end

function modifier_item_cursed_helmet:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
        MODIFIER_EVENT_ON_ATTACK_LANDED 
    }

    return funcs
end

function modifier_item_cursed_helmet:GetModifierPreAttack_BonusDamage( params )
    return self:GetAbility():GetSpecialValueFor("bonus_damage") or 0
end

function modifier_item_cursed_helmet:GetModifierBonusStats_Strength( params )
    return self:GetAbility():GetSpecialValueFor("bonus_strength") or 0
end

function modifier_item_cursed_helmet:GetModifierStatusResistance( params )
    return self:GetAbility():GetSpecialValueFor("bonus_status_resist") or 0
end

function modifier_item_cursed_helmet:OnAttackLanded( params )
    if IsServer() then        
        if params.attacker == self:GetParent() then
            local damage = params.damage

            ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ))
            
            self:GetParent():Heal(damage * (self:GetAbility():GetSpecialValueFor("lifesteal_percent") / 100), self:GetAbility())
        end
    end
end

