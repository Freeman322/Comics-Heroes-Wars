LinkLuaModifier( "modifier_bane_feeze_caster", "abilities/bane_feeze.lua", 0 )
LinkLuaModifier( "modifier_bane_feeze_trg", "abilities/bane_feeze.lua", 0 )

bane_feeze = class({})
function bane_feeze:OnSpellStart()
    EmitSoundOn("Hero_Magnataur.Skewer.Cast", self:GetCaster())
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bane_feeze_caster", nil)
end

modifier_bane_feeze_caster = class({
    IsDebuff = function() return false end,
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end,
    GetOverrideAnimation = function() return ACT_DOTA_CAST_ABILITY_4 end
})
function modifier_bane_feeze_caster:OnCreated ()
    if IsServer() then
        local caster = self:GetCaster()
        self.target = caster:GetCursorPosition()

        self.leap_direction = (self.target - caster:GetAbsOrigin()):Normalized()
        self.leap_distance = (self.target - caster:GetAbsOrigin()):Length2D()
        self.leap_traveled = 0
        self.leap_z = 0


        local range = self:GetAbility():GetSpecialValueFor("skewer_range")
        local point = self.target

        local distance = (point - caster:GetAbsOrigin()):Length2D()
        local direction = (point - caster:GetAbsOrigin()):Normalized()

        if distance > range then
            point = caster:GetAbsOrigin() + range * direction
            distance = range
        end

        self.distance = distance

        self.direction = direction

        self:StartIntervalThink(0.03)
    end
end

function modifier_bane_feeze_caster:OnIntervalThink()
    local caster = self:GetParent()

    if self.leap_traveled < self.leap_distance then
        caster:SetAbsOrigin (caster:GetAbsOrigin () + self.leap_direction * 53.333)
        self.leap_traveled = self.leap_traveled + 53.333
    else
        self:OnMotionInterrupted()
    end

    GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 150, true)

	for i,unit in ipairs(FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 0, self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), 0, false)) do
        if unit ~= self:GetParent() then
            unit:SetAbsOrigin(caster:GetAbsOrigin() + 200 * self.direction)
            unit:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
        end
	end
end

function modifier_bane_feeze_caster:OnMotionInterrupted ()
    if IsServer () then
        self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_4_END)

        for _, taget in ipairs (FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, 375,  self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), 0, false)) do
            FindClearSpaceForUnit(taget, taget:GetAbsOrigin(), false)
            taget:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_stunned", { duration = 1 })
            if taget:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                ApplyDamage ( { attacker = self:GetAbility ():GetCaster (), victim = taget, ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = self:GetAbility():GetAbilityDamageType() })
            end
        end

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(particle, 1, Vector( 275, 1, 1 ))
        ParticleManager:ReleaseParticleIndex(particle)
        EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Hero_EarthShaker.Totem", self:GetCaster())
        self:Destroy()
    end
end
