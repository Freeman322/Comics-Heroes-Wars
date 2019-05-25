LinkLuaModifier ("modifier_palpatine_armor_weakness", "abilities/palpatine_armor_weakness.lua", LUA_MODIFIER_MOTION_NONE)

palpatine_armor_weakness = class({})

function palpatine_armor_weakness:GetIntrinsicModifierName()
	return "modifier_palpatine_armor_weakness"
end

modifier_palpatine_armor_weakness = class({})

function modifier_palpatine_armor_weakness:IsHidden()
	return true
end

function modifier_palpatine_armor_weakness:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACK_START
    }

    return funcs
end

function modifier_palpatine_armor_weakness:GetModifierProcAttack_BonusDamage_Pure (params)
 	if self.bonus_damage == nil then
 		self.bonus_damage = 0
 	end
    return self.bonus_damage
end


function modifier_palpatine_armor_weakness:OnAttackStart (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            self.bonus_damage = target:GetPhysicalArmorValue( false ) * self:GetAbility():GetSpecialValueFor("damage_mult")
        end
    end

    return 0
end

function palpatine_armor_weakness:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

