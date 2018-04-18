if item_infernal_circle == nil then item_infernal_circle = class({}) end

LinkLuaModifier( "modifier_item_infernal_circle", "items/item_infernal_circle.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_infernal_circle", "items/item_infernal_circle.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_infernal_circle:GetIntrinsicModifierName(args)
  return "modifier_item_infernal_circle"
end


function item_infernal_circle:CastFilterResultTarget( hTarget )
	if IsServer() then
    if self:GetCaster() == hTarget then
  		return UF_FAIL_CUSTOM
  	end
    
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function item_infernal_circle:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

function item_infernal_circle:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
    local duration = self:GetSpecialValueFor( "duration" )
    hTarget:AddNewModifier( self:GetCaster(), self, "modifier_infernal_circle", { duration = duration } )

    local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
  	ParticleManager:SetParticleControlEnt( nCasterFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
  	ParticleManager:ReleaseParticleIndex( nCasterFX )

  	local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
  	ParticleManager:SetParticleControlEnt( nTargetFX, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), false )
  	ParticleManager:ReleaseParticleIndex( nTargetFX )

		EmitSoundOn( "Hero_Oracle.PurifyingFlames", hTarget )
	end
end

if modifier_infernal_circle == nil then modifier_infernal_circle = class({}) end

function modifier_infernal_circle:IsHidden()
    return false
end

function modifier_infernal_circle:IsPurgable()
    return false
end

function modifier_infernal_circle:IsBuff()
    return true
end

function modifier_infernal_circle:GetEffectName()
    return "particles/items_fx/force_staff.vpcf"
end

function modifier_infernal_circle:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_infernal_circle:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_infernal_circle:OnTakeDamage (params)
    if IsServer() then
      if self:GetParent() == params.unit then
        local flDamage = params.damage

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_spectre/spectre_dispersion.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
    		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
    		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
    		ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOn ("Hero_Oracle.PurifyingFlames.Damage", self:GetParent())

        ApplyDamage ({ attacker = params.attacker, victim = self:GetCaster(), ability = self:GetAbility(), damage = flDamage / 2, damage_type = DAMAGE_TYPE_PURE })
        self:GetParent():Heal(flDamage/2, self:GetAbility())
      end
    end
end


if modifier_item_infernal_circle == nil then modifier_item_infernal_circle = class({}) end

function modifier_item_infernal_circle:IsHidden ()
    return true
end

function modifier_item_infernal_circle:IsPurgable()
    return false
end

function modifier_item_infernal_circle:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE
    }

    return funcs
end

function modifier_item_infernal_circle:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_strength")
end
function modifier_item_infernal_circle:GetModifierPhysicalArmorBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_armor" )
end
function modifier_item_infernal_circle:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end
function modifier_item_infernal_circle:GetModifierPercentageManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_regen" )
end
function modifier_item_infernal_circle:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_infernal_circle:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

