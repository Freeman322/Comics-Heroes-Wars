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
		--[[local clients = { [158527594] = true,[158527594] = true, [87670156] = true, [104473272] = true }
		if clients[PlayerResource:GetSteamAccountID(caster:GetPlayerOwnerID())] then
			 ---_G.Bolvar_helmet:RemoveSelf()
		end]]
		if self.caster_model == nil then
			self.caster_model = caster:GetModelName()
		end

		caster:SetOriginalModel("models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl")
		self.speed = caster:GetAttackSpeed()*2
	end
end

function modifier_elder_demon_form:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		local clients = { [158527594] = true,[158527594] = true, [87670156] = true, [104473272] = true }
		caster:SetModel(self.caster_model)
		caster:SetOriginalModel(self.caster_model)
		EmitSoundOn("Hero_AbyssalUnderlord.Pit.Target", caster)
		--[[[if clients[PlayerResource:GetSteamAccountID(caster:GetPlayerOwnerID())] then
			 _G.Bolvar_helmet = Attachments:AttachProp(caster, "attach_head", "models/heroes/bolvar/isecrown_helmet.vmdl", 0.4)
		end]]
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

