if diablo_elder_demon_form == nil then diablo_elder_demon_form = class({}) end

LinkLuaModifier("modifier_elder_demon_form", "abilities/diablo_elder_demon_form.lua", LUA_MODIFIER_MOTION_NONE)

function diablo_elder_demon_form:OnSpellStart()
	local duration = self:GetSpecialValueFor(  "duration" )

	if self:GetCaster():HasTalent("special_bonus_unique_diablo_3") then
        duration = self:GetCaster():FindTalentValue("special_bonus_unique_diablo_3") + duration
	end
	
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_elder_demon_form", { duration = duration } )

	local nFXIndex = ParticleManager:CreateParticle( "particles/addons_gameplay/pit_lava_blast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Cancel", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

if modifier_elder_demon_form == nil then modifier_elder_demon_form = class({}) end

function modifier_elder_demon_form:RemoveOnDeath()
	return false
end

function modifier_elder_demon_form:HasCustomEcon()
	return self:GetCaster():HasModifier("modifier_freeza")
end

function modifier_elder_demon_form:IsPurgable()
	return false
end

function modifier_elder_demon_form:IsHidden()
	return false
end

function modifier_elder_demon_form:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf"
end

function modifier_elder_demon_form:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_elder_demon_form:OnCreated(table)
	if IsServer() then
		local caster = self:GetParent()

		self.speed = caster:GetAttackSpeed()*2

		if self:HasCustomEcon() then
			self:GetParent():SetMaterialGroup("gold")

			self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_6)
			
			EmitSoundOn("Freeza.Cast4", self:GetCaster())

			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			self:AddParticle( nFXIndex, false, false, -1, false, true )

			local nFXIndex1 = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/ti9_immortal_staff/cm_ti9_golden_staff_lvlup_globe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
			self:AddParticle( nFXIndex1, false, false, -1, false, true )

			Timers:CreateTimer(2.5, function()
				local nFXIndex = ParticleManager:CreateParticle( "particles/thanos/thanos_supernova_explode_a.vpcf", PATTACH_CUSTOMORIGIN, nil );
				ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
				ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin());
				ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin());
				ParticleManager:SetParticleControl( nFXIndex, 5, Vector(1000, 1000, 0));
				ParticleManager:ReleaseParticleIndex( nFXIndex );
			end)
			return 
		end

		if self.caster_model == nil then
			self.caster_model = caster:GetModelName()
		end

		caster:SetOriginalModel("models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl")
	end
end

function modifier_elder_demon_form:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		EmitSoundOn("Hero_AbyssalUnderlord.Pit.Target", caster)

		if self:HasCustomEcon() then
			self:GetParent():SetMaterialGroup("default")

			return 
		end

		caster:SetModel(self.caster_model)
		caster:SetOriginalModel(self.caster_model)
	end
end

function modifier_elder_demon_form:DeclareFunctions() --we want to use these functions in this item
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_elder_demon_form:GetModifierAttackSpeedBonus_Constant( params )
    return self.speed
end

function modifier_elder_demon_form:GetModifierHealthBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health" )
end

function modifier_elder_demon_form:GetModifierTotalDamageOutgoing_Percentage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage_outgoing" )
end

function modifier_elder_demon_form:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end

function modifier_elder_demon_form:GetModifierConstantManaRegen()
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_regen" )
end

function diablo_elder_demon_form:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

