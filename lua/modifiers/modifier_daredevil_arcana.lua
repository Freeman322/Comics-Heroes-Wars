if modifier_daredevil_arcana == nil then modifier_daredevil_arcana = class({}) end

function modifier_daredevil_arcana:IsHidden()
	return true
end

function modifier_daredevil_arcana:IsPurgable()
	return false
end

function modifier_daredevil_arcana:RemoveOnDeath()
	return false
end

function modifier_daredevil_arcana:OnCreated(params)
    if IsServer() then 
        Timers:CreateTimer(1, function()
        	if self:GetParent().wearables ~= nil and self:GetParent().wearables["head"] ~= nil and self:GetCaster():GetUnitName() == "npc_dota_hero_juggernaut" then 
            	self:GetParent().wearables["head"]:RemoveSelf()
            end 
        end)
    end
end
