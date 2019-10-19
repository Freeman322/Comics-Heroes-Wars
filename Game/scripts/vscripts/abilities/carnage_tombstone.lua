LinkLuaModifier( "modifier_carnage_tombstone_thinker", "abilities/carnage_tombstone.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_carnage_tombstone_modifier", "abilities/carnage_tombstone.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

carnage_tombstone = class ( {})

function carnage_tombstone:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local team_id = caster:GetTeamNumber()
    local thinker = CreateModifierThinker(caster, self, "modifier_carnage_tombstone_thinker", {duration = self:GetSpecialValueFor("duration")}, point, team_id, false)
end

modifier_carnage_tombstone_thinker = class ({})

function modifier_carnage_tombstone_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local target = self:GetAbility():GetCaster():GetCursorPosition()
        local radius = self:GetAbility():GetSpecialValueFor("radius")
   
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, target)
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn("Hero_Juggernaut.HealingWard.Cast", thinker)
        
       	StartSoundEvent("Hero_Juggernaut.HealingWard.Loop", thinker)
    end
end

function modifier_carnage_tombstone_thinker:OnDestroy()
	if IsServer() then
		StopSoundEvent("Hero_Juggernaut.HealingWard.Loop", thinker)
	 end	
end

function modifier_carnage_tombstone_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_carnage_tombstone_thinker:IsAura()
    return true
end

function modifier_carnage_tombstone_thinker:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_carnage") or 0)
end

function modifier_carnage_tombstone_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_carnage_tombstone_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_carnage_tombstone_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_carnage_tombstone_thinker:GetModifierAura()
    return "modifier_carnage_tombstone_modifier"
end

if modifier_carnage_tombstone_modifier == nil then modifier_carnage_tombstone_modifier = class({}) end

function modifier_carnage_tombstone_modifier:IsPurgable()
    return false
end

function modifier_carnage_tombstone_modifier:IsHidden()
    return true
end

function modifier_carnage_tombstone_modifier:GetStatusEffectName()
    return "particles/status_fx/status_effect_slardar_amp_damage.vpcf"
end

--------------------------------------------------------------------------------

function modifier_carnage_tombstone_modifier:StatusEffectPriority()
    return 1000
end

--------------------------------------------------------------------------------

function modifier_carnage_tombstone_modifier:GetEffectName()
    return "particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_spiderlings_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_carnage_tombstone_modifier:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_carnage_tombstone_modifier:OnCreated( kv )
    if IsServer() then
        ----self:GetParent():Purge(true, false, false, false, false)
    end
end

--------------------------------------------------------------------------------

function modifier_carnage_tombstone_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_carnage_tombstone_modifier:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("health_regen") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_carnage_2") or 0)
end

function modifier_carnage_tombstone_modifier:GetModifierConstantManaRegen()
    return self:GetAbility():GetSpecialValueFor("mana_regen") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_carnage_2") or 0)
end