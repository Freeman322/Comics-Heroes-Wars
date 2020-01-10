LinkLuaModifier( "modifier_cosmos_jumper", "abilities/cosmos_jumper.lua", LUA_MODIFIER_MOTION_NONE )

if cosmos_jumper == nil then cosmos_jumper = class({}) end 

cosmos_jumper.m_hTaget = nil

function cosmos_jumper:CastFilterResultTarget( hTarget )
     if hTarget == self:GetCaster() then
          return UF_SUCCESS
     end

     if hTarget:IsHero() then
          return UF_FAIL_CUSTOM
     end

     if hTarget:IsBuilding() then
          return UF_FAIL_CUSTOM
     end

     return UF_SUCCESS
end

--------------------------------------------------------------------------------

function cosmos_jumper:GetCustomCastErrorTarget( hTarget )
     return ""
end

function cosmos_jumper:OnSpellStart()
     if IsServer() then
          local hTarget = self:GetCursorTarget()

          if self.m_hTaget and not self.m_hTaget:IsNull() then
               local hCaster = self.m_hTaget

               hCaster:AddNewModifier(self:GetCaster(), self, "modifier_cosmos_jumper", {duration = self:GetSpecialValueFor("tooltip_delay"), target = hTarget:entindex()})
               hTarget:AddNewModifier(self:GetCaster(), self, "modifier_cosmos_jumper", {duration = self:GetSpecialValueFor("tooltip_delay"), target = hCaster:entindex()})

               local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
               ParticleManager:SetParticleControlEnt( nTargetFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
               ParticleManager:ReleaseParticleIndex( nTargetFX )

               EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hTarget )
               
               self.m_hTaget = nil
          else 
               local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
               ParticleManager:SetParticleControlEnt( nTargetFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
               ParticleManager:ReleaseParticleIndex( nTargetFX )

               EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hTarget )

               self.m_hTaget = hTarget
               
               self:EndCooldown()
          end 
     end 
end

if modifier_cosmos_jumper == nil then modifier_cosmos_jumper = class({}) end

function modifier_cosmos_jumper:IsDebuff() return true end
function modifier_cosmos_jumper:IsHidden() return true end
function modifier_cosmos_jumper:IsPurgable() return false end
function modifier_cosmos_jumper:GetStatusEffectName() return "particles/status_fx/status_effect_mars_spear.vpcf" end
function modifier_cosmos_jumper:StatusEffectPriority() return 1000 end

function modifier_cosmos_jumper:OnCreated(params) 
     if IsServer() then
          self.target = EntIndexToHScript(params.target)
          self.pos = self.target:GetAbsOrigin()
     end 
end

function modifier_cosmos_jumper:OnDestroy()
     if IsServer() then
          self:GetParent():SetAbsOrigin(self.pos)

          FindClearSpaceForUnit( self:GetParent(), self.pos, true )

          local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
          ParticleManager:SetParticleControlEnt( nCasterFX, 1, self.target, PATTACH_ABSORIGIN_FOLLOW, nil, self.target:GetOrigin(), false )
          ParticleManager:ReleaseParticleIndex( nCasterFX )

          local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target )
          ParticleManager:SetParticleControlEnt( nTargetFX, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
          ParticleManager:ReleaseParticleIndex( nTargetFX )

          EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", self:GetParent() )
          EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", self.target )
     end 
end