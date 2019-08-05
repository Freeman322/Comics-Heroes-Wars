if not sheefu_tears_of_fears then sheefu_tears_of_fears = class({}) end
LinkLuaModifier( "modifier_sheefu_tears_of_fears", "abilities/sheefu_tears_of_fears.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheefu_tears_of_fears_target", "abilities/sheefu_tears_of_fears.lua", LUA_MODIFIER_MOTION_NONE )

function sheefu_tears_of_fears:GetIntrinsicModifierName() return "modifier_sheefu_tears_of_fears" end

modifier_sheefu_tears_of_fears = class({})
function modifier_sheefu_tears_of_fears:IsHidden() return true end
function modifier_sheefu_tears_of_fears:IsPurgable() return false end
function modifier_sheefu_tears_of_fears:RemoveOnDeath() return false end
function modifier_sheefu_tears_of_fears:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_sheefu_tears_of_fears:OnAttackLanded (params)
    if IsServer() then
        if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() and params.attacker:IsRealHero() and not params.attacker:PassivesDisabled() and not params.attacker:IsSilenced() then
            if params.target:IsHero() then
               local modifier = params.target:FindModifierByName("modifier_sheefu_tears_of_fears_target")
               if not modifier then
                    modifier =  params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sheefu_tears_of_fears_target", {duration = self:GetAbility():GetSpecialValueFor("counter_duration")})
                    modifier:SetStackCount(1) return 
               end
                modifier:IncrementStackCount()
            end
        end
    end
end

if not modifier_sheefu_tears_of_fears_target then modifier_sheefu_tears_of_fears_target = class({}) end
function modifier_sheefu_tears_of_fears_target:IsHidden() return false end
function modifier_sheefu_tears_of_fears_target:IsPurgable() return false end
function modifier_sheefu_tears_of_fears_target:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_ambient_glow.vpcf" end
function modifier_sheefu_tears_of_fears_target:GetEffectAttachType() return PATTACH_ABSORIGIN end

function modifier_sheefu_tears_of_fears_target:OnStackCountChanged(iStackCount)
     if IsServer() then
          ParticleManager:DestroyParticle(self.effect, false)

          self.effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
          ParticleManager:SetParticleControl( self.effect, 0, self:GetParent():GetAbsOrigin() )
          ParticleManager:SetParticleControl( self.effect, 1, Vector(1, self:GetStackCount() + 1, 0) )
          ParticleManager:SetParticleControl( self.effect, 3, self:GetParent():GetAbsOrigin() )
          self:AddParticle(self.effect, false, false, -1, false, true)
          
          ApplyDamage( {
               victim = self:GetParent(),
               attacker = self:GetCaster(),
               damage = self:GetAbility():GetSpecialValueFor("bonus_damage"),
               damage_type = DAMAGE_TYPE_PHYSICAL,
               ability = self:GetAbility()
          })

          if iStackCount == self:GetAbility():GetSpecialValueFor("required_hits") then
               local target = self:GetParent()

               local mana_burn = self:GetAbility():GetSpecialValueFor( "mana_burn" )
               local max_damage = self:GetAbility():GetSpecialValueFor(  "max_damage_ptc" )
               local damage = self:GetAbility():GetSpecialValueFor("bonus_damage")

               local ignore_cap_damage = self:GetCaster():HasTalent("special_bonus_unique_sheefu_1")

               target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = 0.05 } )

               local calc_damage = target:GetMaxMana() * (mana_burn / 100)

               if not ignore_cap_damage and calc_damage > (target:GetMaxHealth() * (max_damage / 100)) then
                    calc_damage = target:GetMaxHealth() * (max_damage / 100)
               end

               ApplyDamage( {
                    victim = target,
                    attacker = self:GetCaster(),
                    damage = calc_damage,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    ability = self:GetAbility()
               } )

               target:SpendMana(calc_damage, self:GetAbility())

               local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
               ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
               ParticleManager:SetParticleControl( nFXIndex, 5, self:GetParent():GetAbsOrigin() )
               ParticleManager:ReleaseParticleIndex( nFXIndex )

               EmitSoundOn( "Hero_Nightstalker.Void.Nihility", self:GetCaster() )

               self:GetAbility():UseResources(false, false, true)
               self:Destroy()
          end
     end
end

function modifier_sheefu_tears_of_fears_target:OnCreated(params)
    if IsServer() then
        self.effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( self.effect, 0, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( self.effect, 1, Vector(1, self:GetStackCount() + 1, 0) )
        ParticleManager:SetParticleControl( self.effect, 3, self:GetParent():GetAbsOrigin() )
        self:AddParticle(self.effect, false, false, -1, false, true)

        EmitSoundOn( "Hero_Abaddon.Curse.Proc", self:GetCaster() )
    end
end

function modifier_sheefu_tears_of_fears_target:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
