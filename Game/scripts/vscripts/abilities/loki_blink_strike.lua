loki_blink_strike = class({})

function loki_blink_strike:OnSpellStart()
    if IsServer() then
        local target = self:GetCursorTarget()
        local particle = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike.vpcf"
        
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "loki_golden_poseidons_daggers") == true then
            particle = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf"
        end

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "lovuska_jokera") == true then
            EmitSoundOn("Loki.CustomCast1", self:GetCaster())
        end

        local nFXIndex = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControl(nFXIndex, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(nFXIndex, 1, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(nFXIndex, 2, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(nFXIndex, 3, target:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        EmitSoundOn( "Hero_Riki.Blink_Strike.Immortal", self:GetCaster() )
        local victim_angle = target:GetAnglesAsVector()
        local victim_forward_vector = target:GetForwardVector()
        local victim_angle_rad = victim_angle.y*math.pi/180
        local victim_position = target:GetAbsOrigin()
        local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end_sparkles.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        self:GetCaster():SetAbsOrigin(attacker_new)
        FindClearSpaceForUnit(self:GetCaster(), attacker_new, true)
        self:GetCaster():SetForwardVector(victim_forward_vector)


        EmitSoundOn("Hero_Riki.Blink_Strike", target)
        if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
            self:GetCaster():PerformAttack(target, true, true, true, true, false, false, true)
            ApplyDamage({
                victim = target,
                attacker = self:GetCaster(),
                damage = self:GetAbilityDamage(),
                damage_type = self:GetAbilityDamageType(),
                ability = self,
            })
        end
    end
end

function loki_blink_strike:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_lovuska_jokera") then return "custom/loki_blink_strike_custom" end
    return self.BaseClass.GetAbilityTextureName(self) 
end