black_panther_shadow_warrior_release = class ( {})

--------------------------------------------------------------------------------

function black_panther_shadow_warrior_release:CastFilterResultTarget (hTarget)
    if IsServer () then
        local distance = self:GetSpecialValueFor ("tooltip_range")
        local dToCaster = (hTarget:GetAbsOrigin () - self:GetCaster():GetAbsOrigin()):Length2D()
        if hTarget ~= nil and dToCaster > distance  then
            return UF_FAIL_CUSTOM
        end

        local nResult = UnitFilter (hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end

function black_panther_shadow_warrior_release:GetCustomCastErrorTarget( hTarget )
    if IsServer () then
        local distance = self:GetSpecialValueFor ("tooltip_range")
        local dToCaster = (hTarget:GetAbsOrigin () - self:GetCaster():GetAbsOrigin()):Length2D()
        if hTarget ~= nil and dToCaster > distance  then
            return "#dota_hud_error_too_dist"
        end

        return ""
    end
end

function black_panther_shadow_warrior_release:GetCastRange (vLocation, hTarget)
    return 1300
end

--------------------------------------------------------------------------------

function black_panther_shadow_warrior_release:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then

        local caster = self:GetCaster()
        local target = hTarget
        local ability = self

        local victim_angle = target:GetAnglesAsVector()
        local victim_forward_vector = target:GetForwardVector()

        -- Angle and positioning variables
        local victim_angle_rad = victim_angle.y*math.pi/180
        local victim_position = target:GetAbsOrigin()
        local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)


        -- Sets Riki behind the victim and facing it
        caster:SetAbsOrigin(attacker_new)
        FindClearSpaceForUnit(caster, attacker_new, true)
        caster:SetForwardVector(victim_forward_vector)
        local damage = ability:GetSpecialValueFor("damage")/100
        local bonus_damage = (damage*target:GetMaxHealth()) + ability:GetAbilityDamage()

        ApplyDamage({victim = target, attacker = caster, damage = bonus_damage, damage_type = ability:GetAbilityDamageType()})


        -- Order the caster to attack the target
        -- Necessary on jumps to allies as well (does not actually attack), otherwise Riki will turn back to his initial angle
        order =
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = target:entindex(),
            AbilityIndex = ability,
            Queue = true
        }

        ExecuteOrderFromTable(order)
        if self:GetCaster ():HasModifier("modifier_black_panther_shadow_warrior") then
            self:GetCaster ():RemoveModifierByName("modifier_black_panther_shadow_warrior")
        end
        EmitSoundOn ("Hero_Riki.Blink_Strike", self:GetCaster () )

        local hAbility = self
        local hAbility_prim = self:GetCaster ():FindAbilityByName ("black_panther_shadow_warrior")
        hAbility:SetHidden(true)
        hAbility_prim:SetHidden (false)
        hAbility_prim:SetLevel(hAbility:GetLevel())
    end
end

function black_panther_shadow_warrior_release:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

