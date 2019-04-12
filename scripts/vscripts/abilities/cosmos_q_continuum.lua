LinkLuaModifier( "cosmos_q_continuum_thinker", "abilities/cosmos_q_continuum.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "cosmos_q_continuum_modifier", "abilities/cosmos_q_continuum.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

cosmos_q_continuum = class ( {})

function cosmos_q_continuum:OnSpellStart()
     if IsServer() then
          local caster = self:GetCaster()
          local point = self:GetCursorPosition()
          local team_id = caster:GetTeamNumber()

          local thinker = CreateModifierThinker(caster, self, "cosmos_q_continuum_thinker", {duration = self:GetSpecialValueFor("duration")}, point, team_id, false)
     end
end

cosmos_q_continuum_thinker = class ({})

function cosmos_q_continuum_thinker:OnCreated(event)
     if IsServer() then
          local nWarpFX = ParticleManager:CreateParticle ("particles/effects/charity_warp.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
          ParticleManager:SetParticleControl(nWarpFX, 0, self:GetParent():GetAbsOrigin())
          ParticleManager:SetParticleControl(nWarpFX, 1, self:GetParent():GetAbsOrigin())
          ParticleManager:SetParticleControl(nWarpFX, 3, self:GetParent():GetAbsOrigin())
          self:AddParticle( nWarpFX, false, false, -1, false, true )

          EmitSoundOn("Hero_ShadowDemon.Disruption.Cast", self:GetParent())
     end
end

function cosmos_q_continuum_thinker:OnDestroy()
     if IsServer() then

     end
end

function cosmos_q_continuum_thinker:CheckState() return {[MODIFIER_STATE_PROVIDES_VISION] = true} end
function cosmos_q_continuum_thinker:IsAura() return true end
function cosmos_q_continuum_thinker:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function cosmos_q_continuum_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function cosmos_q_continuum_thinker:GetAuraSearchType()  return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function cosmos_q_continuum_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS end
function cosmos_q_continuum_thinker:GetModifierAura() return "cosmos_q_continuum_modifier" end

cosmos_q_continuum_modifier = class ( {})

function cosmos_q_continuum_modifier:IsDebuff() return true end

function cosmos_q_continuum_modifier:OnCreated(event)
    self:StartIntervalThink(1)
    self:OnIntervalThink()
end

function cosmos_q_continuum_modifier:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("movespeed_slow_pct") * -1 end
function cosmos_q_continuum_modifier:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("attackspeed_slow") * -1 end
function cosmos_q_continuum_modifier:GetEffectName() return "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_debuff_arcana.vpcf" end
function cosmos_q_continuum_modifier:GetEffectAttachType() return PATTACH_POINT_FOLLOW end
function cosmos_q_continuum_modifier:DeclareFunctions() return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT } end

function cosmos_q_continuum_modifier:OnIntervalThink()
     if IsServer() then
          local damage = self:GetAbility():GetSpecialValueFor("damage")
          if self:GetCaster():HasTalent("special_bonus_unique_cosmos_3") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_cosmos_3") end

          ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
     end
end
