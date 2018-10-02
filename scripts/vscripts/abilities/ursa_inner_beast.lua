ursa_inner_beast = class({})
LinkLuaModifier( "modifier_ursa_inner_beast", "abilities/ursa_inner_beast.lua", LUA_MODIFIER_MOTION_NONE )

function ursa_inner_beast:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_ursa_devils_helmet") then
        return "custom/ursa_enrage"
    end
    return self.BaseClass.GetAbilityTextureName(self)
end

function ursa_inner_beast:IsHiddenWhenStolen()
    return true
end

function ursa_inner_beast:GetBehavior()
    if self:GetCaster():HasScepter() then
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
    end

    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function ursa_inner_beast:OnSpellStart()
    local duration = self:GetSpecialValueFor( "duration" )

    if self:GetCaster():HasTalent("special_bonus_unique_ursa_warrior") then
        duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_ursa_warrior")
    end

    if self:GetCaster():HasScepter() then 
        self:GetCaster():Purge(false, true, false, true, true)
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


        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "ursa_devils_helmet") == true then
            local _pfxParticle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_drunken_haze_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            self:AddParticle( _pfxParticle1, false, false, -1, false, true )
            EmitSoundOn("Ursa.VodkaItem.Cast", self:GetCaster())
            local warp = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_zeus/zues_screen_empty.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetCaster():GetOwner())
            self:AddParticle( warp, false, false, -1, false, true )
            self:AddParticle(ParticleManager:CreateParticleForPlayer("particles/generic_gameplay/screen_silence_indicator.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetCaster():GetOwner()), false, true, 1000, false, false)
            self:AddParticle(ParticleManager:CreateParticleForPlayer("particles/econ/items/zeus/arcana_chariot/zeus_tgw_screen_damage.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetCaster():GetOwner()), false, true, 1000, false, false)
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