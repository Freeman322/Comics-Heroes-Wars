if not collector_wex then collector_wex = class({}) end 
LinkLuaModifier("modifier_collector_wex", "abilities/collector_wex.lua", LUA_MODIFIER_MOTION_NONE)

function collector_wex:IsStealable()
	return false
end

function collector_wex:OnSpellStart()
    if IsServer() then 
        local modifier = self:GetCaster():AddNewModifier(
            self:GetCaster(), 
            self, 
            "modifier_collector_wex", 
            {  } -- kv
        )
        
        self.invoke:AddOrb( modifier )
    end
end

function collector_wex:OnUpgrade()
    if IsServer() then 
        if not self.invoke then
            self.invoke = self:GetCaster():FindAbilityByName( "collector_collect" )
        else
            if self.invoke:GetLevel() < 1 then self.invoke:SetLevel(1) end
            self.invoke:UpdateOrb("modifier_collector_wex", self:GetLevel())
        end
    end
end

modifier_collector_wex = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_collector_wex:IsHidden()
	return false
end

function modifier_collector_wex:IsDebuff()
	return false
end

function modifier_collector_wex:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_collector_wex:IsPurgable()
	return false
end

function modifier_collector_wex:OnDestroy( kv )

end

function modifier_collector_wex:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_collector_wex:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor( "attack_speed_per_instance" ) or 0 
end

function modifier_collector_wex:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor( "move_speed_per_instance" ) or 0 
end