LinkLuaModifier( "modifier_item_eye_of_terror", "items/item_eye_of_terror.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_eye_of_terror_active", "items/item_eye_of_terror.lua", LUA_MODIFIER_MOTION_NONE )

if item_eye_of_terror == nil then
	item_eye_of_terror = class({})
end

function item_eye_of_terror:GetIntrinsicModifierName()
	return "modifier_item_eye_of_terror"
end


function item_eye_of_terror:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function item_eye_of_terror:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

function item_eye_of_terror:OnSpellStart()
	local hTarget = self:GetCursorTarget()
    local hCaster = self:GetCaster()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
             local info = {
                EffectName = "particles/items_fx/ethereal_blade.vpcf",
                Ability = self,
                iMoveSpeed = 6000,
                Source = hCaster,
                Target = hTarget,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
          }
            EmitSoundOn( "DOTA_Item.EtherealBlade.Activate", self:GetCaster() )
                      
            ProjectileManager:CreateTrackingProjectile( info )  

            hTarget:AddNewModifier( hCaster, self, "modifier_stunned", {duration = 0.3} )
       end
    end
end

--------------------------------------------------------------------------------

function item_eye_of_terror:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "DOTA_Item.EtherealBlade.Target", hTarget )
        local ghost_duration = self:GetSpecialValueFor( "duration" )
        
		local damage = self:GetSpecialValueFor( "blast_stats_multiplier" ) * (self:GetCaster():GetAgility() + self:GetCaster():GetStrength() + self:GetCaster():GetIntellect())

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_item_eye_of_terror_active", { duration = ghost_duration } )
	end

	return true
end

if modifier_item_eye_of_terror == nil then
	modifier_item_eye_of_terror = class({})
end

function modifier_item_eye_of_terror:IsHidden()
    return true 
end

function modifier_item_eye_of_terror:IsPurgable()
    return false
end


function modifier_item_eye_of_terror:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_HEALTH_BONUS,
    MODIFIER_PROPERTY_MANA_BONUS,
    ---MODIFIER_EVENT_ON_TAKEDAMAGE
}

return funcs
end


function modifier_item_eye_of_terror:OnTakeDamage( params )
	if IsServer() then
		if self:GetCaster() == nil then
			return 0
		end

		if self:GetCaster():PassivesDisabled() then
			return 0
		end

		if self:GetCaster() ~= self:GetParent() then
			return 0
		end

		local hAttacker = params.attacker
		local hVictim = params.unit
		local fDamage = params.damage

        if hVictim ~= nil and hAttacker ~= nil and hAttacker == self:GetCaster() and hAttacker:GetTeamNumber() ~= hVictim:GetTeamNumber() then
            print(params.damage_type)
            if params.damage_type > 1 then 
                local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hVictim:GetOrigin(), hVictim, self:GetAbility():GetSpecialValueFor("magical_splash_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
                if #units > 0 then
                    for _,unit in pairs(units) do
                        ApplyDamage ( {
                            victim = unit,
                            attacker = self:GetParent(),
                            damage = fDamage * (self:GetAbility():GetSpecialValueFor("magical_splash_ammount") / 100),
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            ability = self:GetAbility(),
                            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
                        })
                        EmitSoundOn( "Hero_Oracle.FalsePromise.Healed", units )
                        ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, units)
                    end
                end				
			end
		end
	end

	return 0
end

function modifier_item_eye_of_terror:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_strength" )
end

function modifier_item_eye_of_terror:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_intellect" )
end
function modifier_item_eye_of_terror:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_agility" )
end

function modifier_item_eye_of_terror:GetModifierPercentageManacost( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "manacost_reduction" ) 
end

function modifier_item_eye_of_terror:GetModifierSpellAmplify_Percentage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "spell_amp" )
end

function modifier_item_eye_of_terror:GetModifierManaBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "mana_bonus" )
end

function modifier_item_eye_of_terror:GetModifierHealthBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "health_bonus" )
end

if modifier_item_eye_of_terror_active == nil then 
	modifier_item_eye_of_terror_active = class({})
end

function modifier_item_eye_of_terror_active:IsHidden() 
	return false
end

function modifier_item_eye_of_terror_active:IsBuff ()
    return false
end

function modifier_item_eye_of_terror_active:GetStatusEffectName ()
    return "particles/status_fx/status_effect_ghost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_eye_of_terror_active:StatusEffectPriority ()
    return 1000
end

--------------------------------------------------------------------------------

function modifier_item_eye_of_terror_active:GetEffectName ()
    return "particles/items_fx/ghost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_eye_of_terror_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_eye_of_terror_active:GetTexture ()
    return "item_eye_of_terror"
end

function modifier_item_eye_of_terror_active:IsPurgable ()
    return false
end

function modifier_item_eye_of_terror_active:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE

    }

    return funcs
end

function modifier_item_eye_of_terror_active:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end


function modifier_item_eye_of_terror_active:GetModifierMoveSpeedBonus_Percentage (params)
    return -90
end

function modifier_item_eye_of_terror_active:GetModifierIncomingDamage_Percentage (params)
    return 100
end
