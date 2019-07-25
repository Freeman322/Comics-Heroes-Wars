---@class shazam_shazam
LinkLuaModifier( "modifier_shazam_shazam", "abilities/shazam_shazam.lua", LUA_MODIFIER_MOTION_NONE )

shazam_shazam = class({}) 

function shazam_shazam:IsStealable() return false end 

function shazam_shazam:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function shazam_shazam:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end
function shazam_shazam:GetChannelTime() return self:GetSpecialValueFor("fade_time") end
function shazam_shazam:OnAbilityPhaseStart() return true end

function shazam_shazam:OnSpellStart()
    if IsServer() then
        EmitSoundOn("chw.shazam", self:GetCaster())

        ---self:EndCooldown() self:RefundManaCost()

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
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_shazam_shazam", {
            duration = self:GetSpecialValueFor("max_duration") ---self:GetShazamDuration()
        })


        local nFXIndex = ParticleManager:CreateParticle( "particles/shazam/shazam_compression.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(200, 200, 0) )
        ParticleManager:SetParticleControl( nFXIndex, 6, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
    else
        self:EndCooldown()self:RefundManaCost()
    end
end

---@class modifier_shazam_shazam 

modifier_shazam_shazam = class({})

function modifier_shazam_shazam:IsBuff() return true end
function modifier_shazam_shazam:IsPurgable() return false end

function modifier_shazam_shazam:OnCreated(params) 
    if IsServer() then
        self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)

        self:StartIntervalThink(0.1) 

        Timers:CreateTimer(0.15, function()
            if self and not self:IsNull() then
                self:GetParent():Heal(self:GetParent():GetMaxHealth(), self:GetAbility())
            end
        end)
    end 
end

function modifier_shazam_shazam:OnIntervalThink()
    if IsServer() then 
        self:GetParent():Purge(false, true, false, true, true)
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
