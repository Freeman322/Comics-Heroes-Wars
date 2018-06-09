LinkLuaModifier("modifier_gambit_leap", "abilities/gambit_leap.lua" , LUA_MODIFIER_MOTION_NONE)
if gambit_leap == nil then gambit_leap = class({}) end

function gambit_leap:OnSpellStart ()
    self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_gambit_leap", nil )
    EmitSoundOn ("Hero_EarthShaker.Whoosh",self:GetCaster ())
end

if modifier_gambit_leap == nil then modifier_gambit_leap = class({}) end


function modifier_gambit_leap:GetEffectName()
    return "particles/items2_fx/veil_of_discord_debuff.vpcf"
end

function modifier_gambit_leap:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_gambit_leap:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
		local ability = self:GetAbility()
		local ability_level = ability:GetLevel()

		caster:Stop()
		ProjectileManager:ProjectileDodge(caster)

		-- Ability variables
		ability.leap_direction = caster:GetForwardVector()
		ability.leap_distance = ability:GetSpecialValueFor("leap_distance")
		ability.leap_speed = 1400 * 1/30
		ability.leap_traveled = 0
		ability.leap_z = 0

		caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

		local nFXIndex = ParticleManager:CreateParticle( "particles/hero_gambit/backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )

		self:StartIntervalThink(0.03)
    end
end

function modifier_gambit_leap:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveGesture(ACT_DOTA_CAST_ABILITY_3)
	end
end

function modifier_gambit_leap:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_gambit_leap:OnIntervalThink()
	if IsServer() then
		local caster = self:GetParent()
		local ability = self:GetAbility()

		if ability.leap_traveled < ability.leap_distance/2 then
			ability.leap_z = ability.leap_z + ability.leap_speed
			caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z))
		else
			ability.leap_z = ability.leap_z - ability.leap_speed
			caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z))
		end

		if ability.leap_traveled < ability.leap_distance then
			caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.leap_direction * ability.leap_speed)
			ability.leap_traveled = ability.leap_traveled + ability.leap_speed
		else
			self:ApplyLeapDamage()
		end
	end
end

function modifier_gambit_leap:ApplyLeapDamage()
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/hero_gambit/backtrack_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 0))
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 0))
		ParticleManager:SetParticleControl( nFXIndex, 3, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 0))
		ParticleManager:SetParticleControl( nFXIndex, 4, self:GetCaster():GetOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 6, self:GetCaster():GetOrigin())
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,target in pairs(enemies) do
				target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetAbility():GetSpecialValueFor("stun_duration") } )
				EmitSoundOn("Hero_MonkeyKing.Spring.Target", target)
				local damage = {
					victim = target,
					attacker = self:GetCaster(),
					damage = self:GetAbility():GetSpecialValueFor("damage"),
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility()
				}

				ApplyDamage( damage )
			end
		end
		EmitSoundOn("Hero_MonkeyKing.Spring.Impact", self:GetCaster())
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self:Destroy()
	end
end

function gambit_leap:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

