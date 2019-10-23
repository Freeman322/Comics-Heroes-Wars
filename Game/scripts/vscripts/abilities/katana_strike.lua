LinkLuaModifier("modifier_katana_strike_bonus", "abilities/katana_strike.lua", 0)

katana_strike = class({})

function katana_strike:OnSpellStart()
    if IsServer() then
        local target = self:GetCursorTarget()
        local particle = "particles/econ/events/ti9/blink_dagger_ti9_start_lvl2_sparkles.vpcf"


        local nFXIndex = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControl(nFXIndex, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(nFXIndex, 1, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(nFXIndex, 2, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(nFXIndex, 3, target:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        EmitSoundOn( "Hero_PhantomAssassin.Phantom_Strike", self:GetCaster() )
        local victim_angle = target:GetAnglesAsVector()
        local victim_forward_vector = target:GetForwardVector()
        local victim_angle_rad = victim_angle.y*math.pi/180
        local victim_position = target:GetAbsOrigin()
        local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti8/blink_dagger_ti8_end_energy.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        self:GetCaster():SetAbsOrigin(attacker_new)
        FindClearSpaceForUnit(self:GetCaster(), attacker_new, true)
        self:GetCaster():SetForwardVector(victim_forward_vector)


        EmitSoundOn("Hero_Riki.Blink_Strike", target)

        self:GetCaster():PerformAttack (target, false, false, true, true, false, false, true)
        self:GetCaster():PerformAttack (target, false, false, true, true, false, false, true)
        
        -----self:GetCaster():PerformAttack (target, false, false, true, true, false, false, true)

        ApplyDamage({
            victim = target,
            attacker = self:GetCaster(),
            damage = self:GetAbilityDamage(),
            damage_type = self:GetAbilityDamageType(),
            ability = self,
        })

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_katana_strike_bonus", {duration = self:GetSpecialValueFor("duration")})
    end
end

modifier_katana_strike_bonus = class({})

function modifier_katana_strike_bonus:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
    return funcs
end

function modifier_katana_strike_bonus:GetModifierMoveSpeedBonus_Percentage( params ) return self:GetAbility():GetSpecialValueFor("movespeed_bonus") end
function modifier_katana_strike_bonus:GetModifierAttackSpeedBonus_Constant( params ) return self:GetAbility():GetSpecialValueFor("attack_speed_bonus") end

        
function katana_strike:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_goku") then
        return "custom/goku_skin_second_spell"
	end
	
    return self.BaseClass.GetAbilityTextureName(self)
end