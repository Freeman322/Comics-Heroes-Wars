if not valkorion_illusion then valkorion_illusion = class({}) end
LinkLuaModifier( "modifier_valkorion_illusion", "abilities/valkorion_illusion.lua", LUA_MODIFIER_MOTION_NONE )

function valkorion_illusion:OnOwnerDied()
	if IsServer() then
          if self:IsActivated() and self:IsTrained() and self:GetCaster():IsRealHero() then
               local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {modifier = "modifier_valkorion_illusion", duration = self:GetCaster():GetRespawnTime(), outgoing_damage = 100, incoming_damage = 100}, 1, 1, true, true ) 
               illusion[1]:AddNewModifier(self:GetCaster(), self, "modifier_valkorion_illusion", nil)
               illusion[1]:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_tempest_double", nil)
               illusion[1]:Heal(self:GetCaster():GetMaxHealth(), self)
          end 
	end
end

modifier_valkorion_illusion = class({})

function modifier_valkorion_illusion:GetStatusEffectName()
	return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end

function modifier_valkorion_illusion:IsHidden()
	return true
end

function modifier_valkorion_illusion:DeclareFunctions() 
     local funcs = {
               MODIFIER_PROPERTY_TEMPEST_DOUBLE
     }
     return funcs
end

function modifier_valkorion_illusion:GetModifierTempestDouble( params )
    return 1
end

function modifier_valkorion_illusion:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_valkorion_illusion:IsPurgable()
	return false
end

function modifier_valkorion_illusion:OnCreated(table)
	if IsServer() then 
		local nFXIndex = ParticleManager:CreateParticle( "particles/dormammu/dormammu_tempest_double.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 7, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetOrigin(), true );
		self:AddParticle(nFXIndex, false, false, -1, false, false)
	end
end