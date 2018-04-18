savitar_gods_speed = class({})

function savitar_gods_speed:OnSpellStart()
	EmitSoundOn("Hero_Invoker.ColdSnap.Cast", self:GetCaster())
	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #units > 0 then
		for _,target in pairs(units) do
			target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = (self:GetCaster():GetIdealSpeed()/100)*self:GetSpecialValueFor("duration") } )
			ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbilityDamage(), ability = self, damage_type = DAMAGE_TYPE_PURE})

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn( "Hero_Invoker.ColdSnap", target )
		end
	end
end

function savitar_gods_speed:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

