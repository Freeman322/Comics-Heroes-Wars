if not collector_quas then collector_quas = class({}) end 
LinkLuaModifier("modifier_collector_quas", "abilities/collector_quas.lua", LUA_MODIFIER_MOTION_NONE)

function collector_quas:OnSpellStart()
    if IsServer() then 
        local modifier = self:GetCaster():AddNewModifier(
            self:GetCaster(), 
            self, 
            "modifier_collector_quas", 
            {  } -- kv
        )
        
        self.invoke:AddOrb( modifier )
    end
end


function collector_quas:IsStealable()
	return false
end

--------------------------------------------------------------------------------
-- Ability Events
function collector_quas:OnUpgrade()
    if IsServer() then 
        if not self.invoke then
            self.invoke = self:GetCaster():FindAbilityByName( "collector_collect" )
        else
            if self.invoke:GetLevel() < 1 then self.invoke:SetLevel(1) end
            self.invoke:UpdateOrb("modifier_collector_quas", self:GetLevel())
        end
    end
end

modifier_collector_quas = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_collector_quas:IsHidden()
	return false
end

function modifier_collector_quas:IsDebuff()
	return false
end

function modifier_collector_quas:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_collector_quas:IsPurgable()
	return false
end

function modifier_collector_quas:OnDestroy( kv )

end

function modifier_collector_quas:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_collector_quas:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor( "health_regen_per_instance" ) or 0 
end