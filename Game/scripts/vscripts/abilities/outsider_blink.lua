outsider_blink = class({})

function outsider_blink:OnSpellStart()
	local caster = self:GetCaster()
	ProjectileManager:ProjectileDodge(caster)  --Disjoints disjointable incoming projectiles.

	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, caster)
	EmitSoundOn("DOTA_Item.BlinkDagger.Activate", caster)

	local origin_point = caster:GetAbsOrigin()
	local target_point = caster:GetCursorPosition()
	local difference_vector = target_point - origin_point

	caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(caster, target_point, false)

	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)
end

function outsider_blink:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

