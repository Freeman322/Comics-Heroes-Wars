superman_punch = class ({})

LinkLuaModifier( "modifier_superman_punch", "abilities/superman_punch.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_superman_punch_slow", "abilities/superman_punch.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_superman_punch_flying", "abilities/superman_punch.lua", LUA_MODIFIER_MOTION_NONE)

function superman_punch:GetIntrinsicModifierName()
	return "modifier_superman_punch"
end

function superman_punch:OnSpellStart()
  if IsServer() then 
    self:GetCaster():MoveToTargetToAttack(self:GetCursorTarget())
  end 
end


modifier_superman_punch = class({})

function modifier_superman_punch:IsHidden() return true end
function modifier_superman_punch:IsPermanent() return true end


function modifier_superman_punch:DeclareFunctions()
  local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
  }

  return funcs
end

function modifier_superman_punch:OnAttackLanded(params)
  if IsServer() then 
    if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and params.attacker == self:GetCaster() then
        local hTarget = params.target
        local damage = params.original_damage

        if hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then return false end
        if hTarget:IsBuilding() or hTarget:IsOther() then return false end

        local damage_mult = self:GetAbility():GetSpecialValueFor("crit_multiplier")
        if self:GetParent():HasTalent("special_bonus_unique_superman_1") then damage_mult = damage_mult + self:GetParent():FindTalentValue("special_bonus_unique_superman_1") end 

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        self:GetCaster():EmitSound("Hero_Tusk.WalrusPunch.Target")

        damage = damage * (damage_mult / 100)

        local air_time_duration = 1.0
        local duration = 3.0

        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_superman_punch_flying", {duration = air_time_duration})
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_superman_punch_slow", {duration = duration})

        -- Text particles
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_walruspunch_txt_ult.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(particle, 2, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 175))
        ParticleManager:ReleaseParticleIndex(particle)

        ApplyDamage ( {
            victim = hTarget,
            attacker = self:GetParent(),
            damage = damage,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self:GetAbility(),
            damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
        })

        self:GetCaster():EmitSound("Hero_Tusk.WalrusPunch.Cast")

        self:GetAbility():UseResources(false, false, true)
    end
  end 
  
  return
end

modifier_superman_punch_flying = class({})

---@override
function modifier_superman_punch_flying:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = IsServer(), -- Not showing the status bar
    }
end

---@override
function modifier_superman_punch_flying:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end

---@override
function modifier_superman_punch_flying:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

---@override
function modifier_superman_punch_flying:OnCreated(keys)
    if IsServer() then
        self.air_time_duration = 1.0
        local max_height = 650

        self.z_vel = max_height * 4
        self.direction = Vector(0, 0, self.z_vel)
        
        self:GetParent():EmitSound("Hero_Tusk.WalrusPunch.Damage")

        self:StartIntervalThink(FrameTime())
    end
end

---@override
function modifier_superman_punch_flying:OnIntervalThink()
    local unit = self:GetParent()
    -- Decrease the z velocity
    self.direction.z = self.direction.z - (self.z_vel *2  *FrameTime())
    unit:SetAbsOrigin(unit:GetAbsOrigin() + self.direction *  FrameTime())
end

---@override
function modifier_superman_punch_flying:OnDestroy()
    if IsServer() then
        FindClearSpaceForUnit(self:GetParent(),self:GetParent():GetAbsOrigin(),true)
    end
end


modifier_superman_punch_slow = class({})


function modifier_superman_punch_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_superman_punch_slow:GetModifierMoveSpeedBonus_Percentage()
    return -50
end

function modifier_superman_punch_slow:GetStatusEffectName()
    return "particles/units/heroes/hero_tusk/tusk_walruspunch_status.vpcf"
end