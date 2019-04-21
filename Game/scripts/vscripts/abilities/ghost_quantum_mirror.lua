ghost_quantum_mirror = class({})
--------------------------------------------------------------------------------

function ghost_quantum_mirror:CastFilterResultTarget( hTarget )
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function ghost_quantum_mirror:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

--------------------------------------------------------------------------------

function ghost_quantum_mirror:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		local nFXIndex = ParticleManager:CreateParticle( "particles/ghost/quantum_mirror_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true);
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(300, 300, 0) );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn( "Hero_FacelessVoid.TimeDilation.Cast.ti7", self:GetCaster() )

		if IsServer() then 
			local duration = self:GetSpecialValueFor("illusion_duration")

			if self:GetCaster():HasTalent("special_bonus_unique_ghost_1") then
				duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_ghost_1") or 0)
			end

			local double = CreateUnitByName( hTarget:GetUnitName(), hTarget:GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
			double:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)

			local caster_level = hTarget:GetLevel()
			for i = 2, caster_level do double:HeroLevelUp(false) end

			for ability_id = 0, 15 do
				local ability = double:GetAbilityByIndex(ability_id)
				if ability then	
					ability:SetLevel(hTarget:GetAbilityByIndex(ability_id):GetLevel())
					ability:SetActivated(false)
				end
			end


			for item_id = 0, 5 do
				local item_in_caster = hTarget:GetItemInSlot(item_id)
				if item_in_caster ~= nil and not item_in_caster:IsDroppableAfterDeath() then
					local item_name = item_in_caster:GetName()
					if not (item_name == "item_aegis" or item_name == "item_smoke_of_deceit" or item_name == "item_recipe_refresher" or item_name == "item_refresher" or item_name == "item_ward_observer" or item_name == "item_ward_sentry") then
						local item_created = CreateItem( item_in_caster:GetName(), double, double)
						double:AddItem(item_created)
					end
				end
			end

			double:SetMaximumGoldBounty(0)
			double:SetMinimumGoldBounty(0)
			double:SetDeathXP(0)
			double:SetAbilityPoints(0) 

			double:SetHasInventory(false)
			double:SetCanSellItems(false)

			double:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_tempest_double", nil)
			double:AddNewModifier(self:GetCaster(), self, "modifier_kill", {["duration"] = duration})

			FindClearSpaceForUnit(double, double:GetAbsOrigin(), false)
		end
	end
end