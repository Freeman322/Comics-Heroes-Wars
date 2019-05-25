LinkLuaModifier("modifier_sam_murasama", "abilities/sam_murasama.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sam_murasama_armor", "abilities/sam_murasama.lua", LUA_MODIFIER_MOTION_NONE)

sam_murasama = class({})

function sam_murasama:GetIntrinsicModifierName() return "modifier_sam_murasama" end

modifier_sam_murasama = class({})

function modifier_sam_murasama:IsHidden() return true end
function modifier_sam_murasama:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_sam_murasama:OnAttackLanded(params)
  if params.attacker == self:GetParent() and params.attacker:IsRealHero() and params.target:GetUnitName() ~= "npc_dota_creature_yaz" and params.target:IsMagicImmune() == false and params.attacker:PassivesDisabled() == false then
    params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sam_murasama_armor", {duration = 0.00001})

    local particle = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_desolation/sf_base_attack_desolation_explosion.vpcf", 0, params.target)
    ParticleManager:SetParticleControl(particle, 3, params.target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
  end
end

modifier_sam_murasama_armor = class({})

function modifier_sam_murasama_armor:IsHidden() return true end
function modifier_sam_murasama_armor:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end

function modifier_sam_murasama_armor:OnCreated()
  if self:GetParent():GetPhysicalArmorValue( false ) > 0 then
    self.armor_red = self:GetParent():GetPhysicalArmorValue( false ) * (self:GetAbility():GetSpecialValueFor("armor_ignor_pct") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_sam_murasama_bonus_ignor") or 0)) / 100 * -1
  end
end

function modifier_sam_murasama_armor:GetModifierPhysicalArmorBonus()  return self.armor_red end
