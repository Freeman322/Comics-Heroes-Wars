atomic_samurai_air_blade_flying_sword = class({}) --- Чет название длинновато XDDDD

--------------------------------------------------------------------------------

function atomic_samurai_air_blade_flying_sword:OnSpellStart()
	if IsServer() then
		local wave_speed = self:GetSpecialValueFor( "wave_speed" )
		local wave_width = self:GetSpecialValueFor( "wave_width" )
		local count = self:GetSpecialValueFor( "wave_count" )
		
		if self:GetCaster():HasTalent("special_bonus_unique_atomic_samurai") then count = count + self:GetCaster():FindTalentValue("special_bonus_unique_atomic_samurai") end

		----дальше цикл, от 1 до колличества count повторить одно и тоже действие
		
		for i = 1, count do 
			local dir = self:GetCaster():GetForwardVector() + Vector(RandomFloat(-0.5, 0.5), RandomFloat(-0.5, 0.5), 0) ---- рандомно оклониться от направлдения юнита на |25| скалярных велечин
			
			local info = {
				EffectName = "particles/units/heroes/hero_mars/mars_spear.vpcf",
				Ability = self,
				vSpawnOrigin = self:GetCaster():GetOrigin(), 
				fStartRadius = wave_width,
				fEndRadius = wave_width,
				vVelocity = dir * wave_speed,
				fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				bProvidesVision = true,
				iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
				iVisionRadius = vision_aoe
			}
			
			ProjectileManager:CreateLinearProjectile( info )
		end
		
		EmitSoundOn( "Hero_Mars.Spear" , self:GetCaster() )
	end
end


function atomic_samurai_air_blade_flying_sword:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
		EmitSoundOn( "Hero_Mars.Spear.Target" ,hTarget )
		
		local wave_damage = self:GetSpecialValueFor( "wave_damage" ) + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_atomic_samurai_2") or 0)
		
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = wave_damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = this,
		}

		ApplyDamage( damage )
	end

	return false
    end
end 