LinkLuaModifier ("modifier_doomsday_death_pact", "abilities/doomsday_death_pact.lua", LUA_MODIFIER_MOTION_NONE)
doomsday_death_pact = class ( {})
--------------------------------------------------------------------------------
function doomsday_death_pact:GetIntrinsicModifierName()
	return "modifier_doomsday_death_pact"
end

function doomsday_death_pact:OnSpellStart ()
    local hCaster = self:GetCaster ()
    local hTarget = self:GetCursorTarget ()


    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
        hTarget:Interrupt()

        local nCasterFX = ParticleManager:CreateParticle ("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
        ParticleManager:SetParticleControlEnt (nCasterFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin (), false)
        ParticleManager:ReleaseParticleIndex (nCasterFX)
        local nTargetFX = ParticleManager:CreateParticle ("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
        ParticleManager:SetParticleControlEnt (nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin (), false)
        ParticleManager:ReleaseParticleIndex (nTargetFX)

        EmitSoundOn ("Hero_VengefulSpirit.NetherSwap", hCaster)
        EmitSoundOn ("Hero_Dark_Seer.Surge", hTarget)

        hTarget:Kill(self, hCaster)
        if self:GetCaster():HasModifier("modifier_doomsday_death_pact") then
            local mod = self:GetCaster():FindModifierByName("modifier_doomsday_death_pact")
            mod:SetStackCount(mod:GetStackCount() + (hTarget:GetMaxHealth()*(self:GetSpecialValueFor("health_gain_pct")/100)))
        end
        hCaster:CalculateStatBonus()
    end
end


if modifier_doomsday_death_pact == nil then modifier_doomsday_death_pact = class({}) end

function modifier_doomsday_death_pact:IsPurgable(  )
    return false
end

function modifier_doomsday_death_pact:IsHidden()
    return true
end

function modifier_doomsday_death_pact:RemoveOnDeath()
    return false
end

function modifier_doomsday_death_pact:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
    }

    return funcs
end

function modifier_doomsday_death_pact:GetModifierExtraHealthBonus( params )
    return self:GetStackCount()
end

function doomsday_death_pact:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

