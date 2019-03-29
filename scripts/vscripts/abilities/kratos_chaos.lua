kratos_chaos = class({})
LinkLuaModifier( "modifier_kratos_chaos", "abilities/kratos_chaos.lua", LUA_MODIFIER_MOTION_NONE )

function kratos_chaos:OnSpellStart()
  if IsServer() then 
    local duration = self:GetSpecialValueFor("duration")
    if self:GetCaster():HasTalent("special_bonus_unique_kratos_1") then duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_kratos_1") or 0) end

    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_kratos_chaos", {duration = duration}  )
  
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_impact_moonfall_gold.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
    ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
    ParticleManager:SetParticleControl( nFXIndex, 5, self:GetCaster():GetOrigin() )
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    EmitSoundOn( "Kratos.Chaos.Cast", self:GetCaster() )
  end 
end

if modifier_kratos_chaos == nil then modifier_kratos_chaos = class({}) end

function modifier_kratos_chaos:IsBuff() return true end
function modifier_kratos_chaos:IsPurgable() return false end
function modifier_kratos_chaos:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
    }

    return funcs
end

function modifier_kratos_chaos:GetModifierProcAttack_BonusDamage_Pure (params)
    if IsServer() then 
        if not params.target:IsBuilding() and not params.target:IsAncient() then
            return params.target:GetHealth() * (self:GetAbility():GetSpecialValueFor("damage_ptc") / 100)
        end 
    end 
end

function modifier_kratos_chaos:CheckState()
  local state = {
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true
  }

  return state
end

function modifier_kratos_chaos:GetStatusEffectName()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end

function modifier_kratos_chaos:StatusEffectPriority()
    return 1000
end

function modifier_kratos_chaos:GetEffectName()
    return "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
end

function modifier_kratos_chaos:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_kratos_chaos:GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetSpecialValueFor("damage_reduction") * (-1)
end

function modifier_kratos_chaos:GetModifierMoveSpeed_Absolute() return 650 end
function modifier_kratos_chaos:GetModifierMoveSpeed_Limit() return 650 end
function modifier_kratos_chaos:GetModifierMoveSpeed_Max() return 650 end
