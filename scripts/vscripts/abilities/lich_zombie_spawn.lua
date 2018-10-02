if lich_zombie_spawn == nil then
    lich_zombie_spawn = class({})
end

function lich_zombie_spawn:OnSpellStart ()
    local point = self:GetCaster():GetAbsOrigin()
    local caster = self:GetCaster()

    EmitSoundOn("Hero_Ancient_Apparition.IceBlast.Target", caster)

    for i = 1, 8 do
      local golem = CreateUnitByName( "npc_dota_creature_berserk_zombie", point, true, caster, caster, caster:GetTeamNumber())
      golem:AddNewModifier(caster, self, "modifier_kill", {duration = 300})
    end
    local pudge = CreateUnitByName( "npc_dota_creature_boss_pudge", point, true, caster, caster, caster:GetTeamNumber())
    pudge:AddNewModifier(caster, self, "modifier_kill", {duration = 300})
end

function lich_zombie_spawn:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

