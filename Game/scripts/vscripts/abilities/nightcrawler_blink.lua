if nightcrawler_blink == nil then nightcrawler_blink  = class({}) end


function nightcrawler_blink:OnSpellStart()
	local radius = self:GetSpecialValueFor( "radius" )
	local vPoint = self:GetCaster():GetCursorPosition()

	local particle1 = "particles/hero_nightcrawler/nightcrawler_blink_cast.vpcf"
	local particle2 = "particles/hero_nightcrawler/nightcrawler_blink.vpcf"
	local particle3 = "particles/hero_nightcrawler/nightcrawler_blink_self.vpcf"

	local sound = "Hero_MonkeyKing.IronCudgel"

	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "octavia") then
		particle1 = "particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf"
		particle2 = "particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf"
		particle3 = "particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf"

		sound = "OctaviaSkin.Blink"
	end

	local nFXIndex = ParticleManager:CreateParticle( particle1, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false )
	
	self.count = 0
	local max_units = self:GetSpecialValueFor("max_units")
	print(#allies)
	if #allies > 0 then
		for _,ally in pairs(allies) do
			if self.count >= max_units then
				break
			else
				self.count = self.count + 1
				ally:SetAbsOrigin(vPoint)
				FindClearSpaceForUnit(ally, vPoint, true)
				local nFXIndex = ParticleManager:CreateParticle( particle3, PATTACH_WORLDORIGIN, self:GetCaster() )
				ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin())
				ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin())
				ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end
	end
	self.count = 0

	local nFXIndex = ParticleManager:CreateParticle( particle2, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition() )
	ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetCursorPosition() )
	ParticleManager:SetParticleControl( nFXIndex, 4, self:GetCaster():GetCursorPosition() )
	ParticleManager:SetParticleControl( nFXIndex, 5, self:GetCaster():GetCursorPosition() )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( sound, self:GetCaster() )
end

function nightcrawler_blink:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

