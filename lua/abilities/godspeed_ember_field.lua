if not godspeed_ember_field then godspeed_ember_field = class({}) end
function godspeed_ember_field:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
LinkLuaModifier ("modifier_godspeed_ember_field", "abilities/godspeed_ember_field.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_godspeed_ember_field_aura", "abilities/godspeed_ember_field.lua", LUA_MODIFIER_MOTION_NONE)


function godspeed_ember_field:GetIntrinsicModifierName()
	return "modifier_godspeed_ember_field_aura"
end

if modifier_godspeed_ember_field_aura == nil then modifier_godspeed_ember_field_aura = class({}) end

function modifier_godspeed_ember_field_aura:IsAura()
	return true
end

function modifier_godspeed_ember_field_aura:IsHidden()
	return true
end

function modifier_godspeed_ember_field_aura:IsPurgable()
	return true
end

function modifier_godspeed_ember_field_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_godspeed_ember_field_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
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

if modifier_godspeed_ember_field == nil then modifier_godspeed_ember_field = class({}) end

function modifier_godspeed_ember_field:OnCreated(htable)
    self._flSpeed = 0
    if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_godspeed_ember_field:OnIntervalThink()
    if IsServer() then
        local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                if unit then
                    self._flSpeed = self._flSpeed + unit:GetMoveSpeedModifier(unit:GetBaseMoveSpeed())
                end
            end
        end
    end
    if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
        self._flSpeed = self._flSpeed * (self:GetAbility():GetSpecialValueFor("speed_stole")/100)
        self._flSpeed = self._flSpeed * (-1)
    else
        self._flSpeed = self._flSpeed * (self:GetAbility():GetSpecialValueFor("speed_stole")/100)
    end
	self:ForceRefresh()
end

function modifier_godspeed_ember_field:IsPurgable(  )
    return false
end

function modifier_godspeed_ember_field:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
				MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_godspeed_ember_field:GetModifierMoveSpeed_Max()
	return 99999
end

function modifier_godspeed_ember_field:GetModifierMoveSpeed_Limit()
	return 99999
end

function modifier_godspeed_ember_field:GetModifierMoveSpeedBonus_Constant()
    if not self._flSpeed then
        self._flSpeed = 0
    end
	return self._flSpeed
end
