LinkLuaModifier("modifier_genos_glue_trap_thinker", "abilities/genos/genos_glue_trap.lua", LUA_MODIFIER_MOTION_NONE)

genos_glue_trap = class ({})

function genos_glue_trap:OnSpellStart()
    local point = self:GetCursorPosition()
    local team_id = self:GetCaster():GetTeamNumber()
    local thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_genos_glue_trap_thinker", {duration = self:GetSpecialValueFor("thinker_duration")}, point, team_id, false)
end

function genos_glue_trap:GetAOERadius ()
    return self:GetSpecialValueFor("thinker_radius")
end

modifier_genos_glue_trap_thinker = class ({})

function modifier_genos_glue_trap_thinker:OnCreated(event)
  if IsServer() then
      local target = self:GetAbility():GetCaster():GetCursorPosition()
      local radius = self:GetAbility():GetSpecialValueFor("thinker_radius")

      local nFXIndex = ParticleManager:CreateParticle( "particles/genos/genos_glue_trap.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
      ParticleManager:SetParticleControl( nFXIndex, 0, target)
      ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, 0))
      ParticleManager:SetParticleControl( nFXIndex, 15, Vector(255, 255, 255))
      ParticleManager:SetParticleControl( nFXIndex, 16, Vector(255, 255, 255))
      self:AddParticle( nFXIndex, false, false, -1, false, true )

      EmitSoundOn("Hero_Alchemist.AcidSpray", self:GetParent())

      self:StartIntervalThink(0.1)
  end
end

function modifier_genos_glue_trap_thinker:OnIntervalThink()
    local enemies = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("thinker_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _, target in pairs(enemies) do
        target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_rooted", {duration = self:GetRemainingTime()})
    end
end

function modifier_genos_glue_trap_thinker:OnDestroy()
  StopSoundOn("Hero_Alchemist.AcidSpray", self:GetParent())
end
