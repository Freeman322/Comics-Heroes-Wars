LinkLuaModifier ("modifier_doomsday_orb", "abilities/doomsday_orb.lua", LUA_MODIFIER_MOTION_NONE)

doomsday_orb = class({})

function doomsday_orb:GetIntrinsicModifierName()
	return "modifier_doomsday_orb"
end

modifier_doomsday_orb = class({})

function modifier_doomsday_orb:IsHidden()
	return true
end

function modifier_doomsday_orb:IsPurgable()
	return false
end

function modifier_doomsday_orb:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACK_START
    }
    return funcs
end

function modifier_doomsday_orb:GetModifierProcAttack_BonusDamage_Pure(params)
 	if self.bonus_damage == nil then
 		self.bonus_damage = 0
 	end
    return self.bonus_damage
end


function modifier_doomsday_orb:OnAttackStart(params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            self.bonus_damage = self:GetParent():GetHealth()*(self:GetAbility():GetSpecialValueFor("damage_pct_fake")/100)
            if target:IsBuilding() then
            	self.bonus_damage = 0
            end
        end
    end

    return 0
end

function doomsday_orb:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

