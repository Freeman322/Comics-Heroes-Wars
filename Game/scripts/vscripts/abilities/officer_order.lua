officer_order = class({})
LinkLuaModifier( "modifier_officer_order", "abilities/officer_order.lua", LUA_MODIFIER_MOTION_NONE )

local ALLOWED_UNITS = {}

ALLOWED_UNITS["npc_dota_officer_trooper"] = true
ALLOWED_UNITS["npc_dota_officer_assault"] = true
ALLOWED_UNITS["npc_dota_officer_assassin"] = true

--------------------------------------------------------------------------------
local PERMANENT_BONUS_HP = 100
local PERMANENT_BONUS_DAMAGE = 15
local PERMANENT_BONUS_ATTACK_TIME = 0.1


function officer_order:OnSpellStart()
    local radius = self:GetSpecialValueFor(  "radius" )

    if self:GetCaster():HasScepter() then
        radius = self:GetSpecialValueFor(  "radius_scepter" )
    end

    local duration = self:GetSpecialValueFor(  "duration" )

    if self:GetCaster():HasTalent("special_bonus_unique_officer_1") then duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_officer_1") end

    local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
    if #allies > 0 then
        for _,ally in pairs(allies) do
            if ALLOWED_UNITS[ally:GetUnitName()] or ally:IsCreep()  then
                ally:SetBaseMaxHealth(ally:GetBaseMaxHealth() + PERMANENT_BONUS_HP)
                ally:SetBaseDamageMax(ally:GetBaseDamageMax() + PERMANENT_BONUS_DAMAGE)
                ally:SetBaseAttackTime(ally:GetBaseAttackTime() - PERMANENT_BONUS_ATTACK_TIME)

                ally:AddNewModifier( self:GetCaster(), self, "modifier_officer_order", { duration = duration } )
            end
        end
    end

    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )

    self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_1 );
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if modifier_officer_order == nil then modifier_officer_order = class({}) end

--------------------------------------------------------------------------------

function modifier_officer_order:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end


function modifier_officer_order:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_officer_order:GetModifierPreAttack_BonusDamage( params ) return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_officer_order:GetModifierAttackSpeedBonus_Constant( params ) return self:GetAbility():GetSpecialValueFor("attack_speed") end

function modifier_officer_order:OnAttackLanded( params ) 
    if IsServer() then
        if params.attacker == self:GetParent() and self:GetCaster():HasTalent("special_bonus_unique_officer_1") then
            self:GetCaster():PerformAttack(params.target, true, true, true, true, false, false, true)
        end
    end 
end
