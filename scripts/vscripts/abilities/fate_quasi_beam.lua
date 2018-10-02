fate_quasi_beam = class({})
LinkLuaModifier( "modifier_fate_quasi_beam", "abilities/fate_quasi_beam.lua", LUA_MODIFIER_MOTION_NONE )

function fate_quasi_beam:OnSpellStart()
	if IsServer() then 
		local hCaster = self:GetCaster()
		local hTarget = self:GetCursorTarget()

    local duration = self:GetSpecialValueFor("hero_teleport_delay")
    if self:GetCaster():HasTalent("special_bonus_unique_fate_5") then duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_fate_5") or 0) end

		if hTarget then hTarget:AddNewModifier(hCaster, self, "modifier_fate_quasi_beam", {duration = duration}) end 
		
		EmitSoundOn( "Hero_Chen.TestOfFaith.Cast", hCaster )
		EmitSoundOn( "Hero_Chen.TestOfFaith.Target", hTarget )
	end
end

if modifier_fate_quasi_beam == nil then modifier_fate_quasi_beam = class({}) end 

function modifier_fate_quasi_beam:IsPurgable()
	return false
end

function modifier_fate_quasi_beam:RemoveOnDeath()
	return true
end

function modifier_fate_quasi_beam:OnCreated(table)
	if IsServer() then
        local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl( pfx, 0, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( pfx, 1, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( pfx, 3, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( pfx, 4, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( pfx, 5, Vector(200, 200, 0) )
        ParticleManager:SetParticleControl( pfx, 16, Vector(200, 200, 0) )
        self:AddParticle(pfx, false, false, -1, false, false)
    end
end

function modifier_fate_quasi_beam:OnDestroy()
	if IsServer() then
  		EmitSoundOn("Hero_Chen.HolyPersuasionCast", self:GetParent())

  		local fountains = Entities:FindAllByClassname("ent_dota_fountain")
  		for _, fountain in pairs(fountains) do
  			if fountain and fountain:GetTeamNumber() == self:GetParent():GetTeamNumber() then 
  				self:GetParent():SetAbsOrigin(fountain:GetAbsOrigin()) 
  				FindClearSpaceForUnit(self:GetParent(), fountain:GetAbsOrigin(), true)
  			end 
  		end
    end
end

function modifier_fate_quasi_beam:GetStatusEffectName()
	return "particles/econ/items/slardar/slardar_takoyaki_gold/status_effect_slardar_crush_tako_gold.vpcf"
end

function modifier_fate_quasi_beam:StatusEffectPriority()
	return 1000
end

function modifier_fate_quasi_beam:GetEffectName()
	return "particles/econ/courier/courier_huntling_gold/courier_huntling_gold_ambient.vpcf"
end

function modifier_fate_quasi_beam:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
