if daredevil_boundless_strike == nil then daredevil_boundless_strike = class({}) end

LinkLuaModifier( "modifier_daredevil_boundless_strike_self", "abilities/daredevil_boundless_strike.lua", LUA_MODIFIER_MOTION_NONE )

function daredevil_boundless_strike:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function daredevil_boundless_strike:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

function daredevil_boundless_strike:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_daredevil_arcana") then
		return "custom/daredevil_boundless_strike_arcana"
	end
	return "custom/daredevil_boundless_strike"
end

function daredevil_boundless_strike:OnAbilityPhaseStart()
	if IsServer() then
		self.vCursor = self:GetCaster():GetCursorPosition()
		local vForward = self.vCursor - self:GetCaster():GetAbsOrigin()
		vForward = vForward:Normalized()
		local nFXIndex = ParticleManager:CreateParticle( "particles/hero_daredevil/daredevil_slash_strike.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
		ParticleManager:SetParticleControlOrientation(nFXIndex,0,vForward,Vector(0, 0, 0),Vector(0, 0, 0))
		ParticleManager:SetParticleControl( nFXIndex, 1, self.vCursor );
		ParticleManager:SetParticleControl( nFXIndex, 2, self:GetCaster():GetAbsOrigin());
		ParticleManager:SetParticleControl( nFXIndex, 3, Vector(1, 0, 0));
		ParticleManager:SetParticleControl( nFXIndex, 4, Vector(1, 0, 0));
		ParticleManager:ReleaseParticleIndex( nFXIndex );
		EmitSoundOn("Hero_MonkeyKing.Strike.Cast", self:GetCaster())
	end

	return true
end

function daredevil_boundless_strike:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN
	return behav
end

function daredevil_boundless_strike:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition()
	local nLenght = self:GetCastRange( self:GetCursorPosition(), nil)
	local vForward = self:GetCursorPosition() - hCaster:GetAbsOrigin()
	vForward = vForward:Normalized()
	local nStun	= self:GetSpecialValueFor( "stun_duration" )
	local nRadius	= self:GetSpecialValueFor( "strike_radius" )
	local vStartPos = hCaster:GetAbsOrigin()
	local vEndPos = vStartPos + vForward * nLenght

	hCaster:AddNewModifier(hCaster, self, "modifier_daredevil_boundless_strike_self", {duration = 0.3})
	if _G.clients[PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID())] then
		local nFXIndex = ParticleManager:CreateParticle( "particles/hero_daredevil/jade_strike.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
		ParticleManager:SetParticleControlOrientation(nFXIndex,0,vForward,Vector(0, 0, 0),Vector(0, 0, 0))
		ParticleManager:SetParticleControl( nFXIndex, 1, vEndPos );
		ParticleManager:SetParticleControl( nFXIndex, 2, self:GetCaster():GetAbsOrigin());
		ParticleManager:ReleaseParticleIndex( nFXIndex );
		EmitSoundOn("Hero_EarthSpirit.RollingBoulder.Target", hCaster)
	else
		local nFXIndex = ParticleManager:CreateParticle( "particles/hero_daredevil/daredevil_slash_strike_ground.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
		ParticleManager:SetParticleControlOrientation(nFXIndex,0,vForward,Vector(0, 0, 0),Vector(0, 0, 0))
		ParticleManager:SetParticleControl( nFXIndex, 1, vEndPos );
		ParticleManager:SetParticleControl( nFXIndex, 2, self:GetCaster():GetAbsOrigin());
		ParticleManager:ReleaseParticleIndex( nFXIndex );
		EmitSoundOn("Hero_MonkeyKing.Strike.Impact", hCaster)
	end
	local units = FindUnitsInLine( hCaster:GetTeamNumber(), vStartPos, vEndPos , nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_CLOSEST  )
	for _, unit in pairs(units) do
		EmitSoundOn("Hero_MonkeyKing.Spring.Target", hCaster)
		unit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = nStun})
		local damage = {
					victim = unit,
					attacker = hCaster,
					damage = self:GetAbilityDamage(),
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self
				}

		ApplyDamage( damage )
		hCaster:PerformAttack(unit, true, true, true, true, true, false, true)
	end
end

if modifier_daredevil_boundless_strike_self == nil then modifier_daredevil_boundless_strike_self = class({}) end

function modifier_daredevil_boundless_strike_self:IsHidden ()
    return true
end

function modifier_daredevil_boundless_strike_self:RemoveOnDeath ()
    return true
end

function modifier_daredevil_boundless_strike_self:IsPurgable()
    return false
end

function modifier_daredevil_boundless_strike_self:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }

    return funcs
end

function modifier_daredevil_boundless_strike_self:GetModifierPreAttack_CriticalStrike (params)
    return self:GetAbility():GetSpecialValueFor ("strike_crit_mult")
end
function modifier_daredevil_boundless_strike_self:CheckState()
	local state = {
	[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end
