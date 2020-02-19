if not tatsumaki_mastery then tatsumaki_mastery = class({}) end 

LinkLuaModifier ("modifier_tatsumaki_mastery", "abilities/tatsumaki_mastery.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_tatsumaki_mastery_buff", "abilities/tatsumaki_mastery.lua", LUA_MODIFIER_MOTION_NONE)

function tatsumaki_mastery:GetIntrinsicModifierName()
    return "modifier_tatsumaki_mastery"
end


function tatsumaki_mastery:OnSpellStart()
     if not IsServer() then return end

     local pos = self:GetCursorPosition()

     self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tatsumaki_mastery_buff", {x = pos.x, y = pos.y, z = pos.z})

     EmitSoundOn("Tatsumaki.Cast3", self:GetCaster())
 end
 

if not modifier_tatsumaki_mastery then modifier_tatsumaki_mastery = class({}) end 

modifier_tatsumaki_mastery.m_inFXIndex = nil
modifier_tatsumaki_mastery.max_charges = 0

function modifier_tatsumaki_mastery:IsDebuff() return false end
function modifier_tatsumaki_mastery:IsPurgable() return false end
function modifier_tatsumaki_mastery:IsPermanent() return true end

function modifier_tatsumaki_mastery:OnCreated( kv )
     self.max_charges = self:GetAbility():GetSpecialValueFor("max_stacks")
     self.charge_time = self:GetAbility():GetSpecialValueFor("stack_recovery_time")

     if IsServer() then     
          self:SetStackCount(self.max_charges)
          self:CalculateCharge()
     end
 end
 
 function modifier_tatsumaki_mastery:OnRefresh(params)
     self.max_charges = self:GetAbility():GetSpecialValueFor("max_stacks")
     self.charge_time = self:GetAbility():GetSpecialValueFor("stack_recovery_time")

     if IsServer() then  
          self:CalculateCharge()
     end
 end
 
 function modifier_tatsumaki_mastery:DeclareFunctions()
     local funcs = {
          MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
          MODIFIER_EVENT_ON_TAKEDAMAGE,
          MODIFIER_PROPERTY_DODGE_PROJECTILE 
     }
 
     return funcs
 end

 function modifier_tatsumaki_mastery:GetModifierDodgeProjectile(params)
     if IsServer() and self:GetStackCount() > 0 then
          EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())

          local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
          ParticleManager:SetParticleControl( effect, self:GetParent():GetOrigin() + Vector(0, 0, 96) )
          ParticleManager:ReleaseParticleIndex(effect)

          return 1
     end
 
     return
 end

 function modifier_tatsumaki_mastery:GetModifierIncomingDamage_Percentage(params)
     if IsServer() and self:GetStackCount() > 0 then
          if not params.attacker:IsHero() then
               return self:GetAbility():GetSpecialValueFor("creep_evasion_pct") 
          end

          local reduction = self:GetStackCount() * self:GetAbility():GetSpecialValueFor("one_stack_reduction")  * (-1)

          self:DecrementStackCount()
          self:CalculateCharge()

          return reduction
     end
 
     return 0
 end
 
 --------------------------------------------------------------------------------
-- Interval Effects
function modifier_tatsumaki_mastery:OnIntervalThink()
     if IsServer() then
          self:IncrementStackCount()
          self:StartIntervalThink(-1)
          self:CalculateCharge()
     end
end
 
 function modifier_tatsumaki_mastery:CalculateCharge()
     if self:GetStackCount()>=self.max_charges then
          -- stop charging
          self:SetDuration( -1, false )
          self:StartIntervalThink( -1 )
     else
         -- if not charging
          if self:GetRemainingTime() <= 0.05 then
               -- start charging
               local charge_time = self:GetAbility():GetCooldown( -1 )
               if self.charge_time then
                    charge_time = self.charge_time
               end
               self:StartIntervalThink( charge_time )
               self:SetDuration( charge_time, true )
          end
     
          -- set on cooldown if no charges
          if self:GetStackCount()==0 then
               self:GetAbility():StartCooldown( self:GetRemainingTime() )
          end
     end
 end


modifier_tatsumaki_mastery_buff = class({
     IsHidden = function() return false end,
     IsPurgable = function() return false end,
     RemoveOnDeath = function() return true end,
})
 
modifier_tatsumaki_mastery_buff.pos = nil

function modifier_tatsumaki_mastery_buff:CheckState () return { [MODIFIER_STATE_COMMAND_RESTRICTED] = true, [MODIFIER_STATE_FLYING] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_OUT_OF_GAME] = true } end


function modifier_tatsumaki_mastery_buff:GetEffectName()return "particles/units/heroes/hero_demonartist/demonartist_soulchain_debuff.vpcf" end
function modifier_tatsumaki_mastery_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
 
function modifier_tatsumaki_mastery_buff:OnCreated(params)
     if IsServer() then
          self.pos = Vector(params.x, params.y, params.z)
          self.speed = self:GetAbility():GetSpecialValueFor("fly_speed")
          self.traveled_distance = 0

          self:StartIntervalThink(FrameTime())
          self:GetParent():SetThink( "OnFlyProcess", self, 0.1 )
     end
end

function modifier_tatsumaki_mastery_buff:OnFlyProcess()
     if not self or self:IsNull() then return nil end 

     local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("fly_avalance_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #units > 0 then
		for _,unit in pairs(units) do
               unit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = 0.15 } )
               
               local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
               ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
               ParticleManager:ReleaseParticleIndex( nFXIndex )

               local DamageInfo =
               {
                    victim = unit,
                    attacker = self:GetCaster(),
                    ability = self:GetAbility(),
                    damage = self:GetAbility():GetSpecialValueFor("fly_avalance_total_damage") * 0.1,
                    damage_type = DAMAGE_TYPE_PURE,
               }

               ApplyDamage( DamageInfo )
		end
	end

     return 0.1
end

 
function modifier_tatsumaki_mastery_buff:OnIntervalThink()
     if not IsServer() then return end
     self:GetParent():FaceTowards(self.pos)

     local distance = (self.pos - self:GetParent():GetAbsOrigin()):Length2D()
    
     if distance > 24 then
          self:GetParent():SetOrigin(self:GetParent():GetAbsOrigin() + (self.pos - self:GetParent():GetAbsOrigin()):Normalized() * self.speed * FrameTime())
          self.traveled_distance = self.traveled_distance + self.speed * FrameTime()
     else
          FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)

          self:Destroy()
     end
end
 