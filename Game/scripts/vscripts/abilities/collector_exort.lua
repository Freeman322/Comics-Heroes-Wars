if not collector_exort then collector_exort = class({}) end 
LinkLuaModifier("modifier_collector_exort", "abilities/collector_exort.lua", LUA_MODIFIER_MOTION_NONE)


function collector_exort:IsStealable()
	return false
end


function collector_exort:OnSpellStart()
    if IsServer() then 
        local modifier = self:GetCaster():AddNewModifier(
            self:GetCaster(), 
            self, 
            "modifier_collector_exort", 
            {  } -- kv
        )
        
        self.invoke:AddOrb( modifier )
    end
end

function collector_exort:OnUpgrade()
    if IsServer() then 
        if not self.invoke then
            self.invoke = self:GetCaster():FindAbilityByName( "collector_collect" )
        else
            if self.invoke:GetLevel() < 1 then self.invoke:SetLevel(1) end
            self.invoke:UpdateOrb("modifier_collector_exort", self:GetLevel())
        end
    end
end

modifier_collector_exort = class({})

--------------------------------------------------------------------------------
-- Classifications

function modifier_collector_exort:IsHidden()
	return false
end

function modifier_collector_exort:IsDebuff()
	return false
end

function modifier_collector_exort:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_collector_exort:IsPurgable()
	return false
end

function modifier_collector_exort:OnDestroy( kv )

end

function modifier_collector_exort:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}

	return funcs
end

function modifier_collector_exort:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor( "bonus_damage_per_instance" ) or 0 
end
