LinkLuaModifier ("scarlet_witch_sphere_thinker", "abilities/scarlet_witch_sphere.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("scarlet_witch_sphere_modifier", "abilities/scarlet_witch_sphere.lua", LUA_MODIFIER_MOTION_NONE)

scarlet_witch_sphere = class ( {})

function scarlet_witch_sphere:OnSpellStart ()
    local point = self:GetCursorPosition ()
    local caster = self:GetCaster ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor ("duration")
    local thinker = CreateModifierThinker (caster, self, "scarlet_witch_sphere_thinker", {duration = duration }, point, team_id, false)
end

function scarlet_witch_sphere:GetAOERadius ()
    return 450
end

scarlet_witch_sphere_thinker = class ( {})

function scarlet_witch_sphere_thinker:OnCreated (event)
    if IsServer() then
        local thinker = self:GetParent ()
        local ability = self:GetAbility ()
        local thinker_pos = thinker:GetAbsOrigin()
        self.team_number = thinker:GetTeamNumber ()
        self.radius = ability:GetSpecialValueFor ("radius")
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "scarlet_armor") then
            local particle = ParticleManager:CreateParticle ("particles/units/heroes/hero_arc_warden/arc_warden_magnetic.vpcf", PATTACH_WORLDORIGIN, thinker)
            ParticleManager:SetParticleControl(particle, 0, thinker_pos)
            ParticleManager:SetParticleControl(particle, 1, Vector (self.radius, self.radius, 0))
            self:AddParticle( particle, false, false, -1, false, true )
        else
            local particle = ParticleManager:CreateParticle ("particles/scarlet_witch_sphere.vpcf", PATTACH_WORLDORIGIN, thinker)
            ParticleManager:SetParticleControl(particle, 0, thinker_pos)
            ParticleManager:SetParticleControl(particle, 1, Vector (self.radius, self.radius, 0))
            ParticleManager:SetParticleControl(particle, 3, thinker_pos)
            self:AddParticle( particle, false, false, -1, false, true )
        end
        EmitSoundOn("Hero_ArcWarden.MagneticField", self:GetCaster())
    end
end

function scarlet_witch_sphere_thinker:IsAura ()
    return true
end

function scarlet_witch_sphere_thinker:GetAuraRadius ()
    return self.radius
end

function scarlet_witch_sphere_thinker:GetAuraSearchTeam ()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function scarlet_witch_sphere_thinker:GetAuraSearchType ()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function scarlet_witch_sphere_thinker:GetAuraSearchFlags ()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function scarlet_witch_sphere_thinker:GetModifierAura ()
    return "scarlet_witch_sphere_modifier"
end


scarlet_witch_sphere_modifier = class ( {})

function scarlet_witch_sphere_modifier:IsBuff ()
    return true
end

function scarlet_witch_sphere_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true
    }

    return state
end

function scarlet_witch_sphere_modifier:DeclareFunctions ()
    return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end


function scarlet_witch_sphere_modifier:GetModifierAttackSpeedBonus_Constant (params)
    return -1000
end

function scarlet_witch_sphere:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/wanda_arcana_scream"
	end
	return self.BaseClass.GetAbilityTextureName(self)
end