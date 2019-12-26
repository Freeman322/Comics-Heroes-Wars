spawn_mystic_absorb = class({})

LinkLuaModifier( "modifier_spawn_mystic_absorb", "abilities/spawn_mystic_absorb.lua", LUA_MODIFIER_MOTION_NONE )


function spawn_mystic_absorb:CastFilterResultTarget( hTarget )
    if IsServer() then
        local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
        return nResult
    end

    return UF_SUCCESS
end

function spawn_mystic_absorb:GetCastRange( vLocation, hTarget )
    return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end


function spawn_mystic_absorb:OnSpellStart()
    local hTarget = self:GetCursorTarget()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb( self ) ) then
            local duration = self:GetSpecialValueFor( "duration" )

            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_spawn_mystic_absorb", { duration = duration } )
            self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_spawn_mystic_absorb", { duration = duration } )

            if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "pepe") then
                EmitSoundOn( "Pepe.Cast", self:GetCaster() )
            end
        end
    end
end

modifier_spawn_mystic_absorb = class({})

function modifier_spawn_mystic_absorb:IsDebuff()
    if self:GetParent() == self:GetCaster() then
        return false
    end
    return true
end

function modifier_spawn_mystic_absorb:IsHidden()
    return true
end

function modifier_spawn_mystic_absorb:IsPurgable()
    return true
end

function modifier_spawn_mystic_absorb:OnCreated(args)
    self.IsCasterModifier = true

    if IsServer() then
        local caster = self:GetCaster()
        local target = self:GetParent()

        if caster ~= target then
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_death_prophet/death_prophet_spiritsiphon.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin(), true )
            ParticleManager:SetParticleControl( nFXIndex, 5, Vector( self:GetAbility():GetSpecialValueFor("duration"), 0, 0) )
            ParticleManager:SetParticleControl( nFXIndex, 11, Vector( 1, 0, 0) )
            self:AddParticle( nFXIndex, false, false, -1, false, true )
            local status = ParticleManager:CreateParticle( "particles/status_fx/status_effect_earth_spirit_boulderslow.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
            self:AddParticle(status, false, true, 1000, false, false)

            EmitSoundOn("Hero_DeathProphet.SpiritSiphon.Cast", caster)
            EmitSoundOn("Hero_DeathProphet.SpiritSiphon.Target", target)

            self.IsCasterModifier = false

            self:StartIntervalThink(1)
        end
    end
end

function modifier_spawn_mystic_absorb:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local target = self:GetParent()

        if caster ~= target then
            local health = target:GetMaxHealth()*(self:GetAbility():GetSpecialValueFor("manahealth")/100)
            local mana = target:GetMaxMana()*(self:GetAbility():GetSpecialValueFor("manahealth")/100)

            target:ModifyHealth(target:GetHealth() - health, self:GetAbility(), true, 0)
            target:SetMana(target:GetMana() - mana)

            caster:Heal(health, self:GetAbility())
            caster:SetMana(caster:GetMana() + mana)

            self:SetStackCount(self:GetStackCount() + 1)
        end
    end
end

function modifier_spawn_mystic_absorb:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_spawn_mystic_absorb:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_spawn_mystic_absorb:GetModifierMoveSpeedBonus_Constant()
    if self.IsCasterModifier then
        return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("move_speed")
    else
        return self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("move_speed") * (-1))
    end
end

function modifier_spawn_mystic_absorb:GetModifierAttackSpeedBonus_Constant()
    if self.IsCasterModifier then
        return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("move_speed")
    else
        return self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("move_speed") * (-1))
    end
end

function spawn_mystic_absorb:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

