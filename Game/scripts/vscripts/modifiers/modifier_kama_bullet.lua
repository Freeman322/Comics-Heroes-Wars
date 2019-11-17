if modifier_kama_bullet == nil then modifier_kama_bullet = class({}) end

function modifier_kama_bullet:IsHidden() return true end
function modifier_kama_bullet:IsPurgable() return false end
function modifier_kama_bullet:RemoveOnDeath() return false end

function modifier_kama_bullet:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_RESPAWN
    }

    return funcs
end

function modifier_kama_bullet:OnRespawn(params)
    if IsServer() then 
        if params.unit == self:GetParent() then 
            EmitSoundOn("Kama.Spawn", self:GetParent())
        end 
    end 
end