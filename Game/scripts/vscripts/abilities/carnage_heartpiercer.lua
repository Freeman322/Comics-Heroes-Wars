if not carnage_heartpiercer then carnage_heartpiercer = class({}) end
LinkLuaModifier( "modifier_carnage_heartpiercer", "abilities/carnage_heartpiercer.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_carnage_heartpiercer_debuff", "abilities/carnage_heartpiercer.lua", LUA_MODIFIER_MOTION_NONE )

function carnage_heartpiercer:GetIntrinsicModifierName()
	return "modifier_carnage_heartpiercer"
end

modifier_carnage_heartpiercer = class({})

function modifier_carnage_heartpiercer:IsHidden()
	return true
end

function modifier_carnage_heartpiercer:OnCreated()
	if IsServer() then
		
	end
end

function modifier_carnage_heartpiercer:IsPurgable()
	return false
end

function modifier_carnage_heartpiercer:RemoveOnDeath()
	return false
end

function modifier_carnage_heartpiercer:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_carnage_heartpiercer:OnAttackLanded (params)
	if IsServer() then
	    if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() then
			if RollPercentage(self:GetAbility():GetSpecialValueFor("chance_pct")) then 
				params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_carnage_heartpiercer_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
				EmitSoundOn("Hero_Pangolier.HeartPiercer", params.target)
		        self:GetAbility():UseResources(false, false, true)
		    end
	    end
	end
end

if modifier_carnage_heartpiercer_debuff == nil then modifier_carnage_heartpiercer_debuff = class({}) end 


function modifier_carnage_heartpiercer_debuff:IsPurgeException()
    return true
end

function modifier_carnage_heartpiercer_debuff:GetStatusEffectName()
    return "particles/units/heroes/hero_visage/status_effect_visage_chill_slow.vpcf"
end


function modifier_carnage_heartpiercer_debuff:StatusEffectPriority()
    return 1000
end


function modifier_carnage_heartpiercer_debuff:GetEffectName()
    return "particles/units/heroes/hero_pangolier/pangolier_heartpiercer_debuff.vpcf"
end


function modifier_carnage_heartpiercer_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_carnage_heartpiercer_debuff:OnCreated( kv )
    if IsServer() then
        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("damage_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #units > 0 then
			for _,unit in pairs(units) do
				
				local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
				ParticleManager:SetParticleControlEnt( nCasterFX, 0, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetOrigin(), false )
				ParticleManager:ReleaseParticleIndex( nCasterFX )

				EmitSoundOn("Hero_Pangolier.HeartPiercer.Creep", self:GetParent())
				EmitSoundOn("Hero_Pangolier.HeartPiercer.Proc", self:GetParent())
				EmitSoundOn("Hero_Pangolier.HeartPiercer.Proc.Creep", self:GetParent())
				
				unit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = 0.3 } )
				
				local damage = {
					victim = unit,
					attacker = self:GetCaster(),
					damage = self:GetAbility():GetSpecialValueFor( "damage" ),
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility()
				}
	
				ApplyDamage( damage )
			end
		end
    end
end


function modifier_carnage_heartpiercer_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end


function modifier_carnage_heartpiercer_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("slow_pct")
end
