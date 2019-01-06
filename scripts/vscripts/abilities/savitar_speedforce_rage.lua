if savitar_speedforce_rage == nil then savitar_speedforce_rage = class({}) end

LinkLuaModifier( "modifier_savitar_speedforce_rage", "abilities/savitar_speedforce_rage.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_savitar_speedforce_rage_talent", "abilities/savitar_speedforce_rage.lua", LUA_MODIFIER_MOTION_NONE )

function savitar_speedforce_rage:GetIntrinsicModifierName()
  if self:GetCaster():HasModifier("modifier_savitar_speedforce_rage_talent") then return "modifier_savitar_speedforce_rage" end 
  return
end

function savitar_speedforce_rage:GetBehavior()
    if self:GetCaster():HasModifier("modifier_savitar_speedforce_rage_talent") then
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function savitar_speedforce_rage:OnSpellStart()
  if IsServer() then 
    if not self:GetCaster():HasTalent("special_bonus_savitar_1") then self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_savitar_speedforce_rage", { duration = self:GetSpecialValueFor("duration") } ) end
    if self:GetCaster():HasTalent("special_bonus_savitar_1") then self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_savitar_speedforce_rage", nil ) end
    
    EmitSoundOn( "Savitar.Ult.Cast", self:GetCaster() )

    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_cast_moonfall.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() );
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin());
    ParticleManager:ReleaseParticleIndex( nFXIndex );

    if self:GetCaster():HasTalent("special_bonus_savitar_1") then self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_savitar_speedforce_rage_talent", nil) end 
  end 
end

if modifier_savitar_speedforce_rage == nil then modifier_savitar_speedforce_rage = class({}) end

function modifier_savitar_speedforce_rage:IsHidden()
  return false
end

function modifier_savitar_speedforce_rage:IsPurgable()
  return false
end

function modifier_savitar_speedforce_rage:GetPriority()
  return MODIFIER_PRIORITY_ULTRA
end

function modifier_savitar_speedforce_rage:GetEffectName()
  return "particles/hero_savitar/savitar_speedforce_rage.vpcf"
end

function modifier_savitar_speedforce_rage:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_savitar_speedforce_rage:DeclareFunctions ()
  local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }

  return funcs
end

function modifier_savitar_speedforce_rage:GetModifierMoveSpeed_Limit()
	return 10000
end

function modifier_savitar_speedforce_rage:GetModifierPreAttack_BonusDamage( params )
  return self:GetStackCount()
end

function modifier_savitar_speedforce_rage:GetModifierConstantHealthRegen( params )
  return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_savitar_speedforce_rage:GetModifierMoveSpeedBonus_Constant(target)
  return self:GetAbility():GetSpecialValueFor("move_speed_bonus")
end

function modifier_savitar_speedforce_rage:OnCreated(params)
  if IsServer() then 
    self:StartIntervalThink(1)
  end 
end

function modifier_savitar_speedforce_rage:OnIntervalThink()
  if IsServer() then 
    self:SetStackCount(math.floor( self:GetParent():GetIdealSpeed() * (self:GetAbility():GetSpecialValueFor("attack_damage_ptc") / 100) ))

    if (not self:GetParent():HasModifier("modifier_dark_seer_surge")) then self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_dark_seer_surge", nil) end 
  end 
end

if not modifier_savitar_speedforce_rage_talent then modifier_savitar_speedforce_rage_talent = class({}) end 
function modifier_savitar_speedforce_rage_talent:IsHidden() return true end
function modifier_savitar_speedforce_rage_talent:IsPurgable() return false end
function modifier_savitar_speedforce_rage_talent:RemoveOnDeath() return false end