if not loki_wind_walk then loki_wind_walk = class({}) end

LinkLuaModifier( "modifier_loki_invis", "abilities/loki_wind_walk.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_loki_triks_of_the_trade_crit", "abilities/loki_wind_walk.lua" ,LUA_MODIFIER_MOTION_NONE )

function loki_wind_walk:OnSpellStart()
    local caster = self:GetCaster()
    EmitSoundOn("Hero_Weaver.Shukuchi", caster)
    local duration = self:GetSpecialValueFor("duration")
    caster:AddNewModifier(caster, self, "modifier_loki_invis", {duration = duration})
    ---caster:AddNewModifier(caster, self, "modifier_invisible", {duration = duration})

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "lovuska_jokera") == true then
        EmitSoundOn("Loki.CustomCast2", caster)
    end
end

function loki_wind_walk:OnUpgrade()
end

modifier_loki_invis = class({})

function modifier_loki_invis:OnCreated()
    self.speed = self:GetAbility():GetSpecialValueFor("speed")
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_weaver/weaver_shukuchi.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(50, 50, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_loki_invis:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_EVENT_ON_BREAK_INVISIBILITY,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_loki_invis:OnBreakInvisibility(args)
---self:Destroy()
end

function modifier_loki_invis:GetModifierInvisibilityLevel(args)
    return 1
end

function modifier_loki_invis:CheckState()
    local state = {
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
    }

    return state
end

function modifier_loki_invis:GetModifierMoveSpeed_Max( params )
    return self.speed
end

function modifier_loki_invis:GetModifierMoveSpeed_Limit( params )
    return self.speed
end

function modifier_loki_invis:GetModifierMoveSpeed_Absolute( params )
    return self.speed
end

function modifier_loki_invis:OnAttackLanded( params )
    if params.attacker == self:GetParent() then
        EmitSoundOn("DOTA_Item.MKB.Minibash", params.target)
        self:GetParent():PerformAttack(params.target, true, true, true, true, false, true, true)
        self:GetParent():PerformAttack(params.target, true, true, true, true, false, true, true)
        self:GetParent():PerformAttack(params.target, true, true, true, true, false, true, true)
        self:Destroy()
    end
end

function modifier_loki_invis:IsHidden()
    return true
end

if not modifier_loki_triks_of_the_trade_crit then modifier_loki_triks_of_the_trade_crit = class({}) end

function modifier_loki_triks_of_the_trade_crit:IsHidden ()
    return true
end

function modifier_loki_triks_of_the_trade_crit:RemoveOnDeath ()
    return true
end

function modifier_loki_triks_of_the_trade_crit:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }

    return funcs
end

function modifier_loki_triks_of_the_trade_crit:GetModifierPreAttack_CriticalStrike (params)
    return self:GetAbility():GetSpecialValueFor("crit")
end

function loki_wind_walk:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_lovuska_jokera") then return "custom/loki_wind_walk_custom" end
    return self.BaseClass.GetAbilityTextureName(self) 
end