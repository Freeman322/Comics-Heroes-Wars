LinkLuaModifier("modifier_item_rapier_of_despair", "items/item_rapier_of_despair", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_rapier_of_despair_buff", "items/item_rapier_of_despair", LUA_MODIFIER_MOTION_NONE)

item_rapier_of_despair = class ({})

function item_rapier_of_despair:GetIntrinsicModifierName()
    return "modifier_item_rapier_of_despair"
end

function item_rapier_of_despair:OnSpellStart()
    if IsServer() then
        local vLoc = self:GetCursorPosition()

        EmitSoundOn("Hero_ObsidianDestroyer.Equilibrium.Cast", self:GetCaster())

	    local nFXIndex = ParticleManager:CreateParticle("particles/econ/items/witch_doctor/wd_ti8_immortal_head/wd_ti8_immortal_maledict_aoe.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl( nFXIndex, 0, vLoc )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetSpecialValueFor("despair_radius"), self:GetSpecialValueFor("despair_radius"), 1) )
        ParticleManager:ReleaseParticleIndex( nFXIndex ) 

        local units = FindUnitsInRadius(self:GetCaster():GetTeam(), vLoc, nil, self:GetSpecialValueFor("despair_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
        for i, target in ipairs(units) do  
            EmitSoundOn("Hero_ObsidianDestroyer.Equilibrium.Damage", target)

            ParticleManager:CreateParticle("particles/econ/items/lifestealer/lifestealer_immortal_backbone/lifestealer_immortal_backbone_rage_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            
            target:AddNewModifier(self:GetCaster(), self, "modifier_orchid_malevolence_debuff", {duration = self:GetSpecialValueFor("despair_duration")})
            target:AddNewModifier(self:GetCaster(), self, "modifier_item_rapier_of_despair_buff", {duration = self:GetSpecialValueFor("despair_duration")})
        end
    end
end

modifier_item_rapier_of_despair_buff = class({})

function modifier_item_rapier_of_despair_buff:IsHidden() return false end
function modifier_item_rapier_of_despair_buff:IsPurgable() return false end
function modifier_item_rapier_of_despair_buff:RemoveOnDeath() return true end
function modifier_item_rapier_of_despair_buff:DeclareFunctions() return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_item_rapier_of_despair_buff:GetEffectName() return "particles/econ/items/witch_doctor/wd_ti8_immortal_head/wd_ti8_immortal_maledict_dots.vpcf" end
function modifier_item_rapier_of_despair_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_rapier_of_despair_buff:GetModifierTotalDamageOutgoing_Percentage( params ) return -100 end
function modifier_item_rapier_of_despair_buff:GetModifierIncomingDamage_Percentage( params ) return self:GetAbility():GetSpecialValueFor("despair_damage_percent") end

modifier_item_rapier_of_despair = class ({})

function modifier_item_rapier_of_despair:IsPurgable() return false end
function modifier_item_rapier_of_despair:IsHidden() return true end
function modifier_item_rapier_of_despair:RemoveOnDeath() return false end 

function modifier_item_rapier_of_despair:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
    }
    return funcs
end

function modifier_item_rapier_of_despair:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_item_rapier_of_despair:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end
function modifier_item_rapier_of_despair:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_item_rapier_of_despair:GetModifierSpellAmplify_Percentage() return self:GetAbility():GetSpecialValueFor("spell_amp") end
function modifier_item_rapier_of_despair:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
function modifier_item_rapier_of_despair:GetModifierPercentageCasttime() return self:GetAbility():GetSpecialValueFor("bonus_casttime") end

--[[[function modifier_item_rapier_of_despair:GetModifierPreAttack_CriticalStrike(params)
    if IsServer() then 
        if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
            params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_rupture", {duration = self:GetAbility():GetSpecialValueFor("despair_duration")}) 
            return self:GetAbility():GetSpecialValueFor("crit_multiplier")
        end 
    end 
    return 
end]]--

