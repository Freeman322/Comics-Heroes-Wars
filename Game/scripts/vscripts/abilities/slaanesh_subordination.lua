if slaanesh_subordination == nil then slaanesh_subordination = class({}) end
LinkLuaModifier("modifier_slaanesh_subordination", "abilities/slaanesh_subordination.lua", LUA_MODIFIER_MOTION_NONE)

function slaanesh_subordination:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function slaanesh_subordination:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

function slaanesh_subordination:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hCaster == nil or hTarget == nil then
		return
	end

	EmitSoundOn( "Hero_DeathProphet.Silence", hCaster )
  	
  	hTarget:AddNewModifier(hCaster, self, "modifier_slaanesh_subordination", {duration = self:GetSpecialValueFor("duration")})
end

if modifier_slaanesh_subordination == nil then modifier_slaanesh_subordination = class({}) end

function modifier_slaanesh_subordination:IsPurgable()
    return false
end

function modifier_slaanesh_subordination:IsHidden()
    return true
end

function modifier_slaanesh_subordination:GetEffectName()
	if self:GetCaster():HasModifier("modifier_voland_custom") then return "particles/voland_ability.vpcf" end  
    return "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher_debuff.vpcf"
end

function modifier_slaanesh_subordination:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_slaanesh_subordination:OnCreated(params)
    if IsServer() then
    	EmitSoundOn( "Hero_Bane.Nightmare.Loop", hTarget )
    end
end

function modifier_slaanesh_subordination:OnDestroy()
    if IsServer() then
        local hTarget = self:GetParent()
        EmitSoundOn("Hero_DarkWillow.Shadow_Realm.Damage", self:GetParent())
        local pop_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget)
        ParticleManager:SetParticleControl(pop_pfx, 0, hTarget:GetAbsOrigin())
        ParticleManager:SetParticleControl(pop_pfx, 1, Vector(100, 0, 0))
        ParticleManager:ReleaseParticleIndex(pop_pfx)
    end
end

function modifier_slaanesh_subordination:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end


function modifier_slaanesh_subordination:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_slaanesh_subordination:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("movement_speed")
end
function modifier_slaanesh_subordination:GetModifierIncomingDamage_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("incoming_damage")
end

function slaanesh_subordination:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_voland_custom") then return "custom/voland_subordination" end  
	return self.BaseClass.GetAbilityTextureName(self)  
end