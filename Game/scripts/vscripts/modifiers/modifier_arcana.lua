if modifier_arcana == nil then modifier_arcana = class({}) end

function modifier_arcana:RemoveOnDeath()
   return false
end

function modifier_arcana:IsPurgable()
   return false
end

function modifier_arcana:IsHidden()
   return true
end
