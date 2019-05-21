if overvoid_blink == nil then overvoid_blink = class({}) end


function overvoid_blink:GetBehavior() 
	local behav = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	return behav
end

function overvoid_blink:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end


function overvoid_blink:OnSpellStart()
	local hCaster = self:GetCaster() --We will always have Caster.
	local vPoint = self:GetCursorPosition() --We will always have Vector for the point.
	local vOrigin = hCaster:GetAbsOrigin() --Our caster's location
	local nMaxBlink = self:GetSpecialValueFor( "blink_range" ) --How far can we actually blink?
	local nClamp = self:GetSpecialValueFor( "blink_range" ) --How far can we actually blink?
	if vPoint then
		self:Blink(hCaster, vPoint, nMaxBlink, nClamp) --BLINK!
	end	
end


function overvoid_blink:Blink(hTarget, vPoint, nMaxBlink, nClamp)
	local vOrigin = hTarget:GetAbsOrigin() --Our units's location
	ProjectileManager:ProjectileDodge(hTarget)  --We disjoint disjointable incoming projectiles.
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hTarget) --Create particle effect at our caster.
	hTarget:EmitSound("DOTA_Item.BlinkDagger.Activate") --Emit sound for the blink
	local vDiff = vPoint - vOrigin --Difference between the points
	if vDiff:Length2D() > nMaxBlink then  --Check caster is over reaching.
		vPoint = vOrigin + (vPoint - vOrigin):Normalized() * nClamp -- Recalculation of the target point.
	end
	hTarget:SetAbsOrigin(vPoint) --We move the caster instantly to the location
	FindClearSpaceForUnit(hTarget, vPoint, false) --This makes sure our caster does not get stuck
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, hTarget) --Create particle effect at our caster.
	local units = FindUnitsInRadius(hTarget:GetTeamNumber(), vPoint, nil, self:GetSpecialValueFor("damage_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)

    -- Calculate the position of each found unit in relation to the center
	for i,unit in ipairs(units) do
		ParticleManager:CreateParticle ("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_POINT_FOLLOW, unit)
		EmitSoundOn("Hero_ObsidianDestroyer.AstralImprisonment.Cast", unit)

		ApplyDamage({victim = unit, attacker = hTarget, ability = self, damage = self:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS})
	end
end

function overvoid_blink:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

