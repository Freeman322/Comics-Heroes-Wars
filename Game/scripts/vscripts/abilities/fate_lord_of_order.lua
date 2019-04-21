fate_lord_of_order = class({})

--------------------------------------------------------------------------------

function fate_lord_of_order:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

--------------------------------------------------------------------------------

function fate_lord_of_order:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hCaster == nil or hTarget == nil then
		return
	end

	hTarget:Interrupt()

	local nCasterFX = ParticleManager:CreateParticle( "particles/econ/items/warlock/warlock_staff_hellborn/warlock_rain_of_chaos_hellborn_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControlEnt( nCasterFX, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nCasterFX )

	local nTargetFX = ParticleManager:CreateParticle( "particles/econ/items/warlock/warlock_staff_hellborn/warlock_rain_of_chaos_hellborn_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:SetParticleControlEnt( nTargetFX, 0, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nTargetFX )

	EmitSoundOn( "Hero_Chen.HolyPersuasionEnemy", hCaster )
	EmitSoundOn( "Hero_Chen.HolyPersuasionEnemy", hTarget )

	local damage = self:GetSpecialValueFor("damage")
	if self:GetCaster():HasTalent("special_bonus_unique_fate_3") then damage = damage + (self:GetCaster():FindTalentValue("special_bonus_unique_fate_3") or 1) end

	hCaster:StartGesture( ACT_DOTA_CHANNEL_END_ABILITY_4 )

	if hTarget:GetTeamNumber() == hCaster:GetTeamNumber() then
		local damage_result = hCaster:GetHealth() * (damage / 100)

		hTarget:Heal(damage_result, self) hCaster:ModifyHealth(hCaster:GetHealth() - damage_result, self, true, 0)
	else
		local damage_result = hTarget:GetHealth() * (damage / 100)

		local damage_tbl = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage_result,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self
		}

		ApplyDamage( damage_tbl )

		self:GetCaster():Heal(damage_result, self)
	end
end
