-- первый ульт (руки вместе и бдыщь)

genos_spiral_incineration = class ({})

local PTC_LOW = 30

function genos_spiral_incineration:OnSpellStart()
    if IsServer() then
        local speed = self:GetSpecialValueFor( "dragon_slave_speed" )
        local width_initial = self:GetSpecialValueFor( "dragon_slave_width_initial" )
        local width_end = self:GetSpecialValueFor( "dragon_slave_width_end" )
        local distance = self:GetSpecialValueFor( "dragon_slave_distance" )
        local damage = self:GetSpecialValueFor( "dragon_slave_damage" ) 
    
        EmitSoundOn( "Hero_Lina.DragonSlave.Cast", self:GetCaster() )
    
        local vPos = nil
        if self:GetCursorTarget() then
            vPos = self:GetCursorTarget():GetOrigin()
        else
            vPos = self:GetCursorPosition()
        end
    
        local vDirection = vPos - self:GetCaster():GetOrigin()
        vDirection.z = 0.0
        vDirection = vDirection:Normalized()
    
        speed = speed * ( distance / ( distance - width_initial ) )
    
        local info = {
            EffectName = "particles/genos/genos_flame.vpcf",
            Ability = self,
            vSpawnOrigin = self:GetCaster():GetOrigin(), 
            fStartRadius = width_initial,
            fEndRadius = width_end,
            vVelocity = vDirection * speed,
            fDistance = distance,
            Source = self:GetCaster(),
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        }
    
        ProjectileManager:CreateLinearProjectile( info )

        EmitSoundOn( "Hero_Lina.DragonSlave", self:GetCaster() )
    end
end

--------------------------------------------------------------------------------

function genos_spiral_incineration:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetSpecialValueFor("dragon_slave_damage") + (hTarget:GetHealth() * (PTC_LOW / 100)),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )

		local vDirection = vLocation - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
		ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_huskar_burning_spear_debuff", {duration = self:GetSpecialValueFor("debuff_duration")})
	end

	return false
end