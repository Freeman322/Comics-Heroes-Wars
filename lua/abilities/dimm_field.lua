if dimm_field == nil then dimm_field = class({}) end

LinkLuaModifier( "modifier_dimm_field", "abilities/dimm_field.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dimm_field_thinker", "abilities/dimm_field.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_dimm_field_caster", "abilities/dimm_field.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dimm_field_target", "abilities/dimm_field.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function dimm_field:CastFilterResultTarget( hTarget )
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function dimm_field:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function dimm_field:OnSpellStart()
	self.hTarget = self:GetCursorTarget()
	if self.hTarget ~= nil then
		 CreateModifierThinker (self:GetCaster(), self, "modifier_dimm_field_thinker", {duration = self:GetSpecialValueFor("duration")}, self.hTarget:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	end
  self.hTarget:AddNewModifier(self:GetCaster(), self, "modifier_dimm_field_target", {duration = self:GetSpecialValueFor("duration")})
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_dimm_field_caster", {duration = self:GetSpecialValueFor("duration")})
end

function dimm_field:GetFieldTarget()
	return self.hTarget
end

function dimm_field:GetFieldCaster()
	return self:GetCaster()
end

modifier_dimm_field_thinker = class({})

function modifier_dimm_field_thinker:OnCreated(args)
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.dur = self:GetAbility():GetSpecialValueFor("duration")
    print("RADIUS: " .. tostring(self.radius))
    print("DUR: " .. tostring(self.dur))
    if IsServer () then
        local _particle = ParticleManager:CreateParticle("particles/hero_dimm/dimm_field.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
      	ParticleManager:SetParticleControl(_particle, 0, self:GetParent():GetAbsOrigin())
      	ParticleManager:SetParticleControl(_particle, 1, Vector(self.radius, self.radius, 0))
      	ParticleManager:SetParticleControl(_particle, 2, Vector(self.dur, 0, 0))
        self:StartIntervalThink(0.01)
    end
end

function modifier_dimm_field_thinker:OnIntervalThink ()
    if IsServer () then
        local units = FindUnitsInRadius (self:GetParent ():GetTeamNumber (), self:GetParent ():GetOrigin (), self:GetParent (), self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
        if #units > 0 then
            for _, unit in pairs (units) do
                if unit ~= nil and ( unit:HasModifier("modifier_dimm_field_caster") or unit:HasModifier("modifier_dimm_field_target") ) then
                    local distance = (self:GetParent():GetAbsOrigin() - unit:GetAbsOrigin()):Length2D()
                    print(distance)
                    if distance >= (self.radius - 50) then
                      unit:SetAbsOrigin(self:GetParent():GetAbsOrigin())
                      FindClearSpaceForUnit(unit, self:GetParent():GetAbsOrigin(), true)
                    end
                end
            end
        end
    end
end

modifier_dimm_field_caster = class({})

function modifier_dimm_field_caster:IsHidden()
  return true
end

function modifier_dimm_field_caster:IsPurgable()
  return false
end

function modifier_dimm_field_caster:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end

function modifier_dimm_field_caster:StatusEffectPriority()
	return 1000
end

function modifier_dimm_field_caster:GetHeroEffectName()
	return "particles/frostivus_herofx/juggernaut_fs_omnislash_slashers.vpcf"
end

function modifier_dimm_field_caster:HeroEffectPriority()
	return 100
end

function modifier_dimm_field_caster:DeclareFunctions()
	local funcs = {
      MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end


function modifier_dimm_field_caster:OnTakeDamage(params)
  if IsServer() then
  	if params.unit == self:GetParent() then
	    local target = params.attacker
      if target ~= self:GetAbility():GetFieldTarget() then
          self:GetParent():Heal(params.damage, self:GetParent())
          self:GetParent():Purge(false, true, false, true, false)
      else
      	return
      end
  	end
  end
end

modifier_dimm_field_target = class({})

function modifier_dimm_field_target:IsHidden()
  return true
end

function modifier_dimm_field_target:IsPurgable()
  return false
end

function modifier_dimm_field_target:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end

function modifier_dimm_field_target:StatusEffectPriority()
	return 1000
end

function modifier_dimm_field_target:GetHeroEffectName()
	return "particles/frostivus_herofx/juggernaut_fs_omnislash_slashers.vpcf"
end

function modifier_dimm_field_target:HeroEffectPriority()
	return 100
end

function modifier_dimm_field_target:DeclareFunctions()
	local funcs = {
      MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end


function modifier_dimm_field_target:OnTakeDamage(params)
  if IsServer() then
  	if params.unit == self:GetParent() then
	    local target = params.attacker
      if target ~= self:GetAbility():GetFieldCaster() then
          self:GetParent():Heal(params.damage, self:GetParent())
          self:GetParent():Purge(false, true, false, true, false)
      else
      	return
      end
  	end
  end
end

function dimm_field:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

