doctor_doom_sanity_curse = class ( {})

LinkLuaModifier ("modifier_doctor_doom_sanity_curse", "abilities/doctor_doom_sanity_curse.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function doctor_doom_sanity_curse:CastFilterResultTarget (hTarget)
    if IsServer () then

        if hTarget ~= nil and hTarget:IsMagicImmune () and ( not self:GetCaster ():HasScepter () ) then
            return UF_FAIL_MAGIC_IMMUNE_ENEMY
        end

        local nResult = UnitFilter (hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end


function doctor_doom_sanity_curse:GetCooldown (nLevel)
    if self:GetCaster ():HasScepter () then
        return self:GetSpecialValueFor("cooldown_scepter")
    end

    return self.BaseClass.GetCooldown (self, nLevel)
end
--------------------------------------------------------------------------------

function doctor_doom_sanity_curse:GetCastRange (vLocation, hTarget)
    return self.BaseClass.GetCastRange (self, vLocation, hTarget)
end

--------------------------------------------------------------------------------

function doctor_doom_sanity_curse:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local duration = self:GetSpecialValueFor ("duration")
            hTarget:AddNewModifier (self:GetCaster (), self, "modifier_doctor_doom_sanity_curse", { duration = duration } )
            EmitSoundOn ("Hero_DoomBringer.Devour", hTarget)
        end
        EmitSoundOn ("Hero_DoomBringer.LvlDeath", self:GetCaster () )
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_doctor_doom_sanity_curse = class({})

function modifier_doctor_doom_sanity_curse:OnCreated( kv )
    self.damage = self:GetAbility():GetSpecialValueFor( "damage_scepter" )/100
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/doctor_doom/doctor_doom_sanity_curce.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 10, Vector(0, 0, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        self:StartIntervalThink(1)
        self.soundName = "Hero_DoomBringer.Doom"
        StartSoundEvent( self.soundName, self:GetParent())
    end
end

function modifier_doctor_doom_sanity_curse:OnIntervalThink()
    if IsServer() then
        local target = self:GetParent()
        local attacker = self:GetCaster()
        local ability = self:GetAbility()
        local damage = 0
        if self:GetCaster():HasModifier("modifier_doom") and self:GetCaster():HasScepter() then
            local mod = self:GetCaster():FindModifierByName("modifier_doom")
            self.damage_bonus = mod:GetStackCount()*3
            damage = self:GetAbility():GetAbilityDamage() + (target:GetMaxHealth()*self.damage) + self.damage_bonus
        else
            damage = self:GetAbility():GetAbilityDamage()
        end
        ApplyDamage({attacker = attacker, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
    end
end

function modifier_doctor_doom_sanity_curse:OnDestroy()
    if IsServer() then
        StopSoundEvent(self.soundName, self:GetParent())
    end
end
--------------------------------------------------------------------------------

function modifier_doctor_doom_sanity_curse:OnRefresh( kv )
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" )/100
end

--------------------------------------------------------------------------------

function modifier_doctor_doom_sanity_curse:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_FIXED_DAY_VISION,
        MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end


function modifier_doctor_doom_sanity_curse:GetFixedNightVision( params )
    return self:GetAbility():GetSpecialValueFor("vision")
end

function modifier_doctor_doom_sanity_curse:GetModifierMoveSpeedBonus_Percentage( params )
    return self:GetAbility():GetSpecialValueFor("slowing")
end

--------------------------------------------------------------------------------

function modifier_doctor_doom_sanity_curse:GetFixedDayVision( params )
    return self:GetAbility():GetSpecialValueFor("vision")
end

function modifier_doctor_doom_sanity_curse:IsDebuff()
    return true
end

--------------------------------------------------------------------------------

function modifier_doctor_doom_sanity_curse:IsStunDebuff()
    return true
end

function modifier_doctor_doom_sanity_curse:IsPurgable()
    return false
end


function modifier_doctor_doom_sanity_curse:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_FAKE_ALLY] = true,
    }

    return state
end

function doctor_doom_sanity_curse:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

