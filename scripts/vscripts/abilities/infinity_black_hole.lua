LinkLuaModifier ("modifier_infinity_black_hole_thinker", "abilities/infinity_black_hole.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_infinity_black_hole", "abilities/infinity_black_hole.lua", LUA_MODIFIER_MOTION_NONE)
infinity_black_hole = class ({})

function infinity_black_hole:GetCastRange (vLocation, hTarget)
    return self.BaseClass.GetCastRange (self, vLocation, hTarget)
end

function infinity_black_hole:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_arcana") then return "custom/enigma_singularity" end
    return self.BaseClass.GetAbilityTextureName(self) 
end

function infinity_black_hole:GetAOERadius ()
    return 450
end

function infinity_black_hole:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end

function infinity_black_hole:GetManaCost (hTarget)
    return self.BaseClass.GetManaCost (self, hTarget)
end

function infinity_black_hole:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_AOE +  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end

function infinity_black_hole:GetChannelTime()
    return 4
end

function infinity_black_hole:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = self:GetCursorPosition ()
    local team_id = caster:GetTeamNumber ()
    local thinker = CreateModifierThinker (caster, self, "modifier_infinity_black_hole_thinker", {}, point, team_id, false)
    AddFOWViewer (caster:GetTeam (), point, 450, 4, false)
    GridNav:DestroyTreesAroundPoint(point, 500, false)
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
end

modifier_infinity_black_hole_thinker = class ( {})

function modifier_infinity_black_hole_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        self.startup_time = ability:GetSpecialValueFor("move_tick_rate")
        self.target = self:GetCaster():GetCursorPosition()
        self.duration = ability:GetSpecialValueFor("duration")
        self.speed = ability:GetSpecialValueFor("pull_speed")
        self.radius = ability:GetSpecialValueFor("far_radius")
        self.vision_radius = ability:GetSpecialValueFor("vision_radius")
        local thinker_pos = thinker:GetAbsOrigin()

        self:StartIntervalThink (self.startup_time)

        self.soundName = "chw.black_hole_loop_01"

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "enigma_singularity") == true then
          local bhParticle1 = ParticleManager:CreateParticle ("particles/enigma/enigma_fundamental_of_gravity/enigma_black_hole_extr_hole.vpcf", PATTACH_WORLDORIGIN, thinker)
          ParticleManager:SetParticleControl(bhParticle1, 0, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 1, Vector (self.radius, self.radius, 0))
          ParticleManager:SetParticleControl(bhParticle1, 2, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 3, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 6, Vector (self.radius, self.radius, 0))
          ParticleManager:SetParticleControl(bhParticle1, 5, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 6, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 7, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 8, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 9, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 20, thinker_pos + Vector (0, 0, 65))
          self:AddParticle( bhParticle1, false, false, -1, false, true )

          self.soundName = "Enigma.Singularity_black_hole"
        else
          local bhParticle1 = ParticleManager:CreateParticle ("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf", PATTACH_WORLDORIGIN, thinker)
          ParticleManager:SetParticleControl(bhParticle1, 0, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 1, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 2, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 3, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 6, Vector (self.radius, self.radius, 0))
          ParticleManager:SetParticleControl(bhParticle1, 7, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 8, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 9, thinker_pos + Vector (0, 0, 65))
          ParticleManager:SetParticleControl(bhParticle1, 20, Vector (self.radius, self.radius, 0))
          self:AddParticle( bhParticle1, false, false, -1, false, true )
        end
        ScreenShake(thinker:GetOrigin (), 100, 100, 6, 9999, 0, true)

        StartSoundEvent(self.soundName, self:GetAbility():GetCaster())
        EmitSoundOn("Hero_Enigma.BlackHole.Cast.Chasm", thinker)
        thinker:EmitSound ("enigma_enig_ability_black_01")
    end
end

