modifier_responses = class({})

-- Hidden, permanent, not purgable
function modifier_responses:IsHidden() return false end
function modifier_responses:IsPurgable() return false end
function modifier_responses:IsPermanent() return true end

function modifier_responses:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true
    }
end

function modifier_responses:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ORDER,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
end

function modifier_responses:OnOrder(event) self.FireOutput('OnOrder', event) end
function modifier_responses:OnDeath(event) self.FireOutput('OnUnitDeath', event) end
function modifier_responses:OnTakeDamage(event) self.FireOutput('OnTakeDamage', event) end
function modifier_responses:OnAbilityExecuted(event) self.FireOutput('OnAbilityExecuted', event) end
