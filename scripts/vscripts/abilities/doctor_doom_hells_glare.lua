LinkLuaModifier ("modifier_doctor_doom_hells_glare_thinker", "abilities/doctor_doom_hells_glare.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_doctor_doom_hells_glare",         "abilities/doctor_doom_hells_glare.lua", LUA_MODIFIER_MOTION_NONE)
doctor_doom_hells_glare = class({})


function doctor_doom_hells_glare:GetAOERadius ()
    return 450
end

function doctor_doom_hells_glare:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end

function doctor_doom_hells_glare:GetManaCost (hTarget)
    return self.BaseClass.GetManaCost (self, hTarget)
end

function doctor_doom_hells_glare:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
end

function doctor_doom_hells_glare:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = self:GetCursorPosition ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor("duration")
    local thinker = CreateModifierThinker (caster, self, "modifier_doctor_doom_hells_glare_thinker", {duration = duration }, point, team_id, false)
    AddFOWViewer (caster:GetTeam (), point, 450, duration, false)
    GridNav:DestroyTreesAroundPoint (point, 500, false)
end

modifier_doctor_doom_hells_glare = class({})

function modifier_doctor_doom_hells_glare:IsBuff ()
    if self:GetParent():GetTeamNumber(  ) ~= self:GetAbility():GetCaster():GetTeamNumber(  ) then
        return false
     end
    return true
end

function modifier_doctor_doom_hells_glare:OnCreated (event)
    local ability = self:GetAbility()
    if IsServer() then
        if self:GetCaster():HasModifier("modifier_doom") then
            local mod = self:GetCaster():FindModifierByName("modifier_doom")
            self.damage = mod:GetStackCount()*5
        else
            self.damage = 0
        end
    end
    self.damage = self.damage or 0
    self.health_regen = ability:GetSpecialValueFor ("health_regen") + self.damage
    self:StartIntervalThink( 1 )
    self:OnIntervalThink()
end

function modifier_doctor_doom_hells_glare:DeclareFunctions ()
    return { MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT }
end

function modifier_doctor_doom_hells_glare:GetModifierConstantHealthRegen()
     if self:GetParent():GetTeamNumber(  ) == self:GetAbility():GetCaster():GetTeamNumber(  ) then
        return self.health_regen
     end
     return 0
end

function modifier_doctor_doom_hells_glare:OnIntervalThink(  )
    if IsServer() then
        if self:GetParent():GetTeamNumber(  ) ~= self:GetAbility():GetCaster():GetTeamNumber(  ) then
            ApplyDamage( {attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage") + self.damage, damage_type = DAMAGE_TYPE_PURE} )
            -- Damage an npc.
        end
    end
end

modifier_doctor_doom_hells_glare_thinker = class({})

function modifier_doctor_doom_hells_glare_thinker:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor ("radius")
    if IsServer() then
        if self:GetCaster():HasTalent("special_bonus_unique_doom") then
            self.radius = self:GetCaster():FindTalentValue("special_bonus_unique_doom") + self:GetAbility():GetSpecialValueFor ("radius")
        end
        local nFXIndex = ParticleManager:CreateParticle( "particles/doctor_doom/doctor_doom_hells_field.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        EmitSoundOn("Hero_Silencer.Curse.Cast", thinker)
    end
end

function modifier_doctor_doom_hells_glare_thinker:IsAura ()
    return true
end

function modifier_doctor_doom_hells_glare_thinker:GetAuraRadius ()
    return self.radius
end

function modifier_doctor_doom_hells_glare_thinker:GetAuraSearchTeam ()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_doctor_doom_hells_glare_thinker:GetAuraSearchType ()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_doctor_doom_hells_glare_thinker:GetAuraSearchFlags ()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_doctor_doom_hells_glare_thinker:GetModifierAura ()
    return "modifier_doctor_doom_hells_glare"
end

function doctor_doom_hells_glare:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

