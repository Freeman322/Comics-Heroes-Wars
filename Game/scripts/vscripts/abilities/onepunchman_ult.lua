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

                if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "kama_bullet") then
                    EmitSoundOn( "Kama.CastUlti", self:GetCaster() )
                end

                local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/ironfist_iron_strike_ground.vpcf", PATTACH_CUSTOMORIGIN, nil );
                ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetAbsOrigin())
                ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1, 0, 0) )
                ParticleManager:SetParticleControl( nFXIndex, 2, Vector(0, 255, 0) )
                ParticleManager:SetParticleControl( nFXIndex, 3, Vector(0, 0.4, 0) )
                ParticleManager:SetParticleControl( nFXIndex, 11, hTarget:GetAbsOrigin())
                ParticleManager:SetParticleControl( nFXIndex, 12, hTarget:GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex( nFXIndex );

                ApplyDamage({
                    victim = hTarget,
                    attacker = self:GetCaster(),
                    ability = self,
                    damage = 99999999,
                    damage_type = self:GetAbilityDamageType()
                })
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
  return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
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

                    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "kama_bullet") then
                        EmitSoundOn( "Kama.CastUlti", self:GetCaster() )
                    end

                    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/ironfist_iron_strike_ground.vpcf", PATTACH_CUSTOMORIGIN, nil );
                    ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetAbsOrigin())
                    ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1, 0, 0) )
                    ParticleManager:SetParticleControl( nFXIndex, 2, Vector(0, 255, 0) )
                    ParticleManager:SetParticleControl( nFXIndex, 3, Vector(0, 0.4, 0) )
                    ParticleManager:SetParticleControl( nFXIndex, 11, hTarget:GetAbsOrigin())
                    ParticleManager:SetParticleControl( nFXIndex, 12, hTarget:GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex( nFXIndex );

                    ApplyDamage({
                        victim = hTarget,
                        attacker = self:GetCaster(),
                        ability = self:GetAbility(),
                        damage = 99999999,
                        damage_type = self:GetAbility():GetAbilityDamageType()
                    })

                    self:GetAbility():UseResources(true, false, true)
                end
            end
        end
    end
    return 0
end

