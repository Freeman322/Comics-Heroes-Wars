--[[spiderman_extermination = class ( {})
LinkLuaModifier ("modifier_spiderman_extermination", "heroes/hero_spiderman/spiderman_extermination.lua", LUA_MODIFIER_MOTION_NONE)

function spiderman_extermination:OnSpellStart ()
    local caster = self:GetCaster ()
    local duration = self:GetSpecialValueFor ("duration")
    local radius = self:GetSpecialValueFor ("radius")
    local damage = self:GetSpecialValueFor ("bonus_damage")

    local nFXIndex = ParticleManager:CreateParticle ("particles/spiderman/spiderman_extermination_cast.vpcf", PATTACH_CUSTOMORIGIN, nil);
    ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster ():GetOrigin () + Vector (0, 0, 96), true);
    ParticleManager:SetParticleControl (nFXIndex, 1, Vector (1, 1, 1))
    ParticleManager:SetParticleControl (nFXIndex, 2, Vector (1, 1, 1))
    ParticleManager:SetParticleControl (nFXIndex, 3, Vector (1, 1, 1))
    ParticleManager:ReleaseParticleIndex (nFXIndex);

    EmitSoundOn ("Hero_Huskar.Life_Break", caster)

    local nearby_units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for i, targets in ipairs(nearby_units) do
        ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, nearby_ally)
        targets:AddNewModifier(caster, self, "modifier_spiderman_extermination", {duration = duration})
        ApplyDamage({attacker = caster, victim = targets, ability = self, damage = damage , damage_type = DAMAGE_TYPE_PURE})
    end
end

function spiderman_extermination:GetCastRange (vLocation, hTarget)
    return  self:GetSpecialValueFor ("radius")
end

modifier_spiderman_extermination = class ( {})

function modifier_spiderman_extermination:OnCreated( kv )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/spiderman/spiderman_extermination_status.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1, 1, 1) )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end
--------------------------------------------------------------------------------

function modifier_spiderman_extermination:IsDebuff ()
    return true
end

--------------------------------------------------------------------------------

function modifier_spiderman_extermination:IsStunDebuff ()
    return true
end

--------------------------------------------------------------------------------

function modifier_spiderman_extermination:GetEffectName ()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function modifier_spiderman_extermination:GetEffectAttachType ()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_spiderman_extermination:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_spiderman_extermination:GetOverrideAnimation (params)
    return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_spiderman_extermination:CheckState ()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end]]
LinkLuaModifier ("modifier_spiderman_extermination", "abilities/spiderman_extermination.lua", LUA_MODIFIER_MOTION_NONE)

if spiderman_extermination == nil then
    spiderman_extermination = class ( {})
end

function spiderman_extermination:GetIntrinsicModifierName ()
    return "modifier_spiderman_extermination"
end

function spiderman_extermination:GetCooldown( nLevel )
    if self:GetCaster():HasModifier("modifier_special_bonus_unique_spiderman") then
        return 1
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

if modifier_spiderman_extermination == nil then
    modifier_spiderman_extermination = class({})
end

function modifier_spiderman_extermination:IsHidden()
    return true
end

function modifier_spiderman_extermination:IsPurgable()
    return true
end

function modifier_spiderman_extermination:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_spiderman_extermination:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
            local damage = params.damage
            if self:GetAbility():IsCooldownReady() then
                self:GetParent():SetHealth( self:GetParent():GetHealth() + damage)
                EmitSoundOn( "Hero_Oracle.FalsePromise.Healed", target )
                self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
            end
        end
    end
end

function spiderman_extermination:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

