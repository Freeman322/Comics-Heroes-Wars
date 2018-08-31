ghost_quantum_phase = class({})
LinkLuaModifier("modifier_ghost_quantum_phase", "abilities/ghost_quantum_phase.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghost_quantum_phase_disabled_mana_regen", "abilities/ghost_quantum_phase.lua", LUA_MODIFIER_MOTION_NONE)

function ghost_quantum_phase:ProcsMagicStick()
	return false
end

function ghost_quantum_phase:GetManaCostPerSecond()
	return self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("mana_cost_tick") / 100)
end

function ghost_quantum_phase:OnToggle()
    if IsServer() then 
        if self:GetToggleState() then
            self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ghost_quantum_phase", nil ) 
            self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ghost_quantum_phase_disabled_mana_regen", nil )

            EmitSoundOn("Ghost.Quantum_phase.Cast", self:GetCaster())

            self:EndCooldown()
        else
            local hBuff = self:GetCaster():FindModifierByName( "modifier_ghost_quantum_phase" )
            if hBuff ~= nil then
                hBuff:Destroy()
            end

            self:UseResources(false, false, true)
        end
    end
end

if not modifier_ghost_quantum_phase then modifier_ghost_quantum_phase = class({}) end 

function modifier_ghost_quantum_phase:IsPurgable()
    return false
end

function modifier_ghost_quantum_phase:IsHidden()
    return false
end

function modifier_ghost_quantum_phase:OnCreated(params)
    if IsServer() then 
        self._iBaseMana = self:GetParent():GetMana()
        self:SetStackCount(self:GetParent():GetManaRegen())
        self:StartIntervalThink(1) self:OnIntervalThink()
    end
end

function modifier_ghost_quantum_phase:OnIntervalThink()
    if IsServer() then 
        if self:GetParent():GetMana() > 10 then self:GetParent():SpendMana(self:GetAbility():GetManaCostPerSecond(), self:GetAbility()) else self:GetAbility():ToggleAbility() end 
    end 
end

function modifier_ghost_quantum_phase:CheckState()
	local state = {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_MUTED] = true
	}
	return state
end

function modifier_ghost_quantum_phase:GetEffectName()
	return "particles/ghost/quantum_phase.vpcf"
end

function modifier_ghost_quantum_phase:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ghost_quantum_phase:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_ghost_quantum_phase:GetModifierMoveSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("active_bonus_speed")
end

if not modifier_ghost_quantum_phase_disabled_mana_regen then modifier_ghost_quantum_phase_disabled_mana_regen = class({}) end 

function modifier_ghost_quantum_phase_disabled_mana_regen:IsHidden()
    return true
end

function modifier_ghost_quantum_phase_disabled_mana_regen:IsPurgable()
    return false
end

function modifier_ghost_quantum_phase_disabled_mana_regen:OnIntervalThink()
    if IsServer() then 
        if self._iMana < self:GetParent():GetMana() then self:OnManaIncreased() self:GetParent():SetMana(self._iMana) self._iMana = self:GetParent():GetMana() else self._iMana = self:GetParent():GetMana() end  
        
        if not self._hAbility:GetToggleState() then self:Destroy() end 
    end 
end

function modifier_ghost_quantum_phase_disabled_mana_regen:OnCreated(params)
    if IsServer() then 
        self._iMana = self:GetParent():GetMana()

        self._hAbility = self:GetParent():FindAbilityByName("ghost_quantum_phase")
            
        self:StartIntervalThink(0.01)
    end 
end

function modifier_ghost_quantum_phase_disabled_mana_regen:OnManaIncreased()
    if IsServer() then 
        
    end 
end
