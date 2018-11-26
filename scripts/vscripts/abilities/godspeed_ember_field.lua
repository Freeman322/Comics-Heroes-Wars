if not godspeed_ember_field then godspeed_ember_field = class({}) end
function godspeed_ember_field:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
LinkLuaModifier ("modifier_godspeed_ember_field", "abilities/godspeed_ember_field.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_godspeed_ember_field_aura", "abilities/godspeed_ember_field.lua", LUA_MODIFIER_MOTION_NONE)

function godspeed_ember_field:GetIntrinsicModifierName()
	return "modifier_godspeed_ember_field_aura"
end

function godspeed_ember_field:GetTotalThisLifeMovespeed()
    return self._iMovespeed or 0
end

function godspeed_ember_field:AddSpeed(value)
    self._iMovespeed = (self._iMovespeed or 0) + value
end

function godspeed_ember_field:OnOwnerDied()
    self._iMovespeed = 0
end

if modifier_godspeed_ember_field_aura == nil then modifier_godspeed_ember_field_aura = class({}) end

function modifier_godspeed_ember_field_aura:IsAura()
	return true
end

function modifier_godspeed_ember_field_aura:GetEffectName()
	return "particles/units/heroes/hero_chen/chen_penitence_debuff.vpcf"
end

function modifier_godspeed_ember_field_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_godspeed_ember_field_aura:IsHidden()
	return true
end

function modifier_godspeed_ember_field_aura:IsPurgable()
	return false
end

function modifier_godspeed_ember_field_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_godspeed_ember_field_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_godspeed_ember_field_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_godspeed_ember_field_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_godspeed_ember_field_aura:GetModifierAura()
	return "modifier_godspeed_ember_field"
end

function modifier_godspeed_ember_field_aura:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_godspeed_ember_field_aura:OnIntervalThink()
    if IsServer() then
        self:SetStackCount(self:GetAbility():GetTotalThisLifeMovespeed()) 
    end
end

function modifier_godspeed_ember_field_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT 
    }

    return funcs
end

function modifier_godspeed_ember_field_aura:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end

function modifier_godspeed_ember_field_aura:GetModifierMoveSpeed_Limit()
	return self:GetAbility():GetSpecialValueFor("max_speed")
end

function modifier_godspeed_ember_field_aura:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end


function modifier_godspeed_ember_field_aura:GetModifierMoveSpeedBonus_Constant()
    return self:GetStackCount()
end


if modifier_godspeed_ember_field == nil then modifier_godspeed_ember_field = class({}) end

function modifier_godspeed_ember_field:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_UNIT_MOVED
    }

    return funcs
end

function modifier_godspeed_ember_field:OnCreated( params )
    if IsServer() then self._vPosition = self:GetParent():GetAbsOrigin() end 
end

function modifier_godspeed_ember_field:OnUnitMoved(params)
	if IsServer() then 
		if params.unit == self:GetParent() then 
			if self._vPosition ~= self:GetParent():GetAbsOrigin() then 
				local distance = (self:GetParent():GetAbsOrigin() - self._vPosition):Length2D()

				self._vPosition = self:GetParent():GetAbsOrigin()

				self:OnPositionChanged(distance)
			end 			
		end
	end 
end

function modifier_godspeed_ember_field:OnPositionChanged( distance )
	if IsServer() then 
		local value = math.floor( distance ) * (self:GetAbility():GetSpecialValueFor("heal_ptc") / 100)
            
        self:GetCaster():Heal(value, self:GetCaster())

        self:GetAbility():AddSpeed(value)
	end
end


function modifier_godspeed_ember_field_aura:IsHidden()
	return true
end

function modifier_godspeed_ember_field_aura:IsPurgable()
	return false
end