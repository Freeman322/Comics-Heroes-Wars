LinkLuaModifier("modifier_cosmos_cosmos_power", "abilities/cosmos_cosmos_power.lua", 0)
LinkLuaModifier("modifier_cosmos_cosmos_power_target", "abilities/cosmos_cosmos_power.lua", 0)

cosmos_cosmos_power = class({
    GetIntrinsicModifierName = function() return "modifier_cosmos_cosmos_power" end,
    GetConceptRecipientType = function() return DOTA_SPEECH_USER_ALL end,
    SpeakTrigger = function() return DOTA_ABILITY_SPEAK_CAST end,
    IsStealable = function() return false end
})

function cosmos_cosmos_power:GetManaCost(iLevel) return self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("mana_pool_damage_pct") / 100) end
function cosmos_cosmos_power:GetCooldown(nLevel) return IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_cosmos_1") or self.BaseClass.GetCooldown(self, nLevel) end
function cosmos_cosmos_power:OnProjectileHit(hTarget, vLocation)
    if hTarget ~= nil and not (hTarget:IsInvulnerable() or hTarget:TriggerSpellAbsorb(self) or hTarget:IsMagicImmune()) then

        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_cosmos_cosmos_power_target", {duration = self:GetSpecialValueFor("warp_duration" )})

        ApplyDamage({
  			victim = hTarget,
  			attacker = self:GetCaster(),
  			damage =  self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("mana_pool_damage_pct") / 100),
  			damage_type = DAMAGE_TYPE_PURE,
  			ability = self
  		})

        EmitSoundOn( "Hero_Lich.IceAge.Damage", hTarget )
	end

	return true
end

modifier_cosmos_cosmos_power = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_START, MODIFIER_EVENT_ON_ORDER} end
})
function modifier_cosmos_cosmos_power:OnCreated() self.power = false end
function modifier_cosmos_cosmos_power:OnAttackStart (params)
    if not IsServer () then return end
    if params.attacker == self:GetParent() and (self:GetAbility():GetAutoCastState() or self.power) and self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() and not (params.target:IsMagicImmune() or params.target:IsBuilding()) then
        ProjectileManager:CreateTrackingProjectile({
            EffectName = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf",
            Ability = self:GetAbility(),
            iMoveSpeed = self:GetCaster():GetProjectileSpeed(),
            Source = self:GetCaster(),
            Target = params.target,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
        })
        EmitSoundOn("Hero_Abaddon.Curse.Proc", self:GetCaster())

        self:GetAbility():UseResources(true, false, true)
        
        self.power = false
    end
 end
function modifier_cosmos_cosmos_power:OnOrder(params)
    if params.unit == self:GetParent() then
        if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and params.ability:GetName() == self:GetAbility():GetName() then
            self.power = true
        else
            self.power = false
        end
    end
end

modifier_cosmos_cosmos_power_target = class({
    GetEffectName = function() return "particles/items4_fx/meteor_hammer_spell_debuff.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_DISABLE_HEALING, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
    GetDisableHealing = function() return 1 end
})
function modifier_cosmos_cosmos_power_target:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("slowing") end
