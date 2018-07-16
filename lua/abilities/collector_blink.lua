if collector_blink == nil then collector_blink = class({}) end

function collector_blink:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

function collector_blink:IsStealable()
    return false
  end
  

function collector_blink:OnSpellStart()
    if IsServer() then 
        local hCaster = self:GetCaster() --We will always have Caster.
        local vPoint = self:GetCursorPosition() --We will always have Vector for the point.
        local vOrigin = hCaster:GetAbsOrigin() --Our caster's location
        local nMaxBlink = self:GetOrbSpecialValueFor( "blink_range", "w" ) --How far can we actually blink?
        local nClamp = self:GetSpecialValueFor( "min_blink_range" ) --How far can we actually blink?
        if vPoint then
            self:Blink(hCaster, vPoint, nMaxBlink, nClamp) --BLINK!
        end	
    end
end


function collector_blink:Blink(hTarget, vPoint, nMaxBlink, nClamp)
	local vOrigin = hTarget:GetAbsOrigin()
	ProjectileManager:ProjectileDodge(hTarget)  
    ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", PATTACH_ABSORIGIN, hTarget) 
    
    EmitSoundOn("Hero_Antimage.Blink_out", hTarget)

    local vDiff = vPoint - vOrigin
	if vDiff:Length2D() > nMaxBlink then 
		vPoint = vOrigin + (vPoint - vOrigin):Normalized() * nClamp
    end
    
	hTarget:SetAbsOrigin(vPoint)
    FindClearSpaceForUnit(hTarget, vPoint, false) 
    
	EmitSoundOn("Hero_Antimage.Blink_in", hTarget)
	ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf", PATTACH_ABSORIGIN, hTarget) 
end
