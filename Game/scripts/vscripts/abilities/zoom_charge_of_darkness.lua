LinkLuaModifier("modifier_zoom_charge_of_darkness", "abilities/zoom_charge_of_darkness.lua", 0)

zoom_charge_of_darkness = class({IsRefreshable = function() return false end})

function zoom_charge_of_darkness:CastFilterResultTarget( hTarget )
  if IsServer() then

    if hTarget ~= nil and hTarget:IsMagicImmune() and not self:GetCaster():HasScepter() then
      return UF_FAIL_MAGIC_IMMUNE_ENEMY
    end

    return UnitFilter(hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber())
  end

  return UF_SUCCESS
end

function zoom_charge_of_darkness:OnSpellStart()
    if not IsServer() then return end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zoom_charge_of_darkness", {ent_index = self:GetCursorTarget():GetEntityIndex()})
    if self:GetCaster():GetModelName() == "models/heroes/hero_zoom/speed_wraith/blackflash.vmdl" then
        EmitSoundOn("Hero_Spectre.Haunt", self:GetCaster())
        EmitSoundOn("Hero_Spectre.Reality", self:GetCaster())
        EmitSoundOn("Hero_Undying.FleshGolem.Cast", self:GetCaster())
        EmitSoundOn("Hero_Oracle.FalsePromise.FP", self:GetCaster())
    end
    EmitSoundOn("Hero_Spirit_Breaker.ChargeOfDarkness.FP", self:GetCaster())
end

modifier_zoom_charge_of_darkness = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return true end,
    CheckState = function() return {[MODIFIER_STATE_COMMAND_RESTRICTED] = true} end
})

function modifier_zoom_charge_of_darkness:GetEffectName()
    if self:GetCaster():HasModifier("modifier_zoom_kalyaska") then return "particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon_flying.vpcf" end
    if self:GetCaster():HasModifier("modifier_zoom_kalyaska_gold") then return "particles/econ/items/pudge/pudge_immortal_arm/pudge_immortal_arm_rot_gold.vpcf" end
    return "particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/spirit_breaker_charge_iron.vpcf"
end

function modifier_zoom_charge_of_darkness:OnCreated(params)
    if not IsServer() then return end
    self.target = EntIndexToHScript(params.ent_index)
    self.speed = 500
    self.traveled_distance = 0
    self:StartIntervalThink(FrameTime())
end

function modifier_zoom_charge_of_darkness:OnIntervalThink()
    if not IsServer() then return end
    self:GetCaster():FaceTowards(self.target:GetAbsOrigin())
    self.distance = (self.target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
    if self.speed < self:GetAbility():GetSpecialValueFor("movement_speed") then self.speed = self.speed + self.speed * 0.1 end
    if self.speed > self:GetAbility():GetSpecialValueFor("movement_speed") then self.speed = self:GetAbility():GetSpecialValueFor("movement_speed") end
    if self.distance > 150 then
        self:GetCaster():SetOrigin(self:GetCaster():GetAbsOrigin() + (self.target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * self.speed * FrameTime())
        self.traveled_distance = self.traveled_distance + self.speed * FrameTime()
    else
        self:Destroy()
    end
end

function modifier_zoom_charge_of_darkness:OnDestroy()
    if not IsServer() then return end
    local target = self.target
    local caster = self:GetCaster()
    if self.distance <= 150 then
        if caster:HasModifier("modifier_zoom_charge_of_darkness") then caster:RemoveModifierByName("modifier_zoom_charge_of_darkness") end
        local damage = 0.01 * self:GetAbility():GetSpecialValueFor("damage")
        local talent = false
        if IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_zoom") then talent = true end
        ApplyDamage({
            victim = target,
            attacker = caster,
            ability = self:GetAbility(),
            damage = damage * self.speed + (talent and 1 or damage) * self.traveled_distance,
            damage_type = self:GetAbility():GetAbilityDamageType()
        })

        FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
        local explosion5 = ParticleManager:CreateParticle("particles/one_punch.vpcf", PATTACH_WORLDORIGIN, target)
        ParticleManager:SetParticleControl(explosion5, 0, target:GetAbsOrigin() + Vector(0, 0, 1))
        ParticleManager:SetParticleControl(explosion5, 1, Vector(1, 1, 1))
        ParticleManager:SetParticleControl(explosion5, 2, Vector(255, 255, 255))
        ParticleManager:SetParticleControl(explosion5, 3, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion5, 5, Vector(200, 200, 0))

        local explosion9 = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(explosion9, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion9, 1, target:GetAbsOrigin()+ target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion9, 3, target:GetAbsOrigin() + target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion9, 11, target:GetAbsOrigin()+ target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion9, 12, caster:GetAbsOrigin())


        local explosion13 = ParticleManager:CreateParticle("particles/hero_zoom/time_crystal_activate.vpcf", PATTACH_WORLDORIGIN, target)
        ParticleManager:SetParticleControl(explosion13 , 0, target:GetAbsOrigin())

        local explosion10 = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(explosion10, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion10, 1, target:GetAbsOrigin() - target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion10, 3, target:GetAbsOrigin() - target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion10, 11, target:GetAbsOrigin() - target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion10, 12, caster:GetAbsOrigin())

        local explosion12 = ParticleManager:CreateParticle("particles/punch_cracks.vpcf", PATTACH_WORLDORIGIN, target)
        ParticleManager:SetParticleControl(explosion12, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion12, 1,  Vector(200, 200, 0))
        ParticleManager:SetParticleControl(explosion12, 3,  caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion12, 11,  caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion12, 12,  caster:GetAbsOrigin())

        EmitSoundOn( "Hero_EarthShaker.EchoSlam", hTarget )
        EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", hTarget )
        EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", hTarget )
        EmitSoundOn( "PudgeWarsClassic.echo_slam", hTarget )

        if self:GetCaster():HasModifier("modifier_zoom_kalyaska_gold") then
            local explosion5 = ParticleManager:CreateParticle("particles/zoom_golden_wheelchair_end.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
            ParticleManager:SetParticleControl(explosion5, 0, self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl(explosion5, 1, Vector(500, 500, 0))
            ParticleManager:ReleaseParticleIndex(explosion5)

            EmitSoundOn("Hero_Riki.Smoke_Screen.ti8", self:GetCaster())
        end
    end
end
