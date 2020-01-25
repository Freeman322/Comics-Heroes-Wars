item_soul_urn = class({})
LinkLuaModifier ("item_soul_urn_modifier", "items/item_soul_urn.lua", LUA_MODIFIER_MOTION_NONE)

function item_soul_urn:GetIntrinsicModifierName()
    return "item_soul_urn_modifier"
end
item_soul_urn_modifier = class({})

function item_soul_urn_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_soul_urn_modifier:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
    }

    return funcs
end

function item_soul_urn_modifier:OnTakeDamageKillCredit( params )
    if IsServer() then
        if params.inflictor and params.attacker == self:GetParent() then 
            if RollPercentage(self:GetAbility():GetSpecialValueFor("critical_chance")) then 
                local damage = (params.damage * (self:GetAbility():GetSpecialValueFor("critical_strike") / 100))

                if params.target == self:GetParent() then return end 
                
                pcall(function()
                    if params.target and not params.target:IsNull() then
                        SendOverheadEventMessage( params.target, OVERHEAD_ALERT_BONUS_POISON_DAMAGE , params.target, math.floor( damage ), nil )

                        ApplyDamage ( {
                            victim = params.target,
                            attacker = self:GetParent(),
                            damage = damage,
                            damage_type = params.damage_type,
                            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
                        })
                    end
                end)
            end 
        end 
    end 
end

function item_soul_urn_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_intellect" )
end

function item_soul_urn_modifier:GetModifierPhysicalArmorBonus ( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_armor" )
end

function item_soul_urn_modifier:GetModifierConstantManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen" )
end

function item_soul_urn_modifier:GetModifierPercentageCasttime()
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_cast_time" )
end

function item_soul_urn_modifier:GetModifierManaBonus()
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_mana" )
end

function item_soul_urn:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

