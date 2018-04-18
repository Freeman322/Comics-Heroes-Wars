groot_divided_we_stand = class({})
LinkLuaModifier("modifier_groot_divided_we_stand", "abilities/groot_divided_we_stand.lua", LUA_MODIFIER_MOTION_NONE)

function groot_divided_we_stand:GetManaCost( hTarget )
    return (self:GetCaster():GetMaxMana()*0.01) + 20
end

function groot_divided_we_stand:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 0
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function groot_divided_we_stand:OnSpellStart()
    local caster = self:GetCaster()
    if IsServer() then
        if caster:HasScepter() then
            if not caster:HasModifier("modifier_groot_divided_we_stand") then
                caster:AddNewModifier( caster, self, "modifier_groot_divided_we_stand", nil )
            else
                local hRotBuff = caster:FindModifierByName( "modifier_groot_divided_we_stand" )
                if hRotBuff ~= nil then
                    hRotBuff:Destroy()
                end
            end
        else
            caster:AddNewModifier(caster, self, "modifier_groot_divided_we_stand", {duration = self:GetSpecialValueFor("duration")})
        end
    end
end

if modifier_groot_divided_we_stand == nil then modifier_groot_divided_we_stand = class({}) end

function modifier_groot_divided_we_stand:IsPurgable()
    return false
end

function modifier_groot_divided_we_stand:IsHidden()
    return false
end

function modifier_groot_divided_we_stand:GetEffectName()
    return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf"
end

function modifier_groot_divided_we_stand:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_groot_divided_we_stand:OnCreated(table)
    if IsServer() then
        local hero = self:GetParent()
        local projectile_model = "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"

        -- Saves the original model and attack capability
        if self.caster_model == nil then
            self.caster_model = hero:GetModelName()
        end
        self.caster_attack = hero:GetAttackCapability()

        -- Sets the new model and projectile
        hero:SetOriginalModel("models/heroes/furion/treant.vmdl")
        hero:SetRangedProjectileName(projectile_model)

        -- Sets the new attack type
        hero:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

        hero:SetModelScale(0.80)

        if hero:HasScepter() then
            self:StartIntervalThink(1)
        end
    end
end

function modifier_groot_divided_we_stand:OnIntervalThink()
   if IsServer() then
    self:GetParent():SetMana(self:GetParent():GetMana() - ((self:GetParent():GetMana()*0.01) + 25))
   end
end

function modifier_groot_divided_we_stand:OnDestroy()
    if IsServer() then
         local hero = self:GetParent()

        hero:SetModel(self.caster_model)
        hero:SetOriginalModel(self.caster_model)
        hero:SetAttackCapability(self.caster_attack)
        hero:SetModelScale(90)
    end
end

function modifier_groot_divided_we_stand:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}

return funcs
end

function modifier_groot_divided_we_stand:GetModifierAttackRangeBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_range" )
end

function modifier_groot_divided_we_stand:GetModifierMoveSpeedBonus_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "speed_loss" )
end

function modifier_groot_divided_we_stand:GetModifierBaseAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end

function modifier_groot_divided_we_stand:GetModifierConstantManaRegen()
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_regen" )

end

function modifier_groot_divided_we_stand:GetModifierBaseAttackTimeConstant()
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "base_attack_time" )
end

function modifier_groot_divided_we_stand:GetModifierBonusStats_Strength()
    local hAbility = self:GetAbility()
    if self:GetParent():HasScepter() then
        return hAbility:GetSpecialValueFor( "bonus_str_scepter" )
    end
    return 0
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function groot_divided_we_stand:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

