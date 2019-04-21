if franklin_global_retrocausality == nil then franklin_global_retrocausality = class({}) end

LinkLuaModifier( "modifier_franklin_global_retrocausality_friendly", "abilities/franklin_global_retrocausality.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_franklin_global_retrocausality_target", "abilities/franklin_global_retrocausality.lua", LUA_MODIFIER_MOTION_NONE )

function franklin_global_retrocausality:IsRefreshable() return true end
function franklin_global_retrocausality:IsStealable() return false end
 
local CONST_COOLDOWN_NOT_REDUC = 185

function franklin_global_retrocausality:OnSpellStart()
	local duration = self:GetSpecialValueFor(  "tooltip_duration" )
	local hTarget = self:GetCursorTarget()

	if hTarget then 
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_franklin_global_retrocausality_target", { duration = duration } )

			local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
			if #units > 0 then
				for _,unit in pairs(units) do
					unit:AddNewModifier( self:GetCaster(), self, "modifier_franklin_global_retrocausality_friendly", { duration = duration, target = hTarget:entindex() } )
				end
			end

			EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse.Cast", self:GetCaster())
		end 
	end
end

if modifier_franklin_global_retrocausality_friendly == nil then modifier_franklin_global_retrocausality_friendly = class({}) end


function modifier_franklin_global_retrocausality_friendly:IsPurgable()
    return false
end

function modifier_franklin_global_retrocausality_friendly:IsHidden()
    return true
end

function modifier_franklin_global_retrocausality_friendly:IsPurgable()
	return false
end

function modifier_franklin_global_retrocausality_friendly:RemoveOnDeath()
	return true
end


function modifier_franklin_global_retrocausality_friendly:GetStatusEffectName()
	return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end


function modifier_franklin_global_retrocausality_friendly:StatusEffectPriority()
	return 1000
end

function modifier_franklin_global_retrocausality_friendly:GetHeroEffectName()
	return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

function modifier_franklin_global_retrocausality_friendly:HeroEffectPriority()
	return 100
end

function modifier_franklin_global_retrocausality_friendly:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_armor_friend_ring.vpcf"
end

function modifier_franklin_global_retrocausality_friendly:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_franklin_global_retrocausality_friendly:OnCreated(params)
	if IsServer() then
	    local warp = ParticleManager:CreateParticleForPlayer("particles/hero_franklin/franklin_global_retrocausality_screen.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
		self:AddParticle( warp, false, false, -1, false, true )
		
		self.target = params.target

  	end
end

function modifier_franklin_global_retrocausality_friendly:GetTarget()
	return self.target
end


function modifier_franklin_global_retrocausality_friendly:OnDestroy()
	if IsServer() then
    	EmitSoundOn("Hero_Oracle.FalsePromise.FP", self:GetParent())
  	end
end

function modifier_franklin_global_retrocausality_friendly:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }

    return funcs
end

function modifier_franklin_global_retrocausality_friendly:GetModifierTotalDamageOutgoing_Percentage ( params )
    return self:GetAbility():GetSpecialValueFor("bonus_damage_outgoing")
end

if modifier_franklin_global_retrocausality_target == nil then modifier_franklin_global_retrocausality_target = class({}) end 

function modifier_franklin_global_retrocausality_target:IsPurgable()
    return false
end

function modifier_franklin_global_retrocausality_target:IsHidden()
    return true
end

function modifier_franklin_global_retrocausality_target:IsPurgable()
	return false
end

function modifier_franklin_global_retrocausality_target:RemoveOnDeath()
	return true
end
