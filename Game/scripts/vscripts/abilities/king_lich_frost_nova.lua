king_lich_frost_nova = class({})
LinkLuaModifier( "modifier_king_lich_frost_nova",   "abilities/king_lich_frost_nova.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function king_lich_frost_nova:OnSpellStart()
	local radius = self:GetSpecialValueFor( "radius" ) 
    local duration = self:GetSpecialValueFor(  "duration" )
    local target = self:GetCursorTarget()

    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
    if #units > 0 then
        for _,unit in pairs(units) do
            unit:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("duration") } )
            unit:AddNewModifier( self:GetCaster(), self, "modifier_king_lich_frost_nova", { duration = self:GetDuration() } )
            
            ApplyDamage({attacker = self:GetCaster(), victim = unit, damage = self:GetSpecialValueFor("aoe_damage"), damage_type = self:GetAbilityDamageType(), ability = self})
        end
    end

    if target and not target:IsNull() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_frost_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_ABSORIGIN, "attach_hitloc", target:GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, 1) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Ability.FrostNova", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
        
        ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbilityDamage(), damage_type = self:GetAbilityDamageType(), ability = self})
    end
end

if not modifier_king_lich_frost_nova then modifier_king_lich_frost_nova = class({}) end 

function modifier_king_lich_frost_nova:IsBuff ()
    return false
end

function modifier_king_lich_frost_nova:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_king_lich_frost_nova:GetEffectName()
    return "particles/items4_fx/meteor_hammer_spell_debuff.vpcf"
end

function modifier_king_lich_frost_nova:GetEffectAttachType ()
    return PATTACH_ABSORIGIN
end

function modifier_king_lich_frost_nova:GetStatusEffectName()
    return "particles/status_fx/status_effect_wyvern_curse_buff.vpcf"
end

function modifier_king_lich_frost_nova:StatusEffectPriority()
    return 1000
end

function modifier_king_lich_frost_nova:GetModifierMoveSpeedBonus_Percentage( params )
    return self:GetAbility():GetSpecialValueFor("slow_movement_speed")
end

function modifier_king_lich_frost_nova:GetModifierAttackSpeedBonus_Constant( params )
    return self:GetAbility():GetSpecialValueFor("slow_attack_speed")
end

