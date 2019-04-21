LinkLuaModifier ("modifier_palpatine_lightnings_thinker", "abilities/palpatine_lightnings.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_palpatine_lightnings", "abilities/palpatine_lightnings.lua", LUA_MODIFIER_MOTION_NONE)
palpatine_lightnings = class ({})

function palpatine_lightnings:GetCastRange (vLocation, hTarget)
    return self.BaseClass.GetCastRange (self, vLocation, hTarget)
end

function palpatine_lightnings:GetAOERadius ()
    return 400
end

function palpatine_lightnings:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end

function palpatine_lightnings:GetManaCost (hTarget)
    return self.BaseClass.GetManaCost (self, hTarget)
end

function palpatine_lightnings:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_AOE +  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end

function palpatine_lightnings:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = self:GetCursorPosition ()
    local team_id = caster:GetTeamNumber ()

    local thinker = CreateModifierThinker (caster, self, "modifier_palpatine_lightnings_thinker", {duration = self:GetSpecialValueFor("duration")}, point, team_id, false)
    AddFOWViewer (caster:GetTeam (), point, 450, 4, false)
    GridNav:DestroyTreesAroundPoint(point, 500, false)
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
end

modifier_palpatine_lightnings_thinker = class ( {})

function modifier_palpatine_lightnings_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()

        self:StartIntervalThink (0.05)
    end
end

function modifier_palpatine_lightnings_thinker:OnIntervalThink()
    local caster = self:GetAbility():GetCaster()
    local target_location = self:GetParent():GetAbsOrigin()
    local ability = self:GetAbility()

    local radius = ability:GetSpecialValueFor("far_radius")

    -- Targeting variables
    local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
    local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE

    -- Units to be caught in the black hole
    local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, 0, false)

    -- Calculate the position of each found unit in relation to the center
    for i,unit in ipairs(units) do
        local unit_location = unit:GetAbsOrigin()

        unit:AddNewModifier(caster, ability, "modifier_palpatine_lightnings", {duration = 0.1})
        local primary_damage = ability:GetSpecialValueFor("damage")
        local damage_percent = ability:GetSpecialValueFor("damage_perc")/100
        local damage = ((unit:GetMaxHealth()*damage_percent) + primary_damage)/20
        if unit:GetUnitName() == "npc_dota_warlock_golem_1" then
            return nil
        end
        if self:GetCaster():HasTalent("special_bonus_unique_palpatine") then
            damage = (self:GetCaster():FindTalentValue("special_bonus_unique_palpatine")*0.05) + damage
        end
        ApplyDamage({victim = unit, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS})

        EmitSoundOn( "Hero_Zuus.StaticField", unit )
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti6/maelstorm_ti6.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

        local nFXIndex2 = ParticleManager:CreateParticle( "particles/econ/events/ti6/maelstorm_ti6.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex2, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex2, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex2 );
    end
    if not self:GetAbility():IsChanneling() then
        self:Destroy()
    end
end

function modifier_palpatine_lightnings_thinker:CheckState()
    if self.duration then
        return {[MODIFIER_STATE_PROVIDES_VISION] = true}
    end
    return nil
end


modifier_palpatine_lightnings = class ( {})

function modifier_palpatine_lightnings:IsHidden()
    return true
end

function modifier_palpatine_lightnings:IsPurgable()
    return false
end

function modifier_palpatine_lightnings:IsDebuff ()
    return true
end

function modifier_palpatine_lightnings:IsStunDebuff ()
    return true
end

function modifier_palpatine_lightnings:GetEffectName ()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_palpatine_lightnings:GetEffectAttachType ()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_palpatine_lightnings:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

function modifier_palpatine_lightnings:GetOverrideAnimation (params)
    return ACT_DOTA_FLAIL
end

function modifier_palpatine_lightnings:CheckState ()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

function palpatine_lightnings:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

