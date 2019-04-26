if raiden_lightning_transfer == nil then raiden_lightning_transfer = class({}) end

function raiden_lightning_transfer:GetBehavior() 
	local behav = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	return behav
end

function raiden_lightning_transfer:GetCooldown( nLevel ) return self.BaseClass.GetCooldown( self, nLevel ) end

function raiden_lightning_transfer:OnSpellStart()
    if IsServer() then 
        local hCaster = self:GetCaster() --We will always have Caster.
        local vPoint = self:GetCursorPosition() --We will always have Vector for the point.
        local vOrigin = hCaster:GetAbsOrigin() --Our caster's location
        local nMaxBlink = self:GetSpecialValueFor( "blink_range" ) --How far can we actually blink?
        local nClamp = self:GetSpecialValueFor( "blink_range" ) --How far can we actually blink?
        if vPoint then
            self:Blink(hCaster, vPoint, nMaxBlink, nClamp) --BLINK!
        end	
    end
end

function raiden_lightning_transfer:Blink(hTarget, vPoint, nMaxBlink, nClamp)
	local vOrigin = hTarget:GetAbsOrigin() 
    ProjectileManager:ProjectileDodge(hTarget) 
    
    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_compression.vpcf", PATTACH_CUSTOMORIGIN, nil );
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
    ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin());
    ParticleManager:ReleaseParticleIndex( nFXIndex );

    EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", self:GetCaster())
    
    local vDiff = vPoint - vOrigin 
	if vDiff:Length2D() > nMaxBlink then  
		vPoint = vOrigin + (vPoint - vOrigin):Normalized() * nClamp 
	end
    
    hTarget:SetAbsOrigin(vPoint) 

	FindClearSpaceForUnit(hTarget, vPoint, false) 
    
	local units = FindUnitsInRadius(hTarget:GetTeamNumber(), vPoint, nil, self:GetSpecialValueFor("damage_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
    for i,unit in ipairs(units) do
        ApplyDamage({victim = unit, attacker = hTarget, ability = self, damage = self:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS})
    end

    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_compression.vpcf", PATTACH_CUSTOMORIGIN, nil );
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
    ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin());
    ParticleManager:ReleaseParticleIndex( nFXIndex );

    EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", self:GetCaster())
end


