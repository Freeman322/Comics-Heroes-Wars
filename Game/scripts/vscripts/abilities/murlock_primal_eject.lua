LinkLuaModifier ("modifier_murlock_primal_eject", "abilities/murlock_primal_eject.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_murlock_primal_eject_heal", "abilities/murlock_primal_eject.lua", LUA_MODIFIER_MOTION_NONE)

murlock_primal_eject = class({})

function murlock_primal_eject:GetIntrinsicModifierName(  )
    return "modifier_murlock_primal_eject_heal"
end

function murlock_primal_eject:OnSpellStart ()
    if IsServer() then
        local caster = self:GetCaster()

        EmitSoundOn ("Hero_Silencer.GlaivesOfWisdom.Damage", caster)

        local duration = self:GetSpecialValueFor("duration")

        caster:AddNewModifier (caster, self, "modifier_murlock_primal_eject", { duration = duration })
        caster:AddNewModifier (caster, self, "modifier_invisible", { duration = duration })

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "sanji") == true then EmitSoundOn("Sanji.Cast4", caster) end
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "rat") then EmitSoundOn("Rat.Cast", self:GetCaster()) end
    end
end

modifier_murlock_primal_eject = class ( {})

function modifier_murlock_primal_eject:IsPurgable() return false end
function modifier_murlock_primal_eject:GetStatusEffectName() return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"end
function modifier_murlock_primal_eject:StatusEffectPriority() return 1000 end

function modifier_murlock_primal_eject:OnCreated( kv )
    if IsServer() then

        local nFXIndex = ParticleManager:CreateParticle( "particles/murlock/murlock_primal_eject.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eyeR" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eyeL" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 15, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 16, self:GetParent():GetOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        local tick = self:GetAbility():GetSpecialValueFor("const_tick")

        if self:GetCaster():HasTalent("special_bonus_unique_murloc_1") then tick = tick * 0.75 end 

        self:StartIntervalThink(tick)
        self:OnIntervalThink()
    end
end

function modifier_murlock_primal_eject:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local pos = caster:GetAbsOrigin()
        local radius = self:GetAbility():GetSpecialValueFor("radius")
    
        local nearby_units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        local target = nearby_units[1]
    
        if target and not target:IsNull() then
            EmitSoundOn("Hero_Riki.Blink_Strike", target)

            if target:IsCreep() and not target:IsAncient() then target:Kill (self:GetAbility (), caster) end

            caster:SetAbsOrigin(target:GetAbsOrigin())
            FindClearSpaceForUnit (caster, target:GetAbsOrigin (), false)

            local particle = ParticleManager:CreateParticle ("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControl (particle, 0, caster:GetAbsOrigin ()) -- Origin
            ParticleManager:SetParticleControl (particle, 1, target:GetAbsOrigin ()) -- Destination
            ParticleManager:SetParticleControl (particle, 5, target:GetAbsOrigin ()) -- Hit Glow
            ParticleManager:ReleaseParticleIndex (particle);

            ParticleManager:CreateParticle ("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, caster)

            caster:PerformAttack(target, true, true, true, false, false , false, true)
            target:Stop()
        end
    end
end

function modifier_murlock_primal_eject:OnDestroy()
    if IsServer() then
        local caster = self:GetParent()

        caster:SetHealth ((caster:GetMaxHealth ()) + caster:GetHealth())
        caster:SetMana ((caster:GetMaxMana ()) + caster:GetMana())
    end
end

function modifier_murlock_primal_eject:DeclareFunctions()

    return {
        MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
    }
end
function modifier_murlock_primal_eject:CheckState()
   
    return {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
end


function modifier_murlock_primal_eject:GetModifierBaseAttackTimeConstant( params )
    return 0.25
end

--------------------------------------------------------------------------------

function modifier_murlock_primal_eject:GetModifierPersistentInvisibility()
    return 1
end

function modifier_murlock_primal_eject:IsHidden()
    return true
end

function modifier_murlock_primal_eject:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end


function murlock_primal_eject:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

modifier_murlock_primal_eject_heal = class({})

function modifier_murlock_primal_eject_heal:IsHidden() return true end
function modifier_murlock_primal_eject_heal:IsPurgable() return true end

--------------------------------------------------------------------------------

function modifier_murlock_primal_eject_heal:OnCreated( kv )
	self.hp_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )

	if IsServer() then
		if self:GetParent():HasTalent("special_bonus_unique_murloc") then self.hp_regen = self.hp_regen * 2 end
	end
end

--------------------------------------------------------------------------------

function modifier_murlock_primal_eject_heal:OnRefresh( kv )
	self.hp_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
end

--------------------------------------------------------------------------------

function modifier_murlock_primal_eject_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_murlock_primal_eject_heal:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
end

function modifier_murlock_primal_eject_heal:GetModifierHealthRegenPercentage( params )
	return self.hp_regen
end
