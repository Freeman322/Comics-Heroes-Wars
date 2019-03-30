LinkLuaModifier ("modifier_item_ionic_vapor", "items/item_ionic_vapor.lua", LUA_MODIFIER_MOTION_NONE)

if item_ionic_vapor == nil then
    item_ionic_vapor = class ( {})
end

function item_ionic_vapor:GetIntrinsicModifierName ()
    return "modifier_item_ionic_vapor"
end

function item_ionic_vapor:OnSpellStart(  )
    if IsServer() then
        local hTaget = self:GetCursorTarget()
        hTaget:CutDown(self:GetCaster():GetTeamNumber())
    end
end

if modifier_item_ionic_vapor == nil then
    modifier_item_ionic_vapor = class ( {})
end

function modifier_item_ionic_vapor:IsHidden()
    return true
end

function modifier_item_ionic_vapor:IsPurgable()
    return false
end

function modifier_item_ionic_vapor:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end

function modifier_item_ionic_vapor:GetModifierConstantHealthRegen(params)
    return self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
end

function modifier_item_ionic_vapor:GetModifierConstantManaRegen(params)
    return self:GetAbility():GetSpecialValueFor("bonus_mp_regen")
end

function modifier_item_ionic_vapor:GetModifierPreAttack_BonusDamage (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_damage")
end

function modifier_item_ionic_vapor:GetModifierBonusStats_Strength (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_strength")
end

function modifier_item_ionic_vapor:GetModifierMoveSpeedBonus_Percentage (params)
    return self:GetAbility ():GetSpecialValueFor ("movement_speed_percent_bonus")
end

function modifier_item_ionic_vapor:GetModifierBonusStats_Agility (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_agility")
end

function modifier_item_ionic_vapor:GetModifierAttackSpeedBonus_Constant (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_attack_speed")
end

function modifier_item_ionic_vapor:OnAttackLanded (params)
    if IsServer() then
        if params.attacker == self:GetParent() then
        	if not params.target:IsBuilding() and RollPercentage(self:GetAbility():GetSpecialValueFor("maim_chance")) then
                local hTarget = params.target

                hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sange_and_yasha_buff", {duration = self:GetAbility():GetSpecialValueFor("maim_duration")})

                EmitSoundOn("DOTA_Item.Maim", hTarget)
                ScreenShake(hTarget:GetOrigin(), 100, 0.1, 0.3, 500, 0, true)
        	end
            if params.target ~= nil and params.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not self:GetParent():IsRangedAttacker() then

                local cleaveDamage = ( self:GetAbility():GetSpecialValueFor("cleave_damage_percent") * params.damage ) / 100.0

                DoCleaveAttack( self:GetParent(), params.target, self:GetAbility(), cleaveDamage, self:GetAbility():GetSpecialValueFor("cleave_starting_width"), self:GetAbility():GetSpecialValueFor("cleave_ending_width"), self:GetAbility():GetSpecialValueFor("cleave_distance"), "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf" )
            end
        end
    end
end

function modifier_item_ionic_vapor:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
