wolverine_enrage = class({})
LinkLuaModifier( "modifier_wolverine_enrage", "abilities/wolverine_enrage.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function wolverine_enrage:OnSpellStart()
     if IsServer() then
          local duration = self:GetSpecialValueFor(  "duration" )

          if self:GetCaster():HasTalent("special_bonus_unique_wolverine_1") then duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_wolverine_1") end 
          
          self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_wolverine_enrage", { duration = duration } )

          local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal_cast_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
          ParticleManager:ReleaseParticleIndex( nFXIndex )
     
          EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )
     
          self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
     end 
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if modifier_wolverine_enrage == nil then modifier_wolverine_enrage = class({}) end

--------------------------------------------------------------------------------

function modifier_wolverine_enrage:IsHidden()
     return true
end
  
function modifier_wolverine_enrage:IsPurgable()
     return false
end

function modifier_wolverine_enrage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_wolverine_enrage:GetEffectName()
     return "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
end

function modifier_wolverine_enrage:GetEffectAttachType()
     return PATTACH_ABSORIGIN_FOLLOW
end
--------------------------------------------------------------------------------

function modifier_wolverine_enrage:GetModifierIncomingDamage_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("damage_reduction_ptc")
end

function modifier_wolverine_enrage:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end

function modifier_wolverine_enrage:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("move_speed_ptc")
end

function modifier_wolverine_enrage:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

