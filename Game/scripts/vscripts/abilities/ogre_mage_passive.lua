LinkLuaModifier("modifier_ogre_mage_passive", "abilities/ogre_mage_passive.lua", 0)
LinkLuaModifier("modifier_ogre_mage_passive_debuff", "abilities/ogre_mage_passive.lua", 0)

ogre_mage_passive = class({})

function ogre_mage_passive:GetIntrinsicModifierName() return "modifier_ogre_mage_passive" end

modifier_ogre_mage_passive = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end
})

function modifier_ogre_mage_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_ogre_mage_passive:OnTakeDamage(params)
    if IsServer() then
        if params.inflictor and params.attacker == self:GetParent() and params.unit:IsMagicImmune() == false and params.unit:IsBuilding() == false and params.unit:HasModifier("modifier_ogre_mage_passive_debuff") == false and params.inflictor:IsItem() == false and params.inflictor ~= nil then
            params.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ogre_mage_passive_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
        end
    end
end

modifier_ogre_mage_passive_debuff = class({
    IsHidden = function() return false end,
    IsPurgable = function() return true end,
    IsDebuff = function() return true end
})

if IsServer() then
    function modifier_ogre_mage_passive_debuff:OnCreated() self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_interval")) end
    function modifier_ogre_mage_passive_debuff:OnIntervalThink() ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = (self:GetParent():GetMaxHealth() * self:GetAbility():GetSpecialValueFor("damage_per_second") / 100) / 10, damage_type = self:GetAbility():GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, ability = self:GetAbility()}) end
end

function modifier_ogre_mage_passive_debuff:GetEffectName() return "particles/ogre_mage_passive_debuff.vpcf" end
function modifier_ogre_mage_passive_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
