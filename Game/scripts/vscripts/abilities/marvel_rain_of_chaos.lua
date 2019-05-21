if marvel_rain_of_chaos == nil then marvel_rain_of_chaos = class({}) end 

function marvel_rain_of_chaos:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function marvel_rain_of_chaos:OnSpellStart()
	if IsServer() then 
		local point = self:GetCursorPosition()
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, point );
		ParticleManager:SetParticleControl( nFXIndex, 1, point );
		ParticleManager:SetParticleControl( nFXIndex, 3, point );
		ParticleManager:SetParticleControl( nFXIndex, 6, point );
		ParticleManager:SetParticleControl( nFXIndex, 4, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 0) );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn( "Hero_LegionCommander.Overwhelming.Location.ti7", self:GetCaster() )
		EmitSoundOn( "Hero_LegionCommander.Overwhelming.Cast", self:GetCaster() )

		local damage = 0
		local units = FindUnitsInRadius(self:GetCaster():GetTeam(), point, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        
		for _, target in pairs(units) do
			if self:GetCaster():HasTalent("special_bonus_unique_marvel_3") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_marvel_3") end
			if target:IsHero() then damage = damage + self:GetSpecialValueFor("damage_per_hero") else damage = damage + self:GetSpecialValueFor("damage_per_unit") end          
		end
		for _, target in pairs(units) do
			target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})   
			EmitSoundOn("Hero_LegionCommander.Overwhelming.Hero", target)
			ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})  
		end
	end
end
