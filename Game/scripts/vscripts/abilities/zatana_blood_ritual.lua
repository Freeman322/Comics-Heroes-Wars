zatana_blood_ritual = class({})

function zatana_blood_ritual:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function zatana_blood_ritual:OnSpellStart() 
	local caster = self:GetCaster()
	local target = caster:GetCursorPosition() 
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetAbilityDamage()

	local effect = ParticleManager:CreateParticle("particles/hero_zatana/zatana_ritual_a.vpcf", PATTACH_WORLDORIGIN, nil) 
	ParticleManager:SetParticleControl(effect, 0, target)
	ParticleManager:ReleaseParticleIndex( effect );

	EmitSoundOn("Hero_DeathProphet.Silence", caster) 

	local nearby_enemy_units = FindUnitsInRadius(caster:GetTeam(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i, nearby_enemy in ipairs(nearby_enemy_units) do  --Restore health and play a particle effect for every found ally.
		nearby_enemy:AddNewModifier(caster, self, "modifier_silence", {duration = self:GetSpecialValueFor("duration")})
		local table = {attacker = caster, victim = nearby_enemy, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL}
		ApplyDamage(table) 
	end

	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "sailor") then EmitSoundOn( "Sailor.Cast3", self:GetCaster() ) end
	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "rat") then EmitSoundOn("Rat.Cast", self:GetCaster()) end
end
function zatana_blood_ritual:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

