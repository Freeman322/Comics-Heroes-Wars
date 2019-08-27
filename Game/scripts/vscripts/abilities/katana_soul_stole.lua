LinkLuaModifier("modifier_katana_soul_stole", "abilities/katana_soul_stole.lua" , 0)

katana_soul_stole = class({})

function katana_soul_stole:OnHeroDiedNearby( hVictim, hKiller, kv )
	if hVictim == nil or hKiller == nil then
		return
	end

	if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() and hKiller == self:GetCaster() then
		local damage = self:GetSpecialValueFor("bonus_damage")

		self:GetCaster():FindModifierByName("modifier_katana_soul_stole"):IncrementStackCount()

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, damage, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_ti8_immortal_arms/doom_ti8_immortal_devour.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hVictim, PATTACH_POINT_FOLLOW, "attach_hitloc", hVictim:GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace.Arcana", hVictim)
	end
end

function katana_soul_stole:GetIntrinsicModifierName() return "modifier_katana_soul_stole" end

modifier_katana_soul_stole = class({})

function modifier_katana_soul_stole:IsPurgable()	return false end
function modifier_katana_soul_stole:IsHidden()	return false end
function modifier_katana_soul_stole:RemoveOnDeath() return false end

function modifier_katana_soul_stole:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_katana_soul_stole:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") * self:GetStackCount() end
