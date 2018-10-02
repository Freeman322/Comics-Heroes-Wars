if tower_split == nil then tower_split = class({}) end

LinkLuaModifier("tower_split_modifier", "abilities/tower_split.lua", LUA_MODIFIER_MOTION_NONE)

function tower_split:GetIntrinsicModifierName()
  return "tower_split_modifier"
end

function tower_split:OnProjectileHit( hTarget, vLocation )
  if hTarget ~= nil then
    self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true)
  end

  return true
end

if tower_split_modifier == nil then tower_split_modifier = class({}) end

function tower_split_modifier:IsHidden()
  return true
end

function tower_split_modifier:IsPurgable()
  return false
end

function tower_split_modifier:DeclareFunctions ()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_START
  }

  return funcs
end

function tower_split_modifier:OnAttackStart (params)
  if IsServer () then
    if params.attacker == self:GetParent () then
      local caster = self:GetParent()
      local caster_location = caster:GetAbsOrigin()

      if caster:GetTeamNumber() == 3 then
        split_shot_projectile = "particles/base_attacks/ranged_tower_bad.vpcf"
      else
        split_shot_projectile = "particles/base_attacks/ranged_tower_good.vpcf"
      end
      local attack_target = caster:GetAttackTarget()
      local split_shot_targets = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, 850, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			local count = 0
      -- Create projectiles for units that are not the casters current attack target
      for _,v in pairs(split_shot_targets) do
        if v ~= attack_target then
					count = count + 1
					if count >= 5 then
						break
					end
          local projectile_info =
          {
            EffectName = split_shot_projectile,
            Ability = self:GetAbility(),
            vSpawnOrigin = caster_location,
            Target = v,
            Source = caster,
            bHasFrontalCone = false,
            iMoveSpeed = 800,
            bReplaceExisting = false,
            bProvidesVision = false
          }
          ProjectileManager:CreateTrackingProjectile(projectile_info)
        end
        -- If we reached the maximum amount of targets then break the loop
      end
    end
  end

  return 0
end

function tower_split:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

