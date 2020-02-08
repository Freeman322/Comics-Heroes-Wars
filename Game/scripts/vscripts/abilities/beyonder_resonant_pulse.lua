if beyonder_resonant_pulse == nil then  beyonder_resonant_pulse = class({}) end

LinkLuaModifier( "modifier_beyonder_resonant_pulse", "abilities/beyonder_resonant_pulse.lua" ,LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function beyonder_resonant_pulse:GetIntrinsicModifierName()
	return "modifier_beyonder_resonant_pulse"
end

function beyonder_resonant_pulse:GetCastRange( vLocation, hTarget ) return self.BaseClass.GetCastRange( self, vLocation, hTarget ) end
function beyonder_resonant_pulse:GetCooldown (nLevel) return self.BaseClass.GetCooldown (self, nLevel) end
function beyonder_resonant_pulse:GetAbilityTextureName()  return self.BaseClass.GetAbilityTextureName(self)  end

function beyonder_resonant_pulse:Pulse(target)
     if IsServer() then
          local pos = target:GetAbsOrigin()
          local caster = self:GetCaster()

          local origin = caster:GetAbsOrigin()
          local vDirection = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
 
          local duration = self:GetSpecialValueFor("pop_damage_delay")
          local base_damage = self:GetSpecialValueFor("damage")
   
          local sound_start = "Hero_VoidSpirit.AstralStep.Start"
          local sound_end = "Hero_VoidSpirit.AstralStep.End"
     
          -- Create Particle
          local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf", PATTACH_WORLDORIGIN, caster )
          ParticleManager:SetParticleControl( effect_cast, 0, origin )
          ParticleManager:SetParticleControl( effect_cast, 1, pos )
          ParticleManager:ReleaseParticleIndex( effect_cast )
     
          -- Create Sound
          EmitSoundOnLocationWithCaster( origin, sound_start, caster )
          EmitSoundOnLocationWithCaster( pos, sound_end,caster )

          local unit_table = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), pos, nil, self:GetSpecialValueFor("width"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
          if #unit_table > 0 then
               for k, unit in pairs(unit_table) do 
                    EmitSoundOn( "Hero_VoidSpirit.AetherRemnant.Target" , unit )

                    unit:AddNewModifier( caster, self, "modifier_void_spirit_astral_step_debuff", { duration = duration } )
                    unit:AddNewModifier( caster, self, "modifier_stunned", {duration = duration})
                    
                    ApplyDamage({attacker = caster, victim = unit, ability = self, damage = base_damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})

                    caster:PerformAttack(unit, true, true, true, false, false, false, true)
               end
          end

          caster:SetAbsOrigin(pos)
          FindClearSpaceForUnit(caster, pos, true)
     end
end


function beyonder_resonant_pulse:OnSpellStart()
     self:Pulse(self:GetCursorTarget())
end

modifier_beyonder_resonant_pulse = class({
     IsHidden = function() return true end,
     IsPurgable = function() return false end,
     DeclareFunctions = function() return {MODIFIER_EVENT_ON_ORDER} end
 })
 
function modifier_beyonder_resonant_pulse:OnOrder(params)
     if params.unit == self:GetParent() and self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() then
          local target = params.target
          if (params.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or params.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or params.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET) then
               if self:GetCaster():GetRangeToUnit(target) <= self:GetAbility():GetSpecialValueFor("lenght") then
                    self:GetAbility():Pulse(target)
                    self:GetAbility():UseResources(true, false, true)
               end
          end
     end
 end
 