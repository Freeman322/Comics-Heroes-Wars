if franklin_global_retrocausality == nil then franklin_global_retrocausality = class({}) end

LinkLuaModifier( "modifier_franklin_global_retrocausality", "abilities/franklin_global_retrocausality.lua", LUA_MODIFIER_MOTION_NONE )

function franklin_global_retrocausality:IsRefreshable()
   return false
end


function franklin_global_retrocausality:OnSpellStart()
	local duration = self:GetSpecialValueFor(  "tooltip_duration" )

	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
	if #units > 0 then
		for _,unit in pairs(units) do
			unit:AddNewModifier( self:GetCaster(), self, "modifier_franklin_global_retrocausality", { duration = duration } )
		end
	end
  EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse.Cast", self:GetCaster())
end

if modifier_franklin_global_retrocausality == nil then modifier_franklin_global_retrocausality = class({}) end


function modifier_franklin_global_retrocausality:IsPurgable()
    return false
end

function modifier_franklin_global_retrocausality:IsHidden()
    return true
end


function modifier_franklin_global_retrocausality:IsPurgable()
	return false
end

function modifier_franklin_global_retrocausality:RemoveOnDeath()
	return false
end


function modifier_franklin_global_retrocausality:GetStatusEffectName()
	return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end


function modifier_franklin_global_retrocausality:StatusEffectPriority()
	return 1000
end

function modifier_franklin_global_retrocausality:GetHeroEffectName()
	return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

function modifier_franklin_global_retrocausality:HeroEffectPriority()
	return 100
end

function modifier_franklin_global_retrocausality:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_armor_friend_ring.vpcf"
end

function modifier_franklin_global_retrocausality:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_franklin_global_retrocausality:OnCreated(params)
  self.unit_table = {}
	if IsServer() then
    local warp = ParticleManager:CreateParticle("particles/hero_franklin/franklin_global_retrocausality_screen.vpcf", PATTACH_EYES_FOLLOW, self:GetParent())
    self:AddParticle( warp, false, false, -1, false, true )
    self.unit_table.origin = self:GetParent():GetAbsOrigin()
    self.unit_table.hp = self:GetParent():GetHealth()
    self.unit_table.mana = self:GetParent():GetMana()
    self.unit_table.abilities = {}
    for i=0, 15, 1 do
  		local current_ability = self:GetParent():GetAbilityByIndex(i)
      if current_ability ~= nil then
  			self.unit_table.abilities[current_ability] = current_ability:GetCooldownTimeRemaining()
      end
  	end
  end
end

function modifier_franklin_global_retrocausality:OnDestroy()
	if IsServer() then
    EmitSoundOn("Hero_Oracle.FalsePromise.FP", self:GetParent())
    if self.unit_table then
      if self:GetParent():GetHealth() <= 0 then
        self:GetParent():RespawnHero(false, false, true)
      end
      self:GetParent():SetAbsOrigin(self.unit_table.origin)
      self:GetParent():SetHealth(self.unit_table.hp)
      self:GetParent():SetMana(self.unit_table.mana)
      for i=0, 15, 1 do
    		local current_ability = self:GetParent():GetAbilityByIndex(i)
    		if current_ability ~= nil and current_ability:GetAbilityName() ~= "franklin_global_retrocausality" then
          current_ability:EndCooldown()
          if self.unit_table.abilities[current_ability] then
            current_ability:StartCooldown(self.unit_table.abilities[current_ability])
          end
    		end
    	end
    end
  end
end

function franklin_global_retrocausality:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

