LinkLuaModifier ("modifier_thanos_battle_hunger", "abilities/thanos_battle_hunger.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_thanos_battle_hunger_caster", "abilities/thanos_battle_hunger.lua", LUA_MODIFIER_MOTION_NONE)

thanos_battle_hunger = class({})

function thanos_battle_hunger:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function thanos_battle_hunger:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_thanos_golden_timebreaker") then
		return "custom/thanos_battle_hunger_immortal"
	end
	return "custom/thanos_battle_hunger"
end


function thanos_battle_hunger:OnSpellStart ()
    local point = self:GetCursorPosition ()
    local caster = self:GetCaster ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor("duration")

    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
  	if #units > 0 then
  		for _, unit in pairs(units) do
  			unit:AddNewModifier( self:GetCaster(), self, "modifier_thanos_battle_hunger", { duration = duration } )
  		end
  	end
    caster:AddNewModifier( self:GetCaster(), self, "modifier_thanos_battle_hunger_caster", { duration = duration } )
end

function thanos_battle_hunger:GetAOERadius ()
    return self:GetSpecialValueFor ("radius")
end

modifier_thanos_battle_hunger = class ( {})

function modifier_thanos_battle_hunger:OnCreated (event)
    if IsServer() then
        local caster = self:GetCaster()
        local order_target =
      	{
      		UnitIndex = self:GetParent():entindex(),
      		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
      		TargetIndex = caster:entindex()
      	}
        self:GetParent():Stop()
      	ExecuteOrderFromTable(order_target)
      	self:GetParent():SetForceAttackTarget(caster)
    end
end

function modifier_thanos_battle_hunger:OnDestroy(args)
  if IsServer() then
      self:GetParent():Stop()
      self:GetParent():SetForceAttackTarget(nil)
  end
end

function modifier_thanos_battle_hunger:IsPurgable()
	return false
end


function modifier_thanos_battle_hunger:CheckState()
    return {
      [MODIFIER_STATE_COMMAND_RESTRICTED] = true
    }
end

function modifier_thanos_battle_hunger:GetStatusEffectName()
	return "particles/status_fx/status_effect_doom.vpcf"
end

function modifier_thanos_battle_hunger:StatusEffectPriority()
	return 1000
end


modifier_thanos_battle_hunger_caster = class({})

function modifier_thanos_battle_hunger_caster:OnCreated (event)
    if IsServer() then
      local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", PATTACH_CUSTOMORIGIN, nil );
      ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin());
      ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin());
      ParticleManager:SetParticleControl( nFXIndex, 2, self:GetCaster():GetOrigin());
      ParticleManager:ReleaseParticleIndex( nFXIndex );

      EmitSoundOn( "Hero_Axe.BerserkersCall.Item.Shoutmask", self:GetCaster() )
      if self:GetCaster():HasModifier("modifier_thanos_golden_timebreaker") then
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/lifestealer/lifestealer_immortal_backbone_gold/lifestealer_immortal_backbone_gold_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    		self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse.Cast", self:GetCaster() )
        EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse", self:GetCaster() )
        EmitSoundOn( "Hero_ObsidianDestroyer.AstralImprisonment.End", self:GetCaster() )
    	end
    end
end

function modifier_thanos_battle_hunger_caster:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
	return funcs
end

function modifier_thanos_battle_hunger_caster:IsHidden()
	return true
end

function modifier_thanos_battle_hunger_caster:IsPurgable()
	return false
end

function modifier_thanos_battle_hunger_caster:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_thanos_battle_hunger_caster:GetStatusEffectName()
	return "particles/status_fx/status_effect_phoenix_burning.vpcf"
end

function modifier_thanos_battle_hunger_caster:StatusEffectPriority()
	return 1000
end

function thanos_battle_hunger:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

