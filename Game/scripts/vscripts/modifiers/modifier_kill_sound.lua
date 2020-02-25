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

if modifier_sounds == nil then modifier_sounds = class({}) end

modifier_sounds.m_sSound = ""
modifier_sounds.abils = {}

function modifier_sounds:IsPurgable() return false end
function modifier_sounds:IsHidden() return true end
function modifier_sounds:RemoveOnDeath() return false end

function modifier_sounds:OnCreated(params)
    self.m_sSound = params.kill

    self.abils[1] = params.ability0
    self.abils[2] = params.ability1
    self.abils[3] = params.ability2
    self.abils[4] = params.ability3
    self.abils[5] = params.ability4
    self.abils[6] = params.ability5
    self.abils[7] = nil
end

function modifier_sounds:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_HERO_KILLED,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }

    return funcs
end

function modifier_sounds:OnHeroKilled(params)
    if IsServer() then
        if params.attacker == self:GetParent() and self.m_sSound ~= nil then
            EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), self.m_sSound, self:GetParent())
        end
    end
end

function modifier_sounds:OnAbilityExecuted( params )
	if IsServer() then
        if params.unit == self:GetParent() then
            -- check item ability
			local hAbility = params.ability
			if hAbility ~= nil and not hAbility:IsItem() then
                local sound = hAbility:GetAbilityIndex() + 1

                print(self.abils[sound])
                
                if self.abils[sound] then
                    EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), self.abils[sound], self:GetParent())
                end
			end
        end
	end
end

function modifier_sounds:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

