ancient_lich_ice_skull = class({})

ancient_lich_ice_skull.m_iCount = 1

function ancient_lich_ice_skull:OnSpellStart()
    if IsServer() then
        local vision_radius = self:GetSpecialValueFor( "vision_radius" )
        local bolt_speed = self:GetSpecialValueFor( "bolt_speed" )
    end
end

--------------------------------------------------------------------------------

function ancient_lich_ice_skull:OnProjectileHit( hTarget, vLocation )
    if IsServer() then
        if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then
            EmitSoundOn( "Hero_Lich.ChainFrostImpact.Hero", hTarget )
            
            local duration = self:GetSpecialValueFor( "stun_duration" )
            local damage = self:GetSpecialValueFor( "damage" ) 

            local damage = {
                victim = hTarget,
                attacker = self:GetCaster(),
                damage = damage * self.m_iCount,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self
            }

            ApplyDamage( damage )
            
            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )
            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_item_skadi_slow",  { duration = self:GetSpecialValueFor("slow_duration") } )

            if self.m_iCount < self:GetSpecialValueFor( "bounce_count" ) then
                self.m_iCount = self.m_iCount + 1
                
                self:FindNewTarget()
            end
        end
    end
    
    return true
end

function ancient_lich_ice_skull:FindNewTarget(hTarget)
    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), self:GetCaster(), self:GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
	if #units > 0 then
		self:CreateProjectile(units[1])
	end
end

function ancient_lich_ice_skull:CreateProjectile(target)
    local info = {
        EffectName = "particles/econ/items/lich/lich_ti8_immortal_arms/lich_ti8_chain_frost.vpcf",
        Ability = self,
        iMoveSpeed = 1000,
        Source = self:GetCaster(),
        Target = target,
        bDodgeable = true,
        bProvidesVision = false,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
    }

    ProjectileManager:CreateTrackingProjectile( info )
    EmitSoundOn( "Hero_Lich.ChainFrost", self:GetCaster() )
end

function ancient_lich_ice_skull:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 