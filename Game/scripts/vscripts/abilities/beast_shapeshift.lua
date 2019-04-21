beast_shapeshift = class({})
LinkLuaModifier( "modifier_beast_shapeshift", "abilities/beast_shapeshift.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beast_shapeshift_passive", "abilities/beast_shapeshift.lua", LUA_MODIFIER_MOTION_NONE )

function beast_shapeshift:GetIntrinsicModifierName ()
    return "modifier_beast_shapeshift_passive"
end

function beast_shapeshift:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )

  self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("transformation_time")}  )
  Timers:CreateTimer(self:GetSpecialValueFor("transformation_time"), function()
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_beast_shapeshift", { duration = duration }  )
  end)

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Lycan.Shapeshift.Cast", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_4 );
end

if modifier_beast_shapeshift == nil then modifier_beast_shapeshift = class({}) end

function modifier_beast_shapeshift:IsBuff()
    return true
end

function modifier_beast_shapeshift:IsPurgable()
    return false
end

function modifier_beast_shapeshift:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }

    return funcs
end

function modifier_beast_shapeshift:GetModifierModelChange(params)
  if self:GetParent():HasModifier("modifier_jiren") then return "models/heroes/hero_marvel/jiren_custom/jiren.vmdl" end 
  return "models/creeps/nian/nian_creep.vmdl"
end

function modifier_beast_shapeshift:GetModifierModelScale(params)
  return -0.4
end

function modifier_beast_shapeshift:GetModifierMoveSpeed_Absolute(params)
  return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_beast_shapeshift:GetModifierMoveSpeed_Limit(params)
  return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_beast_shapeshift:GetModifierMoveSpeed_Max(params)
  return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_beast_shapeshift:OnCreated(params)
  if IsServer() then
    self:StartIntervalThink(0.1) 
  end
end

function modifier_beast_shapeshift:OnIntervalThink()
  if IsServer() then 
    self:GetParent():Purge(false, true, false, true, true)
  end 
end

if modifier_beast_shapeshift_passive == nil then modifier_beast_shapeshift_passive = class({}) end

function modifier_beast_shapeshift_passive:IsBuff()
    return true
end

function modifier_beast_shapeshift_passive:IsPurgable()
    return false
end

function modifier_beast_shapeshift_passive:IsHidden()
    return true
end

function modifier_beast_shapeshift_passive:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
end

function modifier_beast_shapeshift_passive:GetModifierIncomingDamage_Percentage(params)
  return self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function beast_shapeshift:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

