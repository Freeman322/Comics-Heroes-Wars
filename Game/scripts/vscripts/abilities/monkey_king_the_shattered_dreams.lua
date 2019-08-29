LinkLuaModifier("modifier_monkey_king_the_shattered_dreams", "abilities/monkey_king_the_shattered_dreams.lua", LUA_MODIFIER_MOTION_NONE)

if monkey_king_the_shattered_dreams == nil then monkey_king_the_shattered_dreams = class({}) end

function monkey_king_the_shattered_dreams:GetCastAnimation( )
  return ACT_DOTA_CAST_ABILITY_4
end

function monkey_king_the_shattered_dreams:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "cooldown_scepter" )
	end

	return self.BaseClass.GetCooldown( self, nLevel )
end

function monkey_king_the_shattered_dreams:GetManaCost( hTarget )
	if 	self:GetCaster():HasScepter() then
			return 0
	end
  return self.BaseClass.GetManaCost( self, hTarget )
end

function monkey_king_the_shattered_dreams:GetConceptRecipientType()
  return DOTA_SPEECH_USER_ALL
end

function monkey_king_the_shattered_dreams:SpeakTrigger()
  return DOTA_ABILITY_SPEAK_CAST
end

function monkey_king_the_shattered_dreams:GetIntrinsicModifierName()
	return "modifier_monkey_king_the_shattered_dreams"
end


if modifier_monkey_king_the_shattered_dreams == nil then modifier_monkey_king_the_shattered_dreams = class({}) end

function modifier_monkey_king_the_shattered_dreams:IsHidden()
	return true
end

function modifier_monkey_king_the_shattered_dreams:IsPurgable()
	return false
end

function modifier_monkey_king_the_shattered_dreams:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_monkey_king_the_shattered_dreams:OnCreated(params)
end

function modifier_monkey_king_the_shattered_dreams:OnAttackLanded(params)
  if IsServer() then
  	if params.attacker == self:GetParent() then
      if self:GetAbility():IsCooldownReady() and self:GetParent():GetMana() >= self:GetAbility():GetManaCost(self:GetAbility():GetLevel()) then
        if RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) and self:GetParent():IsRealHero() then 
          self:DoWidghAttack(self:GetParent(), params.target, params.damage)
          self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
          self:GetAbility():PayManaCost()
        end
      end
  	end
  end
end

function modifier_monkey_king_the_shattered_dreams:DoWidghAttack(caster, target, damage)
  local particle = "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pur_immortal_cast.vpcf"
  local target_teams = self:GetAbility():GetAbilityTargetTeam()
  local target_types = self:GetAbility():GetAbilityTargetType()
  local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
  local unit_table = FindUnitsInLine(caster:GetTeamNumber(), target:GetAbsOrigin(), (caster:GetAbsOrigin() + caster:GetForwardVector() * self:GetAbility():GetSpecialValueFor("range")), nil, self:GetAbility():GetSpecialValueFor("width"), target_teams, target_types, target_flags)
  if #unit_table == 0 then
      return
  end

  local start_pos = caster:GetAbsOrigin()

  for index, unit in pairs(unit_table) do
    unit.dest = ( start_pos - unit:GetAbsOrigin() ):Length2D()
  end

  table.sort(unit_table,
  function(i, j)
      if i.dest < j.dest then
          return true
      else
          return false
      end
  end)

  for index, unit in pairs(unit_table) do
    local next_target = unit_table[index + 1]

    EmitSoundOn("DOTA_Item.MKB.Minibash", unit)
    EmitSoundOn("DOTA_Item.MKB.Minibash", unit)
    EmitSoundOn("Hero_MonkeyKing.IronCudgel", unit)
    EmitSoundOn( "Hero_Juggernaut.OmniSlash.Damage", unit )

    unit:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration = 1.5})

    ApplyDamage( {attacker = caster, victim = unit, ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_PHYSICAL} )
    self:GetCaster():PerformAttack (unit, false, false, true, true, false, false, true)
    self:GetCaster():PerformAttack (unit, false, false, true, true, false, false, true)

    if next_target and unit and not unit:IsNull() and not next_target:IsNull() then
      local nFXIndex = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, nil );
  		ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
  		ParticleManager:SetParticleControlEnt( nFXIndex, 1, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetOrigin(), true );
  		ParticleManager:ReleaseParticleIndex( nFXIndex );
    end
  end

end

function monkey_king_the_shattered_dreams:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

