LinkLuaModifier ("modifier_atomic_samurai_focused_atomic_slash", "abilities/atomic_samurai_focused_atomic_slash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_atomic_samurai_focused_atomic_slash_thinker", "abilities/atomic_samurai_focused_atomic_slash.lua", LUA_MODIFIER_MOTION_NONE)

atomic_samurai_focused_atomic_slash = class ({})


function atomic_samurai_focused_atomic_slash:GetAOERadius() return self:GetSpecialValueFor("radius") end
function atomic_samurai_focused_atomic_slash:GetCooldown (nLevel) return self.BaseClass.GetCooldown (self, nLevel) end
function atomic_samurai_focused_atomic_slash:GetManaCost (hTarget) return self.BaseClass.GetManaCost (self, hTarget) end
function atomic_samurai_focused_atomic_slash:GetBehavior() return DOTA_ABILITY_BEHAVIOR_AOE +  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES end

function atomic_samurai_focused_atomic_slash:OnSpellStart ()
    if IsServer() then
        local thinker = CreateModifierThinker (self:GetCaster(), self, "modifier_atomic_samurai_focused_atomic_slash_thinker", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)

        AddFOWViewer (self:GetCaster():GetTeam (), self:GetCursorPosition(), 450, 4, false)
        GridNav:DestroyTreesAroundPoint(self:GetCursorPosition(), 500, false)

        EmitSoundOn("Hero_EmberSpirit.SearingChains.Cast", thinker)
        EmitSoundOn("Hero_EmberSpirit.SearingChains.Burn", self:GetCaster())
    end
end

modifier_atomic_samurai_focused_atomic_slash_thinker = class ({})

function modifier_atomic_samurai_focused_atomic_slash_thinker:Next()
     if IsServer() then
          local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
          
          if #units == 0 or units == nil then
               self:Destroy()

               return nil
          end

          if #units > 0 then
               return units[1]
          end
     end

     return nil
end

function modifier_atomic_samurai_focused_atomic_slash_thinker:OnCreated(event)
     if IsServer() then
          self.radius = self:GetAbility():GetSpecialValueFor("radius")
          self.caster = self:GetAbility():GetCaster()
          self.damage = self:GetAbility():GetSpecialValueFor("bonus_hero_damage")
          self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_atomic_samurai_focused_atomic_slash", nil)
          self.pos = self:GetParent():GetAbsOrigin()
          self.old_pos = self:GetCaster():GetAbsOrigin()

          local nFXIndex = ParticleManager:CreateParticle ("particles/econ/items/monkey_king/arcana/fire/mk_arcana_fire_spring_cast_ringouterpnts.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
          ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin())
          ParticleManager:SetParticleControl( nFXIndex, 4, self:GetParent():GetAbsOrigin())
          ParticleManager:SetParticleControl( nFXIndex, 5, self:GetParent():GetAbsOrigin())
          ParticleManager:ReleaseParticleIndex(nFXIndex)

          self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("attack_interval"))
          self:OnIntervalThink()
    end
end

function modifier_atomic_samurai_focused_atomic_slash_thinker:OnDestroy()
     if IsServer() then
          if self.mod and not self.mod:IsNull() then
               self.mod:Destroy()

               self.caster:SetAbsOrigin(self.old_pos)
               FindClearSpaceForUnit(self.caster, self.old_pos, true)
          end
     end
end

function modifier_atomic_samurai_focused_atomic_slash_thinker:OnIntervalThink()
    if IsServer() then
          local target = self:Next()

          if target == nil or target:IsNull() then self:Destroy() return end

          local pos = target:GetAbsOrigin()
          local pos2 = self.caster:GetAbsOrigin()

          self:CreateTrail(pos2, pos)

          self.caster:SetAbsOrigin(target:GetAbsOrigin())
          FindClearSpaceForUnit(self.caster, target:GetAbsOrigin(), false)

          EmitSoundOn("Hero_Juggernaut.ArcanaTrigger", target)
          EmitSoundOn("Hero_Juggernaut.ArcanaTrigger.Loadout_1", self.caster)

          ApplyDamage({
               victim = target,
               attacker = self.caster,
               ability = self:GetAbility(),
               damage = self.damage,
               damage_type = self:GetAbility():GetAbilityDamageType()
          })

          self.caster:PerformAttack(target, false, true, true, false, false, false, true)
          self.caster:PerformAttack(target, false, true, true, false, false, false, true)
    end
end

function modifier_atomic_samurai_focused_atomic_slash_thinker:CreateTrail(pos1, pos2)
     if IsServer() then
          local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self:GetParent() );
          ParticleManager:SetParticleControl( nFXIndex, 0, pos1 + Vector(0, 0, 92) );
          ParticleManager:SetParticleControl( nFXIndex, 1, pos2 + Vector(0, 0, 92) );
          ParticleManager:ReleaseParticleIndex( nFXIndex );
     end
end

if modifier_atomic_samurai_focused_atomic_slash == nil then modifier_atomic_samurai_focused_atomic_slash = class({}) end

function modifier_atomic_samurai_focused_atomic_slash:IsHidden() return true end
function modifier_atomic_samurai_focused_atomic_slash:IsPurgable() return false end
function modifier_atomic_samurai_focused_atomic_slash:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_atomic_samurai_focused_atomic_slash:CheckState () return { [MODIFIER_STATE_COMMAND_RESTRICTED] = true, [MODIFIER_STATE_OUT_OF_GAME] = true } end

function modifier_atomic_samurai_focused_atomic_slash:OnCreated(params)
     if IsServer() then
          self:GetCaster():AddNoDraw()
     end
end
function modifier_atomic_samurai_focused_atomic_slash:OnDestroy()
     if IsServer() then
          self:GetCaster():RemoveNoDraw()
     end
end