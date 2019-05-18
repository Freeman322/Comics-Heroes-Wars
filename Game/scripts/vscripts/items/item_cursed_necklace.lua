LinkLuaModifier( "modifier_item_cursed_necklace", "items/item_cursed_necklace.lua", LUA_MODIFIER_MOTION_NONE )

if item_cursed_necklace == nil then item_cursed_necklace = class({}) end

function item_cursed_necklace:GetIntrinsicModifierName()
	return "modifier_item_cursed_necklace"
end

if modifier_item_cursed_necklace == nil then
	modifier_item_cursed_necklace = class({})
end

function modifier_item_cursed_necklace:IsHidden()
    return true 
end

function modifier_item_cursed_necklace:IsPurgable()
    return false
end


function modifier_item_cursed_necklace:DeclareFunctions() 
local funcs = {
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_HEALTH_BONUS,
    MODIFIER_PROPERTY_MANA_BONUS,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_CAST_RANGE_BONUS
}

return funcs
end

function modifier_item_cursed_necklace:OnTakeDamage( params )
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
        
        if not params.inflictor then
            return 0
        end

		local hAttacker = params.attacker
		local hVictim = params.unit
		local fDamage = params.damage

        if hVictim ~= nil and hAttacker ~= nil and hAttacker == self:GetCaster() and hAttacker:GetTeamNumber() ~= hVictim:GetTeamNumber() then
            if params.damage_type > 1 then 
                local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hVictim:GetOrigin(), hVictim, self:GetAbility():GetSpecialValueFor("splash_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
                if #units > 0 then
                    for _,unit in pairs(units) do
                        pcall(function()
                            ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)

                            ApplyDamage ( {
                                victim = unit,
                                attacker = self:GetParent(),
                                damage = fDamage * (self:GetAbility():GetSpecialValueFor("magical_splash") / 100),
                                damage_type = DAMAGE_TYPE_PURE,
                                ability = self:GetAbility(),
                                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
                            })
                        end)
                    end
                end				
			end
		end
	end

	return 0
end
function modifier_item_cursed_necklace:GetModifierConstantManaRegen( params ) return self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" ) end
function modifier_item_cursed_necklace:GetModifierBonusStats_Intellect( params ) return self:GetAbility():GetSpecialValueFor( "bonus_intellect" ) end
function modifier_item_cursed_necklace:GetModifierCastRangeBonus( params ) return self:GetAbility():GetSpecialValueFor( "cast_range_bonus" ) end
function modifier_item_cursed_necklace:GetModifierPercentageManacost( params ) return self:GetAbility():GetSpecialValueFor( "manacost_reduction" ) end
function modifier_item_cursed_necklace:GetModifierSpellAmplify_Percentage( params ) return self:GetAbility():GetSpecialValueFor( "spell_amp" ) end
function modifier_item_cursed_necklace:GetModifierManaBonus( params ) return self:GetAbility():GetSpecialValueFor( "mana_bonus" ) end
function modifier_item_cursed_necklace:GetModifierHealthBonus( params ) return self:GetAbility():GetSpecialValueFor( "health_bonus" ) end
