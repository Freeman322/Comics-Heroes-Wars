LinkLuaModifier ("modifier_garou_will_active", "abilities/garow_will.lua", LUA_MODIFIER_MOTION_NONE)

garow_will = class({})

---vars

local CONST_DUMMY_MODIFIER_DURATION = 10.0
local CONST_MOVESPEED = 1000
local CONST_STUN_DURATION = 0.5

---
function garow_will:GetCooldown( nLevel ) return self.BaseClass.GetCooldown( self, nLevel ) end

function garow_will:OnSpellStart()
    if IsServer() then
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            if ( not hTarget:TriggerSpellAbsorb( self ) ) then
                if not hTarget:IsBuilding() and not hTarget:IsAncient() then
                    self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_garou_will_active", {target = hTarget:entindex()})
                end
            end
        end
    end
end

if modifier_garou_will_active == nil then modifier_garou_will_active = class({}) end
function modifier_garou_will_active:IsHidden() return true end
function modifier_garou_will_active:IsPurgable() return false end
function modifier_garou_will_active:GetStatusEffectName() return "particles/status_fx/status_effect_grimstroke_ink_swell.vpcf" end
function modifier_garou_will_active:StatusEffectPriority() return 1000 end
function modifier_garou_will_active:GetEffectName() return "" end

function modifier_garou_will_active:IsPurgable()
    return false
end

function modifier_garou_will_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_garou_will_active:OnCreated(params)
    if IsServer() then 
        if params.unit then 
            self._hUnit = EntIndexToHScript(params.target)

            if IsValidEntity(self._hUnit) then 
                self:SetDuration(CONST_DUMMY_MODIFIER_DURATION, false)

                self:GetParent():Stop()
                self:GetParent():MoveToTargetToAttack(self._hUnit)

                self:StartIntervalThink(FrameTime())
                return
            end 

            self:Destroy()
        end 
    end
end

function modifier_fate_fatebind:OnIntervalThink()
    if IsServer() then 
        if self._hUnit:IsNull() or self._hUnit == nil then self:Destroy() end 

        if (self._hUnit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= 128 then 
            self._hUnit:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = CONST_STUN_DURATION})
            self:Destroy()
        end 
    end
end

function modifier_garou_will_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
    }

    return funcs
end

function modifier_garou_will_active:GetModifierMoveSpeed_Absolute()
	return CONST_MOVESPEED
end


function modifier_garou_will_active:CheckState()
	local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
	}

	return state
end
