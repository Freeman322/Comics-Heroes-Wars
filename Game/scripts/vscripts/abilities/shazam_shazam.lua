---@class shazam_shazam
LinkLuaModifier( "modifier_shazam_shazam", "abilities/shazam_shazam.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shazam_shazam_cooldown", "abilities/shazam_shazam.lua", LUA_MODIFIER_MOTION_NONE )

shazam_shazam = class({}) 

function shazam_shazam:IsStealable() return false end 
function shazam_shazam:GetIntrinsicModifierName() return "modifier_shazam_shazam_cooldown" end 
function shazam_shazam:GetCooldownBuff() return self:GetCaster():FindModifierByName("modifier_shazam_shazam_cooldown") end
function shazam_shazam:GetShazamDuration() return self:GetCaster():FindModifierByName("modifier_shazam_shazam_cooldown"):GetDurationTime() end

shazam_shazam.m_hBuff = nil

function shazam_shazam:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function shazam_shazam:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end
function shazam_shazam:GetChannelTime() return self:GetSpecialValueFor("fade_time") end
function shazam_shazam:OnAbilityPhaseStart() return true end

function shazam_shazam:OnSpellStart()
    if IsServer() then
        EmitSoundOn("chw.shazam", self:GetCaster())

        self:EndCooldown() self:RefundManaCost()

        local nFXIndex = ParticleManager:CreateParticle( "particles/shazam/shazam_compression.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(200, 200, 0) )
        ParticleManager:SetParticleControl( nFXIndex, 6, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
    end 
end

function shazam_shazam:OnChannelFinish( bInterrupted )
    if not bInterrupted then
        if self.m_hBuff and not self.m_hBuff:IsNull() then self.m_hBuff:Destroy() self:GetCooldownBuff():OnShazam(false) return nil end 
        
        self.m_hBuff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_shazam_shazam", {
            duration = self:GetShazamDuration()
        })

        local nFXIndex = ParticleManager:CreateParticle( "particles/shazam/shazam_compression.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(200, 200, 0) )
        ParticleManager:SetParticleControl( nFXIndex, 6, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        
        self:GetCooldownBuff():OnShazam(true) 
	end
end


---@class modifier_shazam_shazam_cooldown 

modifier_shazam_shazam_cooldown = class({}) 

modifier_shazam_shazam_cooldown.m_iCooldown = 0
modifier_shazam_shazam_cooldown.m_bOnCooldown = false
modifier_shazam_shazam_cooldown.m_iDurationTime = 18
modifier_shazam_shazam_cooldown.m_iMaxDurationTime = 18

local INTERVAL_THINK = 0.1

function modifier_shazam_shazam_cooldown:IsHidden() return false end
function modifier_shazam_shazam_cooldown:IsPurgable() return false end
function modifier_shazam_shazam_cooldown:RemoveOnDeath() return false end
function modifier_shazam_shazam_cooldown:DestroyOnExpire() return false end

function modifier_shazam_shazam_cooldown:OnCreated(params)
    if IsServer() then
        self.m_iMaxDurationTime = self:GetAbility():GetSpecialValueFor("max_duration")
        self.m_iDurationTime = self.m_iMaxDurationTime
        self.m_iCooldown = self:GetCaster():GetCooldownTimeAfterReduction(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))

        self:StartIntervalThink(INTERVAL_THINK)
    end 
end

function modifier_shazam_shazam_cooldown:OnIntervalThink()
    if IsServer() then 
        self:GetAbility():SetActivated(self.m_iDurationTime > 0)
        
        if not self.m_bOnCooldown and not self:GetParent():HasModifier("modifier_shazam_shazam") and self.m_iDurationTime <= self.m_iMaxDurationTime then
            self.m_iDurationTime = self.m_iDurationTime + INTERVAL_THINK
        end 

        if self:GetParent():HasModifier("modifier_shazam_shazam") then
            self.m_iDurationTime = self.m_iDurationTime - INTERVAL_THINK

            if self.m_iDurationTime <= 0 then
                self:GetParent():RemoveModifierByName("modifier_shazam_shazam")

                self:GetAbility():UseResources(true, false, true)
                self:SetDuration(self.m_iCooldown, true)
                self.m_bOnCooldown = true
            end 
        end 

        if self.m_bOnCooldown and self:GetRemainingTime() <= 0 then
            self.m_bOnCooldown = false
        end 
    end 
end

function modifier_shazam_shazam_cooldown:OnShazam(created)
    if IsServer() then 
        if created then
        else 
        end 
    end 
end


function modifier_shazam_shazam_cooldown:GetDurationTime(created)
    if IsServer() then 
        return m_iDurationTime
    end 
end

---@class modifier_shazam_shazam 

modifier_shazam_shazam = class({})

function modifier_shazam_shazam:IsBuff() return true end
function modifier_shazam_shazam:IsPurgable() return false end

function modifier_shazam_shazam:OnCreated(params) 
    if IsServer() then
        self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
        
    end 
end

function modifier_shazam_shazam:OnDestroy() 
    if IsServer() then
        self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
    end 
end

function modifier_shazam_shazam:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,

        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
        
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,

        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }

    return funcs
end

function modifier_shazam_shazam:GetModifierModelChange(params)
    return "models/heroes/hero_shazam/shazam/shazam.vmdl"
end

function modifier_shazam_shazam:GetModifierHealthBonus(params) return self:GetAbility():GetSpecialValueFor("health") end
function modifier_shazam_shazam:GetModifierPhysicalArmorBonus(params) return self:GetAbility():GetSpecialValueFor("armor") end
function modifier_shazam_shazam:GetModifierMagicalResistanceBonus(params) return self:GetAbility():GetSpecialValueFor("magical_resistance") end
function modifier_shazam_shazam:GetModifierSpellAmplify_Percentage(params) return self:GetAbility():GetSpecialValueFor("spell_damage") end
function modifier_shazam_shazam:GetModifierPreAttack_BonusDamage(params) return self:GetAbility():GetSpecialValueFor("damage") end
function modifier_shazam_shazam:GetModifierAttackSpeedBaseOverride(params) return self:GetAbility():GetSpecialValueFor("fixed_attack_speed") end
function modifier_shazam_shazam:GetModifierMoveSpeed_Absolute(params) return self:GetAbility():GetSpecialValueFor("move_speed") end
function modifier_shazam_shazam:GetModifierMoveSpeed_Limit(params) return self:GetAbility():GetSpecialValueFor("move_speed") end
function modifier_shazam_shazam:GetModifierMoveSpeed_Max(params) return self:GetAbility():GetSpecialValueFor("move_speed") end
function modifier_shazam_shazam:GetModifierAttackRangeBonus(params) return -422 end
