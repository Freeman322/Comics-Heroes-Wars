if not loki_blink_strike then loki_blink_strike = class({}) end

function loki_blink_strike:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function loki_blink_strike:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end

function loki_blink_strike:OnSpellStart()
    if IsServer() then
        local target = self:GetCursorTarget()
        local particle = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike.vpcf"
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "loki_golden_poseidons_daggers") == true then
          particle = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf"
        end

        local nFXIndex = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, nil );
    		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
    		ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
    		ParticleManager:ReleaseParticleIndex( nFXIndex );

    		EmitSoundOn( "Hero_Riki.Blink_Strike.Immortal", self:GetCaster() )
        local victim_angle = target:GetAnglesAsVector()
        local victim_forward_vector = target:GetForwardVector()
        local victim_angle_rad = victim_angle.y*math.pi/180
        local victim_position = target:GetAbsOrigin()
        local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start_sparkles.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex( nFXIndex );
        ---EmitSoundOn("Hero_Spectre.Reality", self:GetCaster())

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
