vader_force_blast = class({})

function vader_force_blast:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = 250,
		fEndRadius = 300,
		vVelocity = vDirection * 1000,
		fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = 250,
	}

	self.nProjID = ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_Invoker.DeafeningBlast.Immortal" , self:GetCaster() )
	self.counter = 0
end

function vader_force_blast:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		self.counter = self.counter + 1
		if self.counter == 3 then
			if self:GetCaster():HasModifier("modifier_vader") then
                local mod = self:GetCaster():FindModifierByName("modifier_vader")
                mod:SetStackCount(mod:GetStackCount() + 1)
            end
			self.counter = 0
		end
		if self:GetCaster():HasModifier("modifier_vader") then
            local mod = self:GetCaster():FindModifierByName("modifier_vader")
            self.damage = mod:GetStackCount()*5
        else
            self.damage = 0
        end
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage() + self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}

		ApplyDamage( damage )

		local point = self:GetCaster():GetAbsOrigin()
		local knockbackProperties =
	    {
	        center_x = point.x,
	        center_y = point.y,
	        center_z = point.z,
	        duration = self:GetSpecialValueFor("stun_duration"),
	        knockback_duration = self:GetSpecialValueFor("stun_duration"),
	        knockback_distance = 600,
	        knockback_height = 0
	    }

        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
		EmitSoundOn( "Hero_Invoker.SunStrike.Ignite.Apex" , hTarget )
	end

	return false
end

function vader_force_blast:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

