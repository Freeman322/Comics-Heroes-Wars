modifier_ogre = class({}) 

modifier_ogre.m_hAbility = nil

function modifier_ogre:IsPurgable() return false end
function modifier_ogre:IsHidden() return true end
function modifier_ogre:RemoveOnDeath() return false end
function modifier_ogre:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_ogre:OnCreated(params)
    if IsServer() then 
          self.m_hAbility = self:GetParent():FindAbilityByName("ogre_magi_unrefined_fireblast")

          if self.m_hAbility then self.m_hAbility:SetLevel(1) end 

          self:StartIntervalThink(0.333)
    end
end

function modifier_ogre:OnIntervalThink()
     if IsServer() then
          if self.m_hAbility then self.m_hAbility:SetHidden(not self:GetParent():HasScepter()) end 
     end 
end