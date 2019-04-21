LinkLuaModifier("modifier_flash_void", "abilities/flash_void.lua", LUA_MODIFIER_MOTION_NONE)

if flash_void == nil then flash_void = class({}) end

function flash_void:OnSpellStart()
   if IsServer() then
      self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_flash_void", {duration = self:GetSpecialValueFor("duration")})
      EmitSoundOn("Hero_Invoker.Tornado.Cast.Immortal", self:GetCaster())
   end
end

if modifier_flash_void == nil then modifier_flash_void = class({}) end

function modifier_flash_void:IsHidden()
   return true
end

function modifier_flash_void:IsPurgable()
   return false
end

function modifier_flash_void:OnCreated(event)
  if IsServer() then
    local ability = self:GetAbility()

    self:GetCaster():Stop()

    self.forced_direction = self:GetCaster():GetForwardVector()
    self.forced_distance = ability:GetSpecialValueFor("push_length")
    self.forced_speed = 1600 * 1/30	-- * 1/30 gives a duration of ~0.4 second push time (which is what the gamepedia-site says it should be)
    self.forced_traveled = 0
    self:StartIntervalThink(0.03)
  end
end

function modifier_flash_void:OnIntervalThink()
   if IsServer() then
       local target = self:GetParent()
       local ability = self:GetAbility()

       if self.forced_traveled < self.forced_distance then
          target:SetAbsOrigin(target:GetAbsOrigin() + self.forced_direction * self.forced_speed)
          self.forced_traveled = self.forced_traveled + (self.forced_direction * self.forced_speed):Length2D()
          local units = FindUnitsInRadius( target:GetTeamNumber(), target:GetOrigin(), target, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
        	if #units > 0 then
          		for _,unit in pairs(units) do
                  if not unit:HasModifier("modifier_eul_cyclone") then
                     ApplyDamage({attacker = target, victim = unit, damage = self:GetAbility():GetAbilityDamage(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_PURE})
                     EmitSoundOn("DOTA_Item.Cyclone.Activate", unit)
                     unit:AddNewModifier( self:GetCaster(), self, "modifier_eul_cyclone", { duration = self:GetAbility():GetSpecialValueFor("duration") } )
                  end
              end
        	end
       else
          FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
          self:Destroy()
       end
   end
end

function modifier_flash_void:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function flash_void:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

