if jons_whirlpool == nil then jons_whirlpool = class({}) end

LinkLuaModifier( "jons_whirlpool_thinker", "abilities/jons_whirlpool.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "jons_whirlpool_modifier", "abilities/jons_whirlpool.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

function jons_whirlpool:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local team_id = caster:GetTeamNumber()
    local thinker = CreateModifierThinker(caster, self, "jons_whirlpool_thinker", {duration = self:GetSpecialValueFor("duration")}, point, team_id, false)
    self.vPos = thinker:GetAbsOrigin()
end

function jons_whirlpool:GetTinkerPos()
    return self.vPos
end

if jons_whirlpool_thinker == nil then jons_whirlpool_thinker = class ({}) end

function jons_whirlpool_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        self.radius = self:GetAbility():GetSpecialValueFor("radius")
        local bhParticle1 = ParticleManager:CreateParticle ("particles/hero_jones/jons_whirlpool.vpcf", PATTACH_WORLDORIGIN, thinker)
        ParticleManager:SetParticleControl(bhParticle1, 0, thinker:GetAbsOrigin() + Vector (0, 0, 65))
        ParticleManager:SetParticleControl(bhParticle1, 6, Vector (self.radius, self.radius, 0))
        self:AddParticle( bhParticle1, false, false, -1, false, true )

        self:StartIntervalThink(0.1)
        EmitSoundOn("Ability.Torrent", thinker)
    end
end


function jons_whirlpool_thinker:OnIntervalThink()
    local caster = self:GetAbility():GetCaster()
    local target_location = self:GetParent():GetAbsOrigin()
    local ability = self:GetAbility()

    local radius = ability:GetSpecialValueFor("radius")
    local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
    local target_flags = DOTA_UNIT_TARGET_NONE

    local units = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)

    -- Calculate the position of each found unit in relation to the center
    for _,unit in ipairs(units) do
        local kv =
            {
                duration = self:GetRemainingTime(),
                dir_x = self:GetParent():GetAbsOrigin().x,
                dir_y = self:GetParent():GetAbsOrigin().y,
                dir_z = self:GetParent():GetAbsOrigin().z,
            }

        unit:AddNewModifier(caster, ability, "jons_whirlpool_modifier", kv)
    end
end


function jons_whirlpool_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end


if jons_whirlpool_modifier == nil then jons_whirlpool_modifier = class({}) end

function jons_whirlpool_modifier:IsHidden()
    return false
end

function jons_whirlpool_modifier:IsPurgable()
    return false
end

function jons_whirlpool_modifier:IsDebuff()
    return true
end

function jons_whirlpool_modifier:IsStunDebuff()
    return true
end

function jons_whirlpool_modifier:GetStatusEffectName()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_l2_radiant.vpcf"
end

function jons_whirlpool_modifier:StatusEffectPriority()
    return 1000
end

function jons_whirlpool_modifier:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function jons_whirlpool_modifier:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function jons_whirlpool_modifier:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

function jons_whirlpool_modifier:GetOverrideAnimation(params)
    return ACT_DOTA_FLAIL
end

function jons_whirlpool_modifier:CheckState ()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
    }

    return state
end

function jons_whirlpool_modifier:OnCreated( kv )
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

function jons_whirlpool_modifier:OnIntervalThink()
    if IsServer() then
        local unit_location = self:GetParent():GetAbsOrigin()
        local vector_distance = self.vPos - unit_location
        local distance = (vector_distance):Length2D()
        local direction = (vector_distance):Normalized()

        local vNewPos = Vector( self.vPos.x - self.radius * math.cos(self.i), self.vPos.y - self.radius * math.sin(self.i), self:GetParent():GetAbsOrigin().z);

        self:GetParent():SetAbsOrigin(vNewPos);

        self.i = self.i + (math.pi/10) / 10
        self.radius = self.radius - 0.5

        local damage = self:GetAbility():GetAbilityDamage()

        local damage_table = {}

        damage_table.attacker = self:GetCaster()
        damage_table.victim = self:GetParent()
        damage_table.ability = self:GetAbility()
        damage_table.damage_type = DAMAGE_TYPE_MAGICAL
        damage_table.damage = damage/100
        ApplyDamage(damage_table)
    end
end

function jons_whirlpool_modifier:OnDestroy()
    if IsServer() then
        FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
    end
end

function jons_whirlpool:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

