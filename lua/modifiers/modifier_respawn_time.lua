if modifier_respawn_time == nil then modifier_respawn_time = class({}) end

function modifier_respawn_time:IsPurgable()
	return false
end

function modifier_respawn_time:IsHidden()
	return true
end

function modifier_respawn_time:RemoveOnDeath()
	return false
end

function modifier_respawn_time:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_respawn_time:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_respawn_time:OnDeath(params)
    if IsServer() then 
		if params.unit == self:GetParent() and GetMapName() ~= "free_for_all" then 
			if self:GetParent():IsReincarnating() then 
				return
			end
			if self:GetParent():FindModifierByName("modifier_item_frostmourne") ~= nil then
				if self:GetParent():FindModifierByName("modifier_item_frostmourne"):WillReincarnate() then 
					return 
				end 
			end
            local time = self:GetParent():GetLevel() * 3
            self:GetParent():SetTimeUntilRespawn(time)
            self:GetParent():SetBuybackCooldownTime(10)
        end
    end
end
