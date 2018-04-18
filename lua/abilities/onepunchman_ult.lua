onepunchman_ult = class({})

--------------------------------------------------------------------------------
function onepunchman_ult:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end
--------------------------------------------------------------------------------

function onepunchman_ult:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_saitama_arcana") then
		return "custom/onepunchman_ult_arcana"
	end
	return "custom/onepunchman_ult"
end

function onepunchman_ult:OnSpellStart()
    local hTarget = self:GetCursorTarget()
    local target = hTarget
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb( self ) ) then
              local caster = self:GetCaster()
              local ability = self

              if target:HasItemInInventory("item_aegis") then
                  for i=0, 5, 1 do
                      local current_item = target:GetItemInSlot(i)
                      if current_item ~= nil then
                          if current_item:GetName() == "item_aegis" then
                              current_item:RemoveSelf()
                          end
                      end
                  end
              end
              ----target:Purge(true, true, false, false, true)
              if target:HasAbility("skeleton_king_reincarnation_datadriven") then
                  local abil = target:FindAbilityByName("skeleton_king_reincarnation_datadriven")
                  abil:StartCooldown(60)
              end
              
              target:Kill(ability, caster)
              if target:IsAlive() then
                  target:ForceKill(false)
              end
          end
          if self:GetCaster():HasModifier("modifier_saitama_arcana") then
            local nFXIndex = ParticleManager:CreateParticle( "particles/thanos/thanos_supernova_explode_a.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndex, 0, target:GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 1, target:GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 3, target:GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 5, Vector(500, 500, 0));
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            local nFXIndex = ParticleManager:CreateParticle( "particles/hero_saitama/saitama_onepunch_strike.vpcf", PATTACH_WORLDORIGIN, nil )
        		ParticleManager:SetParticleControl( nFXIndex, 0, target:GetOrigin() )
        		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 200, 1, 1 ) )
        		ParticleManager:ReleaseParticleIndex( nFXIndex )
            local knockbackProperties =
            {
                center_x = target:GetAbsOrigin().x,
                center_y = target:GetAbsOrigin().y,
                center_z = target:GetAbsOrigin().z,
                duration = 1,
                knockback_duration = 1,
                knockback_distance = 680,
                knockback_height = 4
            }

            target:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
        	else
            local explosion5 = ParticleManager:CreateParticle("particles/one_punch.vpcf", PATTACH_WORLDORIGIN, target)
            ParticleManager:SetParticleControl(explosion5, 0, target:GetAbsOrigin() + Vector(0, 0, 1))
            ParticleManager:SetParticleControl(explosion5, 1, Vector(1, 1, 1))
            ParticleManager:SetParticleControl(explosion5, 2, Vector(255, 255, 255))
            ParticleManager:SetParticleControl(explosion5, 3, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(explosion5, 5, Vector(200, 200, 0))

            local explosion13 = ParticleManager:CreateParticle("particles/hero_zoom/time_crystal_activate.vpcf", PATTACH_WORLDORIGIN, target)
            ParticleManager:SetParticleControl(explosion13 , 0, target:GetAbsOrigin())
          end
          EmitSoundOn( "Hero_EarthShaker.EchoSlam", hTarget )
          EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", self:GetCaster() )
          EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", hTarget )
          EmitSoundOn( "PudgeWarsClassic.echo_slam", hTarget )
          if self:GetCaster():HasScepter() then
              local damage = self:GetSpecialValueFor("damage_scepter")*0.01
              local Scepters = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 680, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
              for i = 1, #Scepters do
                  local target = Scepters[i]
                  EmitSoundOn( "Hero_Magnataur.ReversePolarity.Stun", target )
                  ApplyDamage({victim = target, attacker = self:GetCaster(), damage = hTarget:GetMaxHealth()*damage, damage_type = DAMAGE_TYPE_PURE})
              end
          end
      end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function onepunchman_ult:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

