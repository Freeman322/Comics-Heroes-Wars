if not modifier_escape then modifier_escape = class({}) end 

function modifier_escape:IsHidden()
	return false
end

function modifier_escape:IsPurgable()
    return false
end

function modifier_escape:RemoveOnDeath()
    return false
end

function modifier_escape:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }

    return state
end

function modifier_escape:OnCreated(params)
    if IsServer() then 
        self._iTimeOut = 8

        self:StartIntervalThink(1)
    end 
end

function modifier_escape:OnIntervalThink()
    if IsServer() then 
        self._iTimeOut = self._iTimeOut - 1

        if self._iTimeOut <= 0 then 
            EmitAnnouncerSoundForPlayer("Event.Escaped", self:GetParent():GetPlayerOwnerID())

            self:Escape()
            return 
        end

        CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "on_escape", {time = self._iTimeOut})
        EmitAnnouncerSoundForPlayer("Event.EscapeTick", self:GetParent():GetPlayerOwnerID())
    end 
end

function modifier_escape:Escape()
    if IsServer() then
        CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "on_escape_done", nil)
        
        Event:OnPlayerEscaped(self:GetParent())

        self:Destroy()
    end 
end