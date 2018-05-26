LinkLuaModifier ("modifier_godspeed_tempest_double_scepter", "abilities/godspeed_tempest_double.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_godspeed_tempest_double", "abilities/godspeed_tempest_double.lua", LUA_MODIFIER_MOTION_NONE )

if not modifier_godspeed_tempest_double_scepter then modifier_godspeed_tempest_double_scepter = class({}) end

function modifier_godspeed_tempest_double_scepter:IsHidden()
	return true
end

function modifier_godspeed_tempest_double_scepter:IsPurgable()
	return false
end

function modifier_godspeed_tempest_double_scepter:RemoveOnDeath()
	return false
end

function modifier_godspeed_tempest_double_scepter:OnCreated(htable)
  if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_godspeed_tempest_double_scepter:OnIntervalThink()
    if IsServer() then
		local abil = self:GetParent():FindAbilityByName("godspeed_tempest_double")
		if abil then 
			if self:GetParent():HasScepter() and abil:IsHidden() == true then
				abil:SetHidden(false)
			end
			if not self:GetParent():HasScepter() and abil:IsHidden() == false then
				abil:SetHidden(true)
			end
		end
	end
end

if godspeed_tempest_double == nil then godspeed_tempest_double = class({}) end 

function godspeed_tempest_double:IsRefreshable()
    return false
end

function godspeed_tempest_double:OnSpellStart()
	if IsServer() then 
		local duration = self:GetSpecialValueFor("duration")

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
				if ability:GetName() == "godspeed_tempest_double" then
					ability:SetActivated(false)
				end
			end
		end


		for item_id = 0, 5 do
			local item_in_caster = self:GetCaster():GetItemInSlot(item_id)
			if item_in_caster ~= nil then
				local item_name = item_in_caster:GetName()
				local item_created = CreateItem( item_in_caster:GetName(), double, double)
				double:AddItem(item_created)
			end
		end

		double:SetMaximumGoldBounty(0)
		double:SetMinimumGoldBounty(0)
		double:SetDeathXP(0)
		double:SetAbilityPoints(0) 

		double:SetHasInventory(false)
		double:SetCanSellItems(false)

		double:AddNewModifier(self:GetCaster(), self, "modifier_godspeed_tempest_double", nil)
		double:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_tempest_double", nil)
		double:AddNewModifier(self:GetCaster(), self, "modifier_kill", {["duration"] = duration})

		EmitSoundOn("Hero_ArcWarden.TempestDouble.FP", double)

		FindClearSpaceForUnit(double, double:GetAbsOrigin(), false)

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() );
		ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin());
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn("Hero_ArcWarden.TempestDouble", self:GetCaster())
	end
end

modifier_godspeed_tempest_double = class({})

function modifier_godspeed_tempest_double:GetStatusEffectName()
	return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end

function modifier_godspeed_tempest_double:IsHidden()
	return true
end

function modifier_godspeed_tempest_double:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_godspeed_tempest_double:IsPurgable()
	return false
end

function modifier_godspeed_tempest_double:OnCreated(table)
	if IsServer() then 
	end
end

function modifier_godspeed_tempest_double:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_godspeed_tempest_double:GetModifierTotalDamageOutgoing_Percentage( params )
	return -50
end
