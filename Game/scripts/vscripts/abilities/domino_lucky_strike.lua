domino_lucky_strike = class ({})

LinkLuaModifier("modifier_domino_lucky_strike", "abilities/domino/domino_lucky_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domino_lucky_strike_armor_reduce", "abilities/domino/domino_lucky_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domino_lucky_strike_passive_disable", "abilities/domino/domino_lucky_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domino_lucky_strike_mute", "abilities/domino/domino_lucky_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domino_lucky_strike_disarm", "abilities/domino/domino_lucky_strike.lua", LUA_MODIFIER_MOTION_NONE)

function domino_lucky_strike:GetIntrinsicModifierName()
    return "modifier_domino_lucky_strike"
end

modifier_domino_lucky_strike = class ({})

function modifier_domino_lucky_strike:IsHidden() return true end
function modifier_domino_lucky_strike:DeclareFunctions()
    local funcs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
    return funcs
end

--[[    ВСЕГО 8 ЭФФЕКТОВ
        стан                        1
        крит                        2
        дизарм                      3
        сало                        4

        мут(запрет итемов)          5
        откл. пассивок              6
        - 20, 35, 50%   армор       7
        хекс                        8
]]

if IsServer() then
function modifier_domino_lucky_strike:OnAttackLanded (params)
    if params.attacker == self:GetParent() then
      self.rand = math.random(1, 8)
      if RollPercentage(self:GetAbility():GetSpecialValueFor("base_chance")) and self:GetAbility():IsCooldownReady() and (not (params.target:IsBuilding() or params.target:IsMagicImmune() or params.target:IsAncient())) then

        if self.rand == 1 then --Стан
          params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
          EmitSoundOn("DOTA_Item.SkullBasher", params.target)


        elseif self.rand == 2 then -- "Крит"
          local damage = {
                  victim = params.target,
                  attacker = self:GetParent(),
                  damage = self:GetParent():GetAverageTrueAttackDamage(target) * (self:GetAbility():GetSpecialValueFor("crit_mult") / 100),
                  damage_type = DAMAGE_TYPE_PHYSICAL
          }
          ApplyDamage(damage)
          EmitSoundOn("DOTA_Item.Daedelus.Crit", params.target)


        elseif self.rand == 3 then -- Дизарм
          params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_domino_lucky_strike_disarm", {duration = self:GetAbility():GetSpecialValueFor("disarm_duration")})
          EmitSoundOn("DOTA_Item.HeavensHalberd.Activate",params.target)


        elseif self.rand == 4 then -- Сало
          params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_silence", {duration = self:GetAbility():GetSpecialValueFor("silence_duration")})
          EmitSoundOn("DOTA_Item.Orchid.Activate", params.target)


        elseif self.rand == 5 then -- Мут
          params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_domino_lucky_strike_mute", {duration = self:GetAbility():GetSpecialValueFor("mute_duration")})
          EmitSoundOn("DOTA_Item.Nullifier.Target", params.target)

        elseif self.rand == 6 then -- Отключение пассивок
          params.target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_domino_lucky_strike_passive_disable",{duration = self:GetAbility():GetSpecialValueFor("passive_off_duration")})
          EmitSoundOn("DOTA_Item.SilverEdge.Target", params.target)

        elseif  self.rand == 7 then -- Снижение брони
          params.target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_domino_lucky_strike_armor_reduce",{duration = self:GetAbility():GetSpecialValueFor("armor_reduce_duration")})

        elseif  self.rand == 8 then -- Хекс
          params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hexxed", {duration = self:GetAbility():GetSpecialValueFor("hex_duration")})
          EmitSoundOn("Hero_Lion.Hex.Target", params.target)

        end

      ---========== Запуск кулдауна ==========---
      self:GetAbility():EndCooldown()
      local cooldown = self:GetAbility():GetSpecialValueFor("cooldown")
      if self:GetCaster():HasTalent("special_bonus_unique_domino_2") then
          self:GetAbility():StartCooldown(self:GetCaster():FindTalentValue("special_bonus_unique_domino_2"))
      else
          self:GetAbility():StartCooldown(cooldown)
      end

      end
    end
end
end

modifier_domino_lucky_strike_passive_disable = class ({})

function modifier_domino_lucky_strike_passive_disable:IsHidden() return true end
function modifier_domino_lucky_strike_passive_disable:CheckState()
  local state = {[MODIFIER_STATE_PASSIVES_DISABLED] = true}
  return state
end

function modifier_domino_lucky_strike_passive_disable:GetEffectName()
  return "particles/items3_fx/silver_edge.vpcf"
end

function modifier_domino_lucky_strike_passive_disable:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

modifier_domino_lucky_strike_armor_reduce = class ({}) --=========== Снижение брони ===========--

function modifier_domino_lucky_strike_armor_reduce:IsHidden() return true end
function modifier_domino_lucky_strike_armor_reduce:DeclareFunctions()
  local funcs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
  return funcs
end

function modifier_domino_lucky_strike_armor_reduce:OnCreated()
  self.armor = self:GetParent():GetPhysicalArmorValue() * (self:GetAbility():GetSpecialValueFor("armor_reduce_pct") / 100) * -1
end
function modifier_domino_lucky_strike_armor_reduce:GetModifierPhysicalArmorBonus()
  return self.armor
end

modifier_domino_lucky_strike_mute = class ({}) --=========== Мут ===========--

function modifier_domino_lucky_strike_mute:IsHidden() return true end

function modifier_domino_lucky_strike_mute:GetEffectName()
  return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end

function modifier_domino_lucky_strike_mute:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_domino_lucky_strike_mute:CheckState()
  local state = {[MODIFIER_STATE_MUTED] = true}
  return state
end

modifier_domino_lucky_strike_disarm = class({})

function modifier_domino_lucky_strike_disarm:IsPurgable() return false end
function modifier_domino_lucky_strike_disarm:IsHidden() return false end

function modifier_domino_lucky_strike_disarm:GetEffectName()
  return "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd.vpcf"
end

function modifier_domino_lucky_strike_disarm:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_domino_lucky_strike_disarm:CheckState()
  local state = {[MODIFIER_STATE_DISARMED] = true}
  return state
end
