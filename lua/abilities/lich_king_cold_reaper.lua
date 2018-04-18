if lich_king_cold_reaper == nil then lich_king_cold_reaper = class({}) end

function lich_king_cold_reaper:IsRefreshable()
    return false
end

function lich_king_cold_reaper:IsStealable()
    return false
end

function lich_king_cold_reaper:OnSpellStart()
    local caster = self:GetCaster()
    local spawn_location = caster:GetAbsOrigin()
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControl(nFXIndex, 0, Vector(0, 0, 0))
    ParticleManager:SetParticleControl(nFXIndex, 1, Vector(250, 250, 250))
    EmitSoundOn( "Hero_Ancient_Apparition.IceBlast.Target", self:GetCaster() )
    EmitSoundOn( "HHero_Crystal.CrystalNova", self:GetCaster() )
    EmitSoundOn( "hero_Crystal.CrystalNovaCast", self:GetCaster() )

    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_arthas/snow_rise_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControl(nFXIndex, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self:GetSpecialValueFor("range"), 5, 0))
    ParticleManager:SetParticleControl(nFXIndex, 2, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(nFXIndex, 3, Vector(1, 0, 0))
    local damage = self:GetSpecialValueFor("damage")
    local souls = self:GetCaster():FindModifierByName("modifier_lich_aura_passive")
    if souls == nil then
        souls_damage = self:GetSpecialValueFor("bonus_per_soul")
    else
        local stack = souls:GetStackCount()
        souls_damage = stack*self:GetSpecialValueFor("bonus_per_soul")
        self.talent_souls = 15
        if self:GetCaster():HasTalent("special_bonus_unique_lich_king") then
            souls_damage = stack * (self:GetSpecialValueFor("bonus_per_soul") + 15)
        end
    end

    self.damage = damage + souls_damage
    self.range = self:GetSpecialValueFor("range")
    if self:GetCaster():FindAbilityByName("lich_king_cold_reaper") ~= nil then
       self.range = self.range + (self:GetLevel()*50)
    end
    if self:GetCaster():HasScepter() then
        self.range = self.range + 100
    end
    local targets = FindUnitsInRadius(caster:GetTeamNumber(), spawn_location, nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for i = 1, #targets do
        local target = targets[i]
        if not target:IsAncient() or not target:IsConsideredHero() then
          local origin = target:GetAbsOrigin()
          target:AddNewModifier(caster, self, "modifier_ancientapparition_coldfeet_freeze", {duration = self:GetSpecialValueFor("duration")})
   		    ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self.damage, damage_type = self:GetAbilityDamageType(), ability = self})
          if target:IsRealHero() then
              if target:GetHealth() == 0 then
                  local golem = CreateUnitByName( "npc_lich_zombie_golem", origin, true, caster, caster:GetOwner(), caster:GetTeamNumber())
              	golem:SetControllableByPlayer(caster:GetPlayerID(), false)
                  golem:AddNewModifier(caster, self, "modifier_kill", {duration = 30})
              end
          else
              target:Kill(self, caster)
              local golem = CreateUnitByName( "npc_lich_zombie", origin, true, caster, caster:GetOwner(), caster:GetTeamNumber())
              golem:SetControllableByPlayer(caster:GetPlayerID(), false)
              golem:AddNewModifier(caster, self, "modifier_kill", {duration = 30})
          end
       end
    end
    local count = 0
    for _, unit in pairs(targets) do
      if unit:IsRealHero() then
        count = count + 1
      end
    end
    local pID = self:GetCaster():GetPlayerOwnerID()
    if GameRules.Globals.Quests[pID] and GameRules.Globals.Quests[pID].quest == 3 then
      if count == 5 then
        GameRules.Globals.Quests[pID].state = 1
        CustomNetTables:SetTableValue( "globals", "quest_selected", GameRules.Globals.Quests )
      end
    end
end

function lich_king_cold_reaper:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

