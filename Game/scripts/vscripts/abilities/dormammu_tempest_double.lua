LinkLuaModifier( "modifier_dormammu_tempest_double", "abilities/dormammu_tempest_double.lua", LUA_MODIFIER_MOTION_NONE )

if dormammu_tempest_double == nil then dormammu_tempest_double = class({}) end 

function dormammu_tempest_double:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor("cooldown_scepter")
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function dormammu_tempest_double:OnSpellStart()
	if IsServer() then 
		local duration = self:GetSpecialValueFor("duration")
		local units = self:GetSpecialValueFor("count")

		if self:GetCaster():HasTalent("special_bonus_unique_dormammu_2") then
			units = units + 1 
		end

		if self:GetCaster():HasTalent("special_bonus_unique_dormammu") then
			duration = duration + 10
		end

		for i = 1, units do
			local double = CreateUnitByName( self:GetCaster():GetUnitName(), self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
			double:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)

			local caster_level = self:GetCaster():GetLevel()
			for i = 2, caster_level do
				double:HeroLevelUp(false)
			end


			for ability_id = 0, 15 do
				local ability = double:GetAbilityByIndex(ability_id)
				if ability then	
					ability:SetLevel(self:GetCaster():GetAbilityByIndex(ability_id):GetLevel())
					if ability:GetName() == "dormammu_tempest_double" then
						ability:SetActivated(false)
					end
				end
			end


			for item_id = 0, 5 do
				local item_in_caster = self:GetCaster():GetItemInSlot(item_id)
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

			double:AddNewModifier(self:GetCaster(), self, "modifier_dormammu_tempest_double", nil)
			double:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_tempest_double", nil)
			double:AddNewModifier(self:GetCaster(), self, "modifier_kill", {["duration"] = duration})

			EmitSoundOn("Hero_ArcWarden.TempestDouble.FP", double)

			FindClearSpaceForUnit(double, double:GetAbsOrigin(), false)
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() );
	ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin());
	ParticleManager:ReleaseParticleIndex( nFXIndex );

	EmitSoundOn("Hero_ArcWarden.TempestDouble", self:GetCaster())
end

modifier_dormammu_tempest_double = class({})

function modifier_dormammu_tempest_double:GetStatusEffectName()
	return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end

function modifier_dormammu_tempest_double:IsHidden()
	return true
end

function modifier_dormammu_tempest_double:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

function modifier_dormammu_tempest_double:GetModifierIncomingDamage_Percentage( params )
    return self:GetAbility():GetSpecialValueFor( "double_incoming_damage" )
end

function modifier_dormammu_tempest_double:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_dormammu_tempest_double:IsPurgable()
	return false
end

function modifier_dormammu_tempest_double:OnCreated(table)
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