medivh_dark_rift = class({})
vPoint = nil
LinkLuaModifier("modifier_medivh_dark_rift", "abilities/medivh_dark_rift.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_rift_effect", "abilities/medivh_dark_rift.lua", LUA_MODIFIER_MOTION_NONE)

function medivh_dark_rift:GetCastRange( vLocation, hTarget )
    return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function medivh_dark_rift:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function medivh_dark_rift:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function medivh_dark_rift:OnSpellStart()
    vPoint = self:GetCursorPosition()
    local caster = self:GetCaster()

    EmitSoundOn("Hero_Abaddon.BorrowedTime", caster)
    caster:AddNewModifier(caster, self, "modifier_medivh_dark_rift", {duration = self:GetSpecialValueFor("teleport_delay")})
end

modifier_medivh_dark_rift = class({})

function modifier_medivh_dark_rift:IsPurgable()
	return false
end

function modifier_medivh_dark_rift:OnCreated(table)
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abbysal_underlord_darkrift_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 1) )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 20, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )

		local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex1, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex1, 1, Vector(1000, 0, 0))
		ParticleManager:SetParticleControlEnt( nFXIndex1, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex1, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex1, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex1, 6, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex1, 20, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex1, false, false, -1, false, true )

		EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Cast", self:GetParent())
		EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Target", self:GetParent())
	end
end

function modifier_medivh_dark_rift:OnDestroy()
	if IsServer() then
		local direction = (vPoint - self:GetParent():GetAbsOrigin()):Normalized()
		local nFXIndex2 = ParticleManager:CreateParticle( "particles/hero_medivh/dark_rift_end.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
		ParticleManager:SetParticleControlEnt(nFXIndex2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex2, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", vPoint, true)
		ParticleManager:SetParticleControl(nFXIndex2, 2, vPoint)
		ParticleManager:SetParticleControlOrientation(nFXIndex2, 2, direction, Vector(0,1,0), Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex(nFXIndex2)

		local nFXIndex2 = ParticleManager:CreateParticle( "particles/hero_medivh/dark_rift_end.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
		ParticleManager:SetParticleControlEnt(nFXIndex2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex2, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",  self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(nFXIndex2, 2,  self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(nFXIndex2, 2, direction, Vector(0,1,0), Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex(nFXIndex2)

		local nearby_units = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _, units in pairs(nearby_units) do
			units:SetAbsOrigin(self:GetParent():GetAbsOrigin())
			units:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_dark_rift_effect", {duration = 0.5})
		end
		Timers:CreateTimer(0.1, function()
			for _, units in pairs(nearby_units) do
				units:SetAbsOrigin(vPoint)
				EmitSoundOn("Hero_ObsidianDestroyer.EssenceAura", units)
				FindClearSpaceForUnit(units, vPoint, false)
				ParticleManager:CreateParticle ("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_POINT_FOLLOW, units)
			end
			return nil
		end)
		EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Complete", self:GetCaster() )
		GridNav:DestroyTreesAroundPoint(vPoint, 450, false)
	end
end

if modifier_dark_rift_effect == nil then modifier_dark_rift_effect = class({}) end

function modifier_dark_rift_effect:IsHidden()
	return true
	-- body
end

function modifier_dark_rift_effect:GetEffectName()
	return "particles/units/heroes/hero_chaos_knight/chaos_knight_phantasm.vpcf"
	-- body
end

function modifier_dark_rift_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
	-- body
end

function medivh_dark_rift:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

