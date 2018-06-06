ursa_inner_beast = class({})
LinkLuaModifier( "modifier_ursa_inner_beast", "abilities/ursa_inner_beast.lua", LUA_MODIFIER_MOTION_NONE )

function ursa_inner_beast:IsHiddenWhenStolen()
    return true
end

function ursa_inner_beast:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function ursa_inner_beast:OnSpellStart()
    local duration = self:GetSpecialValueFor( "duration" )

    if self:GetCaster():HasTalent("special_bonus_unique_ursa_warrior") then
        duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_ursa_warrior")
    end

    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ursa_inner_beast", { duration = duration } )

    EmitSoundOn("Hero_Ursa.Enrage", self:GetCaster() )
end


modifier_ursa_inner_beast = class({})

function modifier_ursa_inner_beast:GetStatusEffectName()
    return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function modifier_ursa_inner_beast:GetEffectName()
    return "particles/hero_ursa/ursa_infernal_rage_buff.vpcf"
end

function modifier_ursa_inner_beast:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ursa_inner_beast:IsBuff()
    return true
end

function modifier_ursa_inner_beast:IsHidden()
    return false
end

function modifier_ursa_inner_beast:IsPurgable()
    return false
end

function modifier_ursa_inner_beast:OnCreated(params)
    if IsServer() then 
        self.reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
        self.damage = self:GetAbility():GetSpecialValueFor("damage_mult_tooltip")

        if self:GetCaster():HasTalent("special_bonus_unique_ursa_warrior_1") then
            self.reduction = self.reduction + self:GetCaster():FindTalentValue("special_bonus_unique_ursa_warrior_1")
        end

        if self:GetCaster():HasTalent("special_bonus_unique_ursa_warrior_4") then
            self.damage = self.damage + (self:GetCaster():FindTalentValue("special_bonus_unique_ursa_warrior_4") * 100)
        end
    end
end

function modifier_ursa_inner_beast:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }
    return funcs
end

function modifier_ursa_inner_beast:GetModifierIncomingDamage_Percentage( params )
    return self.reduction * (-1)
end

function modifier_ursa_inner_beast:GetModifierBaseDamageOutgoing_Percentage( params )
    return self.damage
end