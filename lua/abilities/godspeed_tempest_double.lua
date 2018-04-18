LinkLuaModifier ("modifier_godspeed_tempest_double_scepter", "abilities/godspeed_tempest_double.lua", LUA_MODIFIER_MOTION_NONE)

--[[
if not godspeed_tempest_double then godspeed_tempest_double = class({}) end
function godspeed_tempest_double:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
LinkLuaModifier ("modifier_godspeed_tempest_double", "abilities/godspeed_tempest_double.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_godspeed_tempest_double_scepter", "abilities/godspeed_tempest_double.lua", LUA_MODIFIER_MOTION_NONE)

function godspeed_tempest_double:GetIntrinsicModifierName()
	return "modifier_godspeed_tempest_double_scepter"
end

function godspeed_tempest_double:OnSpellStart()
	local caster = self:GetCaster()
	local spawn_location = caster:GetOrigin()
	local duration = self:GetSpecialValueFor("duration")

	local double = CreateUnitByName( caster:GetUnitName(), spawn_location, true, caster, caster:GetOwner(), caster:GetTeamNumber())
	double:SetControllableByPlayer(caster:GetPlayerID(), false)

	local caster_level = caster:GetLevel()
	for i = 2, caster_level do
		double:HeroLevelUp(false)
	end

	local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster () )
	ParticleManager:SetParticleControl (nFXIndex, 0, Vector (0, 0, 0))
	ParticleManager:SetParticleControl (nFXIndex, 1, Vector (250, 250, 250))
	EmitSoundOn ("Hero_FacelessVoid.TimeDilation.Cast", self:GetCaster () )

	for ability_id = 0, 15 do
		local ability = double:GetAbilityByIndex(ability_id)
		if ability then

			ability:SetLevel(caster:GetAbilityByIndex(ability_id):GetLevel())
			if ability:GetName() == "godspeed_tempest_double" then
				ability:SetActivated(false)
			end
		end
	end


	for item_id = 0, 5 do
		local item_in_caster = caster:GetItemInSlot(item_id)
		if item_in_caster ~= nil then
			local item_name = item_in_caster:GetName()
			if not (item_name == "item_aegis" or item_name == "item_smoke_of_deceit" or item_name == "item_recipe_refresher" or item_name == "item_refresher" or item_name == "item_ward_observer" or item_name == "item_ward_sentry") then
				local item_created = CreateItem( item_in_caster:GetName(), double, double)
				double:AddItem(item_created)
				item_created:SetCurrentCharges(item_in_caster:GetCurrentCharges())
			end
		end
	end

	double:SetMaximumGoldBounty(0)
	double:SetMinimumGoldBounty(0)
	double:SetDeathXP(0)
	double:SetAbilityPoints(0)

	double:SetHasInventory(false)
	double:SetCanSellItems(false)

	double:AddNewModifier(caster, self, "modifier_godspeed_tempest_double", nil)
	double:AddNewModifier(caster, self, "modifier_kill", {["duration"] = duration})

end

modifier_godspeed_tempest_double = class({})

function modifier_godspeed_tempest_double:DeclareFunctions()
	return {MODIFIER_PROPERTY_SUPER_ILLUSION, MODIFIER_PROPERTY_ILLUSION_LABEL, MODIFIER_PROPERTY_IS_ILLUSION, MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function modifier_godspeed_tempest_double:GetIsIllusion()
	return true
end

function modifier_godspeed_tempest_double:GetModifierSuperIllusion()
	return true
end

function modifier_godspeed_tempest_double:GetModifierIllusionLabel()
	return true
end

function modifier_godspeed_tempest_double:OnTakeDamage( event )
	if event.unit:IsAlive() == false and event.unit == self:GetParent() then
		event.unit:MakeIllusion()
	end
end

function modifier_godspeed_tempest_double:GetStatusEffectName()
	return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end

function modifier_godspeed_tempest_double:IsHidden()
	return true
end

function modifier_godspeed_tempest_double:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end--]]

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
    		local abil = self:GetParent():FindAbilityByName("arc_warden_tempest_double")
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
