if item_dawnbreaker == nil then item_dawnbreaker = class({}) end 

LinkLuaModifier( "modifier_item_dawnbreaker_active", "items/item_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_dawnbreaker", "items/item_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE )

function item_dawnbreaker:GetIntrinsicModifierName()
    return "modifier_item_dawnbreaker"
end

function item_dawnbreaker:OnSpellStart()
    if IsServer () then
        self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_item_dawnbreaker_active", { duration = self:GetSpecialValueFor ("sunbright_duration") })
    end
end

if modifier_item_dawnbreaker == nil then modifier_item_dawnbreaker = class({}) end 

function modifier_item_dawnbreaker:IsPurgable()
    return false
end

function modifier_item_dawnbreaker:IsHidden()
    return false
end

function modifier_item_dawnbreaker:DestroyOnExpire()
    return false
end

function modifier_item_dawnbreaker:IsCooldownReady()
   return self:GetRemainingTime() <= 0
end

function modifier_item_dawnbreaker:StartCooldown(flCooldown)
    self:SetDuration(flCooldown, true)
end

function modifier_item_dawnbreaker:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_item_dawnbreaker:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_item_dawnbreaker:GetModifierStatusResistance (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_status_resist")
end

function modifier_item_dawnbreaker:GetModifierHPRegenAmplify_Percentage (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_hp_amp")
end

function modifier_item_dawnbreaker:GetModifierPreAttack_BonusDamage (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_damage")
end

function modifier_item_dawnbreaker:GetModifierBonusStats_Strength (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_dawnbreaker:GetModifierBonusStats_Intellect (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_dawnbreaker:GetModifierBonusStats_Agility (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_dawnbreaker:GetModifierPhysicalArmorBonus (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_armor")
end

function modifier_item_dawnbreaker:GetModifierProcAttack_BonusDamage_Pure (params)
    if IsServer() then 
        if params.attacker == self:GetParent() and params.attacker:IsRealHero() then
        if not params.target:IsBuilding() and not params.target:IsAncient() then
            return params.target:GetHealth() * (self:GetAbility():GetSpecialValueFor("damage_pers") / 100) end
        end 
    end 
end

function modifier_item_dawnbreaker:OnTakeDamage(params)
    if IsServer() then 
        if params.unit == self:GetParent() then
            if self:IsCooldownReady() and self:GetParent():GetHealthPercent() <= self:GetAbility():GetSpecialValueFor("trigger_value") and self:GetParent():IsRealHero() then
                self:GetParent():Heal(params.damage, self:GetAbility())

                EmitSoundOn("Hero_Oracle.FortunesEnd.Target", self:GetParent())

                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_aeon_disk_buff", {duration = self:GetAbility():GetSpecialValueFor("soul_keep_duration")})
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_black_king_bar_immune", {duration = self:GetAbility():GetSpecialValueFor("soul_keep_duration")})
                self:StartCooldown(self:GetAbility():GetSpecialValueFor("soul_keep_cooldown"))
            end 
        end 
	end
end

if modifier_item_dawnbreaker_active == nil then modifier_item_dawnbreaker_active = class({}) end 

function modifier_item_dawnbreaker_active:IsPurgable()
    return false
end

function modifier_item_dawnbreaker_active:IsHidden()
    return false
end

function modifier_item_dawnbreaker_active:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_item_dawnbreaker_active:OnCreated(table)
    if IsServer() then         
        EmitSoundOn("Hero_Oracle.FalsePromise.Healed", self:GetParent())

        if self:GetAbility():GetCaster():IsHasSuperStatus() then self:SetDuration(self:GetRemainingTime() + 2) end 
    end 
end

function modifier_item_dawnbreaker_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE 
    }

    return funcs
end

function modifier_item_dawnbreaker_active:GetModifierHPRegenAmplify_Percentage (params)
    return self:GetAbility():GetSpecialValueFor ("sunbright_heal_amp")
end

function modifier_item_dawnbreaker_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_combo_breaker.vpcf"
end

function modifier_item_dawnbreaker_active:StatusEffectPriority()
    return 1000
end

function modifier_item_dawnbreaker_active:GetEffectName ()
    return "particles/dawnbreaker/dawnbreaker.vpcf"
end
