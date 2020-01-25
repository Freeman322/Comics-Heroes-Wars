if modifier_kill_sound == nil then modifier_kill_sound = class({}) end

modifier_kill_sound.m_sSound = ""

function modifier_kill_sound:IsPurgable() return false end
function modifier_kill_sound:IsHidden() return true end
function modifier_kill_sound:RemoveOnDeath() return false end

function modifier_kill_sound:OnCreated(params)
    self.m_sSound = params.sound
end

function modifier_kill_sound:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_HERO_KILLED
    }

    return funcs
end

function modifier_kill_sound:OnHeroKilled(params)
    if params.attacker == self:GetParent() then
        EmitSoundOn(self.m_sSound, self:GetParent())
    end
end

function modifier_kill_sound:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
