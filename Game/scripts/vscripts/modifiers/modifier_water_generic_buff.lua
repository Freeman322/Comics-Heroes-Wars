local Z_PROXY = 130

if not modifier_water_generic_buff then modifier_water_generic_buff = class({}) end

function modifier_water_generic_buff:IsPurgable() return false end

modifier_water_generic_buff.m_hAbility = nil
modifier_water_generic_buff.m_hPrimaryBuff = nil
modifier_water_generic_buff.m_hWaterBuff = nil

function modifier_water_generic_buff:OnCreated(params)
    if IsServer() then
          self.m_hAbility = self:GetAbility()
          self.m_hPrimaryBuff = self:GetParent():AddNewModifier(self:GetParent(), self.m_hAbility, self.m_hAbility:GetDefaultBuffModifierName(), nil)

          self:StartIntervalThink(FrameTime())
    end
end

function modifier_water_generic_buff:OnDestroy()
     if IsServer() then
          if self.m_hPrimaryBuff ~= nil  then
               self.m_hPrimaryBuff:Destroy() 
          end

          if self.m_hWaterBuff ~= nil then
               self.m_hWaterBuff:Destroy()
          end
     end
end

function modifier_water_generic_buff:OnIntervalThink()
     if IsServer() then
          if self:GetParent():GetAbsOrigin().z <= Z_PROXY and not self.m_hWaterBuff then
               self.m_hWaterBuff = self:GetParent():AddNewModifier(self:GetParent(), self.m_hAbility, self.m_hAbility:GetWaterBuffModifierName(), nil)
          end
          if self:GetParent():GetAbsOrigin().z > Z_PROXY then
               if self.m_hWaterBuff ~= nil and not self.m_hWaterBuff:IsNull() then
                    self.m_hWaterBuff:Destroy()
               end
          end
     end
end
