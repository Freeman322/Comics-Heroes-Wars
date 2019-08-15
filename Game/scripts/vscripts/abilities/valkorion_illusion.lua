if not valkorion_illusion then valkorion_illusion = class({}) end
LinkLuaModifier( "modifier_valkorion_illusion", "abilities/valkorion_illusion.lua", LUA_MODIFIER_MOTION_NONE )

valkorion_illusion.m_hIllusion = nil

function valkorion_illusion:OnOwnerDied()
	if IsServer() then
		if self:IsActivated() and self:IsTrained() and self:GetCaster():IsRealHero() and self:IsCooldownReady() then
			if self.m_hIllusion and self.m_hIllusion:IsNull() == false then UTIL_Remove(m_hIllusion) end 
			
               self.m_hIllusion = CreateUnitByName( self:GetCaster():GetUnitName(), self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
			self.m_hIllusion:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)

			local caster_level = self:GetCaster():GetLevel()
			for i = 2, caster_level do
				self.m_hIllusion:HeroLevelUp(false)
			end

			for ability_id = 0, 15 do
				local ability = self.m_hIllusion:GetAbilityByIndex(ability_id)
				if ability then	
					ability:SetLevel(self:GetCaster():GetAbilityByIndex(ability_id):GetLevel())
					if ability:GetName() == "valkorion_illusion" then
						ability:SetActivated(false)
					end
				end
			end


			for item_id = 0, 5 do
				local item_in_caster = self:GetCaster():GetItemInSlot(item_id)
				if item_in_caster ~= nil and not item_in_caster:IsDroppableAfterDeath() then
					local item_name = item_in_caster:GetName()
					if not (item_name == "item_aegis" or item_name == "item_frostmourne") then
						local item_created = CreateItem( item_in_caster:GetName(), self.m_hIllusion, self.m_hIllusion)
						self.m_hIllusion:AddItem(item_created)
					end
				end
			end

			self.m_hIllusion:SetMaximumGoldBounty(0)
			self.m_hIllusion:SetMinimumGoldBounty(0)
			self.m_hIllusion:SetDeathXP(0)
			self.m_hIllusion:SetAbilityPoints(0) 

			self.m_hIllusion:SetHasInventory(false)
			self.m_hIllusion:SetCanSellItems(false)

			self.m_hIllusion:AddNewModifier(self:GetCaster(), self, "modifier_valkorion_illusion", nil)
			self.m_hIllusion:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_tempest_self.m_hIllusion", nil)
			self.m_hIllusion:AddNewModifier(self:GetCaster(), self, "modifier_kill", {["duration"] = self:GetCaster():GetLevel() * 2})

			EmitSoundOn("Hero_ArcWarden.Tempestself.m_hIllusion.FP", self.m_hIllusion)

			FindClearSpaceForUnit(self.m_hIllusion, self.m_hIllusion:GetAbsOrigin(), false)

			self:UseResources(false, false, true)
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