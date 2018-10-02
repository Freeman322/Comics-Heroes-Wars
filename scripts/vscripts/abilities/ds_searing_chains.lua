LinkLuaModifier ("modifier_ds_searing_chains", "abilities/ds_searing_chains.lua", LUA_MODIFIER_MOTION_NONE)
ds_searing_chains = class({})

function ds_searing_chains:OnSpellStart ()
    local caster = self:GetCaster ()
    local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor ("duration")
    local damage = self:GetSpecialValueFor ("damage")
    if IsServer () then
        if ( not target:TriggerSpellAbsorb( self ) ) then
            EmitSoundOn ("Hero_EmberSpirit.SearingChains.Cast", caster)
            EmitSoundOn ("Hero_EmberSpirit.SearingChains.Target", target)
            local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster () )
            ParticleManager:SetParticleControlEnt(nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster ():GetOrigin (), true)
            ParticleManager:SetParticleControl(nFXIndex, 1, Vector(200, 200, 0))
            ParticleManager:ReleaseParticleIndex (nFXIndex)
            target:AddNewModifier (caster, self, "modifier_ds_searing_chains", { duration = duration })
            ApplyDamage ( { victim = target, attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
        end
    end
end

modifier_ds_searing_chains = class({})
--------------------------------------------------------------------------------

function modifier_ds_searing_chains:OnCreated( kv )
    self.warcry_armor = self:GetAbility():GetSpecialValueFor( "warcry_armor" )
    self.warcry_movespeed = self:GetAbility():GetSpecialValueFor( "warcry_movespeed" )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_ds_searing_chains:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_ds_searing_chains:GetOverrideAnimation( params )
    return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_ds_searing_chains:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end
-----------------------------------------------------------------
function modifier_ds_searing_chains:GetEffectName()
    return "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf"
end

function modifier_ds_searing_chains:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function ds_searing_chains:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

