iron_heat_missile = class({})

function iron_heat_missile:OnSpellStart()
	local radius = self:GetSpecialValueFor( "radius" )

	local particle = "particles/units/heroes/hero_tinker/tinker_missile.vpcf"
	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "dark_custom") == true then particle = "particles/hero_ironman/iron_rockets.vpcf" end
	
	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "iron_devil") == true then 
		particle = "particles/hero_ironman/iron_devil_rockets.vpcf" 
		
		EmitSoundOn("IronDevil.CastRockets", self:GetCaster())
	end

	local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #targets > 0 then
		local count = 0
		for _,enemy in pairs(targets) do
			if count < self:GetSpecialValueFor("targets") then
				count = count + 1
				local info = {
						EffectName = particle,
						Ability = self,
						iMoveSpeed = self:GetSpecialValueFor( "speed" ),
						Source = self:GetCaster(),
						Target = enemy,
						iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
					}

				ProjectileManager:CreateTrackingProjectile( info )
				EmitSoundOn( "Hero_Tinker.Heat-Seeking_Missile", self:GetCaster() )
			else
				break
			end
		end
	else
		EmitSoundOn( "Hero_Tinker.Heat-Seeking_Missile_Dud", self:GetCaster() )
	end
	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end


function iron_heat_missile:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_Tinker.Heat-Seeking_Missile.Impact", hTarget )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		if self:GetCaster():HasTalent("special_bonus_unique_iron_man") then
			hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("talent_stun_duration")})
		end

		ApplyDamage( damage )
	end

	return true
end

function iron_heat_missile:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
