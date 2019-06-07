LinkLuaModifier("modifier_sam_bladerun_buff", "abilities/sam_blademode.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sam_bladerun_debuff", "abilities/sam_blademode.lua", LUA_MODIFIER_MOTION_NONE)

sam_blademode = class({})

function sam_blademode:GetCooldown(nLevel)
  return self:GetCaster():HasScepter() and self:GetSpecialValueFor("cooldown_scepter") or self.BaseClass.GetCooldown(self, nLevel)
end

function sam_blademode:OnSpellStart()
  EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", self:GetCaster())
  local duration = self:GetCaster():HasScepter() and self:GetSpecialValueFor("duration_scepter") or self:GetSpecialValueFor("duration")
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sam_bladerun_buff", {duration = duration})
  ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticleForPlayer("particles/sam/sam_blademode_screen.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster():GetOwner()))
end

modifier_sam_bladerun_buff = class({})

function modifier_sam_bladerun_buff:RemoveOnDeath() return true end
function modifier_sam_bladerun_buff:IsDebuff() return false end
function modifier_sam_bladerun_buff:IsAura() return true end
function modifier_sam_bladerun_buff:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_sam_bladerun_buff:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_sam_bladerun_buff:GetAuraSearchFlags() return 0 end
function modifier_sam_bladerun_buff:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("debuff_radius") end
function modifier_sam_bladerun_buff:GetModifierAura() return "modifier_sam_bladerun_debuff" end

function modifier_sam_bladerun_buff:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE} end
function modifier_sam_bladerun_buff:OnAttackLanded(params)
  if params.attacker == self:GetParent() and params.attacker:IsRealHero() and params.target:IsMagicImmune() == false and params.target:IsBuilding() == false then
    local damage = self:GetAbility():GetSpecialValueFor("bonus_proc_damage") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_sam_blademode_bonus_proc_damage") or 0)
    ApplyDamage({victim = params.target, attacker = self:GetParent(), damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
    EmitSoundOn("Ability.static.start", params.target)
  
    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alisa") == true then EmitSoundOn("Alisa.Attack", params.target) end 

    if not params.attacker:PassivesDisabled() then
      self:GetCaster():SetAbsOrigin(Vector(params.target:GetAbsOrigin().x - 100 * math.cos(params.target:GetAnglesAsVector().y * math.pi/180), params.target:GetAbsOrigin().y - 100 * math.sin(params.target:GetAnglesAsVector().y * math.pi/180), 0))
      FindClearSpaceForUnit(self:GetCaster(), Vector(params.target:GetAbsOrigin().x - 100 * math.cos(params.target:GetAnglesAsVector().y * math.pi/180), params.target:GetAbsOrigin().y - 100 * math.sin(params.target:GetAnglesAsVector().y * math.pi/180), 0), true)
      self:GetCaster():SetForwardVector(params.target:GetForwardVector())

      local nFXIndex = ParticleManager:CreateParticle("particles/sam/sam_blademode_blink.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
      ParticleManager:SetParticleControl(nFXIndex, 0, self:GetCaster():GetAbsOrigin())
      ParticleManager:SetParticleControl(nFXIndex, 1, self:GetCaster():GetAbsOrigin())
      ParticleManager:SetParticleControl(nFXIndex, 2, self:GetCaster():GetAbsOrigin())
      ParticleManager:SetParticleControl(nFXIndex, 3, params.target:GetAbsOrigin())
      ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
  end
end
function modifier_sam_bladerun_buff:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("attack_speed_bonus") end
function modifier_sam_bladerun_buff:GetModifierMoveSpeed_Absolute() return self:GetAbility():GetSpecialValueFor("movespeed") end

function modifier_sam_bladerun_buff:OnCreated()
  EmitSoundOn( "Ability.static.loop",self:GetCaster())
  self.radius = self:GetAbility():GetSpecialValueFor("debuff_radius")
  local particle = ParticleManager:CreateParticle("particles/sam/sam_blademode_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
  self:AddParticle(particle, false, false, -1, false, false)
end

function modifier_sam_bladerun_buff:OnDestroy()
  StopSoundOn("Ability.static.loop",self:GetCaster())
end

modifier_sam_bladerun_debuff = class({})

function modifier_sam_bladerun_debuff:IsHidden() return false end
function modifier_sam_bladerun_debuff:IsDebuff() return true end
function modifier_sam_bladerun_debuff:RemoveOnDeath() return true end
function modifier_sam_bladerun_debuff:IsPurgable() return false end
function modifier_sam_bladerun_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_sam_bladerun_debuff:GetModifierTurnRate_Percentage() return self:GetAbility():GetSpecialValueFor("turn_rate_slow_pct") * -1 end
function modifier_sam_bladerun_debuff:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("movespeed_slow_pct") * -1 end
