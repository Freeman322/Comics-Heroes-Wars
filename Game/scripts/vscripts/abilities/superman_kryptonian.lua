superman_kryptonian = class({})
LinkLuaModifier( "modifier_superman_kryptonian", "abilities/superman_kryptonian", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_superman_knockback", "abilities/superman_kryptonian", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
EF_DAYTIME = "Day"
EF_NIGHTTIME = "Night"

function superman_kryptonian:OnSpellStart()
    if IsServer() then
        self:CreateWave()
    end 
end

function superman_kryptonian:CreateWave()
    if IsServer() then
      local punch_particle = ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
      ParticleManager:SetParticleControl(punch_particle, 0, self:GetCaster():GetAbsOrigin())
      ParticleManager:SetParticleControl(punch_particle, 1, Vector(600, 600, 600))
      ParticleManager:SetParticleControl(punch_particle, 2, Vector(255, 255, 255))
      ParticleManager:SetParticleControl(punch_particle, 3, self:GetCaster():GetAbsOrigin())
      ParticleManager:ReleaseParticleIndex(punch_particle)
      
      EmitSoundOn("Hero_ElderTitan.EchoStomp", self:GetCaster())

      local units = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, unit in pairs(units) do
            unit:AddNewModifier(self:GetCaster(), self, "modifier_superman_knockback", {duration = 1.0})
        end
    end
end


function superman_kryptonian:GetIntrinsicModifierName()
	return "modifier_superman_kryptonian"
end


modifier_superman_knockback = class({})

function modifier_superman_knockback:IsHidden() return true end

function modifier_superman_knockback:IsDebuff() return true end

function modifier_superman_knockback:OnCreated(params)
  if IsServer() then
    local knockbackProperties =
    {
      center_x = self:GetCaster():GetAbsOrigin().x,
      center_y = self:GetCaster():GetAbsOrigin().y,
      center_z = self:GetCaster():GetAbsOrigin().z,
      duration = 0.80,
      knockback_duration = 0.80,
      knockback_distance = 120,
      knockback_height = 300
    }

    self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", knockbackProperties )

    local mult = self:GetAbility():GetSpecialValueFor("stack_mult")
    if self:GetCaster():HasTalent("special_bonus_unique_superman_5") then mult = mult + self:GetCaster():FindTalentValue("special_bonus_unique_superman_5") end

    local damage = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self:GetCaster():FindModifierByName("modifier_superman_kryptonian"):GetStackCount() * mult,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self:GetAbility(),
    }

    ApplyDamage( damage )
  end
end

--------------------------------------------------------------------------------

if modifier_superman_kryptonian == nil then modifier_superman_kryptonian = class({}) end

--------------------------------------------------------------------------------

function modifier_superman_kryptonian:OnCreated( kv )
    if IsServer() then
        self.nMaxStacks = self:GetAbility():GetSpecialValueFor("max_stacks")
        self.nGameTime = EF_DAYTIME

        if self:GetCaster():HasTalent("special_bonus_unique_superman_2") then self.nMaxStacks = self.nMaxStacks + self:GetCaster():FindTalentValue("special_bonus_unique_superman_2") end

		self:StartIntervalThink( 1 ) self:SetStackCount(1)
	end
end

function modifier_superman_kryptonian:OnRefresh()
    if IsServer() then
        self.nMaxStacks = self:GetAbility():GetSpecialValueFor("max_stacks")
        if self:GetCaster():HasTalent("special_bonus_unique_superman_2") then self.nMaxStacks = self.nMaxStacks + self:GetCaster():FindTalentValue("special_bonus_unique_superman_2") end
	end
end

function modifier_superman_kryptonian:OnIntervalThink()
    if IsServer() then
        if GameRules:IsDaytime() then self.nGameTime = EF_DAYTIME else self.nGameTime = EF_NIGHTTIME end 
        if self.nGameTime == EF_NIGHTTIME and not self:GetCaster():HasTalent("special_bonus_unique_superman_6") then self:SetStackCount(1) self:GetAbility():SetActivated(false) return else self:GetAbility():SetActivated(true) end  

		if self:GetStackCount() < self.nMaxStacks then      
            self:IncrementStackCount()
        end
        
        self:OnRefresh()
	end
end

--------------------------------------------------------------------------------
function modifier_superman_kryptonian:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_superman_kryptonian:GetModifierPhysicalArmorBonus (params)
    return self:GetAbility():GetSpecialValueFor("armor_per_stack") * self:GetStackCount()
end

function modifier_superman_kryptonian:GetModifierPreAttack_BonusDamage (params)
    return self:GetAbility():GetSpecialValueFor("damage_per_stack") * self:GetStackCount()
end

function modifier_superman_kryptonian:GetModifierAttackSpeedBonus_Constant (params)
    return self:GetAbility():GetSpecialValueFor("attack_speed_per_stack") * self:GetStackCount()
end
