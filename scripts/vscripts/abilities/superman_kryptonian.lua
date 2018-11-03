superman_kryptonian = class({})
LinkLuaModifier( "modifier_superman_kryptonian", "abilities/superman_kryptonian", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
EF_DAYTIME = "Day"
EF_NIGHTTIME = "Night"


function superman_kryptonian:GetIntrinsicModifierName()
	return "modifier_superman_kryptonian"
end

--------------------------------------------------------------------------------

if modifier_superman_kryptonian == nil then modifier_superman_kryptonian = class({}) end

--------------------------------------------------------------------------------

function modifier_superman_kryptonian:OnCreated( kv )
    if IsServer() then
        self.nMaxStacks = self:GetAbility():GetSpecialValueFor("max_stacks")
        self.nGameTime = EF_DAYTIME

        if self:GetCaster():HasTalent("special_bonus_unique_superman_2") then self.nMaxStacks = self.nMaxStacks + self:GetCaster():FindTalentValue("special_bonus_unique_superman_2") end

		self:StartIntervalThink( 1 ) self:SetStackCount(1)
	end

end

function modifier_superman_kryptonian:OnRefresh(params)
    if IsServer() then
        self.nMaxStacks = self:GetAbility():GetSpecialValueFor("max_stacks")
        if self:GetCaster():HasTalent("special_bonus_unique_superman_2") then self.nMaxStacks = self.nMaxStacks + self:GetCaster():FindTalentValue("special_bonus_unique_superman_2") end
	end
end

function modifier_superman_kryptonian:OnIntervalThink()
    if IsServer() then
        if GameRules:IsDaytime() then self.nGameTime = EF_DAYTIME else self.nGameTime = EF_NIGHTTIME end 

		if self:GetStackCount() < self.nMaxStacks then
            if self.nGameTime == EF_NIGHTTIME then self:SetStackCount(1) return end 
            
            self:IncrementStackCount()
		end
	end
end

--------------------------------------------------------------------------------
function modifier_superman_kryptonian:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_superman_kryptonian:GetModifierPhysicalArmorBonus (params)
    return self:GetAbility():GetSpecialValueFor("armor_per_stack") * self:GetStackCount()
end

function modifier_superman_kryptonian:GetModifierPreAttack_BonusDamage (params)
    return self:GetAbility():GetSpecialValueFor("damage_per_stack") * self:GetStackCount()
end

function modifier_superman_kryptonian:GetModifierAttackSpeedBonus_Constant (params)
    return self:GetAbility():GetSpecialValueFor("attack_speed_per_stack") * self:GetStackCount()
end
