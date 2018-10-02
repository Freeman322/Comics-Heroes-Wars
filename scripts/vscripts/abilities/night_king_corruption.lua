LinkLuaModifier ("modifier_night_king_corruption",           "abilities/night_king_corruption.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_night_king_corruption_reduction", "abilities/night_king_corruption.lua", LUA_MODIFIER_MOTION_NONE)
night_king_corruption = class({})

function night_king_corruption:GetIntrinsicModifierName()
	return "modifier_night_king_corruption"
end

modifier_night_king_corruption = class({})

function modifier_night_king_corruption:IsHidden()
	return true
end

function modifier_night_king_corruption:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACK_START
    }

    return funcs
end

function modifier_night_king_corruption:GetModifierProcAttack_BonusDamage_Pure (params)
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end


function modifier_night_king_corruption:OnAttackStart (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_night_king_corruption_reduction", {duration = 7})
        end
    end

    return 0
end

modifier_night_king_corruption_reduction = class({})

function modifier_night_king_corruption_reduction:OnCreated(ht)
    if IsServer() then
        self.armor = (armor*self:GetAbility():GetSpecialValueFor("armor_reduction"))
        if self:GetParent():IsBuilding() then
            self.armor = self.armor / 2
        end
    end
end

function modifier_night_king_corruption_reduction:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_night_king_corruption_reduction:GetModifierPhysicalArmorBonus (params)
    return self.armor
end

function night_king_corruption:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

