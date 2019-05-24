LinkLuaModifier("modifier_sargeras_annihilation", "abilities/sargeras_annihilation.lua", LUA_MODIFIER_MOTION_NONE)
if sargeras_annihilation == nil then
	sargeras_annihilation = class({})
end

function sargeras_annihilation:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_NO_TARGET
	return behav
end
function sargeras_annihilation:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_sargeras_arcana") then
		return "custom/sargeras_arcana"
	end
	return "custom/sargeras_annihilation"
end

function sargeras_annihilation:OnSpellStart()
	if IsServer() then
		local iAoE = self:GetSpecialValueFor( "range_tooltip" )
		
		local particle = "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf"

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "sargeras_devourer_of_words") then
			particle = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf"
		end

		local nFXIndex = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), iAoE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 2*#enemies, 1, 1 ) )
			for _,hTarget in pairs(enemies) do
				if hTarget ~= nil and not hTarget:IsInvulnerable() then
					EmitSoundOnLocationWithCaster( hTarget:GetOrigin(), "Hero_EarthShaker.EchoSlamSmall", hTarget )
					local damage = {
						victim = hTarget,
						attacker = self:GetCaster(),
						damage = #enemies*self:GetSpecialValueFor("damage_per_unit"),
						damage_type = self:GetAbilityDamageType(),
						ability = self
					}
					local dur = #enemies*self:GetSpecialValueFor("duration_per_unit")
					if dur >= self:GetSpecialValueFor("max_duration") then
						dur = 12
					end
					hTarget:AddNewModifier(hTarget, self, "modifier_sargeras_annihilation", {duration = dur})
					ApplyDamage( damage )
				end
			end
		else
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 1, 1 ) )
		end
		
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_EarthShaker.EchoSlam", self:GetCaster() )

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "sargeras_devourer_of_words") then
			local nFXIndex = ParticleManager:CreateParticle( "particles/hero_sargeras/sargeras_arcana_cast.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( iAoE, 1, 1 ) )
			ParticleManager:SetParticleControl( nFXIndex, 10, Vector( 10, 1, 1 ) )
			ParticleManager:SetParticleControl( nFXIndex, 11, Vector( 4, 1, 1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn("Sargeras.WD.Layer", self:GetCaster())
			EmitSoundOn("Sargeras.WD.CastUlti", self:GetCaster())
			EmitSoundOn("Sargeras.WD.CastUlti_Layer", self:GetCaster())
		end
	end
end

if modifier_sargeras_annihilation == nil then
	modifier_sargeras_annihilation = class({})
end

function modifier_sargeras_annihilation:OnCreated( kv )
	if IsServer() then
		local hAbility = self:GetAbility()
		local iAoE = hAbility:GetSpecialValueFor( "echo_slam_echo_range" )
		local iDamage = hAbility:GetSpecialValueFor( "echo_slam_echo_damage" )

		local particle = "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf"
		
		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "sargeras_devourer_of_words") then
			particle = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf"
		end

		local nFXIndex = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( iAoE, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		self:StartIntervalThink(0.1)
	end
end

function modifier_sargeras_annihilation:IsHidden()
	return false
end

function modifier_sargeras_annihilation:IsPurgable()
	return false
end

function modifier_sargeras_annihilation:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local iDamage = hAbility:GetSpecialValueFor( "burn_damage" )

		local damage = {
			victim = self:GetParent(),
			attacker = hAbility:GetCaster(),
			damage = iDamage/10,
			damage_type = DAMAGE_TYPE_PURE,
			ability = hAbility
		}
		ApplyDamage( damage )
	end
end

function modifier_sargeras_annihilation:GetEffectName()
	if self:GetCaster():HasModifier("modifier_sargeras_s7_custom") then return "particles/hero_sargeras/sargeras_arcana_target.vpcf" end 

	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_sargeras_annihilation:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function sargeras_annihilation:GetAbilityTextureName() if self:GetCaster():HasModifier("modifier_sargeras_s7_custom") then return "custom/sargeras_annihilation_custom" end return self.BaseClass.GetAbilityTextureName(self)  end 

