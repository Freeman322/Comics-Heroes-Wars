tribunal_blink = class({})

function tribunal_blink:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

function tribunal_blink:OnSpellStart()
	local hCaster = self:GetCaster() 
	ProjectileManager:ProjectileDodge(hCaster)
	local vPoint = self:GetCursorPosition() 
	local vOrigin = hCaster:GetAbsOrigin() 
	local nMaxBlink = self:GetSpecialValueFor( "blink_range" ) 
	local nClamp = self:GetSpecialValueFor( "blink_range" ) 
	if vPoint then
		self:Blink(hCaster, vPoint, nMaxBlink, nClamp) 
	end	
end

function tribunal_blink:Blink(hTarget, vPoint, nMaxBlink, nClamp)
	local vOrigin = hTarget:GetAbsOrigin() 
	ProjectileManager:ProjectileDodge(hTarget)  
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hTarget) 
	hTarget:EmitSound("DOTA_Item.BlinkDagger.Activate") 
	local vDiff = vPoint - vOrigin 
	if vDiff:Length2D() > nMaxBlink then 
		vPoint = vOrigin + (vPoint - vOrigin):Normalized() * nClamp 
	end
	hTarget:SetAbsOrigin(vPoint) 
	FindClearSpaceForUnit(hTarget, vPoint, false) 
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, hTarget)

end

function tribunal_blink:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 