if item_sacred_staff_null == nil then
    item_sacred_staff_null = class({})
end
LinkLuaModifier( "item_sacred_scepter_passive_modifier", "items/item_sacred_staff_null.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_sacred_scepter_active_modifier", "items/item_sacred_staff_null.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function item_sacred_staff_null:GetIntrinsicModifierName()
    return "item_sacred_scepter_passive_modifier"
end
function item_sacred_staff_null:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function item_sacred_staff_null:OnSpellStart()
    local hTarget = self:GetCursorTarget()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb( self ) ) then
            local duration = self:GetSpecialValueFor("duration")
            hTarget:AddNewModifier( self:GetCaster(), self, "item_sacred_scepter_active_modifier", {duration = 8} )
            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti5/dagon_ti5.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
            ParticleManager:SetParticleControl(nFXIndex, 2, Vector(1, 0, 0));
            ParticleManager:ReleaseParticleIndex( nFXIndex );
            EmitSoundOn( "DOTA_Item.DiffusalBlade.Kill", self:GetCaster() )
        end
    end
end

--------------------------------------------------------------------------------
if item_sacred_scepter_passive_modifier == nil then
    item_sacred_scepter_passive_modifier = class({})
end

function item_sacred_scepter_passive_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_sacred_scepter_passive_modifier:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

return funcs
end

function item_sacred_scepter_passive_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "all" )
end

function item_sacred_scepter_passive_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "all" )
end
function item_sacred_scepter_passive_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "all" )
end

function item_sacred_scepter_passive_modifier:GetModifierBaseAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end

function item_sacred_scepter_passive_modifier:GetModifierAttackSpeedBonus_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_attack_speed" )
end

if item_sacred_scepter_active_modifier == nil then
    item_sacred_scepter_active_modifier = class({})
end
function item_sacred_scepter_active_modifier:GetStatusEffectName()
    return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end
function item_sacred_scepter_active_modifier:OnCreated(event)
    if IsServer() then
        self:StartIntervalThink(0.8)
    end
end

function item_sacred_scepter_active_modifier:OnIntervalThink()
    if IsServer() then
        local target = self:GetParent()
        local caster = self:GetCaster()
        local target_pos = target:GetAbsOrigin()

        -- Adds spell duration to cooldowns of all of the target's abilities currently on cooldown
        for i=0, 15 do
            if target:GetAbilityByIndex(i) ~= nil then
                local cd = target:GetAbilityByIndex(i):GetCooldownTimeRemaining()
                if cd >= 0 then
                    target:GetAbilityByIndex(i):EndCooldown()
                    target:GetAbilityByIndex(i):StartCooldown(cd + 1.5)
                    EmitSoundOn( "DOTA_Item.Butterfly", self:GetCaster() )
                    ApplyDamage({victim = target, attacker = caster, damage = cd, damage_type = DAMAGE_TYPE_PURE, ability = self})
                end
            end
        end
    end
end

function item_sacred_scepter_active_modifier:CheckState()
    if self.duration then
        return {[MODIFIER_STATE_MUTED] = true}
    end
    return nil
end
function item_sacred_staff_null:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

