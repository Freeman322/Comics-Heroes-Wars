doomsday_adaptive_armor = class({})
LinkLuaModifier( "modifier_doomsday_adaptive_armor", "abilities/doomsday_adaptive_armor.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_doomsday_adaptive_armor_active", "abilities/doomsday_adaptive_armor.lua",LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
function doomsday_adaptive_armor:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 80
    end

    return 0
end

function doomsday_adaptive_armor:GetBehavior()
    if 	self:GetCaster():HasScepter() then
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
    end
    return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function doomsday_adaptive_armor:GetIntrinsicModifierName()
    return "modifier_doomsday_adaptive_armor"
end

function doomsday_adaptive_armor:OnSpellStart()
    local duration = self:GetSpecialValueFor( "duration_scepter" )

    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_doomsday_adaptive_armor_active", { duration = duration }  )

    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    EmitSoundOn( "Item.CrimsonGuard.Cast", self:GetCaster() )

    self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_4 );
end
--------------------------------------------------------------------------------
-------------------------------------------------------------------------------
modifier_doomsday_adaptive_armor = class({})

function modifier_doomsday_adaptive_armor:IsHidden()
    return true
end

function modifier_doomsday_adaptive_armor:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

function modifier_doomsday_adaptive_armor:GetModifierIncomingDamage_Percentage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "absorb_fake" )
end
function modifier_doomsday_adaptive_armor:GetStatusEffectName()
    return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf"
end

function modifier_doomsday_adaptive_armor:StatusEffectPriority()
    return 1000
end


--------------------------------------------------------------------------------
modifier_doomsday_adaptive_armor_active = class({})

function modifier_doomsday_adaptive_armor_active:OnCreated( kv )
    if IsServer() then
        self:GetParent():SetRenderColor(255, 0, 0)
    end
end
function modifier_doomsday_adaptive_armor_active:OnDestroy( kv )
    if IsServer() then
        self:GetParent():SetRenderColor(255, 255, 255)
        EmitSoundOn( "Item.StarEmblem.Ally", self:GetCaster() )
    end
end
--------------------------------------------------------------------------------

function modifier_doomsday_adaptive_armor_active:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
    }

    return state
end

function doomsday_adaptive_armor:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

