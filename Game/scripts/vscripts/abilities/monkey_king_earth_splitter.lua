if monkey_king_earth_splitter == nil then monkey_king_earth_splitter = class({}) end

LinkLuaModifier( "modifier_monkey_king_earth_splitter_self", "abilities/monkey_king_earth_splitter.lua", LUA_MODIFIER_MOTION_NONE )

function monkey_king_earth_splitter:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function monkey_king_earth_splitter:GetCastAnimation( )
  return ACT_DOTA_CAST_ABILITY_1
end

function monkey_king_earth_splitter:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

function monkey_king_earth_splitter:OnAbilityPhaseStart()
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

function monkey_king_earth_splitter:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN
	return behav
end

function monkey_king_earth_splitter:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition()
	local nLenght = self:GetCastRange( self:GetCursorPosition(), nil)
	local vForward = self:GetCursorPosition() - hCaster:GetAbsOrigin()
	vForward = vForward:Normalized()
	local nStun	= self:GetSpecialValueFor( "stun_duration" )
	local nRadius	= self:GetSpecialValueFor( "strike_radius" )
	local vStartPos = hCaster:GetAbsOrigin()
	local vEndPos = vStartPos + vForward * nLenght

	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "monkey_king_golden_staff") then
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_golden_immortal_strike.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
		ParticleManager:SetParticleControlOrientation(nFXIndex,0,vForward,Vector(0, 0, 0),Vector(0, 0, 0))
		ParticleManager:SetParticleControl( nFXIndex, 1, vEndPos );
		ParticleManager:SetParticleControl( nFXIndex, 2, self:GetCaster():GetAbsOrigin());
		ParticleManager:ReleaseParticleIndex( nFXIndex );
	else 
		local nFXIndex = ParticleManager:CreateParticle( "particles/hero_daredevil/daredevil_slash_strike_ground.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
		ParticleManager:SetParticleControlOrientation(nFXIndex,0,vForward,Vector(0, 0, 0),Vector(0, 0, 0))
		ParticleManager:SetParticleControl( nFXIndex, 1, vEndPos );
		ParticleManager:SetParticleControl( nFXIndex, 2, self:GetCaster():GetAbsOrigin());
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
		ParticleManager:SetParticleControl( nFXIndex, 1, vEndPos );
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector(0.1, 0, 0));
		ParticleManager:ReleaseParticleIndex( nFXIndex );
	end

	EmitSoundOn("Hero_MonkeyKing.Strike.Impact", hCaster)

	local units = FindUnitsInLine( hCaster:GetTeamNumber(), vStartPos, vEndPos , nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_CLOSEST  )
	for _, unit in pairs(units) do
		EmitSoundOn("Hero_MonkeyKing.Spring.Target", hCaster)
		unit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = nStun})
		self:GetCaster():PerformAttack(unit, true, true, true, true, false, false, true)
		local damage = {
					victim = unit,
					attacker = hCaster,
					damage = self:GetAbilityDamage() + (unit:GetMaxHealth() * (self:GetSpecialValueFor("damage")/100)),
					damage_type = self:GetAbilityDamageType(),
					ability = self
				}

		ApplyDamage( damage )
	end
end

function monkey_king_earth_splitter:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

