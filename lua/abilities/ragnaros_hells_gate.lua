ragnaros_hells_gate = class({})
LinkLuaModifier( "ragnaros_hells_gate_thinker",   "abilities/ragnaros_hells_gate.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "ragnaros_hells_gate_modifier",  "abilities/ragnaros_hells_gate.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

function ragnaros_hells_gate:GetAOERadius()
    return self:GetSpecialValueFor( "radius" )
    -- Gets a value from this ability's special value block for its current level.
end

function ragnaros_hells_gate:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function ragnaros_hells_gate:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local team_id = caster:GetTeamNumber()
    local thinker = CreateModifierThinker(caster, self, "ragnaros_hells_gate_thinker", {duration = self:GetSpecialValueFor("duration")}, point, team_id, false)
end

ragnaros_hells_gate_thinker = class ({})

function ragnaros_hells_gate_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local target = self:GetAbility():GetCaster():GetCursorPosition()
        self.radius = ability:GetSpecialValueFor("radius")

        local nFXIndex = ParticleManager:CreateParticle( "particles/ragnaros/ragnaros_lava.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, target)
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        AddFOWViewer( thinker:GetTeam(), target, 500, self:GetAbility():GetSpecialValueFor("duration"), false)
        GridNav:DestroyTreesAroundPoint(target, 500, false)
    end
end

function ragnaros_hells_gate_thinker:CheckState()
    if self.duration then
        return {[MODIFIER_STATE_PROVIDES_VISION] = true}
    end
    return nil
end

function ragnaros_hells_gate_thinker:IsAura()
    return true
end

function ragnaros_hells_gate_thinker:GetAuraRadius()
    return self.radius
end

function ragnaros_hells_gate_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function ragnaros_hells_gate_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function ragnaros_hells_gate_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function ragnaros_hells_gate_thinker:GetModifierAura()
    return "ragnaros_hells_gate_modifier"
end

ragnaros_hells_gate_modifier = class ({})

function ragnaros_hells_gate_modifier:IsHidden(  )
    return false
end

function ragnaros_hells_gate_modifier:IsPurgable(  )
    return false
end

function ragnaros_hells_gate_modifier:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.1)
    end
end

function ragnaros_hells_gate_modifier:OnIntervalThink()
    if IsServer() then
        ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = (self:GetAbility():GetSpecialValueFor("damage")/10) , damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function ragnaros_hells_gate_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

--------------------------------------------------------------------------------

function ragnaros_hells_gate_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("slowing")
end
function ragnaros_hells_gate:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

