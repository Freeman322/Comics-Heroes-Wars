if not modifier_speech then modifier_speech = class({}) end 

function modifier_speech:IsHidden() return true end
function modifier_speech:IsPurgable() return false end
function modifier_speech:RemoveOnDeath() return false end
function modifier_speech:DestroyOnExpire() return false end

function modifier_speech:OnCreated(params) 
    if IsServer() then 
        self._sHeroPrefix = self:GetCaster():GetUnitName():gsub("npc_dota_hero_", "")
        self._sHeroName =  self:GetCaster():GetUnitName()
        self._iCooldown = 6

        self:StartIntervalThink(1)
    end 
end

function modifier_speech:OnIntervalThink()
    if IsServer() then 
        if self._iCooldown > 0 then self._iCooldown = self._iCooldown - 1 end 
    end 
end

function modifier_speech:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_UNIT_MOVED,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_ORDER,
        MODIFIER_EVENT_ON_HERO_KILLED
    }

    return funcs
end

function modifier_speech:IsSpeechInCooldown()
    return self._iCooldown > 0
end

function modifier_speech:OnDeath( params )
    if IsServer() then
        if params.unit == self:GetParent() then 
            pcall(function()           
                local chance = math.random(1, 5)
                EmitSoundOn(self._sHeroPrefix .. "_Die_" .. chance, self:GetParent())
            end)
        end
    end 
end

function modifier_speech:OnUnitMoved( params )
    if params.unit == self:GetParent() then 
        if not self:IsSpeechInCooldown() then          
            local chance = math.random(1, 10)
            local sound = self._sHeroPrefix .. "_Attack_" .. chance
            
            EmitAnnouncerSoundForPlayer(sound, self:GetParent():GetPlayerOwnerID())

            print(sound)

            self._iCooldown = 6
        end
    end
end

function modifier_speech:OnOrder( params )

end

function modifier_speech:OnHeroKilled( params )
    if params.attacker == self:GetParent() then 
        pcall(function()           
            local chance = math.random(1, 5)

            EmitSoundOn(self._sHeroPrefix .. "_Kill_" .. chance, self:GetParent())
        end)
    end
end

