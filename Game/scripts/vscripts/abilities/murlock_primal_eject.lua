LinkLuaModifier ("modifier_murlock_primal_eject", "abilities/murlock_primal_eject.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_murlock_primal_eject_target", "abilities/murlock_primal_eject.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_murlock_primal_eject_heal", "abilities/murlock_primal_eject.lua", LUA_MODIFIER_MOTION_NONE)

murlock_primal_eject = class ( {})

function murlock_primal_eject:GetIntrinsicModifierName(  )
    return "modifier_murlock_primal_eject_heal"
end

function murlock_primal_eject:OnSpellStart ()
    local caster = self:GetCaster ()
    local sound = "Hero_Silencer.GlaivesOfWisdom.Damage"
    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "deep_murloc") then
        sound = "Deep_Murloc.Ulti"
    end
    EmitSoundOn (sound, caster)
    local duration = self:GetSpecialValueFor("duration")
    caster:AddNewModifier (caster, self, "modifier_murlock_primal_eject", { duration = duration })
    caster:AddNewModifier (caster, self, "modifier_invisible", { duration = duration })

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "sanji") == true then EmitSoundOn("Sanji.Cast4", caster) end
    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "rat") then EmitSoundOn("Rat.Cast", self:GetCaster()) end
end

modifier_murlock_primal_eject_heal = class({})

function modifier_murlock_primal_eject_heal:IsPurgable(  )
  return false
end

function modifier_murlock_primal_eject_heal:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
        self:StartIntervalThink(0.1)
	end
end


function modifier_murlock_primal_eject_heal:OnIntervalThink()
    local caster = self:GetParent()
    local pos = caster:GetAbsOrigin()
    local radius = self:GetAbility():GetSpecialValueFor("radius")
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    self.regen = self:GetAbility():GetSpecialValueFor( "health_regen" )

    if #units > 0 then
        self.regen = 0
    else
        self.regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
        if self:GetCaster():HasTalent("special_bonus_unique_murloc") then
            self.regen = self.regen*2
        end
    end
end

--------------------------------------------------------------------------------

function modifier_murlock_primal_eject_heal:DeclareFunctions()

	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_murlock_primal_eject_heal:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
end

--------------------------------------------------------------------------------

function modifier_murlock_primal_eject_heal:GetModifierHealthRegenPercentage( params )
	return self.regen
end

modifier_murlock_primal_eject = class ( {})

function modifier_murlock_primal_eject:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_murlock_primal_eject:GetStatusEffectName()
    return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

--------------------------------------------------------------------------------

function modifier_murlock_primal_eject:StatusEffectPriority()
    return 1000
end

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
        self:StartIntervalThink(0.3)
    end
end

function modifier_murlock_primal_eject:OnIntervalThink()
    local caster = self:GetParent()
    local pos = caster:GetAbsOrigin()
    local radius = self:GetAbility():GetSpecialValueFor("radius")
    local nearby_units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius,
    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

    for i = 1, #nearby_units do  --Restore health and play a particle effect for every found ally.
        local target = nearby_units[1]
        EmitSoundOn("Hero_Riki.Blink_Strike", target)
        target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_murlock_primal_eject_target", {duration = 0.4})
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

modifier_murlock_primal_eject_target = class ( {})

function modifier_murlock_primal_eject_target:IsHidden ()
    return false
end

function modifier_murlock_primal_eject_target:IsPurgable ()
    return false
end

function modifier_murlock_primal_eject_target:OnCreated (kv)
    if IsServer () then
        local hTarget = self:GetParent ()
        local caster = self:GetAbility ():GetCaster ()
        self:StartIntervalThink(0.35)

        hTarget:Stop ()
    end
end


function modifier_murlock_primal_eject_target:OnIntervalThink ()
    if IsServer () then
        local target = self:GetParent ()
        local caster = self:GetAbility ():GetCaster ()
        if target:IsCreep () and not target:IsAncient() then
            target:Kill (self:GetAbility (), caster)
        end
        caster:SetAbsOrigin (target:GetAbsOrigin ())
        FindClearSpaceForUnit (caster, target:GetAbsOrigin (), false)
        caster:PerformAttack( target, true, true, true, false, false , false, true)
        local particle = ParticleManager:CreateParticle ("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl (particle, 0, caster:GetAbsOrigin ()) -- Origin
        ParticleManager:SetParticleControl (particle, 1, target:GetAbsOrigin ()) -- Destination
        ParticleManager:SetParticleControl (particle, 5, target:GetAbsOrigin ()) -- Hit Glow
        ParticleManager:ReleaseParticleIndex (particle);
        ParticleManager:CreateParticle ("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)
    end
end
--------------------------------------------------------------------------------
function modifier_murlock_primal_eject_target:OnDestroy (kv)
    if IsServer () then
        local target = self:GetParent()
        local caster = self:GetAbility():GetCaster()
        target:Stop()
        caster:Stop()
    end
end

function murlock_primal_eject:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end