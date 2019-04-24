LinkLuaModifier ("modifier_raiden_electro_field", 				"abilities/raiden_electro_field.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_raiden_electro_field_passive", "abilities/raiden_electro_field.lua", LUA_MODIFIER_MOTION_NONE)

local CONST_DAMAGE_INTERVAL = 0.25

raiden_electro_field = class ({})

function raiden_electro_field:GetIntrinsicModifierName() return "modifier_raiden_electro_field" end

modifier_raiden_electro_field = class({})

function modifier_raiden_electro_field:IsAura() return true end
function modifier_raiden_electro_field:IsHidden() return true end
function modifier_raiden_electro_field:IsPurgable()	return true end
function modifier_raiden_electro_field:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_raiden_electro_field:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_raiden_electro_field:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_raiden_electro_field:GetAuraSearchFlags()	return 0 end
function modifier_raiden_electro_field:GetModifierAura() return "modifier_raiden_electro_field_passive" end

modifier_raiden_electro_field_passive = class({})

function modifier_raiden_electro_field_passive:IsPurgable() return false end

function modifier_raiden_electro_field_passive:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(CONST_DAMAGE_INTERVAL)
    end 
end

function modifier_raiden_electro_field_passive:OnIntervalThink()
    if IsServer() then 
        local damage = self:GetAbility():GetAbilityDamage()

        if self:GetCaster():HasTalent("special_bonus_unique_raiden_1") then
            damage = damage + self:GetAbility():GetCaster():FindTalentValue("special_bonus_unique_raiden_1")
        end 

        ApplyDamage({
            attacker = self:GetCaster(),
            victim = self:GetParent(),
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(),
            damage = damage
        })
    end 
end 