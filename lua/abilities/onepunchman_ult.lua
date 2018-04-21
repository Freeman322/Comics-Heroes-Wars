onepunchman_ult = class({})
LinkLuaModifier( "modifier_onepunchman_ult", "abilities/onepunchman_ult.lua", LUA_MODIFIER_MOTION_NONE )

function onepunchman_ult:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function onepunchman_ult:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_saitama_arcana") then
		return "custom/onepunchman_ult_arcana"
	end
	return "custom/onepunchman_ult"
end

function onepunchman_ult:OnSpellStart()
    if IsServer() then 
      self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_onepunchman_ult", nil  )
    end
end

if modifier_onepunchman_ult == nil then modifier_onepunchman_ult = class({}) end

function modifier_onepunchman_ult:IsPurgable()
  return false
end

function modifier_onepunchman_ult:GetEffectName()
  return "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf"
end

function modifier_onepunchman_ult:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_onepunchman_ult:OnCreated( kv )
  if IsServer() then
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/alchemist/alchemist_stove_back/alchemist_stove_back_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2" , self:GetParent():GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2" , self:GetParent():GetOrigin(), true )
    self:AddParticle( nFXIndex, false, false, -1, false, true )

     local nFXIndex2 = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
     self:AddParticle( nFXIndex2, false, false, -1, false, true )
  end
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
                  damage = hTarget:GetMaxHealth() * 100,
                  damage_type = DAMAGE_TYPE_PURE,
                  ability = self:GetAbility(),
                  damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
              }

              ApplyDamage( damage )

              self:Destroy()
            end
        end
    end
    return 0
end

