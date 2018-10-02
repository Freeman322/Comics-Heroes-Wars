LinkLuaModifier( "overvoid_dark_hole_thinker", "abilities/overvoid_dark_hole.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "overvoid_dark_hole_modifier", "abilities/overvoid_dark_hole.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

overvoid_dark_hole = class ( {})

function overvoid_dark_hole:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local team_id = caster:GetTeamNumber()
    local thinker = CreateModifierThinker(caster, self, "overvoid_dark_hole_thinker", {duration = self:GetSpecialValueFor("duration")}, point, team_id, false)
end

overvoid_dark_hole_modifier = class ( {})

function overvoid_dark_hole_modifier:IsDebuff ()
    return true
end

function overvoid_dark_hole_modifier:IsHidden()
    return true
end

function overvoid_dark_hole_modifier:OnCreated (event)
    local ability = self:GetAbility ()
    if IsServer() then
    	EmitSoundOn("Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent())
    	EmitSoundOn("Hero_AbyssalUnderlord.Pit.Target", self:GetParent())
    	EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Complete", self:GetParent())

        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self:GetAbility():GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function overvoid_dark_hole_modifier:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function overvoid_dark_hole_modifier:GetEffectName()
    return "particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf"
end

function overvoid_dark_hole_modifier:GetEffectAttachType ()
    return PATTACH_ABSORIGIN
end

overvoid_dark_hole_thinker = class ({})

function overvoid_dark_hole_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()

        self.radius = ability:GetSpecialValueFor("radius")
        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_jaina/jaina_overvoid_aoe_ring.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, thinker:GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 1))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetAbility():GetSpecialValueFor("duration"), 0, 0))
        ParticleManager:SetParticleControl( nFXIndex, 6, Vector(255, 255, 255))
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn("Hero_AbyssalUnderlord.PitOfMalice.Start", thinker)
        EmitSoundOn("Hero_AbyssalUnderlord.PitOfMalice", thinker)

        AddFOWViewer( thinker:GetTeam(), thinker:GetAbsOrigin(), 500, 5, false)
        GridNav:DestroyTreesAroundPoint(thinker:GetAbsOrigin(), 500, false)
    end
end

function overvoid_dark_hole_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function overvoid_dark_hole_thinker:IsAura()
    return true
end

function overvoid_dark_hole_thinker:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function overvoid_dark_hole_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function overvoid_dark_hole_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function overvoid_dark_hole_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function overvoid_dark_hole_thinker:GetModifierAura()
    return "overvoid_dark_hole_modifier"
end

function overvoid_dark_hole:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

