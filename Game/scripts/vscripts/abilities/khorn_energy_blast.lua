khorn_energy_blast = class({})

function khorn_energy_blast:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function khorn_energy_blast:OnSpellStart()
	local duration = self:GetSpecialValueFor(  "stun_duration" )

	local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetCursorPosition(), self:GetCaster(), self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #targets > 0 then
		for _,target in pairs(targets) do
			target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )
			ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbilityDamage(), ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end

	EmitSoundOn("Hero_Invoker.SunStrike.Ignite", self:GetCaster())
	
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(400, 400, 0) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

function khorn_energy_blast:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

