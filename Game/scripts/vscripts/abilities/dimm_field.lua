LinkLuaModifier("modifier_dimm_field", "abilities/dimm_field.lua", 0)
LinkLuaModifier("modifier_dimm_field_debuff", "abilities/dimm_field.lua", 0)

dimm_field = class({GetIntrinsicModifierName = function() return "modifier_dimm_field" end})
function dimm_field:OnProjectileHit( hTarget, vLocation )
    if not IsServer() then return end
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_dimm_field_debuff", {duration = self:GetSpecialValueFor("duration")})
    EmitSoundOn("Hero_Lich.ChainFrostImpact.Hero", hTarget)
  return true
end


modifier_dimm_field = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK, MODIFIER_EVENT_ON_ORDER} end
})
function modifier_dimm_field:OnCreated() self.attack = false end

function modifier_dimm_field:OnAttack(params)
    if not IsServer () then return end
    if params.attacker == self:GetParent() and self:GetParent():IsRealHero() and self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() and (self:GetAbility():GetAutoCastState() or self.attack) and not params.target:IsBuilding() then
        ProjectileManager:CreateTrackingProjectile({
            EffectName = "particles/units/heroes/hero_jakiro/jakiro_base_attack.vpcf",
            Ability = self:GetAbility(),
            iMoveSpeed = 1000,
            Source = self:GetCaster(),
            Target = params.target,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
        })
        EmitSoundOn("Ability.DarkRitual", self:GetCaster())
        self:GetAbility():UseResources(true, false, true)
        self.attack = false
    end
end

function modifier_dimm_field:OnOrder(params)
    if params.unit == self:GetParent() then
        if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and params.ability:GetName() == self:GetAbility():GetName() then
            self.attack = true
        else
            self.attack = false
        end
    end
end

modifier_dimm_field_debuff = class({
    IsHidden = function() return false end,
    IsPurgable = function() return true end,
    GetStatusEffectName = function() return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_l2_dire.vpcf" end,
    StatusEffectPriority = function() return 1000 end,
    GetEffectName = function() return "particles/units/heroes/hero_jakiro/jakiro_icepath_debuff.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end
})

function modifier_dimm_field_debuff:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(1)
end
function modifier_dimm_field_debuff:OnIntervalThink()
    if not IsServer() then return end
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        ability = self:GetAbility(),
        damage = self:GetAbility():GetSpecialValueFor("damage") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_dimm_2") or 0),
        damage_type = self:GetAbility():GetAbilityDamageType()
    })
end
function modifier_dimm_field_debuff:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("slowing") * -1 end
