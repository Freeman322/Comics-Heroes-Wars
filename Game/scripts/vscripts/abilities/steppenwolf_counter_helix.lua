LinkLuaModifier( "modifier_steppenwolf_counter_helix", "abilities/steppenwolf_counter_helix.lua", LUA_MODIFIER_MOTION_NONE )
if steppenwolf_counter_helix == nil then steppenwolf_counter_helix = class({}) end 

function steppenwolf_counter_helix:GetIntrinsicModifierName()
	return "modifier_steppenwolf_counter_helix"
end

function steppenwolf_counter_helix:OnUpgrade()
	if IsServer() then 
		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2)
		EmitSoundOn("Hero_Axe.BerserkersCall.Item.Shoutmask", self:GetCaster())
	end
end


if modifier_steppenwolf_counter_helix == nil then modifier_steppenwolf_counter_helix = class({}) end 


function modifier_steppenwolf_counter_helix:IsHidden()
	return true
end


function modifier_steppenwolf_counter_helix:GetEffectName()
	return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end


function modifier_steppenwolf_counter_helix:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_steppenwolf_counter_helix:IsPurgable()
	return false
end

function modifier_steppenwolf_counter_helix:RemoveOnDeath()
	return false
end

function modifier_steppenwolf_counter_helix:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_steppenwolf_counter_helix:OnTakeDamage(params)
	if IsServer() then
	    if params.unit == self:GetParent() then
			local target = params.target
			if RollPercentage(self:GetAbility():GetSpecialValueFor("trigger_chance")) and self:GetAbility():IsCooldownReady() then
				self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_3)
				EmitSoundOn("Hero_Axe.CounterHelix", self:GetCaster())

				local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_weapon_practos/axe_attack_blur_counterhelix_practos.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() );
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
				ParticleManager:ReleaseParticleIndex( nFXIndex );

				local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() );
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_OVERHEAD_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true );
				ParticleManager:ReleaseParticleIndex( nFXIndex );

				local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
				if #units > 0 then
					for _,unit in pairs(units) do

						unit:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 0.03 } )

						local damage = {
							victim = unit,
							attacker = self:GetCaster(),
							damage = self:GetAbility():GetAbilityDamage(),
							damage_type = self:GetAbility():GetAbilityDamageType(),
							ability = self:GetAbility()
						}

						EmitSoundOn("Hero_Axe.CounterHelix_Blood_Chaser", unit)

						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_culling_blade.vpcf", PATTACH_CUSTOMORIGIN, unit );
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
						ParticleManager:ReleaseParticleIndex( nFXIndex );						
						
						self:GetParent():PerformAttack(unit, true, true, true, true, false, false, false)
						
						ApplyDamage( damage )
					end
				end

				self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
			end
	    end
	end
end