LinkLuaModifier ("modifier_collector_ult", "abilities/collector_ult.lua", LUA_MODIFIER_MOTION_NONE)
collector_ult = class ( {})

function collector_ult:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end


function collector_ult:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_arcana") then
        return "custom/collector_ult_immortal"
    end
    return self.BaseClass.GetAbilityTextureName(self)
end


function collector_ult:OnSpellStart ()
    if IsServer() then
      local caster = self:GetCaster ()
      local duration = self:GetSpecialValueFor ("duration")
      local data = { duration = duration, bracers = false }
      if Util:PlayerEquipedItem(caster:GetPlayerOwnerID(), "collector_gloves_of_elder_one") == true then
        data = { duration = duration, bracers = true }
      end
      caster:AddNewModifier (caster, self, "modifier_collector_ult", data)
      EmitSoundOn ("Hero_Nevermore.ROS.Arcana", caster)

      if self:GetCaster():HasModifier("modifier_arcana") then
          local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
          ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin());
          ParticleManager:ReleaseParticleIndex( nFXIndex );

          EmitSoundOn("Hero_ChaosKnight.RealityRift.Cast.ti7", self:GetCaster())
          EmitSoundOn("Hero_ChaosKnight.RealityRift.ti7_layer", self:GetCaster())
      end
    end
end

modifier_collector_ult = class ( {})

function modifier_collector_ult:OnCreated( kv )
    self.bBracers = kv.bracers
    if IsServer() then
        if self.bBracers then
          local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
          self:AddParticle( nFXIndex, false, false, -1, false, true )

          EmitSoundOn("Hero_Sylph.WillOWisp", self:GetParent())
        else
          local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
          ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
          self:AddParticle( nFXIndex, false, false, -1, false, true )
        end
    end
end


function modifier_collector_ult:DeclareFunctions()
    return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_collector_ult:OnAttackLanded( params )
    if params.attacker == self:GetParent() then
        if params.target:IsBuilding() then
          return nil
        end
        ApplyDamage({attacker = self:GetParent(), victim = params.target, damage = self:GetParent():GetIntellect()*5, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL})
        EmitSoundOn("DOTA_Item.EtherealBlade.Target", params.target)
        if self.bBracers then
          EmitSoundOn("Hero_Clinkz.SearingArrows.Impact.Immortal", params.target)
        end
        if self:GetCaster():HasModifier("modifier_arcana") then
            local target = params.target
            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/antimage/antimage_weapon_basher_ti5/am_basher.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            EmitSoundOn( "Hero_ChaosKnight.ChaosStrike", target )
        end
    end
end
