hulk_passive = class({})

LinkLuaModifier( "modifier_hulk_passive", "abilities/hulk_passive.lua",LUA_MODIFIER_MOTION_NONE )

function hulk_passive:GetIntrinsicModifierName()
	return "modifier_hulk_passive"
end

modifier_hulk_passive = class({})

function modifier_hulk_passive:IsHidden()
  return true
end

function modifier_hulk_passive:IsPurgable()
  return false
end

function modifier_hulk_passive:DeclareFunctions()
	local funcs = {
      MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_hulk_passive:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() and params.attacker:IsRealHero() then
            if self:GetAbility():IsCooldownReady() and RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
              local hTarget = params.target
              EmitSoundOn( "Hero_Slardar.Bash", hTarget )

              local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_CUSTOMORIGIN, nil );
              ParticleManager:SetParticleControlEnt(nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
              ParticleManager:ReleaseParticleIndex( nFXIndex );

              local damage = {
                  victim = hTarget,
                  attacker = self:GetParent(),
                  damage = self:GetAbility():GetSpecialValueFor("bonus_damage"),
                  damage_type = DAMAGE_TYPE_PHYSICAL,
                  ability = self:GetAbility(),
              }
            
              local knockbackProperties =
              {
                  center_x = hTarget:GetAbsOrigin().x,
                  center_y = hTarget:GetAbsOrigin().y,
                  center_z = hTarget:GetAbsOrigin().z,
                  duration = self:GetAbility():GetSpecialValueFor("duration"),
                  knockback_duration = self:GetAbility():GetSpecialValueFor("duration"),
                  knockback_distance = 300,
                  knockback_height = 200
              }

              hTarget:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )

              ApplyDamage( damage )
              
              self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
            end
        end
    end
    return 0
end
