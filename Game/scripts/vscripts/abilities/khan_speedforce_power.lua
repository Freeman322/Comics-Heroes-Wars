khan_speedforce_power = class({})

LinkLuaModifier( "modifier_khan_speedforce_power", "abilities/khan_speedforce_power.lua", LUA_MODIFIER_MOTION_NONE )


function khan_speedforce_power:GetIntrinsicModifierName()
	return "modifier_khan_speedforce_power"
end

modifier_khan_speedforce_power = class({})

function modifier_khan_speedforce_power:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_khan_speedforce_power:IsPurgable()
	return false
end

function modifier_khan_speedforce_power:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_khan_speedforce_power:GetModifierEvasion_Constant( params )
	local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_evasion")
end

function modifier_khan_speedforce_power:OnTakeDamage( params )
    if params.unit == self:GetParent() then
    	local random = math.random(100)
    	if random <= self:GetAbility():GetSpecialValueFor("protect_chance") then
    		params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned",{duration = self:GetAbility():GetSpecialValueFor("duration")})
    	end
    end
end

function khan_speedforce_power:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

