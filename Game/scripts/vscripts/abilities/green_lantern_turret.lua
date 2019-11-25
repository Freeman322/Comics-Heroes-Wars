LinkLuaModifier("modifier_gl_turret", "abilities/green_lantern_turret.lua", LUA_MODIFIER_MOTION_NONE)

green_lantern_turret = class({})

function green_lantern_turret:OnSpellStart()
    local unit = CreateUnitByName("npc_dota_gl_turret", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeam())
    unit:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
    unit:AddNewModifier(self:GetCaster(), self, "modifier_gl_turret", {duration = self:GetSpecialValueFor("turret_duration")})
    unit:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self:GetSpecialValueFor("turret_duration")})

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "scarlett") then
        unit:SetRangedProjectileName("particles/econ/items/witch_doctor/witch_doctor_ribbitar/witch_doctor_ribbitar_ward_attack.vpcf")
    end

    FindClearSpaceForUnit(unit, self:GetCursorPosition(), true)
    EmitSoundOn("Hero_Sven.StormBolt", self:GetCaster())
end

modifier_gl_turret = class({})

function modifier_gl_turret:IsHidden() return true end
function modifier_gl_turret:IsPurgable() return false end

function modifier_gl_turret:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_gl_turret:GetModifierExtraHealthBonus()
    return (self:GetAbility():GetSpecialValueFor("turret_base_health") - 10) + (self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("health_by_str") / 100)
end

function modifier_gl_turret:GetModifierBaseAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("turret_damage") + (self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor("damage_by_int") / 100)
end

function modifier_gl_turret:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("attack_speed") + (self:GetCaster():GetAgility() *self:GetAbility():GetSpecialValueFor("AS_by_agi") / 100)
end
