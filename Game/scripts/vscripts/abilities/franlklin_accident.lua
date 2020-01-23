if franlklin_accident == nil then franlklin_accident = class({}) end

function franlklin_accident:OnSpellStart()
	local radius = self:GetSpecialValueFor( "radius" )
	local duration = self:GetSpecialValueFor(  "silence_duration" )

	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #units > 0 then
		for _,target in pairs(units) do
			target:AddNewModifier( self:GetCaster(), self, "modifier_silencer_global_silence", { duration = duration } )
			EmitSoundOn("DOTA_Item.Orchid.Activate", target)
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2017/dagon_wm07.vpcf", PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector(100, 100, 0))
			ParticleManager:ReleaseParticleIndex( nFXIndex );
			ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbilityDamage(), ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end

	EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

function franlklin_accident:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

