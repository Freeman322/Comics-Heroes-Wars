LinkLuaModifier("modifier_dimm_ravage", "abilities/dimm_ravage.lua", LUA_MODIFIER_MOTION_NONE)

if dimm_ravage == nil then dimm_ravage = class({}) end

function dimm_ravage:CastFilterResultTarget( hTarget )
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function dimm_ravage:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function dimm_ravage:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		local duration = self:GetSpecialValueFor( "duration" )
		EmitSoundOn( "PudgeWarsClassic.sphere", hTarget )
		EmitSoundOn( "Hero_Invoker.EMP.Discharge", self:GetCaster() )
		local enemies = FindUnitsInRadius (self:GetCaster ():GetTeamNumber (), self:GetCaster ():GetOrigin (), self:GetCaster (), 999999, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
		if #enemies > 0 then
			for _, target in pairs (enemies) do
				if target ~= hTarget and target ~= self:GetCaster() then
					target:AddNewModifier (self:GetCaster (), self, "modifier_dimm_ravage", { duration = duration } )
				end
			end
		end
	end
end

if modifier_dimm_ravage == nil then
	modifier_dimm_ravage = class({})
end

function modifier_dimm_ravage:IsHidden()
	return false
end

function modifier_dimm_ravage:IsPurgable()
    return false
end

function modifier_dimm_ravage:GetStatusEffectName()
    return "particles/status_fx/status_effect_faceless_chronosphere.vpcf"
end

function modifier_dimm_ravage:StatusEffectPriority()
    return 1000
end

function modifier_dimm_ravage:OnCreated()
    if IsServer () then
        local quantum_brake_effect = ParticleManager:CreateParticle ("particles/units/heroes/hero_faceless_void/faceless_void_chronosphere_warp.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
        ParticleManager:SetParticleControl (quantum_brake_effect, 0, self:GetParent ():GetAbsOrigin ())
        ParticleManager:SetParticleControl (quantum_brake_effect, 1, Vector (9999, 9999, 50))
        self:AddParticle( quantum_brake_effect, false, false, -1, false, true )
    end

end

function modifier_dimm_ravage:CheckState()
local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
    return state
end

function dimm_ravage:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

