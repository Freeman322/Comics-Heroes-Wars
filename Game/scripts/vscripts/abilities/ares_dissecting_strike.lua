if not ares_dissecting_strike then ares_dissecting_strike = class({}) end
LinkLuaModifier( "modifier_ares_dissecting_strike", "abilities/ares_dissecting_strike.lua", LUA_MODIFIER_MOTION_NONE )

function ares_dissecting_strike:GetIntrinsicModifierName()
  return "modifier_ares_dissecting_strike"
end

function ares_dissecting_strike:OnSpellStart ()
  if IsServer() then
    local target = self:GetCursorTarget()
    self:ToggleAutoCast()
    self:GetCaster():PerformAttack(target, true, true, false, false, false, false, false)
  end
end

modifier_ares_dissecting_strike = class({})

function modifier_ares_dissecting_strike:IsHidden()
  return true
end

function modifier_ares_dissecting_strike:OnCreated()
  if IsServer() then
    if Util:PlayerEquipedItem(self:GetParent():GetPlayerOwnerID(), "ares_son_of_zeus") == true then
      self.bLightning = true
    end
  end
end

function modifier_ares_dissecting_strike:IsPurgable()
  return false
end

function modifier_ares_dissecting_strike:RemoveOnDeath()
  return false
end

function modifier_ares_dissecting_strike:DeclareFunctions ()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED
  }

  return funcs
end

function modifier_ares_dissecting_strike:OnAttackLanded (params)
  if IsServer() then
      if params.attacker == self:GetParent() then
          local target = params.target
          if self:GetAbility():GetAutoCastState() and self:GetAbility():IsCooldownReady() then
              self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
              if self.bLightning then
                  local nFXIndex = ParticleManager:CreateParticle( "particles/hero_ares/ares_immortal_lightning_weapon_proc.vpcf", PATTACH_CUSTOMORIGIN, target );
                  ParticleManager:SetParticleControl( nFXIndex, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, 1500) );
                  ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                  ParticleManager:SetParticleControlEnt( nFXIndex, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                  ParticleManager:SetParticleControlEnt( nFXIndex, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                  ParticleManager:SetParticleControlEnt( nFXIndex, 6, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                  ParticleManager:ReleaseParticleIndex( nFXIndex );
                  EmitSoundOn( "Hero_Zuus.LightningBolt.Cast.Righteous", self:GetParent() )
                  EmitSoundOn( "Hero_Zuus.LightningBolt.Righteous", target )
                  EmitSoundOn( "Hero_Zuus.Righteous.Layer", target )
                  EmitSoundOn( "Hero_Zuus.GodsWrath.PreCast.Arcana", target )
              else
                  local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_CUSTOMORIGIN, nil );
                  ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                  ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
                  ParticleManager:ReleaseParticleIndex( nFXIndex );
                  EmitSoundOn( "Hero_DoomBringer.InfernalBlade.PreAttack", self:GetParent() )
                  EmitSoundOn( "Hero_DoomBringer.InfernalBlade.Target", target )
              end
              
              self:GetParent():Heal(params.damage * (self:GetAbility():GetSpecialValueFor("crit_lifesteal")/100), self:GetAbility())
              local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
              local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
              ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent():GetAbsOrigin())

              if target:IsRealHero() or target:IsAncient() then
                  target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
              else
                  target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("creep_stun_duration")})
              end
              ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self:GetAbility(), damage = self:GetAbility():GetAbilityDamage(), damage_type = DAMAGE_TYPE_PURE})
          end
      end
  end
end


function ares_dissecting_strike:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
