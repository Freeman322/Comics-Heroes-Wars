draks_double_edge = class({})

function draks_double_edge:OnSpellStart()
local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
				if not hTarget:TriggerSpellAbsorb( self ) then
					local enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), hTarget:GetAbsOrigin(), self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
						for _, target in pairs(enemies) do
								local damage = self:GetSpecialValueFor("edge_damage") + self:GetCaster():GetStrength()*self:GetSpecialValueFor("damage_per_strength")
							
								if target ~= hTarget then
									damage = damage * (self:GetSpecialValueFor("damage_pct" / 100))
								end

								local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/centaur/dc_centaur_double_edge/_dc_centaur_double_edge.vpcf", PATTACH_CUSTOMORIGIN, nil );
								ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
								ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
								ParticleManager:SetParticleControlEnt( nFXIndex, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
								ParticleManager:SetParticleControlEnt( nFXIndex, 5, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
								ParticleManager:ReleaseParticleIndex( nFXIndex )

								EmitSoundOn( "Hero_Centaur.DoubleEdge", target )
								EmitSoundOn( "Hero_Centaur.DoubleEdge", self:GetCaster() )

								ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
						end
				end
		end
end
