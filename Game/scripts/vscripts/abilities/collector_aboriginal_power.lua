if not collector_aboriginal_power then collector_aboriginal_power = class({}) end 

LinkLuaModifier( "modifier_collector_aboriginal_power",	"abilities/collector_aboriginal_power.lua", LUA_MODIFIER_MOTION_NONE )

function collector_aboriginal_power:GetAbilityTextureName()
  return self.BaseClass.GetAbilityTextureName(self)
end

function collector_aboriginal_power:IsStealable()
  return false
end


function collector_aboriginal_power:OnSpellStart ()
  if IsServer() then
    local caster = self:GetCaster ()
    local duration = self:GetOrbSpecialValueFor ("duration", "w")
    local data = { duration = duration, bracers = false }

    if Util:PlayerEquipedItem(caster:GetPlayerOwnerID(), "collector_gloves_of_elder_one") == true then
      data = { duration = duration, bracers = true }
    end

    caster:AddNewModifier (caster, self, "modifier_collector_aboriginal_power", data)
    EmitSoundOn ("Hero_Nevermore.ROS.Arcana", caster)

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "collector_gloves_of_elder_one") then
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin());
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOn("Hero_ChaosKnight.RealityRift.Cast.ti7", self:GetCaster())
        EmitSoundOn("Hero_ChaosKnight.RealityRift.ti7_layer", self:GetCaster())
    end
  end
end


if modifier_collector_aboriginal_power == nil then
    modifier_collector_aboriginal_power = class ( {})
end

function modifier_collector_aboriginal_power:IsHidden ()
  return false
end

function modifier_collector_aboriginal_power:IsPurgable()
  return false
end

function modifier_collector_aboriginal_power:DeclareFunctions ()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED
  }

  return funcs
end

function modifier_collector_aboriginal_power:OnAttackLanded (params)
  if IsServer () then
    if params.attacker == self:GetParent () then
      if not params.target:IsBuilding() and not params.target:IsAncient() then
        EmitSoundOn("DOTA_Item.EtherealBlade.Target", params.target)
        if self.bBracers then
          EmitSoundOn("Hero_Clinkz.SearingArrows.Impact.Immortal", params.target)
        end
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "collector_gloves_of_elder_one") then
            local target = params.target
            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/antimage/antimage_weapon_basher_ti5/am_basher.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            EmitSoundOn( "Hero_ChaosKnight.ChaosStrike", target )
        end

        local iNtdx = ParticleManager:CreateParticle( "particles/collector/collector_sanity_eclipse_enemy.vpcf", PATTACH_WORLDORIGIN, params.target )
        ParticleManager:ReleaseParticleIndex( iNtdx )

        ApplyDamage({victim = params.target, attacker = self:GetAbility():GetCaster(), damage = (self:GetAbility():GetOrbSpecialValueFor("int_mult","e") / 100) * self:GetCaster():GetIntellect(), damage_type = DAMAGE_TYPE_PURE})
      end
    end
  end

  return 0
end