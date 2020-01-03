if godspeed_gods_speed == nil then godspeed_gods_speed = class({}) end

LinkLuaModifier( "modifier_godspeed_gods_speed", "abilities/godspeed_gods_speed.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_godspeed_gods_speed_passive", "abilities/godspeed_gods_speed.lua", LUA_MODIFIER_MOTION_NONE )

function godspeed_gods_speed:GetIntrinsicModifierName()
    return "modifier_godspeed_gods_speed_passive"
end

function godspeed_gods_speed:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function godspeed_gods_speed:OnSpellStart()
    if IsServer() then
        EmitSoundOn( "Savitar.Ult.Cast", self:GetCaster() )

        local duration = self:GetSpecialValueFor("duration")

        if self:GetCaster():HasTalent("special_bonus_unique_godspeed_1") then duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_godspeed_1") end

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_cast_moonfall_gold.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() );
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin());
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_godspeed_gods_speed", {duration = duration})
    end
end

if modifier_godspeed_gods_speed == nil then modifier_godspeed_gods_speed = class({}) end

function modifier_godspeed_gods_speed:IsHidden()
    return false
end

function modifier_godspeed_gods_speed:IsPurgable()
    return false
end

function modifier_godspeed_gods_speed:GetPriority()
    return MODIFIER_PRIORITY_ULTRA
end

function modifier_godspeed_gods_speed:GetEffectName()
    return "particles/godspeed/godspeed_godsspeed_buff.vpcf"
end

function modifier_godspeed_gods_speed:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_godspeed_gods_speed:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_godspeed_gods_speed:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_godspeed_gods_speed:GetModifierMoveSpeedBonus_Percentage_Unique( params )
    return self:GetAbility():GetSpecialValueFor("active_speed")
end


modifier_godspeed_gods_speed_passive = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
})

function modifier_godspeed_gods_speed_passive:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_godspeed_gods_speed_passive:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_speed")
end

function modifier_godspeed_gods_speed_passive:OnAttackLanded (params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() and self:GetParent():IsRealHero() then
        local target = params.target

        local ptc = self:GetAbility():GetSpecialValueFor("speed_factor")

        if self:GetCaster():HasTalent("special_bonus_unique_godspeed_2") then ptc = ptc + self:GetCaster():FindTalentValue("special_bonus_unique_godspeed_2") end

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOn( "Hero_DoomBringer.InfernalBlade.Target", target )

        ApplyDamage({
            victim = target,
            attacker = self:GetCaster(),
            ability = self:GetAbility(),
            damage = (ptc / 100) * self:GetCaster():GetIdealSpeed(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
        })
    end
end
