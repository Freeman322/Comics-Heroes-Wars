crystal_maiden_frost_shield = class({})

LinkLuaModifier( "modifier_crystal_maiden_frost_shield", "abilities/crystal_maiden_frost_shield.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frost_shield_stun", "abilities/crystal_maiden_frost_shield.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function crystal_maiden_frost_shield:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
        local duration = self:GetSpecialValueFor( "duration" )
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_crystal_maiden_frost_shield", { duration = duration } )
        hTarget:Purge( false, true, false, true, false )
        -- (bool RemovePositiveBuffs, bool RemoveDebuffs, bool BuffsCreatedThisFrameOnly, bool RemoveStuns, bool RemoveExceptions
        EmitSoundOn( "Hero_Abaddon.AphoticShield.Cast", hTarget )
	end
end

modifier_crystal_maiden_frost_shield = class({})

function modifier_crystal_maiden_frost_shield:GetTexture()
    return "frost_shield"
end

function modifier_crystal_maiden_frost_shield:IsPurgable()
    return false
end

function modifier_crystal_maiden_frost_shield:OnCreated( params )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/elsa_frost_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(100, 1, 1))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(100, 1, 1))
        ParticleManager:SetParticleControl( nFXIndex, 4, Vector(100, 1, 1))
        ParticleManager:SetParticleControlEnt( nFXIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        EmitSoundOn ("Hero_Crystal.CrystalNova", self:GetParent())
        self.damage_absorb = self:GetAbility():GetSpecialValueFor("damage_absorb")
        if self:GetCaster():HasTalent("special_bonus_unique_jaina") then
            self.damage_absorb = self:GetAbility():GetSpecialValueFor("damage_absorb") + self:GetCaster():FindTalentValue("special_bonus_unique_jaina")
        end
    end
end

function modifier_crystal_maiden_frost_shield:OnDestroy( params )
    if IsServer() then
        EmitSoundOn("DOTA_Item.Mekansm.Activate", self:GetParent())
	    ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

        local nearby_units = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, nearby_enemy in ipairs(nearby_units) do  --Restore health and play a particle effect for every found ally.
            EmitSoundOn("hero_Crystal.frostbite", nearby_enemy)
            ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, nearby_ally)

            nearby_enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_crystal_maiden_frost_shield_stun", {duration = self:GetAbility():GetSpecialValueFor( "frost_embrace_dur" )})
        end
    end
end


function modifier_crystal_maiden_frost_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end

function modifier_crystal_maiden_frost_shield:GetModifierIncomingDamage_Percentage( params )
    return -100
end


function modifier_crystal_maiden_frost_shield:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local caster = params.unit
            local damage = params.original_damage

            if self.damage_absorb >= damage then
                self.damage_absorb = self.damage_absorb - damage
                EmitSoundOn("Hero_Pugna.NetherWard.Target", self:GetParent())
            else
                self:Destroy()
            end
        end
    end
end

modifier_crystal_maiden_frost_shield_stun = class({})

function modifier_crystal_maiden_frost_shield_stun:OnCreated( kv )
	if IsServer() then
		ApplyDamage( {attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage_absorb"), damage_type = DAMAGE_TYPE_MAGICAL} )
        -- Damage an npc.
	end
end


function modifier_crystal_maiden_frost_shield_stun:GetEffectName()
	return "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror_recipient.vpcf"
end

--------------------------------------------------------------------------------

function modifier_crystal_maiden_frost_shield_stun:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_crystal_maiden_frost_shield_stun:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_crystal_maiden_frost_shield_stun:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_crystal_maiden_frost_shield_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function modifier_crystal_maiden_frost_shield_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_crystal_maiden_frost_shield_stun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_crystal_maiden_frost_shield_stun:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_crystal_maiden_frost_shield_stun:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function crystal_maiden_frost_shield:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

