modifier_connection_state = class({})

function modifier_connection_state:IsAura() return false end
function modifier_connection_state:IsHidden() return true end
function modifier_connection_state:IsPurgable() return false end
function modifier_connection_state:RemoveOnDeath() return false end

function modifier_connection_state:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(1)
    end 
end

function modifier_connection_state:OnIntervalThink()
    if PlayerResource:GetConnectionState(self:GetParent():GetPlayerOwnerID()) == DOTA_CONNECTION_STATE_ABANDONED then
        UTIL_Remove(self:GetParent())
    end
end