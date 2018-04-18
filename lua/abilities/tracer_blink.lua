if tracer_blink == nil then tracer_blink = class({}) end

function tracer_blink:GetBehavior() 
	local behav = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	return behav
end

function tracer_blink:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end


function tracer_blink:OnSpellStart()
	local hCaster = self:GetCaster() --We will always have Caster.
	local vPoint = self:GetCursorPosition() --We will always have Vector for the point.
	local vOrigin = hCaster:GetAbsOrigin() --Our caster's location
	local nMaxBlink = self:GetSpecialValueFor( "blink_range" ) --How far can we actually blink?
	local nClamp = self:GetSpecialValueFor( "blink_range" ) --How far can we actually blink?
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	if vPoint then
		self:Blink(hCaster, vPoint, nMaxBlink, nClamp) --BLINK!
	end	
end


function tracer_blink:Blink(hTarget, vPoint, nMaxBlink, nClamp)
	local vOrigin = hTarget:GetAbsOrigin() --Our units's location
	ProjectileManager:ProjectileDodge(hTarget)  --We disjoint disjointable incoming projectiles.
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hTarget) --Create particle effect at our caster.
	hTarget:EmitSound("Hero_Tinker.Laser") --Emit sound for the blink
	local vDiff = vPoint - vOrigin --Difference between the points
	if vDiff:Length2D() > nMaxBlink then  --Check caster is over reaching.
		vPoint = vOrigin + (vPoint - vOrigin):Normalized() * nClamp -- Recalculation of the target point.
	end
	hTarget:SetAbsOrigin(vPoint) --We move the caster instantly to the location
	FindClearSpaceForUnit(hTarget, vPoint, false) --This makes sure our caster does not get stuck
	EmitSoundOn("Hero_Tinker.LaserImpact", hTarget)
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, hTarget) --Create particle effect at our caster.
end
function tracer_blink:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

