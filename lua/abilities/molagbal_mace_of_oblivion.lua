if molagbal_mace_of_oblivion == nil then molagbal_mace_of_oblivion = class({}) end

LinkLuaModifier ("modifier_molagbal_mace_of_oblivion", "abilities/molagbal_mace_of_oblivion.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier ("modifier_molagbal_mace_of_oblivion_buff", "abilities/molagbal_mace_of_oblivion.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier ("modifier_molagbal_mace_of_oblivion_atr", "abilities/molagbal_mace_of_oblivion.lua", LUA_MODIFIER_MOTION_NONE )

function molagbal_mace_of_oblivion:GetIntrinsicModifierName ()
    return "modifier_molagbal_mace_of_oblivion"
end

function molagbal_mace_of_oblivion:OnSpellStart()
    if IsServer() then
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            local duration = self:GetSpecialValueFor( "active_duration" )

            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_molagbal_mace_of_oblivion_atr", { duration = duration, attr = hTarget:GetPrimaryAttribute() } )
            self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_molagbal_mace_of_oblivion_atr", { duration = duration, attr = hTarget:GetPrimaryAttribute() } )

            EmitSoundOn( "MolagBal.Maceofoblivion.Cast", hTarget ) EmitSoundOn( "MolagBal.Maceofoblivion.Target", self:GetCaster() )

            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 0.1})

            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_sfm_ink_swell_reveal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget );
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            if hTarget:GetHealthPercent() <= self:GetSpecialValueFor("kill_threshold") then ApplyDamage({attacker = self:GetCaster(), victim = hTarget, damage = 99999, damage_type = DAMAGE_TYPE_PURE, ability = self}) end 
        end 
    end 
end

if modifier_molagbal_mace_of_oblivion == nil then
    modifier_molagbal_mace_of_oblivion = class ( {})
end

function modifier_molagbal_mace_of_oblivion:IsHidden ()
    return true
end

function modifier_molagbal_mace_of_oblivion:IsPurgable()
    return false
end

function modifier_molagbal_mace_of_oblivion:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_molagbal_mace_of_oblivion:OnAttackLanded(params)
    if IsServer () then
        if params.attacker == self:GetParent() then
          if params.target:IsRealHero() then
                local hAbility = self:GetAbility ()            
                local duration = self:GetAbility():GetSpecialValueFor("duration")
                
                self:GetCaster():AddNewModifier (self:GetCaster(), self:GetAbility(), "modifier_molagbal_mace_of_oblivion_buff", {duration = duration}):IncrementStackCount()
                params.target:AddNewModifier (self:GetCaster(), self:GetAbility(), "modifier_molagbal_mace_of_oblivion_buff", {duration = duration}):IncrementStackCount()

                local manaDrain = self:GetAbility():GetSpecialValueFor("mana_drain")
                if self:GetCaster():HasTalent("special_bonus_unique_molag_bal_3") then manaDrain = manaDrain + self:GetCaster():FindTalentValue("special_bonus_unique_molag_bal_3") end 
                
                if not params.target:IsMagicImmune() then params.target:SpendMana(manaDrain, self:GetAbility()) self:GetParent():GiveMana(manaDrain) end 
            end
        end
    end

    return 0
end


if modifier_molagbal_mace_of_oblivion_buff == nil then
    modifier_molagbal_mace_of_oblivion_buff = class ( {})
end


function modifier_molagbal_mace_of_oblivion_buff:IsHidden ()
    return false
end

function modifier_molagbal_mace_of_oblivion_buff:RemoveOnDeath ()
    return true
end

function modifier_molagbal_mace_of_oblivion_buff:IsDebuff()
    return self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber()
end

function modifier_molagbal_mace_of_oblivion_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_molagbal_mace_of_oblivion_buff:GetModifierMoveSpeedBonus_Constant (params)
    if self:IsDebuff() then 
        return self:GetAbility():GetSpecialValueFor ("movespeed_slow") * (-1)
    end 
    return self:GetAbility():GetSpecialValueFor ("movespeed_slow") 
end

function modifier_molagbal_mace_of_oblivion_buff:GetModifierAttackSpeedBonus_Constant (params)
    if self:IsDebuff() then 
        return self:GetAbility():GetSpecialValueFor ("attack_speed_slow") * (-1)
    end 
    return self:GetAbility():GetSpecialValueFor ("attack_speed_slow") 
end

function modifier_molagbal_mace_of_oblivion_buff:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if modifier_molagbal_mace_of_oblivion_atr == nil then modifier_molagbal_mace_of_oblivion_atr = class({}) end

function modifier_molagbal_mace_of_oblivion_atr:IsHidden ()
    return false
end

function modifier_molagbal_mace_of_oblivion_atr:RemoveOnDeath ()
    return true
end

function modifier_molagbal_mace_of_oblivion_atr:IsDebuff()
    return self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber()
end

function modifier_molagbal_mace_of_oblivion_atr:OnCreated(parmas)
    if IsServer() then 
        self:SetStackCount(parmas.attr)
    end 
end

function modifier_molagbal_mace_of_oblivion_atr:GetEffectName(  )
    return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf"
end

function modifier_molagbal_mace_of_oblivion_atr:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_molagbal_mace_of_oblivion_atr:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }

    return funcs
end

function modifier_molagbal_mace_of_oblivion_atr:GetModifierBonusStats_Agility (params)
    if self:GetStackCount() == DOTA_ATTRIBUTE_AGILITY and self:IsDebuff() then 
        return self:GetAbility():GetSpecialValueFor ("primary_atr_drain") * (-1)
    elseif self:GetStackCount() == DOTA_ATTRIBUTE_AGILITY then 
        return self:GetAbility():GetSpecialValueFor ("primary_atr_drain") 
    end 
    return 
end

function modifier_molagbal_mace_of_oblivion_atr:GetModifierBonusStats_Intellect (params)
   if self:GetStackCount() == DOTA_ATTRIBUTE_INTELLECT and self:IsDebuff() then 
        return self:GetAbility():GetSpecialValueFor ("primary_atr_drain") * (-1)
    elseif self:GetStackCount() == DOTA_ATTRIBUTE_INTELLECT then 
        return self:GetAbility():GetSpecialValueFor ("primary_atr_drain") 
    end 
    return 
end

function modifier_molagbal_mace_of_oblivion_atr:GetModifierBonusStats_Strength (params)
    if self:GetStackCount() == DOTA_ATTRIBUTE_STRENGTH and self:IsDebuff() then 
        return self:GetAbility():GetSpecialValueFor ("primary_atr_drain") * (-1)
    elseif self:GetStackCount() == DOTA_ATTRIBUTE_STRENGTH  then 
        return self:GetAbility():GetSpecialValueFor ("primary_atr_drain") 
    end 
    return 
end

function modifier_molagbal_mace_of_oblivion_atr:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

