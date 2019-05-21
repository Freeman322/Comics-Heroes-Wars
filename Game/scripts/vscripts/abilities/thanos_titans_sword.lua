---@class thanos_titans_sword
---@author Freeman
---
thanos_titans_sword = class({})

LinkLuaModifier( "modifier_thanos_titans_sword",	"abilities/thanos_titans_sword.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function thanos_titans_sword:GetIntrinsicModifierName() return "modifier_thanos_titans_sword" end

function thanos_titans_sword:OnSpellStart()
     if IsServer() then
          local hTarget = self:GetCursorTarget()
          if hTarget ~= nil then
               if ( not hTarget:TriggerSpellAbsorb( self ) ) then
                    if not hTarget:IsBuilding() and not hTarget:IsAncient() then
                         self:GetCaster():MoveToTargetToAttack(hTarget)
                    end
               end
          end
     end
end

---@class modifier_thanos_titans_sword
modifier_thanos_titans_sword = class ( {})

function modifier_thanos_titans_sword:IsHidden() return true end
function modifier_thanos_titans_sword:IsPurgable() return false end

function modifier_thanos_titans_sword:DeclareFunctions ()
     local funcs = {
          MODIFIER_EVENT_ON_ATTACK_LANDED,
          MODIFIER_EVENT_ON_ATTACK_START
     }

  return funcs
end

function modifier_thanos_titans_sword:OnAttackLanded (params)
     if IsServer () then
          if params.attacker == self:GetParent () then
               if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
                    if not params.target:IsBuilding() and not params.target:IsMagicImmune() then
                         local radius = self:GetAbility():GetSpecialValueFor("radius")

                         if self:GetCaster():HasTalent("special_bonus_unique_thanos_3") then radius = radius + self:GetCaster():FindTalentValue("special_bonus_unique_thanos_3") end 

                         local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), params.target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
                         if #units > 0 then
                              for _,unit in pairs(units) do
                                   unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("ministun_duration")})
                         
                                   EmitSoundOn("Hero_DoomBringer.Attack.Impact", unit)

                                   local bonus = (self:GetAbility():GetSpecialValueFor("bonus_damage") / 100) * unit:GetMaxHealth()

                                   ApplyDamage({
                                        attacker = self:GetParent(),
                                        victim = unit,
                                        damage = params.original_damage + bonus,
                                        damage_type = DAMAGE_TYPE_PURE,
                                        ability = self:GetAbility(),
                                        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION  + DOTA_DAMAGE_FLAG_HPLOSS 
                                   })                         
                              end
                         end

                         self:GetAbility():PayManaCost()
                         self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))

                         self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_3)
                    end
               end
          end
     end

     return 0
end

function modifier_thanos_titans_sword:OnAttackStart (params)
     if IsServer () then
          if params.attacker == self:GetParent () then
               if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
                    if not params.target:IsBuilding() and not params.target:IsMagicImmune() then
                         self:GetCaster():RemoveGesture(ACT_DOTA_ATTACK)
                         self:GetCaster():RemoveGesture(ACT_DOTA_ATTACK2)
                         
                         self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_3)
                    end
               end
          end
     end

     return 0
end