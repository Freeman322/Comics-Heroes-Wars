ronan_soul_stole = class({})
LinkLuaModifier( "modifier_ronan_soul_stole", "abilities/ronan_soul_stole.lua",LUA_MODIFIER_MOTION_NONE )

function ronan_soul_stole:OnSpellStart()
    if IsServer() then 
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ronan_soul_stole", { duration = self:GetDuration() } )

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    end
end

modifier_ronan_soul_stole = class({})

function modifier_ronan_soul_stole:OnCreated( kv )
    if IsServer() then
        self.str = 0
        self.dmg = 0
        self.armor = 0
        self.move = 0

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        self.dmg = self:GetAbility():GetSpecialValueFor("damage")
        if self:GetCaster():HasTalent("special_bonus_unique_ronan") then 
            self.dmg = self.dmg + self:GetCaster():FindTalentValue("special_bonus_unique_ronan")
        end

        self.armor = self:GetAbility():GetSpecialValueFor("armor")
        if self:GetCaster():HasTalent("special_bonus_unique_ronan_1") then 
            self.armor = self.armor + self:GetCaster():FindTalentValue("special_bonus_unique_ronan_1")
        end

        self.armor = self:GetAbility():GetSpecialValueFor("movespeed")

        if self:GetCaster():HasItemInInventory("item_shere2")then 
            self.str = self:GetAbility():GetSpecialValueFor("bonus_stats_power_gem")
        end
    end
end

function modifier_ronan_soul_stole:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }

    return funcs
end

function modifier_ronan_soul_stole:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

function modifier_ronan_soul_stole:StatusEffectPriority()
    return 1000
end

function modifier_ronan_soul_stole:GetEffectName()
    return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end

function modifier_ronan_soul_stole:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ronan_soul_stole:GetModifierPhysicalArmorBonus()
    return self.armor
end

function modifier_ronan_soul_stole:GetModifierBonusStats_Strength()
    return self.str
end

function modifier_ronan_soul_stole:GetModifierMoveSpeedBonus_Percentage( params )
    return self.move
end

function modifier_ronan_soul_stole:GetModifierDamageOutgoing_Percentage( params )
    return self.dmg
end
