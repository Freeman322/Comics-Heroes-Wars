if franklin_mischief == nil then franklin_mischief = class({}) end
LinkLuaModifier("modifier_franklin_mischief", "abilities/franklin_mischief.lua", LUA_MODIFIER_MOTION_NONE)

function franklin_mischief:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function franklin_mischief:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

function franklin_mischief:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end


function franklin_mischief:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hCaster == nil or hTarget == nil then
		return
	end

	hTarget:Interrupt()

	local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nTargetFX )

	EmitSoundOn( "Hero_ShadowShaman.Hex.Target", hCaster )
	EmitSoundOn( "Hero_ShadowShaman.SheepHex.Target", hTarget )
  	
  	hTarget:AddNewModifier(hCaster, self, "modifier_franklin_mischief", {duration = self:GetSpecialValueFor("duration")})
end

if modifier_franklin_mischief == nil then modifier_franklin_mischief = class({}) end

function modifier_franklin_mischief:IsPurgable()
    return false
end

function modifier_franklin_mischief:IsHidden()
    return true
end

function modifier_franklin_mischief:OnCreated(params)
	if IsServer() then
  end
end

function modifier_franklin_mischief:OnDestroy()
	if IsServer() then
    EmitSoundOn("DOTA_Item.Armlet.DeActivate", self:GetParent())
  end
end

function modifier_franklin_mischief:CheckState()
	local state = {
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end


function modifier_franklin_mischief:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}

	return funcs
end

function modifier_franklin_mischief:GetModifierModelChange( params )
	return "models/items/hex/sheep_hex/sheep_hex.vmdl"
end
function modifier_franklin_mischief:GetModifierMoveSpeed_Absolute( params )
	return self:GetAbility():GetSpecialValueFor("movement_speed")
end
function modifier_franklin_mischief:GetModifierMoveSpeed_Limit( params )
	return self:GetAbility():GetSpecialValueFor("movement_speed")
end
function modifier_franklin_mischief:GetModifierMoveSpeed_Max( params )
	return self:GetAbility():GetSpecialValueFor("movement_speed")
end

function franklin_mischief:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

