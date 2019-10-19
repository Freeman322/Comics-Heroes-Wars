pennywise_fear = class({})
LinkLuaModifier( "modifier_pennywise_fear", "abilities/pennywise_fear.lua",LUA_MODIFIER_MOTION_NONE )

---------------------------------------------------------------------------

function pennywise_fear:OnSpellStart()
	local radius = self:GetSpecialValueFor( "radius" ) 
	local duration = self:GetSpecialValueFor(  "duration" )

	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
	if #units > 0 then
		for _,unit in pairs(units) do
            unit:AddNewModifier( self:GetCaster(), self, "modifier_pennywise_fear", { duration = duration } )
            ApplyDamage({victim = unit, attacker = self:GetCaster(), ability = self, damage = self:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL})

            EmitSoundOn("Hero_Visage.GraveChill.Target", unit)
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN, "attach_hitloc", self:GetCaster():GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_ABSORIGIN, "attach_hitloc", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Visage.SummonFamiliars.Cast", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

if modifier_pennywise_fear == nil then modifier_pennywise_fear = class({}) end

function modifier_pennywise_fear:IsPurgable() return false end
function modifier_pennywise_fear:RemoveOnDeath() return true end
function modifier_pennywise_fear:IsHidden() return false end
function modifier_pennywise_fear:GetStatusEffectName() return "particles/status_fx/status_effect_terrorblade_reflection.vpcf" end
function modifier_pennywise_fear:StatusEffectPriority() return 1000 end

modifier_pennywise_fear._vLoc = nil

function modifier_pennywise_fear:OnCreated(params)
    if IsServer() then
        self._vLoc = self:GetParent():GetBasePos()

        self:GetParent():MoveToPosition(self._vLoc)
	end
end


function modifier_pennywise_fear:CheckState()
	local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_DOMINATED] = true,
        [MODIFIER_STATE_HEXED] = true
	}

	return state
end

