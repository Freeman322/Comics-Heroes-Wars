LinkLuaModifier("modifier_flash_speedforce_power", "abilities/flash_speedforce_power.lua", 0)
LinkLuaModifier("modifier_flash_speedforce_power_debuff", "abilities/flash_speedforce_power.lua", 0)

flash_speedforce_power = class({
    GetIntrinsicModifierName = function() return "modifier_dark_seer_surge" end
})

function flash_speedforce_power:OnSpellStart() if IsServer() then self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_flash_speedforce_power", {duration = self:GetSpecialValueFor("duration")}) end end

modifier_flash_speedforce_power = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end,
    IsDebuff = function() return false end,
    IsAura = function() return true end,
    GetModifierAura = function() return "modifier_flash_speedforce_power_debuff" end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
})

modifier_flash_speedforce_power.buff = 0
modifier_flash_speedforce_power.ms = 0

function modifier_flash_speedforce_power:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function modifier_flash_speedforce_power:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function modifier_flash_speedforce_power:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_flash_speedforce_power:GetAuraDuration() return self:GetRemainingTime() end

function modifier_flash_speedforce_power:GetModifierPreAttack_BonusDamage() return self:GetCaster():GetIdealSpeed() / 100 * self:GetAbility():GetSpecialValueFor("speed_to_damage_pct") end
function modifier_flash_speedforce_power:GetModifierAttackSpeedBonus_Constant() return self:GetCaster():GetIdealSpeed() / 100 * self:GetAbility():GetSpecialValueFor("speed_to_attack_speed_pct") end

function modifier_flash_speedforce_power:OnCreated()
    modifier_flash_speedforce_power.ms = self:GetParent():GetIdealSpeed()

    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
  		self:AddParticle(nFXIndex, false, false, -1, false, true)

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "flash_custom") == true then
            local nFXIndex = ParticleManager:CreateParticle("particles/hero_flash/flash_custom_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            self:AddParticle(nFXIndex, false, false, -1, false, true)
        end
  	end

    EmitSoundOn("DOTA_Item.Mjollnir.Loop", self:GetCaster())
end

function modifier_flash_speedforce_power:OnDestroy() modifier_flash_speedforce_power.buff = 0 StopSoundOn("DOTA_Item.Mjollnir.Loop", self:GetCaster()) end
function modifier_flash_speedforce_power:GetModifierMoveSpeedBonus_Constant() return modifier_flash_speedforce_power.buff * self:GetAbility():GetSpecialValueFor("movespeed_steal") end
function modifier_flash_speedforce_power:GetModifierMoveSpeed_Absolute() return modifier_flash_speedforce_power.ms + modifier_flash_speedforce_power.buff end

modifier_flash_speedforce_power_debuff = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    IsDebuff = function() return true end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
})

function modifier_flash_speedforce_power_debuff:OnCreated() self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("movespeed_steal_interval")) end
function modifier_flash_speedforce_power_debuff:OnDestroy() modifier_flash_speedforce_power.buff = 0 end
function modifier_flash_speedforce_power_debuff:OnIntervalThink()
    local distance = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()
    if not self:GetParent():IsMagicImmune() and distance <= self:GetAbility():GetSpecialValueFor("radius") then
        modifier_flash_speedforce_power.buff = modifier_flash_speedforce_power.buff + 1
    end
end
function modifier_flash_speedforce_power_debuff:GetModifierMoveSpeedBonus_Constant() return modifier_flash_speedforce_power.buff * (self:GetAbility():GetSpecialValueFor("movespeed_steal") * -1) end
