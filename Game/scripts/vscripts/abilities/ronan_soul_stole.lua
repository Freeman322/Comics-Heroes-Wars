LinkLuaModifier("modifier_ronan_soul_stole", "abilities/ronan_soul_stole.lua", 0)

ronan_soul_stole = class({})

function ronan_soul_stole:OnSpellStart()
  self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ronan_soul_stole", {duration = self:GetSpecialValueFor("duration")})
  EmitSoundOn("Hero_Sven.WarCry", self:GetCaster())
end

modifier_ronan_soul_stole = class({})

function modifier_ronan_soul_stole:OnCreated()
  if IsServer() then
    local particle = ParticleManager:CreateParticle("particles/econ/items/sven/sven_warcry_ti5/sven_warcry_buff_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0 ,self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 3 ,self:GetParent():GetAbsOrigin())
    self:AddParticle(particle, false, false, -1, false, false)
  end
end

function modifier_ronan_soul_stole:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS} end
function modifier_ronan_soul_stole:GetStatusEffectName() return "particles/status_fx/status_effect_gods_strength.vpcf" end
function modifier_ronan_soul_stole:StatusEffectPriority() return 1000 end
function modifier_ronan_soul_stole:GetEffectName() return "particles/items4_fx/nullifier_mute_debuff.vpcf" end
function modifier_ronan_soul_stole:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_ronan_soul_stole:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("armor") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_ronan_1") or 0) end
function modifier_ronan_soul_stole:GetModifierBonusStats_Strength() if self:GetCaster():HasModifier("modifier_item_power_gem") then return self:GetAbility():GetSpecialValueFor("bonus_stats_power_gem") end end
function modifier_ronan_soul_stole:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("movespeed") end
function modifier_ronan_soul_stole:GetModifierDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("damage") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_ronan") or 0) end
