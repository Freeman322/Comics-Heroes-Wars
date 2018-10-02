if daredevil_supersence == nil then daredevil_supersence = class({}) end
LinkLuaModifier("modifier_daredevil_supersence", "abilities/daredevil_supersence.lua", LUA_MODIFIER_MOTION_NONE)

function daredevil_supersence:OnSpellStart()
	if IsServer() then
		local duration = self:GetSpecialValueFor("duration")
		EmitSoundOn("Hero_Nightstalker.Darkness", self:GetCaster())

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin())
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nFXIndex = ParticleManager:CreateParticle( "particles/hero_daredevil/daredevil_super_sence_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(200, 200, 0))
		ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetOrigin())
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local heroes = HeroList:GetAllHeroes()
		for _, hero in pairs(heroes) do
			if hero:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				hero:AddNewModifier(self:GetCaster(), self, "modifier_daredevil_supersence", {duration = duration})
			end
		end
	end
end

if modifier_daredevil_supersence == nil then modifier_daredevil_supersence = class({}) end

function modifier_daredevil_supersence:IsDebuff()
	return true
end

function modifier_daredevil_supersence:IsPurgable()
	return false
end

function modifier_daredevil_supersence:CheckState()
	local state = {
	[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end

function modifier_daredevil_supersence:OnCreated(htable)
	if IsServer() then
		local invis = ParticleManager:CreateParticleForPlayer("particles/hero_daredevil/supersence_status_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetOwner())
        self:AddParticle(invis, false, true, 1000, false, false)
	end
end

function daredevil_supersence:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

