if jons_ancient_call == nil then jons_ancient_call = class({}) end

LinkLuaModifier("modifier_jons_ancient_call", "abilities/jons_ancient_call", LUA_MODIFIER_MOTION_NONE)

function jons_ancient_call:GetIntrinsicModifierName()
  return "modifier_jons_ancient_call"
end

if modifier_jons_ancient_call == nil then modifier_jons_ancient_call = class({}) end

function modifier_jons_ancient_call:IsHidden()
  return false
end

function modifier_jons_ancient_call:IsPurgable()
  return false
end

function modifier_jons_ancient_call:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_jons_ancient_call:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end
      if self:GetAbility():IsCooldownReady() then
        local target = params.target
        if target ~= nil and target:IsBuilding() == false then
					if target:GetUnitName() == "npc_dota_warlock_golem_1" then
						return nil
					end
          local pers = self:GetAbility():GetSpecialValueFor("health_pers")
          if self:GetCaster():HasTalent("special_bonus_unique_jons_2") then
              local value = self:GetCaster():FindTalentValue("special_bonus_unique_jons_2")
              pers = value + pers
          end
          if target:GetHealthPercent() <= self:GetAbility():GetSpecialValueFor("health_pers") then
            EmitSoundOn("Hero_Oracle.FalsePromise.FP", self:GetCaster())
            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop_c.vpcf", PATTACH_CUSTOMORIGIN, target );
        		ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:SetParticleControl( nFXIndex, 2, Vector(100, 100, 100))
            ParticleManager:SetParticleControlEnt( nFXIndex, 10, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
        		ParticleManager:ReleaseParticleIndex( nFXIndex );
            target:Kill(self:GetAbility(), self:GetCaster())
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
          end
        end
      end
		end
	end

	return 0
end

function jons_ancient_call:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

