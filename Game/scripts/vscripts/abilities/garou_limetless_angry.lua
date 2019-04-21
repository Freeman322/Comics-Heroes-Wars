garou_limetless_angry = class({})

LinkLuaModifier("modifier_garou_limetless_angry", "abilities/garou_limetless_angry.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_garou_limetless_angry_fear", "abilities/garou_limetless_angry.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

--- Powers up when hero killed, depends on creep damage and heal 

---Vars 
garou_limetless_angry.m_iCounter = 1
garou_limetless_angry.m_iCreepDmgPTC = 45
---

function garou_limetless_angry:GetIntrinsicModifierName() return "modifier_garou_limetless_angry" end

--------------------------------------------------------------------------------

function garou_limetless_angry:OnHeroDiedNearby( hVictim, hKiller, kv )
	if hVictim == nil or hKiller == nil then
		return
	end

    self.m_iCreepDmgPTC = self:GetSpecialValueFor("creep_dmg_coff")

	if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() then
        if hKiller == self:GetCaster() then 
            self.m_iCounter = self.m_iCounter + 1

            self.m_iCreepDmgPTC = self.m_iCreepDmgPTC * self.m_iCounter

            local mod = self:GetCaster():FindModifierByName("modifier_garou_limetless_angry")

            if mod then mod:OnKillDone(hVictim, self.m_iCounter, hVictim:GetAbsOrigin()) end 
        end 
	end
end

--------------------------------------------------------------------------------

function garou_limetless_angry:GetKillCounter()
	if self.m_iCounter == nil then
		self.m_iCounter = 1
	end
	return self.m_iCounter
end

modifier_garou_limetless_angry = class({})

function modifier_garou_limetless_angry:IsHidden() return true end 
function modifier_garou_limetless_angry:IsPurgable() return false end 
function modifier_garou_limetless_angry:IsPermanent() return true end 
function modifier_garou_limetless_angry:RemoveOnDeath() return false end 

function modifier_garou_limetless_angry:OnKillDone(unit, stacks, position)
    if IsServer() then 
        --- TODO FEAR Modifier
    end 
end

function modifier_garou_limetless_angry:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_garou_limetless_angry:GetModifierExtraHealthBonus( params )
    return self:GetAbility():GetSpecialValueFor("health_coff") * self.m_iCounter
end

function modifier_garou_limetless_angry:GetModifierPreAttack_BonusDamage( params )
    return self:GetAbility():GetSpecialValueFor("damage_coff") * self.m_iCounter 
end

modifier_garou_limetless_angry_fear = class({})

--------------------------------------------------------------------------------

function modifier_garou_limetless_angry_fear:IsDebuff() return true end

--------------------------------------------------------------------------------

function modifier_garou_limetless_angry_fear:IsStunDebuff() return true end

--------------------------------------------------------------------------------

function modifier_garou_limetless_angry_fear:GetEffectName() return "" end

--------------------------------------------------------------------------------

function modifier_garou_limetless_angry_fear:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

--------------------------------------------------------------------------------

function modifier_garou_limetless_angry_fear:OnCreated(params) 
    if IsServer() then
        self:GetParent():MoveToPosition(self:GetParent():GetBasePos())
    end 
end 

function modifier_garou_limetless_angry_fear:OnDestroy()
    if IsServer() then
        self:GetParent():Stop()
    end 
end 
--------------------------------------------------------------------------------

function modifier_garou_limetless_angry_fear:CheckState()
	local state = {
        [MODIFIER_STATE_NIGHTMARED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end
