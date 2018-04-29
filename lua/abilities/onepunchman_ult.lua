onepunchman_ult = class({})
LinkLuaModifier( "modifier_onepunchman_ult", "abilities/onepunchman_ult.lua", LUA_MODIFIER_MOTION_NONE )

function onepunchman_ult:GetIntrinsicModifierName()
    return "modifier_onepunchman_ult"
end

function onepunchman_ult:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_saitama_arcana") then
		return "custom/onepunchman_ult_arcana"
	end
	return "custom/onepunchman_ult"
end

function onepunchman_ult:OnSpellStart()
    if IsServer() then 
      local hTarget = self:GetCursorTarget()
      if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb( self ) ) then
          EmitSoundOn( "Hero_EarthShaker.EchoSlam", hTarget )
          EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", hTarget )
          EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", hTarget )
          EmitSoundOn( "PudgeWarsClassic.echo_slam", hTarget )

          local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/ironfist_iron_strike_ground.vpcf", PATTACH_CUSTOMORIGIN, nil );
          ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetAbsOrigin())
          ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1, 0, 0) )
          ParticleManager:SetParticleControl( nFXIndex, 2, Vector(0, 255, 0) )
          ParticleManager:SetParticleControl( nFXIndex, 3, Vector(0, 0.4, 0) )
          ParticleManager:SetParticleControl( nFXIndex, 11, hTarget:GetAbsOrigin())
          ParticleManager:SetParticleControl( nFXIndex, 12, hTarget:GetAbsOrigin())
          ParticleManager:ReleaseParticleIndex( nFXIndex );

          local damage = {
              victim = hTarget,
              attacker = self:GetCaster(),
              damage = hTarget:GetMaxHealth(),
              damage_type = DAMAGE_TYPE_PURE,
              ability = self,
              damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
          }
          ApplyDamage( damage )

          hTarget:Kill(self, self:GetCaster()) 
        end
      end
    end
end

if modifier_onepunchman_ult == nil then modifier_onepunchman_ult = class({}) end

function modifier_onepunchman_ult:IsPurgable()
  return false
end

function modifier_onepunchman_ult:IsHidden()
  return true
end

function modifier_onepunchman_ult:GetEffectName()
  if self:GetAbility():IsCooldownReady() then 
    return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
  end
  return ""
end

function modifier_onepunchman_ult:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_onepunchman_ult:DeclareFunctions()
  local funcs = {
      MODIFIER_EVENT_ON_ATTACK_LANDED
  }

  return funcs
end

function modifier_onepunchman_ult:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            if (params.target:IsHero() or params.target:IsCreep()) and params.target:IsAncient() == false then 
              if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then 
                local hTarget = params.target

                EmitSoundOn( "Hero_EarthShaker.EchoSlam", hTarget )
                EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", hTarget )
                EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", hTarget )
                EmitSoundOn( "PudgeWarsClassic.echo_slam", hTarget )

                local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/ironfist_iron_strike_ground.vpcf", PATTACH_CUSTOMORIGIN, nil );
                ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetAbsOrigin())
                ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1, 0, 0) )
                ParticleManager:SetParticleControl( nFXIndex, 2, Vector(0, 255, 0) )
                ParticleManager:SetParticleControl( nFXIndex, 3, Vector(0, 0.4, 0) )
                ParticleManager:SetParticleControl( nFXIndex, 11, hTarget:GetAbsOrigin())
                ParticleManager:SetParticleControl( nFXIndex, 12, hTarget:GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex( nFXIndex );

                local damage = {
                    victim = hTarget,
                    attacker = self:GetParent(),
                    damage = hTarget:GetMaxHealth(),
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self:GetAbility(),
                    damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
                }
                ApplyDamage( damage )

                hTarget:Kill(self:GetAbility(), self:GetParent()) 

                self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
                self:GetAbility():PayManaCost()
              end
            end
        end
    end
    return 0
end