function modifier_infinity_black_hole_thinker:OnIntervalThink()
    local caster = self:GetAbility():GetCaster()
    local target_location = self.target
    local ability = self:GetAbility()

    local speed = ability:GetSpecialValueFor("pull_speed")/10
    local radius = ability:GetSpecialValueFor("far_radius")
    local target_teams = ability:GetAbilityTargetTeam()
    local target_types = ability:GetAbilityTargetType()
    local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE

    local units = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)

    -- Calculate the position of each found unit in relation to the center
    for _,unit in ipairs(units) do
        local kv =
        {
            duration = ability:GetSpecialValueFor("duration"),
            dir_x = self:GetParent():GetAbsOrigin().x,
            dir_y = self:GetParent():GetAbsOrigin().y,
            dir_z = self:GetParent():GetAbsOrigin().z,
        }

        unit:AddNewModifier(caster, ability, "modifier_infinity_black_hole", kv)
        --[[local unit_location = unit:GetAbsOrigin()
        local vector_distance = target_location - unit_location
        local distance = (vector_distance):Length2D()
        local direction = (vector_distance):Normalized()

        local vPos = unit:GetAbsOrigin();

        local radius = (vPos - self:GetParent():GetAbsOrigin()):Length2D()
        print(i)

        local vNewPos = Vector( self:GetParent():GetAbsOrigin().x - radius * math.cos(i), self:GetParent():GetAbsOrigin().y - radius * math.sin(i), vPos.z);
        unit:SetAbsOrigin(vNewPos);

        ---unit:SetAbsOrigin(unit:GetAbsOrigin() + direction * 5);


        local primary_damage = ability:GetSpecialValueFor("damage")
        local damage_percent = ability:GetSpecialValueFor("damage_perc")/100
        local damage = ((unit:GetMaxHealth()*damage_percent) + primary_damage)/10
        if caster:HasScepter() and caster:HasAbility("enigma_midnight_pulse_new") then
            damage = ((unit:GetMaxHealth()*damage_percent) + primary_damage + (unit:GetMaxHealth()*midnightpulse_damage))/10
        end

        ApplyDamage({victim = unit, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS})]]
    end
    if not self:GetAbility():IsChanneling() then
        StopSoundEvent(self.soundName, caster)
        EmitSoundOn("Hero_Enigma.Black_Hole.Stop", self:GetAbility():GetCaster())
        StopSoundOn("Hero_Enigma.BlackHole.Cast.Chasm", self:GetParent())
        for _,unit in ipairs(units) do
            FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
        end
        self:Destroy()
    end
end

function modifier_infinity_black_hole_thinker:CheckState()
    if self.duration then
        return {[MODIFIER_STATE_PROVIDES_VISION] = true}
    end
    return nil
end


if modifier_infinity_black_hole == nil then modifier_infinity_black_hole = class({}) end

function modifier_infinity_black_hole:IsHidden()
    return false
end

function modifier_infinity_black_hole:IsPurgable()
    return false
end

function modifier_infinity_black_hole:IsDebuff()
    return true
end

function modifier_infinity_black_hole:IsStunDebuff()
    return true
end

function modifier_infinity_black_hole:GetStatusEffectName()
    return "particles/econ/items/enigma/enigma_world_chasm/status_effect_enigma_blackhole_tgt_ti5.vpcf"
end

function modifier_infinity_black_hole:StatusEffectPriority()
    return 1000
end

function modifier_infinity_black_hole:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_infinity_black_hole:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_infinity_black_hole:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

function modifier_infinity_black_hole:GetOverrideAnimation(params)
    return ACT_DOTA_FLAIL
end

function modifier_infinity_black_hole:CheckState ()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }

    return state
end

function modifier_infinity_black_hole:OnCreated( kv )

    self.vPos = Vector( kv["dir_x"], kv["dir_y"], kv["dir_z"] )
    self.radius = (self.vPos - self:GetParent():GetAbsOrigin()):Length2D()


    self:StartIntervalThink(0.01)

    local unit_origin = self:GetParent():GetAbsOrigin()

    local origin = self.vPos - unit_origin

    if (math.asin( origin.y / self.radius) > math.pi ) then
        self.i = math.asin(origin.y / self.radius)
    else
        self.i = math.acos(origin.x / self.radius)
    end
end

function modifier_infinity_black_hole:OnIntervalThink()
	if IsServer() then
        local unit_location = self:GetParent():GetAbsOrigin()
        local vector_distance = self.vPos - unit_location
        local distance = (vector_distance):Length2D()
        local direction = (vector_distance):Normalized()


        local vNewPos = Vector( self.vPos.x - self.radius * math.cos(self.i), self.vPos.y - self.radius * math.sin(self.i), self:GetParent():GetAbsOrigin().z);

        self:GetParent():SetAbsOrigin(vNewPos);

        self.i = self.i + (math.pi/100) / 10
       --- print(self.i)
        self.radius = self.radius - 0.2

        local damage = ((self:GetAbility():GetSpecialValueFor("damage_perc")/100)*self:GetParent():GetMaxHealth()) + self:GetAbility():GetSpecialValueFor("damage")

        if self:GetCaster():HasScepter() then
            local ability = self:GetCaster():FindAbilityByName("enigma_midnight_pulse_new")
            if ability then
                local bonus = (ability:GetLevelSpecialValueFor("damage_per_tick", ability:GetLevel() - 1)/100)*self:GetParent():GetMaxHealth()
                damage = damage + bonus
            end
        end
        local damage_table = {}

        damage_table.attacker = self:GetCaster()
        damage_table.victim = self:GetParent()
        damage_table.ability = self:GetAbility()
        damage_table.damage_type = DAMAGE_TYPE_PURE
        damage_table.damage = damage/100
        damage_table.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS

        if not self:GetParent():GetUnitName() ~= "npc_mega_greevil" and self:GetParent():GetUnitName() ~= "npc_dota_warlock_golem_1" then
            ApplyDamage(damage_table)
        end

		if not self:GetAbility():IsChanneling() then
            FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
            self:Destroy()
        end
	end
end

function modifier_infinity_black_hole:OnDestroy()
    if IsServer() then
        FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
    end
end
