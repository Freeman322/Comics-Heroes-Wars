LinkLuaModifier ("modifier_dormammu_continuum_field_thinker", "abilities/dormammu_continuum_field.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_dormammu_continuum_field", "abilities/dormammu_continuum_field.lua", LUA_MODIFIER_MOTION_NONE)
dormammu_continuum_field = class ({})

function dormammu_continuum_field:GetCastRange (vLocation, hTarget)
    return self.BaseClass.GetCastRange (self, vLocation, hTarget)
end

function dormammu_continuum_field:GetAOERadius ()
    return self:GetSpecialValueFor("radius")
end

function dormammu_continuum_field:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end

function dormammu_continuum_field:GetManaCost (hTarget)
    return self.BaseClass.GetManaCost (self, hTarget)
end

function dormammu_continuum_field:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_AOE +  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end

function dormammu_continuum_field:GetChannelTime()
    return self:GetSpecialValueFor("channel")
end

function dormammu_continuum_field:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = self:GetCursorPosition ()
    local team_id = caster:GetTeamNumber ()
    local thinker = CreateModifierThinker (caster, self, "modifier_dormammu_continuum_field_thinker", {duration = self:GetSpecialValueFor("channel")}, point, team_id, false)
    AddFOWViewer (caster:GetTeam (), point, 450, 4, false)
    GridNav:DestroyTreesAroundPoint(point, 500, false)
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
end

modifier_dormammu_continuum_field_thinker = class ( {})

function modifier_dormammu_continuum_field_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        self.radius = ability:GetSpecialValueFor("radius")
        local thinker_pos = thinker:GetAbsOrigin()

        EmitSoundOn("Hero_ArcWarden.MagneticField", thinker)

        local bhParticle1 = ParticleManager:CreateParticle ("particles/units/heroes/hero_arc_warden/arc_warden_magnetic_warp.vpcf", PATTACH_WORLDORIGIN, thinker)
        ParticleManager:SetParticleControl(bhParticle1, 0, thinker_pos)
        ParticleManager:SetParticleControl(bhParticle1, 1, Vector (self.radius, self.radius, 0))
        self:AddParticle( bhParticle1, false, false, -1, false, true )

        ScreenShake(thinker:GetOrigin (), 100, 100, 2, 9999, 0, true)

        self:StartIntervalThink(0.1)
    end
end

function modifier_dormammu_continuum_field_thinker:OnIntervalThink()
    if not self:GetAbility():IsChanneling() then
        self:GetCaster():Stop()
        self:Destroy()
    end
end

function modifier_dormammu_continuum_field_thinker:CheckState()
    if self.duration then
        return {[MODIFIER_STATE_PROVIDES_VISION] = true}
    end
    return nil
end

function modifier_dormammu_continuum_field_thinker:IsAura ()
    return true
end

function modifier_dormammu_continuum_field_thinker:GetAuraRadius ()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_dormammu_continuum_field_thinker:GetAuraSearchTeam ()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_dormammu_continuum_field_thinker:GetAuraSearchType ()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_dormammu_continuum_field_thinker:GetAuraSearchFlags ()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_dormammu_continuum_field_thinker:GetModifierAura ()
    return "modifier_dormammu_continuum_field"
end


if modifier_dormammu_continuum_field == nil then modifier_dormammu_continuum_field = class({}) end

function modifier_dormammu_continuum_field:IsHidden()
    return false
end

function modifier_dormammu_continuum_field:IsPurgable()
    return false
end

function modifier_dormammu_continuum_field:IsDebuff()
    return true
end

function modifier_dormammu_continuum_field:IsStunDebuff()
    return true
end

function modifier_dormammu_continuum_field:GetStatusEffectName()
    return "particles/econ/items/enigma/enigma_world_chasm/status_effect_enigma_blackhole_tgt_ti5.vpcf"
end

function modifier_dormammu_continuum_field:StatusEffectPriority()
    return 1000
end

function modifier_dormammu_continuum_field:GetEffectName()
    return "particles/generic_gameplay/dropped_gem.vpcf"
end

function modifier_dormammu_continuum_field:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_dormammu_continuum_field:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_dormammu_continuum_field:GetModifierMoveSpeed_Max()
	return 100
end

function modifier_dormammu_continuum_field:GetModifierMoveSpeed_Absolute()
	return 100
end

function modifier_dormammu_continuum_field:GetModifierAttackSpeedBonus_Constant()
	return -10000
end

function modifier_dormammu_continuum_field:CheckState ()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
    }
    return state
end

function modifier_dormammu_continuum_field:OnCreated( kv )
    if IsServer() then
      self:StartIntervalThink(1)
    end
end

function modifier_dormammu_continuum_field:OnIntervalThink()
	if IsServer() then
      local damage_table = {}
      damage_table.attacker = self:GetCaster()
      damage_table.victim = self:GetParent()
      damage_table.ability = self:GetAbility()
      damage_table.damage_type = DAMAGE_TYPE_MAGICAL
      damage_table.damage = self:GetParent():GetMaxHealth()*(self:GetAbility():GetSpecialValueFor("damage")/100)
      damage_table.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS
      ApplyDamage(damage_table)
	end
end

function dormammu_continuum_field:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

